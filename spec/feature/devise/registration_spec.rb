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

require 'spec_helper'

RSpec.describe 'Registration' do
  subject { page }

  before do
    visit new_user_registration_path
  end

  it 'correct' do
    password = Faker::Internet.password
    firstname = Faker::Name.first_name
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    fill_in 'user_firstname', with: firstname
    expect {
      click_button 'sign_up'
      expect(current_path).to eq root_path
      expect(page).to have_content firstname
    }.to change(User, :count).by(1)
  end

  it 'empty password confirmation' do
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: Faker::Internet.password
    expect {
      click_button 'sign_up'
    }.not_to change(User, :count)
  end

  it 'incorrect password confirmation' do
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: Faker::Internet.password
    fill_in 'user_password_confirmation', with: Faker::Internet.password
    expect {
      click_button 'sign_up'
    }.not_to change(User, :count)
  end

  it 'empty password' do
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password_confirmation', with: Faker::Internet.password
    expect {
      click_button 'sign_up'
    }.not_to change(User, :count)
  end

  it 'empty email' do
    fill_in 'user_password', with: Faker::Internet.password
    fill_in 'user_password_confirmation', with: Faker::Internet.password
    expect {
      click_button 'sign_up'
    }.not_to change(User, :count)
  end
end
