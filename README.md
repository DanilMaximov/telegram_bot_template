## Trade Observer Bot
This is a platform for observing any types of trade markets (currency, cryptocurrency, stocks) based on chat bots.

## Features 

Done: 
* Base easy scalable application architecture
  * Several user roles (Admin, Moderator, User)
  * User authentication system
  * Isolated and Separated Responder module -> one Responder module for any bot
  * Button style UI
* Easy internationalization using i18n gem 
* Separate classes/services for all the functional
* 

In Progress: 
* Concurrent bot clients initialization and execution
* Database logging
* Separate Custom Trade Aggregator Info API (Sequel + Roda stack)
* Api Fault Tolerance system
* Сontinuous trade info update
* Achieve 95% test coverage

## Directory layout

```sh
└── trade_observer_bot
    ├── app                                       # application files
    │   └── bots                                  # bots related stuff
    │       └── responders                        # folder with responder logic -> one logic for all bots 
    │           └── user                          # user responder files
    │               └── base_reponder.rb          # base responder logic -> start menu, main buttons etc.
    │               └── currency_reponder.rb      # responder logic related to currency trade markets
    │               └── ...                       # other responders with business logic
    │           └── admin                         # admin responder files
    │               └── ...                       # all responders realted to admin user role
    │           └── responder.rb                  # main responber file -> routing to responders && base responder commands (send, edit message, etc.)
    │       └── telegram                          # telegram client related files
    │       └── application_bot.rb                # abastract bots file
    │   └── exchanges                             # exchange/trade markets related stuff
    │        └── currency                         # currency folder contains logic related to receiving any currency data
    │        └── ...                              # some other exchange/trade logic modules
    │   └── helpers                               # helpers
    │   └── models                                # models
    │   └── services                              # services folder containt service classes/objects
    │       └── currency                          # services related to currency module
    │       └── responders                        # services related to responder module
    │       └── application_service.rb            # abstract service class
    │       └── fetch_uri_service.rb              # service for fetching data.
    │       └── ...                         
    ├── config                                    # folder with configs
    │   └── initializers                          # folder with initializers
    │   └── locales                               # folder with i18n locales
    │   └── application.rb                        # class for application configuration
    │   └── config.ru                             # main executable rackup file
    │   └── database_development.yml              # sample dev database configuration
    ├── db                                        # database related stuff
    │   └── migrations                            # migrations
    │       └── 001_create_telegram_user.rb       # migration for creating table 'telegram_users'
    ├── spec                                      # tests folder
    ├── .rspec                                    # spec config file
    ├── .rubocop.yml                              # rubocop config file
    ├── .ruby-version                             # ruby version file
    ├── Gemfile                                   # Gemfile
    ├── Gemfile.lock                              # Gemfile.lock
    └── README.md                                 # Readme file
```

