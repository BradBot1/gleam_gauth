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

/// An error relating to the deletion of a user
pub type UserDeletionError(identifier) {
  /// The user requested to be deleted does not exist
  NoSuchUser(id: identifier)
  /// A generic error such as the data source being unreachable
  Generic(message: String)
}

/// The deletion service for a user
/// Do not interact with the delete_user function directly, instead use the delete_user function provided by this module
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

/// Performs all middleware in sequence
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

/// Performs all wares in sequence
fn do_ware(obj: a, ware: List(fn(a) -> a)) -> a {
  case ware {
    [] -> obj
    [ware, ..rest] -> do_ware(ware(obj), rest)
  }
}

/// Adds a middleware to the service
/// The provided middleware is appended at the start of the middleware list
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

/// Adds an errorware to the service
/// The provided errorware is appended at the start of the errorware list
pub fn with_errorware(
  service: UserDeletionService(identifier),
  errorware: fn(UserDeletionError(identifier)) -> UserDeletionError(identifier),
) -> UserDeletionService(identifier) {
  UserDeletionService(service.delete_user, service.middleware, [
    errorware,
    ..service.errorware
  ])
}

/// Deletes the user with the given identifier by:
/// - Applying all middleware in sequence
/// - Deleting the user via the service's delete_user function
/// Any errors will first go through all errorware in sequence before being returned
pub fn delete_user(
  user: identifier,
  service: UserDeletionService(identifier),
) -> Result(Nil, UserDeletionError(identifier)) {
  case delete_user_middleware(user, service.middleware) {
    Ok(user) -> service.delete_user(user)
    Error(error) -> Error(do_ware(error, service.errorware))
  }
}
