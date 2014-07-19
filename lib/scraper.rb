require 'open-uri'
require 'nokogiri'

module Scraper

	def self.get_next_event
 		get_all_events[0] #Events are sorted by date, so just get the 1st one
 	end


	def self.get_all_events
		resp = get_liberty_events + get_swansea_city_fixtures

		resp.sort! { |a,b| a.date <=> b.date }
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

	def self.get_swansea_city_fixtures
		base_url = 'http://int.soccerway.com'
		doc = Nokogiri::HTML(open(base_url + '/teams/wales/swansea-city-afc/738/matches'))
		resp = Array.new

		doc.xpath('//table[@class="matches   "]/tbody/tr').map do |row|
			home_team = row.at_xpath('td[4]').text.strip
			match_date = Time.at(row['data-timestamp'].strip.to_i)
			if home_team == 'Swansea City' && match_date.future?
				away_team = row.at_xpath("td[6]/a")["title"]
				event_name = "#{home_team} v #{away_team}"
				match_url = base_url + row.at_xpath("td[5]/a")["href"]
				resp.push(Event.new(name: event_name, date:match_date, url: match_url, source: 'soccerway.com'))
			end
		end
		resp
	end
 
end