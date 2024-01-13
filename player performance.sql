CREATE TABLE player_all (
  player_id SERIAL primary key,
	player_name varchar(40),
	first_year varchar(40),
	last_year varchar(40),
	years integer,
	g integer,
	mp integer,
	fg integer,
	fga integer,
	threept integer,
	threept_attempts integer,
	ft integer,
	fta integer,
	orb integer,
	trb integer,
	ast integer,
	stl integer,
	blk integer,
	tov integer,
	pf integer,
	pts integer,
	fg_perc decimal (8,2),
	threept_perc decimal (8,2),
	ft_perc decimal (8,2),
	avg_mp decimal (8,2),
	avg_pts decimal (8,2),
	avg_trb decimal (8,2),
	avg_ast decimal (8,2)
)



COPY player_all(
	player_name,
	first_year,
	last_year,
	years,
	g,
	mp,
	fg,
	fga,
	threept,
	threept_attempts,
	ft,
	fta,
	orb,
	trb,
	ast,
	stl,
	blk,
	tov,
	pf,
	pts,
	fg_perc,
	threept_perc,
	ft_perc,
	avg_mp,
	avg_pts,
	avg_trb,
	avg_ast
)
FROM '/private/tmp/player_performance - sportsref_download.csv'
DELIMITER ','
CSV HEADER;

select * from player_all

-- create player_profile table
CREATE TABLE player_profile AS
select
	player_id,
	player_name,
	first_year,
	last_year,
	years
from player_all

select * from player_profile

-- create player_stats table
CREATE TABLE player_stats AS
select
	player_id,
	g,
	mp,
	fg,
	fga,
	threept,
	threept_attempts,
	ft,
	fta,
	orb,
	trb,
	ast,
	stl,
	blk,
	tov,
	pf,
	pts
from player_all

select * from player_stats

-- create player_fact table
CREATE TABLE player_fact AS
select
	player_id,
	fg_perc,
	threept_perc,
	ft_perc,
	avg_mp,
	avg_pts,
	avg_trb,
	avg_ast
from player_all

select * from player_fact