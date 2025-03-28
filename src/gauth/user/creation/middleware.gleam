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
import gauth/user/creation.{type UserCreationError, InvalidName}
import gleam/int
import gleam/io
import gleam/string

/// Logs to stdout when a user is about to be created
pub fn logging(name: String) -> Result(String, UserCreationError) {
  io.println("Creating user with name: " <> name)
  Ok(name)
}

/// Runs string.trim on the provided name
pub fn trim_name(name: String) -> Result(String, UserCreationError) {
  Ok(name |> string.trim)
}

/// Returns a middleware that ensures the provided name is within the required bounds. If it is not then it will return an InvalidName error 
pub fn within_length(
  min: Int,
  max: Int,
) -> fn(String) -> Result(String, UserCreationError) {
  fn(name: String) -> Result(String, UserCreationError) {
    case string.length(name) {
      len if len < min ->
        Error(InvalidName(
          name,
          "Name is too short, must be atleast " <> int.to_string(min),
        ))
      len if len > max ->
        Error(InvalidName(
          name,
          "Name is too long, must be atmost " <> int.to_string(max),
        ))
      _ -> Ok(name)
    }
  }
}
