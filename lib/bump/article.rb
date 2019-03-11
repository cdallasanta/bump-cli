class Article
  attr_accessor :author, :title, :subtitle, :content
  @@all = []

  def initialize
    @@all << self
  end

  def self.new_from_hash(hash)
    article = Article.new
    hash.each do |attribute, value|
      article.send("#{attribute}=", value)
    end

    article.content = article.content.reject {|para| para.text==""}
  end

  def self.all
    @@all
  end

  def self.reset_all
    @@all = []
  end
end
