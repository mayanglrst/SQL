-- columns used
select
	location
	, date
	, total_cases
	, total_deaths
	, population
from death
where continent is not null

-- Indonesia monthly total death vs total cases
select
	location
	, to_char(date, 'yyyy-mm') date
	, sum(total_deaths) total_deaths
	, sum(total_cases) total_cases
	, round(sum(total_deaths) / sum(total_cases) * 100, 2) perc_death
from death
where location = 'Indonesia' 
group by 1,2
order by 1,2


-- Indonesia monthly total cases vs population
select
	location
	, to_char(date, 'yyyy-mm') date
	, sum(total_cases) total_cases
	, sum(population) total_population
	, sum(new_cases) total_new_cases
	, round(sum(total_cases) / sum(population) * 100, 2) perc_total_cases
	, round(sum(new_cases) / sum(population) * 100, 2) perc_new_cases
from death
where location = 'Indonesia'
group by 1,2
order by 1,2

-- Country with highest infection rate compared to population
select
	location
	, max(total_cases) highest_infection_count
	, max((total_cases/population)*100) as highest_infection_rate
from death
where total_cases is not null and population is not null and continent is not null
group by 1
order by 3 desc

-- Country with highest death rate compared to population
select
	location
	, max(total_deaths) highest_death_count
	, max((total_deaths/population)*100) as highest_deaths_rate
from death
where total_deaths is not null and population is not null and continent is not null
group by 1
order by 3 desc

-- Total deaths and total cases by continent
select
	continent
	, sum(total_deaths) total_deaths
	, sum(total_cases) total_cases
	, round(sum(total_deaths) / sum(total_cases) * 100, 2) perc_death
	, sum(population) total_population
	, sum(new_cases) total_new_cases
	, round(sum(total_cases) / sum(population) * 100, 2) perc_total_cases
	, round(sum(new_cases) / sum(population) * 100, 2) perc_new_cases
from death
where continent is not null
group by 1
order by 4 desc

-- Global numbers
select
	sum(total_deaths) total_deaths
	, sum(total_cases) total_cases
	, round(sum(total_deaths) / sum(total_cases) * 100, 2) perc_death
	, sum(population) total_population
	, sum(new_cases) total_new_cases
	, round(sum(total_cases) / sum(population) * 100, 2) perc_total_cases
	, round(sum(new_cases) / sum(population) * 100, 2) perc_new_cases
from death
where continent is not null
-- group by 1
order by 4 desc

-- Join tables more than one column. Total population vs total vaccinations
select 
	vacc.continent
	, sum(death.population) total_population
	, sum(new_vaccinations) total_new_vaccinations
	, round(sum(new_vaccinations) / sum(death.population) * 100, 2) perc_vacc
from death
join vacc on death.location = vacc.location
	and death.date = vacc.date
where vacc.continent is not null
group by 1
order by 1,2,3

select
	a.continent
	, a.location
	, a.date
	, a.population
	, b.new_vaccinations
	, total_vaccinations
from death a
join vacc b on a.location = b.location
	and a.date = b.date
where a.continent is not null
order by 2,3

-- new vaccinations is per day, we want to do rolling calculation per location
select
	a.continent
	, a.location
	, a.date
	, a.population
	, new_vaccinations
	, sum(new_vaccinations) over (partition by a.location order by a.location, a.date) rolling_over_vacc
from death a
join vacc b on a.location = b.location
	and a.date = b.date
where a.continent is not null
order by 2,3

-- how many people per country are vaccinated
-- 1st option: use CTE
with a as (
select
	a.continent
	, a.location
	, a.date
	, a.population
	, new_vaccinations
	, sum(new_vaccinations) over (partition by a.location order by a.location, a.date) rolling_over_vacc
from death a
join vacc b on a.location = b.location
	and a.date = b.date
where a.continent is not null
order by 2,3
)

select *
	, round((rolling_over_vacc/population)*100,2)
from a

-- Create view table to store data for later visualization
create view covid_vacc as 
with a as (
select
	a.continent
	, a.location
	, a.date
	, a.population
	, new_vaccinations
	, sum(new_vaccinations) over (partition by a.location order by a.location, a.date) rolling_over_vacc
from death a
join vacc b on a.location = b.location
	and a.date = b.date
where a.continent is not null
order by 2,3
)

select *
	, round((rolling_over_vacc/population)*100,2)
from a
