import gleam/option.{type Option, None, Some}

pub type User {
  User(id: Int, name: String)
}

pub type UserError {
  Generic(message: String)
  InvalidId(id: Option(Int))
  InvalidName(name: String, problem: String)
}

pub type UserFactory {
  UserFactory(create: fn(Option(Int), String) -> Result(User, UserError))
}

fn null_create_user(_id: Option(Int), _name: String) -> Result(User, UserError) {
  Ok(User(id: 0, name: "None"))
}

/// Creates a new UserFactory that ignores all arguments and just returns a user with an ID of 0
pub fn null_user_factory() -> UserFactory {
  null_create_user |> UserFactory
}

fn simple_create_user(id: Option(Int), name: String) -> Result(User, UserError) {
  case id {
    Some(id) -> Ok(User(id: id, name: name))
    None -> Error(InvalidId(id))
  }
}

/// Creates a new UserFactory that creates a user with the given ID and name
pub fn simple_user_factory() -> UserFactory {
  simple_create_user |> UserFactory
}
