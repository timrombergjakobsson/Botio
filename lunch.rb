class Lunch < Bot::Command
  respond_to "food" 
  require 'nokogiri'
  require 'open-uri'
  
  def self.respond
  end
     
  def self.fetch_lunch
    on :message, "food" do | m | 
      doc = Nokogiri.HTML(open("http://www.kvartersmenyn.se/start/city/1/23").read)
      doc.at_css("span a[href='http://ringos.kvartersmenyn.se/']").ancestors("table").at_css("td:nth-child(2)").inner_html.gsub("<br>","\n").gsub(/<div.*<\/div>/,"").strip
    end
      
  end
   
end