module DateHelper
	def self.readable_future_date(date)
		days_away = (date - Date.today).to_i #TODO: Returns 0 some times

		case days_away
		when 1
  			"on tomorrow"
		when 2
  			"on the day after tomorrow"
		else
  			"in #{days_away} days"
	end

	end
end