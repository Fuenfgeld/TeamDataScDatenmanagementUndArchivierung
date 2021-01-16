-- Database covid19_allergy.db

CREATE TABLE patients_cov(
  Id varchar primary key,
  BIRTHDATE date,
  DEATHDATE date,
  SSN varchar,
  DRIVERS varchar,
  PASSPORT varchar,
  PREFIX varchar,
  FIRST varchar,
  LAST varchar,
  SUFFIX varchar,
  MAIDEN varchar,
  MARITAL varchar,
  RACE varchar,
  ETHNICITY varchar,
  GENDER varchar,
  BIRTHPLACE varchar,
  ADDRESS varchar,
  CITY varchar,
  STATE varchar,
  COUNTY varchar,
  ZIP varchar,
  LAT double,
  LON double,
  HEALTHCARE_EXPENSES varchar,
  HEALTHCARE_COVERAGE varchar
);

CREATE UNIQUE INDEX patient_id_cov on patients_cov(Id);
CREATE INDEX patient_gender_cov on patients_cov(GENDER);

CREATE TABLE patients_alle(
  Id varchar primary key,
  BIRTHDATE date,
  DEATHDATE date,
  SSN varchar,
  DRIVERS varchar,
  PASSPORT varchar,
  PREFIX varchar,
  FIRST varchar,
  LAST varchar,
  SUFFIX varchar,
  MAIDEN varchar,
  MARITAL varchar,
  RACE varchar,
  ETHNICITY varchar,
  GENDER varchar,
  BIRTHPLACE varchar,
  ADDRESS varchar,
  CITY varchar,
  STATE varchar,
  COUNTY varchar,
  ZIP varchar,
  LAT double,
  LON double,
  HEALTHCARE_EXPENSES varchar,
  HEALTHCARE_COVERAGE varchar
);

CREATE UNIQUE INDEX patient_id_alle on patients_alle(Id);
CREATE INDEX patient_gender_alle on patients_alle(GENDER);

CREATE TABLE encounters_cov(
  Id varchar primary key,
  START date,
  STOP date,
  PATIENT varchar ,
  ORGANIZATION varchar,
  PROVIDER varchar,
  PAYER varchar,
  ENCOUNTERCLASS varchar,
  CODE varchar,
  DESCRIPTION varchar,
  BASE_ENCOUNTER_COST double,
  TOTAL_CLAIM_COST double,
  PAYER_COVERAGE double,
  REASONCODE varchar,
  REASONDESCRIPTION varchar,
  FOREIGN KEY(PATIENT) REFERENCES patients_cov(id)
);

CREATE UNIQUE INDEX encounters_id_cov on encounters_cov(Id);
CREATE INDEX encounters_patient_cov on encounters_cov(PATIENT);
CREATE INDEX encounters_description_cov on encounters_cov(DESCRIPTION);

CREATE TABLE encounters_alle(
  Id varchar primary key,
  START date,
  STOP date,
  PATIENT varchar ,
  ORGANIZATION varchar,
  PROVIDER varchar,
  PAYER varchar,
  ENCOUNTERCLASS varchar,
  CODE varchar,
  DESCRIPTION varchar,
  BASE_ENCOUNTER_COST double,
  TOTAL_CLAIM_COST double,
  PAYER_COVERAGE double,
  REASONCODE varchar,
  REASONDESCRIPTION varchar,
  FOREIGN KEY(PATIENT) REFERENCES patients_alle(id)
);

CREATE UNIQUE INDEX encounters_id_alle on encounters_alle(Id);
CREATE INDEX encounters_patient_alle on encounters_alle(PATIENT);
CREATE INDEX encounters_description_alle on encounters_alle(DESCRIPTION);

CREATE TABLE conditions_cov(
  START date,
  STOP date,
  PATIENT varchar,
  ENCOUNTER varchar,
  CODE varchar,
  DESCRIPTION varchar,
  FOREIGN KEY(PATIENT) REFERENCES patients_cov(id),
  FOREIGN KEY(ENCOUNTER) REFERENCES encounters_cov(id)
);

CREATE INDEX conditions_patient_cov on conditions_cov(PATIENT);
CREATE INDEX conditions_encounter_cov on conditions_cov(ENCOUNTER);
CREATE INDEX conditions_description_cov on conditions_cov(DESCRIPTION);

