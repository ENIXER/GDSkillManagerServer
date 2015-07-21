require 'nokogiri'
require 'anemone'
require 'kconv'

opts = {
    depth_limit: 2
}

target = "http://tri.gfdm-skill.net/users"

# AnemoneにクロールさせたいURLと設定を指定した上でクローラーを起動！
Anemone.crawl(target, opts) do |anemone|
  # 指定したページのあらゆる情報(urlやhtmlなど)をゲットします。
  anemone.on_pages_like(/#{target}\/[0-9]+\/(guitar|drum)/) do |page|

    # Nokogiriインスタンスを取得し、エンコードをUTF8に変換
    doc = Nokogiri::HTML.parse(page.body.toutf8)
    # puts page.url
    doc.css("h1").each do |h1|
      puts h1.text.chomp.strip
    end

    # Nokogiriインスタンスからxpathで欲しい要素(ノード)を絞り込む
    doc.xpath("/html/body/div[@class='container']//table[contains(@id, 'sortable')]/tbody//tr").each do |node|

      # 更に絞り込んでstring型に変換
      title = node.xpath("./td[2]/text()").to_s.chomp.strip
      level = node.xpath("./td[3]/text()").to_s.chomp.strip.split(nil)[0]
      chart = node.xpath("./td[3]/text()").to_s.chomp.strip.split(nil)[1]
      skill = node.xpath("./td[4]/text()").to_s.chomp.strip.split(nil)[0]

      # 表示形式に整形
      puts title + ', ' + chart + ', ' + level + ', ' + skill
    end
    puts
  end
end
