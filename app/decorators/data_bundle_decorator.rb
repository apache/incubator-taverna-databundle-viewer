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

  FILE_TYPES = {
      inputs: '/inputs/',
      intermediates: '/intermediates/',
      outputs: '/outputs/'
  }

  FILE_TYPES.each do |type_key, type_name|
    define_method :"#{type_key}" do
      files = manifest['aggregates'].select { |files| files['folder'].start_with?(type_name) }
      result = {}
      files.each do |file|
        key = file['file'].split('/').last.split('.').first
        result[key] = file_content(file['file'])
      end
      return result
    end
  end

  def file_content(file)
    File.new("#{object.file_path}#{file}", 'r').read
  end

  def manifest
    if @manifest.nil?
      file = File.new("#{object.file_path}.ro/manifest.json", 'r')
      @manifest = JSON.parse(file.read)
    end

    @manifest
  end

  def workflow
    if @workflow.nil?
      manifest = Nokogiri::XML(File.open("#{object.file_path}#{DataBundle::EXTRACTED_WORKFLOW_PATH}/META-INF/manifest.xml"))
      t2flow_name = manifest.xpath('//manifest:file-entry[@manifest:media-type="application/vnd.taverna.t2flow+xml"][@manifest:size]').first['manifest:full-path']
      file = File.open("#{object.file_path}#{DataBundle::EXTRACTED_WORKFLOW_PATH}/#{t2flow_name}")
      @workflow = T2Flow::Parser.new.parse(file)
    end

    @workflow
  end

  def to_json
    stream = []
    workflow.datalinks.each { |link| stream << write_link(link, workflow) }
    stream
  end

  def write_link(link, dataflow)
    stream = {}
    if dataflow.sources.select { |s| s.name == link.source } != []
      stream[:source] = link.source
      stream[:file_content] = inputs[link.source] unless inputs[link.source].nil?
    else
      stream[:source] = processor_by_name(dataflow, link.source)
    end
    if dataflow.sinks.select { |s| s.name == link.sink } != []
      stream[:target] = link.sink
    else
      stream[:target] = processor_by_name(dataflow, link.sink)
    end
    stream
  end

  def processor_by_name(dataflow, name)
    dataflow.processors.select { |p| p.name == name.split(':').first }.first.name
  end
end
