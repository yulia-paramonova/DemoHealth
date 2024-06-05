/* Preparation de données pour la démo : filtrer les tables villes et centres hospitaliers*/
data casuser.villes;
set CASUSER.VILLES_FRANCE;
where upcase(COMPRESS(label)) in('BOURGENBRESSE','LAON','VICHY','DIGNE','NICE','PRIVAS','CHARLEVILLE-MÉZIÈES','FOIX','TROYES','CARCASSONNE','RODEZ','STRASBOURG','M
ARSEILLE','CAEN','AURILLAC','ANGOULÊME','LAROCHELLE','BOURGES','BRIVE','AJACCIO','DIJON','SAINTBRIEUC','GUÉRET','NIORT','PÉRIGUEU
X','BESANÇON','VALENCE','EVRY','EVREUX','CHARTRES','BREST','NÎMES','AUCH','BORDEAUX','COLMAR','BASTIA','TOULOUSE','LEPUY','CHAUMON
T','ANNECY','LIMOGES','GAP','TARBES','NANTERRE','MONTPELLIER','RENNES','CHÂTEAUROUX','TOURS','GRENOBLE','LONSLESAUNIER','MONTDEMARS
AN','SAINTETIENNE','NANTES','BLOIS','ORLÉANS','CAHORS','AGEN','MENDE','ANGERS','SAINT-LÔ','REIMS','LAVAL','NANCY','BARLEDUC','VANN
ES','METZ','NEVERS','LILLE','BEAUVAIS','ALENÇON','PARIS','ARRAS','CLERMONT-FERRAND','PAU','PERPIGNAN','LYON','LYON','MACON','VESOUL
','LEMANS','SAVOIE','MELUN','ROUEN','BOBIGNY','AMIENS','ALBI','MONTAUBAN','BELFORT','PONTOISE','CRÉTEIL','TOULON','AVIGNON','LAROCH
ESURYON','POITIERS','EPINAL','AUXERRE','VERSAILLES');
run; 


data CASUSER.CENTRES (keep=gid Nom_H adr_num adr_voie CP com_nom lat_coor1 long_coor1 num_dep); 
	set CASUSER.CENTRES_H;
	Nom_H=tranwrd(nom,'de Vaccination','Médical');
	Nom_H=tranwrd(Nom_H,'de vaccination','Médical');
	Nom_H=tranwrd(Nom_H,'vaccination','Médical');
	Nom_H=tranwrd(Nom_H,'Vaccination','Médical');
	Nom_H=tranwrd(Nom_H,'Covid-19','');	
	Nom_H=tranwrd(Nom_H,'COVID','');	
	Nom_H=tranwrd(Nom_H,'Covid','');	
	if com_cp<10000
		then CP="0"||compress(put(com_cp,4.));
		else CP=compress(put(com_cp,5.));
	Num_dep = substr(CP,1,2);
where upcase(COMPRESS(com_nom)) in('BOURGENBRESSE','LAON','VICHY','DIGNE','NICE','PRIVAS','CHARLEVILLE-MÉZIÈES','FOIX','TROYES','CARCASSONNE','RODEZ','STRASBOURG','M
ARSEILLE','CAEN','AURILLAC','ANGOULÊME','LAROCHELLE','BOURGES','BRIVE','AJACCIO','DIJON','SAINTBRIEUC','GUÉRET','NIORT','PÉRIGUEU
X','BESANÇON','VALENCE','EVRY','EVREUX','CHARTRES','BREST','NÎMES','AUCH','BORDEAUX','COLMAR','BASTIA','TOULOUSE','LEPUY','CHAUMON
T','ANNECY','LIMOGES','GAP','TARBES','NANTERRE','MONTPELLIER','RENNES','CHÂTEAUROUX','TOURS','GRENOBLE','LONSLESAUNIER','MONTDEMARS
AN','SAINTETIENNE','NANTES','BLOIS','ORLÉANS','CAHORS','AGEN','MENDE','ANGERS','SAINT-LÔ','REIMS','LAVAL','NANCY','BARLEDUC','VANN
ES','METZ','NEVERS','LILLE','BEAUVAIS','ALENÇON','PARIS','ARRAS','CLERMONT-FERRAND','PAU','PERPIGNAN','LYON','LYON','MACON','VESOUL
','LEMANS','SAVOIE','MELUN','ROUEN','BOBIGNY','AMIENS','ALBI','MONTAUBAN','BELFORT','PONTOISE','CRÉTEIL','TOULON','AVIGNON','LAROCH
ESURYON','POITIERS','EPINAL','AUXERRE','VERSAILLES');
run;
