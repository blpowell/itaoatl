class EventsController < ApplicationController
  include Scraper
	
  def index
	render json: Scraper.get_all_events
  end

  def next
 	render json: Scraper.get_next_event
  end

  def bbc
 	render json: Scraper.get_bbc_events
  end

end