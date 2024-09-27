data CASUSER.EFFECTIFS;*195428 lignes;
   set OPENDATA.EFFECTIFS; *568669 lignes;
   where sexe eq 9;
run;

data CASUSER.EFFECTIFS; *9238 lignes;
   set CASUSER.EFFECTIFS; *9238 lignes;
   where cla_age_5 eq "tsage";
	run;

proc means data=CASUSER.EFFECTIFS ; run; 

proc sql;
%if %sysfunc(exist(CASUSER.Effectifs_geo)) %then %do;
    drop table CASUSER.Effectifs_geo;
%end;
%if %sysfunc(exist(CASUSER.Effectifs_geo,VIEW)) %then %do;
    drop view CASUSER.Effectifs_geo;
%end;
quit;
;
PROC FEDSQL SESSREF=yupsession;
	CREATE TABLE CASUSER."Effectifs_geo" AS
		SELECT
			(t1."annee") AS "annee",
			(t1."patho_niv1") AS "patho_niv1",
			(t1."patho_niv2") AS "patho_niv2",
			(t1."patho_niv3") AS "patho_niv3",
			(t1."top") AS "top",
			(t1."cla_age_5") AS "cla_age_5",
			(t1."sexe") AS "sexe",
			(t1."region") AS "region",
			(t1."dept") AS "dept",
			(t1."Ntop") AS "Ntop",
			(t1."Npop") AS "Npop",
			(t1."prev") AS "prev",
			(t1."Niveau prioritaire") AS "Niveau prioritaire",
			(t1."libelle_classe_age") AS "libelle_classe_age",
			(t1."libelle_sexe") AS "libelle_sexe",
			(t1."tri") AS "tri",
			(t2."ville") AS "ville",
			(t2."latitude") AS "latitude",
			(t2."longitude") AS "longitude",
			(t2."department_name") AS "department_name",
			(t2."department_number") AS "department_number",
			(t2."region_geojson_name") AS "region_geojson_name",
			(t2."CP") AS "CP"
		FROM
			CASUSER."EFFECTIFS" t1
				LEFT JOIN CASUSER."VILLES_PREP" t2 ON (t1."dept" = t2."department_number")
	;
QUIT;
RUN;
PROC CASUTIL SESSREF=yupsession;
ALTERTABLE CASDATA="Effectifs_geo" INCASLIB=CASUSER
COLUMNS={
{
NAME="ville",
FORMAT="$32."},
{
NAME="latitude",
FORMAT="BEST."},
{
NAME="longitude",
FORMAT="BEST."},
{
NAME="department_name",
FORMAT="$24."},
{
NAME="department_number",
FORMAT="BEST."},
{
NAME="region_geojson_name",
FORMAT="$27."}};
QUIT;
RUN;

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
,{label="Niveau prioritaire", name="Niveau prioritaire"}
,{label="Libellé classe d'âge", name="libelle_classe_age"}
,{label="Libellé sexe", name="libelle_sexe"}
}
name="effectifs_geo"
;
quit; 

proc cas; *promote la table dans casuser;
lib="casuser";
table.promote / name="effectifs_geo", caslib=lib, target="effectifs_geo", targetLib=lib;
quit; 

proc cas;
lib="casuser";
/* table.dropTable / caslib=lib, name="effectifs_geo", quiet=TRUE; */
table.dropTable / caslib=lib, name="villes", quiet=TRUE;
table.dropTable / caslib=lib, name="villes_imp_flux", quiet=TRUE;
quit; 
