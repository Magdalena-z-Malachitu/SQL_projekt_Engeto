# Projekt z SQL

k ukončení kurzu Datová akademie společnosti Engeto

------------------------------------------------------------------

Projekt obsahuje:

- **Tvorba Tabulek** - Výsledný SQL kód pro vytvoření tabulek s požadovanými daty
- **Sada SQL dotazů pro výzkumné otázky** - Seznam výzkumných otázek spolu s SQL dotazy, které zobrazí relevantní data z vytvořených tabulek
- **Průvodní listina** - popis zjištěných omezení dat, zadání projektu, použitých zdrojů a stručný popis postupu tvorby SQL kódů, odpovědi na výzkumné otázky

-------------------------------------------------------------------

## Omezení dat

- Výsledné tabulky obsahují pouze data za roky 2006--2018. Což je interval, kdy se překrývají data z nezbytných zdrojových sad.
- Výsledné tabulky obsahují přepočtenou průměrnou mzdu, by měla být přesnější, protože zohledňuje také částečné úvazky.
- V sadě SQL dotazů pro výzkumné otázky je v rámci kódu často úmyslně vyřazen první nebo poslední rok z intervalu, protože neumožňuje srovnání s předchozím nebo následujícím rokem.

### Další omezení

- Data z primární tabulky czechia_price jsou nepravidelná. Zpočátku měření (rok 2006) jsou zaznamenány údaje po jednotlivých týdnech. Později se ale interval snižuje a od roku 2011 je zaznamenán pouze 1 týden za každý měsíc.
- Ve sloupci industry_branch v t_magdalena_lorencova_project_sql_primary_final v některých případech chybí hodnota (NULL). To je způsobeno tím, že tato data chybí už tabulkách zdrojových dat.
- Kategorie potravin (food) Jakostní víno bíle (v t_magdalena_lorencova_project_sql_primary_final) se meří až od roku 2015.
- Kategorie potravin (food) Kapr živý (v t_magdalena_lorencova_project_sql_primary_final) se vždy objevuje pouze v posledním kvartále roku (quarter 4) .

----------------------------------------------------------------------

## Zadání projektu  


### Úvod do projektu

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

Datové sady, které je možné požít pro získání vhodného datového podkladu:

Primární tabulky:

- czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
- czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
- czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
- czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
- czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
- czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
- czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.

Číselníky sdílených informací o ČR:

- czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
- czechia_district – Číselník okresů České republiky dle normy LAU.

Dodatečné tabulky:

- countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
- economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

### Výzkumné otázky

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

###Výstupy z projektu

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

-----------------------------------------------------------------------------

## Použité zdroje: 

K vytvoření primární tabulky jsem použila tabulky:

- czechia_payroll - informace o průměrných mzdách v různých odvětvích
- czechia_price - informace o cenách potravin
- czechia_price_category - doplnění názvů potravin
- czechia_payroll_industry_branch - doplnění názvů odvětví

K vytvoření pomocných materiálů jsem použila tabulky:

- economies - informace o HDP, koeficientu GINI, jednotlivých států
- countries - geografické údaje umožňující vyfiltrovat evropské státy


-----------------------------------------------------------------------------

## Příprava SQL dotazů pro tvorbu tabulek

### Primární tabulka

Informace potřebné k vytvoření primární tabulky pro zodpovězení výzkumných otázek jsem identifikovala jako:

- období
- průměrná mzda
- odvětví, kterého se průměrná mzda týka
- cena potraviny
- název potraviny

Našla jsem je v následující zdrojích v této podobě: 

- czechia_payroll - rok, kvartál, průměrná mzda, kód odvětví
- czechia_price - týden (datum počátku týdne, datum konce týdne), cena potraviny, kód kategorie potravin
- czechia_price_category - kód kategorie potravin, název kategorie potravin
- czechia_payroll_industry_branch - kod odvětví, název odvětví


**Výzvy:**

1. Sjednocení časových údajů

