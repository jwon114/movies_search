DROP TABLE IF EXISTS search_history;
DROP TABLE IF EXISTS movies;

CREATE TABLE search_histories (
	id SERIAL PRIMARY KEY,
	search_name VARCHAR(300),
);

CREATE TABLE movies (
	id SERIAL PRIMARY KEY,
	title VARCHAR(300),
	year VARCHAR(10),
	rated VARCHAR(10),
	released VARCHAR(300),
	runtime VARCHAR(100),
	genre VARCHAR(300),
	director VARCHAR(300),
	actors VARCHAR(300),
	plot VARCHAR(600),
	language VARCHAR(300),
	poster VARCHAR(600),
	ratings JSON,
	imdb_id VARCHAR(300),
	movie_type VARCHAR(100),
	total_seasons VARCHAR(100)
);

CREATE TABLE movie_season_episodes (
	id SERIAL PRIMARY KEY,
	title VARCHAR(300),
	released VARCHAR(300),
	episode VARCHAR(100),
	imdb_rating VARCHAR(100),
	imdb_id VARCHAR(300),
	series_id VARCHAR(300),
	season VARCHAR(100)
);
