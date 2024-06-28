/* Store the CSV to a temp file. */
filename scrdata temp;
proc http
   url="https://www.data.gouv.fr/fr/datasets/r/5f71ba43-afc8-43a0-b306-dafe29940f9c"
   out=scrdata;                                     
run;
/* 12 minutes */
/* Drop the existing table if present. */
proc sql;
%if %sysfunc(exist(CASUSER.effectif_patients)) %then %do;
    drop table CASUSER.effectif_patients;
%end;
%if %sysfunc(exist(CASUSER.effectif_patients,VIEW)) %then %do;
    drop view CASUSER.effectif_patients;
%end;
quit;

/* Upload the CSV to CAS. */
proc cas;
   upload
       path="%sysfunc(pathname(scrdata))"
/* 		path="/create-export/create/homes/Yulia.Paramonova@sas.com/effectif_de_patients.csv" */
      casOut={caslib="casuser", name="effectif_patients",memoryFormat="DVR"}
      importOptions={fileType="CSV", delimiter=";", getNames=TRUE, guessRows=500,/*locale="French_France",*/ varChars=TRUE};
run;

   table.tableInfo /
      caslib="casuser", 
      table="effectif_patients";
quit;

proc cas; *ajouter des labels;
table.alterTable /
caslib="casuser"
columns=
{{label="Année", name="annee"}
,{label="Pathologie niveau 1", name="patho_niv1"}
,{label="Pathologie niveau 2", name="patho_niv2"}
,{label="Pathologie niveau 3", name="patho_niv3"}
,{label="Top", name="top"}
,{label="Classe d'âge", name="cla_age_5"}
,{label="Sexe", name="sexe"}
,{label="Région", name="region"}
,{label="Département", name="dept"}
,{label="Total TOP", name="ntop"}
,{label="Population", name="npop"}
,{label="Prévalence ", name="prev"}
,{label="Niveau prioritaire", name="niveau_prioritaire"}
,{label="Libellé classe d'âge", name="libelle_classe_age"}
,{label="Libellé sexe", name="libelle_sexe"}
}
name="effectif_patients"
rename="effectif_patients_dvr"
;
quit; 

proc casutil;
/* Save the file in casuser and promote the table. */
	save casdata="effectif_patients_dvr" replace;
	promote casdata="effectif_patients_dvr" incaslib="casuser";
quit;

proc cas;
lib="casuser";
	table.tableInfo / caslib=lib;
	table.fileInfo / caslib=lib;
quit;

/* 177MB */
/* Remove the temp file. */
filename scrdata clear;
