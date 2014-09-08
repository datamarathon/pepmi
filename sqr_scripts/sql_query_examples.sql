-- 2014-03-21 Code created at Nikuthon
-- Variables to pull
-- --
-- Prothrombin time
-- Vasoactive drug treatment
-- Cardiopulmonary resuscitation
-- Dobutamine
-- Epinephrine
-- Norepinephrine
-- Dopamine


-- How to export query result to csv in Oracle SQL Developer?
-- http://stackoverflow.com/questions/4168398/how-to-export-query-result-to-csv-in-oracle-sql-developer


-- Example code for joining two tables
-- ICD9, AGE, SAPSI, SURVIVE/DIE FLAG
select id.SUBJECT_ID, id.SAPSI_FIRST, id.ICUSTAY_EXPIRE_FLG, id.ICUSTAY_ADMIT_AGE as AGE, ic.CODE, ic.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL id, MIMIC2V26.ICD9 ic
where id.SUBJECT_ID = ic.SUBJECT_ID
    and id.HOSPITAL_FIRST_FLG = 'Y'
    and id.ICUSTAY_FIRST_FLG = 'Y'
    and id.ICUSTAY_FIRST_CAREUNIT = 'MICU'
    and id.SAPSI_FIRST > 20;


--
-- Prothrombin time
--
select *
from  MIMIC2V26.LABEVENTS x, MIMIC2V26.D_LABITEMS y
where x.ITEMID = y.ITEMID
    and upper(y.LOINC_DESCRIPTION) like '%PROTHROMBIN%';



--
-- Vasoactive drugs
    --
-- CHARTEVENTS
select *
from  MIMIC2V26.CHARTEVENTS x, MIMIC2V26.D_CHARTITEMS y
where (x.ITEMID = y.ITEMID)
    and ((upper(y.LABEL) like '%VASOPRESSIN%') or (upper(y.LABEL) like '%EPINEPHRINE%') or (upper(y.LABEL) like '%DOBUTAMINE%') or (upper(y.LABEL) like '%DOPAMINE%'));

-- MEDEVENTS
select *
from  MIMIC2V26.MEDEVENTS x, MIMIC2V26.D_MEDITEMS y
where (x.ITEMID = y.ITEMID)
    and ((upper(y.LABEL) like '%VASOPRESSIN%') or (upper(y.LABEL) like '%EPINEPHRINE%') or (upper(y.LABEL) like '%DOBUTAMINE%') or (upper(y.LABEL) like '%DOPAMINE%'));

-- IOEVENTS
select *
from  MIMIC2V26.IOEVENTS x, MIMIC2V26.D_IOITEMS y
where (x.ITEMID = y.ITEMID)
    and ((upper(y.LABEL) like '%VASOPRESSIN%') or (upper(y.LABEL) like '%EPINEPHRINE%') or (upper(y.LABEL) like '%DOBUTAMINE%') or (upper(y.LABEL) like '%DOPAMINE%'));
