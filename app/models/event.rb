class Event
   attr_accessor :name, :date, :url, :source, :on_today

    def initialize(options = {})
        self.name = options[:name] 
        self.date = options[:date] 
        self.url =  options[:url] 
        self.source =  options[:source] 
        self.on_today = check_is_on_today
    end

   def check_is_on_today
   		self.date.to_date == Date.today
   end


end