# Projekt z SQL

k ukončení kurzu Datová akademie společnosti Engeto

------------------------------------------------------------------

Projekt obsahuje:

- Tvorba Tabulek - Výsledný SQL kód pro vytvoření tabulek s požadovanými daty
- Sada SQL dotazů pro výzkumné otázky - Seznam výzkumných otázek spolu s SQL dotazy, které zobrazí relevantní data z vytvořených tabulek
- Průvodní listina - popis zjištěných omezení dat, zadání projektu, použitých zdrojů a stručný popis postupu tvorby SQL kódů, odpovědi na výzkumné otázky

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

1. Opakující se hodnoty 

Primární tabulka obsahuje jak data o průměrných mzdách, tak data o průměrných cenách potravin za časové období, a to včetně jednotlivých odvětví a kategorií potravin. Tato data spolu nesouvisejí jinak, než právě časovým intervalem, za který jsou měřena. Docházelo proto k duplikování hodnot a nárůstu počtu řádků, který nebyl vždy zcela rovnoměrný. 

Před výpočtem průměrných mezd a potravin za rok tak bylo nutné data vyčistit a získat pouze neopakující se hodnoty. K tomu jsem použila CTE clearing_values_wages a clearing_values_food.

2. Zbytečně podrobná data 

Primární tabulka obsahuje hodnoty mezd a průměrných cen potravin za čtvrtletí. Čtvrtletí bylo nejmenším relativně jednoduše použitelným společným časovým úsekem pro oba typy dat. 

Při hledání odpovědí na výzkumné otázky se však nakonec ukázalo, že není třeba pracovat s jednotkami menšími než rok. Pro každý SQL dotaz tak byl nutný přepočet průměrných hodnot ze čtvrtletí na rok. Mimo to jsem potřebovala také zaokrouhlovat vypočtená hodnoty, aby se ve výsledných číslech nezobrazovalo zbytečně moc desetinných míst. 

Přestože jsem pro přehlednost použila řetězce CTE, je výsledný kód zbytečně rozsáhlý, protože data mohla být předzpracovaná už při tvorbě primární tabulky. 

Závěr: Při zpracování datových podkladů příště vezmu více v úvahu účel, ke kterému budou data používána.

---------------------------------------------------------------------------

## Odpovědi na výzkumné otázky

**1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**
 
V některých odvětvích došlo v průběhu let k poklesu mezd – konkrétně ve **26 případech z 240**.

**Nejčastější pokles** mezd byl zaznamenán v těchto odvětvích:

- Těžba a dobývání (4×, v letech 2007–2010)  
- Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu (3×)  

V ostatních odvětvích se meziroční pokles mezd projevil maximálně jedenkrát až dvakrát za sledovaného období.

**K nejplošnějšímu poklesu** mezd přitom docházel v letech **2009–13**:

- 2013 – 12 odvětví
- 2011, 2009 - 4 odvětví
- 2010 – 3 odvětví  

Rok **2013** byl také rokem, kdy mzdy v některých odvětvích klesaly **nejdrastičtěji**. Nejvíce poklesly mzdy v těchto odvětvích: 

- Peněžnictví a pojišťovnictví (z 50 800 kč na  46 317 Kč) 
- Výroby a rozvodu elektřiny, plynu, tepla a klimatiz. vzduchu (42 657 Kč na 40 762 Kč).

V ostatních letech docházelo k poklesu mezd obvykle v rámci maximálně několika stokorun. Výjimku tvoří odvětví Těžba a dobývání, kde v roce 2009 klesly mzdy takřka o 1000 Kč (z 29 273 Kč na 28 361 Kč).

**Nejmenší pokles mezd** se projevil v letech:

- 2014, 2016 – pouze v odvětví Těžba a dobývání  
- 2016–2017 – pouze v odvětví  Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu 

V letech **2006–2008** a v roce **2012** tedy mzdy naopak **pouze rostly**. 



**2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

Prvním a posledním srovnatelným obdobím jsou **1. čtvrtletí roku 2006** a **4. čtvrtletí roku 2018**. Srovnávat čtvrtletí mi ale přijde nepraktické i vzhledem k tomu, že žádná z ostatních otázek kvartály nezohledňuje. Srovnala jsem proto hodnoty za rok 2006 a 2018. 


