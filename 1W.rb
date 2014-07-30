  #Gems

  require 'rubygems'
  require 'sinatra'
  require 'data_mapper'
  require 'time'


  #Data
  #
  		DataMapper.setup(:default, 'sqlite://C:\Users\Orbital Think Pa\Documents\GitHub\teleprompterhack')
  #
 # class Passwords 
#
# 		property :id
#
#
 # end
  #
  #Code

get '/' do
	@date = Time.now
	erb :index

end


post '/' do
	@text = params[:promptinput].to_s
end