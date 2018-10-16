-- write your COPY statement to import a csv here
COPY game (index, title, esrb, aggregate_rating) 
    FROM 'D:\Documents\NYU\Data Analysis\tsekenrick-homework04\igdb_ps4_ratings.csv'
    csv HEADER DELIMITER ',';