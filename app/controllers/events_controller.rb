class EventsController < ApplicationController
  include Scraper
	
  def index
	render json: Scraper.get_all_events
  end

  def next
 	render json: Scraper.get_next_event
  end

  def swans_fixtures
 	render json: Scraper.get_swansea_city_fixtures
  end

end