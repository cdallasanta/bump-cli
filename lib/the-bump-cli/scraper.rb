class TheBumpCli::Scraper
  def get_articles(stage)
    puts "SCRAPING #{stage} ******************************************"

    html = Nokogiri::HTML(open("https://www.thebump.com"))
    all_sections = html.css(".homepage-panel---articles")
    all_sections[stage].css(".homepage-panel--item").collect do |article|
      article_url = article.attribute("href").value
      scrape_article(article_url, stage)
    end
  end

  def scrape_article(article_url, stage)
    puts "SCRAPING #{article_url} ******************************************"
    html = Nokogiri::HTML(open(article_url))
    article_hash = {
      title: html.css("div#pre-content-container h1").text.strip,
      subtitle: html.css("div#pre-content-container .dek").text.strip,
      author: html.css("div#pre-content-container .contributor-name").text.strip,
      content: html.css("div.body-content p, div.body-content h2, div.body-content ul"),
      stage: stage
    }

    TheBumpCli::Article.new_from_hash(article_hash)
  end
end
