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

CREATE TABLE IF NOT EXISTS all_car_models
(
id serial,
model_code character varying(125) NOT NULL,
model_title character varying(125) NOT NULL,

car_companies_id integer NOT NULL,
release_year_id integer NOT NULL,
PRIMARY KEY (id),

CONSTRAINT car_companies_id_fk FOREIGN KEY (car_companies_id)
REFERENCES car_companies (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,

CONSTRAINT release_year_id_fk FOREIGN KEY (release_year_id)
REFERENCES release_year (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

--adds rows to the car_companies
INSERT INTO car_companies (make_code, make_title)
SELECT DISTINCT make_code, make_title
  FROM car_models;

--adds rows to the release_year
INSERT INTO release_year (year)
SELECT DISTINCT year
  FROM car_models;

--adds rows to the all_car_models

-- INSERT INTO all_car_models(model_code, model_title, car_companies_id, release_year_id)
-- SELECT (model_code, model_title) FROM car_models
-- SELECT car_companies_id FROM car_companies
-- SELECT release_year_id FROM release_year;

-- FROM car_models VALUES (model_code, model_title)
-- FROM car_companies VALUES (car_companies_id)
-- FROM release_year VALUES (release_year_id);

-- add two new rows represneting the foreign keys to the mast car-models table

