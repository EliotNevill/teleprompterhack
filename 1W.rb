  #Gems

  require 'rubygems'
  require 'sinatra'
  require 'time'


  #Data
  #
  #
  #
  #Code

get '/' do
	@date = Time.now
	erb :index
end


