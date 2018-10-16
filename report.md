# Overview
The data that will be used for this assignment comes from the Internet Game Database (IGDB). IGDB contains information from a wide variety of sources. This is because the database contains information about games spanning from the advent of video games (think arcade titles like Pong and Pac-Man) to the present day. 

As a result, the types of information available for games of different eras can be widely disparate, and the places you could obtain pertinent information would also be similarly varied. Even within a title, you would need to look to different sources for data involving publication, versus data involving critical reception, or data involving speedrun times for applicable titles.

Due to the variability and expansiveness of the information available on IGDB, the scope of the data I used in HW3 was necessarily limited in scope, as there aren't many types of data that are available for all games in the database. So, the final, cleaned dataset contains entries only from titles published on the PlayStation 4, and for only 3 categories of data - the name of the game, its ESRB rating, and an aggregate rating based on a combination of user and critic reviews.

# Table Design
Because the data in the .csv from the previous homework was already pared down to eliminate any fields with incomplete or inconsistent data, the design of the table is very straightforward:

```sql
CREATE TABLE game (
    index integer,
    title varchar(255) PRIMARY KEY,
    esrb integer,
    aggregate_rating numeric
);
```

The index field is sort of a holdover from importing the DataFrame as a .csv, and really just represented the number of the row entry. Given that, the choice of representing as an `integer` is rather self explanatory. It has no real relation to any of the data. I considered using this as an artificial PK, but decided that since the game title should be unique to each entry, that would make for a more meaningful PK.

---

As noted in the overview, the title of the game is naturally just a `varchar` - I considered using `string` here, but I find it hard to believe that a game could have a title longer than 255 characters. I felt that the name of the game was suitable as a PK since it should be fairly safe to assume that it would be a field unique to each entry.

---

The ESRB rating is represented as an `integer` - in the .csv, the ESRB rating is a value between 1.0 and 7.0, but only ever the whole number values, and the decimal value is always zero. This is because there is a mapping from these numeric values to the ESRB ratings:

* 1.0 is Rating Pending (RP)
* 2.0 is Early Childhood (EC)
* 3.0 is Everyone (E)
* 4.0 is Everyone 10+ (E10+)
* 5.0 is Teen (T)
* 6.0 is Mature (M)
* 7.0 is Adult Only (AO)

So the choice to use `integer` was obvious.

---

Finally, the aggregate rating is represented as `numeric`, because the data allows for any value between 0 and 100 with arbitrary decimal precision.

# Import
My initial import statement was as follows:

```sql
COPY game (index, title, esrb, aggregate_rating) 
    FROM 'igdb_ps4_ratings.csv'
    csv HEADER DELIMITER ',';
```

However, this gave the following error:
`ERROR:  could not open file "igdb_ps4_ratings.csv" for reading: No such file or directory`

It appeared that even though I started psql from the directory of my repository (which contains the .csv file), it wasn't able to locate my file. This suggests that the working directory of psql might be irrespective of the working directory from which you launched it. Since I was unable to determine what directory psql was searching in, I just passed in the absolute path:

```sql
COPY game (index, title, esrb, aggregate_rating) 
    FROM 'D:\Documents\NYU\Data Analysis\tsekenrick-homework04\igdb_ps4_ratings.csv'
    csv HEADER DELIMITER ',';
```

This worked without error, reporting back:
`COPY 1275`, which is the correct number of entries.

# Database Information
```
homework04=# \l
                                          List of databases
    Name    |  Owner   | Encoding |       Collate       |        Ctype        |   Access privileges
------------+----------+----------+---------------------+---------------------+-----------------------
 homework04 | postgres | UTF8     | English_Canada.1252 | English_Canada.1252 |
 postgres   | postgres | UTF8     | English_Canada.1252 | English_Canada.1252 |
 template0  | postgres | UTF8     | English_Canada.1252 | English_Canada.1252 | =c/postgres          +
            |          |          |                     |                     | postgres=CTc/postgres
 template1  | postgres | UTF8     | English_Canada.1252 | English_Canada.1252 | =c/postgres          +
            |          |          |                     |                     | postgres=CTc/postgres
 test       | postgres | UTF8     | English_Canada.1252 | English_Canada.1252 |
(5 rows)


homework04=# \d
        List of relations
 Schema | Name | Type  |  Owner
--------+------+-------+----------
 public | game | table | postgres
(1 row)

homework04=# \d game
                            Table "public.game"
      Column      |          Type          | Collation | Nullable | Default
------------------+------------------------+-----------+----------+---------
 index            | integer                |           |          |
 title            | character varying(255) |           | not null |
 esrb             | integer                |           |          |
 aggregate_rating | numeric                |           |          |
Indexes:
    "game_pkey" PRIMARY KEY, btree (title)

```

