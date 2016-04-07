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
	@db.execute 'CREATE TABLE IF NOT EXISTS Comments 
	( 
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		created_time DATE,
		content TEXT,
		autor TEXT,
		post_id INTEGER
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

  	if content.size <= 0 
  		@error = 'Type post text'
  		return erb :new
  	elsif autor.size <= 0
  		@error = 'Type autor text'	
  		return erb :new	
  	end
  	@db.execute ' insert into Posts (created_time,content,autor) values (datetime(), ?, ?)', [content, autor]
  	redirect to '/'
  	erb :new
  #erb "It is your post: #{content}, autor: #{autor}"
end

get '/details/:post_id' do 
	 post_id = params['post_id']
	 result = @db.execute 'select * from Posts where id= ?',[post_id]
	 @row = result[0]
	 @comments = @db.execute 'select * from Comments where post_id= ? order by id desc',[post_id]
 erb :details 

end

post '/details/:post_id'  do
	post_id = params['post_id']
	content = params[:content]
	autor   = params[:autor]
	
	@db.execute 'insert into Comments (created_time, content, autor, post_id ) values (datetime(), ?, ?, ?)', [content, autor, post_id]
	redirect to '/details/' + post_id
end


















