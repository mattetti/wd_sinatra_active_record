# WdSinatraActiveRecord

A Ruby gem to avoid reinventing the wheel every time you want to use
`ActiveRecord` in a [WeaselDiesel](https://github.com/mattetti/Weasel-Diesel) app backed by Sinatra ([wd_sinatra](https://github.com/mattetti/wd-sinatra)).

Use this gem to easily get connected to one or multiple databases and to
enjoy some of the common ActiveRecord Rake tasks available in Rails.


## Installation

Add this line to your application's Gemfile:

    gem 'wd_sinatra_active_record'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wd_sinatra_active_record


Don't forget to set a gem dependency for the DB adapter you need.
For instance:

    mysql2


## Usage

Add an ActiveRecord `database.yml` file in your config folder and then require this
gem in your `app.rb` file and connect to the DB:

    require 'wd_sinatra_active_record'
    WdSinatraActiveRecord::DBConnector.set_db_connection
    WdSinatraActiveRecord::DBConnector.connect_to_db unless ENV['DONT_CONNECT']


The DB settings can be accessed via:

    DBConnector::DB_CONFIG[RACK_ENV]

If you need a secondary DB connection (to another DB for instance),
add a new entry to your `database.yml` config file:

    development:
      adapter: mysql2
      encoding: utf8
      reconnect: true
      database: app_development
      pool: 5
      username: root
      password:
      socket: /tmp/mysql.sock

      secondary:
        adapter: mysql2
        encoding: utf8
        reconnect: true
        database: secondary_development
        pool: 5
        username: root
        password:
        socket: /tmp/mysql.sock

Then in your `app.rb` after requiring this gem:


    class SecondaryConnection < ActiveRecord::Base
      self.abstract_class = true
    end
    secondary_config = DBConnector::DB_CONFIG[RACK_ENV]['secondary']
    SecondaryConnection.establish_connection(secondary_config) unless ENV['DONT_CONNECT']

Then whichever `ActiveRecord` that needs to connect to the secondary DB
can inherit from `SecondaryConnection` instead of `ActiveRecord::Base`.

## Rake tasks

A Rake task file is also provided so you can load ActiveRecord specific
tasks. To do that, create a new rake file in your lib/tasks folder, load
`WDSinatra` and the rake task file:

```
$ echo "require 'wd_sinatra_active_record'
load WdSinatraActiveRecord.task_path" > lib/tasks/db.rake
```

The tasks are very basic and mainly copied from Rails, feel free to send
patches and improvements.

(Note: WDSinatra version 1.0.4 or newer required)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
