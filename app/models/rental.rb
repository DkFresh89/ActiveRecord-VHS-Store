class Rental < ActiveRecord::Base

    belongs_to :client
    belongs_to :vhs
    # Rental#due_date - returns a date one week from when the record was created
    def due_date 
        #binding.pry 
        self.created_at + 1.week 
    end 

    #Helper Method for past_due_date
    def past_due?
        # binding.pry 
        self.created_at < self.updated_at
    end
    #2nd Helper Method for past_due_date
    def returned_late?
        self.current == false && self.due_date < self.updated_at
    end

    
     
        # Rental.past_due_date - returns a list of all the rentals past due date, currently rented or rented in the past
        def self.past_due_date
        self.all.select do |rental| 
            rental.past_due? || rental.returned_late?
        end
    end

end