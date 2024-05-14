create table batiment
(
    id  serial primary key,
    nom VARCHAR(50) not null
);

create table formation
(
    id          serial primary key,
    libelle     VARCHAR(50) not null,
    batiment_id INT         not null references batiment (id)
);

create table etudiant
(
    id           serial primary key,
    nom          VARCHAR(50) not null,
    prenom       VARCHAR(50) not null,
    formation_id INT         not null references formation (id)
);


insert into batiment(nom)
values ('batiment info');
insert into batiment(nom)
values ('batiment lettres');
insert into batiment(nom)
values ('batiment mecanique');


select *
from batiment;

insert into formation(libelle, batiment_id) values ('SQL', 1);
insert into formation(libelle, batiment_id) values ('Java', 1);

insert into formation(libelle, batiment_id) values ('classiques', 2);
insert into formation(libelle, batiment_id) values ('modernes', 2);

insert into formation(libelle, batiment_id) values ('newtonnienne', 3);
insert into formation(libelle, batiment_id) values ('quantique', 3);


insert into etudiant (nom, prenom, formation_id)
select 'dylan ' || i, 'bob ' || i, 1
from generate_series(1, 5) as i;

insert into etudiant (nom, prenom, formation_id)
select 'le nain ' || i, 'gimli ' || i, 2
from generate_series(1, 5) as i;

insert into etudiant (nom, prenom, formation_id)
select 'le gris ' || i, 'gandalf ' || i, 3
from generate_series(1, 5) as i;

insert into etudiant (nom, prenom, formation_id)
select 'bessac ' || i, 'frodo ' || i, 4
from generate_series(1, 5) as i;

insert into etudiant (nom, prenom, formation_id)
select 'verlaine ' || i, 'paul ' || i, 5
from generate_series(1, 5) as i;


-- requete 1
select f.libelle, b.nom
from formation f
         join batiment b on f.batiment_id = b.id;

-- requete 2
select *
from etudiant e
         join formation f on e.formation_id = f.id
where f.batiment_id = 1;


-- requete 3
select f.libelle, e.prenom, e.nom
from formation f
         left join etudiant e on e.formation_id = f.id and f.libelle = 'SQL'
;


select f.libelle, e.prenom, e.nom
from etudiant e
         right join formation f on e.formation_id = f.id and f.libelle = 'SQL'
;
