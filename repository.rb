# frozen_string_literal: true

require 'singleton'
require 'mongo'
require 'dotenv/load'

module Repository
  # MongoDB client connect
  class MongoRepo
    attr_accessor :client
    def self.instance
      @@instance ||= new
    end

    # tried 1. initialize, 2. new, 3. self.initialize, 4. self.new
    def initialize
      puts "I'm being initialized!"

      @client = Mongo::Client.new([ENV['MONGO_URL']],
                                  database: ENV['MONGO_DB'],
                                  user: ENV['MONGO_USER'],
                                  password: ENV['MONGO_PW'])
    end
  end

  # notice_latest Collection
  class Latest
    include Singleton
    def initialize
      @client = Repository::MongoRepo.instance.client
      @collection = @client[:notice_latest]
    end

    def insert_one(doc)
      @collection.insert_one(doc)
    end

    def find_one
      @collection.find.first
    end

    def delete_all
      @collection.delete_many
    end
  end

  # notice_history Collection
  class History
    include Singleton
    def initialize
      @client = Repository::MongoRepo.instance.client
      @collection = @client[:notice_history]
    end

    def insert_one(doc)
      @collection.insert_one(doc)
    end
  end

  # notice_task Collection
  class Task
    include Singleton
    def initialize
      @client = Repository::MongoRepo.instance.client
      @collection = @client[:notice_task]
    end

    def insert_one(doc)
      @collection.insert_one(doc)
    end

    def insert_many(list)
      @collection.insert_many(list)
    end

    def find_one
      @collection.find.sort({time: 1}).limit(1).first
    end

    def delete_one(id)
      @collection.delete_one({_id: id})
    end

    def delete_all
      @collection.delete_many
    end
  end

  # notice_latest Collection
  class ViewLatest
    include Singleton
    def initialize
      @client = Repository::MongoRepo.instance.client
      @collection = @client[:view_latest]
    end

    def insert_one(doc)
      @collection.insert_one(doc)
    end

    def find_one
      @collection.find.first
    end

    def delete_all
      @collection.delete_many
    end
  end

  # notice_task Collection
  class ViewTask
    include Singleton
    def initialize
      @client = Repository::MongoRepo.instance.client
      @collection = @client[:view_task]
    end

    def insert_many(list)
      @collection.insert_many(list)
    end

    def find_one(weekday)
      @collection.find({weekday: weekday}).first
    end

    def delete_all
      @collection.delete_many
    end
  end
end