| Rok  | Odvětví                                                              | Chléb (kg)  | Mléko (l) |
|------|----------------------------------------------------------------------|-------------|-----------|
|      | Nejvíc za průměrný plat                                              |             |           |
|------|----------------------------------------------------------------------|-------------|-----------|
| 2006 | Peněžnictví a pojišťovnictví                                         | 2 494       | 2 785     |
| 2006 | Informační a komunikační činnosti                                    | 2 230       | 2 491     |
| 2006 | Výroba a rozvod elektřiny, plynu, tepla a klimatizovaného vzduchu    | 1 820       | 2 033     |
|------|----------------------------------------------------------------------|-------------|-----------|
| 2018 | Informační a komunikační činnosti                                    | 2 332       | 2 868     |
| 2018 | Peněžnictví a pojišťovnictví                                         | 2 256       | 2 775     |
| 2018 | Výroba a rozvod elektřiny, plynu, tepla a klimatizovaného vzduchu    | 1 906       | 2 345     |
|------|----------------------------------------------------------------------|-------------|-----------|
|      | Nejmíň za průměrný plat                                              |             |           |
|------|----------------------------------------------------------------------|-------------|-----------|
| 2006 | Ubytování, stravování a pohostinství                                 | 792         | 812       |
| 2006 | Administrativní a podpůrné činnosti                                  | 861         | 1 005     |
| 2006 | Zemědělství, lesnictví a rybářství                                   | 924         | 1 031     |
|------|----------------------------------------------------------------------|-------------|-----------|
| 2018 | Ubytování, stravování a pohostinství                                 | 724         | 974       |
| 2018 | Administrativní a podpůrné činnosti                                  | 900         | 1 059     |
| 2018 | Ostatní činnosti                                                     | 974         | 1 198     |
| 2018 | Zemědělství, lesnictví a rybářství                                   | 1 047       | —         |
|------|----------------------------------------------------------------------|-------------|-----------|
|      | **Bez ohledu na odvětví**                                            |             |           |      
|------|----------------------------------------------------------------------|-------------|-----------|
| 2006 |                                                                      | **1 314**   | **1 467** |
|------|----------------------------------------------------------------------|-------------|-----------|
| 2018 |                                                                      | **1 358**   | **1 670** |     


Souhrnně (bez ohledu na odvětví) bych si za průměrný plat mohla v roce 2006 mohla koupit 1 313 kg chleba a 1 467 l mléka, zatímco v roce 2018 1 358 kg chleba a 1 670 l mléka. 

Rozdíl: **+45 kg chleba** a **+203 l mléka**  

Z toho plyne, že přestože ceny potravin vzrostly (chléb z 16 Kč na 24 Kč, mléko z 14 Kč na 20 Kč), **potraviny byly v roce 2018 reálně dostupnější než v roce 2006.**


=======================

**Nejvíce chleba** za průměrný plat v roce **2006**:

- Peněžnictví a pojišťovnictví – 2 494 kg  
- Informační a komunikační činnosti – 2 230 kg  
- Výroba a rozvod elektřiny, plynu, tepla a klimatizovaného vzduchu – 1 820 kg  

**Nejvíce chleba** za průměrný plat v roce **2018**:

- Informační a komunikační činnosti – 2 332 kg 
- Peněžnictví a pojišťovnictví – 2 256 kg  
- Výroba a rozvod elektřiny, plynu, tepla a klimatizovaného vzduchu – 1 906 kg 

**Nejméně chleba** za průměrný plat v roce **2006**:

- Ubytování, stravování a pohostinství – 792 kg    
- Administrativní a podpůrné činnosti – 861 kg
- Zemědělství, lesnictví a rybářství – 924 kg

**Nejméně chleba** za průměrný plat v roce **2018**:

- Ubytování, stravování a pohostinství – 724 kg 
- Administrativní a podpůrné činnosti – 900 kg 
- Ostatní činnosti – 974 kg (2006) 
- Zemědělství, lesnictví a rybářství – 1047 kg 

**Nejvíce mléka** za průměrný plat v roce **2006**:

- Peněžnictví a pojišťovnictví – 2 785 l  
- Informační a komunikační činnosti – 2 491 l 
- Výroba a rozvod elektřiny, plynu, tepla a klimatizovaného vzduchu – 2 033 l 

**Nejvíce mléka** za průměrný plat v roce **2018**:
- Informační a komunikační činnosti – 2 868 l 
- Peněžnictví a pojišťovnictví – 2 775 l  
- Výroba a rozvod elektřiny, plynu, tepla a klimatizovaného vzduchu – 2 345 l 

**Nejméně mléka** za průměrný plat v roce **2006**:

- Ubytování, stravování a pohostinství – 812 l 
- Administrativní a podpůrné činnosti – 1005 l  
- Zemědělství, lesnictví a rybářství – 1031 l 

**Nejméně mléka** za průměrný plat v roce **2018**:

