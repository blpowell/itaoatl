require 'open-uri'
require 'nokogiri'

module Scraper

	def self.get_next_event
 		get_all_events[0] #Events are sorted by date, so just get the 1st one
 	end


	def self.get_all_events
#		resp = Array.new 
		get_liberty_events + get_bbc_events

		#resp.sort! { |a,b| a.date <=> b.date }
	end


 	def self.get_liberty_events
		base_url = 'http://www.liberty-stadium.com/'

		doc = Nokogiri::HTML(open(base_url + "events.php"))
		resp = Array.new 
		events = doc.css("div.cms_events_list_row").map do |event|

			event_url = base_url + event.at_css("a")['href']

			#Events page doesnt have enough info - so we need to go to each URL
			event_page = Nokogiri::HTML(open(event_url))
			event_name = event_page.at_css("h1").text.strip
			event_date = DateTime.parse(event_page.at_css("div.cms_events_view_date").text.strip)

			if  event_date.future? #Ignore events in the past
				resp.push(Event.new(name: event_name, date:event_date, url: event_url, source:"liberty-stadium"))
			end
		end
		resp
	end


	def self.get_bbc_events
		base_url = 'http://www.bbc.co.uk/sport/football/teams/swansea-city/fixtures'
		doc = Nokogiri::HTML(open(base_url))

		resp = Array.new

		doc.xpath('//tr[starts-with(@id, "match-row")]').map do |row|
			match_name = row.at_css("td.match-details").text.strip
			if match_name.starts_with?('Swansea')
				match_date = DateTime.parse(row.at_css("td.match-date").text + row.at_css("td.kickoff").text)
				
				(match_date.month < Date.today.month)? (match_date = match_date + 365) : match_date 

				match_url = base_url + '#' + row['id']
				resp.push(Event.new(name: match_name, date:match_date, url: match_url, source:'bbc'))
			end
			
		end
		resp
	end 
 
end