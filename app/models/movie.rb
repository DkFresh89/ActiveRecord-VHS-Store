class Movie < ActiveRecord::Base

    has_many :movie_genres
    has_many :genres, through: :movie_genres
    has_many :vhs 
    has_many :rentals, through: :vhs 


    def self.longest
        # binding.pry 
        self.all.sort_by{|movie| movie.length}.reverse

    end 

    def self.available_now
        # binding.pry 
        Rental.all.select {|r| r.current == false}
    end 


end