class Client < ActiveRecord::Base

    
    has_many :rentals
    has_many :vhs, through: :rentals 

    def self.first_rental (client_hash, movie_title)
        new_client = Client.create(client_hash)
        movie = Movie.find_by(title: movie_title)
        vhs_copies = Vhs.where(movie_id: movie.id)
        available_copy = vhs_copies.select {|copy| copy.is_available_to_rent? || !copy.ever_rented? }.first
        Rental.create(vhs_id: available_copy.id , client_id: new_client.id, current: true)
        # binding.pry 
    end

    def rentals_past_due
        Rental.all.select{|r| r.past_due?}
    end 

    def self.non_grata
        binding.pry 
        self.all.select do |client|
            client.rentals.any? { |rental| rental.returned_late? || rental.past_due? }
        end

    end 

    #returns a list of top 5 most active clients (i.e. those who had the most non-current / returned rentals)

    def self.most_active
      
        self.all.sort_by{|client| client.num_rentals}.reverse[0..4]

    end 
    #helper method
    def num_rentals

        self.rentals.size

    end 

    # returns an instance who has spent most money at the store; one rental is $5,35 upfront (bonus: additional $12 charge for every late return — do not count those that have not yet been returned)


    def rental_fees

        (self.rentals.count * 5.35).round(2)

    end 

    def late_fees

        self.rentals.count{|rental| rental.returned_late?} * 12

    end 

    def total_paid

        self.rental_fees + self.late_fees

    end 


    def self.paid_most

    self.all.max_by{|client| client.total_paid}

    end 

    # returns an Integer of all movies watched by the all clients combined (assume that a rented movie is a watched movie)

    def self.total_watch_time

        Rental.all.sum{|rental| rental.vhs.movie.length}

    end


    def return_one(vhs)

       rental = Rental.find_by(vhs_id: vhs.id, client_id: self.id, current: true)
       rental.update(current: false)

    end 

    def all_active_rentals

        # self.rentals.select{|rental| rental.current == true}
        #AR Method
        Rental.where(client_id: self.id, current: true)

    end 

    def return_all 
        #you can call an AR method on an array
        # self.all_active_rentals.update(current: false)


        self.rentals.update_all(current: false)
        
    end 

    def last_return

        self.return_all
        self.destroy

    end 
   

end