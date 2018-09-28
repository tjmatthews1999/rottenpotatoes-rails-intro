class Movie < ActiveRecord::Base
#define possible ratings
def self.ratings 
    ['G', 'PG', 'PG-13', 'R'] 
    end
end
