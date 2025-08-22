/*
#Projekt z SQL#

##Úvod do projektu##
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, 
jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují 
**dostupnost základních potravin široké veřejnosti**. Kolegové již vydefinovali základní otázky, 
na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude 
výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět 
**porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období**.

Jako dodatečný materiál připravte i **tabulku s HDP, GINI koeficientem a populací dalších 
evropských států ve stejném období**, jako primární přehled pro ČR.

*Datové sady, které je možné požít pro získání vhodného datového podkladu
Primární tabulky:

czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
Číselníky sdílených informací o ČR:

czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
czechia_district – Číselník okresů České republiky dle normy LAU.
Dodatečné tabulky:

countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.
*

##Výzkumné otázky##
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období 
v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd 
(větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji 
v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce 
výraznějším růstem?
﻿

##Výstupy z projektu##
Pomozte kolegům s daným úkolem. Výstupem by měly být dvě tabulky v databázi, ze kterých se 
požadovaná data dají získat. Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final 
(pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – 
společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších 
evropských státech).

Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení 
na vytyčené výzkumné otázky. Pozor, otázky/hypotézy mohou vaše výstupy podporovat i vyvracet! 
Záleží na tom, co říkají data.

Na svém GitHub účtu vytvořte veřejný repozitář, kam uložíte všechny informace k projektu – 
hlavně SQL skript generující výslednou tabulku, popis mezivýsledků (průvodní listinu) 
ve formátu markdown (.md) a informace o výstupních datech (například kde chybí hodnoty apod.).

Neupravujte data v primárních tabulkách! Pokud bude potřeba transformovat hodnoty, dělejte tak 
až v tabulkách nebo pohledech, které si nově vytváříte.
 */
/*
##Příprava podkladů ##
1. *Poptřebuju připojit czechia_payroll cpa na czechia_price cpr i přes rozdílné časové údaje.
cpa měří průměrnou hrubou mzdu čtvrtletně, v letech 2000–2021.   
cpr má údaje o cennách měřené po týdnech, v letech 2006–2018.
Převedu tedy pdaje z týdnů na kvartály.
*/
SELECT 
	min (cpa.payroll_year), -- zjištění časového rozsahu dat (2000–2021)
	max (cpa.payroll_year)
FROM czechia_payroll cpa
;
SELECT min (cpr.date_from), -- zjištění časového rozsahu dat (2006–2018)
	max (cpr.date_to)
FROM czechia_price cpr
;

/* Týdny nebudou většinou odpovídat kvartálům. (Čtyřikrát ročně se může vyskytnout přechodový 
 * týden.) Společný jmenovatel by mohl být kalendářní den, ale je rozdíl v cenách mezi týdny 
 * natolik velký, aby bylo nutné ho zohlednit?
 */

SELECT  DISTINCT cpr.date_from, cpr.date_to
FROM czechia_price cpr 
WHERE date_part ('MONTH', cpr.date_from) != date_part ('month', cpr.date_to) 
		AND (date_part ('MONTH', cpr.date_from)) IN (03,06,09,12)
ORDER BY date_from desc
;
/* Vyfiltrovala jsem přechodové týdny mezi kvartály, abych zjistila o jak velký počet týdnů
se jedná. Předpokládala jsem 2–4 týdny za rok. Ale našla jsem jich pouze 7 celkem, 
a od roku 2009 žádný. 
*/

SELECT DISTINCT cpr.category_code
FROM czechia_price cpr
;-- 27 kategorií potravin

SELECT DISTINCT cpr.region_code 
FROM czechia_price cpr
;--15 regionů

SELECT 52*27*15 -- (týdny v roce * kategorie * region) -- 21060
;

SELECT COUNT(*)
FROM czechia_price
WHERE date_part('year', date_from) = 2006
; -- 4515

/***Ověření na roce 2011**
 * V cpr je 27 různých kategorií potravin a 15 regiónů. Předpokládaný počet řádků v tabulce 
 * za jeden rok (zhruba 52 týdnů) by byl asi 21 060. Za rok 2011 je jich 4515.
 */
SELECT DISTINCT cpr.date_from
FROM czechia_price cpr
WHERE date_part('year', date_from) = 2011
ORDER BY cpr.date_from asc;