CREATE TABLE conditions_alle(
  START date,
  STOP date,
  PATIENT varchar,
  ENCOUNTER varchar,
  CODE varchar,
  DESCRIPTION varchar,
  FOREIGN KEY(PATIENT) REFERENCES patients_alle(id),
  FOREIGN KEY(ENCOUNTER) REFERENCES encounters_alle(id)
);

CREATE INDEX conditions_patient_alle on conditions_alle(PATIENT);
CREATE INDEX conditions_encounter_alle on conditions_alle(ENCOUNTER);
CREATE INDEX conditions_description_alle on conditions_alle(DESCRIPTION);

CREATE TABLE observations_cov(
  DATE date,
  PATIENT varchar,
  ENCOUNTER varchar,
  CODE varchar,
  DESCRIPTION varchar,
  VALUE varchar,
  UNITS varchar,
  TYPE varchar,
  FOREIGN KEY(PATIENT) REFERENCES patients_cov(id),
  FOREIGN KEY(ENCOUNTER) REFERENCES encounters_cov(id)
);

CREATE INDEX observations_patient_cov on observations_cov(PATIENT);
CREATE INDEX observations_encounter_cov on observations_cov(ENCOUNTER);
CREATE INDEX observations_description_cov on observations_cov(DESCRIPTION);
CREATE INDEX observations_type_cov on observations_cov(TYPE);

CREATE TABLE observations_alle(
  DATE date,
  PATIENT varchar,
  ENCOUNTER varchar,
  CODE varchar,
  DESCRIPTION varchar,
  VALUE varchar,
  UNITS varchar,
  TYPE varchar,
  FOREIGN KEY(PATIENT) REFERENCES patients_alle(id),
  FOREIGN KEY(ENCOUNTER) REFERENCES encounters_alle(id)
);

CREATE INDEX observations_patient_alle on observations_alle(PATIENT);
CREATE INDEX observations_encounter_alle on observations_alle(ENCOUNTER);
CREATE INDEX observations_description_alle on observations_alle(DESCRIPTION);
CREATE INDEX observations_type_alle on observations_alle(TYPE);

CREATE VIEW v_patients as
select PA.id PATIENT_Id, BIRTHDATE, DEATHDATE, MARITAL, RACE, ETHNICITY, GENDER, CITY, MAX(strftime('%Y', START)) - strftime('%Y', BIRTHDATE) AGE,  'allergy' file 
from patients_alle pa
JOIN encounters_alle EA 
  ON PA.Id = EA.PATIENT
group by PA.id
  union
select PC.id PATIENT_Id, BIRTHDATE, DEATHDATE, MARITAL, RACE, ETHNICITY, GENDER, CITY, MAX(strftime('%Y', START)) - strftime('%Y', BIRTHDATE) AGE, 'covid-19' file 
from patients_cov PC 
JOIN encounters_cov EC 
  ON PC.Id = EC.PATIENT
group by PC.id;

CREATE VIEW v_encounters as
select Id ENCOUNTER_Id, "START" , STOP , PATIENT , CODE , DESCRIPTION, BASE_ENCOUNTER_COST , TOTAL_CLAIM_COST , PAYER_COVERAGE , REASONCODE , REASONDESCRIPTION , 'allergy' file from encounters_alle
  union
select Id ENCOUNTER_Id, "START" , STOP , PATIENT , CODE , DESCRIPTION, BASE_ENCOUNTER_COST , TOTAL_CLAIM_COST , PAYER_COVERAGE , REASONCODE , REASONDESCRIPTION , 'covid-19' file from encounters_cov
;

CREATE INDEX patient_city_alle on patients_alle(CITY);
CREATE INDEX patient_race_alle on patients_alle(RACE);

CREATE VIEW v_age_alle as
  select 
    PA.ID Patient_allergy, 
    MAX(strftime('%Y', START)) - strftime('%Y', BIRTHDATE) AGE 
  from patients_alle PA 
  JOIN encounters_alle EA 
    ON PA.Id = EA.PATIENT 
  GROUP BY PA.ID
;

CREATE VIEW v_age_cov as
  select 
    PA.ID Patient_cov, 
    MAX(strftime('%Y', START)) - strftime('%Y', BIRTHDATE) AGE 
  from patients_cov PA 
  JOIN encounters_cov EA 
    ON PA.Id = EA.PATIENT 
  GROUP BY PA.ID
;
