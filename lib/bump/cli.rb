class Cli
  attr_accessor :scraper

  def initialize
    @scraper = Scraper.new
    Article.reset_all
  end

  def call
    puts "Welcome to The Bump CLI!".colorize(:blue)
    scraper.get_articles(set_stage)

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
    stage = ""
    until [*0..4].include?(stage)
      puts "What stage of pregnancy is your family in?".colorize(:blue)
      puts "Please select the number from the following options:".colorize(:blue)
      puts "1 - Getting Pregnant"
      puts "2 - First Trimester"
      puts "3 - Second Trimester"
      puts "4 - Third Trimester"
      puts "5 - Parenting"
      stage = gets.chomp.to_i - 1
    end
    stage
  end

  def display_article_titles
    Article.all.each.with_index(1) do |article, i|
      puts "#{i} - #{article.title}"
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

    #puts the next paragraph of the article. If what is next is an h*, it places that THEN the next paragraph
    #if the next paragraph is an ul, then it puts the whole list
    #it also cleans up the text as it puts it out
    if ["h1","h2","h3","h4"].include?(article.content[paragraph].name)
      puts article.content[paragraph].text.gsub(/â.*¢/,"-").gsub("â","\'").colorize(:yellow)
      paragraph += 1
      puts article.content[paragraph].text.gsub(/â.*¢/,"-").gsub("â","\'")
    elsif article.content[paragraph].name == "ul"
      article.content[paragraph].children.each do |li|
        if li.name == "li"
          puts "- " + li.text.gsub(/â.*¢/,"-").gsub("â","\'")
        end
      end
    else
      puts article.content[paragraph].text.gsub(/â.*¢/,"-").gsub("â","\'")
    end

    #for continuing, this checks if we are at the end of the article, and offers the next paragraph if it is not
    if paragraph + 1 < article.content.length
      response = ask_to_continue

      if response == ''
        show_article_content(choice, paragraph+1)
      end
    else
      puts "(End of article)"
    end
  end

  def ask_to_continue
    user_choice = nil
    until ['','exit'].include?(user_choice)
      puts '(press enter to continue, or type "exit" to exit)'.colorize(:blue)
      user_choice = gets.chomp
    end
    user_choice
  end
end
