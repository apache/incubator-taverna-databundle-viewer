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

RSpec.describe 'Session' do
  subject { page }

  let(:user) { create :user }

  context 'sign_in', type: :feature do
    before do
      visit new_user_session_path
    end

    it 'correct email and password' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'sign_in'
      expect(current_path).to eq(root_path)
      expect(page).to have_content user.firstname
    end

    it 'incorrect email' do
      fill_in 'user_password', with: user.password
      click_button 'sign_in'
      expect(page).to have_content 'Invalid email or password.'
      expect(current_path).to eq(new_user_session_path)
    end

    it 'incorrect password' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '111'
      click_button 'sign_in'
      expect(page).to have_content 'Invalid email or password.'
      expect(current_path).to eq(new_user_session_path)
    end
  end

  it 'sign out', type: :feature, js: true do
    sign_in user
    click_link 'open_user_dropdown'
    click_link 'sign_out'
    expect(current_path).to eq(root_path)
    expect(page).not_to have_content user.firstname
  end

  context 'omniauth' do
    it 'facebook' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({provider: 'facebook', uid: '123545', info: {email: Faker::Internet.email}})
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      visit new_user_session_path
      expect {
        click_link 'omniauth_facebook'
      }.to change(User, :count).by(1)
    end

    it 'google' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({provider: 'google_oauth2', uid: '123545', info: {email: Faker::Internet.email}})
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      visit new_user_session_path
      expect {
        click_link 'omniauth_google_oauth2'
      }.to change(User, :count).by(1)
    end
  end
end
