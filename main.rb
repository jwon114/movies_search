require 'sinatra'
# require 'sinatra/reloader'
require 'httparty'
require 'json'
require 'uri'
require 'typhoeus'
require_relative 'db_config'
require_relative 'models/movie'
require_relative 'models/search_history'
require_relative 'models/movie_season_episode'
# require 'pry'

API_KEY = ENV["OMDB_API_KEY"]

helpers do 
	def add_movie(movie)

		movie_info = {
			title: movie["Title"],
			year: movie["Year"],
			rated: movie["Rated"],
			released: movie["Released"],
			runtime: movie["Runtime"],
			genre: movie["Genre"],
			director: movie["Director"],
			actors: movie["Actors"],
			plot: movie["Plot"],
			language: movie["Language"],
			poster: movie["Poster"],
			ratings: (JSON.generate movie["Ratings"]), # need to generate JSON because ruby parses into a hash with hash rockets
			imdb_id: movie["imdbID"],
			movie_type: movie["Type"]
		}

		if movie["Type"] == "series"
			movie_info[:total_seasons] = movie["totalSeasons"].to_i
		end

		new_movie = Movie.create(movie_info)
	end

	def build_ratings_images(ratings)
		movie_ratings = []
		ratings.each do |rating|
			case rating["Source"]
				when "Internet Movie Database"
					ratings_image = "<i class='fa fa-imdb fa-5x'></i>"
					ratings_value = "<i class='fa fa-star'></i>" + rating["Value"]
				when "Rotten Tomatoes"
					if rating["Value"].gsub("%", "").to_i >= 60
						ratings_image = "<img class='ratings_icon' src='../images/fresh.png' alt=''>"
						ratings_value = rating["Value"]
					else 
						ratings_image = "<img class='ratings_icon' src='../images/rotten.png' alt=''>"
						ratings_value = rating["Value"]
					end
				when "Metacritic"
					ratings_image = "<img class='ratings_icon' src='../images/Metacritic.png' alt=''>"
					ratings_value = rating["Value"]
			end

			movie_ratings << { :image => ratings_image, :value => ratings_value }
		end
		return movie_ratings
	end

	def add_episode(episode)
		
		new_episode = MovieSeasonEpisode.new
		new_episode.title = episode["Title"]
		new_episode.year = episode["Year"]
		new_episode.rated = episode["Rated"]
		new_episode.released = episode["Released"]
		new_episode.season = episode["Season"]
		new_episode.episode = episode["Episode"]
		new_episode.runtime = episode["Runtime"]
		new_episode.genre = episode["Genre"]
		new_episode.director = episode["Director"]
		new_episode.writer = episode["Writer"]
		new_episode.actors = episode["Actors"]
		new_episode.plot = episode["Plot"]
		new_episode.language = episode["Language"]
		new_episode.country = episode["Country"]
		new_episode.poster = episode["Poster"]
		new_episode.ratings = (JSON.generate episode["Ratings"])
		new_episode.imdb_rating = episode["imdbRating"]
		new_episode.imdb_id = episode["imdbID"]
		new_episode.series_id = episode["seriesID"]
		new_episode.movie_type = episode["Type"]

		new_episode.save
	end

end


get '/' do

  	erb :index
end

get '/movie_listing/:title' do

	result = HTTParty.get("http://omdbapi.com/?apikey=#{API_KEY}&s=#{params[:title]}")

	if result["Response"] == "False"
		@error = result["Error"]
		erb :error
	elsif result["Response"] == "True"
		history = SearchHistory.create(title: params[:title])
		# check totalResults count to see if there is only one result. redirect to
		if result["totalResults"] == "1"
			redirect to("/movie/#{result['Search'][0]['imdbID']}")
		else
			@movie_listing_data = result["Search"]
			erb :movie_listing
		end
	end

end

get '/movie_listing' do
	if params[:title].empty?
		@error = "No title searched"
		erb :error
	else 
		redirect '/movie_listing/' + URI.encode(params[:title])
	end
end

get '/movie/:id' do
	# search for title in database, if present then retrieve, otherwise send http request and save to db
	movie_result = Movie.where(imdb_id: params[:id]).first

	if movie_result
		puts 'got movie from local database'
		@movie_data = movie_result
		# movie_results query returns the ratings JSON as a string. Need to parse back into JSON to loop through it
		ratings = JSON.parse movie_result.ratings
		@movie_ratings = build_ratings_images(ratings)
		@seasons = movie_result.total_seasons
	else
		result = HTTParty.get("http://omdbapi.com/?apikey=#{API_KEY}&i=#{params[:id]}")
		if result["Response"] == "False"
			@error = result["Error"]
			erb :error
		elsif result["Response"] == "True"
			puts 'adding movie to local database'
			add_movie(result)
			movie_result = Movie.where(imdb_id: params[:id]).first
			@movie_data = movie_result
			# movie_results query returns the ratings JSON as a string. Need to parse back into JSON to loop through it
			ratings =  JSON.parse movie_result.ratings
			@movie_ratings = build_ratings_images(ratings)
			@seasons = movie_result.total_seasons
		end
	end

	erb :movie
end

get '/movie/:id/:season' do

	episode_result = HTTParty.get("http://omdbapi.com/?apikey=#{API_KEY}&i=#{params[:id]}&season=#{params[:season]}")
	if episode_result["Response"] == "False"
		@error = episode_result["Error"]
		erb :error
	elsif episode_result["Response"] == "True"
		episode_list = episode_result["Episodes"]
		# if the number of episodes does not equals the number in the database then fetch again and store
		if MovieSeasonEpisode.where(series_id: params[:id], season: params[:season]).count != episode_list.count
			# Use Typhoeus gem for HTTP get and Hydra for multipl concurrent requests
			hydra = Typhoeus::Hydra.new(max_concurrency: 2)
			requests = episode_list.map do |episode|
				request = Typhoeus::Request.new("http://omdbapi.com/?apikey=#{API_KEY}&i=#{episode['imdbID']}")
				hydra.queue(request)
				request
			end
			hydra.run

			requests.each do |response|
				add_episode(JSON.parse(response.response.body))
			end
		end
		@episodes = MovieSeasonEpisode.where(series_id: params[:id], season: params[:season]).order("episode ASC")
	end

	erb :season_listing
end

get '/history' do

	# gets the unique last 10 rows from search_histories table
	search_history_sql = "
		SELECT title FROM (SELECT title, MAX(id) as id 
		FROM search_histories 
		GROUP BY title) 
		AS filtered_query 
		ORDER BY id desc 
		LIMIT 10;" 

	history = SearchHistory.find_by_sql(search_history_sql)
	@search_history = []
	history.each do |search|
		@search_history << search[:title]
	end

	erb :history
end








