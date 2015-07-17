CREATE USER normal_user;
CREATE DATABASE normal_cars OWNER normal_user ENCODING 'utf8';

CREATE TABLE IF NOT EXISTS car_companies
(
id serial,
make_code character varying(125) NOT NULL,
make_title character varying(125) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS release_year
(
id serial,
year integer NOT NULL,
PRIMARY KEY (id)
);


\i ~/Devleague/Denormal-Automotives/scripts/normal_data_car_companies.sql

--adds rows to the car_companies
INSERT INTO car_companies (make_code, make_title)
SELECT DISTINCT make_code, make_title
  FROM car_models;

--adds rows to the release_year
INSERT INTO release_year (year)
SELECT DISTINCT year
  FROM car_models;

--adds rows to the all_car_models

UPDATE tmp_car_models
SET car_companies_id =
(
SELECT id
FROM car_companies
WHERE car_companies.make_code = tmp_car_models.make_code
);

UPDATE tmp_car_models
SET release_year_id =
(
SELECT id
FROM release_year
WHERE release_year.year = tmp_car_models.year
);

ALTER TABLE tmp_car_models DROP COLUMN make_code;
ALTER TABLE tmp_car_models DROP COLUMN make_title;
ALTER TABLE tmp_car_models DROP COLUMN year;

ALTER TABLE tmp_car_models
ADD CONSTRAINT car_companies_id_fk FOREIGN KEY (car_companies_id)
REFERENCES car_companies (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE tmp_car_models
ADD CONSTRAINT release_year_id_fk FOREIGN KEY (release_year_id)
REFERENCES release_year (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;


SELECT tmp_car_models.*, car_companies.make_title
FROM tmp_car_models
INNER JOIN car_companies
ON  car_companies.id = tmp_car_models.car_companies_id;