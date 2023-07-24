
SELECT *
FROM coviddeaths
WHERE continent is not null
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
order by 1,2;

-- Total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
-- WHERE location like '%states%'
ORDER BY 1,2;

-- Looking at total cases vs population 
SELECT Location, date, total_cases, Population, (total_cases/population)*100 as DeathPercentage
FROM coviddeaths
-- WHERE location like '%states%'
ORDER BY 1,2;

-- Looking at countries with highest infection rate compared to population
SELECT location, Population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
FROM coviddeaths
-- WHERE location like '%states%'
GROUP BY Location, population
order by percentpopulationinfected desc;

-- Showing countries with highest death count per population
SELECT Location, MAX(total_deaths) as totaldeathcount
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc;

-- Showing continent with highest death count per population
SELECT Location, MAX(total_deaths) as totaldeathcount
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent is null
GROUP BY continent
ORDER BY TotalDeathCount desc;


-- Global Numbers
SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent is not null
-- GROUP BY date
ORDER BY 1,2;


-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3;

-- USE CTE
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;

-- Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
DATE datetime
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3;

-- Create view to store data for visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
-- order by 2,3
;

SELECT *
FROM PercentPopulationVaccinated