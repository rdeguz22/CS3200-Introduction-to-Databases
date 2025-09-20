
-- a. Register a new user (volunteers or residents requesting a tree)
INSERT INTO User (user_id, firstName, lastName, email, neighborhood, zipCode) VALUES
(4, 'Tyler', 'Smith', 'smith.t@example.com', 'midtown', '10004');

-- b. Accept a request for a tree, registering as a new user if necessary. When requesting a tree, users will need to specify their address as the tree will be planted on the portion of the street facing their property

UPDATE requests
SET status = 'Approved'
WHERE user_id = 1 AND address ='123 Main St';

-- c. Schedule a visit to a site requesting a tree

INSERT INTO visits(scheduledDate, conductedDate, photoURL, employee_id, jobsite_address) VALUES
('2025-03-25', NULL, NULL, 103, '789 Pine Ave')

-- d. On or after a site visit, record the information gathered by the team including references to photos for the team to review later

UPDATE visits
SET conductedDate = '2025-04-01' AND photoURL = 'http://example.com/photo3.jpg'''
WHERE employee_id = 103 AND jobsite_address = '789 Pine Ave';

-- e. Schedule the planting of a tree, includes booking the team of volunteers who will do the planting
-- To schedule a date
UPDATE JobSite
SET date_of_job = '2025-12-5'
WHERE jobsite_address ='789 Pine Ave';

-- input what workers volunteer
INSERT INTO volunteer (user_id, jobsite_address) VALUES
(3, '123 Main St');

-- f. After a tree is planted, record volunteers who participated, observations of the tree planting, and references to before/after photos of the site.
-- to find volunteers who participate in a specific tree planting
SELECT u.user_id, CONCAT(u.firstName, ' ', u.lastName) AS name
FROM User u INNER JOIN volunteer v ON u.user_id = v.user_id
WHERE v.jobsite_address = '123 Main St';
-- to add observations and photos
UPDATE JobSite
SET completed_data = 'the planting went smoothly' AND after_photos_URL = 'http://example.com/photo15.jpg'
WHERE jobsite_address = '456 Elm St';
-- to find before and after photos use
SELECT v.photoURL, jb.after_photos_URL
FROM JobSite jb INNER JOIN visits v ON jb.jobsite_address = v.jobsite_address
WHERE v.jobsite_address = '456 Elm St';

-- g. Update the collection of tree species available for planting: removal or addition of species
-- removal:
DELETE FROM TreeSpecies
WHERE scientificName = 'Sugar Maple';
-- addition:
INSERT INTO TreeSpecies(treeSpecies_name, minimumBasinWidth, commonName, scientificName, heightRange, acceptableUnderPowerLine, droughtTolerance, foliage, rootDamagePotential, numberPlanted, yearsSinceFirstTree, yearsSinceMostRecent, yearWithMostPlanted) VALUES
('Birch', 2.5, 'River Birch', 'Betula nigra', '40-70 ft', TRUE, 'Medium', 'Deciduous', 'Low', 120, 35, 5, 2010);

-- h. For all requests to plant a tree that have not yet completed, show its status, and the number of days that has transpired since it was first submitted
SELECT
    r.status,
    DATEDIFF(CURDATE(), r.date_requested) AS daysSinceSubmitted
FROM
    requests r
WHERE
    r.status != 'Completed' OR 'Finalized';

-- i. Find all trees planted within a selection of Oakland neighborhoods or zip codes specified by a user in the app.
-- If user specifies zipcode:
SELECT ts.commonName, COUNT(jb.tree_name) AS tree_count
FROM JobSite jb INNER JOIN tree.TreeSpecies ts ON jb.tree_name = ts.scientificName
WHERE jb.zipCode = '10001'
GROUP BY ts.commonName;
-- If user specifies neighborhoods:
SELECT ts.commonName, COUNT(jb.tree_name) AS tree_count
FROM JobSite jb INNER JOIN tree.TreeSpecies ts ON jb.tree_name = ts.scientificName
WHERE jb.neighborhood = 'Downtown'
GROUP BY ts.commonName;

-- j. For every species of trees, find the number of trees planted and some basic statistics on when trees were planted: the number of years since the first tree of the species was planted, the number of years since the most recent tree of the species was planted. In addition, include the year that had the most trees of the species planted and the number of trees planted.
SELECT
ts.commonName AS TreeSpecies,
SUM(ts.numberPlanted) AS TotalTreesPlanted,
MAX(YEAR(CURDATE()) - ts.yearsSinceFirstTree) AS YearsSinceFirstPlanted,
MAX(YEAR(CURDATE()) - ts.yearsSinceMostRecent) AS YearsSinceMostRecentPlanted,
ts.yearWithMostPlanted AS YearWithMostPlanted,
ts.numberPlanted AS MostPlantedYearCount
FROM
TreeSpecies ts
GROUP BY
ts.scientificName
ORDER BY
TotalTreesPlanted DESC;


-- k. For each Oakland neighborhood, create a report that summarizes the requests, their progress (pending, in-process, completed, ec), the trees planted, etc. This is an opportunity for your team to demonstrate your skills, so it's expected that you'll demonstrate sophisticated database querying skills.
SELECT
    n.name AS Neighborhood,
    COUNT(r.address) AS TotalRequests,
    SUM(CASE WHEN r.status = 'Pending' THEN 1 ELSE 0 END) AS PendingRequests,
    SUM(CASE WHEN r.status = 'In-Process' THEN 1 ELSE 0 END) AS InProcessRequests,
    SUM(CASE WHEN r.status = 'Completed' THEN 1 ELSE 0 END) AS CompletedRequests,
    SUM(CASE WHEN r.status = 'Approved' THEN 1 ELSE 0 END) AS ApprovedRequests,
    SUM(ts.numberPlanted) AS TotalTreesPlanted,
    GROUP_CONCAT(DISTINCT ts.commonName) AS TreesPlanted
FROM
    Neighborhood n
INNER JOIN JobSite js ON n.name = js.neighborhood
LEFT JOIN requests r ON js.jobsite_address = r.address
LEFT JOIN TreeSpecies ts ON js.tree_name = ts.scientificName
GROUP BY
    n.name
ORDER BY
    n.name;