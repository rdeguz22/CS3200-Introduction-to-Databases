SELECT d.first_name || ' ' || d.last_name AS DIRECTOR,
       COUNT(director_id) AS MOVIES,
       MIN(rank) AS MIN_RANK,
       AVG(rank) AS AVG_RANK,
       MAX(rank) AS MAX_RANK
    FROM DIRECTORS AS d
        INNER JOIN movies_directors AS md ON d.id = md.director_id
        INNER JOIN movies AS m ON md.movie_id = m.id
    WHERE rank IS NOT NULL
    GROUP BY d.first_name, d.last_name
    HAVING 2 <= COUNT(director_id) AND 7 <= MIN(rank)