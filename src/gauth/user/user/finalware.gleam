import gauth/user
import gleam/io

pub fn logging(user: user.User(identifier)) -> user.User(identifier) {
  io.println("Created user " <> user.name)
  user
}
