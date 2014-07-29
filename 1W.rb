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


post '/' do
	text = params[:text].to_s
	@text = text
end

puts @text