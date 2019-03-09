class Scraper
  attr_accessor :stage

  def initialize
    @stage = ""
  end

  def set_stage
    while @stage == ""
      get_stage_input
    end
  end

  def get_stage_input
    puts "What stage of pregnancy is your family in?"
    puts "Please select the number from the following options:"
    choice = gets.chomp
    case choice
    when 1
      @stage = "Planning a Family"
    when 2
      @stage = "First Trimester"
    when 3
      @stage = "Second Trimester"
    when 4
      @stage = "Third Trimester"
    when 5
      @stage = "Parenting"
    else
      @stage = ""
    end
  end

  def get_articles
  end
end
