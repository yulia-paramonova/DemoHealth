/* Store the CSV to a temp file. */
filename scrdata temp;
proc http
   url="https://www.data.gouv.fr/fr/datasets/r/5f71ba43-afc8-43a0-b306-dafe29940f9c"
   out=scrdata;                                     
run;

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
      path="%sysfunc(pathname(refile))"
      casOut={caslib="casuser", name="effectif_patients",memoryFormat="DVR"}
      importOptions={fileType="CSV", delimiter=";", getNames=TRUE, guessRows=500,locale="French_France"};
run;

   table.tableInfo /
      caslib="casuser", 
      table="effectif_patients";
quit;

/* One of the column names was over 32 characters so fix that.  */
proc casutil;

   altertable casdata="covdata"  
      columns = 
        {
          {name= "totale_positivi_test_antigenico_rapido" rename="totale_pos_test_antigen_rapido"}
        };

/* Save the file in casuser and promote the table. */
	save casdata="effectif_patients" replace;
	promote casdata="effectif_patients" incaslib="casuser";
quit;

/* Remove the temp file. */
filename scrdata clear;
