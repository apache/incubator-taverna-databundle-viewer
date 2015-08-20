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

RSpec.describe 'DataBundles', type: :feature do
  context 'signed in user' do
    let(:user) { create :user }
    let!(:data_bundle) { create :data_bundle, user: user }
    let!(:data_bundle_foreign) { create :data_bundle }

    before do
      sign_in user
      visit data_bundles_path
    end

    context 'create' do
      it 'with file and name - ok' do
        name = Faker::Lorem.sentence
        expect {
          fill_in 'data_bundle_name', with: name
          attach_file 'data_bundle_file', "#{Rails.root}/spec/fixtures/hello_anyone.zip"
          click_button 'save_data_bundle'
        }.to change(DataBundle, :count).by(1)
        visit data_bundles_path
        expect(page).to have_content name
      end

      it 'without file - error' do
        expect {
          click_button 'save_data_bundle'
        }.not_to change(DataBundle, :count)
        expect(current_path).to eq data_bundles_path
        expect(page).to have_css 'div#error_explanation'
      end
    end

    it 'can see the databundles' do
      expect(page).to have_content data_bundle.name
    end

    it 'can not see foreign databundles' do
      expect(page).not_to have_content data_bundle_foreign.name
    end

    it 'show databundle' do
      click_link "to_show_#{data_bundle.id}"
      expect(page).to have_content data_bundle.name
    end

    context 'edit' do
      before do
        click_link "to_edit_#{data_bundle.id}"
      end

      it 'change name - ok' do
        new_name = Faker::Lorem.sentence
        expect {
          fill_in 'data_bundle_name', with: new_name
          click_button 'save_data_bundle'
        }.not_to change(DataBundle, :count)
        expect(page).to have_content new_name
      end

      it 'with empty name - error' do
        expect {
          fill_in 'data_bundle_name', with: ''
          click_button 'save_data_bundle'
        }.not_to change(DataBundle, :count)
        expect(page).to have_css 'div#error_explanation'
        expect(current_path).to eq data_bundle_path(data_bundle.id)
      end
    end

    it 'delete databundle', js: true do
      expect {
        page.accept_confirm do
          click_link "to_delete_#{data_bundle.id}"
        end
      }.to change(DataBundle, :count).by(-1)
    end
  end

  context 'anonymous user' do
    it 'can not upload new databundles' do
      visit data_bundles_path
      expect(page).not_to have_css 'form#new_data_bundle'
    end

    it 'not see the databundles' do
      bundle = create :data_bundle
      visit data_bundles_path
      expect(page).not_to have_content bundle
    end
  end
end
