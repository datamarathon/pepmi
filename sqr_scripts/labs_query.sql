--select * from "MIMIC2V26"."d_labitems" where FLUID = 'BLOOD' and upper(LOINC_DESCRIPTION) like '%BIC%' order by ITEMID;

--select *
--from  "MIMIC2V26"."labevents" x, "MIMIC2V26"."d_labitems" y
--where x.ITEMID = y.ITEMID
--and upper(y.LOINC_DESCRIPTION) like '%BASE%';

CREATE TABLE "USER3"."Glucose" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50112)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Hemoglobin" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50386)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."WhiteBloodCell" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50468)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Platelets" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50428)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."PT" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50439)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Creatinine" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50090)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Urea" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50177)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Sodium" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50159)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Potassium" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50149)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."BIC" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50172)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Chloride" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50083)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."pH" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50018)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."pCO2" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50016)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."AnionGap" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50068)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Albumin" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50060)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."Lactate" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50010)
order by "ICUSTAY_ID","CHARTTIME");

CREATE TABLE "USER3"."BaseDeficit" as
(select id."ICUSTAY_ID","CHARTTIME","VALUE","VALUENUM"
from "MIMIC2V26"."icustay_detail" id, "MIMIC2V26"."labevents" ic
where id."ICUSTAY_ID" = ic."ICUSTAY_ID"
and "ICUSTAY_ADMIT_AGE" > 60
--and "CHARTTIME" - "ICUSTAY_INTIME" > 360-- six hours period
and "ITEMID" in (50002)
order by "ICUSTAY_ID","CHARTTIME");
