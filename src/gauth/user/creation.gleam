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
    errorware: List(fn(UserCreationError) -> UserCreationError),
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

fn do_ware(obj: a, ware: List(fn(a) -> a)) -> a {
  case ware {
    [] -> obj
    [ware, ..rest] -> do_ware(ware(obj), rest)
  }
}

pub fn create_user(
  user: String,
  service: UserCreationService(identifier),
) -> Result(User(identifier), UserCreationError) {
  case create_user_middleware(user, service.middleware) {
    Ok(user) -> Ok(do_ware(service.create_user(user), service.finalware))
    Error(error) -> Error(do_ware(error, service.errorware))
  }
}
