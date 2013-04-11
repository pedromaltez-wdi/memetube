########
# GEMS #
########

require 'sinatra'
require 'sinatra/reloader' if development?
require 'mongo_mapper'
require 'json'
# require 'newrelic_rpm' if production?

##########
# MODELS #
##########

# Video model
class Video
	include MongoMapper::Document

	key :title,				String, :required => true
	key :description,       String
	key :url,				String, :required => true
	key :created_at,		Time,   :required => true

	# many :comments
end

# Comment model
# class Comment
# 	include MongoMapper::Document
# 	key :textarea,			String, :required => true
# 	key :created_at,		Time,   :required => true

# 	belongs_to :dogs
# end

###########
# DOG APP #
###########

class MemeTubeApp < Sinatra::Base

	##############
	# DEV CONFIG #
	##############
	configure :development do
		register Sinatra::Reloader
		MongoMapper.database = 'memetube_db'
	end

	#################
	# HEROKU CONFIG #
	#################
	# configure :production do
	# 	regex_match = /.*:\/\/(.*):(.*)@(.*):(.*)\//.match(ENV['MONGOLAB_URI'])
	# 	host = regex_match[3]
	# 	port = regex_match[4]
	# 	db_name = regex_match[1]
	# 	pw = regex_match[2]

	# 	MongoMapper.connection = Mongo::Connection.new(host, port)
	# 	MongoMapper.database = db_name
	# 	MongoMapper.database.authenticate(db_name, pw)
	# end
	
	###############
	# HTML ROUTES #
	###############

	# Route: Home
	get '/' do
		videos = Video.sort(:created_at).last()
		erb :home, locals: { videos: videos }
	end

	get '/list' do
		videos = Video.all()
		erb :list, locals: { videos: videos }
	end

	# # Route: Dog detail
	# get '/video/:id' do
	# 	video = Video.find(params[:id])
	# 	erb :video, locals:
	# end

	# Route: Create Dog

	get '/videos/:id' do
		videos = Video.find(params[:id])
		erb :videos, locals: { videos: videos }
	end

	get '/add' do
		erb :add
	end

	post '/video' do
		new_video = {
			title: params[:video_title],
			description: params[:video_description],
			url: params[:video_url],
			created_at: Time.now
		}
		Video.new(new_video).save!
		redirect '/'
	end

	# # Route: Delete Dog
	# get '/dog/delete/:id' do
	# 	Dog.destroy(params[:id])
	# 	redirect '/'
	# end

	# # Route: Create Breed
	# post '/breed' do
	# 	new_breed = {
	# 		name: params[:breed_name],
	# 		created_at: Time.now,
	# 	}
	# 	Breed.new(new_breed).save!
	# 	redirect '/'
	# end

	# # Route: Delete Breed
	# get '/breed/delete/:id' do
	# 	breed_id = params[:id]

	# 	# Destroy any documents that reference this breed
	# 	dogs = Dog.destroy_all({ breed_id: breed_id })

	# 	# Destroy the breed
	# 	Breed.destroy(breed_id)

	# 	redirect '/'
	# end









	get '/about' do
		erb :about
	end
	
	get '/faq' do
		erb :faq
	end
	
	get '/contact' do
		erb :contact
	end





end
