require 'open-uri'

class WordProcessing

  @@wordandweightlist = Array.new
  @@wordfordisplaylist = Array.new


  #Words and their corrosponding weight
  class WordAndWeight
    attr_accessor :word, :weight
    def initialize(word , weight)
      @word = word
      @weight = Math.log(200000 /  weight.to_f) /10
    end
  end

 #Words that are going to be displayed
  class WordForDisplay
    attr_accessor :frequency, :formattedword, :weight, :word
    
    def initialize (word)
      @word = word
      @formattedword = @word
      @formattedword.gsub!(/\p{^Alnum}/, '')
      @formattedword.downcase!
      @frequency = 0
      @weight = 0

     
    end
    def increase_frequency
      @frequency += 1
      puts "Frequency Increased"
    end
    def getwordsize
      "font-size:#{weight}px"
    end
    

  end

  def self.create_word_list
    #Creating a list of words and their weights
    
    web_file = open("http://ucrel.lancs.ac.uk/bncfreq/lists/2_2_spokenvwritten.txt")
    web_file.each_line do |line|
      linesegment = line.split("\t")
      tempword = WordAndWeight.new( linesegment[1] , linesegment[3] )
      @@wordandweightlist << tempword
      puts "#{tempword.word}\t#{tempword.weight}"
    end
    @@wordandweightlist.shift
    @@wordandweightlist.shift


  end

  def self.process_form_data (formtext)
    puts formtext
    #Splitting the form imput
    text = formtext.split(" ")
    text.each do |word|
      tempword = WordForDisplay.new(word)
      @@wordfordisplaylist << tempword
    end


    #Frequency of the words within the form
    wordFrequencys = Hash.new(0)
    @@wordfordisplaylist.each do |displayword|
      wordFrequencys[displayword.formattedword] += 1
    end

    #Calculating weighing for each of the words
    @@wordfordisplaylist.each do |displayword|
      @@wordandweightlist.each do |wordandfrequency|
        if displayword.formattedword == wordandfrequency.word
          displayword.weight = wordandfrequency.weight
        end
      end

      displayword.weight = displayword.weight * wordFrequencys[displayword.formattedword] / @@wordfordisplaylist.length * 1000
      puts "#{displayword.weight} * #{wordFrequencys[displayword.formattedword]} / #{@@wordfordisplaylist.length}"
      puts displayword.weight
    end
    return @@wordfordisplaylist

  end
  def self.get_text_output
    @@wordfordisplaylist
  end


end

