require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

url = 'http://www.comics.org/on_sale_weekly/'
page = Nokogiri::HTML(open(url))
blk = lambda {|k,v| k[v] = Hash.new(&blk)}
this_week = Hash.new(&blk)

rows = page.css('tr')

comics = rows.collect do |row|
  comic = {}
  publisher = row.css('td a').map {|a| a.text if a['href'].match('/publisher')}.compact.uniq
  title = row.css('td a').map {|a| a.text if a['href'].match('/series')}.compact.uniq
  issue = row.css('td a').map {|a| a.text if a['href'].match('/issue')}.compact.uniq

  [
    [:publisher, publisher],
    [:title, title],
    [:issue, issue]
  ].each do |k,v|
    comic[k] = v
  end
  comic
end
pp comics
