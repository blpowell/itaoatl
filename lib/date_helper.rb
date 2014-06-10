module DateHelper
	def self.readable_future_date(date)
		days_away = (date - Date.today).to_i #TODO: Returns 0 for times less than 24 hrs away

		case days_away
		when 1
  			"tomorrow"
		when 2
  			"the day after tomorrow"
		else
  			"in #{days_away} days"
	end

	end
end