/* Rok 2011 obsahuje záznamy pouze za 12 týdnů, 1 za každý měsíc. Data jsou nepravidelná.
 * Stále mě zajímá, zda mám zohlednit přechodové týdny mezi kvartály.*/

SELECT *, -- pro všechny týdny
	CASE 
	    WHEN cpr.value = 0 THEN NULL
	    ELSE ((cpr2.value - cpr.value) / cpr.value) * 100
	END AS value_diff_percent
FROM czechia_price cpr
CROSS JOIN czechia_price cpr2
WHERE date_part('MONTH', cpr.date_from) IN (3, 6, 9, 12)
	AND 
	cpr2.date_from = cpr.date_from + INTERVAL '7 days'
	AND cpr.category_code = cpr2.category_code 
	AND cpr.region_code =cpr2.region_code
	-- Cenový skok mezi jednotlivými týdny může být vlastně dost značný, až 82 % v jednom případě.
ORDER BY value_diff_percent DESC
-- 11 953 řádků
;
SELECT *, -- pouze přechodové týdny, rozdíl v cenách vychází až 31 % v nejhorším případě 
	CASE 
	    WHEN cpr.value = 0 THEN NULL
	    ELSE ((cpr2.value - cpr.value) / cpr.value) * 100
	END AS value_diff_percent
FROM czechia_price cpr
CROSS JOIN czechia_price cpr2
WHERE date_part ('MONTH', cpr.date_from) != date_part ('month', cpr.date_to) 
		AND date_part('MONTH', cpr.date_from) IN (3, 6, 9, 12)
	AND 
	cpr2.date_from = cpr.date_from + INTERVAL '7 days'
	AND cpr.category_code = cpr2.category_code 
	AND cpr.region_code =cpr2.region_code
ORDER BY value_diff_percent desc
-- row count 1 750 - to je málo oproti celkovému počtu přechodových týdů (2625, viz níž)
;

SELECT  * -- vyfiltrované pouze přechodové týdny
FROM czechia_price cpr 
WHERE date_part ('MONTH', cpr.date_from) != date_part ('month', cpr.date_to) 
		AND (date_part ('MONTH', cpr.date_from)) IN (03,06,09,12)
ORDER BY date_from DESC
-- row count 2625
;

SELECT cpr.* -- přechodové týdny, které nemají navazující týden
FROM czechia_price cpr
WHERE date_part('MONTH', cpr.date_from) IN (3, 6, 9, 12)
  AND date_part('MONTH', cpr.date_from) != date_part('MONTH', cpr.date_to)
  AND NOT EXISTS (
      SELECT 1
      FROM czechia_price cpr2
      WHERE cpr2.date_from = cpr.date_from + INTERVAL '7 days'
        AND cpr2.category_code = cpr.category_code
        AND cpr2.region_code = cpr.region_code
  )
ORDER BY cpr.date_from;
-- row count 875


SELECT 875 + 1750 -- Přehodové s navazujícím týdnem + bez navazujícího týdne = 2625 -> sedí
;

/*Potřebuju v přepočítávání cen za kvartál zohlednit i přechodové týdny. Proto je navážu do 
 tabulky cpa na oba kvartály a započítám je do průměrů.
*/

SELECT DISTINCT cpa.payroll_year, cpa. payroll_quarter, cpr.date_from, cpr.date_to
FROM czechia_payroll cpa 
CROSS JOIN czechia_price cpr
WHERE cpa.value_type_code = 5958 -- zajímají mě pouze průměrné hrubé mzdy zaměstnanců
	AND cpa.payroll_year IN (date_part('year', cpr.date_from), date_part('year', cpr.date_to))
	AND date_part ('MONTH', cpr.date_from) != date_part ('month', cpr.date_to) 
	AND CASE 
		WHEN date_part('month', cpr.date_from) IN (1,2,3)
			OR date_part('month', cpr.date_to) IN (1,2,3) THEN cpa.payroll_quarter = 1
		WHEN date_part('month', cpr.date_from) IN (4,5,6)
			OR date_part('month', cpr.date_to) IN (4,5,6) THEN cpa.payroll_quarter = 2
		WHEN date_part('month', cpr.date_from) IN (7,8,9)
			OR date_part('month', cpr.date_to) IN (7,8,9) THEN cpa.payroll_quarter = 3
		WHEN date_part('month', cpr.date_from) IN (10,11,12)
			OR date_part('month', cpr.date_to) IN (10,11,12) THEN cpa.payroll_quarter = 4
		END
