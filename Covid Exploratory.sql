/*
Data Exploratory Project
*/

SELECT *
FROM [Project Portfolio].dbo.CovidDeaths$
ORDER BY 3, 4

SELECT *
FROM [Project Portfolio].dbo.CovidVaccinations$
ORDER BY 3, 4

--select data that is to be used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Project Portfolio].dbo.CovidDeaths$
ORDER BY location, date 

--comparing total cases and total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as 'Deaths per Case'
FROM [Project Portfolio].dbo.CovidDeaths$
ORDER BY location, date 


--likelihood of dying from covid in Kenya
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as 'Deaths per Case'
FROM [Project Portfolio].dbo.CovidDeaths$
WHERE location = 'Kenya'
ORDER BY location, date 

--comparing total case to the population
--percentage of population that got covid
SELECT location, date, total_cases, population, (total_cases/population) * 100 as 'Infection rates'
FROM [Project Portfolio].dbo.CovidDeaths$
ORDER BY location, date 

--Countries with highest infection rates
SELECT location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population) * 100) as HighestInfectionRates
FROM [Project Portfolio].dbo.CovidDeaths$
GROUP BY location, population
ORDER BY HighestInfectionRates

--Countries with highest death rates
SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM [Project Portfolio].dbo.CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


--spliting the data based on continent

--continents with the highest death count
SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM [Project Portfolio].dbo.CovidDeaths$
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--global numbers

--total daily cases 
SELECT date, SUM(new_cases) AS TotalDailyCases, SUM(cast(new_deaths AS INT)) AS TotalDailyDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases)) * 100 as DailyDeathPercentage
FROM [Project Portfolio].dbo.CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2 

--overall global cases
SELECT SUM(new_cases) AS TotalDailyCases, SUM(cast(new_deaths AS INT)) AS TotalDailyDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases)) * 100 as DailyDeathPercentage
FROM [Project Portfolio].dbo.CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1, 2 


--comparing population to vaccinations 

SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (Partition by deaths.location order by deaths.location, deaths.date) UpdateVaccinationCount
FROM [Project Portfolio].dbo.CovidDeaths$ as deaths
JOIN [Project Portfolio].dbo.CovidVaccinations$ as vac
	on deaths.location = vac.location 
	and deaths.date = vac.date
where deaths.continent is not null
order by 1, 2, 3


--finding % of population vaccinated

--create temp table
drop table if exists #PopulationPercentageVaccinated

create table #PopulationPercentageVaccinated
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population int,
	new_vaccinations numeric,
	updatevaccinationcount numeric
)	

insert into #PopulationPercentageVaccinated
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (Partition by deaths.location order by deaths.location, deaths.date) UpdateVaccinationCount
FROM [Project Portfolio].dbo.CovidDeaths$ as deaths
JOIN [Project Portfolio].dbo.CovidVaccinations$ as vac
	on deaths.location = vac.location 
	and deaths.date = vac.date
where deaths.continent is not null
--order by 1, 2, 3

select continent, location, population, new_vaccinations,  updatevaccinationcount, (updatevaccinationcount / population) * 100 as VaccinatedPercentage
from #PopulationPercentageVaccinated


--creating view to store data
create view PopulationPercentageVaccinated as
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (Partition by deaths.location order by deaths.location, deaths.date) UpdateVaccinationCount
FROM [Project Portfolio].dbo.CovidDeaths$ as deaths
JOIN [Project Portfolio].dbo.CovidVaccinations$ as vac
	on deaths.location = vac.location 
	and deaths.date = vac.date
where deaths.continent is not null
--order by 1, 2, 3