Tabulka czechia_payroll obsahuje informace o průměrných mzdách v letech 2000–2021. Jako časový úcek přitom používá čtvrtletí. 

Naproti tomu tabulka czechia_prize obsahuje údaje o cenách potravin v letech 2006–2018. Ceny potravin jsou přitom měřeny v konkrétních týdnech. Data v tabulce czechia_prize jsou navíc nerovnoměrná. Zatímco zpočátku probíhala měření každý týden, od roku 2011 jsou ceny zaznamenány pouze za první týden v měsíci. 

Výsledná tabulka tedy obsahuje údaje pouze za léta 2006-2018 a bylo nutné sjednotit časové údaje. Rozhodla jsem se použít kvartál jakožto nejměnší použitelnou společnou jednotku a údaje o týdnech z tabulky czechia_prize přepočítat na čtvrtletí. 

Týdny samozřejmě nebudou většinou zapadat do hranic kvartálů. Čtyřikrát ročně se může vyskytnout přechodový týden. Vzhledem ke snížení frekvence měření se přechodových týdnů vyskytuje pouze 7. Protože se však ukázalo, že rozdíl v cenách může být mezi jednotlivými týdny dost značný (až 82 % v nejhorším případě, u přechodových týdnů až 31 %), rozhodla jsem se v rámci přesnosti započítat údaje o cenách z přechodových týdnů do průměrné ceny v obou kvartálech, ke kterým týden náleží. 

Za tímto účelem jsem použila dva SQL dotazy spojené prostřednictvím operátoru UNION. První přiřadil týdny ke kvartálům podle měsíce v datu začátku týdne a druhý podle měsíce v datu konce týdne.

```SQL
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
```

Dotaz jsem následně vnořila do nového dotazu, který vypočítal průměrné ceny potravin za jednotlivá čtvrtletí. 



2. Složitost a náročnost kódu

Abych dosáhla požadovaného výsledku, potřebovala jsem propojit data ze čtyř různých tabulek a přepočítat časové jednotky a dopočítat průměrné ceny potravin za kvartál z tabulky czechia_orice. Původně jsem se pokusila o relativně jednoduchý dotaz s vnořením několika poddotazů. To se ale ukázalo být naprosto neefektivní. Dotaz pak byl velice pomalý.

Vzhledem k náročnosti na výkon databáze a pro lepší přehlednost jsem tedy s pomocí operátoru WITH vytvořila dočasnou tabulku (afpq, jako average_food_price_per_quarter) s údaji o průměrných cenách potravin za čtvrtletí. Tuto jsem následně připojila k vybraným údajům z tabulky czechia_payroll prostřednictvím operátoru LEFT JOIN. Stejně tak jsem s pomocí LEFT JOIN připojila údaje o názvech odvětví a potravin z tabulek czechia_payroll_industry_branch a czechia_price_category. Tento výsledný dotaz byl mnohem rychlejší a použitelnější. 

Vzhledem ke složitosti kódu jsem také nemohla vytvořit tabulku přímo z výsledků dotazu. Bylo nutné nejdříve vytvořit tabulku s odpovídajícími sloupci a tu pak následně naplnit z dotazu zahrnujícího dočasnou tabulku afpq.


### Pomocná tabulka

Informace potřebné k vytvoření pomocné tabulky pro zodpovězení výzkumných otázek jsem identifikovala jako:

- rok (pouze období 2006-2018)
- stát (pouze evropské)
- HDP
- koeficient GINI 
- populace 

Všechny potřebné údaje jsou dostupné v tabulce economies. Neexistuje ale jednoduchý způsob, jak z ní vyfiltrovat evropské země. Proto jsem k ní připojila tabulku countries, která obsahuje i údaje o kontinentu. S pomocí tohoto sloupce mohu vyfiltrovat pouze evropské státy.

---------------------------------------------------------------------------

## Příprava sady SQL dotazů pro zodpovězení výzkumných otázek


### Výzvy

---------------------------------------------------------------------------

