CREATE USER denormal_user;
CREATE DATABASE denormal_cars OWNER denormal_user ENCODING 'utf8';

\i ~/Devleague/Denormal-Automotives/scripts/denormal_data.sql

SELECT DISTINCT make_title FROM car_models;
SELECT DISTINCT model_title FROM car_models WHERE make_code = 'VOLKS';
SELECT make_code, model_code, model_title, year FROM car_models WHERE make_code = 'LAM';
SELECT * FROM car_models WHERE year BETWEEN 2010 AND 2015;