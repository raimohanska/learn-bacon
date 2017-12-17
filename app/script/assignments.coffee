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
    description: "Given a stream of integers, calculate a running sum of the values."
    example: "return a.scan(0, function(acc, value) { return acc + value})"
    inputs: -> [Bacon.sequentially(1000, [1,2,3]).name("a")]
    tip: "scan"
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
    description: "Output all values from both given streams"
    example: "return a.merge(b)"
    inputs: -> [Bacon.once("a").concat(Bacon.later(2000, "b")).name("a"), Bacon.later(1000, "1").name("b")]
    tip: "merge"
  }
  {
    description: "Output all values from all three streams"
    example: "return Bacon.mergeAll(a, b, c)"
    inputs: -> [Bacon.once("a").concat(Bacon.later(2000, "b")).name("a"), Bacon.later(1000, "1").name("b"), Bacon.later(3000, "hello").name("c")]
    tip: "Bacon.mergeAll"
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
  {
    description: "Combine the latest values of streams a,b and c, using the given function f"
    example: "return Bacon.combineWith(a, b, c, f)"
    inputs: -> [
      Bacon.once("a").concat(Bacon.later(4000, "b")).name("a")
      Bacon.later(1000, "1").name("b")
      Bacon.later(2000, "hello").name("c")
      `function f(a,b,c) { return a+b+c }`
    ]
    tip: "Bacon.combineWith"
  }
  {
    description: "Given a stream of URLs, fetch the content of each, using the given fetch function that returns an EventStream",
    example: "return urls.flatMap(fetch)"
    inputs: -> [
      Bacon.sequentially(2000, ["/cats", "/dogs", "/giraffes"]).name("urls")
      `function fetch(url) { return Bacon.later(500, url.substring(1)) }`
    ]
    tip: "flatMap"
  }
  {
    description: "Given a stream of URLs, fetch the content of each, using the given fetch function that returns an EventStream. If the previous fetch is still under progress when fetching the next one, discard the result of the pending fetch.",
    example: "return urls.flatMapLatest(fetch)"
    inputs: -> [
      Bacon.sequentially(2000, ["/cats", "/dogs", "/giraffes"]).name("urls")
      `function fetch(url) { return Bacon.later(url == "/dogs" ? 4000 : 500, url.substring(1)) }`
    ]
    tip: "flatMapLatest"
  }
  {
    description: "Given a stream of URLs, fetch the content of each, using the given fetch function that returns a Promise",
    example: "return urls.flatMap(function(value) { return Bacon.fromPromise(fetch(value)) })"
    inputs: -> [
      Bacon.sequentially(2000, ["/cats", "/dogs", "/giraffes"]).name("urls")
      `function fetch(url) { return new Promise(resolve => setTimeout(() => resolve(url.substring(1)), 500)) }`
    ]
    tip: "flatMap, Bacon.fromPromise"
  }
  {
    description: "Output the latest value of stream \"a\" at the time of each event in stream \"b\""
    example: "return a.sampledBy(b)"
    inputs: -> [
      Bacon.once("a").concat(Bacon.later(2000, "b")).concat(Bacon.later(500, "c")).name("a")
      Bacon.later(1000, "1").concat(Bacon.later(2000, "2")).name("b")
    ]
    tip: "sampledBy"
  }
  {
    description: "Starting from value zero (0), add the value of each event in stream \"a\", multiply by each value in stream \"b\", and reset back to zero on each value in stream \"c\""
    example: """
return Bacon.update(0,
  a, function(state, x) { return state + x },
  b, function(state, x) { return state * x },
  c, function() { return 0 }
)
"""
    inputs: -> [
      Bacon.sequentially(1000, [1,2,3]).name("a")
      Bacon.later(4000, 100).name("b")
      Bacon.later(5000, "reset").name("c")
    ]
    tip: "Bacon.update"
  }
]
