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

@draw_workflow = ->
  if $('svg#graphContainer').length > 0
    d3.json $('#data_bundle').attr('data-url'), (error, links) ->
      tick = ->
        path.attr 'd', (d) ->
          dx = d.target.x - (d.source.x)
          dy = d.target.y - (d.source.y)
          dr = Math.sqrt(dx * dx + dy * dy)
          'M' + d.source.x + ',' + d.source.y + 'A' + dr + ',' + dr + ' 0 0,1 ' + d.target.x + ',' + d.target.y
        node.attr 'transform', (d) ->
          'translate(' + d.x + ',' + d.y + ')'
        return

      nodes = {}
      links.forEach (link) ->
        link.source = nodes[link.source] or (nodes[link.source] =
            name: link.source, file_content: link.file_content)
        link.target = nodes[link.target] or (nodes[link.target] =
            name: link.target, file_content: link.file_content)
        link.value = +link.value
        return

      width = 960
      height = 900

      force = d3.layout.force().nodes(d3.values(nodes)).links(links).size([width, height])
      .linkDistance(100).charge(-500).on('tick', tick).start()
      svgContainer = d3.select('svg#graphContainer').attr('width', width).attr('height', height)
      # build the arrow.
      svgContainer.append('svg:defs').selectAll('marker').data(['end']).enter().append('svg:marker').attr('id', String)
      .attr('viewBox', '0 -5 10 10').attr('refX', 15).attr('refY', -1.5).attr('markerWidth', 6)
      .attr('markerHeight', 6).attr('orient', 'auto').append('svg:path').attr 'd', 'M0,-5L10,0L0,5'
      # add the links and the arrows
      path = svgContainer.append('svg:g').selectAll('path').data(force.links()).enter().append('svg:path')
      .attr('class', 'link').attr('marker-end', 'url(#end)')
      # define the nodes
      node = svgContainer.selectAll('.node').data(force.nodes()).enter().append('g').attr('class', 'node')
      .attr('id', (d) -> d.name).call(force.drag)
      # add the nodes
      node.append('circle').attr('r', 5)
      # add the text
      node.append('text').attr('x', 12).attr('dy', '.35em').text (d) ->
        d.name
      node.append('text').attr('class', 'file_content').attr('visibility', 'hidden').text (d) ->
        return d.file_content

      node.on 'click', (d) ->
        rect = svgContainer.append('rect').transition().duration(500).attr('width', 250)
        .attr('height', 300).attr('x', 10).attr('y', 10).style('fill', 'white').attr('stroke', 'black')
        text = svgContainer.append('text').text(d.file_content)
        .attr('x', 50).attr('y', 150).attr('fill', 'black')
      return
