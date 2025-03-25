import gauth/user.{type User}

pub type UserCreationError {
  InvalidName(name: String, reason: String)
  Generic(message: String)
}

pub type UserCreationService(identifier) {
  UserCreationService(
    create_user: fn(String) -> User(identifier),
    middleware: List(fn(String) -> Result(String, UserCreationError)),
    finalware: List(fn(User(identifier)) -> User(identifier)),
  )
}

fn create_user_middleware(
  user: String,
  middleware: List(fn(String) -> Result(String, UserCreationError)),
) -> Result(String, UserCreationError) {
  case middleware {
    [] -> Ok(user)
    [middleware, ..rest] ->
      case middleware(user) {
        Ok(user) -> create_user_middleware(user, rest)
        Error(error) -> Error(error)
      }
  }
}

fn create_user_finalware(
  user: User(identifier),
  finalware: List(fn(User(identifier)) -> User(identifier)),
) -> User(identifier) {
  case finalware {
    [] -> user
    [finalware, ..rest] -> create_user_finalware(finalware(user), rest)
  }
}

pub fn create_user(
  user: String,
  service: UserCreationService(identifier),
) -> Result(User(identifier), UserCreationError) {
  case create_user_middleware(user, service.middleware) {
    Ok(user) ->
      Ok(create_user_finalware(service.create_user(user), service.finalware))
    Error(error) -> Error(error)
  }
}
