%let libr = lib="cafrance"; *added after proc cas;
%let tblnm = tblnm="H_M_articles"; *added after proc cas;
%let lib="cafrance"; *used outside proc cas;
proc casutil; list files incaslib=&lib; run; *physical files information ;
proc cas; &libr ; table.tableInfo / caslib=lib; quit; *in-memory table;


proc casutil;
	load casdata='CENTRES_H_DVR.sashdat' casout='CENTRES_H' incaslib='casuser' 
		outcaslib='cafrance';
	load casdata='DIABETIC_DATA_DVR.sashdat' casout='DIABETIC_DATA' incaslib='casuser' 
		outcaslib='cafrance';
	quit;
