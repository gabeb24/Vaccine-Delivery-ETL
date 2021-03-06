# Vaccine-Delivery-ETL
The purpose of this project was to locate publicly available manufacturer level Covid-19 Vaccine Delivery data sources and create ETL pipelines using SQL Server in conjunction with the business intelligence tool Pyramid Analytics. The outputs of these ETL processes in conjunction with media monitoring data are the backend database of the UNICEF COVID-19 Vaccine Market Dashboard https://www.unicef.org/supply/covid-19-vaccine-market-dashboard. As of April 21, 2022 around 11 billion Covid-19 doses have been delivered globally and this project assigns approximately 4 billion or 36% of those doses to a manufacturer. 
### Brief Summary of ETL Process
1. Extract data from web (Done in Pyramid Analytics) (See source data documentation file)
2. Conduct simple data preprocessing (Done in Pyramid Analytics). For step-by-step documentation & outputs of this step of data see processed data folder.
3. Send partially preprocessed data to SQL Server (raw database schema) (Done in Pyramid Analytics). See processed data folder
4. Write SQL query for complex data manipulation to create reference tables.
