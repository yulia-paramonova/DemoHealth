*donnez le nom à votre session;
cas yourSession sessopts=(caslib=casuser timeout=1800 locale="en_US");

*assigner l'ensemble de librairies cas;
caslib _all_ assign;


proc casutil;
	load casdata='M5_Final.sashdat' casout='M5_Final' incaslib='Public' outcaslib='Public'; *charger la table en mémoire;
	promote CASDATA='M5_Final' incaslib='PUBLIC' OUTCASLIB='PUBLIC'; *promouvoir la table;
	droptable casdata='M5_FINAL' incaslib='PUBLIC' quiet; *drop la table de mémoire;
	save casdata='M5_Final' incaslib='PUBLIC' outcaslib='PUBLIC' replace; *sauvegarder la table "sur disque";
	quit;



proc cas;
lib="casuser";
tblnm="villes";
*charger la table en mémoire;
	table.loadTable / path=tblnm||".sashdat", caslib=lib, casout={caslib=lib, name=tblnm, replace=TRUE};
*sauvegarder la table "sur disque";
	table.save / caslib=lib name=tblnm||".sashdat" table={name=tblnm, caslib=lib} replace=true;
*promouvoir la table;
	table.promote / name=tblnm, caslib=lib, target=tblnm, targetLib=lib;
*delete source (sashdat);
	table.deleteSource / caslib=lib source=tblnm||".sashdat" ;
*drop la table de mémoire;
	table.dropTable / caslib=lib, name=tblnm, quiet=TRUE;
quit;


proc cas;
lib="casuser";
	table.fileInfo / caslib=lib; *to see data source files;
	table.tableInfo / caslib=lib; *to see in-memory tables;
quit;

