#encoding: utf-8

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def init_db
	@db = SQLite3::Database.new 'lepro.db'
	@db.results_as_hash = true

end

before do 
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts 
	( 
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		created_time DATE,
		content TEXT,
		autor TEXT
	)'


end


get '/' do
	@result = @db.execute 'select * from Posts order by id desc'
	erb :index
end
get '/new' do
  	erb :new
end

post '/new' do
  content = params[:content]
  autor   = params[:autor]
  	@db.execute ' insert into Posts (created_time,content,autor) values (datetime(), ?, ?)', [content, autor]
  	
  erb "It is your post: #{content}, autor: #{autor}"
end




