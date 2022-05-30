/*Queries used for Tableau Project*/

--1.
select	sum(new_cases) as total_cases,
		sum(cast(new_deaths as int)) as total_deaths,
		sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
--group By date
order by 1,2

--Doublecheck base off the data provided
--we found that numbers are extremely close so we will keep these "The second include "International" location"

--select	sum(new_cases) as total_cases,
--			sum(cast(new_deaths as int)) as total_deaths,
--			sum(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths$
----where location like '%states%'
--where location = 'World'
----group By date
--order by 1,2

-- 2. 
-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

select	location, 
		sum(cast(new_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths$
--Where location like '%states%'
where	continent is null 
		and location not in ('World', 'European Union', 'International')
group by location
order by totaldeathcount desc

-- 3.
select	location, 
		population, 
		max(total_cases) as HighestInfectionCount,
		max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--Where location like '%states%'
group by location, population
order by PercentPopulationInfected desc

-- 4.
select	location,
		population,
		date, 
		max(total_cases) as HighestInfectionCount,
		max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--Where location like '%states%'
group by location, population, date
order by PercentPopulationInfected desc

-- 5.
select	dea.continent, 
		dea.location, 
		dea.date, 
		dea.population,
		max(vac.total_vaccinations) as RollingPeopleVaccinated
--		, (RollingPeopleVaccinated/population)*100
from	PortfolioProject..CovidDeaths$ dea
join	PortfolioProject..CovidVaccinations$ vac
on		dea.location = vac.location
	and	dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3

--6.
select	sum(new_cases) as total_cases,
		sum(cast(new_deaths as int)) as total_deaths,
		sum(cast(new_deaths as int))/sum(New_Cases)*100 as DeathPercentage
from	PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null 
--group by date
order by 1,2

--Doublecheck base off the data provided
--we found that numbers are extremely close so we will keep these "The second include "International" location"

--select	sum(new_cases) as total_cases,
--			sum(cast(new_deaths as int)) as total_deaths,
--			sum(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths$
----where location like '%states%'
--where location = 'World'
----group By date
--order by 1,2

--7.
-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe
select	location, 
		sum(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is null 
and location not in ('World', 'European Union', 'International')
group by location
order by TotalDeathCount desc

--8.
select	location,
		population, 
		max(total_cases) as HighestInfectionCount,
		max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--9.
--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
select	location, 
		date, 
		population, 
		total_cases, 
		total_deaths
from	PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null 
order by 1,2

--10.
with PopvsVac (
		continent, 
		location, 
		date, 
		population, 
		New_Vaccinations, 
		RollingPeopleVaccinated)
as (
select	dea.continent, 
		dea.location, 
		dea.date, 
		dea.population, 
		vac.new_vaccinations, 
		sum(convert(int,vac.new_vaccinations)) 
over	(partition by dea.Location 
		order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as PercentPeopleVaccinated
From PopvsVac

--11.
select	location, 
		population,
		date, 
		max(total_cases) as HighestInfectionCount,
		max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--Where location like '%states%'
group by location, population, date
order by PercentPopulationInfected desc