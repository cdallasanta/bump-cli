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
      @stage = "getting-pregnant"
    when 2
      @stage = "first-trimester"
    when 3
      @stage = "second-trimester"
    when 4
      @stage = "third-trimester"
    when 5
      @stage = "parenting"
    else
      @stage = ""
    end
  end

  def get_articles
    html = Nokogiri::HTML(open("https://www.thebump.com"))
    all_sections = html.css(".homepage-panel---articles")
    all_sections[@stage].css(".homepage-panel--item").each do |article|
      article_url = article.attribute("href").value
      scrape_article(article_url)
    end
    puts ""
  end

  def scrape_article(url)
    html = Nokogiri::HTML(open(url))
    article_hash = {
      title: html.css("div#pre-content-container h1").text,
      subtitle: html.css("div#pre-content-container .dek").text,
      author: html.css("div#pre-content-container .contributor-name"),
      content: html.css("div.body-content").text
    }

    Article.new_from_hash(article_hash)
  end
end
