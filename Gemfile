# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '5.2.2'

# basic gems
gem 'coffee-rails'
gem 'jbuilder'
gem 'mysql2'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'uglifier'

# faster app boot
gem 'bootsnap', require: false

# frontend
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'haml-rails'
gem 'sass-rails'
gem 'simple_form'

# javascript libraries
gem 'bootstrap3-datetimepicker-rails'
gem 'colorbox-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'momentjs-rails'
gem 'select2-rails'

# react
gem 'mini_racer', platforms: :ruby
gem 'react_on_rails', '9.0.0'
gem 'webpacker'

# authentication & authorization
gem 'devise'
gem 'flag_shih_tzu'
gem 'pundit'

# background processing
gem 'capistrano-sidekiq'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-throttled'
gem 'sidekiq-unique-jobs'

# search & pagination
gem 'kaminari'
gem 'ransack'

# file upload
gem 'aws-sdk-s3', require: false
gem 'combine_pdf'
gem 'paperclip'

# file generation
gem 'barby'
gem 'chunky_png', '1.3.3' # to work with barby
gem 'prawn', '1.0.0.rc1', require: false # joining pdfs
gem 'spreadsheet'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary-edge', '0.12.3.0' # 0.12.4.0 changes elements size in pdf

# api
gem 'graphql'

# consuming api
gem 'ifirma', github: 'e-price/ifirma-api'
gem 'nori' # savon in version 2.4.0 depends on nori v. 2.3.0
gem 'oauth2'
gem 'savon', '2.4.0', require: false # issues with httpi 2.3

# monitoring
gem 'rollbar'

# utilities
gem 'attr_extras'
gem 'awesome_print'
gem 'best_in_place'
gem 'better_errors'
gem 'chartkick'
gem 'draper'
gem 'ean13'
gem 'figaro'
gem 'httparty'
gem 'iconv', require: false
gem 'liquid'
gem 'mechanize'
gem 'php_serialize'
gem 'responders' # due to respond_with and respond_to removal in rails 5.1
gem 'working_hours'

group :development do
  # debugging
  gem 'letter_opener'

  # deploy
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-scm-copy'

  # performance
  gem 'bullet'
  gem 'rack-mini-profiler'

  # continuous testing
  gem 'guard'
  gem 'guard-rspec'
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard'

  # security
  gem 'gemsurance', require: false

  # quality
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'climate_control'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'pry', '0.11.3' # guard pry wrapper incompatibility
  gem 'pry-rails', '0.3.6' # guard pry wrapper incompatibility

  gem 'factory_bot_rails'
  gem 'faker'

  # security
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
end

group :production, :development do
  gem 'whenever', require: false
end

group :production do
  gem 'newrelic_rpm'
end
