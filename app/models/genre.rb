class Genre < ActiveRecord::Base

    has_many :movie_genres
    has_many :movies, through: :movie_genres


    def self.most_popular 

        Genre.all.sort_by{|genre| genre.movies.count}.reverse[0..4]

    end 

    def average_movie_length

        sum = self.movies.sum{|movies| movies.length}
        return 0 if sum == 0
        #sets to a float and rounds to 2 decimal points
        average = sum/self.movies.count.to_f.round(2)

    end 

    def self.longest_movies

        self.all.max_by{|genre| genre.average_movie_length}

    end 


end