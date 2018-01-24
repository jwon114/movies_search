DROP TABLE IF EXISTS search_histories;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS movie_season_episodes;

CREATE TABLE search_histories (
	id SERIAL PRIMARY KEY,
	search_name VARCHAR(300)
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
	total_seasons INTEGER
);

CREATE TABLE movie_season_episodes (
	id SERIAL PRIMARY KEY,
	title VARCHAR(300),
	year VARCHAR(10),
	rated VARCHAR(10),
	released VARCHAR(300),
	season INTEGER,
	episode INTEGER,
	runtime VARCHAR(100),
	genre VARCHAR(300),
	director VARCHAR(300),
	writer VARCHAR(600),
	actors VARCHAR(600),
	plot VARCHAR(600),
	language VARCHAR(300),
	country VARCHAR(100),
	poster VARCHAR(600),
	ratings JSON,
	imdb_rating VARCHAR(100),
	imdb_id VARCHAR(300),
	series_id VARCHAR(300),
	movie_type VARCHAR(100)
);
