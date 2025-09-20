USE tree;

SET FOREIGN_KEY_CHECKS = 0;

-- Neighborhood
INSERT INTO Neighborhood (name) VALUES
('Downtown'), ('Sunset Park'), ('Bayview'),
('Mission'), ('SOMA'), ('Chinatown'),
('Nob Hill'), ('Tenderloin'), ('Castro'), ('Haight-Ashbury');

-- User
INSERT INTO User (user_id, firstName, lastName, email, neighborhood, zipCode, isVolunteer) VALUES
(1, 'Alice', 'Johnson', 'alice@example.com', 'Downtown', '94110', TRUE),
(2, 'Bob', 'Smith', 'bob@example.com', 'Sunset Park', '94112', FALSE),
(3, 'Carol', 'Lee', 'carol@example.com', 'Bayview', '94114', TRUE),
(4, 'Dan', 'Miller', 'dan@example.com', 'Mission', '94103', TRUE),
(5, 'Eva', 'Martinez', 'eva@example.com', 'SOMA', '94107', FALSE),
(6, 'Frank', 'Wong', 'frank@example.com', 'Chinatown', '94108', TRUE),
(7, 'Grace', 'Kim', 'grace@example.com', 'Nob Hill', '94109', TRUE),
(8, 'Hank', 'Lopez', 'hank@example.com', 'Tenderloin', '94102', FALSE),
(9, 'Ivy', 'Nguyen', 'ivy@example.com', 'Castro', '94114', TRUE),
(10, 'Jack', 'Brown', 'jack@example.com', 'Haight-Ashbury', '94117', FALSE);

-- Role
INSERT INTO Role (name) VALUES
('Arborist'), ('Supervisor'), ('Technician'),
('Planner'), ('Foreman'), ('Intern'),
('Consultant'), ('Analyst'), ('Inspector'), ('Manager');

-- TreeSpecies
INSERT INTO TreeSpecies (
    treeSpecies_name, minimumBasinWidth, commonName, scientificName, heightRange,
    acceptableUnderPowerLine, droughtTolerance, foliage, rootDamagePotential,
    numberPlanted, yearsSinceFirstTree, yearsSinceMostRecent, yearWithMostPlanted
) VALUES
('Maple', 3.0, 'Red Maple', 'Acer rubrum', '30-50ft', TRUE, 'Medium', 'Deciduous', 'Low', 100, 5, 1, 2023),
('Oak', 4.5, 'Valley Oak', 'Quercus lobata', '40-70ft', FALSE, 'High', 'Deciduous', 'High', 200, 10, 2, 2021),
('Pine', 2.5, 'Monterey Pine', 'Pinus radiata', '50-80ft', TRUE, 'Low', 'Evergreen', 'Medium', 150, 8, 1, 2022),
('Birch', 2.0, 'White Birch', 'Betula papyrifera', '20-40ft', TRUE, 'Low', 'Deciduous', 'Low', 90, 6, 2, 2023),
('Cedar', 3.5, 'Incense Cedar', 'Calocedrus decurrens', '40-70ft', FALSE, 'Medium', 'Evergreen', 'Medium', 80, 7, 2, 2020),
('Elm', 3.0, 'American Elm', 'Ulmus americana', '60-80ft', FALSE, 'High', 'Deciduous', 'High', 110, 9, 4, 2019),
('Fir', 2.8, 'Douglas Fir', 'Pseudotsuga menziesii', '40-80ft', FALSE, 'High', 'Evergreen', 'High', 120, 11, 3, 2018),
('Spruce', 2.7, 'Blue Spruce', 'Picea pungens', '30-60ft', TRUE, 'Medium', 'Evergreen', 'Low', 60, 4, 2, 2023),
('Willow', 3.2, 'Weeping Willow', 'Salix babylonica', '30-50ft', TRUE, 'Low', 'Deciduous', 'Medium', 140, 5, 1, 2022),
('Ash', 3.1, 'White Ash', 'Fraxinus americana', '40-70ft', FALSE, 'Medium', 'Deciduous', 'High', 170, 6, 2, 2021);

-- JobSite
INSERT INTO JobSite (
    jobsite_address, zipCode, name, neighborhood, description, user_id,
    neighborhood_id, tree_name, date_of_job, completed_date, completed_data, after_photos_URL
) VALUES
('123 Elm St', 94110, 'Elm Jobsite', 'Downtown', 'Replanting project', 1, 'Downtown', 'Acer rubrum', '2023-03-01', '2023-03-10', 'Healthy growth', 'http://example.com/elm.jpg'),
('456 Oak Ave', 94112, 'Oak Jobsite', 'Sunset Park', 'Storm recovery', 2, 'Sunset Park', 'Quercus lobata', '2023-04-15', '2023-04-20', 'Some damage', 'http://example.com/oak.jpg'),
('789 Pine Rd', 94114, 'Pine Jobsite', 'Bayview', 'New planting area', 3, 'Bayview', 'Pinus radiata', '2023-05-20', '2023-05-25', 'New saplings', 'http://example.com/pine.jpg'),
('111 Birch Blvd', 94103, 'Birch Site', 'Mission', 'Soil testing', 4, 'Mission', 'Betula papyrifera', '2023-01-10', '2023-01-12', 'Initial prep', 'http://example.com/birch.jpg'),
('222 Cedar Ln', 94107, 'Cedar Site', 'SOMA', 'Infrastructure conflict', 5, 'SOMA', 'Calocedrus decurrens', '2023-02-20', '2023-03-01', 'Route cleared', 'http://example.com/cedar.jpg'),
('333 Elm Ct', 94108, 'Elm Court', 'Chinatown', 'Tree removal', 6, 'Chinatown', 'Ulmus americana', '2023-03-15', '2023-03-17', 'Removed safely', 'http://example.com/elmcourt.jpg'),
('444 Fir Way', 94109, 'Fir Project', 'Nob Hill', 'Plant diversity test', 7, 'Nob Hill', 'Pseudotsuga menziesii', '2023-03-22', '2023-03-25', 'Growing well', 'http://example.com/fir.jpg'),
('555 Spruce St', 94102, 'Spruce Site', 'Tenderloin', 'Replacement trees', 8, 'Tenderloin', 'Picea pungens', '2023-04-01', '2023-04-07', 'Stable', 'http://example.com/spruce.jpg'),
('666 Willow Dr', 94114, 'Willow Grove', 'Castro', 'Powerline compliance', 9, 'Castro', 'Salix babylonica', '2023-04-10', '2023-04-13', 'Compliant', 'http://example.com/willow.jpg'),
('777 Ash Ave', 94117, 'Ash Project', 'Haight-Ashbury', 'Drought study', 10, 'Haight-Ashbury', 'Fraxinus americana', '2023-05-01', '2023-05-05', 'Dry weather resistant', 'http://example.com/ash.jpg');

