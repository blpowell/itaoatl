require 'open-uri'
require 'nokogiri'

module Scraper

	def self.get_next_event
 		get_all_events[0] #Events are sorted by date, so just get the 1st one
 	end


	def self.get_all_events
		resp = get_next_liberty_event + get_next_swansea_fixture + get_next_osprey_fixture

		resp.sort! { |a,b| a.date <=> b.date }
	end


 	def self.get_next_liberty_event
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
				#Once we have one event - quit
			end
		end
		resp
	end

	def self.get_next_osprey_fixture
		year = 2015
		base_url = "http://www.ospreysrugby.com/FixturesResults/PrinterFriendlyVersion/#{year}?team=Ospreys"

		doc = Nokogiri::HTML(open(base_url))
		resp = Array.new

		doc.xpath('//table/tbody/tr').map do |row|
			if row.xpath('td').count == 7 #Ignore month rows which span the table
				match_date = row.xpath('td[1]').text.strip

				if row.xpath('td[5]').text.strip == 'Liberty Stadium, Swansea' #Only home events
					match_name = "Ospreys v #{row.xpath('td[4]').text.strip}"
					match_time = row.xpath('td[2]').text.strip
					resp.push(Event.new(name: match_name, date:build_date(match_date,match_time), url: base_url, source: 'ospreysrugby.com'))
					break #Once we have one event - stop
				end
			end
		end
		resp
	end

	def self.get_next_swansea_fixture
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
				break #Once we have one event - quit
			end
		end
		resp
	end

	def self.build_date(date_without_year,kickoff_time)
 		date = DateTime.parse(date_without_year + ' ' + kickoff_time)
 		if date.month < Date.today.month
 			date = date + 365
 		end
		return date
	end
end