#!/bin/bash

# Define ANSI color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Remove existing files in HDFS directories
hdfs dfs -rm -r /vagrant/TPA/data/*
hdfs dfs -rm -r /vagrant/TPA/hive_tables/*

# Drop existing Hive tables
hive -e "DROP TABLE IF EXISTS catalogue;"
hive -e "DROP TABLE IF EXISTS clients_14;"
hive -e "DROP TABLE IF EXISTS clients_19;"
hive -e "DROP TABLE IF EXISTS co2;"
hive -e "DROP TABLE IF EXISTS immatriculation;"

# Step 1: Add the CSV file to HDFS
hadoop fs -put /vagrant/TPA/data/Catalogue.csv .
hadoop fs -put /vagrant/TPA/data/Clients_14.csv .
hadoop fs -put /vagrant/TPA/data/Clients_19.csv .
hadoop fs -put /vagrant/TPA/data/Co2.csv .
hadoop fs -put /vagrant/TPA/data/Immatriculations.csv .

# Step 2: Create the entities table in Hive and load data
hive -e "
CREATE TABLE IF NOT EXISTS catalogue (
    marque STRING,
    nom STRING,
    puissance INT,
    longueur STRING,
    nbPlaces INT,
    nbPortes INT,
    couleur STRING,
    occasion STRING,
    prix INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/vagrant/TPA/hive_tables/catalogue';

LOAD DATA INPATH './Catalogue.csv' OVERWRITE INTO TABLE catalogue;
"
echo "${GREEN}Importation du catalogue terminée.${NC}"

hive -e "
CREATE TABLE IF NOT EXISTS clients_14 (
    age INT,
    sexe STRING,
    taux INT,
    situationFamiliale STRING,
    nbEnfantsAcharge INT,
    deuxiemeVoiture STRING,
    immatriculation STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/vagrant/TPA/hive_tables/clients_14';

LOAD DATA INPATH './Clients_14.csv' OVERWRITE INTO TABLE clients_14;
"
echo "${GREEN}Importation du fichier Clients_14.csv terminée.${NC}"

hive -e "
DROP TABLE IF EXISTS clients_19;
CREATE TABLE clients_19 (
    age INT,
    sexe STRING,
    taux INT,
    situationFamiliale STRING,
    nbEnfantsAcharge INT,
    deuxiemeVoiture STRING,
    immatriculation STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/vagrant/TPA/hive_tables/clients_19';

LOAD DATA INPATH './Clients_19.csv' OVERWRITE INTO TABLE clients_19;
"
echo "${GREEN}Importation du fichier Clients_19.csv terminée.${NC}"

hive -e "
CREATE TABLE IF NOT EXISTS co2 (
    idCsv INT,
    marqueModele STRING,
    bonusMalus STRING,
    rejetsCO2 INT,
    coutEnergie STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/vagrant/TPA/hive_tables/co2';

LOAD DATA INPATH './Co2.csv' OVERWRITE INTO TABLE co2;
"
echo "${GREEN}Importation du co2 terminée.${NC}"

hive -e "
CREATE TABLE IF NOT EXISTS immatriculation (
    immatriculation STRING,
    marque STRING,
    nom STRING,
    puissance INT,
    longueur STRING,
    nbPlaces INT,
    nbPortes INT,
    couleur STRING,
    occasion STRING,
    prix INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/vagrant/TPA/hive_tables/immatriculation';

LOAD DATA INPATH './Immatriculations.csv' OVERWRITE INTO TABLE immatriculation;
"
echo "${GREEN}Importation d'immatriculation terminée.${NC}"

echo "JOB DONE"