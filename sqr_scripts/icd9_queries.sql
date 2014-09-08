-- Queries for ICD9

-- ASTHMA
select icu.ICUSTAY_ID, icu.SUBJECT_ID, icd9.CODE, icd9.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL icu, MIMIC2V26.ICD9 icd9
where (icu.SUBJECT_ID = icd9.SUBJECT_ID)
    and (icd9.DESCRIPTION like '%ASTHMA%')
    and (icd9.code not in ('493.20','493.21','493.22','V17.5','E945.7'));


-- COPD
select icu.ICUSTAY_ID, icu.SUBJECT_ID, icd9.CODE, icd9.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL icu, MIMIC2V26.ICD9 icd9
where (icu.SUBJECT_ID = icd9.SUBJECT_ID)
    and ((icd9.DESCRIPTION like '%EMPHYSEMA%')
	or (icd9.DESCRIPTION like '%OBSTRUCTIVE CHRONIC BRONCHITIS%'))
    and (icd9.code not in ('998.81'))
    and (icd9.DESCRIPTION not like '%SUBCUTANEOUS%');


-- DEMENTIA
select icu.ICUSTAY_ID, icu.SUBJECT_ID, icd9.CODE, icd9.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL icu, MIMIC2V26.ICD9 icd9
where (icu.SUBJECT_ID = icd9.SUBJECT_ID)
    and (icd9.DESCRIPTION like '%DEMENTIA%');


-- STROKE (can't tell apart acute from )
-- select icu.ICUSTAY_ID, icu.SUBJECT_ID, icd9.CODE, icd9.DESCRIPTION
-- from MIMIC2V26.ICUSTAY_DETAIL icu, MIMIC2V26.ICD9 icd9
-- where (icu.SUBJECT_ID = icd9.SUBJECT_ID)
--     and (icd9.DESCRIPTION like '%CEREBRO%');


-- FRACTURE
select icu.ICUSTAY_ID, icu.SUBJECT_ID, icd9.CODE, icd9.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL icu, MIMIC2V26.ICD9 icd9
where (icu.SUBJECT_ID = icd9.SUBJECT_ID)
    and (icd9.DESCRIPTION like '%FRACTURE%');


-- TRAUMA
select icu.ICUSTAY_ID, icu.SUBJECT_ID, icd9.CODE, icd9.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL icu, MIMIC2V26.ICD9 icd9
where (icu.SUBJECT_ID = icd9.SUBJECT_ID)
    and (icd9.DESCRIPTION like '%TRAUMA%')
    and (icd9.code not in ('785.59','309.81','568.81'));


-- DECUBITUS
select icu.ICUSTAY_ID, icu.SUBJECT_ID, icd9.CODE, icd9.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL icu, MIMIC2V26.ICD9 icd9
where (icu.SUBJECT_ID = icd9.SUBJECT_ID)
    and (icd9.DESCRIPTION like '%DECUBITUS%');
