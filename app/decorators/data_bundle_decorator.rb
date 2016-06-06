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

  FILE_TYPES = {:inputs => '/inputs/' , :intermediates => '/intermediates/', :outputs => 'outputs'}

  FILE_TYPES.each do |type_key, type_name|
    define_method :"#{type_key}" do
      files = manifest['aggregates'].select { |file| !file['folder'].nil? && file['folder'].start_with?(type_name) }
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

  def to_dataHashObject
    paths = []

    workflow.datalinks.each do |link|
      paths << write_link(link, workflow) 
    end

    stream = {}
    nodes = []
    links = []

    paths.each do |path|
      #get source node
      source = {:name => path[:source] }
      target = {:name => path[:target] }

      indexSource = -1
      indexTarget = -1

      nodes.each_with_index do |node, index|
        if node[:name].to_s == source[:name]
          indexSource = index
        elsif node[:name].to_s == target[:name]
          indexTarget = index
        end
      end

      if indexSource == -1
        indexSource = nodes.count
        nodes << source
      end

      if indexTarget == -1
        indexTarget = nodes.count
        nodes << target
      end

      links << {:source => indexSource, :target => indexTarget, :value => 50}

    end

    stream = {:nodes => nodes, :links => links }
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



  # find the provenance file
  # how to extract info from file see http://ruby-rdf.github.io/ , section Querying RDF data using basic graph patterns
  def provenanceMain
    
    if @provenance.nil?

      provenanceObj = Provenance.new("#{object.file_path}workflowrun.prov.ttl")
      @provenance =  provenanceObj.to_dataHashObject("#{object.file_path}")

      # stream = {}
      # nodes = []
      # links = []

      # iteration = 12

      # iteration.times do |i|
      #   nodes << {:name => i, :label => i, :type => "Artifact"}
      # end 

      # (iteration - 1).times do |i|
      #   links << {:source => i, :target => i+1, :value => 50}
      # end

      # stream = {:nodes => nodes, :links => links }

      # @provenance = stream

    end # if provenance

    #return 
    @provenance 
  end # def provenance

end
