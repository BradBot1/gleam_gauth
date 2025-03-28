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
import gauth/user/data
import gauth/user/deletion

/// A simple struct for the creation, deletion, and data fetching of users.
/// Shouldn't be depended upon unless you need all three, prefer requiring single components as paramters
pub type Auth(indentifier) {
  Auth(
    creation: creation.UserCreationService(indentifier),
    deletion: deletion.UserDeletionService(indentifier),
    data: data.UserDataService(indentifier),
  )
}
