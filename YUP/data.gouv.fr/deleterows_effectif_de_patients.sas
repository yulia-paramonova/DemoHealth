proc cas;
lib="casuser";
table.dropTable / caslib=lib, name="EFFECTIF_PATIENTS_DVR", quiet=TRUE;
table.loadTable / path="effectif_patients_dvr.sashdat" caslib=lib, casout={caslib=lib, name="EFFECTIF_PATIENTS_DVR", replace=TRUE};
run; 

proc cas;
   table.deleteRows /                /* 2 */
      table={caslib='casuser',
             name='EFFECTIF_PATIENTS_DVR',
      where="sexe = 9"};
   table.deleteRows /                /* 2 */
      table={caslib='casuser',
             name='EFFECTIF_PATIENTS_DVR',
      where="cla_age_5 = 'tsage'"};
quit;


proc cas; *promote la table dans casuser;
lib="casuser";
table.promote / name="EFFECTIF_PATIENTS_DVR", caslib=lib, target="EFFECTIF_PATIENTS_DVR", targetLib=lib;
quit; 

proc cas; *check la taille de la table dvr;
lib="casuser";
	table.fileInfo / caslib=lib; *to see data source files;
	table.tableInfo / caslib=lib; *to see in-memory tables;
quit;
