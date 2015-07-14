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

class DataBundleDecorator < Draper::Decorator
  delegate_all

  def manifest
    if @manifest.nil?
      tmp_file = Tempfile.new('bundle', Rails.root.join('tmp'), encoding: 'ascii-8bit')
      tmp_file.write(open(object.file.url).read)
      @bundle_file = ROBundle::File.open(tmp_file.path)
      @manifest = JSON.parse(@bundle_file.find_entry('.ro/manifest.json').get_input_stream.read)
    end

    @manifest
  end

  def inputs
    inputs = manifest['aggregates'].select { |files| files['folder'] == '/inputs/' }.first
    if inputs.nil?
      ''
    else
      @bundle_file.find_entry(inputs['file'].sub(/^\//, '')).get_input_stream.read
    end
  end

  def outputs
    outputs = manifest['aggregates'].select { |files| files['folder'] == '/outputs/' }.first
    if outputs.nil?
      ''
    else
      @bundle_file.find_entry(outputs['file'].sub(/^\//, '')).get_input_stream.read
    end
  end
end
