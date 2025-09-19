/* 1) Vytvoření primární tabulky s daty o mzdách a cenách potravin za Českou republiku. 
 */

CREATE TABLE t_magdalena_lorencova_project_SQL_primary_final 
	(ID serial PRIMARY KEY,
    Year int,
    Quarter int,
    Avg_wage int,
    industry_branch VARCHAR(255),
    food_price_per_quarter float,
    food VARCHAR(50)
);

WITH afpq AS ( 
	SELECT afp.year, afp.quarter, avg (afp.food_price) AS food_price_per_quarter, afp.food_code
	FROM (
		SELECT cpa.payroll_year AS year, cpa.payroll_quarter AS quarter, cpr.value AS food_price, cpr.category_code AS food_code
			FROM czechia_payroll cpa 
			LEFT JOIN czechia_price cpr
				ON cpa.payroll_year = date_part ('year', cpr.date_from)
				AND cpa.payroll_quarter = 
					CASE 
						WHEN date_part('month', cpr.date_from) IN (1,2,3) THEN 1
						WHEN date_part('month', cpr.date_from) IN (4,5,6) THEN 2
						WHEN date_part('month', cpr.date_from) IN (7,8,9) THEN 3
						WHEN date_part('month', cpr.date_from) IN (10,11,12) THEN 4
					END	
			WHERE cpa.value_type_code = 5958 
				AND cpa.payroll_year BETWEEN 2006 AND 2018
				UNION 
			SELECT cpa.payroll_year AS year, cpa.payroll_quarter AS quarter, cpr.value AS food_price, cpr.category_code AS food_code
			FROM czechia_payroll cpa 
			LEFT JOIN czechia_price cpr
				ON cpa.payroll_year = date_part ('year', cpr.date_from)
				AND cpa.payroll_quarter = 
					CASE 
						WHEN date_part('month', cpr.date_to) IN (1,2,3) THEN 1
						WHEN date_part('month', cpr.date_to) IN (4,5,6) THEN 2
						WHEN date_part('month', cpr.date_to) IN (7,8,9) THEN 3
						WHEN date_part('month', cpr.date_to) IN (10,11,12) THEN 4
					END	
			WHERE cpa.value_type_code = 5958
				AND cpa.payroll_year BETWEEN 2006 AND 2018
	) AS afp
	GROUP BY afp.year, afp.quarter, afp.food_code
	)
INSERT INTO t_magdalena_lorencova_project_sql_primary_final 
(Year,
 Quarter,
 Avg_wage,
 industry_branch,
 food_price_per_quarter,
 food) -- Dodala jsem výčet sloupců. Bez toho se mi to pokoušelo 
 	-- zapsat hodnoty i do sloupce id s PRIMARY KEY.
SELECT cpa.payroll_year AS Year,
	cpa.payroll_quarter AS Quarter,
	cpa.value AS Avg_wage,
	cpib.name AS industry_branch,
	afpq.food_price_per_quarter AS food_price_per_quarter,
	cpc.name AS food
FROM czechia_payroll cpa
LEFT JOIN czechia_payroll_industry_branch cpib
	ON cpa.industry_branch_code = cpib.code
LEFT JOIN afpq
	ON afpq.year = cpa.payroll_year AND afpq.quarter = cpa.payroll_quarter
LEFT JOIN czechia_price_category cpc 
 ON afpq.food_code = cpc.code
WHERE cpa.value_type_code = 5958 
	AND cpa.payroll_year BETWEEN 2006 AND 2018 
	AND cpa.calculation_code = 200
;

;
/* 2) Vytvoření pomocné tabulku s HDP, GINI koeficientem a populací 
 * dalších evropských států za roky 2006-2018. 
*/

CREATE TABLE t_magdalena_lorencova_project_sql_secondary_final 
(ID serial PRIMARY KEY,
	YEAR int,
	country varchar(50),
	population float,
	gini float,
	gdp float,
	taxes float)
;
INSERT INTO t_magdalena_lorencova_project_sql_secondary_final 
	(YEAR,
	country,
	population,
	gini,
	gdp,
	taxes)
SELECT 
	e.YEAR,
	e.country,
	e.population,
	e.gini,
	e.gdp,
	e.taxes
FROM economies e
LEFT JOIN countries c 
	ON c.country = e.country
WHERE e.year BETWEEN 2006 AND 2018
	AND c.continent = 'Europe'
;

