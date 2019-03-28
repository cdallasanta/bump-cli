class TheBumpCli::Cli
  attr_accessor :scraper, :article_collection

  def initialize
    @scraper = TheBumpCli::Scraper.new
  end

  def call
    puts "Welcome to The Bump CLI!".colorize(:blue)
    family_stage = self.set_stage - 1

    #if the stage has not been run yet, then scrape for that stage
    if TheBumpCli::Article.find_by_stage(family_stage) == []
      scraper.get_articles(family_stage)
    end
    #set the current articles to the selected stage
    article_collection = TheBumpCli::Article.find_by_stage(family_stage)

    puts "Please select an article:".colorize(:blue)
    self.show_article_titles
    article_choice = self.set_article - 1

    self.show_article_header(article_choice)
    self.show_article_content(article_choice)

    self.ask_for_another_article
  end

  def set_stage
    stage = ""
    until stage.to_i.between?(1,5)
      puts "What stage of pregnancy is your family in?".colorize(:blue)
      puts "Please select the number from the following options:".colorize(:blue)
      puts "1 - Getting Pregnant"
      puts "2 - First Trimester"
      puts "3 - Second Trimester"
      puts "4 - Third Trimester"
      puts "5 - Parenting"
      stage = gets.chomp.to_i
    end
    stage
  end

  def set_article
    article_choice = gets.chomp.to_i
    until article_choice.to_i.between?(1,5)
      puts "Please select an article by its number".colorize(:blue)
      article_choice = gets.chomp.to_i
    end
    article_choice
  end

  def show_article_titles
    article_collection.each.with_index(1) do |article, i|
      puts "#{i} - #{article.title}"
    end
  end

  def show_article_header(choice)
    article = article_collection[choice]

    puts ""
    puts article.title.colorize(:light_yellow).underline
    puts article.subtitle.colorize(:yellow)
    puts "by #{article.author}"
    puts ""
  end

  def show_article_content(choice, paragraph = 0)
    article = article_collection[choice]

    # if it is a header, put the colorized header and the next paragraph (cleanup up with the gsub)
    if ["h1","h2","h3","h4"].include?(article.content[paragraph].name)
      puts article.content[paragraph].text.gsub(/â.*¢/,"-").gsub("â","\'").colorize(:yellow)
      paragraph += 1
      puts article.content[paragraph].text.gsub(/â.*¢/,"-").gsub("â","\'")
    # if it is a list, put all the list items out at once
    elsif article.content[paragraph].name == "ul"
      article.content[paragraph].children.each do |li|
        if li.name == "li"
          puts "- " + li.text.gsub(/â.*¢/,"-").gsub("â","\'")
        end
      end
    # otherwise, put the paragraph
    else
      puts article.content[paragraph].text.gsub(/â.*¢/,"-").gsub("â","\'")
    end

    # for continuing, this checks if we are at the end of the article, and offers the next paragraph if it is not
    if paragraph + 1 < article.content.length
      response = self.ask_to_continue

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

  def ask_for_another_article
    puts "Would you like to read another article? (y/n)".colorize(:blue)
    continue = gets.chomp.downcase

    if continue == 'y'
      self.call
    elsif continue == 'n'
      puts "Goodbye!".colorize(:blue)
    else
      self.ask_for_another_article
    end
  end
end
