SELECT
    '1990''s' AS decade,
    g.name AS genre,
    COUNT(m.id) AS movies
FROM genres AS g
LEFT JOIN movies_genres AS mg ON g.name = mg.genre
LEFT JOIN movies AS m
    ON mg.movie_id = m.id
        AND m.year_released >= 1990
    AND m.year_released <= 1999
GROUP BY g.name
UNION
SELECT
    '2000''s' AS decade,
    g.name AS genre,
    COUNT(m.id) AS movies
FROM genres AS g
LEFT JOIN movies_genres AS mg ON g.name = mg.genre
LEFT JOIN movies AS m
    ON mg.movie_id = m.id
        AND m.year_released >= 1990
    AND m.year_released <= 1999
GROUP BY g.name
ORDER BY decade, movies DESC, genre