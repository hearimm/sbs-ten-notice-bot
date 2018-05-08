require 'singleton'
require 'mongo'
require 'dotenv/load'

module Repository
    class MongoRepo
        
        attr_accessor :client
        def self.instance
            @@instance ||= new
        end

        def initialize # tried 1. initialize, 2. new, 3. self.initialize, 4. self.new
            puts "I'm being initialized!"
            
            @client = Mongo::Client.new([ENV['MONGO_URL']], 
                :database => ENV['MONGO_DB'], 
                :user => ENV['MONGO_USER'], 
                :password => ENV['MONGO_PW'])
        end
    end

    class Latest
        include Singleton
        def initialize
            @client = Repository::MongoRepo.instance.client
            @collection = @client[:notice_latest]
        end

        def insert_one(doc)
            return @collection.insert_one(doc)
        end

        def get_one
            return @collection.find().first() 
        end

        def delete_all
            return @collection.delete_many()
        end
    end
    
    class History
        include Singleton
        def initialize
            @client = Repository::MongoRepo.instance.client
            @collection = @client[:notice_history]
        end

        def insert_one(doc)
            return @collection.insert_one(doc)
        end
    end
end
