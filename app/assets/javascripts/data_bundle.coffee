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

margin =
  top: 0
  right: 320
  bottom: 0
  left: 0
width = 960 - (margin.left) - (margin.right)
height = 500 - (margin.top) - (margin.bottom)

@draw_workflow = ->
  tree = d3.layout.tree().separation((a, b) ->
    if a.parent == b.parent then 1 else .5
  ).children((d) ->
    d.parents
  ).size([
      height
      width
    ])

  svg = d3.select('#d3_visualization').append('svg').attr('width', width + margin.left + margin.right).attr('height',
    height +
      margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  d3.json $('#data_bundle').attr('data-url'), (error, json) ->
    if error
      throw error

    nodes = tree.nodes(json)
    link = svg.selectAll('.link').data(tree.links(nodes)).enter().append('path').attr('class', 'link').attr('d', elbow)
    node = svg.selectAll('.node').data(nodes).enter().append('g').attr('class', 'node').attr('transform', (d) ->
      'translate(' + d.y + ',' + d.x + ')')
    node.append('text').attr('class', 'name').attr('x', 8).attr('y', -6).text (d) ->
      d.name
    node.append('svg:title').text((d) -> "Click for see template")

    node.append('text').attr('x', 8).attr('y', 8).attr('dy', '.71em').attr('class', 'about lifespan')
    .on "click", (d) ->
      console.log("click on file name")
    .html (d) ->
      $.map(d.inputs, (val, i) ->
        return val.file
      ).join(', ')
  return

elbow = (d, i) ->
  'M' + d.source.y + ',' + d.source.x + 'H' + d.target.y + 'V' + d.target.x + (if d.target.children then '' else 'h' + margin.right)
