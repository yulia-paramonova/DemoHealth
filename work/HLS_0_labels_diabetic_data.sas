proc cas; * ajouter des labels;
table.alterTable /
caslib="public"
columns={{label="Nombre de tests laboratoires" , name="num_lab_procedures"}
				,{label="Nombre de prescriptions" , name="num_medications"}
				,{label="Nombre de procédures" , name="num_procedures"}
				,{label="Nombre de diagnostics" , name="number_diagnoses"}
				,{label="Nombre de visites aux urgences" , name="number_emergency"}
				,{label="Nombre d'hospitalisations" , name="number_inpatient"}
				,{label="Nombre de visites ambulatoires" , name="number_outpatient"}
				,{label="Réadmis" , name="readmitted"}
				,{label="ID admission" , name="encounter_id"}
				,{label="ID patient" , name="patient_nbr"}
				,{label="Race" , name="race"}
				,{label="Genre" , name="gender"}
				,{label="Age" , name="age"}
				,{label="Spécialité médicale" , name="medical_specialty"}				
				,{label="Temps d'hospitalisation" , name="time_in_hospital"}
				,{label="Prescription de médicaments contre le diabète" , name="diabetesMed"}
				,{label="Changement de médicaments contre le diabète" , name="change"}
}
name="FRAYUP_DIABETIC_DATA"
;
quit; 

