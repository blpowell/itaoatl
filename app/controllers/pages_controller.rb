class PagesController < ApplicationController
	include Scraper, DateHelper



  def index
  	@event = Scraper.get_next_event

	no_messages = ["No","Na","Negative","Nope","Doesn't look like it","Not Today"]
	yes_messages = ["Yes","Yeah","Looks like it","There Is","Sure Is"]
  	
  	@n = no_messages[rand(no_messages.length)]
  	@y = yes_messages[rand(yes_messages.length)]
  end

  def why

  end




end