ORDER BY cpr.date_from asc
-- Dotaz je neefektivní, vytváří nested loop a zpracování trvá v rámci minut. 
-- Po poradě s Copilotem jsem se ho rozhodla přepsat do LEFT JOINů v kombinaci UNION
;


SELECT DISTINCT  cpa.payroll_year, cpa. payroll_quarter, cpr.date_from, cpr.date_to 
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
SELECT DISTINCT cpa.payroll_year, cpa. payroll_quarter, cpr.date_from, cpr.date_to
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
ORDER BY date_to ASC
;

/* Díky UNION  se mi podařilo správně natáhnout přechodové týdny DO obou kvartálů. 
 * Teď ještě upravím dotaz tak, abych dostala průměrné ceny potravin za kvartál 
 * a pouze za roky 2006-2018, za které mám jak průměré mzdy, tak ceny potravin.
 * Pro snazší orientaci při budoucí práci vyměním kódy regionů a kategorií potravin za názvy,
 * vyberu jen potřebné sloupce a přejmenuju je pro snazší orientaci.
 * Ve výsledné tabulce chci pracovat s hodnotamy za kvartál, protože tak budou data vyvážená.*/

SELECT payroll_year,
	payroll_quarter,
	avg (food_price) AS avg_foodprice,
	(SELECT cpc.name
	FROM Czechia_price_category cpc
	WHERE category_code = cpc.code) AS food,
	(SELECT cr.name
	FROM czechia_region cr
	WHERE region_code = cr.code) AS food_price_region,
	avg_wage,
	(SELECT cpib.name
	FROM czechia_payroll_industry_branch cpib
	WHERE industry_branch_code = cpib.code) AS avg_wage_industry_branch
