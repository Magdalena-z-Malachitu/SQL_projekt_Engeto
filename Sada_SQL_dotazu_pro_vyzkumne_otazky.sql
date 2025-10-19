-- Výpočet průměrných mezd za rok
WITH clearing_values_wages AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.avg_wage,
        pfi.industry_branch
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
)
SELECT 
    cvw.year,
    ROUND(AVG(cvw.avg_wage)::NUMERIC, 2) AS avg_wage,
    LAG(cvw.year) OVER (
        PARTITION BY cvw.industry_branch
        ORDER BY cvw.year
    ) AS prev_year,
    LAG(ROUND(AVG(cvw.avg_wage)::NUMERIC, 2)) OVER (
        PARTITION BY cvw.industry_branch
        ORDER BY cvw.year
    ) AS prev_year_avg_wage,
    cvw.industry_branch
FROM clearing_values_wages cvw
GROUP BY 
    cvw.year,
    cvw.industry_branch
;

-- Výpočet průměrných cen potravin za rok
WITH clearing_values_food AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.food_price_per_quarter,
        pfi.food
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
)
SELECT 
    cvf.year,
    ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price,
    LAG(cvf.year) OVER (
        PARTITION BY cvf.food
        ORDER BY cvf.year
    ) AS prev_year,
    LAG(ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2)) OVER (
        PARTITION BY cvf.food
        ORDER BY cvf.year
    ) AS prev_year_avg_food_price,
    cvf.food
FROM clearing_values_food cvf
GROUP BY 
    cvf.year,
    cvf.food
;

/* 
 	1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */
WITH clearing_values_wages AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.avg_wage,
        pfi.industry_branch
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
avg_wages_per_year AS (
    SELECT 
        cvw.year,
        ROUND(AVG(cvw.avg_wage)::NUMERIC, 2) AS avg_wage,
        LAG(cvw.year) OVER (
            PARTITION BY cvw.industry_branch
            ORDER BY cvw.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvw.avg_wage)::NUMERIC, 2)) OVER (
            PARTITION BY cvw.industry_branch
            ORDER BY cvw.year
        ) AS prev_year_avg_wage,
        cvw.industry_branch
    FROM clearing_values_wages cvw
    GROUP BY 
        cvw.year,
        cvw.industry_branch
)
SELECT 
    *,
    CASE 
        WHEN awy.avg_wage > awy.prev_year_avg_wage THEN 'up'
        WHEN awy.avg_wage < awy.prev_year_avg_wage THEN 'down'
        ELSE 'n/a'
    END AS raise_or_decrease
FROM avg_wages_per_year awy
WHERE awy.prev_year IS NOT NULL
;

/*
  	2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a 
 	poslední srovnatelné období v dostupných datech cen a mezd?
 */	

WITH clearing_values_wages AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.avg_wage,
        pfi.industry_branch
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
avg_wages_per_year AS (
    SELECT 
        cvw.year,
        ROUND(AVG(cvw.avg_wage)::NUMERIC, 2) AS avg_wage,
        LAG(cvw.year) OVER (
            PARTITION BY cvw.industry_branch
            ORDER BY cvw.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvw.avg_wage)::NUMERIC, 2)) OVER (
            PARTITION BY cvw.industry_branch
            ORDER BY cvw.year
        ) AS prev_year_avg_wage,
        cvw.industry_branch
    FROM clearing_values_wages cvw
    GROUP BY 
        cvw.year,
        cvw.industry_branch
),
clearing_values_food AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.food_price_per_quarter,
        pfi.food
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
average_food_prices_per_year AS (
    SELECT 
        cvf.year,
        ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price,
        LAG(cvf.year) OVER (
            PARTITION BY cvf.food
            ORDER BY cvf.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2)) OVER (
            PARTITION BY cvf.food
            ORDER BY cvf.year
        ) AS prev_year_avg_food_price,
        cvf.food
    FROM clearing_values_food cvf
    GROUP BY 
        cvf.year,
        cvf.food
)
SELECT 
    awy.year,
    awy.avg_wage,
    awy.industry_branch,
    afpy.avg_food_price,
    afpy.food,
    ROUND(awy.avg_wage / afpy.avg_food_price, 2) AS food_per_wage
FROM avg_wages_per_year awy
LEFT JOIN average_food_prices_per_year afpy
    ON awy.year = afpy.year
WHERE 
    (afpy.food ILIKE 'chléb%' OR afpy.food ILIKE 'mléko%')
    AND (awy.year = 2006 OR awy.year = 2018)
;

