/* Import data depuis data.gouv.fr */

filename outfile "&_USERHOME/effectif_de_patients.csv";
proc http
/* url="https://raw.githubusercontent.com/yulia-paramonova/Viya-Hands-On/main/Data/table_VHO_ACCIDENTS_CORPORELS.csv" */
/* url="https://github.com/yulia-paramonova/Viya-Hands-On/raw/main/Data/ACCIDENTS_CORPORELS.sashdat" */
url="https://www.data.gouv.fr/fr/datasets/r/5f71ba43-afc8-43a0-b306-dafe29940f9c"
/* url="https://www.data.gouv.fr/fr/datasets/pathologies-effectif-de-patients-par-pathologie-sexe-classe-dage-et-territoire-departement-region/#/resources/5f71ba43-afc8-43a0-b306-dafe29940f9c" */
method="GET"
out=outfile;
run;

/* Generated Code (IMPORT) */
/* Source File: effectif_de_patients.csv */
/* Source Path: /create-export/create/homes/Yulia.Paramonova@sas.com/effectif_de_patients.csv */
/* Code generated on: Thursday, June 27, 2024, 9:57:40 AM */

proc sql;
%if %sysfunc(exist(CASUSER.effectif_de_patients)) %then %do;
    drop table CASUSER.effectif_de_patients;
%end;
%if %sysfunc(exist(CASUSER.effectif_de_patients,VIEW)) %then %do;
    drop view CASUSER.effectif_de_patients;
%end;
quit;



FILENAME REFFILE DISK '/create-export/create/homes/Yulia.Paramonova@sas.com/effectif_de_patients.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=DLM
	OUT=CASUSER.effectif_de_patients;
	DELIMITER=";";
	GETNAMES=YES;
	GUESSINGROWS=500;
RUN;

PROC CONTENTS DATA=CASUSER.effectif_de_patients; RUN;

proc casutil;
	promote casdata="effectif_de_patients" incaslib="casuser";
quit;

