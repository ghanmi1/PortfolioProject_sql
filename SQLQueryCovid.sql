select *
from PortfolioProject..covidDeaths
where continent is not null 
order by 3,4

--update PortfolioProject..CovidVaccinations set new_deaths=NULL where new_deaths =0 


-- looking at total cases vs total deaths 
select location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as deathsPercentage 
from PortfolioProject..covidDeaths
where location like '%austra%'
order by 1,2

---looking at total case vs population 

select location , date , total_deaths , total_cases, population , (total_cases/population )*100 as CasesPercentage 
from PortfolioProject..covidDeaths
where location like '%belg%'
order by 1,2

---looking at countries with highest infection rate compared to population 
select location ,  MAX( total_cases) as highestInfection, population , MAX((total_cases/population ))*100 as infectionRAte
from PortfolioProject..covidDeaths
group by location , population 
order by infectionRAte desc

--- showing countries with highest death count per population  or continent 
select location , max(cast(total_deaths as int )) as total_deaths_count
from PortfolioProject..covidDeaths
where continent is  not null
group by location
order by total_deaths_count desc

--- let us break things by continent 
select continent  , max(cast(total_deaths as int )) as total_deaths_count
from PortfolioProject..covidDeaths
where continent is not  null 
group by continent  
order by total_deaths_count desc 

--- GLOBAL NUMBERS 
select  date , SUM(new_cases) as total_cases , sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) *100 as deathsPercentage 
from PortfolioProject..covidDeaths
--where location like '%austra%'
where continent is not null 
GROUP BY  date 
order by 1,2

select  SUM(new_cases) as total_cases , sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) *100 as deathsPercentage 
from PortfolioProject..covidDeaths
--where location like '%austra%'
where continent is not null 
--GROUP BY  date 
order by 1,2

--- join the two tables 

select dea.continent , dea.location, dea.date,dea.population , vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date) as RollingpeaopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..covidDeaths dea
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null 
order by 2,3

--- Use CTE

with PopulationVSvaccination (continent , location , date , population ,new_vaccinations, RollingPeaopleVaccinated )
as (
select dea.continent , dea.location, dea.date,dea.population , vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date) as RollingpeaopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..covidDeaths dea
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)

select * ,(RollingpeaopleVaccinated / population)*100
from PopulationVSvaccination

---- temp table 
drop table if exists #percentpopulationVaccinated
create table #percentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime , 
population numeric , 
New_vaccinations numeric , 
RollingPeaopleVaccinated numeric
)

insert into #percentpopulationVaccinated 
select dea.continent , dea.location, dea.date,dea.population , vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date) as RollingpeaopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..covidDeaths dea
     on dea.location=vac.location
	 and dea.date=vac.date
--where dea.continent is not null 
--order by 2,3

select * , (RollingpeaopleVaccinated /population)*100
from #percentpopulationVaccinated

--- creating view to store data for later visualization 
use PortfolioProject
go
create view percentpopulationVaccinated as 
select dea.continent , dea.location, dea.date,dea.population , vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date) as RollingpeaopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..covidDeaths dea
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null 
--order by 2,3


























