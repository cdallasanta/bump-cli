class Cli
  attr_accessor :scraper

  def initialize
    @scraper = Scraper.new
    Article.reset_all
  end

  def call
    puts "Welcome to The Bump CLI!".colorize(:blue)
    set_stage
    scraper.get_articles

    puts "Please select an article:".colorize(:blue)
    display_article_titles
    article_choice = gets.chomp.to_i - 1
    until [*0..4].include?(article_choice)
      puts "Please select an article by its number".colorize(:blue)
      article_choice = gets.chomp.to_i - 1
    end

    show_article_header(article_choice)
    show_article_content(article_choice, 0)

    puts "Would you like to read another article? (y/n)".colorize(:blue)
    continue = gets.chomp
    until continue == 'y' || continue == 'n'
      puts "Would you like to read another article? (y/n)".colorize(:blue)
      continue = gets.chomp
    end

    if continue == 'y'
      Article.reset_all
      scraper.stage = ""
      call
    elsif continue == 'n'
      puts "Goodbye!".colorize(:blue)
    end
  end

  def set_stage
    until [*0..4].include?(scraper.stage)
      get_stage_input
    end
  end

  def get_stage_input
    puts "What stage of pregnancy is your family in?".colorize(:blue)
    puts "Please select the number from the following options:".colorize(:blue)
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

  def show_article_header(choice)
    article = Article.all[choice]

    puts ""
    puts article.title.colorize(:light_yellow).underline
    puts article.subtitle.colorize(:yellow)
    puts "by #{article.author}"
    puts ""
  end

  def show_article_content(choice, paragraph)
    article = Article.all[choice]

    #puts the next paragraph of the article. If what is next is an h2, it places that THEN the next paragraph
    if ["h1","h2","h3","h4"].include?(article.content[paragraph].name)
      puts article.content[paragraph].text.gsub("â","\'").colorize(:yellow)
      paragraph += 1
      puts article.content[paragraph].text.gsub("â","\'")
    elsif article.content[paragraph].name == "ul"
      #TODO formatting for ul
    else
      puts article.content[paragraph].text.gsub("â","\'")
    end

    #for continuing, this checks if we are at the end of the article, and offers the next paragraph if it is not
    if paragraph+1 < article.content.length
      puts '(enter "c" to continue, or "exit" to exit)'.colorize(:blue)
      user_choice = gets.chomp

      #loop in case the user inputs an invalid choice
      until ['c','exit'].include?(user_choice)
        puts '(enter "c" to continue, or "exit" to exit)'.colorize(:blue)
        user_choice = gets.chomp
      end
      if user_choice == 'c'
        show_article_content(choice, paragraph+1)
      end
    else
      puts "(End of article)"
    end
  end
end
