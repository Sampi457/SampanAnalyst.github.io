SELECT *FROM PortfolioProject.. CovidDeaths

SELECT *FROM PortfolioProject.. CovidVacc

SELECT Location, date, total_cases, new_cases,total_deaths, population
FROM PortfolioProject.. CovidDeaths
ORDER BY 1,2

-- Looking at total cases vs total deaths
--Showcases likeihood of dying if you contract covid 

-- Death percentage across the world
SELECT 
  Location, 
  date, 
  total_cases, 
  total_deaths,
  (CAST(total_deaths AS FLOAT) / total_cases) * 100 AS Death_percentage  
FROM PortfolioProject..CovidDeaths;


-- Death percentage in the United Kingdom
SELECT 
  Location, 
  date, 
  total_cases, 
  total_deaths,
  (CAST(total_deaths AS FLOAT) / total_cases) * 100 AS Death_percentage  
FROM PortfolioProject..CovidDeaths
Where Location LIKE '%United Kingdom%';

--Looking at total cases vs population in the world
-- Showcases how much of the population were infected with Covid
SELECT 
  Location, 
  date, 
  Population,
  total_cases, 
  (CAST(total_cases AS FLOAT) / population) * 100 AS Infection_percentage  
FROM PortfolioProject..CovidDeaths
Where Location LIKE '%United Kingdom%';

-- Looking at Countries with highest infection rates compared to populations

SELECT 
  Location, 
  Population,
  max(total_cases) as HighestInfectionCount,
  (CAST(max(total_cases) AS FLOAT) / population) * 100 AS PercentagePopulationInfected  
FROM PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentagePopulationInfected  DESC

-- Looking at countries with the highest death count
SELECT
Location, MAX(cast(Total_deaths as int))as Totaldeathcount
From PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
Group by location
order by TotalDeathCount desc

-- Looking at Countries with highest death count compared to populations

SELECT 
  Location, 
  max(total_deaths) as HighestDeathCount,
  (CAST(max(total_deaths) AS FLOAT) / population) * 100 AS PercentagePopulationDead 
FROM PortfolioProject..CovidDeaths
Group by Location
Order by PercentagePopulationDead  DESC


-- Looking at continents with the highest death count
SELECT
location, MAX(cast(Total_deaths as int))as Totaldeathcount
From PortfolioProject..CovidDeaths
WHERE continent is NULL
Group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS consisting of total cases, deaths and death percentage across the world
SELECT
date,
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS INT)) AS total_deaths,
  SUM(CAST(new_deaths AS FLOAT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

SELECT
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS INT)) AS total_deaths,
  SUM(CAST(new_deaths AS FLOAT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Life expectancy vs death

SELECT
  dea.location,
  MAX(CAST(dea.total_deaths AS INT)) AS TotalDeathCount,
  MAX(CAST(dea.population AS FLOAT)) AS population,
  MAX(vac.gdp_per_capita) AS gdp_per_capita,
  MAX(vac.life_expectancy) AS life_expectancy,
  -- Calculate deaths per million
  MAX(CAST(dea.total_deaths AS FLOAT)) / MAX(CAST(dea.population AS FLOAT)) * 1000000 AS deaths_per_million
FROM PortfolioProject..CovidDeaths dea
INNER JOIN PortfolioProject..CovidVacc vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.location
ORDER BY deaths_per_million DESC;

