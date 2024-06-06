/*  Transfert de données d'un serveur à un autre */

options cashost='sas-cas-server-default-client' casport=5570;
cas mysession1;
libname casuser1 cas caslib='casuser';

options cashost='sas-cas-server-shared-epic-client' casport=5570;
cas mysession2;
libname casuser2 cas caslib='casuser';

data CAFRANCE.CENTRES_H;
set CASUSER1.CENTRES_H;
run; 
data CAFRANCE.VILLES_FRANCE;
set CASUSER1.VILLES_FRANCE;
run; 
data CAFRANCE.DIABETIC_DATA;
set CASUSER1.DIABETIC_DATA;
run; 

proc casutil;
	promote CASDATA='CENTRES_H' incaslib='CAFRANCE' OUTCASLIB='CAFRANCE';
	save casdata='CENTRES_H.sashdat' incaslib='CAFRANCE' outcaslib='CAFRANCE' replace;
	promote CASDATA='VILLES_FRANCE' incaslib='CAFRANCE' OUTCASLIB='CAFRANCE';
	save casdata='VILLES_FRANCE.sashdat' incaslib='CAFRANCE' outcaslib='CAFRANCE' replace;
	promote CASDATA='DIABETIC_DATA' incaslib='CAFRANCE' OUTCASLIB='CAFRANCE';
	save casdata='DIABETIC_DATA.sashdat' incaslib='CAFRANCE' outcaslib='CAFRANCE' replace;
	quit;

proc cas;
session mysession2;
	lib="cafrance";
	table.fileInfo / caslib=lib;
	table.tableInfo / caslib=lib;
	*to see in-memory tables;
quit;

proc cas; *Saving and Dropping CAS Tables;
table.save /
    table={caslib="caslib-name",
               name="table-name"},
     caslib="target-caslib", name="file-name.ext";
quit;

proc cas; *promotes;
session mysession2;
table.promote /
     name="CENTRES_H",
     caslib="CAFRANCE",
     target="CENTRES_H",
     targetLib="CAFRANCE";
quit; 

