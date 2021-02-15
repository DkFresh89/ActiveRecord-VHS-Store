class Movie < ActiveRecord::Base

    has_many :movie_genres
    has_many :genres, through: :movie_genres
    has_many :vhs 
    has_many :rentals, through: :vhs 

    #Easy!!!
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
    # def self.most_clients
    #     self.all.max_by{|movie| movie.number_of_clients}
    # end

    def movie_clients
        self.rentals.map(&:client)
    end 


    def self.most_clients 
        movies_hash = self.all.each_with_object({}) {|movie, movie_hash| movie_hash[movie] = movie.movie_clients.uniq.count}
        movies_hash.max_by{|movie, client_count| client_count} [0]
    end 

    def self.most_rentals

        self.all.sort_by{|movie| movie.number_of_rentals}.reverse[0..2]

    end 

    def self.most_popular_female_director

        female_director_movies = self.all.select{|movie| movie.female_director}

        female_director_movies.max_by{|movie| movie.number_of_rentals}.director 
        #.director retruns the string of the the director attached to the instance

    end 
    #Easy method
    def self.newest_list
        Movie.all.sort_by{|movie| movie.year}.reverse 
    end 

    def recommendation

        emoji = ["🥬", "🔥", "⭐️"].sample
        puts emoji + " title: #{self.title} \n description: #{self.description} \n length: #{self.length} \n director: #{self.director} \n year: #{self.year}"

    end 
    #Easy
    def self.surprise_me

        self.all.sample.recommendation

    end 

    def report_stolen

        Vhs.available_now.select{|vhs| vhs.movie == self}.sample.destroy
        puts "THANK YOU FOR YOUR REPORT. WE WILL LAUNCH AN INVESTIGATION."

    end 



end