-- Bez ohledu na odvětví
WITH clearing_values_wages AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.avg_wage,
        pfi.industry_branch
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
clearing_values_food AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.food_price_per_quarter,
        pfi.food
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
average_food_prices_per_year AS (
    SELECT 
        cvf.year,
        ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price,
        LAG(cvf.year) OVER (
            PARTITION BY cvf.food
            ORDER BY cvf.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2)) OVER (
            PARTITION BY cvf.food
            ORDER BY cvf.year
        ) AS prev_year_avg_food_price,
        cvf.food
    FROM clearing_values_food cvf
    GROUP BY 
        cvf.year,
        cvf.food
)
SELECT 
    afpy.year,
    afpy.avg_food_price,
    afpy.food,
    ROUND(AVG(cvw.avg_wage)::NUMERIC, 2) AS avg_wage,
    ROUND(AVG(cvw.avg_wage)::NUMERIC / afpy.avg_food_price, 2) AS food_per_wage
FROM average_food_prices_per_year afpy
LEFT JOIN clearing_values_wages cvw
    ON afpy.year = cvw.year
WHERE 
    (afpy.food ILIKE 'chléb%' OR afpy.food ILIKE 'mléko%')
    AND (afpy.year = 2006 OR afpy.year = 2018)
GROUP BY 
    afpy.year,
    afpy.avg_food_price,
    afpy.food
;

 /*
 	3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší 
 	percentuální meziroční nárůst)? 
 */

WITH clearing_values_food AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.food_price_per_quarter,
        pfi.food
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
average_food_prices_per_year AS (
    SELECT 
        cvf.year,
        ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price,
        LAG(cvf.year) OVER (
            PARTITION BY cvf.food
            ORDER BY cvf.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2)) OVER (
            PARTITION BY cvf.food
            ORDER BY cvf.year
        ) AS prev_year_avg_food_price,
        cvf.food
    FROM clearing_values_food cvf
    GROUP BY 
        cvf.year,
        cvf.food
),
percentual_price_difference_per_year AS (
    SELECT 
        afpy.year,
        afpy.food,
        ROUND(((afpy.avg_food_price - afpy.prev_year_avg_food_price) / afpy.avg_food_price) * 100::NUMERIC, 2) AS percentual_price_difference
    FROM average_food_prices_per_year afpy
)
SELECT 
    afpy.food,
    ROUND(AVG(ppdy.percentual_price_difference), 2) AS percentual_price_difference_2006_18
FROM average_food_prices_per_year afpy
LEFT JOIN percentual_price_difference_per_year ppdy
    ON afpy.year = ppdy.year AND afpy.food = ppdy.food
GROUP BY 
    afpy.food
;

/*
4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší 
 	než růst mezd (větší než 10 %)?
*/

WITH clearing_values_food AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.food_price_per_quarter,
        pfi.food
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
average_food_prices_per_year_no_food AS (
    SELECT 
        cvf.year,
        ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price,
        LAG(cvf.year) OVER (
            ORDER BY cvf.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2)) OVER (
            ORDER BY cvf.year
        ) AS prev_year_avg_food_price
    FROM clearing_values_food cvf
    GROUP BY 
        cvf.year
),
percentual_price_difference_per_year AS (
    SELECT 
        afpynf.year,
        ROUND(((afpynf.avg_food_price - afpynf.prev_year_avg_food_price) / afpynf.avg_food_price) * 100::NUMERIC, 2) AS percentual_price_difference
    FROM average_food_prices_per_year_no_food afpynf
),
clearing_values_wages AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.avg_wage,
        pfi.industry_branch
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
avg_wages_per_year_no_branch AS (
    SELECT 
        cvw.year,
        ROUND(AVG(cvw.avg_wage)::NUMERIC, 2) AS avg_wage,
        LAG(cvw.year) OVER (
            ORDER BY cvw.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvw.avg_wage)::NUMERIC, 2)) OVER (
            ORDER BY cvw.year
        ) AS prev_year_avg_wage
    FROM clearing_values_wages cvw
    GROUP BY 
        cvw.year
),
percentual_wage_difference_per_year AS (
    SELECT 
        awynb.year,
        ROUND(((awynb.avg_wage - awynb.prev_year_avg_wage) / awynb.avg_wage) * 100::NUMERIC, 2) AS percentual_wage_difference
    FROM avg_wages_per_year_no_branch awynb
)
SELECT 
    afpynf.year,
    ppdy.percentual_price_difference AS percentual_food_price_difference,
    pwdy.percentual_wage_difference,
    ppdy.percentual_price_difference - pwdy.percentual_wage_difference AS percentual_price_x_wage_difference,
    CASE 
        WHEN ppdy.percentual_price_difference - pwdy.percentual_wage_difference > 10 THEN 'significantly higher'
        ELSE '-'
    END AS foodprice_growth_x_wage_growth
