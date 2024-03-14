import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/order.{Lt}
import gleam/regex
import gleam/string


pub type Analysis {
  Analysis(most_frequent_words: List(String), longest_word: String, first_words: List(String))
}

type WordOccurence = #(String, Int)

pub fn analyze(text: String) -> Analysis {
  let words = words(text)

  Analysis(
    longest_word: list.fold(words, "", longest_string),
    first_words: list.take(words, 5),
    most_frequent_words: {
      words_occurences_sorted(words, True)
      |> list.map(fn (occurence) { occurence.0 })
      |> list.take(5)
    }
  )
}

pub fn analyze_to_string(text: String) -> String {
  let analysis = analyze(text)

  [
    "First words: " <> string.join(analysis.first_words, ", "),
    "Most frequent words: " <> string.join(analysis.most_frequent_words, ", "),
    "Longest word: " <> analysis.longest_word
  ]
  |> string.join("\n")
}

pub fn words(text: String) -> List(String) {
  let pattern = "[a-zA-Z0-0']+"
  let options = regex.Options(case_insensitive: True, multi_line: True)

  let assert Ok(re) = regex.compile(pattern, options)

  regex.scan(re, text) |> list.map(fn (match) { match.content })
}

pub fn words_occurences(words: List(String)) -> List(WordOccurence) {
  {
    use occurences, word <- list.fold(words, dict.new())
    use value <- dict.update(occurences, word)
    option.unwrap(value, 0) + 1
  }
  |> dict.to_list()
}

pub fn words_occurences_sorted(words: List(String), reverse: Bool) -> List(WordOccurence) {
  let occurences = words_occurences(words) |> list.sort(fn (a, b) { int.compare(a.1, b.1) })
  use <- bool.guard(reverse == False, occurences)
  list.reverse(occurences)
}

fn longest_string(a: String, b: String) -> String {
  case int.compare(string.length(a), string.length(b)) {
    Lt -> b
    _ -> a
  }
}
