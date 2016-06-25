require 'sinatra'

get '/' do
  cache_control :public, max_age: 10
  "Hello World from Sinatra!"
end
