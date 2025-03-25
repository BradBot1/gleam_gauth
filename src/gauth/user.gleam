import gleam/option.{type Option}

pub type User(identifier) {
  User(id: identifier, name: String)
}

pub type UserError(identifier) {
  Generic(message: String)
  InvalidId(id: Option(identifier))
}
