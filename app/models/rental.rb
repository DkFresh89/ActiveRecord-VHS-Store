class Rental < ActiveRecord::Base

    belongs_to :clients
    belongs_to :vhs

end