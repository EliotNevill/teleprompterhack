require 'open-uri'

class WordProcessing
  #Words and their corrosponding weight
  class WordAndWeight
    def initialize(word , weight)
      @word = word
      @weight = Math.log(200000 /  weight.to_f) /10
    end
  end

  def self.create_word_list
    #Creating a list of words and their weights
    wordandweightlist = Array.new
    web_file = open("http://ucrel.lancs.ac.uk/bncfreq/lists/2_2_spokenvwritten.txt")
    web_file.each_line do |line|
      linesegment = line.split("\t")
      tempWord = WordAndWeight.new( linesegment[1] , linesegment[3] )
      wordandweightlist.push(tempWord)
      puts "#{wordandweightlist.last.instance_variable_get("@word")}\t#{wordandweightlist.last.instance_variable_get("@weight")}"
    end
    wordandweightlist.pop()
    wordandweightlist.pop()
  end
  


end