import gleam/io
import gleam/result

import argv
import simplifile

import lib/text

type CustomError {
  UsageError(cause: String)
  ProcessingError(cause: String)
}

pub fn main() {
  let result = {
    use filename <- result.try(get_filename())
    use content <- result.map(open_file(filename))
    text.analyze_to_string(content)
  }

  case result {
    Ok(analysis) -> io.println(analysis)
    Error(error) -> {
      io.println("Error: " <> error.cause <> "\n")
      case error {
        UsageError(_) -> io.println("Usage:\n\tbook <filename>")
        _ -> Nil
      }
    }
  }
}

fn get_filename() -> Result(String, CustomError) {
  case argv.load().arguments {
    [filename] -> Ok(filename)
    _ -> Error(UsageError("filename argument is missing"))
  }
}

fn open_file(filename: String) -> Result(String, CustomError) {
  simplifile.read(filename)
  |> result.replace_error(ProcessingError("failed to read file"))
}
