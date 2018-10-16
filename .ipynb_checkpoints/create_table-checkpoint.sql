-- write your table creation sql here!
DROP TABLE IF EXISTS game;

CREATE TABLE game (
    title varchar(255) PRIMARY KEY,
    esrb integer,
    aggregate_rating numeric
);
