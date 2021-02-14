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
        binding.pry 
        Rental.all.select {|r| r.client_id == self}
    end 


   

end