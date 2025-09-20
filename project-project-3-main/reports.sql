-- Report 1: Tree Planting Success Rate by Neighborhood and Species
-- Calculates the success rate of tree planting (total requests/completed requests) for each neighborhood and species.
SELECT n.neighborhood_id AS Neighborhood, ts.commonName AS TreeSpecies,
    COUNT(r.address) AS TotalRequests,
    SUM(r.status = 'Completed') AS CompletedRequests,
    (SUM(r.status = 'Completed') / COUNT(r.address)) * 100 AS SuccessRate
FROM Neighborhood n
    INNER JOIN JobSite js ON n.neighborhood_id = js.neighborhood_id
    LEFT JOIN requests r ON js.jobsite_address = r.address
    LEFT JOIN TreeSpecies ts ON js.tree_name = ts.scientificName
GROUP BY n.neighborhood_id, ts.commonName
ORDER BY n.neighborhood_id, ts.commonName;

-- Report 2: Volunteer Impact
-- Analyzes volunteer participation and their impact on tree planting by finding the number of sites volunteered at, the number of trees planted by the volunteer, and the species planted.
SELECT u.user_id AS VolunteerID, u.firstName AS FirstName, u.lastName AS LastName,
    COUNT(DISTINCT js.jobsite_address) AS SitesVolunteered,
    COUNT(js.tree_name) AS TreesPlanted,
    (SELECT GROUP_CONCAT(DISTINCT ts2.commonName ORDER BY ts2.commonName)
        FROM JobSite js2
            INNER JOIN volunteer v2 ON js2.jobsite_address = v2.jobsite_address
            LEFT JOIN TreeSpecies ts2 ON js2.tree_name = ts2.scientificName
        WHERE v2.user_id = u.user_id
    ) AS SpeciesVolunteered
FROM User u
    INNER JOIN volunteer v ON u.user_id = v.user_id
    INNER JOIN JobSite js ON v.jobsite_address = js.jobsite_address
    LEFT JOIN TreeSpecies ts ON js.tree_name = ts.scientificName
GROUP BY u.user_id, u.firstName, u.lastName
ORDER BY TreesPlanted DESC;

-- Report 3: Time Between Request to Planting
-- Calculates the average time it takes from a tree planting request to the actual planting for each neighborhood. Helps in identifying neighborhoods where there may be delays or bottlenecks in the planting process.
SELECT n.neighborhood_id AS Neighborhood,
    AVG(DATEDIFF(js.date_of_job, r.date_requested)) AS AverageTimeToPlant
FROM Neighborhood n
    INNER JOIN JobSite js ON n.neighborhood_id = js.neighborhood_id
    INNER JOIN requests r ON js.jobsite_address = r.address
WHERE r.status = 'Completed'
GROUP BY n.neighborhood_id
ORDER BY AverageTimeToPlant;

-- Report 4:  Time Between Visit to Planting
-- Evaluates the effectiveness of site visits by finding the average difference in days between the scheduled date of a site visit and the actual date of the scheduled tree planting at that job site which tell how well scheduled the site visits are.
SELECT n.neighborhood_id AS Neighborhood,
    COUNT(DISTINCT js.jobsite_address) AS Trees,
    AVG(DATEDIFF(js.date_of_job, v.scheduledDate)) AS AverageTimeToPlant
FROM Neighborhood n
    INNER JOIN JobSite js ON n.neighborhood_id = js.neighborhood_id
    INNER JOIN visits v ON js.jobsite_address = v.jobsite_address
GROUP BY n.neighborhood_id
ORDER BY AverageTimeToPlant;

-- Report 5: Neighborhood Tree Diversity
-- Identifying the diversity of tree species in each neighborhood and ranking them based on the number of different tree species planted.
SELECT n.neighborhood_id AS Neighborhood,
    COUNT(DISTINCT ts.scientificName) AS UniqueSpeciesCount,
    (SELECT GROUP_CONCAT(DISTINCT ts2.commonName ORDER BY ts2.commonName)
        FROM JobSite js2
            INNER JOIN Neighborhood n2 ON js2.neighborhood_id = n2.neighborhood_id
            LEFT JOIN TreeSpecies ts2 ON js2.tree_name = ts2.scientificName
        WHERE n2.neighborhood_id = n.neighborhood_id
    ) AS TreeSpecies
FROM Neighborhood n
    INNER JOIN JobSite js ON n.neighborhood_id = js.neighborhood_id
    LEFT JOIN TreeSpecies ts ON js.tree_name = ts.scientificName
GROUP BY n.neighborhood_id
ORDER BY UniqueSpeciesCount DESC;
