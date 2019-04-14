require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @chapters = File.readlines("data/toc.txt")
  @title = "Sherlock Holmes"
  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @chapters = File.readlines("data/toc.txt")
  @text = File.read("data/chp1.txt")
  erb :chapter_view
end
