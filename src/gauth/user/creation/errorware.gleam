import gauth/user/creation
import gleam/io

pub fn logging(error: creation.UserCreationError) -> creation.UserCreationError {
  case error {
    creation.InvalidName(name, reason) ->
      io.println(
        "Failed to create user due to invalid name: "
        <> name
        <> ". Reason: "
        <> reason,
      )
    creation.Generic(message) ->
      io.println("Failed to create user due to: " <> message)
  }
  error
}