## Odpovědi na výzkumné otázky

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 
V některých odvětvích došlo v průběhu let k poklesu mezd. Jedná se o 63 případů z 260, což je velmi výrazné množství.
 * Nejčastěji klesaly mzdy v těchto odvětvích:
 * Peněžnictví a pojišťovnictví (6x, přitom v letech 2007-2010 souvisle)
 * Administrativní a podpůrné čínnosti (5x)
 * Těžba a dobývání (5x)
 * Výroba a rozvod elektřiny (5x, v letech 2010-2015 s výjimkou roku 2012)
 * Činnosti v oblasti nemovitostí (5x, v letech 2008-2013 s výjimkou roku 2011)
 * 
 * Nejplošněji klesaly mzdy v těchno letech:
 * 2013 - v 15 otvětvích
 * 2010 - 13 odvětví 
 * 2009 - v 9 odvětvích 
 * 
 * 
 * Naopak nejmenšího počtu odvětví se pokles mezd dotkl v těchto letech: 
 * 2007 - pokles pouze v oblasti Peněžnictví a pojišťovnictví 
 * 2016-1017 - pokles pouze v oblasti Těžba a dobývání 

2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a 
 	poslední srovnatelné období v dostupných datech cen a mezd?

Závěr: Prvním a posledním srovnatelným obdobím jsou první kvartál roku 2006 a poslední kvartál roku 2018. 
 * 
 * V těchto obdobích bych si nejvíce chleba mohla koupit za průměrný plat prvním kvartálu roku 2006 v následujících odvětvích:
 * Peněžnictví a pojišťovnictví (3 024 kg)
 * Informační a komunikační činnosti (2 401 kg)
 * Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu (1 834 kg)
 * 
 * Naopak nejméně chleba bych si mohla koupit za průměrný plat v těchto odvětvích:
 * Ubytování, stravování a pohostinství (753 kg v prvním čtvrtletí roku 2006 a 835 kg v posledním čtvrtletí roku 2018)
 * Zemědělství, lesnictví a rybářství (882 kg v prvním čtvrtletí roku 2006)
 * Administrativní a podpůrné činnosti (927 kg v prvním čtvrtletí roku 2006 a 908 kg v posledním čtvrtletí roku 2018)
 * 
 * Co se týče mléka, nejvíce bych si ho mohla koupit za průměrný plat v těchto odvětvích a obdobích: 
 * Peněžnictví a pojišťovnictví (3 106 l v prvním čtvrtletí roku 2006)
 * Informační a komunikační činnosti (2 949 l v posledním čtvrtletí roku 2018)
 * Peněžnictví a pojišťovnictví (2 751 l v posledním čtvrtletí roku 2018)
 * Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu (2 539 l v posledním čtvrtletí roku 2018)
 * Informační a komunikační činnosti (2 467 l v prvním čtvrtletí roku 2006)
 * 
 * Nejméně mléka bych si ho mohla koupit za průměrný plat v těchto odvětvích a obdobích: 
 * Ubytování, stravování a pohostinství (774 l v prvním čtvrtletí roku 2006 a 1024 kg v posledním čtvrtletí roku 2018)
 * Zemědělství, lesnictví a rybářství (906 l v prvním čtvrtletí roku 2006)
 * Administrativní a podpůrné činnosti (952 l v prvním čtvrtletí roku 2006)
 * 
 * Pokud budeme uvažovat v rámci let a odhlédneme od rozdílů v platech mezi odvětvími, 
 * budeme srovnávat dostupnost potravin v letech 2006 a 2018. Za průměrný plat bych si v roce 2006
 * mohla koupit 1 313 kg chleba a 1 467 l mléka. V roce 2018 pak 1 358 kg chleba a 1670 l mléka. To je 
 * o 45 kg a 203 l mléka více. Přestože ceny potravin za toto období vzrostly (cena chleba z 16 Kč na 24 Kč 
 * a cena mléka z 14 Kč na 20 Kč), jsou ve skutečnosti potraviny v roce 2018 dostupnější než v roce 2006.

3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší 
 	percentuální meziroční nárůst)?

