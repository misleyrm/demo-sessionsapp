source "https://rubygems.org"
ruby "2.3.0"

gem 'paperclip', '~> 5.2', '>= 5.2.1'

gem 'carrierwave'
gem 'mini_magick'
gem 'rails-assets-jcrop', source: 'https://rails-assets.org'
gem 'fog'
gem 'fog-aws'
# Amazon web services
gem 'aws-sdk', '~> 2'

gem 'rails-erd'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta3', '< 5.1'
gem 'puma'
gem 'redis', '~> 3.2'

gem 'materialize-sass'

gem 'rails_serve_static_assets'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# gem 'hirb'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rails-ujs'
# gem 'rails-jquery-autocomplete'

gem 'acts_as_list'  #sorting and reordering a number of objects in a list

gem 'bootstrap-validator-rails'
# gem 'client_side_validations', github: 'DavyJonesLocker/client_side_validations'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'activerecord-reset-pk-sequence'

# gem 'jquery-fileupload-rails'

# gem 'acts-as-taggable-on'

gem 'simple_form'

gem 'rails_autolink'

gem 'pundit'

gem 'figaro'

gem 'gon'

gem 'scrollbar-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Autocomplete
gem 'jquery-atwho-rails'

# gem 'bower-rails'

# background job
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
# gem 'angularjs-rails'


# Use ActiveModel has_secure_password

# Use Unicorn as the app server
# gem 'unicorn'

# test gem
gem 'rails-perftest'
gem 'ruby-prof'

group :production do
  gem 'pg','~> 0.18'
  gem 'bcrypt'
  gem 'whenever', require: false

end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  #testing
  gem 'capybara'
  gem 'rspec-rails'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem "nifty-generators"
  gem 'hirb'
  gem "capistrano"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'mocha', group: :test

gem 'rails_12factor', group: :production