FROM (
	SELECT DISTINCT  cpa.payroll_year, cpa. payroll_quarter, cpr.value AS food_price,
		cpr.category_code, cpr.region_code, cpa.value AS avg_wage, cpa.industry_branch_code
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
	SELECT DISTINCT cpa.payroll_year, cpa. payroll_quarter, cpr.value AS food_price,
		cpr.category_code, cpr.region_code, cpa.value AS avg_wage, cpa.industry_branch_code
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
GROUP BY payroll_year,
	payroll_quarter,
	category_code,
	food,
	food_price_region,
	avg_wage,
	avg_wage_industry_branch 
;
/* Mám tabulku s průměrnými cenami potravin a průměrnými hrubými mzdami za kvartál 
 * v letech 2006-2018. U krajů, kde byly ceny potravin měřeny, a průmyslových odvětví 
 * s průměrnými mzdami se ale objevují z nějakého důvodu hodnoty NULL. Potřebuji prověřit 
 * původní data, zda je k tomu důvod. 
 * Dotaz je ale takto pomalý. Konzultovala jsem výsledky EXPLAIN ANALYZE s Copilotem a 
 * zdá se, že problém způsobují vnořené SELECTy a složitá agregace, 
 * podle velkého množství hodnot.
 * Proto zkusím dotaz přepsat s pomocí WITH a LEFT JOINů.
 */
WITH afpq AS ( -- Nejdřív spočítám průměrnou cenu potravin za kvartál jako afpq.
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
			WHERE cpa.value_type_code = 5958 -- zvažovala jsem, jestli podmínku nenechat jen nakonec, ale dotaz pak běží 6 s místo 3 s
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
	) -- Jako základ pro výslednou tabulku vezmu cpa a pomocí LEFT JOINů přípojím průměrné ceny 
	-- potravin za kvartál a názvy potravin a průmyslových odvětví z WITH a ostatních tabulek.
SELECT cpa.payroll_year AS Year,
	cpa.payroll_quarter AS Quarter,
	cpa.value AS Avg_wage,
	cpib.name AS industry_branch,
	afpq.food_price_per_quarter,
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
	-- AND cpib.name IS NULL -- Kontrola NULLových hodnot. 2658 - proč tolik? V cpa je jich 208  
;

/* Mám dotaz, který mi poskytuje všechna data, která potřebuju na jednom místě. A můžu vytvořit 
 * tabulku. Postgres SQL mi nedovolí použít CREATE TABLE a WITH v jednom dotazu, takže tabulku 
 * nejřív vytvořím a pak naplním. 
 * 
 * Doplnila jsem také podmínku, který vyfiltruje z původní tabulky pouze přepočtenou průměrnou 
 * mzdu, protože jsem zjistila, že mám za každé čtvrtletí dva různé údaje. Přitom přepočtená 
 * průměrná mzda by měla být přesnější, protože zohledňuje také částečné úvazky.
 * 
 */

CREATE TABLE t_magdalena_lorencova_project_SQL_primary_final 
	(
    Year int,
    Quarter int,
    Avg_wage int,
    industry_branch VARCHAR(255),
    food_price_per_quarter float,
    food VARCHAR(50)
);

WITH afpq AS ( -- Nejdřív spočítám průměrnou cenu potravin za kvartál jako afpq.
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
			WHERE cpa.value_type_code = 5958 -- zvažovala jsem, jestli podmínku nenechat jen nakonec, ale dotaz pak běží 6 s místo 3 s
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
	) -- Jako základ pro výslednou tabulku vezmu cpa a pomocí LEFT JOINů přípojím průměrné ceny 
	-- potravin za kvartál a názvy potravin a průmyslových odvětví z WITH a ostatních tabulek.
INSERT INTO t_magdalena_lorencova_project_sql_primary_final 
SELECT cpa.payroll_year AS Year,
	cpa.payroll_quarter AS Quarter,
	cpa.value AS Avg_wage,
	cpib.name AS industry_branch,
	afpq.food_price_per_quarter,
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
	AND cpa.calculation_code = 200 -- Doplňuji zpřesnění, abych dostala pouze přepočtenou 
	-- průměrnou hrubou mzdu a neměla 2 údaje pro každé čtvrtletí.
;

/*Ověřím, že je tabulka v pořádku a nechám si ji zobrazit. */
SELECT *
FROM t_magdalena_lorencova_project_sql_primary_final tmlpspf 
;

/*Vypadá to dobře. Můžu přejít na tvorbu pomocných materiálů.*/

SELECT *
FROM czechia_payroll cp 
WHERE cp.industry_branch_code IS NULL --344
	AND cp.payroll_year BETWEEN 2006 AND 2018 -- 208
;

SELECT DISTINCT cpr.category_code -- 27
FROM czechia_price cpr
;

SELECT 208*27 -- 5616 - Proč jich jen asi mám půlku?
;

SELECT DISTINCT cp.industry_branch_code, cp.payroll_year, count (*)
FROM czechia_payroll cp 
WHERE cp.industry_branch_code IS NULL --344
	AND cp.payroll_year BETWEEN 2006 AND 2018 -- 208
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter
ORDER BY cp.payroll_year asc
;
-- 4 kvartály, 13 let, 27 kategorií potravin = 1404 řádků pro každé odvětví 
-- 20 průmyslových odvětví - jedno je NULL
-- celkem mám ve výsledné tabulce 53160 řádků, z toho 20ina je 2658


/* 2) Vytvořit pomocnou tabulku s HDP, GINI koeficientem a populací 
 * dalších evropských států za roky 2006-2018. 
 * Všechny potřebné údaje mám v tabulce economies e, ale není jednoduchý 
 * způsob, jak si z ní vyfiltrovat evropské země. Proto k ní připojím 
 * tabulku countries c, která obsahuje i údaje o kontinentu, a s její 
 * pomocí si vyfiltruju Evropu.
*/
SELECT e.YEAR,
	e.country,
	c.country,
	c.continent,
	e.gini,
	e.gdp,
	e.population	
FROM economies e
LEFT JOIN countries c 
	ON c.country = e.country
WHERE e.year BETWEEN 2006 AND 2018
	AND c.continent = 'Europe'
	-- Postupně jsem ověřila, že nemám podivnosti v datech rozšiřováním podmínek:
	--AND c.country != e.country 
	--AND c.country IS NULL OR e.country IS NULL
	--AND c.continent IS null
	-- Žádná z podmínek nevrátila žádné výsledky. (Vždy 0 řádků) 
	-- Data by měla být v pořádku.
;

/*Ve výsledné tabulce nepotřebuji zobrazovat zemi dvakrát a nepotřebuji
 * v ní mít ani kontinent. Nepotřebné sloupce tedy nenechám zoprazit 
 * a rovnou vytvořím tabulku.
*/
CREATE TABLE t_magdalena_lorencova_project_sql_secondary_final as
SELECT e.YEAR,
	e.country,
	e.gini,
	e.gdp,
	e.population
FROM economies e
LEFT JOIN countries c 
	ON c.country = e.country
WHERE e.year BETWEEN 2006 AND 2018
	AND c.continent = 'Europe'
	
/*Nechám si tabulku zobrazit, abych se ujistila, že vypadá v pořádku.*/
	
SELECT *
FROM t_magdalena_lorencova_project_sql_secondary_final tmlpspf 
;

/*Zapomněla jsem přidat sloupec pro daňovou zátěž. Ale chtěla bych 
 * mít sloupce s ekonomickými ukazateli u sebe, aby byla tabulka přehlednější.
 * Proto nebudu sloupec přidávat, ale tabulku smažu a znovu vytvořím. */

DROP TABLE t_magdalena_lorencova_project_sql_secondary_final 
;

CREATE TABLE t_magdalena_lorencova_project_sql_secondary_final AS
SELECT e.YEAR,
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

/* Teď vypadá tabulka dobře. Podklady mám hotové a můžu přejít
 * na výzkumné otázky.
 */
/* Při práci na první otázce jsem nicméně narazila na to, že jsem 
 * do tabulky zapomněla vložit primary key a při left joinu se mi násobí
 * počet řádků. 
 * Aby měla tabulka lepší strukturu, smažu ji a vytvořím znovu tak, aby 
 * první sloupec byl primary key.
  */
DROP TABLE t_magdalena_lorencova_project_sql_primary_final 
;

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

/*Rovnou opravím i tabulku s pomocnými daty. 
 */
DROP TABLE t_magdalena_lorencova_project_sql_secondary_final 
;
-- Protože chci přidat PRIMARY KEY, musím si tabulku nejdřív vytvořit a pak naplnit.

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

SELECT *
FROM t_magdalena_lorencova_project_sql_primary_final tmlpspf

;

SELECT *
FROM t_magdalena_lorencova_project_sql_secondary_final
;

/*Teď mám obě dvě tabulky s jednoznačnou identifikací každého řádku 
a můžu zkusit znovu zpracovat výzkumné otázky.*/

/* ## Výzkumné otázky ##
 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */

/* Poznámka: 
 * Ukázalo se, že doplnění PRIMARY KEY nemělo na násobení řádků ve skutečnosti žádný vliv.
 * Nicméně, tabulky budou přehlednější. 
 * Násobení řádků bylo způsobeno tím, že kromě údajů, které potřebuji byly v původní tabulce 
 * také údaje o průměrných cenách potravin, které pak způsobovaly navýšení počtu řádků 
 * kvůli možným kombinacím. Tento problém vyřešilo použití příkazu SELECT DISTINCT.
 */
 
SELECT DISTINCT -- Používám DISTINCT, abych odfiltrovala duplicity způsobené tím, 
		-- že v původní tabulce jsou také průměrné ceny pro 27 kategorií jídla.
	tmlpspf.year,
	--tmlpspf.quarter,
	tmlpspf2.year AS previous_YEAR,
	--tmlpspf2.quarter AS previous_YEAR_quarter,
	round(avg(tmlpspf.avg_wage),2) AS avg_wage, -- Nakonec jsem se rozhodla pro větší přehlednost použít průměrnou mzdu za rok, 
									--nikoliv čtvrtletí a zobrazení čtvrtletí jsem zakomentovala.
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
		--tmlpspf.quarter,
		--tmlpspf2.quarter,
		tmlpspf.industry_branch
ORDER BY tmlpspf.industry_branch,
	tmlpspf."year"
	 --tmlpspf.quarter, 
	
;
-- Kontrola: Pokud počítám s čtvrtletími, dostanu 1040 řádků, stejně jako když vynechám ceny potravin z původní tabulky.

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
ORDER BY fi.YEAR, fi.quarter asc;

/* Závěr: výsledná tabulka ukazuje, kolik kilogramů chleba a litrů můéka bylo možné si koupit za průměrný plat 
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
-- Já ale hledám kategorii potravin s nejnižším průměrným mezirlčním nárůstem ceny za období 2006-2018.
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
--WHERE gdpraise.gdp_perc_raise > 3 -- Můžu přidat filtr pro roky s meziročním nárůstem hdp o více než 3 %, ať se mi lépe hledá. (1-3% jsou v ČR obvyklé)
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

