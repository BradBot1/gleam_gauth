//  Copyright 2025 BradBot_1

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

pub fn with_middleware(
  service: UserCreationService(identifier),
  middleware: fn(String) -> Result(String, UserCreationError),
) -> UserCreationService(identifier) {
  UserCreationService(
    service.create_user,
    [middleware, ..service.middleware],
    service.finalware,
    service.errorware,
  )
}

pub fn with_finalware(
  service: UserCreationService(identifier),
  finalware: fn(User(identifier)) -> User(identifier),
) -> UserCreationService(identifier) {
  UserCreationService(
    service.create_user,
    service.middleware,
    [finalware, ..service.finalware],
    service.errorware,
  )
}

pub fn with_errorware(
  service: UserCreationService(identifier),
  errorware: fn(UserCreationError) -> UserCreationError,
) -> UserCreationService(identifier) {
  UserCreationService(
    service.create_user,
    service.middleware,
    service.finalware,
    [errorware, ..service.errorware],
  )
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
