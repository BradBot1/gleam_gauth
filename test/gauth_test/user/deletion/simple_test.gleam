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
import gauth/user/deletion/simple
import gauth_test/user/common
import gleam/list
import gleeunit/should

pub fn creation_integrity() {
  let service = simple.new()
  service
  |> should.equal(simple.new())
  service.errorware |> list.length |> should.equal(0)
  service.middleware |> list.length |> should.equal(0)
}

pub fn always_error_test() {
  list.range(0, common.amount_of_iterations)
  |> list.map(fn(id) { simple.new().delete_user(id) })
  |> list.map(should.be_error)
}