-- Employee
INSERT INTO employee (employee_id, role, user, salary) VALUES
(101, 'Arborist', 1, 60000),
(102, 'Supervisor', 2, 70000),
(103, 'Technician', 3, 50000),
(104, 'Planner', 4, 55000),
(105, 'Foreman', 5, 72000),
(106, 'Intern', 6, 30000),
(107, 'Consultant', 7, 68000),
(108, 'Analyst', 8, 64000),
(109, 'Inspector', 9, 61000),
(110, 'Manager', 10, 75000);

-- Visits
INSERT INTO visits (scheduledDate, conductedDate, photoURL, employee_id, jobsite_address) VALUES
('2023-03-01', '2023-03-01', 'http://example.com/visit1.jpg', 101, '123 Elm St'),
('2023-04-10', '2023-04-15', 'http://example.com/visit2.jpg', 102, '456 Oak Ave'),
('2023-05-19', '2023-05-20', 'http://example.com/visit3.jpg', 103, '789 Pine Rd'),
('2023-01-09', '2023-01-10', 'http://example.com/visit4.jpg', 104, '111 Birch Blvd'),
('2023-02-18', '2023-02-20', 'http://example.com/visit5.jpg', 105, '222 Cedar Ln'),
('2023-03-14', '2023-03-15', 'http://example.com/visit6.jpg', 106, '333 Elm Ct'),
('2023-03-20', '2023-03-22', 'http://example.com/visit7.jpg', 107, '444 Fir Way'),
('2023-03-30', '2023-04-01', 'http://example.com/visit8.jpg', 108, '555 Spruce St'),
('2023-04-09', '2023-04-10', 'http://example.com/visit9.jpg', 109, '666 Willow Dr'),
('2023-04-29', '2023-05-01', 'http://example.com/visit10.jpg', 110, '777 Ash Ave');

-- Manages
INSERT INTO manages (employee_id, jobsite_address) VALUES
(101, '123 Elm St'),
(102, '456 Oak Ave'),
(103, '789 Pine Rd'),
(104, '111 Birch Blvd'),
(105, '222 Cedar Ln'),
(106, '333 Elm Ct'),
(107, '444 Fir Way'),
(108, '555 Spruce St'),
(109, '666 Willow Dr'),
(110, '777 Ash Ave');

-- Volunteer
INSERT INTO volunteer (user_id, jobsite_address) VALUES
(1, '123 Elm St'),
(3, '456 Oak Ave'),
(1, '789 Pine Rd'),
(4, '111 Birch Blvd'),
(6, '222 Cedar Ln'),
(7, '333 Elm Ct'),
(9, '444 Fir Way'),
(3, '555 Spruce St'),
(6, '666 Willow Dr'),
(1, '777 Ash Ave');

-- Status
INSERT INTO status (status) VALUES
('Pending'),
('Approved'),
('Completed'),
('In Progress'),
('Delayed'),
('Cancelled'),
('Scheduled'),
('On Hold'),
('Submitted'),
('Finalized');

-- Requests
INSERT INTO requests (payment, status, user_id, address, date_requested, tree_type) VALUES
(100, 'Pending', 1, '123 Elm St', '2023-02-15', 'Acer rubrum'),
(120, 'Approved', 2, '456 Oak Ave', '2023-03-10', 'Quercus lobata'),
(90, 'Completed', 3, '789 Pine Rd', '2023-04-05', 'Pinus radiata'),
(85, 'In Progress', 4, '111 Birch Blvd', '2023-01-01', 'Betula papyrifera'),
(110, 'Delayed', 5, '222 Cedar Ln', '2023-02-10', 'Calocedrus decurrens'),
(95, 'Cancelled', 6, '333 Elm Ct', '2023-03-01', 'Ulmus americana'),
(105, 'Scheduled', 7, '444 Fir Way', '2023-03-15', 'Pseudotsuga menziesii'),
(115, 'On Hold', 8, '555 Spruce St', '2023-03-25', 'Picea pungens'),
(125, 'Submitted', 9, '666 Willow Dr', '2023-04-01', 'Salix babylonica'),
(130, 'Finalized', 10, '777 Ash Ave', '2023-04-20', 'Fraxinus americana');
