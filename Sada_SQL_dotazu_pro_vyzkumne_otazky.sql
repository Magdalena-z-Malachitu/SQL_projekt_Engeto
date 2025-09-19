/* 
 	1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */
 
SELECT DISTINCT -- Používám DISTINCT, abych odfiltrovala duplicity způsobené tím, 
		-- že v původní tabulce jsou také průměrné ceny pro 27 kategorií jídla.
	tmlpspf.year,
	tmlpspf2.year AS previous_YEAR,
	round(avg(tmlpspf.avg_wage),2) AS avg_wage,
	round(avg(tmlpspf2.avg_wage),2) AS previous_avg_wage,
	tmlpspf.industry_branch,
	CASE 
		 WHEN avg(tmlpspf.avg_wage) > avg(tmlpspf2.avg_wage) THEN 'up'
		 WHEN avg(tmlpspf.avg_wage) < avg(tmlpspf2.avg_wage) THEN 'down'
		 ELSE 'n/a'
	 END AS raise_or_decrease
FROM t_magdalena_lorencova_project_sql_primary_final tmlpspf 
LEFT JOIN t_magdalena_lorencova_project_sql_primary_final tmlpspf2
	ON tmlpspf."year" = tmlpspf2."year"+1 
	AND tmlpspf.industry_branch = tmlpspf2.industry_branch 
	AND tmlpspf.quarter = tmlpspf2.quarter
WHERE CASE 
		 WHEN tmlpspf.avg_wage > tmlpspf2.avg_wage THEN 'up'
		 WHEN tmlpspf.avg_wage < tmlpspf2.avg_wage THEN 'down'
		 ELSE 'n/a'
	 END  != 'up' -- Vyřadím DATA, která ukazují očekávaný růst mezd. 
	 AND tmlpspf2."year" IS NOT NULL -- Vyřadím DATA, pro která nemám předchozí rok pro srovnání.
GROUP BY tmlpspf.year,
		tmlpspf2.year,
		tmlpspf.industry_branch
ORDER BY tmlpspf.industry_branch,
	tmlpspf."year"
;

/* Závěr: V některých odvětvích došlo v průběhu let k poklesu mezd. 
 * Jedná se o 63 případů z 260, což je velmi výrazné množství. Seznam konkrétních odvětví spolu 
 * s lety, kdy k poklesu došlo, je možné si zobrazit prostřednictvím dotazu výše.
 */

 /* 
  	2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a 
 	poslední srovnatelné období v dostupných datech cen a mezd?
 */	
 Select *,
 	round ((fi.avg_wage / fi.food_price_per_quarter) :: numeric, 2) food_per_wage
 	-- Dopočítám si do nového sloupce kolik potraviny bych si za průměrnou výplatu mohla koupit.
 FROM t_magdalena_lorencova_project_sql_primary_final fi
 WHERE (food ILIKE '%mléko%' OR food ILIKE '%chléb%') -- Vyberu pouze hodnoty pro chléb a mléko.
 	AND ((fi.YEAR = 2006 AND fi.quarter = 1) OR (fi.YEAR = 2018 AND fi.quarter = 4) )
 	-- Omezím sledovaná období na první kvartál 2006 a poslední kvartál 2018 (první a poslední srovnatelné období).
ORDER BY fi.YEAR, fi.quarter ASC
;

/* Závěr: výsledná tabulka ukazuje, kolik kilogramů chleba a litrů mléka bylo možné si koupit za průměrný plat 
 * v různých odvětvích v prvním čtvrtletí roku 2006 a posledním čtvrtletí roku 2018. */

 /*
 	3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší 
 	percentuální meziroční nárůst)? 
 */
