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
import gleam/int
import gleam/list

pub const amount_of_iterations = 16_000

fn with_helper_sub(
  service: service,
  action: fn(service, Int) -> service,
  counter: Int,
) {
  case counter {
    c if counter >= amount_of_iterations -> action(service, c)
    _ -> with_helper_sub(action(service, counter), action, counter + 1)
  }
}

pub fn with_helper(service: service, action: fn(service, Int) -> service) {
  with_helper_sub(service, action, 1)
}

pub fn generate_names() -> List(String) {
  list.range(0, amount_of_iterations)
  |> list.map(fn(id) { "user " <> int.to_string(id) })
}
