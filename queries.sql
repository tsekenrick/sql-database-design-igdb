-- write your queries underneath each number:
 
-- 1. the total number of rows in the database
SELECT count(*) FROM game;

-- 2. show the first 15 rows, but only display 3 columns (your choice)
SELECT title, esrb, aggregate_rating FROM game LIMIT 15;

-- 3. do the same as above, but chose a column to sort on, and sort in descending order
SELECT title, esrb, aggregate_rating FROM game ORDER BY aggregate_rating DESC LIMIT 15;

-- 4. add a new column without a default value
ALTER TABLE game 
  ADD COLUMN esrb_string varchar(20);

-- 5. set the value of that new column

--set esrb_string to be the string-cast version of esrb
UPDATE game SET esrb_string = esrb::varchar(20);

--set to the rating name based on value
UPDATE game SET esrb_string =
    CASE 
        WHEN esrb_string='1' THEN 'Rating Pending'
        WHEN esrb_string='2' THEN 'Early Childhood'
        WHEN esrb_string='3' THEN 'Everyone'
        WHEN esrb_string='4' THEN 'Everyone 10+'
        WHEN esrb_string='5' THEN 'Teen'
        WHEN esrb_string='6' THEN 'Mature'
        WHEN esrb_string='7' THEN 'Adult Only'
        ELSE NULL
    END;
    
-- 6. show only the unique (non duplicates) of a column of your choice
SELECT DISTINCT esrb_string FROM game;

-- 7.group rows together by a column value (your choice) and use an aggregate function to calculate something about that group 

--counts the number of titles of each esrb rating
SELECT esrb_string, count(esrb_string) AS titles_of_rating FROM game GROUP BY esrb_string;

-- 8. now, using the same grouping query or creating another one, find a way to filter the query results based on the values for the groups 

--only list the esrb ratings for which there are more than 50 titles
SELECT esrb_string, count(esrb_string) AS titles_of_rating FROM game GROUP BY esrb_string HAVING count(esrb_string) > 50;

-- 9. states the number of games of each esrb rating that have an aggregate rating greater than 70
SELECT esrb_string, count(esrb_string) AS titles_of_rating FROM game WHERE aggregate_rating > 70 GROUP BY esrb_string;

-- 10. states the average aggregate rating for games from each of the esrb ratings
SELECT esrb_string, AVG(aggregate_rating) AS rating_avg FROM game GROUP BY esrb_string;

    
-- 11. add best_of_rating boolean as a new column that states whether the title has a better aggregate rating than the average for that esrb rating
BEGIN;
ALTER TABLE game ADD COLUMN best_of_rating boolean;
UPDATE game SET best_of_rating =
    CASE
        WHEN esrb_string = 'Rating Pending' THEN aggregate_rating > 70
        WHEN esrb_string = 'Early Childhood' THEN aggregate_rating > 0
        WHEN esrb_string = 'Everyone' THEN aggregate_rating > 69
        WHEN esrb_string = 'Everyone 10+' THEN aggregate_rating > 71
        WHEN esrb_string = 'Teen' THEN aggregate_rating > 71
        WHEN esrb_string = 'Mature' THEN aggregate_rating > 74
        WHEN esrb_string = 'Adult Only' THEN aggregate_rating > 84
        ELSE NULL
    END;
    
COMMIT;

SELECT title, aggregate_rating, best_of_rating FROM game limit 20;

-- 12. personal interest - looking at the performance of the "Warriors" series games - a hack and slash franchise that I played a lot growing up and has a lot of sentimental value for me (even though I know the games are trash)
SELECT * from game where title ilike '%Warriors%' order by aggregate_rating;