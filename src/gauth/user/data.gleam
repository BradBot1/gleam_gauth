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
import gleam/option.{type Option}

/// An error relating the the procurment of user data
pub type UserDataError(identifier) {
  /// The user has no relevent data
  NoSuchData(id: identifier)
  /// A generic error such as the data source being unreachable
  Generic(id: identifier, message: String)
}

/// A source to collect data for a user
pub type UserDataSource(identifier, data_store) {
  UserDataSource(
    get_data: fn(identifier) -> Result(data_store, UserDataError(identifier)),
  )
}

/// A source to get a user by their ID
pub type UserDataService(identifier) {
  UserDataService(get_user: fn(identifier) -> Option(User(identifier)))
}

/// A stub method that just unwraps the user's ID and then forwards it to the data store
pub fn get_data(
  user: User(identifier),
  data_source: UserDataSource(identifier, data_store),
) -> Result(data_store, UserDataError(identifier)) {
  user.id |> data_source.get_data()
}
