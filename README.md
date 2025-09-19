#Projekt z SQL#
k ukončení kurzu **Datová akademie** společnosti **Engeto**

##Projekt obsahuje:##
- Tvorba Tabulek
  *Výsledný SQL kód pro vytvoření tabulek s požadovanými daty*
- Sada SQL dotazů pro výzkumné otázky
  *Seznam výzkumných otázek spolu s SQL dotazy, které zobrazí relevatní data z vytvořených tabulek, a odpověďmi na tyto otázky.*
- Průvodní listina
  *Kompletní popis cesty k výsledným kódu včetně včetně všech mezikroků, úvah, kontrol a oprav, zjišťování nepravidelností a omezení zdrojových dat, ověřovacích dotazů, vysvětlivek k částem zdrojového kódu i chybných odboček.*

##Omezení dat##

- Výsledné tabulky obsahují pouze data za roky **2006--2018**. Což je interval, kdy se překrývají data z nezbytných zdrojových sad.
- Výsledné tabulky obsahují přepočtenou průměrnou mzdu, by měla být přesnější, protože zohledňuje také částečné úvazky. 
- V sadě SQL dotazů pro výzkumné otázky je v rámci kódu často úmyslně vyřazen první nebo poslední rok z intervalu, protože neumožňuje srovnání s předchozím nebo následujícím rokem.

###Další omezení###
- Data z primární tabulky czechia_price jsou nepravidelná. Zpočátku měření (rok 2006) jsou zaznamenány údaje po jednotlivých týdnech. Později se ale interval snižuje a od roku 2011 je zaznamenán pouze 1 týden za každý měsíc.
- Ve sloupci industry_branch v t_magdalena_lorencova_project_sql_primary_final  v některých případech chybí hodnota (NULL). To je způsobeno tím, že tato data chybí už tabulkách zdrojových dat.
- Kategorie potravin (food) Jakostní víno bíle (v t_magdalena_lorencova_project_sql_primary_final) se meří až od roku 2015.
- Kategorie potravin (food) Kapr živý (v t_magdalena_lorencova_project_sql_primary_final) se vždy objevuje pouze v posledním kvartále roku (quarter 4) .

##Zadání projektu##

###Úvod do projektu###
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, 
jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují 
**dostupnost základních potravin široké veřejnosti**. Kolegové již vydefinovali základní otázky, 
na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude 
výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět 
**porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období**.

Jako dodatečný materiál připravte i **tabulku s HDP, GINI koeficientem a populací dalších 
evropských států ve stejném období**, jako primární přehled pro ČR.

Datové sady, které je možné požít pro získání vhodného datového podkladu
**Primární tabulky**:

- czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
- czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
- czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
- czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
- czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
- czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
- czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.

**Číselníky sdílených informací o ČR**:

- czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
- czechia_district – Číselník okresů České republiky dle normy LAU.

**Dodatečné tabulky**:

- countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
- economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.


###Výzkumné otázky###
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období 
v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd 
(větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji 
v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce 
výraznějším růstem?





