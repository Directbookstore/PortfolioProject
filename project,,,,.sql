select * from porfolioTraining.dbo.dealth order by 3,4
--select * from porfolioTraining.dbo.Vacination 
--let select the data we are going to used 

select location, date,total_cases,new_cases,total_deaths,population
from porfolioTraining.dbo.dealth order by 1,2

 -- loking at total cases vs total dealth because we want to look at percentage of death rate 
 select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 DeathPercentage
from porfolioTraining.dbo.dealth order by 1,2
 
 select * from porfolioTraining.dbo.dealth dea join  porfolioTraining.dbo.Vacination vac on 
 dea.location = vac.location AND dea.date = vac.date 

 --Population vs vaccination 
 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
 from porfolioTraining.dbo.dealth dea join  porfolioTraining.dbo.Vacination vac on 
 dea.location = vac.location AND dea.date = vac.date where dea.continent is not null order by 2,3

 --use CTE

 With popvsvac(continent,location,date,population,new_vaccinations,rollingPeopleVaccinated) as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
 from porfolioTraining.dbo.dealth dea join  porfolioTraining.dbo.Vacination vac on 
 dea.location = vac.location AND dea.date = vac.date where dea.continent is not null --order by 2,3
)
select *, (rollingPeopleVaccinated/population)*100 from popvsvac

--temp table 
create table #percentagepopulationVaccinations
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population nvarchar(255),
new_vaccinations numeric,
rollingPeopleVaccinated numeric
)


insert into #percentagepopulationVaccinations

 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
 from porfolioTraining.dbo.dealth dea join  porfolioTraining.dbo.Vacination vac on 
 dea.location = vac.location AND dea.date = vac.date where dea.continent is not null --order by 2,3
 select *, (rollingPeopleVaccinated/population)*100 from #percentagepopulationVaccinations

 --creating views to store data  for  visualizaion
 create view percentagepopulationVaccinated as
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
 from porfolioTraining.dbo.dealth dea join  porfolioTraining.dbo.Vacination vac on 
 dea.location = vac.location AND dea.date = vac.date where dea.continent is not null --order by 2,3

 select * from percentagepopulationVaccinated

   