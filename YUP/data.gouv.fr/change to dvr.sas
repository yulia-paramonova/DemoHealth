proc cas;
	*drop all tables that have a sashdat in a caslib;
	lib="casuser";
	table.tableInfo result=rt / caslib=lib;
	tablelist=rt.tableInfo[, {"Name"}];

	do x over tablelist[1:tablelist.nrows];
		table.dropTable / caslib=lib, name=scan(x.name, 1);
	end;
	table.tableInfo / caslib=lib;
quit;

proc cas;
	/* Load all the tables that do not contain "_DVR" in name */
	lib="casuser";
	table.fileInfo result=rt / caslib=lib;
	describe rt;
* Store the table names from a table in an array *;
	filelist_dvr=rt.fileInfo[, {"Name"}].where(Name contains "_DVR");
	filelist_dvr_ar=filelist_dvr[,"Name"];
	filelist_total=rt.fileInfo[, "Name"];
	filelist= filelist_total-filelist_dvr_ar;
    print filelist_dvr_ar;
    print filelist_total;
    print filelist;

	do x over filelist;
		table.loadTable / path=x, caslib=lib, casout={caslib=lib, 
			name=scan(x, 1), replace=TRUE};
	end;
	table.tableInfo / caslib=lib;
	*to see in-memory tables;
quit;

proc cas;
	/* change to dvr the in memory tables */
	lib="casuser";
	table.fileInfo / caslib=lib;
	table.tableInfo result=rt / caslib=lib;
	tablelist=rt.tableInfo[, {"Name"}];

	do x over tablelist[1:tablelist.nrows];
*copy in dvr format;
		 table.copyTable / table={name=scan(x.name, 1) caslib=lib}
		    casOut={name=scan(x.name, 1)||"_DVR" caslib=lib memoryFormat="DVR" replace=True replication=0};
*save the dvr version of table;
		table.save / caslib=lib name=scan(x.name, 1)||"_DVR.sashdat" table={name=scan(x.name, 1)||"_DVR", caslib=lib} replace=true;
*promote the dvr version;
		table.promote / name=scan(x.name, 1)||"_DVR", caslib=lib, target=scan(x.name, 1)||"_DVR", targetLib=lib;
*drop the non dvr version;
		table.dropTable / caslib=lib, name=scan(x.name, 1), quiet=TRUE;
*delete the non dvr version;
		table.deleteSource / caslib=lib source=scan(x.name, 1)||".sashdat" ;
	end;
	table.tableInfo / caslib=lib;
	table.fileInfo / caslib=lib;

quit;



/*									Size of File in Bytes   MB
sans_doublons.sashdat							7.9297E8	792	
SANS_DOUBLONS_DVR.sashdat						87020512	87

CENTRES_H.sashdat								3177984		3
CENTRES_H_DVR.sashdat							1707656		1.7

DIABETIC_DATA.sashdat							80682264	80
DIABETIC_DATA_DVR.sashdat						12774416	12

VILLES_FRANCE.sashdat							7151296		7
VILLES_FRANCE_DVR.sashdat						3239112		3	
		
effectif_de_patients_filter_DVR.sashdat			56762080	56	
effectif_de_patients_filter.sashdat				5.2049E8	520 */


	


