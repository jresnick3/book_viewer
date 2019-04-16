require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraph(string)
    string.split("\n\n").map.with_index do |paragraph, index|
    "<p id=\"#{index}\">#{paragraph}</p>"
    end
  end

  def display_paragraph(string)
    in_paragraph(string).join
  end

  def bold_match(query, paragraph)
    paragraph.gsub(query, "<strong>#{query}</strong>")
  end
end


not_found do
  redirect "/"
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i

  redirect "/" if @number > @contents.size

  @title = "Chapter #{@number}: #{@contents[@number - 1]}"
  @chapter = File.read("data/chp#{@number}.txt")
  erb :chapter_view
end

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = Hash.new([])

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    in_paragraph(contents).each_with_index do |paragraph, index|
      if paragraph.include?(query)
        paragraph = bold_match(query, paragraph)
        results[name] += [{chapter: number, par_num: index, content: paragraph}]
        puts results
      end
    end
  end

  results
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end
