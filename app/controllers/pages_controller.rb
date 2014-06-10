class PagesController < ApplicationController
	include Scraper, DateHelper
  def index
  	@event = Scraper.get_next_event
  end

  def why

  end

end
