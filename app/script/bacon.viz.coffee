Bacon = require("baconjs")
d3=require("d3")
_=require("lodash")

tn = new Date().valueOf()
scale = d3.scale.linear().range([ 0,300 ]).domain([ tn - 10000, tn ])
Visualizer = (container) ->
  time = Bacon.fromPoll(1000 / 30, ->
    new Bacon.Next(new Date().valueOf())
  )
  time.map((t) -> [ t - 10000, t ]).assign (ds) ->
    scale.domain ds

  reset = ->
    d3.selectAll(container + " *").remove()
  drawStream = (stream) ->
    svg = d3.select(container).append("svg")
    svg.append("text").text(stream.toString()).attr( x: 5, y: 20).attr "class", "title"

    circles = []
    stream = stream.map((p) ->
      if !p?
        p="undefined"
      if p.color
        console.log "c", p.color
        v: p.v
        color: p.color
        time: new Date().valueOf()
      else
        v: p
        time: new Date().valueOf()
        color: "black"
    )
    drawCircles = ->
      sel = svg.selectAll("circle").data(circles, (d) ->
        d.time
      )
      sel.enter().append("circle").attr(
        cy: 40
        r: 6
        cx: 20
      ).style "fill", (d) ->
        d.color

      sel.attr "cx", (d) ->
        scale d.time

      sel.exit().remove()
      tsel = svg.selectAll("text.p").data(circles, (d) ->
        d.time
      )
      tsel.enter().append("text").attr("class", "p").text((d) ->
        d.v
      ).attr("y", 60).attr "text-anchor", "middle"
      tsel.attr "x", (d) ->
        scale d.time

      tsel.exit().remove()

    time.assign drawCircles
    stream.onValue (c) ->
      circles.push c
  return { reset, drawStream }

module.exports = Visualizer
