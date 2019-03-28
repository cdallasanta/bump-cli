class TheBumpCli::Article
  attr_accessor :author, :title, :subtitle, :content, :stage
  @@all = []

  def initialize
    @@all << self
  end

  def self.find_by_stage(stage)
    @@all.select {|article| article.stage == stage}
  end

  def self.new_from_hash(hash)
    article = TheBumpCli::Article.new
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
