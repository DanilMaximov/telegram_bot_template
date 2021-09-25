## Telegram Bot Template


## Features

## Usage

## Directory layout

```sh
└── template
    ├── app                                       # application files
    │   └── bot                                   # bot related stuff
    │       └── dispatcher                        # folder with responder logic (request -> response cycle)
    │           └── user                          # user responder files
    │               └── base_reponder.rb          # base responder logic -> start menu, main buttons etc.
    │               └── ...                       # other responders with business logic
    │           └── admin                         # admin responder files
    │               └── ...                       # all responders realted to admin user role
    │           └── super_base.rb                 # entry point to request/response cycle
    │           └── base.rb                       # abstract class for responders
    │           └── responding.rb                 # module with responding methods for Base class
    │           └── validating.rb                 # module with validating method for Base class
    │       └── application_bot.rb                # abastract class for bots
    │       └── telegram_bot.rb                   # telegram client class with described interact methods for bot.api
    │   └── helpers                               # helpers
    │   └── models                                # models
    │   └── services                              # services folder containt service classes/objects
    │       └── responders                        # services related to responder module
    │       └── application_service.rb            # abstract service class
    │       └── fetch_uri_service.rb              # service for fetching data.
    │       └── ...                         
    ├── config                                    # folder with configs
    │   └── initializers                          # folder with initializers
    │   └── locales                               # folder with i18n locales
    │   └── application.rb                        # class for application configuration
    │   └── database_development.yml              # sample dev database configuration
    ├── db                                        # database related stuff
    │   └── migrations                            # migrations
    │       └── 001_create_telegram_user.rb       # migration for creating table 'telegram_users'
    ├── config.rb                                 # main executable file
    ├── spec                                      # tests folder
    ├── .rspec                                    # spec config file
    ├── .rubocop.yml                              # rubocop config file
    ├── .ruby-version                             # ruby version file
    ├── Gemfile                                   # Gemfile
    ├── Gemfile.lock                              # Gemfile.lock
    └── README.md                                 # Readme file
```