# Query Results

### 1. the total number of rows in the database
```

count
-------
  1275
```

---

### 2. show the first 15 rows, but only display 3 columns (your choice)
```

               title                | esrb | aggregate_rating
------------------------------------+------+------------------
 Okami HD                           |    5 |      86.62726548
 forma.8                            |    4 |       77.9436892
 flOw                               |    3 |      74.69616645
 de Blob 2                          |    4 |      74.19318669
 de Blob                            |    3 |               76
 Zotrix                             |    3 |               42
 Zone of the Enders: The 2nd Runner |    6 |      70.64541861
 Zombie Vikings                     |    5 |      61.44318947
 Zombie Army Trilogy                |    6 |           80.625
 Zombi                              |    6 |      63.85962689
 Zombeer                            |    6 |            46.25
 Ziggurat                           |    5 |      75.54157938
 Zero Escape: Zero Time Dilemma     |    6 |      79.27423887
 Zenith                             |    6 |               55
 Zen Pinball 2                      |    4 |             73.5
```

---

### 3. do the same as above, but chose a column to sort on, and sort in descending order
```

                title                 | esrb | aggregate_rating
--------------------------------------+------+------------------
 God of War                           |    6 |      97.27472927
 Persona 5                            |    6 |      94.70811435
 The Witcher 3: Wild Hunt             |    6 |      94.28524673
 Grand Theft Auto V                   |    6 |       94.1771104
 Uncharted 2: Among Thieves           |    5 |      93.48623581
 Uncharted 4: A Thief's End           |    5 |      93.42068389
 Undertale                            |    3 |       92.8470095
 Grand Theft Auto: San Andreas        |    6 |       91.8415327
 Celeste                              |    4 |      91.69045487
 The Binding of Isaac: Rebirth        |    6 |      91.63519485
 Jamestown+                           |    4 |             91.5
 Horizon Zero Dawn                    |    5 |      91.37812555
 Grand Theft Auto: Vice City          |    6 |      91.31301832
 Metal Gear Solid V: The Phantom Pain |    6 |      91.27176105
 Shadow of the Colossus               |    5 |      91.22344579

```

---

### 4. add a new column without a default value
```

homework04=# ALTER TABLE game
homework04-#   ADD COLUMN esrb_string varchar(20);
ALTER TABLE

```

---

### 5. set the value of that new column
```

homework04=# UPDATE game SET esrb_string = esrb::varchar(20);
UPDATE 1275

homework04=# UPDATE game SET esrb_string =
homework04-#     CASE
homework04-#         WHEN esrb_string='1' THEN 'Rating Pending'
homework04-#         WHEN esrb_string='2' THEN 'Early Childhood'
homework04-#         WHEN esrb_string='3' THEN 'Everyone'
homework04-#         WHEN esrb_string='4' THEN 'Everyone 10+'
homework04-#         WHEN esrb_string='5' THEN 'Teen'
homework04-#         WHEN esrb_string='6' THEN 'Mature'
homework04-#         WHEN esrb_string='7' THEN 'Adult Only'
homework04-#         ELSE NULL
homework04-#     END;
UPDATE 1275

homework04=# --include a printout to illustrate what was done
homework04=# select title, esrb, esrb_string from game limit 15;
              title               | esrb | esrb_string
----------------------------------+------+--------------
 World of Tanks                   |    5 | Teen
 World of Final Fantasy           |    4 | Everyone 10+
 Wonder Boy: The Dragon's Trap    |    4 | Everyone 10+
 Wolfenstein: The New Order       |    6 | Mature
 Wolfenstein II: The New Colossus |    6 | Mature
 Woah Dave!                       |    3 | Everyone
 Wizard of Legend                 |    4 | Everyone 10+
 Windjammers                      |    3 | Everyone
 Wild Guns Reloaded               |    4 | Everyone 10+
 Wild Arms 3                      |    5 | Teen
 Wick                             |    6 | Mature
 White Night                      |    6 | Mature
 Whispering Willows               |    5 | Teen
 Wheels of Aurelia                |    5 | Teen
 What Remains of Edith Finch      |    5 | Teen

```

