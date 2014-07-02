module.exports = [
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
    description: "Output values 'lol' and 'wut' after 1 and 2 seconds respectively",
    example: "return Bacon.sequentially(1000, ['lol', 'wut'])",
    inputs: -> []
  }
  ,{
    description: "Combine latest values of 2 inputs as array",
    example: "return Bacon.combineAsArray(a,b)",
    inputs: -> [Bacon.once("a").concat(Bacon.later(2000, "b")).name("a"), Bacon.later(1000, "1").name("b")]
  }
  ,{
    description: "Combine latest values of 2 inputs by concatenating",
    example: "return a.combine(b, function(a,b) { return a + b})",
    inputs: -> [Bacon.once("a").concat(Bacon.later(2000, "b")).name("a"), Bacon.later(1000, "1").concat(Bacon.later(2000, "2")).name("b")]
  }
  ,{
    description: "Given a stream of integers, increment each by one",
    example: "return a.map(function(a) { return a + 1})",
    inputs: -> [Bacon.sequentially(1000, [1,2,3]).name("a")]
  }
  ,{
    description: "Given a stream of integers, filter out those less than 2",
    example: "return a.filter(function(a) { return a >= 2 })",
    inputs: -> [Bacon.sequentially(1000, [1,2,3,1]).name("a")]
  }
  ,{
    description: "Given a stream of functions, apply each to the value 1",
    example: "return a.map(function(f) { return f(1) })",
    inputs: -> [Bacon.sequentially(1000, [((x) -> x),((x) ->  x+1)]).name("a")]
  }
  ,{
    description: "Given a stream of functions and a stream of values, combine them by applying the latest function to the latest value",
    example: "return fs.combine(vs, function(f,v) { return f(v) })",
    inputs: -> [Bacon.sequentially(2000, [((x) -> x),((x) ->  x+1)]).name("fs"), Bacon.sequentially(2000, [1, 2, 3]).delay(500).name("vs")]
  }
]
