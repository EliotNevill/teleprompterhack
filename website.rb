require 'rubygems'
require 'data_mapper' # requires all the gems listed above
require 'dm-migrations'
require 'sinatra'

require './word_processing'
require 'time'




# A Sqlite3 connection to a persistent database (should make relative to this script)
DataMapper.setup(:default, 'sqlite:///C:\Users\Orbital Think Pa\Documents\GitHub\teleprompterhack\project.db')


# Define a Post object to store a posted speech
class Post
  include DataMapper::Resource
  property :id,         Serial    # An auto-increment integer key
  property :title,      String    # A varchar type string, for short strings
  property :body,       Text      # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
end

# This list gives frequencies of word forms in the spoken part of the
# British National Corpus, comparing them with the written part, down to
# a minimum frequency of 10 per million words. 

# FrSp    = Frequency (per million words) in speech
# LL      = Log likelihood (a measure of distinctiveness between speech and writing)
# FrWr    = Frequency (per million words) in writing

class WordFreq
  include DataMapper::Resource
  property :id,         Serial #ID
  property :word,       String # The Word; Assume Lowercase
  property :pos,        String # Type of word
  property :f_spoken,   Integer # Frequency Spocken
  property :ll,         Float # Likelyhood
  property :f_writen,   Integer # Frequency Writen
end

#Word  PoS FrSp    LL  FrWr

DataMapper.finalize

#DataMapper.auto_migrate!

# Update any tables based on the defined schema
DataMapper.auto_upgrade!

#Create word-weight list
#WordProcessing.create_word_list


# Return the home page
get '/' do
  @date = Time.now
  erb :index
end

# List all speeches in the db
get '/posts' do
  @date = Time.now
  @posts = Post.all
  erb :Posts 
end

get '/posts/:id' do 
  id = params[:id]
  puts "Looking for post id: #{id}"
  @post = Post.get(id)
  erb :mypost
end


# Add a new post to the database send params through the POST request
post '/posts' do
  @post = Post.create(
    :title => params[:title],
    :body => params[:body],
    :created_at => Time.now
  )
  puts "Added a new post titled: #{@post.title}"
end



# Simple setup to add new test posts to the database
get '/setup' do
  # create makes the resource immediately
  @post = Post.create(
    title:       "My First Speech",
    body:        "This is my speech about Young Rewired State. I loved it. See you next year",
    created_at:  Time.now
  )

  @post.save
end

get '/getwords' do
  WordFreq.destroy
  wordcount = 0
  web_file = open("http://ucrel.lancs.ac.uk/bncfreq/lists/2_2_spokenvwritten.txt")
  

  web_file.each_line do |line|
    if wordcount > 0 then  # first line is header
      items = line.split("\t")
      puts items
      @word = WordFreq.new(
        word:        items[1],
        pos:         items[2],
        f_spoken:    items[3].to_i,
        ll:          items[5].to_f,
        f_writen:    items[6].to_i
      )
      if !@word.save then
        return "Failed to save"
      end
            puts @word.word
    end
    wordcount = wordcount+1 

    if wordcount > 5 then
     return "done 5 words"
    end 
    
  end
  "loaded #{wordcount} words"
end

get '/word/:word' do 
  word = params[:word]
  p word

  @wordinfo = WordFreq.first(:word => word)
  if !@wordinfo.nil? then
    erb :wordinfo
  end

end

get '/words' do
   @words = WordFreq.all
   erb :wordlist
end



#zoo  = Zoo.first(:name => 'Metro')

