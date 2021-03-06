IF OBJECT_ID('ref.[USA Delivery]') IS NOT NULL 
BEGIN 
	DROP TABLE ref.[USA Delivery]
END;
-- 1. data is cumulative, so ge the maximum amount of doses delivered each month and convert to BIGINT
WITH table_1 AS (
	SELECT MAX(CAST([Distributed_Janssen] AS BIGINT)) AS j, 
	MAX(CAST(Distributed_Pfizer AS BIGINT)) AS p,
	MAX(CAST(Distributed_Moderna AS BIGINT)) AS m,
	MAX(CAST(Distributed_Unk_Manuf AS BIGINT)) AS x, [Date full month start date]
	FROM raw.[USA Delivery]
	GROUP BY [Date full month start date]
),
-- 2. Since we want monthly totals use the lag function to get the numbers from the previous month.
table_2 AS (
	SELECT j, Lag(j, 1) OVER(ORDER BY [Date full month start date] ASC) AS prev_j,
	p, Lag(p, 1) OVER(ORDER BY [Date full month start date] ASC) AS prev_p,
	m, Lag(m, 1) OVER(ORDER BY [Date full month start date] ASC) AS prev_m,
	x, Lag(x, 1) OVER(ORDER BY [Date full month start date] ASC) AS prev_x,
	[Date full month start date]
	FROM table_1
),
-- 3. Get monthly totals by subtracting the previous months. EX: Apr 2022 - March 2022 for each of the vaccine columns and rename the outputs to match our list of vaccine IDs
-- Keep in mind that doses that are not explicitly assigned a vaccine ID recieve the vaccine ID 'XX'
table_3 AS (
	SELECT  (j-prev_j) AS [58], (m-prev_m) AS [65], (p-prev_p) AS [13],
	CASE WHEN (x-prev_x) < 0 THEN 0 ELSE (x-prev_x) END AS [XX],
	[Date full month start date]
	from table_2
)
-- 4. Add in Country and source specific data to the table
-- 5. Create a column 'Doses Delivered' and unpivot the Vaccine IDs from column names to row values.
SELECT 'USA' AS ISO, 'USA' AS [Recipient], 264 AS [CountryID], 
CONCAT(FORMAT([Date full month start date], 'MMM'), SPACE(1), DATEPART(year, [Date full month start date])) AS [Month],
[Date full month start date] AS [Delivery Date], [Vaccine ID], [Doses Delivered],
'https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-Jurisdi/unsk-b7fc' AS [Delivery Source],
NULL AS [Deal ID], NULL AS [Donation ID], NULL AS [Sub Deal ID], NULL AS [Secured Doses], NULL AS [Doses],
NULL AS [Update Date], 'Commercial' AS [Delivery Type], NULL AS [Comment], NULL AS [Mechanism]
FROM table_3
UNPIVOT
(
[Doses Delivered]
FOR [Vaccine ID] in ([58], [65], [13], [XX])
) u;