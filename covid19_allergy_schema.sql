/*
Das ist eine automatische Generierung des Schema der Datenbank
Schriten
1. Konsole starten 
2. > cd database directory
3. > sqlite3 database_file.db
4. > .output output_file
5. > .schema
6. > .output
7. > .exit
*/

CREATE TABLE dimPatient(
    ID VARCHAR,
    BIRTHDATE INTEGER,
    DEATHDATE INTEGER,
    LAT DOUBLE,
    LON DOUBLE,
    HEALTHCARE_EXPENSES DOUBLE,
    HEALTHCARE_COVERAGE DOUBLE,
    PSPID VARCHAR PRIMARY KEY,
    AGE INTEGER
  );
CREATE TABLE dimGender(
    ID INTEGER PRIMARY KEY,
    GENDER VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE dimStudy(
    ID INTEGER PRIMARY KEY,
    STUDY VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE dimCity(
    ID INTEGER PRIMARY KEY,
    CITY VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE dimEthnicity(
    ID INTEGER PRIMARY KEY,
    ETHNICITY VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE dimMarital(
    ID INTEGER PRIMARY KEY,
    MARITAL VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE dimRace(
    ID INTEGER PRIMARY KEY,
    RACE VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE dimSnomed(
    CODE VARCHAR PRIMARY KEY,
    DESCRIPTION VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE dimLoinc(
    CODE VARCHAR PRIMARY KEY,
    DESCRIPTION VARCHAR UNIQUE NOT NULL
  );
CREATE TABLE factObservation(
    PATIENT_PSPID VARCHAR REFERENCES dimPatient(PSPID),
    BIRTHYEAR INTEGER,
    DEATHYEAR INTEGER,
    MARITAL_ID VARCHAR REFERENCES dimMarital(ID),
    RACE_ID VARCHAR REFERENCES dimRace(ID),
    ETHNICITY_ID VARCHAR REFERENCES dimEthnicity(ID),
    GENDER_ID VARCHAR REFERENCES dimGender(ID),
    CITY_ID VARCHAR REFERENCES dimCity(ID),
    STUDY_ID VARCHAR REFERENCES dimStudy(ID),
    AGE INTEGER,
    DATE DATE,
    LOINC VARCHAR REFERENCES dimLoinc(CODE),
    VALUE VARCHAR,
    UNITS VARCHAR
  );
CREATE TABLE factProcedure(
    PATIENT_PSPID VARCHAR REFERENCES dimPatient(PSPID),
    BIRTHYEAR INTEGER,
    DEATHYEAR INTEGER,
    MARITAL_ID VARCHAR REFERENCES dimMarital(ID),
    RACE_ID VARCHAR REFERENCES dimRace(ID),
    ETHNICITY_ID VARCHAR REFERENCES dimEthnicity(ID),
    GENDER_ID VARCHAR REFERENCES dimGender(ID),
    CITY_ID VARCHAR REFERENCES dimCity(ID),
    STUDY_ID VARCHAR REFERENCES dimStudy(ID),
    AGE INTEGER,
    DATE DATE,
    SNOMED VARCHAR REFERENCES dimSnomed(CODE)
  );
CREATE TABLE factCondition(
    PATIENT_PSPID VARCHAR REFERENCES dimPatient(PSPID),
    BIRTHYEAR INTEGER,
    DEATHYEAR INTEGER,
    MARITAL_ID VARCHAR REFERENCES dimMarital(ID),
    RACE_ID VARCHAR REFERENCES dimRace(ID),
    ETHNICITY_ID VARCHAR REFERENCES dimEthnicity(ID),
    GENDER_ID VARCHAR REFERENCES dimGender(ID),
    CITY_ID VARCHAR REFERENCES dimCity(ID),
    STUDY_ID VARCHAR REFERENCES dimStudy(ID),
    AGE INTEGER,
    START DATE,
    STOP DATE,
    SNOMED VARCHAR REFERENCES dimSnomed(CODE)
  );
CREATE INDEX ix_factObservation_patient on factObservation(PATIENT_PSPID);
CREATE INDEX ix_factObservation_marital on factObservation(MARITAL_ID);
CREATE INDEX ix_factObservation_race on factObservation(RACE_ID);
CREATE INDEX ix_factObservation_ethnicity on factObservation(ETHNICITY_ID);
CREATE INDEX ix_factObservation_gender on factObservation(GENDER_ID);
CREATE INDEX ix_factObservation_city on factObservation(CITY_ID);
CREATE INDEX ix_factObservation_study on factObservation(STUDY_ID);
CREATE INDEX ix_factObservation_loinc on factObservation(LOINC);
CREATE INDEX ix_factProcedure_patient on factProcedure(PATIENT_PSPID);
CREATE INDEX ix_factProcedure_marital on factProcedure(MARITAL_ID);
CREATE INDEX ix_factProcedure_race on factProcedure(RACE_ID);
CREATE INDEX ix_factProcedure_ethnicity on factProcedure(ETHNICITY_ID);
CREATE INDEX ix_factProcedure_gender on factProcedure(GENDER_ID);
CREATE INDEX ix_factProcedure_city on factProcedure(CITY_ID);
CREATE INDEX ix_factProcedure_study on factProcedure(STUDY_ID);
CREATE INDEX ix_factProcedure_snomed on factProcedure(SNOMED);
CREATE INDEX ix_factCondition_patient on factCondition(PATIENT_PSPID);
CREATE INDEX ix_factCondition_marital on factCondition(MARITAL_ID);
CREATE INDEX ix_factCondition_race on factCondition(RACE_ID);
CREATE INDEX ix_factCondition_ethnicity on factCondition(ETHNICITY_ID);
CREATE INDEX ix_factCondition_gender on factCondition(GENDER_ID);
CREATE INDEX ix_factCondition_city on factCondition(CITY_ID);
CREATE INDEX ix_factCondition_study on factCondition(STUDY_ID);
CREATE INDEX ix_factCondition_snomed on factCondition(SNOMED);
CREATE VIEW v_patients as
select DISTINCT 
  PATIENT_PSPID PATIENT, 
  BIRTHYEAR, 
  DEATHYEAR,
  MARITAL,
  RACE,
  ETHNICITY,
  GENDER,
  CITY,  
  AGE,
  STUDY
from factObservation fo 
JOIN dimMarital dm 
  ON fo.MARITAL_ID = dm.ID 
join dimRace dr 
  on dr.ID = fo.RACE_ID 
join dimEthnicity de 
  on de.ID = fo.ETHNICITY_ID 
join dimGender dg 
  on dg.ID = fo.GENDER_ID
join dimCity dc 
  on dc.ID = fo.CITY_ID
join dimStudy ds 
  on ds.ID = fo.STUDY_ID
/* v_patients(PATIENT,BIRTHYEAR,DEATHYEAR,MARITAL,RACE,ETHNICITY,GENDER,CITY,AGE,STUDY) */;
CREATE VIEW v_observations as
select
  PATIENT_PSPID PATIENT,
  BIRTHYEAR,
  DEATHYEAR,
  dm.MARITAL,
  dr.RACE,
  de.ETHNICITY,
  dg.GENDER,
  dc.CITY ,
  AGE,
  DATE,
  LOINC,
  dl.description DESCRIPTION,
  VALUE,
  UNITS,
  ds.STUDY 
from factObservation fo
join dimMarital dm
  on fo.MARITAL_ID = dm.ID
join dimRace dr
  on dr.ID = fo.RACE_ID
join dimEthnicity de 
  on de.ID = fo.ETHNICITY_ID 
join dimGender dg 
  on dg.ID = fo.GENDER_ID
join dimCity dc 
  on dc.ID = fo.CITY_ID
join dimLoinc dl 
  on dl.code = fo.LOINC
join dimStudy ds
  on ds.ID = fo.STUDY_ID
/* v_observations(PATIENT,BIRTHYEAR,DEATHYEAR,MARITAL,RACE,ETHNICITY,GENDER,CITY,AGE,DATE,LOINC,DESCRIPTION,VALUE,UNITS,STUDY) */;
CREATE VIEW v_conditions as
select
  PATIENT_PSPID PATIENT,
  BIRTHYEAR,
  DEATHYEAR,
  dm.MARITAL,
  dr.RACE,
  de.ETHNICITY,
  dg.GENDER,
  dc.CITY ,
  AGE,
  "START" ,
  STOP ,
  SNOMED ,
  dsn.description DESCRIPTION,
  ds.STUDY 
from factCondition fc
join dimMarital dm
  on fc.MARITAL_ID = dm.ID
join dimRace dr
  on dr.ID = fc.RACE_ID
join dimEthnicity de 
  on de.ID = fc.ETHNICITY_ID 
join dimGender dg 
  on dg.ID = fc.GENDER_ID
join dimCity dc 
  on dc.ID = fc.CITY_ID
join dimSnomed dsn 
  on dsn.code = fc.SNOMED 
join dimStudy ds
  on ds.ID = fc.STUDY_ID
/* v_conditions(PATIENT,BIRTHYEAR,DEATHYEAR,MARITAL,RACE,ETHNICITY,GENDER,CITY,AGE,START,STOP,SNOMED,DESCRIPTION,STUDY) */;
CREATE VIEW v_procedures as
select
  PATIENT_PSPID PATIENT,
  BIRTHYEAR,
  DEATHYEAR,
  dm.MARITAL,
  dr.RACE,
  de.ETHNICITY,
  dg.GENDER,
  dc.CITY ,
  AGE,
  DATE ,
  SNOMED ,
  dsn.description DESCRIPTION,
  ds.STUDY 
from factProcedure fc
join dimMarital dm
  on fc.MARITAL_ID = dm.ID
join dimRace dr
  on dr.ID = fc.RACE_ID
join dimEthnicity de 
  on de.ID = fc.ETHNICITY_ID 
join dimGender dg 
  on dg.ID = fc.GENDER_ID
join dimCity dc 
  on dc.ID = fc.CITY_ID
join dimSnomed dsn 
  on dsn.code = fc.SNOMED 
join dimStudy ds
  on ds.ID = fc.STUDY_ID
/* v_procedures(PATIENT,BIRTHYEAR,DEATHYEAR,MARITAL,RACE,ETHNICITY,GENDER,CITY,AGE,DATE,SNOMED,DESCRIPTION,STUDY) */;
