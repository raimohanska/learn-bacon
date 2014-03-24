Bacon = require("baconjs")
$ = require("jquery")

Bacon.Observable :: withTimestamp = ({ relative, precision } = { precision: 1 }) ->
  offset = if relative then new Date().getTime() else 0
  @flatMap (value) -> { value, timestamp: Math.floor((new Date().getTime() - offset) / precision) }

assignment = {
  description: "output value 1 immediately",
  example: "function answer() { return Bacon.once(1) }",
  template: "function answer() { return Bacon.never() }"
  inputs: -> []
}

evaluateAssignment = (assignment, code) ->
  actual = evalCode(code)(assignment.inputs() ...)
  expected = evalCode(assignment.example)(assignment.inputs() ...)

  values = []
  expectedValues = []
  collectAndVisualize(actual, values, "expected")
  collectAndVisualize(expected, expectedValues, "actual")

collectAndVisualize = (src, values, desc) -> 
  src.withTimestamp({relative:true, precision: 100}).onValue (value) ->
    values.push(value)
    console.log(desc, value)

evalCode = (code) -> eval("(" + code + ")")

evaluateAssignment assignment, "function answer() { return Bacon.later(1000, 2) }"
