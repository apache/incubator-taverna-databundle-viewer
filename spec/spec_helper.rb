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

require 'rubygems'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/webkit/matchers'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

Capybara.javascript_driver = :webkit

Capybara.save_and_open_page_path = '/tmp/capybara-screenshot'
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screen_#{example.full_description.gsub(' ', '-').gsub(/^.*\/spec\//, '')}"
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.fail_fast = false
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.include AbstractController::Translation
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.before :suite do
    DatabaseRewinder.clean_all
  end

  config.after :each do
    DatabaseRewinder.clean
  end
end
