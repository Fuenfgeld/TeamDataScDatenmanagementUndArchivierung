/*
Dieses SQL-Skript (SQLite) ist für den Export mancher relevanter Information der Datenbank in CSV-Dateien
Dieses Skript wurde unter Ubuntu getestet.
*/

--exporting

-- observations

-- Menge an Patienten bei Obserbations (COVID-19)
.output observations_description_patient_cov.csv
select 
  DESCRIPTION, 
  count(distinct PATIENT) C_PATIENTS_COVID 
FROM observations_cov 
group by DESCRIPTION;

-- Menge an Patienten bei Obserbations (Allergy)
.output observations_description_patient_alle.csv
select 
  DESCRIPTION, 
  count(distinct PATIENT) C_PATIENTS_ALLERGY 
FROM observations_alle 
group by DESCRIPTION;

--conditions

-- Menge an Patienten bei Conditions (COVID-19)
.output conditions_description_patient_cov.csv
select 
  DESCRIPTION, 
  count(distinct PATIENT) C_PATIENTS_COVID 
FROM conditions_cov 
group by DESCRIPTION;

-- Menge an Patienten bei Conditions (Allergy)
.output conditions_description_patient_alle.csv
select 
  DESCRIPTION, 
  count(distinct PATIENT) C_PATIENTS_ALLERGY 
FROM conditions_alle 
group by DESCRIPTION;

--race

-- Menge an Patienten bei Race (COVID-19)
.output patients_race_cov.csv
select 
  RACE, 
  count(distinct ID) C_PATIENTS_COVID 
FROM patients_cov 
group by RACE;

-- Menge an Patienten bei Race (Allergy)
.output patients_race_alle.csv
select 
  RACE, 
  count(distinct ID) C_PATIENTS_ALLERGY 
FROM patients_alle 
group by RACE;


-- age

-- Menge an Patienten bei Age (COVID-19)
.output patient_age_cov.csv
select 
  PA.ID Patient_covid, 
  BIRTHDATE, 
  MAX(STOP) STOP, 
  MAX(strftime('%Y', STOP)) - strftime('%Y', BIRTHDATE) AGE_END 
from patients_cov PA 
JOIN encounters_cov EA 
  ON PA.Id = EA.PATIENT 
GROUP BY PA.ID;

-- Menge an Patienten bei Age (Allergy)
.output patient_age_alle.csv
select 
  PA.ID Patient_allergy, 
  BIRTHDATE, 
  MAX(STOP) STOP, 
  MAX(strftime('%Y', STOP)) - strftime('%Y', BIRTHDATE) AGE_END 
from patients_alle PA 
JOIN encounters_alle EA 
  ON PA.Id = EA.PATIENT 
GROUP BY PA.ID;

--encounter

-- Menge an Patienten bei Encounter-Reasondescription (Allergy)
.output encounter_reasondescription_alle.csv
select 
  REASONDESCRIPTION , 
  count(distinct PATIENT) C_PATIENTS_ALLE 
FROM encounters_alle ea  
where REASONDESCRIPTION not like '' -- exclude "''" character (these are not null values)
group by REASONDESCRIPTION ;

-- Menge an Patienten bei Encounter-Reasondescription (COVID-19)
.output encounter_reasondescription_cov.csv
select 
  REASONDESCRIPTION , 
  count(distinct PATIENT) C_PATIENTS_COV 
FROM encounters_cov co  
where REASONDESCRIPTION not like '' -- exclude "''" characters (these are not null values) 
group by REASONDESCRIPTION ;

.output encounter_description_alle.csv
select 
  DESCRIPTION , 
  count(distinct PATIENT) C_PATIENTS_ALLE 
FROM encounters_alle ea  
where DESCRIPTION not like '' -- exclude "''" character (these are not null values)
group by DESCRIPTION ;

.output encounter_description_cov.csv
select 
  DESCRIPTION , 
  count(distinct PATIENT) C_PATIENTS_COV 
  FROM encounters_cov co  
  where DESCRIPTION not like '' -- exclude "''" character (these are not null values)
group by DESCRIPTION ;

.output --output to the console
