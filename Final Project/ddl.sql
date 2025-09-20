-- Create the database
-- CREATE DATABASE tree;

-- Select the database to use


USE tree;

set foreign_key_checks = 0;

 DROP TABLE requests;
 DROP TABLE User;
 DROP TABLE Neighborhood;
 DROP TABLE JobSite;
 DROP TABLE employee;
 DROP TABLE manages;
 DROP TABLE TreeSpecies;
 DROP TABLE visits;
 DROP TABLE volunteer;
 DROP TABLE Role;
 DROP TABLE status;

-- Create User table
CREATE TABLE User (
                      user_id INT PRIMARY KEY UNIQUE,
                      firstName VARCHAR(255),
                      lastName VARCHAR(255),
                      email VARCHAR(255) UNIQUE,
                      neighborhood VARCHAR(255),
                      zipCode VARCHAR(255),
                      isVolunteer BOOLEAN
);

-- Create Neighborhood table with neighborhood_id as INT
CREATE TABLE Neighborhood (
                              name VARCHAR(255) PRIMARY KEY
);

-- Create JobSite table with a foreign key reference to Neighborhood
CREATE TABLE JobSite (
                         jobsite_address VARCHAR(255) PRIMARY KEY,
                         zipCode INT,
                         name VARCHAR(255),
                         neighborhood VARCHAR(255),
                         description VARCHAR(255),
                         user_id INT,
                         neighborhood_id VARCHAR(255),
                         tree_name VARCHAR(255),
                         date_of_job DATE,
                         completed_date DATE,
                         completed_data VarChar(255),
                         after_photos_URL VARCHAR(255),
                         FOREIGN KEY (user_id) REFERENCES User(user_id),
                         FOREIGN KEY (neighborhood_id) REFERENCES Neighborhood(name),
                         FOREIGN KEY (tree_name) REFERENCES TreeSpecies(scientificName)
);

-- Create TreeSpecies table
CREATE TABLE TreeSpecies (
                             treeSpecies_name VARCHAR(255),
                             minimumBasinWidth FLOAT,
                             commonName VARCHAR(255),
                             scientificName VARCHAR(255) PRIMARY KEY,
                             heightRange VARCHAR(255),
                             acceptableUnderPowerLine BOOLEAN,
                             droughtTolerance VARCHAR(255),
                             foliage TEXT,
                             rootDamagePotential VARCHAR(255),
                             numberPlanted INT,
                             yearsSinceFirstTree INT,
                             yearsSinceMostRecent INT,
                             yearWithMostPlanted INT
);

CREATE TABLE Role (
                          name VARCHAR(255) PRIMARY KEY
);

-- Create employee table
CREATE TABLE employee (
                          employee_id INT PRIMARY KEY,
                          role VARCHAR(255),
                          user INT UNIQUE,
                          salary INT,
                          FOREIGN KEY (user) REFERENCES User(user_id),
                          FOREIGN KEY (Role) REFERENCES Role(name)
);

-- Create visits table
CREATE TABLE visits (
                        scheduledDate DATE,
                        conductedDate DATE,
                        photoURL VARCHAR(255),
                        employee_id INT,
                        jobsite_address VARCHAR(255),
                        PRIMARY KEY (employee_id, jobsite_address),
                        FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
                        FOREIGN KEY (jobsite_address) REFERENCES JobSite(jobsite_address)
);

-- Create manages table
CREATE TABLE manages (
                         employee_id INT,
                         jobsite_address VARCHAR(255),
                         PRIMARY KEY (employee_id, jobsite_address),
                         FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
                         FOREIGN KEY (jobsite_address) REFERENCES JobSite(jobsite_address)
);

CREATE TABLE volunteer (
                           user_id INT,
                           jobsite_address VARCHAR(255),
                           PRIMARY KEY (user_id, jobsite_address),
                           FOREIGN KEY (user_id) REFERENCES User(user_id),
                           FOREIGN KEY (jobsite_address) REFERENCES JobSite(jobsite_address)
);

CREATE TABLE status (
                          status VARCHAR(255) PRIMARY KEY
);

CREATE TABLE requests (
                          payment INT,
                          status VARCHAR(255),
                          user_id INT,
                          address VARCHAR(255),
                          date_requested DATE,
                          tree_type VARCHAR(255),
                          FOREIGN KEY (user_id) REFERENCES User(user_id),
                          FOREIGN KEY (address) REFERENCES JobSite(jobsite_address),
                          FOREIGN KEY (status) REFERENCES status(status)
);


set foreign_key_checks = 1;

