class Scraper
  attr_accessor :stage

  def initialize
    @stage = ""
  end

  def get_articles
    html = Nokogiri::HTML(open("https://www.thebump.com"))
    all_sections = html.css(".homepage-panel---articles")
    all_sections[@stage].css(".homepage-panel--item").each do |article|
      article_url = article.attribute("href").value
      scrape_article(article_url)
    end
  end

  def scrape_article(url)
    html = Nokogiri::HTML(open(url))
    article_hash = {
      title: html.css("div#pre-content-container h1").text.gsub("\n",""),
      subtitle: html.css("div#pre-content-container .dek").text.gsub("\n",""),
      author: html.css("div#pre-content-container .contributor-name").text.gsub("\n",""),
      content: html.css("div.body-content p")
    }

    Article.new_from_hash(article_hash)
  end
end
