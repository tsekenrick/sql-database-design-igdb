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

---

The index field is sort of a holdover from importing the DataFrame as a .csv, and really just represented the number of the row entry. Given that, the choice of representing as an `integer` is rather self explanatory. It has no real relation to any of the data, so this will probably get dropped once we import the data. I considered using this as an artificial PK, but decided that since the game title should be unique to each entry, that would make for a more meaningful PK.

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
```

# Query Results
