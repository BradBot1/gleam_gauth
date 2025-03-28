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
import gleam/option.{type Option}

/// A tuple of an identifier and a name
/// Identifiers must be unique.
/// Names can be reused across Users.
pub type User(identifier) {
  User(id: identifier, name: String)
}

pub type UserError(identifier) {
  /// A generic error such as a user being disabled.
  Generic(message: String)
  /// The user id provided isn't valid, IE too long/format etc
  InvalidId(id: Option(identifier))
}
