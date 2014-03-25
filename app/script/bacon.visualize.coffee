d3=require("d3")
_=require("lodash")
Visualizer = (root, streamsP, Bacon) ->
  streamsP.onValue (streams) ->
    shown = d3.select(root).selectAll("p")
      .data(streams)
    shown
      .enter().append("p").text((d) -> d.toString() )
    shown
      .exit().remove()
module.exports = Visualizer
