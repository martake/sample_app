xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "My Home Feed"
    xml.description "Lots of feeds"
    xml.link rss_url(:rss)
    
    for feed in @feed_items
      xml.item do
        xml.title "#{feed.user.name} #{feed.created_at.to_s(:rfc822)}"
        xml.description feed.content
        xml.pubDate feed.created_at.to_s(:rfc822)
        xml.link rss_url(feed, :rss)
        xml.guid rss_url(feed, :rss)
      end
    end
  end
end
