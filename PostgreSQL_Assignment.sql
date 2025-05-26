-- Active: 1747462271714@@127.0.0.1@5433@conservation_db
CREATE DATABASE conservation_db;

-- rangers table creation
CREATE Table rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);

-- species table creation 
CREATE Table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(30),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(20)
);

-- sightings table creation
CREATE Table sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id),
    species_id INT REFERENCES species(species_id),
    sighting_time TIMESTAMP,
    location VARCHAR(50),
    notes TEXT
);

-- inserting data into rangers table 
INSERT INTO rangers ( name, region) 
VALUES ('Alice Green','Northern Hills'),
('Bob White','River Delta'),
('Carol King','Mountain Range');

-- inserting data into species table 
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES 
    ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
    ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
    ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
    ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered'),
    ('Mountain Gorilla', 'Gorilla beringei beringei', '1902-10-17', 'Endangered'),
    ('Blue Whale', 'Balaenoptera musculus', '1758-01-01', 'Endangered'),
    ('Komodo Dragon', 'Varanus komodoensis', '1910-06-01', 'Vulnerable'),
    ('Giant Panda', 'Ailuropoda melanoleuca', '1869-03-11', 'Vulnerable'),
    ('African Lion', 'Panthera leo', '1758-01-01', 'Vulnerable'),
    ('Hawksbill Sea Turtle', 'Eretmochelys imbricata', '1766-01-01', 'Endangered');

-- inserting data into sightings table 
INSERT INTO sightings (ranger_id, species_id, sighting_time, location, notes)
VALUES 
    (1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
    (2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
    (3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
    (2, 1, '2024-05-18 18:30:00', 'Snowfall Pass', NULL);



-- problem 1
INSERT INTO rangers (name,region) VALUES('Derek Fox','Coastal Plains');

-- problem 2
SELECT COUNT(DISTINCT species_id) as unique_species_count FROM sightings;

-- problem 3
SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- problem 4
SELECT name,count(ranger_id) as total_sightings FROM rangers JOIN sightings USING(ranger_id)
GROUP BY(ranger_id);

-- problem 5
SELECT common_name FROM species LEFT JOIN sightings  
USING(species_id)
WHERE sighting_id is NULL
ORDER BY common_name ASC;

-- problem 6
SELECT common_name,sighting_time,name 
FROM sightings JOIN species USING(species_id) JOIN rangers USING(ranger_id)
ORDER BY sighting_time DESC
LIMIT 2;

-- problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE 
extract(year from discovery_date) <1800;

-- problem 8
SELECT sighting_id,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM sighting_time) >= 17 THEN 'Evening'
    END AS time_of_day
FROM sightings;

-- problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);

