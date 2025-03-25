import gauth/user/creation.{type UserCreationError, InvalidName}
import gleam/int
import gleam/io
import gleam/string

pub fn logging(name: String) -> Result(String, UserCreationError) {
  io.println("Creating user with name: " <> name)
  Ok(name)
}

pub fn trim_name(name: String) -> Result(String, UserCreationError) {
  Ok(name |> string.trim)
}

pub fn within_length(
  min: Int,
  max: Int,
) -> fn(String) -> Result(String, UserCreationError) {
  fn(name: String) -> Result(String, UserCreationError) {
    case string.length(name) {
      len if len < min ->
        Error(InvalidName(
          name,
          "Name is too short, must be atleast " <> int.to_string(min),
        ))
      len if len > max ->
        Error(InvalidName(
          name,
          "Name is too long, must be atmost " <> int.to_string(max),
        ))
      _ -> Ok(name)
    }
  }
}
