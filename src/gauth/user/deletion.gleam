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
pub type UserDeletionError(identifier) {
  NoSuchUser(id: identifier)
  Generic(message: String)
}

pub type UserDeletionService(identifier) {
  UserDeletionService(
    delete_user: fn(identifier) -> Result(Nil, UserDeletionError(identifier)),
    middleware: List(
      fn(identifier) -> Result(identifier, UserDeletionError(identifier)),
    ),
    errorware: List(
      fn(UserDeletionError(identifier)) -> UserDeletionError(identifier),
    ),
  )
}

fn delete_user_middleware(
  user: identifier,
  middleware: List(
    fn(identifier) -> Result(identifier, UserDeletionError(identifier)),
  ),
) -> Result(identifier, UserDeletionError(identifier)) {
  case middleware {
    [] -> Ok(user)
    [middleware, ..rest] ->
      case middleware(user) {
        Ok(user) -> delete_user_middleware(user, rest)
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
  service: UserDeletionService(identifier),
  middleware: fn(identifier) ->
    Result(identifier, UserDeletionError(identifier)),
) -> UserDeletionService(identifier) {
  UserDeletionService(
    service.delete_user,
    [middleware, ..service.middleware],
    service.errorware,
  )
}

pub fn with_errorware(
  service: UserDeletionService(identifier),
  errorware: fn(UserDeletionError(identifier)) -> UserDeletionError(identifier),
) -> UserDeletionService(identifier) {
  UserDeletionService(service.delete_user, service.middleware, [
    errorware,
    ..service.errorware
  ])
}

pub fn delete_user(
  user: identifier,
  service: UserDeletionService(identifier),
) -> Result(Nil, UserDeletionError(identifier)) {
  case delete_user_middleware(user, service.middleware) {
    Ok(user) -> service.delete_user(user)
    Error(error) -> Error(do_ware(error, service.errorware))
  }
}
