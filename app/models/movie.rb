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
        Vhs.available_now.map(&:movie).uniq
    end

    #number of rentals each movie's copy has
    def number_of_rentals
        #calling vhs on the instance of movie
        #returns number of copies in store 
        self.vhs.sum{|vhs| vhs.rentals.count}
    end

    #instance method calling on each instance of movie 
    def number_of_clients
        self.vhs.sum{|vhs| vhs.clients.count}
    end

    #Using instance method number_of_clients on an instance of a movie.
    #Max_by enumerable to iterate over all movie instances and apply the block on each instance
    #Returns the most clients of that movie instance
    def self.most_clients
        self.all.max_by{|movie| movie.number_of_clients}
    end


end