---

### 6. show only the unique (non duplicates) of a column of your choice
```

  esrb_string
----------------
 Adult Only
 Everyone
 Everyone 10+
 Teen
 Rating Pending
 Mature

```

---

### 7. group rows together by a column value (your choice) and use an aggregate function to calculate something about that group
```

  esrb_string   | titles_of_rating
----------------+------------------
 Adult Only     |                1
 Everyone       |              257
 Everyone 10+   |              277
 Teen           |              431
 Rating Pending |               21
 Mature         |              288

```

---

### 8. now, using the same grouping query or creating another one, find a way to filter the query results based on the values for the groups
```

 esrb_string  | titles_of_rating
--------------+------------------
 Everyone     |              257
 Everyone 10+ |              277
 Teen         |              431
 Mature       |              288

```

---

### 9. states the number of games of each esrb rating that have an aggregate rating greater than 70
```

  esrb_string   | titles_of_rating
----------------+------------------
 Adult Only     |                1
 Everyone       |              142
 Everyone 10+   |              171
 Teen           |              261
 Rating Pending |               11
 Mature         |              200

```

---

### 10. states the average aggregate rating for games from each of the esrb ratings
```

  esrb_string   |     rating_avg
----------------+---------------------
 Adult Only     | 84.3486983100000000
 Everyone       | 69.4846579210505837
 Everyone 10+   | 70.9824056755234657
 Teen           | 71.3902930509744780
 Rating Pending | 70.0681156476190476
 Mature         | 74.1431048986458333

```

---

### 11. add best_of_rating boolean as a new column that states whether the title has a better aggregate rating than the average for that esrb rating
```

              title               | aggregate_rating | best_of_rating
----------------------------------+------------------+----------------
 World of Tanks                   |      76.37854229 | t
 World of Final Fantasy           |      76.90846542 | t
 Wonder Boy: The Dragon's Trap    |      76.10686937 | t
 Wolfenstein: The New Order       |      80.17774922 | t
 Wolfenstein II: The New Colossus |      86.11448813 | t
 Woah Dave!                       |             79.5 | t
 Wizard of Legend                 |      71.33672054 | t
 Windjammers                      |      84.20708711 | t
 Wild Guns Reloaded               |           79.125 | t
 Wild Arms 3                      |      69.98117366 | f
 Wick                             |               83 | t
 White Night                      |      66.01022382 | f
 Whispering Willows               |      64.37686567 | f
 Wheels of Aurelia                |               55 | f
 What Remains of Edith Finch      |      88.23108213 | t
 Werewolves Within                |      63.33333333 | f
 Weeping Doll                     |               30 | f
 We Happy Few                     |      66.61685827 | f
 We Are Doomed                    |               60 | f
 Watch_Dogs                       |      78.48689289 | t
 
```

---

### 12. personal interest - looking at the performance of the "Warriors" series games - a hack and slash franchise that I played a lot growing up and has a lot of sentimental value for me (even though I know the games are trash)
```

 index |               title                | esrb | aggregate_rating | esrb_string  | best_of_rating
-------+------------------------------------+------+------------------+--------------+----------------
  1082 | Caveman Warriors                   |    4 |      50.33333333 | Everyone 10+ | f
   949 | Dynasty Warriors 9                 |    5 |          57.5625 | Teen         | f
  1196 | Arslan: the Warriors of Legend     |    5 |          58.4375 | Teen         | f
   382 | Samurai Warriors 4-II              |    5 |       68.5400361 | Teen         | f
   948 | Dynasty Warriors: Godseekers       |    5 |            68.75 | Teen         | f
   950 | Dynasty Warriors 8                 |    5 |      70.94185398 | Teen         | f
   536 | One Piece: Pirate Warriors 3       |    5 |      73.20575495 | Teen         | t
   381 | Samurai Warriors: Spirit of Sanada |    5 |             74.5 | Teen         | t
    57 | Warriors All-Stars                 |    5 |      76.16666667 | Teen         | t
   383 | Samurai Warriors 4                 |    5 |      77.76664411 | Teen         | t
    56 | Warriors Orochi 3 Ultimate         |    5 |          78.9375 | Teen         | t
   161 | The Warriors                       |    6 |      85.79115099 | Mature       | t
   
```