module.exports = [
  {
    description: "Output value 1 immediately"
    example: "return Bacon.once(1)"
    inputs: -> []
    tip: "Bacon.once"
  }
  {
    description: "Output value 'lol' after 1000 milliseconds"
    example: "return Bacon.later(1000, 'lol')"
    inputs: -> []
    tip: "Bacon.later"
  }
  {
    description: "Output values 'lol' and 'wut' after 1 and 2 seconds respectively"
    example: "return Bacon.sequentially(1000, ['lol', 'wut'])"
    inputs: -> []
    tip: "Bacon.sequentially"
  }
  {
    description: "Given a stream of integers, increment each by one"
    example: "return a.map(function(a) { return a + 1})"
    inputs: -> [Bacon.sequentially(1000, [1,2,3]).name("a")]
    tip: "map"
  }
  {
    description: "Given a stream of integers, filter out those less than 2"
    example: "return a.filter(function(a) { return a >= 2 })"
    inputs: -> [Bacon.sequentially(1000, [1,2,3,1]).name("a")]
    tip: "filter"
  }
  {
    description: "Given a stream of functions, apply each to the value 1"
    example: "return a.map(function(f) { return f(1) })"
    inputs: -> [Bacon.sequentially(1000, [((x) -> x),((x) ->  x+1)]).name("a")]
    tip: "map"
  }
  {
    description: "Delay stream values by 500 milliseconds"
    example: "return a.delay(500)"
    inputs: -> [Bacon.sequentially(1000, [1,2,3]).name("a")]
    tip: "delay"
  }
  {
    description: "Output all values, but limit output to maximum 1 event per 1000 milliseconds",
    example: "return a.bufferingThrottle(1000)"
    inputs: -> [Bacon.sequentially(500, [1,2,3]).name("a")]
    tip: "bufferingThrottle"
  }
  {
    description: "Combine latest values of 2 inputs as array"
    example: "return Bacon.combineAsArray(a,b)"
    inputs: -> [Bacon.once("a").concat(Bacon.later(2000, "b")).name("a"), Bacon.later(1000, "1").name("b")]
    tip: "combineAsArray"
  }
  {
    description: "Combine latest values of 2 inputs by concatenating"
    example: "return a.combine(b, function(a,b) { return a + b})"
    inputs: -> [Bacon.once("a").concat(Bacon.later(2000, "b")).name("a"), Bacon.later(1000, "1").concat(Bacon.later(2000, "2")).name("b")]
    tip: "combine"
  }
  {
    description: "Given a stream of functions and a stream of values, combine them by applying the latest function to the latest value",
    example: "return fs.combine(vs, function(f,v) { return f(v) })"
    inputs: -> [Bacon.sequentially(2000, [((x) -> x),((x) ->  x+1)]).name("fs"), Bacon.sequentially(2000, [1, 2, 3]).delay(500).name("vs")]
    tip: "combine"
  }
]
