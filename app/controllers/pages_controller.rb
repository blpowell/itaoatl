class PagesController < ApplicationController
	include Scraper, DateHelper

  def index
  	@event = Scraper.get_next_event

	no_messages = ["No","Nah","Negative","Nope","Not today","Nay"]
	yes_messages = ["Yes","Yeah","Looks like it","There is!","Sure is"]
  	
  	@n = no_messages[rand(no_messages.length)]
  	@y = yes_messages[rand(yes_messages.length)]
  end

  def why

  end

end
