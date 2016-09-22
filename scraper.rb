require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

url = 'http://www.comics.org/on_sale_weekly/'
page = Nokogiri::HTML(open(url))
this_week = {}

rows = page.css('tr')

rows[1..-2].each do |r|
  title = rows.css('td a').map {|a|
    a.text if a['href'].match('/series/')
  }.compact.uniq

  issue_num = rows.css('td a').map {|a|
    a.text if a['href'].match('/issue/')
  }.compact.uniq

  this_week = JSON.dump(title: title, issue_num: issue_num)
end
