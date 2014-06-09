require 'open-uri'
require 'nokogiri'

module Scraper

	def self.get_next_event
 		get_all_events[0]
 	end

 	def self.get_all_events
		base_url = 'http://www.liberty-stadium.com/'

		doc = Nokogiri::HTML(open(base_url + "events.php"))
		resp = Array.new 
		events = doc.css("div.cms_events_list_row").map do |event|

			event_url = base_url + event.at_css("a")['href']

			#Events page doesnt have too much info - so we need to go to each URL
			event_page = Nokogiri::HTML(open(event_url))

			event_name = event_page.at_css("h1").text.strip
			event_date = DateTime.parse(event_page.at_css("div.cms_events_view_date").text.strip)
			resp.push(Event.new(name: event_name, date:event_date, url: event_url))
		end

	#Only for testing!
	#resp.push(Event.new(name:"Event on Now",date: DateTime.now, url: "google.com")) #Event today
	#resp.push(Event.new(name:"Christmas",date: DateTime.parse("25-Dec-2014"), url: "google.com")) #Future event

	resp.sort! { |a,b| a.date <=> b.date }
	
	end
end