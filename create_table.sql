-- write your table creation sql here!
DROP TABLE IF EXISTS game;

CREATE TABLE game (
    index integer,
    title varchar(255) PRIMARY KEY,
    esrb integer,
    aggregate_rating numeric
);
