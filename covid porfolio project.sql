--select  *
--FROM PortolioProject..['covid-deaths$']
--order by 3, 4

--select  *
--FROM PortolioProject..['covid-vaccinations$']
--order by 1, 2


--Select the data we going to be using

--select  location, date, total_cases, new_cases, total_deaths, population
--FROM PortolioProject..['covid-deaths$']
--order by 1, 2

--looking at the total cases vs the total deaths

--shows the likelihood of dying if you contract covid
--select  location, date, total_cases, total_deaths, CAST(total_deaths as float)/CAST(total_cases as float)*100 DeathPercentage 
--FROM PortolioProject..['covid-deaths$']
--WHERE LOCATION LIKE 'Nigeria%'
--order by  1, 2

-- Looking at Total cases vs Population
-- show the percentage of the population with covid
--select  location, date, population, total_cases, CAST(total_cases as float)/CAST(population as float)*100 InfectedPopulation
--FROM PortolioProject..['covid-deaths$']
--WHERE LOCATION LIKE 'Nigeria%'
--order by  1, 2

--Looking at countries with the highest infection rate compared to population
--select  location, population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases as float)/CAST(population as float))*100 InfectedPercentage 
--FROM PortolioProject..['covid-deaths$']
----WHERE LOCATION LIKE 'Nigeria%'
--GROUP BY population, location
--order by HighestInfectionCount
--desc

--showing countries withhighest death count per population
--select  location, MAX(CAST(total_deaths as int)) as totalDeathCount
--FROM PortolioProject..['covid-deaths$']
----WHERE LOCATION LIKE 'Nigeria%'
--where continent is not null
--GROUP BY location
--order by totalDeathCount
--desc

--LET'S BREAK THINGS BY CONTINENT
--select continent, MAX(CAST(total_deaths as int)) as totalDeathCount
--FROM PortolioProject..['covid-deaths$']
----WHERE LOCATION LIKE 'Nigeria%'
--where continent is not null
--GROUP BY continent
--order by totalDeathCount
--desc
--select  location, MAX(CAST(total_deaths as int)) as totalDeathCount
--FROM PortolioProject..['covid-deaths$']
----WHERE LOCATION LIKE 'Nigeria%'
--where continent is  null
--GROUP BY location
--order by totalDeathCount
--desc

----GLOBAL NUMBERS

--select SUM(NullIf(new_cases, 0)) as SumOfCasesPerDay,
--SUM(NullIf(new_deaths, 0)) SumOfNewDeathsPerDay,
--SUM(NullIf(New_deaths, 0))/SUM(NullIf(New_cases, 0))DeathPercentage 
----/CAST(total_cases as float)*100 
--FROM PortolioProject..['covid-deaths$']
--WHERE continent is not null
----group by date
--order by  1, 2 

----SELECT *
--FROM PortolioProject..['covid-deaths$'] ded
--JOIN PortolioProject..['covid-vaccinations$'] vac
--ON ded.location = vac.location
--and ded.date = vac.date

--looking at the total population vs vaccinations

SELECT ded.continent, ded.location, ded.date, ded.population, vac.new_vaccinations
FROM PortolioProject..['covid-deaths$'] ded
JOIN PortolioProject..['covid-vaccinations$'] vac
ON ded.location = vac.location
and ded.date = vac.date
where ded.continent is not null
order by 2, 3

--SELECT ded.continent, ded.location, ded.date, ded.population, vac.new_vaccinations,
--sum(cast(vac.new_vaccinations as float)) over (partition by ded.location order by ded.location, ded.date) as RollingPeopleVaccination,
--(RollingPeopleVaccination/population)*100 as vacpop
--FROM PortolioProject..['covid-deaths$'] ded
--JOIN PortolioProject..['covid-vaccinations$'] vac
--ON ded.location = vac.location
--and ded.date = vac.date
--where ded.continent is not null

----order by 2, 3

---- use cte
--;with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccination)
--as
--(
--SELECT ded.continent, ded.location, ded.date, ded.population, vac.new_vaccinations,
--sum(cast(vac.new_vaccinations as float)) over (partition by ded.location order by ded.location, ded.date) as
--RollingPeopleVaccination
----
--FROM PortolioProject..['covid-deaths$'] ded
--JOIN PortolioProject..['covid-vaccinations$'] vac
--ON ded.location = vac.location
--and ded.date = vac.date
--where ded.continent is not null

----order by 2, 3
--)
--select *, cast((RollingPeopleVaccination/population)as float)*100 as percentpopvac
--from popvsvac ;

----WITH popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccination) AS (
--    SELECT
--        ded.continent,
--        ded.location,
--        ded.date,
--        ded.population,
--        vac.new_vaccinations,
--        SUM(CAST(vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY ded.location ORDER BY ded.location, ded.date) AS RollingPeopleVaccination
--        --, - (RollingPeopleVaccination / population) * 100
--    FROM
--        PortolioProject..['covid-deaths$'] ded
--    JOIN
--        PortolioProject..['covid-vaccinations$'] vac
--    ON
--        ded.location = vac.location
--        AND ded.date = vac.date
--    WHERE
--        ded.continent IS NOT NULL
--    -- ORDER BY 2, 3
--)
--SELECT *
--FROM popvsvac;
-- Previous statement terminated with a semicolon
--SELECT * FROM some_other_table;

-- Your CTE
--;WITH popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccination) AS (
--    SELECT
--        ded.continent,
--        ded.location,
--        ded.date,
--        ded.population,
--        vac.new_vaccinations,
		
--        SUM(CAST(vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY ded.location ORDER BY ded.location, ded.date) AS RollingPeopleVaccination
--    FROM
--        PortolioProject..['covid-deaths$'] ded
--    JOIN
--        PortolioProject..['covid-vaccinations$'] vac
--    ON
--        ded.location = vac.location
--        AND ded.date = vac.date
--    WHERE
--        ded.continent IS NOT NULL
--    -- ORDER BY 2, 3
--)
---- Your main query here, referencing the CTE
--SELECT *, (RollingPeopleVaccination / population) * 100
--FROM popvsvac;
--drop table if exists #percentvac
--create table #percentvac
--( 
--continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population float,
--new_vaccinations numeric,
--RollingPeopleVaccination numeric,
--percentpopvac numeric 
--)
--insert into #percentvac
--SELECT ded.continent, ded.location, ded.date, ded.population, vac.new_vaccinations,
--sum(convert(int, vac.new_vaccinations )) over (partition by ded.location order by ded.location, ded.date) as
--RollingPeopleVaccination
----
--FROM PortolioProject..['covid-deaths$'] ded
--JOIN PortolioProject..['covid-vaccinations$'] vac
--ON ded.location = vac.location
--and ded.date = vac.date
--where ded.continent is not null

--SELECT *, (RollingPeopleVaccination / population) * 100
--FROM #percentvac

--create a view
go

Create view percentvac as
SELECT ded.continent, ded.location, ded.date, ded.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations )) over (partition by ded.location order by ded.location, ded.date) as
RollingPeopleVaccination

FROM PortolioProject..['covid-deaths$'] ded
JOIN PortolioProject..['covid-vaccinations$'] vac
ON ded.location = vac.location
and ded.date = vac.date
where ded.continent is not null
--order by 2, 3