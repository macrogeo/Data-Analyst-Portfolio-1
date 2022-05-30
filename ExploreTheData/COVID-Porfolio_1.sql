--Explore the dataset
select *
from PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations$
--where continent is not null
--order by 3,4

--select the data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--looking at total cases vs total deaths
--shows the likelihood of dying if you contract covid in Thailand
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths$
where location like 'thai%' and continent is not null
order by 1,2

--looking at total cases vs population
--shows what percentage of population got covid in Thailand
select location, date, population, total_cases, (total_cases/population)*100 as percentage_of_infection
from PortfolioProject..CovidDeaths$
where location like 'thai%' and continent is not null
order by 1,2

--shows what percentage of population got covid around the world
select location, date, population, total_cases, (total_cases/population)*100 as percentage_of_infection
from PortfolioProject..CovidDeaths$
where continent is not null
--where location like 'thai%'
order by 1,2

--looking at country with highest infection rate compared to population
select location, population, max(total_cases) as highest_infection_count, MAX(total_cases/population)*100 as percentage_of_infection
from PortfolioProject..CovidDeaths$
--where location like 'thai%'
where continent is not null
group by location, population
order by 4 desc

--showing country with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
--use cast() to certify that total_deaths is definitely int to prevent error by var type
from PortfolioProject..CovidDeaths$
--where location like 'thai%'
where continent is not null
group by location
order by TotalDeathCount desc

--Let's break things down by continent
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like 'thai%'
where continent is null
group by location
order by TotalDeathCount desc

--showing the continent with the highest death count per population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
--use cast() to certify that total_deaths is definitely int to prevent error by var type
from PortfolioProject..CovidDeaths$
--where location like 'thai%'
where continent is not null
group by continent
order by TotalDeathCount desc

--global numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
--where location like 'thai%' 
where continent is not null
--group by date
order by 1,2

--looking at total population vs vaccinations
--use cte
with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*10
from PortfolioProject..CovidDeaths$ as dea
join PortfolioProject..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100
From popvsvac

--temp table
drop Table #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*10
from PortfolioProject..CovidDeaths$ as dea
join PortfolioProject..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (rollingpeoplevaccinated/population)*100
From #percentpopulationvaccinated


--creating view to store data for later visualizations
create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*10
from PortfolioProject..CovidDeaths$ as dea
join PortfolioProject..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated