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

class DataBundle < ActiveRecord::Base
  paginates_per 10
  mount_uploader :file, ::DataBundleUploader

  belongs_to :user

  validates :name, :user_id, :file, presence: true

  after_create :extract_file

  EXTRACTED_DIRECTORY = 'extracted_source'
  EXTRACTED_WORKFLOW_PATH = 'workflow_source'

  def file_path
    "#{file.root}/#{file.store_dir}/#{EXTRACTED_DIRECTORY}/"
  end

  def extract_file
    Archive::Zip.extract(file.path, "#{file_path}")
    Archive::Zip.extract("#{file_path}workflow.wfbundle", "#{file_path}#{DataBundle::EXTRACTED_WORKFLOW_PATH}")
  end
end
