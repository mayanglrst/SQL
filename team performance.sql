CREATE TABLE team_all (
  id SERIAL primary key,
	season varchar(40),
	lg varchar(40),
	tm varchar(40),
	win integer,
	lose integer,
	finish integer,
	avg_player_age integer,
	avg_player_height integer,
	avg_player_weight integer,
	games integer,
	mp integer,
	fg integer,
	fga integer,
	fg_perc decimal(8,2),
	threept integer,
	threept_attempts integer,
	threept_perc decimal(8,2),
	ft integer,
	fta integer,
	ft_perc decimal(8,2),
	orb integer,
	drb integer,
	trb integer,
	ast integer,
	stl integer,
	blk integer,
	tov integer,
	pf integer,
	pts integer
)

COPY team_all(
season,
lg,
tm,
win,
lose,
finish,
avg_player_age,
avg_player_height,
avg_player_weight,
games,
mp,
fg,
fga,
fg_perc,
threept,
threept_attempts,
threept_perc,
ft,
fta,
ft_perc,
orb,
drb,
trb,
ast,
stl,
blk,
tov,
pf,
pts
)
FROM '/private/tmp/team_performance - sportsref_download (1).csv'
DELIMITER ','
CSV HEADER;

select * from team_all

-- create team_fact table
CREATE TABLE team_fact AS
select
	id,
	fg_perc,
	threept_perc,
	ft_perc
from team_all

select * from team_fact

-- create team_profile table
CREATE TABLE team_profile AS
select
	id,
	season,
	lg,
	tm,
	win,
	lose,
	finish,
	avg_player_age,
	avg_player_height,
	avg_player_weight
from team_all

select * from team_profile

-- create team_stats table
CREATE TABLE team_stats AS
select
	id,
	games,
mp,
fg,
fga,
threept,
threept_attempts,
ft,
fta,
orb,
drb,
trb,
ast,
stl,
blk,
tov,
pf,
pts
from team_all

select * from team_stats