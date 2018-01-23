class Movie < ActiveRecord::Base
	has_many :movie_season_episodes
end