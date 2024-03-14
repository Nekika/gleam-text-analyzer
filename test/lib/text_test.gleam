import gleeunit
import gleeunit/should

import lib/text

pub fn main() {
  gleeunit.main()
}

fn words_test(input: String, expected: List(String)) {
  text.words(input) |> should.equal(expected)
}
pub fn words_empty_string_test() {
  words_test("", [])
}

pub fn words_single_word_string_test() {
  words_test("Word", ["Word"])
}

pub fn words_complex_string_test() {
  words_test(
    "Hello, World! I'm glad to meet you.",
    ["Hello", "World", "I'm", "glad", "to", "meet", "you"]
  )
}


