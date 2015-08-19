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

describe DataBundleDecorator do
  let(:data_bundle) { create(:data_bundle).decorate }

  it '#inputs' do
    expected_result = Hash.new
    expected_result['name'] = 'Denis'
    expect(data_bundle.inputs).to include expected_result
  end

  it '#intermediates' do
    expected_result = Hash.new
    expected_result['2d812fc1-dfec-42cb-bef9-87b3ce9c9e2d'] = 'Hello, '

    expect(data_bundle.intermediates).to include expected_result
  end

  it '#outputs' do
    expected_result = Hash.new
    expected_result['greeting'] = 'Hello, Denis'

    expect(data_bundle.outputs).to include expected_result
  end
end
