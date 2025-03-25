import gauth/user/deletion
import gleam/io

pub fn logging(
  error: deletion.UserDeletionError(identifier),
) -> deletion.UserDeletionError(identifier) {
  case error {
    deletion.NoSuchUser(_) ->
      io.println("Failed to delete user with as no such user exists")
    deletion.Generic(message) ->
      io.println("Failed to delete user due to: " <> message)
  }
  error
}
