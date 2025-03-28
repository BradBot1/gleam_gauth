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
import gauth/user/creation
import gleam/io

/// Logs to stderr when a user isn't created
pub fn logging(error: creation.UserCreationError) -> creation.UserCreationError {
  case error {
    creation.InvalidName(name, reason) ->
      io.println_error(
        "Failed to create user due to invalid name: "
        <> name
        <> ". Reason: "
        <> reason,
      )
    creation.Generic(message) ->
      io.println_error("Failed to create user due to: " <> message)
  }
  error
}
