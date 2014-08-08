module DateHelper
	def self.readable_future_date(date)
		days_away = ((date - Time.zone.now ) / 1.day).to_i
		hrs_away = ((date - Time.zone.now ) / 1.hours).to_i
		case days_away
		when 0
			if hrs_away > date.hour
				"on tomorrow"
			end			

		when 1
  			"on tomorrow"
		when 2
  			"on the day after tomorrow"
		else
  			"in #{days_away} days"
	end

	end
end