- Ubytování, stravování a pohostinství – 974 l 
- Administrativní a podpůrné činnosti – 1059 l  
- Ostatní činnosti – 1198 l

===========================================================

**3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

V letech **2006–2018** rostly nejpomaleji ceny:

- Bílého pšeničného pečiva (≈ 0,16 % ročně)  
- Banánů (≈ 0,36 % ročně)

Pod hranicí 1 % nárůstu ročně zůstaly také:

- Vepřová pečeně (≈ 0,79 %)  
- Jablka (≈ 0,84 %)  
- Minerální voda (≈ 0,99 %)  

Ceny některých potravin dokonce **klesaly**:

- Brambory (−0,39 % ročně, mírně)  
- Cukr (−3,48 % ročně, výrazně)  
- Rajčata (−3,78 % ročně, výrazně)  

**4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

Pokud uvažujeme průměrné ceny potravin a průměrné mzdy bez ohledu na odvětví, **v žádném roce ceny potravin nerostly o více než 10 % rychleji než mzdy.**

Nejblíže k hranici 10 % měl rok **2009**, kdy:

- **Ceny potravin** klesly o **−6,63 %**
- **Mzdy** vzrostly o **2,99 %**  
→ rozdíl **9,62 %**

**Další roky s většími rozdíly:**

- 2013 – rozdíl 6,66 % způsobený **nárůstem cen potravin (5,15 %)** a **poklesem mezd (−1,51 %)**
- 2018 – rozdíl 5,23 % způsobený vysokým **nárůstem mezd (7,17 %)** oproti mnohem nižšímu **růstu cen potravin (1,94 %)**
- 2016 – rozdíl 4,64 % způsobený **poklesem cen potravin (−1,1 %)** a **nárůstem mezd (3,54 %)**

V ostatních letech se rozdíly mezi růstem mezd a cen potravin pohybují do **4 %**, většinou dokonce do 2 %.



**5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**

V některých letech se zdá, že se růst HDP projevil i na růstu mezd a cen potravin, ale **neexistuje jasná přímá vazba**. Navíc je vzorek dat příliš malý, aby se dal vyvodit jasný závěr.

**Výrazný růst HDP**
- Roky: **2007, 2015, 2017** (nad **5** %),  
	**2018** (nad **3** %)		
- **Mzdy**: *Častěji* také *výrazně rostou* (v roce 2007 o 6,45 % a v roce 2017 o 5,83 %, v roce 2018 o 7,17 %).  
	Jen v roce 2015 vzrostly mzdy podstatně méně výrazně, o 2,56 %
- **Ceny potravin** : Někdy také *výrazně rostou* (v roce 2007 o 6,1 % a v roce 2017 o 9,04 %). Jindy však klesají (v roce 2015 o −0,62 %)

👉 Mzdy reagují pozitivně, ale ceny potravin ne vždy.

2. Běžný růst HDP (do 3,5 %)
- **Roky:** 2008, 2010, 2011, 2014, 2016, 2018
- **Mzdy i ceny potravin:** většinou *normální růst* nebo *pokles*

👉 Slabší HDP = slabší dynamika mezd i cen.

---

### 3. Negativní HDP (pokles ekonomiky)
- **Roky:** 2009, 2012, 2013
- **Mzdy:** většinou *normální* nebo *pokles*
- **Ceny potravin:** překvapivě často *rostou*

👉 Ceny potravin mohou růst i při poklesu HDP, což naznačuje vliv jiných faktorů (např. inflace, dovoz, sezónnost).

---

### ✅ Závěr
**Výše HDP má vliv na změny mezd, ale méně spolehlivě na ceny potravin.**

- Mzdy mají tendenci růst výrazněji v letech s vysokým HDP.
- Ceny potravin jsou méně předvídatelné — mohou růst i při poklesu HDP, což naznačuje, že jsou ovlivněny širšími ekonomickými a tržními faktory.


V některých letech se růst HDP projevil i na růstu mezd a cen potravin, ale **neexistuje jasná přímá vazba**.

**Příklady:**

- **2007** – HDP +5,57 % → potraviny +6,5 %, mzdy +6,88 %  
- **2017** – HDP +5,17 % → potraviny +9,94 %, mzdy +6,21 %  
- **2015** – HDP +5,57 %, ale potraviny **−0,62 %**, mzdy +2,63 %  
- **2018** – HDP +3,2 %, potraviny +1,98 %, mzdy +7,71 % (největší nárůst mezd za 12 let)

Z dostupných dat se zdá, že růst HDP **neovlivňuje přímo** vývoj cen potravin ani mezd. Vztah může být nepřímý a datový vzorek je příliš malý pro silné závěry.



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