Závěr: 
 * V letech 2006–2018 rostly nejpomaleji ceny bílého pšeničného pečiva (v průměru 0,16 % ročně)
 * a banánů (v průměru 0,36 % ročně). Pod hranicí jednoprocentního nárůstu se udržela také 
 * vepřová pečeně (v průměru 0,79 % ročně), jablka (v průměru 0,84 % ročně) a minerální voda 
 * (v průměru 0,99 % ročně).
 * V několika kategoriích potravin došlo v tomto období dokonce k poklesu ceny - u brambor mírně
 * (v průměru 0,16 % ročně), kdežto u cukru (v průměru 3,49 % ročně) a rajských jablek 
 * (v průměru 3,78 % ročně) cena klesala poměrně výrazně. 

4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší 
 	než růst mezd (větší než 10 %)?

Závěr: Pokud uvažujeme průměrné ceny potravin (bez ohledu na kategorii) a průměrné mzdy 
 * (bez zohlednění odvětví), nerostly v žádném roce ceny potravin výrazně rychleji než mzdy 
 * (rozdíl více než o 10 %).
 * Hranici 10% rozdílu v nárůstech cen a mezd se však velmi přibližuje rok 2009 s 
 * poklesem cen potravin o 6,76 % a nárůstem mezd o 3 % (9,76 %, a tedy takřka 10 %). 
 * Zhruba poloviční rozdíl se pak projevil ještě v letech 2014, 2019 a 2017. 
 * V roce 2015 (5,87 %) byl přitom způsoben tím, že ceny potraviny poklesly (-3,31 %
 * zhruba stejně jako vzrostly mzdy (2,56 %). A tento trend pokračoval v mírnější podobě
 * i v roce 2016 (rozdíl 4,84 %), kdy došlo k mírnému poklesu cen potravin (-1,3 %) a 
 * nárůstu mezd (3,54 %). 
 * V roce 2018 pak byl rozdíl v nárůstu cen potravin a mezd způsoben tím, že platy vzrostly
 * rychleji (7,16 %) než ceny potravin (1,82 %)
 * Naopak v roce 2013 způsobil výraznější rozdíl v růstu cen potravin a mezd (6,77 %) 
 * výraznější nárůst cen potravin (5,25 %) a mírný pokles mezd (1,52 %)
 * V ostatních letech se nárůst cen mezd i potravin dosahuje rozdílů do 4 %.

5.á výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, 
 	pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách 
 	potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

*Závěr: 
 * Zdá se, že v letech 2007 (růst o 5,57 %) a 2017 (růst o 5,17 %) došlo s výrazným nárůstem HDP také 
 * k výraznémů růstu cen potravin (6,5 % v roce 2007 a 9,94 % v roce 2017) 
 * i mezd (6,88 % v roce 2007 a 6,21 % v roce 2017). 
 * V letech 2015 a 2018 sice HDP výrazněji vzrostlo (5,57 % a 3,2 %), ale ceny potravin nikoliv 
 * (pokles o 0,62 % v roce 2015 a nárůst o 1,98 % v roce 2018). 
 * U mezd došlo k výraznějšímu růstu v roce 2018 (7,71 %), kdežto v roce 2015 rostly průměrné mzdy normálně (o 2,63 %)
 * V roce 2018 přitom došlo k nejvýraznějšímu meziročnímu nárůstu mezd za posledních 12 let. 
 * Nezdá se, že by výraznější růst HDP přímo působil na ceny potravin nebo mzdy, ale vzorek dat k analýze je příliš malý, 
 * aby bylo možno vyvodit nějaký závěr. Nezdá se ani, že by růst a pokles cen nebo mezd sledovaly stejný trend jako růst a pokles DPH.
 */

/*
 * Úplný závěr: Příště si pořádně pročtu zadání všech otázek a nebudu se při vytváření podkladů trápit menšími časovými jednotkami jako jsou kvartály, 
 * pokud je při dalším zpracování nevyužiju, a nebudu si zbytečně komplikovat kód.
 */

