require 'rubygems'
require 'data_mapper' # requires all the gems listed above
require 'dm-migrations'
require 'sinatra'
require 'erb'


#require './word_processing'
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
 
 post "/" do
  @text = params['promptinput']
  puts "#{@text}"
 end
 
 # List all speeches in the db
 get '/posts' do
 	@date = Time.now
 	@posts = Post.all
  erb :posts 
 end

 # Add a new post to the database send params through the POST request
 post '/add' do
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
     :title      => "My First Speech",
     :body       => "This is my speech about Young Rewired State. I loved it. See you next year",
     :created_at => Time.now
   )

   @post.save
 end
 
 
 
 
 
 
 