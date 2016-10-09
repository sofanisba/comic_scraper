require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'json'
require 'pry'

agent = Mechanize.new
url = 'http://www.comics.org/on_sale_weekly/'
page = agent.get(url)
# puts page.uri
blk = lambda {|k,v| k[v] = Hash.new(&blk)}
this_week = Hash.new(&blk)

rows = page.css('tr')
next_link = page.link_with(text: 'Next >')
page= next_link.click

comics = rows.collect do |row|
  comic = Hash.new
  publisher = row.css('td a').map {|a| a.text if a['href'].match('/publisher')}.compact.uniq.join(" , ")
  title = row.css('td a').map {|a| a.text if a['href'].match('/series')}.compact.uniq.join(" , ")
  issue = row.css('td a').map {|a| a.text if a['href'].match('/issue')}.compact.uniq.join(" , ")
  [
    [:publisher, publisher],
    [:title, title],
    [:issue, issue]
  ].each do |k,v|
    comic[k] = v
  end
  comic
end

# puts page.uri
# binding.pry
puts comics
