class Article
  attr_accessor :author, :title, :subtitle, :content
  @@all = []

  def initialize
    @@all << self
  end

  def clean_up_content
    binding.pry
    @content = @content.reject {|para| para.text==""}
    @content.each do |para|
      para.text.gsub("â","\'")
      para.text.gsub("'¢","-")
    end
  end

  def self.new_from_hash(hash)
    article = Article.new
    hash.each do |k,v|
      article.send("#{k}=", v)
    end

    article.clean_up_content
  end

  def self.all
    @@all
  end

  def self.reset_all
    @@all = []
  end
end
