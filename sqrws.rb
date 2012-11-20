require 'rubygems'
require 'sinatra'
require 'pg'

conn = PGconn.new("localhost", "5432", "", "", "redmine", "redmine", "redmine") 

get '/sing' do
  "In the wee small hours of the morning <br/> While the whole wide world is fast asleep <br/> You lie awake and think about the girl <br/> And never ever think of counting sheep <br/> When your lonely heart has learned it's lesson <br/> You'd be hers if only she would call <br/> In the wee small hours of the morning <br/> That's the time you miss her most of all"
end

get '/q/:name' do
  res = [] 
  File.open("sql/#{params[:name]}.sql", "r") do |f|
    conn.exec(f.read).each { |r| res << "\"#{r.values.join('","')}\"" }
  end
  res.join("\n").to_s
end

# next we'll add params to the query, eh?
