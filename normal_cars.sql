CREATE USER normal_user;
CREATE DATABASE normal_cars OWNER normal_user ENCODING 'utf8';

-- create the table of car companies
CREATE TABLE IF NOT EXISTS car_companies
(
id serial,
make_code character varying(125) NOT NULL,
make_title character varying(125) NOT NULL,
PRIMARY KEY (id)
);

-- create the table of release years
CREATE TABLE IF NOT EXISTS release_year
(
id serial,
year integer NOT NULL,
PRIMARY KEY (id)
);

-- create the table of tmp_car_models
--It populates the table as well
\i ~/Devleague/Denormal-Automotives/scripts/normal_data_car_companies.sql

--adds rows to the car_companies
INSERT INTO car_companies (make_code, make_title)
SELECT DISTINCT make_code, make_title
  FROM tmp_car_models;

--adds rows to the release_year
INSERT INTO release_year (year)
SELECT DISTINCT year
  FROM tmp_car_models;







-- update tmp_car_models.car_companies_id column with
--the id numbers in the car_companies table
UPDATE tmp_car_models
SET car_companies_id =
(
SELECT id
FROM car_companies
WHERE car_companies.make_code = tmp_car_models.make_code
);

-- update tmp_car_models.release_year.id column with
--the id numbers in the release_year table
UPDATE tmp_car_models
SET release_year_id =
(
SELECT id
FROM release_year
WHERE release_year.year = tmp_car_models.year
);

--Drop the extra column in the tmp_car_models table
ALTER TABLE tmp_car_models DROP COLUMN make_code;
ALTER TABLE tmp_car_models DROP COLUMN make_title;
ALTER TABLE tmp_car_models DROP COLUMN year;

--add the foreign key contraints and references to the
--foreign keys in the tmp_car_models table
ALTER TABLE tmp_car_models
ADD CONSTRAINT car_companies_id_fk FOREIGN KEY (car_companies_id)
REFERENCES car_companies (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

--add the foreign key contraints and references to the
--foreign keys in the tmp_car_models table
ALTER TABLE tmp_car_models
ADD CONSTRAINT release_year_id_fk FOREIGN KEY (release_year_id)
REFERENCES release_year (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

--Querying the tmp_car_models table with the car_companies
--using join, to make sure they match up
SELECT tmp_car_models.*, car_companies.make_title
FROM tmp_car_models
INNER JOIN car_companies
ON  car_companies.id = tmp_car_models.car_companies_id;

--more querying
SELECT tmp_car_models.*, release_year.year, car_companies.make_title
FROM tmp_car_models
INNER JOIN release_year
ON  release_year.id = tmp_car_models.release_year_id

--more querying
SELECT tmp_car_models.model_title, car_companies.make_title, release_year.year
FROM tmp_car_models
INNER JOIN release_year
ON  release_year.id = tmp_car_models.release_year_id
INNER JOIN car_companies
ON  car_companies.id = tmp_car_models.car_companies_id;
