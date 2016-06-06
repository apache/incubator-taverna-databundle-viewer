require 'sparql'  # query the graph
require 'uri'     # used to decode urls

class Provenance

  # TODO: try to read the prefixes from the file
  @@prefixes = "PREFIX dc:  <http://purl.org/dc/elements/1.1/>
        PREFIX prov:  <http://www.w3.org/ns/prov#>
        PREFIX cnt:  <http://www.w3.org/2011/content#>
        PREFIX foaf:  <http://xmlns.com/foaf/0.1/>
        PREFIX dcmitype:  <http://purl.org/dc/dcmitype/>
        PREFIX wfprov:  <http://purl.org/wf4ever/wfprov#>
        PREFIX dcam:  <http://purl.org/dc/dcam/>
        PREFIX xml:  <http://www.w3.org/XML/1998/namespace>
        PREFIX vs:  <http://www.w3.org/2003/06/sw-vocab-status/ns#>
        PREFIX dcterms:  <http://purl.org/dc/terms/>
        PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX wot:  <http://xmlns.com/wot/0.1/>
        PREFIX wfdesc:  <http://purl.org/wf4ever/wfdesc#>
        PREFIX dct:  <http://purl.org/dc/terms/>
        PREFIX tavernaprov:  <http://ns.taverna.org.uk/2012/tavernaprov/>
        PREFIX owl:  <http://www.w3.org/2002/07/owl#>
        PREFIX xsd:  <http://www.w3.org/2001/XMLSchema#>
        PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX skos:  <http://www.w3.org/2004/02/skos/core#>
        PREFIX scufl2:  <http://ns.taverna.org.uk/2010/scufl2#>
        "
  cattr_reader :prefixes
  attr_reader :graph

  @file = ''

  #constructor
  def initialize(filepath)
    @file = filepath

    @graph = RDF::Graph.new

    RDF::Reader.open("#{@file}") do |reader|
          reader.each_statement do |statement|
            @graph.insert(statement)
      end
    end
  end

  #Extract all the workflows and their parent workflow
  def getAllWorkflowRuns
    # create the query
    sparql_query = SPARQL.parse("#{Provenance.prefixes}
      SELECT *
      WHERE
      { 
        ?workflowRun  rdf:type  wfprov:WorkflowRun ;
                      rdfs:label ?workflowRunLabel .
        OPTIONAL
        { 
          ?workflowRun  wfprov:wasPartOfWorkflowRun  ?wasPartOfWorkflowRun  .
          ?wasPartOfWorkflowRun  rdfs:label ?wasPartOfWorkflowRunLabel  .
          FILTER NOT EXISTS { ?something  foaf:primaryTopic  ?wasPartOfWorkflowRun }
        }
        OPTIONAL
        {
          {
            ?workflowRun  wfprov:usedInput  ?usedDictionaryInput .
            ?usedDictionaryInput  rdf:type  prov:Dictionary
          }
          UNION
          {
            ?workflowRun  wfprov:usedInput  ?usedArtifactInput
            FILTER NOT EXISTS { ?usedArtifactInput  rdf:type  prov:Dictionary }
          }
        }
        FILTER NOT EXISTS { ?something  foaf:primaryTopic  ?workflowRun }
      }")

    #return the result of the performing the query
    sparql_query.execute(graph)
  end
 
  # Get all the ProcessRuns and their outlinks
  def getAllProcessRuns
    sparql_query = SPARQL.parse("#{Provenance.prefixes}   
      SELECT *
      WHERE
      { 
        ?processURI  rdf:type          wfprov:ProcessRun ;
                  prov:startedAtTime   ?startedAtTime ;
                  prov:endedAtTime     ?endedAtTime ;
                  wfprov:wasEnactedBy  ?engineUsed ;
                  rdfs:label            ?processLabel 
        OPTIONAL
          { 
            ?processURI  wfprov:wasPartOfWorkflowRun  ?wasPartOfWorkflow  .
            ?wasPartOfWorkflow  rdfs:label  ?wasPartOfWorkflowLabel .
            FILTER NOT EXISTS { ?something  foaf:primaryTopic  ?wasPartOfWorkflow }
          }
        OPTIONAL
        { 
          {
          ?processURI  wfprov:usedInput  ?usedDictionaryInput .
          ?usedDictionaryInput  rdf:type  prov:Dictionary
          }
          UNION
          {         
            ?processURI  wfprov:usedInput  ?usedArtifactInput
            FILTER NOT EXISTS { ?usedArtifactInput  rdf:type  prov:Dictionary }
          }        
        }
      }")

    # return the processes that were used
    sparql_query.execute(graph)
  end

  #Extract all the workflows and their parent workflow
  def getAllArtifacts
    # create the query
    sparql_query = SPARQL.parse("#{Provenance.prefixes}
      SELECT *
      WHERE
      {
        { 
          ?artifactURI  rdf:type  wfprov:Artifact  ;
                        wfprov:describedByParameter  ?describedByParameter  .
          ?describedByParameter  rdfs:comment  ?comment
          OPTIONAL
          {
            ?artifactURI  tavernaprov:content  ?filepath
          }
          OPTIONAL
          { 
            ?artifactURI  wfprov:wasOutputFrom  ?outputFromWorkflowRun .
            ?outputFromWorkflowRun  rdf:type  wfprov:WorkflowRun ;
                                    rdfs:label  ?outputFromWorkflowRunLabel .
            FILTER NOT EXISTS { ?something  foaf:primaryTopic  ?outputFromWorkflowRun }
          }
          OPTIONAL
          { 
            ?artifactURI  wfprov:wasOutputFrom  ?outputFromProcessRun .
            ?outputFromProcessRun  rdf:type  wfprov:ProcessRun  ;
                                   prov:startedAtTime  ?startedAtTime ;
                                   prov:endedAtTime    ?endedAtTime ;
                                   rdfs:label ?outputFromProcessRunLabel
          }
          FILTER NOT EXISTS { ?artifactURI  rdf:type  prov:Dictionary }
        }
        UNION
        { 
          ?dictionary  rdf:type  prov:Dictionary
          OPTIONAL
          {
            ?dictionary  tavernaprov:content  ?filepath
          }
          OPTIONAL
          { 
            {
              ?dictionary  prov:hadMember  ?hadMemberDictionary  .
              ?hadMemberDictionary  rdf:type  prov:Dictionary .
            }
            UNION
            {
              ?dictionary  prov:hadMember  ?hadMemberArtifact  .
              ?hadMemberArtifact wfprov:describedByParameter ?describedByParameter  .
              ?describedByParameter rdfs:comment ?comment  .
              FILTER NOT EXISTS { ?hadMemberArtifact  rdf:type  prov:Dictionary }
            }
          }
          OPTIONAL
          { 
            ?dictionary  wfprov:wasOutputFrom  ?outputFromWorkflowRun .
            ?outputFromWorkflowRun  rdf:type  wfprov:WorkflowRun ; 
                                    rdfs:label ?outputFromWorkflowRunLabel .
            FILTER NOT EXISTS { ?something  foaf:primaryTopic  ?outputFromWorkflowRun }
          }
          OPTIONAL
          { 
            ?dictionary  wfprov:wasOutputFrom  ?outputFromProcessRun .
            ?outputFromProcessRun  rdf:type  wfprov:ProcessRun  ;
                                   prov:startedAtTime  ?startedAtTime ;
                                   prov:endedAtTime    ?endedAtTime ;
                                   rdfs:label ?outputFromProcessRunLabel
          }
        }
      }")

    # return the result of the performing the query
    sparql_query.execute(graph)
  end

  def getContentOf(extractedFilepath)
    content = ""

    if File.directory?(extractedFilepath)
      content = "[" 

      # ffs = Files or Folders
      #for each folder/file inside this folder do
      ffs = Dir.glob(extractedFilepath + "/*")
      for file in ffs
        content = content + getContentOf("#{file}") + ", "
      end

      content = content[0...-2] + "]"

    elsif File.file?(extractedFilepath)
      content = File.read(extractedFilepath)
    end

    content
  end

  def to_dataHashObject(bundle_filepath)

    nodes = []
    links = []

    linkValue = 50
    processorTrimCount = "Processor execution ".length
    workflowRunTrimCount = "Workflow run of ".length

    # get all the workflows
    getAllWorkflowRuns.each do |result|

      # get the name
      workflowRunURI = result["workflowRun"].to_s
      workflowRunLabel = result["workflowRunLabel"].to_s
      if workflowRunLabel[0] == "W"
        workflowRunLabel = workflowRunLabel[workflowRunTrimCount, workflowRunLabel.length]
      elsif workflowRunLabel[0] == "P"
        workflowRunLabel = workflowRunLabel[processorTrimCount, workflowRunLabel.length]
      end

      # a temp node for current (Decide whether to be added or not)
      workflowRun = {:name => workflowRunURI, :type => "Workflow Run", 
                     :label => workflowRunLabel}

      # see if exists
      indexSource = nodes.find_index(workflowRun)

      # check
      if indexSource.blank?
        indexSource = nodes.count
        nodes << workflowRun
      end

      # check if has property wasPartOfWorkflowRun 
      if result["wasPartOfWorkflowRun"].present?

        secondWorkflowRunLabel = result["wasPartOfWorkflowRunLabel"].to_s
        if secondWorkflowRunLabel[0] == "W"
          secondWorkflowRunLabel = secondWorkflowRunLabel[workflowRunTrimCount, secondWorkflowRunLabel.length]
        elsif secondWorkflowRunLabel[0] == "P"
          secondWorkflowRunLabel = secondWorkflowRunLabel[processorTrimCount, secondWorkflowRunLabel.length]
        end
        secondWorkflowRun = {:name => result["wasPartOfWorkflowRun"].to_s, :type => "Workflow Run",
                             :label => secondWorkflowRunLabel}

        indexTarget = nodes.find_index(secondWorkflowRun)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << secondWorkflowRun
        end

        # add the link
        linkWfToWf = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkWfToWf).blank?
          links << linkWfToWf
        end
      end

      # check if has property usedInput 
      if result["usedArtifactInput"].present?
        artifact = {:name => result["usedArtifactInput"].to_s, :type => "Artifact" }

        indexTarget = nodes.find_index(artifact)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << artifact
        end

        # add the link
        linkProcessToArtifact = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkProcessToArtifact).blank?
          links << linkProcessToArtifact
        end
      end

      # check if has property usedInput 
      if result["usedDictionaryInput"].present?
        dictionary = {:name => result["usedDictionaryInput"].to_s, :type => "Dictionary" }

        indexTarget = nodes.find_index(artifact)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << dictionary
        end

        # add the link
        linkProcessToArtifact = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkProcessToArtifact).blank?
          links << linkProcessToArtifact
        end
      end

    end

    # get all the processes
    # get all the workflows
    getAllProcessRuns.each do |result|
      # get the name
      processRunURI = result["processURI"].to_s
      processRunLabel = result["processLabel"].to_s

      # a temp node for current (Decide whether to be added or not)
      processRun = {:name => processRunURI, :type => "Process Run", 
                    :startedAtTime => result["startedAtTime"].to_s, :endedAtTime =>result["endedAtTime"].to_s,
                    :label => processRunLabel[processorTrimCount, processRunLabel.length]}
                    

      # see if exists
      indexSource = nodes.find_index(processRun)

      # check
      if indexSource.blank?
        indexSource = nodes.count
        nodes << processRun
      end

      # check if has property wasPartOfWorkflow
      if result["wasPartOfWorkflow"].present?

        workflowRunLabel = result["wasPartOfWorkflowLabel"].to_s
        if workflowRunLabel[0] == "W"
          workflowRunLabel = workflowRunLabel[workflowRunTrimCount, workflowRunLabel.length]
        elsif workflowRunLabel[0] == "P"
          workflowRunLabel = workflowRunLabel[processorTrimCount, workflowRunLabel.length]
        end


        workflowRun = {:name => result["wasPartOfWorkflow"].to_s, :type => "Workflow Run", 
                       :label => workflowRunLabel}

        indexTarget = nodes.find_index(workflowRun)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << workflowRun
        end

        # add the link
        linkProcessToWf = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkProcessToWf).blank?
          links << linkProcessToWf
        end
      end

      # check if has property usedInput 
      if result["usedArtifactInput"].present?
        artifact = {:name => result["usedArtifactInput"].to_s, :type => "Artifact" }

        indexTarget = nodes.find_index(artifact)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << artifact
        end

        # add the link
        linkProcessToArtifact = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkProcessToArtifact).blank?
          links << linkProcessToArtifact
        end
      end

      # check if has property usedInput 
      if result["usedDictionaryInput"].present?
        dictionary = {:name => result["usedDictionaryInput"].to_s, :type => "Dictionary" }

        indexTarget = nodes.find_index(artifact)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << dictionary
        end

        # add the link
        linkProcessToArtifact = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkProcessToArtifact).blank?
          links << linkProcessToArtifact
        end
      end



      # # check if has property engineUsed which represents the wfprov:wasEnactedBy 
      # if result["engineUsed"].present?
      #   engine = {:name => result["engineUsed"].to_s, :type => "Engine"}

      #   indexTarget = nodes.find_index(engine)

      #   if indexTarget.blank?
      #     indexTarget = nodes.count
      #     nodes << engine
      #   end

    #     # add the link
      #   linkProcessToEngine = {:source => indexTarget, :target => indexSource, :value => linkValue}
      #   if links.find_index(linkProcessToEngine).blank?
      #     links << linkProcessToEngine
      #   end
      # end

    end


    # get all the nodes and links related to the artifact
    getAllArtifacts.each do |result|
      
      if result["artifactURI"].present?
        # get the name
        artifactURI = result["artifactURI"].to_s

        # the node that needs to be added to the nodes
        artifact = {:name => artifactURI, :type => "Artifact"}
      else
        # get the name
        artifactURI = result["dictionary"].to_s

        # the node that needs to be added to the nodes
        artifact = {:name => artifactURI, :type => "Dictionary"}
      end

      # get the index of the artifact if present otherwise nil
      indexSource = -1

      nodes.each_with_index do |node, index|
        if node[:type].to_s == artifact[:type].to_s
          if node[:name].to_s == artifact[:name].to_s
            indexSource = index
            artifactLabel = "List"
            if result["comment"].present?
              artifactLabel = result["comment"].to_s
            end

            if node[:label].present? and node[:label] != "List"
              node[:label] = node[:label] + "\\n" + artifactLabel
              
            else
              node.merge!(:label => artifactLabel)
            end

            if !(node[:content].present?) and result["filepath"].present?
                artifactContent = getContentOf("#{bundle_filepath}#{result["filepath"].to_s}")
                node[:content] = artifactContent
            end
          end
        end
      end

      # check if is already in the list if not add to nodes
      if indexSource == -1
        indexSource = nodes.count
        artifactLabel = "List"
        if result["comment"].present?
          artifactLabel = result["comment"].to_s
        end
        artifact[:label] = artifactLabel

        artifactContent = ""
        if result["filepath"].present?
          artifactContent = getContentOf("#{bundle_filepath}#{result["filepath"].to_s}")
          artifact[:content] = artifactContent
        end
        nodes << artifact
      end

      # check if it has the property wasOutputFrom a process Run and add a link entity-process
      if result["outputFromProcessRun"].present?
        processRunLabel = result["outputFromProcessRunLabel"].to_s

        processRun = {:name => result["outputFromProcessRun"].to_s, :type => "Process Run", 
                      :startedAtTime => result["startedAtTime"].to_s, :endedAtTime =>result["endedAtTime"].to_s,
                      :label => processRunLabel[processorTrimCount, processRunLabel.length]}
    
        indexTarget = nodes.find_index(processRun)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << processRun
        end

        # add the link
        linkArtifactToProcess = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkArtifactToProcess).blank?
          links << linkArtifactToProcess
        end
      end

      if result["outputFromWorkflowRun"].present?
        workflowRunLabel = result["outputFromWorkflowRunLabel"].to_s

        if workflowRunLabel[0] == "W"
          workflowRunLabel = workflowRunLabel[workflowRunTrimCount, workflowRunLabel.length]
        elsif workflowRunLabel[0] == "P"
          workflowRunLabel = workflowRunLabel[processorTrimCount, workflowRunLabel.length]
        end

        workflowRun = {:name => result["outputFromWorkflowRun"].to_s, :type => "Workflow Run",
                       :label => workflowRunLabel}
    
        indexTarget = nodes.find_index(workflowRun)

        if indexTarget.blank?
          indexTarget = nodes.count
          nodes << workflowRun
        end

        # add the link
        linkArtifactToWorkflow = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkArtifactToWorkflow).blank?
          links << linkArtifactToWorkflow
        end
      end

      if result["hadMemberArtifact"].present?
        memberArtifact = {:name => result["hadMemberArtifact"].to_s, :type => "Artifact"}
        
        indexTarget = -1

        nodes.each_with_index do |node, index|
          if node[:type].to_s == memberArtifact[:type].to_s
            if node[:name].to_s == memberArtifact[:name].to_s
              indexTarget = index
            end
          end
        end

        if indexTarget == -1
          if result["comment"].present?
            artifactLabel = result["comment"].to_s
            memberArtifact.merge!(:label => artifactLabel)
          end
          indexTarget = nodes.count
          nodes << memberArtifact
        end

        # add the link
        if result["outputFromProcessRun"].present?
          linkDictToArtifact = {:source => indexSource, :target => indexTarget, :value => linkValue}
          if links.find_index(linkDictToArtifact).blank?
            links << linkDictToArtifact
          end
        else
          linkDictToArtifact = {:source => indexTarget, :target => indexSource, :value => linkValue}
          if links.find_index(linkDictToArtifact).blank?
            links << linkDictToArtifact
          end
        end
      
      end

      if result["hadMemberDictionary"].present?
        dictionary = {:name => result["hadMemberDictionary"].to_s, :type => "Dictionary"}
    
        indexTarget = -1

        nodes.each_with_index do |node, index|
          if node[:type].to_s == dictionary[:type].to_s
            if node[:name].to_s == dictionary[:name].to_s
              indexTarget = index
            end
          end
        end

        if indexTarget == -1
          # if result["comment"].present?
          #   artifactLabel = result["comment"].to_s
          #   memberArtifact.merge!(:label => artifactLabel)
          # end
          indexTarget = nodes.count
          nodes << dictionary
        end

        # add the link
        linkDictToDict = {:source => indexTarget, :target => indexSource, :value => linkValue}
        if links.find_index(linkDictToDict).blank?
          links << linkDictToDict
        end
      end
    end

    # make a hash to return
    stream = {:nodes => nodes, :links => links }

    # return stream
    stream
  end

  # persisted is important not to get "undefined method `to_key' for" error
  def persisted?
    false
  end
end