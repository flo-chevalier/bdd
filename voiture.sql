create table voiture
(
    id                   serial primary key,
    date_immatriculation date not null,
    numero_type          varchar(10) not null ,
    nom_modele           varchar(50) not null ,
    classe               varchar(50) not null ,
    couleur              varchar(20) not null ,
    marque               varchar(50) not null ,
    puissance            integer not null ,
    pays_fabrication     varchar(50) not null
);


create table appartient
(
    numero_conducteur varchar(10) not null ,
    nom_conducteur varchar(50) not null ,
    adresse varchar(50) not null ,
    voiture_id integer not null references voiture(id),
    date_achat date not null,
    immatriculation varchar(7) not null,
    nom_prefecture varchar(20) not null,
    lieu_prefecture varchar(20) not null,
    primary key (date_achat, immatriculation)
);


-- table voiture
insert into voiture(date_immatriculation, numero_type, nom_modele, classe, couleur, marque, puissance, pays_fabrication)
values(to_date('12/02/2009', 'dd/mm/yyyy'), 'MO1', 'Clio', 'berline', 'rouge', 'Renault', 5, 'France');

insert into voiture(date_immatriculation, numero_type, nom_modele, classe, couleur, marque, puissance, pays_fabrication)
values(to_date('01/03/2009', 'dd/mm/yyyy'), 'MO1', 'Clio', 'berline', 'noir', 'Renault', 5, 'Espagne');

insert into voiture(date_immatriculation, numero_type, nom_modele, classe, couleur, marque, puissance, pays_fabrication)
values(to_date('01/02/2019', 'dd/mm/yyyy'), 'MO2', '308', 'berline', 'vert', 'Peugeot', 4, 'France');

-- table appartient
insert into appartient(numero_conducteur, nom_conducteur, adresse, voiture_id, date_achat, immatriculation, nom_prefecture, lieu_prefecture)
values('CO1', 'Lagaffe', 'Epinal', 1, to_date('12/02/2009', 'dd/mm/yyyy'), '123AB88', 'Vosges', 'Epinal');

insert into appartient(numero_conducteur, nom_conducteur, adresse, voiture_id, date_achat, immatriculation, nom_prefecture, lieu_prefecture)
values('CO2', 'Talon', 'La Bresse', 2, to_date('01/03/2009', 'dd/mm/yyyy'), '456AD88', 'Vosges', 'Epinal');

insert into appartient(numero_conducteur, nom_conducteur, adresse, voiture_id, date_achat, immatriculation, nom_prefecture, lieu_prefecture)
values('CO3', 'Lefranc', 'Metz', 3, to_date('01/02/2019', 'dd/mm/yyyy'), 'FD777EF', 'Moselle', 'Metz');

insert into appartient(numero_conducteur, nom_conducteur, adresse, voiture_id, date_achat, immatriculation, nom_prefecture, lieu_prefecture)
values('CO2', 'Talon', 'La Bresse', 1, to_date('06/04/2020', 'dd/mm/yyyy'), 'FP649BP', 'Vosges', 'Epinal');


/*** migration 1 **/

create table modele
(
    id        serial primary key,
    reference varchar(10) not null,
    nom       varchar(50) not null,
    classe    varchar(50) not null,
    marque    varchar(50) not null,
    puissance integer     not null
);

insert into modele(reference, nom, classe, marque, puissance)
select distinct v.numero_type, v.nom_modele, v.classe, v.marque, v.puissance
from voiture v;

alter table voiture add column modele_id integer references modele(id);

update voiture v
set modele_id = (select id from modele m where v.numero_type = m.reference);

alter table voiture alter column modele_id set not null;

alter table voiture
    drop column numero_type,
    drop column nom_modele,
    drop column classe,
    drop column marque,
    drop column puissance;


/** migration 2 **/
--- 1. table conducteur
create table conducteur
(
    id        serial primary key,
    reference varchar(10) not null,
    nom       varchar(50) not null,
    adresse   varchar(50) not null
);


insert into conducteur(reference, nom, adresse)
select distinct a.numero_conducteur, a.nom_conducteur, a.adresse
from appartient a;

alter table appartient add column conducteur_id int references conducteur(id);

update appartient a
set conducteur_id = (select id from conducteur c where c.reference = a.numero_conducteur);


alter table appartient drop column numero_conducteur, drop column nom_conducteur, drop column adresse;

alter table appartient alter column conducteur_id set not null;

--- 2. table département
create table departement
(
    id              serial primary key,
    nom_prefecture  varchar(20) not null,
    lieu_prefecture varchar(20) not null
);

insert into departement(nom_prefecture, lieu_prefecture)
select distinct a.nom_prefecture, a.lieu_prefecture
from appartient a;


alter table appartient add column departement_id int references departement(id);

update appartient a
set departement_id = (select id from departement d where d.nom_prefecture = a.nom_prefecture);

alter table appartient drop column nom_prefecture, drop column lieu_prefecture;

--- 3. table immatriculation
create table immatriculation
(
    id             serial primary key,
    numero         varchar(7) not null,
    departement_id int not null references departement(id),
    vehicule_id    int not null references voiture(id)
);

insert into immatriculation(numero, departement_id, vehicule_id)
select distinct a.immatriculation, a.departement_id, a.voiture_id
from appartient a;

alter table appartient add column immatriculation_id int references immatriculation(id);

update appartient a
set immatriculation_id = (select id from immatriculation i where i.numero = a.immatriculation);

alter table appartient drop column voiture_id, drop column immatriculation, drop column departement_id;

alter table appartient alter column immatriculation_id set not null;