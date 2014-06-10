require 'open-uri'
require 'nokogiri'

module Scraper

	def self.get_next_event
 		get_all_events[0] #Events are sorted by date, so just get the 1st one
 	end

 	def self.get_all_events
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
				resp.push(Event.new(name: event_name, date:event_date, url: event_url))
			end

		end
		resp.sort! { |a,b| a.date <=> b.date }
	
	end
end