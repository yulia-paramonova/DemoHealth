data CASUSER.effectif_de_patients_sexe;*1 365 102 lignes;
   set CASUSER.EFFECTIF_DE_PATIENTS; *2 080 566 lignes;
   where sexe ne 9;
run;

data CASUSER.effectif_de_patients_filter; *1 300 511 lignes;
   set CASUSER.effectif_de_patients_sexe; *1 365 102 lignes;
   where cla_age_5 ne "tsage";
	run;


/*data
CASUSER.SEXE_dist
CASUSER.sexe_tous
;
length _df_found 8;
set CASUSER.EFFECTIF_DE_PATIENTS;

_df_found = 0;
if sexe ne 9 then
   do;
      output CASUSER.SEXE_dist;
      _df_found = 1;
   end;
if _df_found eq 0 then
   output CASUSER.sexe_tous;
drop _df_found;
run;
NOTE: Running DATA step in Cloud Analytic Services.
NOTE: The DATA step will run in multiple threads.
NOTE: There were 2080566 observations read from the table EFFECTIF_DE_PATIENTS in caslib CASUSER(Yulia.Paramonova@sas.com).
NOTE: The table SEXE_dist in caslib CASUSER(Yulia.Paramonova@sas.com) has 1365102 observations and 16 variables.
NOTE: The table sexe_tous in caslib CASUSER(Yulia.Paramonova@sas.com) has 715464 observations and 16 variables.
NOTE: DATA statement used (Total process time):
      real time           0.39 seconds
      cpu time            0.01 seconds*/

/*NOTE: There were 2080566 observations read from the table EFFECTIF_DE_PATIENTS in caslib CASUSER(Yulia.Paramonova@sas.com).
NOTE: The table age_dist in caslib CASUSER(Yulia.Paramonova@sas.com) has 1982065 observations and 16 variables.
NOTE: The table age_tous in caslib CASUSER(Yulia.Paramonova@sas.com) has 98501 observations and 16 variables.*/

proc cas; *changer le format de la table en DVR;
lib="casuser"; 
  table.copyTable /
    table={name="effectif_de_patients_filter" caslib=lib}
    casOut={name="effectif_de_patients_filter_DVR" caslib=lib memoryFormat="DVR" replace=True replication=0};
run;

proc cas; *save la table complete dvr dans CASUSER pour voir la taille;
lib="casuser";
table.save / caslib=lib name="effectif_de_patients_filter_DVR"||".sashdat" table={name="effectif_de_patients_filter_DVR", caslib=lib} replace=true;
run; *56 mb;
table.save / caslib=lib name="effectif_de_patients_filter"||".sashdat" table={name="effectif_de_patients_filter", caslib=lib} replace=true;
run; *520 mb;

proc cas; *promote la table dans casuser;
lib="casuser";
table.promote / name="effectif_de_patients_filter_dvr", caslib=lib, target="effectif_de_patients_filter_dvr", targetLib=lib;
quit; 

proc cas; *check la taille de la table dvr;
lib="casuser";
	table.fileInfo / caslib=lib; *to see data source files;
	table.tableInfo / caslib=lib; *to see in-memory tables;
quit;

proc cas;
lib="casuser";
table.dropTable / caslib=lib, name="effectif_de_patients_filter", quiet=TRUE;
table.dropTable / caslib=lib, name="effectif_de_patients_sexe", quiet=TRUE;
table.dropTable / caslib=lib, name="effectif_de_patients", quiet=TRUE;
table.dropTable / caslib=lib, name="age_dist", quiet=TRUE;
table.dropTable / caslib=lib, name="age_tous", quiet=TRUE;
table.dropTable / caslib=lib, name="sexe_dist", quiet=TRUE;
table.dropTable / caslib=lib, name="sexe_tous", quiet=TRUE;
table.deleteSource / caslib=lib source="effectif_de_patients_filter"||".sashdat" ;
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
name="effectif_de_patients_filter_DVR"
;
quit; 