WITH ppd AS ( -- Nejdřív jsem si spočítala percentuální nárůsty mezi jednotlivými roky pro jednotlivé kategorie potreavin.
SELECT 
	fi.food,
	fi.YEAR,
	round (avg(fi.food_price_per_quarter)::numeric, 2) AS avg_food_price_for_year,
	fi2.YEAR AS previous_year,
	round (avg(fi2.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price_for_prev_year,
	round((((avg(fi.food_price_per_quarter) - avg(fi2.food_price_per_quarter))/avg(fi.food_price_per_quarter))*100)::numeric,2) AS percentual_price_difference
FROM t_magdalena_lorencova_project_sql_primary_final fi 
LEFT JOIN t_magdalena_lorencova_project_sql_primary_final fi2
	ON fi.food = fi2.food 
	AND fi."year" = fi2.YEAR+1 
GROUP BY fi.YEAR,
	fi.food,
	fi2.YEAR
)
-- Já ale hledám kategorii potravin s nejnižším průměrným meziročním nárůstem ceny za období 2006-2018.
-- Pro větší přehlednost proto použiju původní tabulku ve WITH, podpočítám si průměrný percentuální meziroční růst za celé období a najdu minimum.
SELECT ppd.food,
	round(avg(ppd.percentual_price_difference) :: NUMERIC,2) AS avg_percentual_raise_between_2006_2018
FROM ppd
GROUP BY ppd.food
ORDER BY round(avg(ppd.percentual_price_difference) :: NUMERIC,2) asc
;

/*Závěr: Existuje dokonce několik kategorií potravin, kde došlo v průběhu let 2006-2018 
 * k poklesu cen potravin (rajská jablka, cukr krystalový a konzumní brambory). 
 * K nejpomalejšímu zvyšování ceny docházelo u pšeničného bílého pečiva, v průměru 0,16 % za rok.
 */

/*
4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší 
 	než růst mezd (větší než 10 %)?
*/
SELECT 
	fi.YEAR,
	round (avg(fi.food_price_per_quarter)::numeric, 2) AS avg_food_price_for_year,
	round (avg(fi.avg_wage)::numeric, 2) AS avg_wage_for_year,
	fi2.YEAR AS previous_year,
	round (avg(fi2.food_price_per_quarter)::NUMERIC, 2) AS avg_food_price_for_prev_year,
	round (avg(fi2.avg_wage)::NUMERIC, 2) AS avg_wage_for_prev_year,
	round((((avg(fi.food_price_per_quarter) - avg(fi2.food_price_per_quarter))/avg(fi.food_price_per_quarter))*100)::numeric,2) AS percentual_price_difference,
	round((((avg(fi.avg_wage) - avg(fi2.avg_wage))/avg(fi.avg_wage))*100)::numeric,2) AS percentual_wage_difference,
	    CASE 
        WHEN ((AVG(fi.food_price_per_quarter) - AVG(fi2.food_price_per_quarter)) / AVG(fi.food_price_per_quarter) * 100) 
             - ((AVG(fi.avg_wage) - AVG(fi2.avg_wage)) / AVG(fi.avg_wage) * 100) > 10 
        THEN 'significantly higher'
        ELSE '-'
    END AS foodprice_growth_x_wage_growth
FROM t_magdalena_lorencova_project_sql_primary_final fi 
LEFT JOIN t_magdalena_lorencova_project_sql_primary_final fi2
	ON fi.food = fi2.food 
	AND fi."year" = fi2.YEAR+1 
WHERE fi.YEAR > 2006 -- Odstraním NULL hodnoty plynoucí z toho, že nemám DATA pro předchozí rok.
	AND fi.food NOT ILIKE '%víno%' 
		--Kategorie jakostní víno bíle se meří až od roku 2015. Proto se bez této podmínky pro rok 2015 ukazují NULL hodnoty.
GROUP BY fi.YEAR,
	fi2.YEAR
ORDER BY fi."year"
;

/* Závěr: Pokud uvažujeme průměrné ceny potravin (bez ohledu na kategorii) a průměrné mzdy 
 * (bez zohlednění odvětví), nerostly v žádném roce ceny potravin výrazně rychleji než mzdy.
 */
/*
5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, 
 	pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách 
 	potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
  */	
/*
 * Potřebuju sloupce: 
 * Rok,
 * Nárůst HDP v procentech od minulého roku, 
 * Nárůst cen potravin v procentech od minulého roku,
 * Nárůst mezd v procentech od minulého roku,
 */	
;
SELECT sfi."year",
	sfi.gdp,
	sfi2.YEAR AS prev_year,
	sfi2.gdp AS prev_gdp,
	round (((sfi.gdp-sfi2.gdp)/sfi2.gdp*100) :: NUMERIC,2) AS gdp_perc_raise
FROM t_magdalena_lorencova_project_sql_secondary_final sfi
LEFT JOIN t_magdalena_lorencova_project_sql_secondary_final sfi2
	ON sfi.YEAR =sfi2.YEAR + 1 AND sfi.country = sfi2.country
WHERE sfi.country = 'Czech Republic'
ORDER BY "year" 
;-- získám percentuální nárůst HDP

SELECT fi.YEAR,
	round (avg(fi.food_price_per_quarter)::numeric, 2) AS avg_food_price_for_same_year,
	round (avg(fi.avg_wage)::numeric, 2) AS avg_wage_for_same_year
FROM t_magdalena_lorencova_project_sql_primary_final fi
GROUP BY fi."year"
ORDER BY fi.year
;-- získám průměrné ceny potravin a hodnoty mezd pro každý rok

WITH fpwg AS 
(
SELECT fi.YEAR,
	round (avg(fi.food_price_per_quarter)::numeric, 2) AS avg_food_price,
	round (avg(fi.avg_wage)::numeric, 2) AS avg_wage
FROM t_magdalena_lorencova_project_sql_primary_final fi
GROUP BY fi."year"
ORDER BY fi.YEAR
) 
SELECT fpwg.YEAR,
	fpwg.avg_food_price,
	fpwg.avg_wage,
	fpwg2.YEAR,
	fpwg2.avg_food_price,
	fpwg2.avg_wage,
	round(((fpwg.avg_food_price-fpwg2.avg_food_price)/fpwg2.avg_food_price*100):: NUMERIC,2) AS food_price_perc_raise,
	round(((fpwg.avg_wage-fpwg2.avg_wage)/fpwg2.avg_wage*100):: NUMERIC,2) AS wage_perc_raise
FROM fpwg
LEFT JOIN fpwg fpwg2
	ON fpwg.YEAR = fpwg2.YEAR+1
;-- Dotáhnu si průměrné ceny potravin a mzdy za předchozí rok a dopočítám si percentuální nárůst. 

-- Teď potřebuju propojit průměrný nárůst HDP a nárůst cen a mezd:

WITH gdpraise AS 
(SELECT sfi."year",
	sfi.gdp,
	sfi2.YEAR AS prev_year,
	sfi2.gdp AS prev_gdp,
	round (((sfi.gdp-sfi2.gdp)/sfi2.gdp*100) :: NUMERIC,2) AS gdp_perc_raise
FROM t_magdalena_lorencova_project_sql_secondary_final sfi
LEFT JOIN t_magdalena_lorencova_project_sql_secondary_final sfi2
	ON sfi.YEAR =sfi2.YEAR + 1 AND sfi.country = sfi2.country
WHERE sfi.country = 'Czech Republic'
ORDER BY "year"
),
fpwg AS 
(
SELECT fi.YEAR,
	round (avg(fi.food_price_per_quarter)::numeric, 2) AS avg_food_price,
	round (avg(fi.avg_wage)::numeric, 2) AS avg_wage
FROM t_magdalena_lorencova_project_sql_primary_final fi
GROUP BY fi."year"
ORDER BY fi.YEAR
)
SELECT gdpraise.YEAR,
	gdpraise.gdp_perc_raise,
	round(((fpwg.avg_food_price-fpwg2.avg_food_price)/fpwg2.avg_food_price*100):: NUMERIC,2) AS food_price_perc_raise,
	round(((fpwg.avg_wage-fpwg2.avg_wage)/fpwg2.avg_wage*100):: NUMERIC,2) AS wage_perc_raise
FROM gdpraise
LEFT JOIN fpwg
	ON gdpraise.YEAR = fpwg.YEAR
LEFT JOIN fpwg fpwg2
	ON fpwg.YEAR = fpwg2.YEAR+1
;-- Mám všechny při percentuální nárůsty v jedné tabulce. Teď potřebuju vyhodnotit vzájmené vztahy.

WITH gdpraise AS 
(SELECT sfi."year",
	sfi.gdp,
	sfi2.YEAR AS prev_year,
	sfi2.gdp AS prev_gdp,
	round (((sfi.gdp-sfi2.gdp)/sfi2.gdp*100) :: NUMERIC,2) AS gdp_perc_raise
FROM t_magdalena_lorencova_project_sql_secondary_final sfi
LEFT JOIN t_magdalena_lorencova_project_sql_secondary_final sfi2
	ON sfi.YEAR =sfi2.YEAR + 1 AND sfi.country = sfi2.country
WHERE sfi.country = 'Czech Republic'
ORDER BY "year"
),
fpwg AS 
(
SELECT fi.YEAR,
	round (avg(fi.food_price_per_quarter)::numeric, 2) AS avg_food_price,
	round (avg(fi.avg_wage)::numeric, 2) AS avg_wage
FROM t_magdalena_lorencova_project_sql_primary_final fi
GROUP BY fi."year"
ORDER BY fi.YEAR
)
SELECT gdpraise.YEAR,
	gdpraise.gdp_perc_raise,
	CASE WHEN gdpraise.gdp_perc_raise > 3 THEN 'significant_raise'
		WHEN gdpraise.gdp_perc_raise < 0 THEN 'drop'
		ELSE 'normal' 
		END AS significant_gdp_raise, -- Označím si roky podle toho, zda byl meziroční nárůst v normě nebo ne. Totéž udělám i u cen potravin a mezd.
	round(((fpwg.avg_food_price-fpwg2.avg_food_price)/fpwg2.avg_food_price*100):: NUMERIC,2) AS food_price_perc_raise,
	CASE WHEN ((fpwg.avg_food_price-fpwg2.avg_food_price)/fpwg2.avg_food_price*100) > 5 THEN 'significant_raise'
		WHEN ((fpwg.avg_food_price-fpwg2.avg_food_price)/fpwg2.avg_food_price*100) < 0 THEN 'drop'
		ELSE 'normal' 
		END AS significant_food_price_raise,
	round(((fpwg.avg_wage-fpwg2.avg_wage)/fpwg2.avg_wage*100):: NUMERIC,2) AS wage_perc_raise,
	CASE WHEN ((fpwg.avg_wage-fpwg2.avg_wage)/fpwg2.avg_wage*100) > 5 THEN 'significant_raise'
		WHEN ((fpwg.avg_wage-fpwg2.avg_wage)/fpwg2.avg_wage*100) < 0 THEN 'drop'
		ELSE 'normal' 
		END AS siginificant_wage_raise
FROM gdpraise
LEFT JOIN fpwg
	ON gdpraise.YEAR = fpwg.YEAR
LEFT JOIN fpwg fpwg2
	ON fpwg.YEAR = fpwg2.YEAR+1
WHERE gdpraise.YEAR  > 2006 -- Vyřadím NULL hodnoty pro rok 2006, kde nemám předchozí rok.
	--AND gdpraise.gdp_perc_raise > 3 -- Můžu přidat filtr pro roky s meziročním nárůstem hdp o více než 3 %, ať se mi lépe hledá. (1-3% jsou v ČR obvyklé)
;

/*
 * Zdá se, že v letech 2007 a 2017 došlo s výrazným nárůstem HDP také k výraznémů růstu cen potravin i mezd. 
 * V letech 2015 a 2018 sice HDP výrazněji vzrostlo, ale ceny potravin nikoliv. 
 * V roce 2018 přitom došlo k nejvýraznějšímu meziročnímu nárůstu mezd za posledních 12 let. 
 * Nezdá se, že by výraznější růst HDP přímo působil na ceny potravin nebo mzdy, ale vzorek dat k analýze je příliš malý, aby bylo možno vyvodit nějaký závěr.
 */

/*
 * Úplný závěr: Příště si pořádně pročtu zadání všech otázek a nebudu se při vytváření podkladů trápit menšími časovými jednotkami jako jsou kvartály, 
 * pokud je při dalším zpracování nevyužiju a nebudu si zbytečně komplikovat kód.
 */

