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
import gauth/user/deletion

/// Just returns a UserDeletionError with the value of "SimpleUserDeletionService cannot delete users, please use an alternative if this functionality is needed"
fn delete_user(
  _name: identifier,
) -> Result(Nil, deletion.UserDeletionError(identifier)) {
  Error(deletion.Generic(
    "SimpleUserDeletionService cannot delete users, please use an alternative if this functionality is needed",
  ))
}

/// Creates an UserDeletionService that fails on delete_user.
/// Only designed for testing and development.
pub fn new() -> deletion.UserDeletionService(identifier) {
  delete_user |> deletion.UserDeletionService([], [])
}
