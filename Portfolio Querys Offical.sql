---- Selecting the Data that will be used in this project
--Select Location, date, total_cases, new_cases, total_deaths, population
--From Covid19PortfolioProject..CovidDeaths
--order by 1,2

---- Looking at Total Cases vs Total Death per country 
--Select Location, date, total_cases, total_deaths, (CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0)) * 100 as death_percentage
--From Covid19PortfolioProject..CovidDeaths
--order by 1,2

---- Looking at Total Cases vs Total Death in the UK
--Select Location, date, total_cases, total_deaths, (CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0)) * 100 as death_percentage
--From Covid19PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
--order by 1,2

---- Looking at Total Cases vs Population in the UK
--Select Location,date, total_cases, population, (CONVERT(float,total_cases)/CONVERT(float,population)) * 100 as percentage_infected
--From Covid19PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
--order by 1,2

---- Looking at countries with highest infection rates compared to population
--Select Location, population, MAX(total_cases) as highest_infection_count, MAX(CONVERT(float,total_cases)/CONVERT(float,population)) * 100 as percentage_infected
--From Covid19PortfolioProject..CovidDeaths
--Group by location, population
--order by percentage_infected desc

---- Looking at countries witht highest death rates compared to population
--Select Location,MAX(cast(total_deaths as int)) as total_death_count
--from Covid19PortfolioProject..CovidDeaths
--where continent is not null
--group by location
--order by total_death_count desc

---- Looking at deaths broke down in continents
--Select location,MAX(cast(total_deaths as int)) as total_death_count
--from Covid19PortfolioProject..CovidDeaths
--where location  not LIKE '%income%' and location not like '%world%' and location not like '%union%' and continent is null
--group by location
--order by total_death_count desc


------ Looking at Total Cases vs Total Death in the UK
--Select Location, date, total_cases, total_deaths, (CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0)) * 100 as death_percentage
--From Covid19PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
--order by 1,2

---- Global Numbers
---- Here I had problems with 0 in the data do I used NULLIF to stop divide by zero errors 
--Select date, SUM(new_cases) as cases_per_day, SUM(new_deaths) as death_per_day,	 NULLIF(SUM(new_deaths),0)/NULLIF(SUM(new_cases),0)*100 as death_percentage 
--From Covid19PortfolioProject..CovidDeaths
--where continent is not null
--Group by date
--order by 1,2


-- Joining tables deaths and vaccinations together
--select *
--from Covid19PortfolioProject..CovidDeaths dea
--Join Covid19PortfolioProject..CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date

---- Looking at Total Population vs Vaccinations
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date ) as total_vaccines 
--from Covid19PortfolioProject..CovidDeaths dea
--Join Covid19PortfolioProject..CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

-- USE CTE

--with PopvsVac(Continent, location, date, population,new_vaccinations, total_vaccines)
--as(
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date ) as total_vaccines 
--from Covid19PortfolioProject..CovidDeaths dea
--Join Covid19PortfolioProject..CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null

--)
--Select *, (total_vaccines/population) * 100 as percentage_of_population_vacced
--From PopvsVac

-- TEMP TABLE


--DROP Table if exists #PercentOfPopulationVaccinated
--Create Table #PercentOfPopulationVaccinated
--(
--continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--total_vaccines numeric
--)

--Insert into #PercentOfPopulationVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date ) as total_vaccines 
--from Covid19PortfolioProject..CovidDeaths dea
--Join Covid19PortfolioProject..CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null

--Select *, (total_vaccines/population) * 100 as percentage_of_population_vacced
--From #PercentOfPopulationVaccinated

-- Create View

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date ) as total_vaccines 
from Covid19PortfolioProject..CovidDeaths dea
Join Covid19PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
