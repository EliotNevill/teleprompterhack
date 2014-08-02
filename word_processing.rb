require 'open-uri'

class WordProcessing

  @@wordandweightlist = Array.new
  @@wordfordisplaylist = Array.new


  #Words and their corrosponding weight
  class WordAndWeight
    attr_accessor :word, :weight
    def initialize(word , weight)
      @word = word
      @weight = Math.log(1000000 /  weight.to_f, 1.36)
    end
  end

 #Words that are going to be displayed
  class WordForDisplay
    attr_accessor :frequency, :formattedword, :weight, :word, :iscolour
    
    def initialize (word)
      @word = word
      @formattedword = "#{word}"
      @frequency = 0
      @weight = 0
      @iscolour = 0
    end
    def increase_frequency
      @frequency += 1
      puts "Frequency Increased"
    end
    def getwordsize
      "font-size:#{weight}px"
    end
    def format_word
      @formattedword.gsub!(/\p{^Alnum}/, '')
      @formattedword.downcase!
    end
    
    

  end

  def self.create_word_list
    #Creating a list of words and their weights
    false_freq = 0
    counter = 8
    web_file = open("http://ucrel.lancs.ac.uk/bncfreq/lists/2_2_spokenvwritten.txt")
    web_file.each_line do |line|
      linesegment = line.split("\t")
      tempword = WordAndWeight.new( linesegment[1] , linesegment[3] )
      @@wordandweightlist << tempword
      puts "#{tempword.word}\t#{tempword.weight}\t#{false_freq}"
      false_freq = counter ** 1.36
      counter = counter + 1
    end
    @@wordandweightlist.shift
    @@wordandweightlist.shift


  end

  def self.process_form_data (formtext)
    @@wordfordisplaylist.clear
    puts formtext
    #Splitting the form imput
    text = formtext.split(" ")
    puts text
    text.each do |word|
      tempword = WordForDisplay.new(word)
      tempword.format_word
      @@wordfordisplaylist << tempword
      puts tempword.word
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
      if is_number?(displayword.formattedword)
        displayword.iscolour = 1
        puts "is colour"
      end
      puts "#{displayword.weight}    /    #{wordFrequencys[displayword.formattedword]}"
      displayword.weight = displayword.weight  / wordFrequencys[displayword.formattedword]
    end
    mutiplier = 0
    @@wordfordisplaylist.each do |displayword|
      mutiplier = displayword.weight + mutiplier
    end
      mutiplier = 10 /  (mutiplier / @@wordfordisplaylist.length)
    @@wordfordisplaylist.each do |displayword|
      displayword.weight = displayword.weight * mutiplier + 20
      if displayword.weight > 40
        displayword.weight = 40
      end

    end
    

    return @@wordfordisplaylist

  end
  def self.get_text_output
    @@wordfordisplaylist
  end
  def self.is_number? (number)
    true if Float(number) rescue false
  end


end

