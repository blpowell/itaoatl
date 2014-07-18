class PagesController < ApplicationController
	include Scraper, DateHelper

  def index
  	@event = Scraper.get_next_event

	no_messages = ["No","Nah","Negative","Nope","Doesn't look like it","Not Today","Nay"]
	yes_messages = ["Yes","Yeah","Looks like it","There Is","Sure Is"]
  	
  	@n = no_messages[rand(no_messages.length)]
  	@y = yes_messages[rand(yes_messages.length)]
  end

  def why

  end




end
