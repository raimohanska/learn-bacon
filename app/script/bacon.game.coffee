Bacon = window.Bacon = require("baconjs")
$ = require("jquery")
_ = require("lodash")
Visualizer = require("./bacon.viz.coffee")
visualizer = new Visualizer("#visualizer")

$.fn.asEventStream = Bacon.$.asEventStream

Bacon.Observable :: withTimestamp = ({ relative, precision } = { precision: 1 }) ->
  offset = if relative then new Date().getTime() else 0
  @flatMap (value) -> { value, timestamp: Math.floor((new Date().getTime() - offset) / precision) }

answerTemplate = "function answer($signature) {\n  $body\n}"

generateCode = (signature, body = "return Bacon.never()") ->
  answerTemplate.replace("$signature", signature).replace("$body", body)

assignments = [
  {
    description: "Output value 1 immediately"
    example: "return Bacon.once(1)"
    inputs: -> []
  }
  ,{
    description: "Output value 'lol' after 1000 milliseconds",
    example: "return Bacon.later(1000, 'lol')",
    inputs: -> []
  }
  ,{
    description: "Combine latest values of 2 inputs as array",
    example: "return Bacon.combineAsArray(a,b)",
    inputs: -> [Bacon.later(100, "a").name("a"), Bacon.later(100, "b").name("b")]
  }
].map (a, i) ->
  a.number = i+1
  a.signature = a.inputs().map((obs) -> obs.toString()).join(", ")
  a

presentAssignment = (visualizer, assignment) ->
  $("#assignment .description").text(assignment.description)
  $("#assignment .number").text(assignment.number)
  $code = $("#assignment .code")
  $code.val(generateCode(assignment.signature))
  codeP = $code.asEventStream("input").merge(Bacon.once()).toProperty().map(-> $code.val())

  evalE = codeP.sampledBy($("#assignment .run").asEventStream("click").doAction(".preventDefault"))
    .takeUntil(currentAssignment.changes())

  resultE = evalE.flatMap (code) ->
    showResult "running"
    evaluateAssignment visualizer, assignment, code

  resultE.map((x) -> if x then "Success" else "FAIL").onValue(showResult)

showResult =  (result) ->
  $("#output .result").text(result).removeClass("fail,success,running").addClass(result.toLowerCase())

evaluateAssignment = (visualizer, assignment, code) ->
  actual = -> evalCode(code)(assignment.inputs() ...).name("Actual")
  expected = -> evalCode(generateCode(assignment.signature, assignment.example))(assignment.inputs() ...).name("Expected")

  visualizer.reset()

  streams = (assignment.inputs().concat([actual(), expected()]))
  streams.forEach (stream) ->
    visualizer.drawStream(stream)

  actualValues = timestampedValues actual()
  expectedValues = timestampedValues expected()

  comparableValues = Bacon.combineTemplate
    actual: foldValues(actualValues)
    expected: foldValues(expectedValues)

  success = comparableValues.map ({actual, expected}) ->
    _.isEqual(actual, expected)

  success

timestampedValues = (src) ->
  src.withTimestamp({relative:true, precision: 100})

foldValues = (src) ->
  src.fold([], (values, value) -> values.concat(value))

collectAndVisualize = (src, values, desc) -> 
  src.withTimestamp({relative:true, precision: 100}).onValue (value) ->
    values.push(value)
    console.log(desc, value)

evalCode = (code) -> eval("(" + code + ")")

currentAssignmentIndex = $("#assignment .previous").asEventStream("click").map(-1)
  .merge($("#assignment .next").asEventStream("click").map(1))
  .scan(0, (num, diff) -> Math.min(assignments.length - 1, Math.max(0, num + diff)))
  .skipDuplicates()

currentAssignment = currentAssignmentIndex
  .map((i) -> assignments[i])

currentAssignment.onValue presentAssignment, visualizer
