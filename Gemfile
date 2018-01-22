#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

source 'https://rubygems.org'

gem 'rails', '4.2.3'

# Application server
gem 'puma'
# Authentication and authorization
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Slim is a template language
gem 'slim'
gem 'slim-rails'
# Bower support for Rails projects
gem 'bower-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Cloud storage
gem 'carrierwave'
gem 'fog'
# Decorator for Rails models
gem 'draper'
# A Ruby library for working with Research Object Bundle files
gem 'ro-bundle'
# A Ruby library to aid the interaction with Taverna 2 workflows
gem 'workflow_parser', github: 'myExperiment/workflow_parser'
gem 'taverna-t2flow', github: 'myExperiment/workflow_parser-t2flow'

# A gem to query the prov.ttl
gem 'sparql'

# A simple interface to working with ZIP archives
gem 'archive-zip'
# Paginator
gem 'kaminari'
# Loads environment variables from `.env`
gem 'dotenv-rails'

# Force newer nokogiri for security fixes
gem 'nokogiri', '~> 1.8.1'

group :development, :test do
  # More useful error page
  gem 'better_errors'
  gem 'binding_of_caller'
  # Turns off the Rails asset pipeline log
  gem 'quiet_assets'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # rspec-rails is a testing framework for Rails
  gem 'rspec-rails'
  # A library for setting up Ruby objects as test data
  gem 'factory_girl_rails'
  # A minimalist's tiny and ultra-fast database cleaner
  gem 'database_rewinder'
  # Acceptance test framework for web applications
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  # Headless is the Ruby interface for Xvfb. It allows you to create a headless display straight from Ruby code
  gem 'headless'
  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'
end

group :test do
  # Collects test coverage data from your Ruby test suite and sends it to Code Climate's hosted, automated code review service
  gem 'codeclimate-test-reporter'
end

group :production do
  # Heroku gem, what makes running your Rails app easier
  gem 'rails_12factor'
end
