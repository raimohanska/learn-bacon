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
    description: "Combine latest values of 2 inputs as array",
    example: "return Bacon.combineAsArray(a,b)",
    inputs: -> [Bacon.later(100, "a").name("a"), Bacon.later(100, "b").name("b")]
  }
]
