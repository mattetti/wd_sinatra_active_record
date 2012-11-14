require "wd_sinatra_active_record/version"
require 'active_record'

# Set the default value, feel free to overwrite
ActiveRecord::Base.default_timezone = :utc


module WdSinatraActiveRecord

  # Path to the rake task file so it can be loaded as such:
  #     load WdSinatraActiveRecord.task_path
  # (Note that the app loaded should have been started using something like:
  #   WDSinatra::AppLoader.console(RAKE_APP_ROOT)
  # before loading this rake task.)
  def self.task_path
    File.join(File.expand_path(File.dirname(__FILE__), ".."), "wd_sinatra_active_record", "db.rake")
  end

  ##### DB Connection ########
  module DBConnector
    DB_CONFIG = YAML.load_file(File.join(WDSinatra::AppLoader.root_path, "config", "database.yml"))

    module_function

    def set_db_connection(env=RACK_ENV)
      # Set the AR logger
      if Object.const_defined?(:LOGGER)
        ActiveRecord::Base.logger = LOGGER
      else
        ActiveRecord::Base.logger = Logger.new($stdout)
      end
      # Establish the DB connection
      db_file = File.join(WDSinatra::AppLoader.root_path, "config", "database.yml")
      if File.exist?(db_file)
        hash_settings = YAML.load_file(db_file)
        if hash_settings && hash_settings[env]
          @db_configurations = hash_settings
          @db_configuration = @db_configurations[env]
          # overwrite DB name by using an ENV variable
          if ENV['FORCED_DB_NAME']
            print "Database name overwritten to be #{ENV['FORCED_DB_NAME']}\n"
            @db_configurations[env]['database'] = @db_configuration['database'] = ENV['FORCED_DB_NAME']
          end
          connect_to_db unless ENV['DONT_CONNECT']
        else
          raise "#{db_file} doesn't have an entry for the #{env} environment"
        end
      else
        raise "#{db_file} file missing, can't connect to the DB"
      end
    end

    def db_configuration(env=RACK_ENV)
      old_connect_status = ENV['DONT_CONNECT']
      set_db_connection(env) unless @db_configuration
      ENV['DONT_CONNECT'] = old_connect_status
      @db_configuration
    end

    def db_configurations
      db_configuration unless @db_configurations
      @db_configurations
    end

    def connect_to_db
      if @db_configuration
        connection = ActiveRecord::Base.establish_connection(@db_configuration)
      else
        raise "Can't connect without the config previously set"
      end
    end

  end

end