FROM average_food_prices_per_year_no_food afpynf
LEFT JOIN avg_wages_per_year_no_branch awynb
    ON afpynf.year = awynb.year
LEFT JOIN percentual_price_difference_per_year ppdy
    ON ppdy.year = afpynf.year
LEFT JOIN percentual_wage_difference_per_year pwdy
    ON pwdy.year = afpynf.year
WHERE afpynf.year > 2006
;

/*
5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, 
 	pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách 
 	potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
  */	

WITH clearing_values_food AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.food_price_per_quarter,
        pfi.food
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
average_food_prices_per_year_no_food AS (
    SELECT 
        cvf.year,
        ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price,
        LAG(cvf.year) OVER (
            ORDER BY cvf.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvf.food_price_per_quarter)::NUMERIC, 2)) OVER (
            ORDER BY cvf.year
        ) AS prev_year_avg_food_price
    FROM clearing_values_food cvf
    GROUP BY 
        cvf.year
),
percentual_price_difference_per_year AS (
    SELECT 
        afpynf.year,
        ROUND(((afpynf.avg_food_price - afpynf.prev_year_avg_food_price) / afpynf.avg_food_price) * 100::NUMERIC, 2) AS percentual_price_difference
    FROM average_food_prices_per_year_no_food afpynf
),
clearing_values_wages AS (
    SELECT DISTINCT 
        pfi.year,
        pfi.avg_wage,
        pfi.industry_branch
    FROM t_magdalena_lorencova_project_sql_primary_final pfi
),
avg_wages_per_year_no_branch AS (
    SELECT 
        cvw.year,
        ROUND(AVG(cvw.avg_wage)::NUMERIC, 2) AS avg_wage,
        LAG(cvw.year) OVER (
            ORDER BY cvw.year
        ) AS prev_year,
        LAG(ROUND(AVG(cvw.avg_wage)::NUMERIC, 2)) OVER (
            ORDER BY cvw.year
        ) AS prev_year_avg_wage
    FROM clearing_values_wages cvw
    GROUP BY 
        cvw.year
),
percentual_wage_difference_per_year AS (
    SELECT 
        awynb.year,
        ROUND(((awynb.avg_wage - awynb.prev_year_avg_wage) / awynb.avg_wage) * 100::NUMERIC, 2) AS percentual_wage_difference
    FROM avg_wages_per_year_no_branch awynb
),
clearing_GDP_values AS (
    SELECT 
        sfi.year,
        ROUND(sfi.gdp::NUMERIC, 2) AS GDP,
        LAG(sfi.year) OVER (
            ORDER BY sfi.year
        ) AS prev_year,
        ROUND(LAG(sfi.gdp) OVER (
            ORDER BY sfi.year
        )::NUMERIC, 2) AS prev_year_GDP
    FROM t_magdalena_lorencova_project_sql_secondary_final sfi
    WHERE sfi.country = 'Czech Republic'
),
percentual_GDP_raise AS (
    SELECT 
        cgv.year,
        cgv.GDP,
        cgv.prev_year_GDP,
        ROUND(((cgv.GDP - cgv.prev_year_GDP) / cgv.prev_year_GDP) * 100::NUMERIC, 2) AS percentual_GDP_raise
    FROM clearing_GDP_values cgv
)
SELECT 
    pgr.year,
    pgr.percentual_GDP_raise,
    CASE 
        WHEN pgr.percentual_GDP_raise > 3 THEN 'significant_raise'
        WHEN pgr.percentual_GDP_raise < 0 THEN 'drop'
        ELSE 'normal'
    END AS significant_GDP_raise,
    pwdy.percentual_wage_difference,
    CASE 
        WHEN pwdy.percentual_wage_difference > 5 THEN 'significant_raise'
        WHEN pwdy.percentual_wage_difference < 0 THEN 'drop'
        ELSE 'normal'
    END AS significant_wages_raise,
    ppdy.percentual_price_difference,
    CASE 
        WHEN ppdy.percentual_price_difference > 5 THEN 'significant_raise'
        WHEN ppdy.percentual_price_difference < 0 THEN 'drop'
        ELSE 'normal'
    END AS significant_food_prices_raise
FROM percentual_GDP_raise pgr
LEFT JOIN percentual_wage_difference_per_year pwdy
    ON pwdy.year = pgr.year
LEFT JOIN percentual_price_difference_per_year ppdy
    ON ppdy.year = pgr.year
WHERE pgr.year != 2006
;

