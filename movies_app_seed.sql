TRUNCATE TABLE MOVIES;
TRUNCATE TABLE SEARCH_HISTORIES;

ALTER SEQUENCE movies_id_seq RESTART WITH 1;
ALTER SEQUENCE search_histories_id_seq RESTART WITH 1;

INSERT INTO MOVIES (
	title, 
	year, 
	rated, 
	released, 
	runtime, 
	genre, 
	director, 
	actors, 
	plot, 
	language, 
	poster, 
	ratings, 
	imdb_id,
	movie_type,
	total_seasons) 
VALUES (
	'Thor: The Dark World', 
	'2013', 
	'PG-13', 
	'08 Nov 2013', 
	'112 min',
	'Action, Adventure, Sci-Fi', 
	'Alan Taylor', 
	'Chris Hemsworth, Natalie Portman, Tom Hiddleston, Anthony Hopkins', 
	'When Dr. Jane Foster gets cursed with a powerful entity known as the Aether, Thor is heralded of the cosmic event known as the Convergence and the genocidal Dark Elves.', 
	'English', 
	'https://images-na.ssl-images-amazon.com/images/M/MV5BMTQyNzAwOTUxOF5BMl5BanBnXkFtZTcwMTE0OTc5OQ@@._V1_SX300.jpg', 
	'[{"Source": "Internet Movie Database","Value": "7.0/10"},{"Source": "Rotten Tomatoes","Value": "66%"},{"Source": "Metacritic","Value": "54/100"}]', 
	'tt1981115',
	'movie',
	null);

INSERT INTO MOVIE_SEASON_EPISODES (
	title, 
	released,
	episode,
	imdb_rating,
	imdb_id,
	series_id,
	season) 
VALUES (
	'Winter Is Coming', 
	'2011-04-07',
	'1',
	'9.5', 
	'tt1480055',
	'tt0944947',
	'1');

INSERT INTO MOVIE_SEASON_EPISODES (
	title, 
	released,
	episode,
	imdb_rating,
	imdb_id,
	series_id,
	season) 
VALUES (
	'The Kingsroad', 
	'2011-04-24',
	'2',
	'8.8', 
	'tt1668746',
	'tt0944947',
	'1');


