Bacon = window.Bacon = require("baconjs")
$ = window.$ = require("jquery")
_ = require("lodash")
Visualizer = require("./bacon.viz.coffee")
visualizer = new Visualizer("#visualizer")

$code = $("#code")
$header = $("#assignment .heading")
codeMirror = CodeMirror.fromTextArea $code.get(0), { 
  lineNumbers: true
  mode: "javascript"
  theme: "solarized dark"
}

$.fn.asEventStream = Bacon.$.asEventStream

Bacon.Observable :: withTimestamp = ({ relative, precision } = { precision: 1 }) ->
  offset = if relative then new Date().getTime() else 0
  @flatMap (value) -> { value, timestamp: Math.floor((new Date().getTime() - offset) / precision) }

answerTemplate = "function answer($signature) {\n  $body\n}"

generateCode = (signature, body = "return Bacon.never()") ->
  answerTemplate.replace("$signature", signature).replace("$body", body)

argumentToString = (arg) ->
  if arg instanceof Bacon.Observable
    arg.toString()
  else if typeof arg == "function"
    arg.name
  else
    arg

assignments = require("./assignments.coffee").map (a, i) ->
  a.number = i+1
  a.signature = a.inputs().map(argumentToString).join(", ")
  a

presentAssignment = (visualizer, assignment) ->
  $("body").css("opacity", 1)
  $header.css("opacity", 0)
  hideResult()
  $("#assignment .description").text(assignment.description)
  $("#assignment .number").text(assignment.number)
  $("#result .tip-text").text("PRO TIP: " + assignment.tip)
  code = generateCode(assignment.signature)
  codeMirror.setValue(code)
  codeP = Bacon.fromEventTarget(codeMirror, "change")
    .map(".getValue")
    .toProperty(code)
  enabledP = codeP.changes().map(true).toProperty(false)

  $run = $("#assignment .run")
  evalE = codeP.filter(enabledP).sampledBy($run.asEventStream("click").doAction(".preventDefault"))
    .takeUntil(currentAssignment.changes())

  resultE = evalE.flatMap (code) ->
    showResult("Running")
    evaluateAssignment visualizer, assignment, code
  
  enabledP.onValue (enabled) ->
    $run.toggleClass("disabled", !enabled)

  resultE
    .map((x) -> if x then "Success" else "Failed")
    .onValue(showResult)

  $header.animate({"opacity": 1})

  $("#result .cheat").click(->
    exampleCode = generateCode(assignment.signature, assignment.example)
    codeMirror.setValue(exampleCode)
  )

hideResult = ->
  showResult("None")
showResult =  (result) ->
  $("#result")
    .removeClass("failed success running none")
    .addClass(result.toLowerCase())
    .show()
    .find(".text").text(result)

evaluateAssignment = (visualizer, assignment, code) ->
  try
    actual = -> evalCode(code)(assignment.inputs() ...).name("Actual")
    expected = -> evalCode(generateCode(assignment.signature, assignment.example))(assignment.inputs() ...).name("Expected")

    visualizer.reset()

    streams = assignment.inputs()
      .filter((s) => s instanceof Bacon.Observable)
      .concat([actual(), expected()])
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
  catch e
    alert(e)
    Bacon.once(false)

timestampedValues = (src) ->
  src.withTimestamp({relative:true, precision: 100})

foldValues = (src) ->
  src.fold([], (values, value) -> values.concat(value))

collectAndVisualize = (src, values, desc) -> 
  src.withTimestamp({relative:true, precision: 100}).onValue (value) ->
    values.push(value)
    console.log(desc, value)

evalCode = (code) -> eval("(" + code + ")")

indexFromHash = -> (parseInt(location.hash.substring(1)) || 1) - 1
hash = Bacon.fromEventTarget(window, "hashchange").map(indexFromHash)

diff = $(".previous").asEventStream("click").map(-1)
  .merge($(".next").asEventStream("click").map(1))

currentAssignmentIndex = Bacon.update(indexFromHash(),
  diff, (i, diff) -> i+diff,
  hash, (i, hash) -> indexFromHash())

currentAssignment = currentAssignmentIndex
  .map((i) -> assignments[i])

currentAssignmentIndex.onValue (x) ->
  location.hash = "#" + (x+1)

toggleLink = ($link, enabledP) ->
  enabledP.assign (enabled) -> $link.toggleClass("disabled", !enabled)

toggleLink($(".previous"), currentAssignmentIndex.map((index) -> index > 0))
toggleLink($(".next"), currentAssignmentIndex.map((index) -> index < assignments.length - 1))

currentAssignment.onValue presentAssignment, visualizer
