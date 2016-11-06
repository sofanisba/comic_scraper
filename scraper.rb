require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'json'
require 'pry'


agent = Mechanize.new

url = 'http://www.comics.org/on_sale_weekly/'
page = agent.get(url)

module Enumerable
  def every_nth(n)
    (n - 1).step(self.size - 1, n).map { |i| self[i] }
  end
end

blk = lambda {|k,v| k[v] = Hash.new(&blk)}
this_week = Hash.new(&blk)

next_link = page.link_with(text: 'Next >')
page= next_link.click
rows = page.css('tr')

comics = rows.collect do |row|
  comic = Hash.new
  publisher = row.css('td a').map {|a| a.text if a['href'].match('/publisher')}.compact.uniq.join(" , ")
  title = row.css('td a').map {|a| a.text if a['href'].match('/series')}.compact.uniq.join(" , ")
  issue = row.css('td a').map {|a| a.text if a['href'].match('/issue')}.compact.uniq.join(" , ")

  pub_date = row.css('td').every_nth(4).map {|td| td.text}
  [
    [:publisher, publisher],
    [:title, title],
    [:issue, issue],
    [:pub_date, pub_date]
  ].each do |k,v|
    comic[k] = v
  end
  comic
end

# binding.pry
puts comics
