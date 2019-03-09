class Cli
  attr_accessor :scraper

  def initialize
    @scraper = Scraper.new
  end

  def call
    puts "Welcome to The Bump CLI!"
    set_stage
    scraper.get_articles

    puts "Please select an article:"
    display_article_titles
    article_choice = gets.chomp.to_i - 1
    until [*0..4].include?(article_choice)
      puts "Please select an article by its number"
      article_choice = gets.chomp.to_i - 1
    end

    show_article(article_choice)
  end

  def set_stage
    until [*0..4].include?(scraper.stage)
      get_stage_input
    end
  end

  def get_stage_input
    puts "What stage of pregnancy is your family in?"
    puts "Please select the number from the following options:"
    puts "1 - Getting Pregnant"
    puts "2 - First Trimester"
    puts "3 - Second Trimester"
    puts "4 - Third Trimester"
    puts "5 - Parenting"
    scraper.stage = gets.chomp.to_i - 1
  end

  def display_article_titles
    num = 1
    Article.all.each do |article|
      puts "#{num} - #{article.title}"
      num +=1
    end
  end

  def show_article(choice)
    article = Article.all[choice]
    paragraph = 0

    puts ""
    puts "#{article.title.colorize(:blue).underline}"
    puts "#{article.subtitle.colorize(:light_blue)}"
    puts "by #{article.author}"
    puts ""
    puts '(enter "c" to continue, or "exit" to exit)'
    until ['c','exit'].include?(gets.chomp)

  end

  def display_article_content(article)
  end
end
