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

RSpec.describe User, type: :model do
  it 'default factory - valid' do
    expect(build(:user)).to be_valid
  end

  context 'invalid' do
    it 'without email' do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it 'duplicate email' do
      user = create :user
      expect(build(:user, email: user.email)).not_to be_valid
    end

    it 'email' do
      expect(build(:user, email: '1111')).not_to be_valid
    end
  end
end
