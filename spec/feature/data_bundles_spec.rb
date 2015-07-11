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
  it 'link from index page' do
    visit root_path
    click_link 'open_data_bundles'
    expect(current_path).to eq data_bundles_path
  end

  context 'signed in user' do
    let(:user) { create :user }
    let!(:data_bundle) { create :data_bundle, user: user }
    let!(:data_bundle_foreign) { create :data_bundle }

    before do
      sign_in user
      visit data_bundles_path
    end

    it 'can upload new databundles' do
      name = Faker::Lorem.sentence
      expect {
        fill_in 'data_bundle_name', with: name
        click_button 'save_data_bundle'
      }.to change(DataBundle, :count).by(1)
      expect(page).to have_content name
    end

    it 'can see the databundles' do
      expect(page).to have_content data_bundle.name
    end

    it 'can not see foreign databundles' do
      expect(page).not_to have_content data_bundle_foreign.name
    end

    it 'show databundle' do
      visit data_bundle_path(data_bundle)
      expect(page).to have_content data_bundle.name
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
