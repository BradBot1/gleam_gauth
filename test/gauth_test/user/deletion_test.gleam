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
import gauth_test/user/common
import gleam/list
import gleeunit/should

fn null() -> deletion.UserDeletionService(Int) {
  deletion.UserDeletionService(fn(_) { Ok(Nil) }, [], [])
}

fn with_helper(
  action: fn(deletion.UserDeletionService(Int), Int) ->
    deletion.UserDeletionService(Int),
) {
  common.with_helper(null(), action)
}

pub fn with_middleware_test() {
  let service =
    with_helper(fn(service, counter) {
      let service = deletion.with_middleware(service, fn(name) { Ok(name) })
      service.middleware
      |> list.length
      |> should.equal(counter)
      service
    })
  service.middleware
  |> list.length
  |> should.equal(common.amount_of_iterations)
  service.errorware
  |> list.length
  |> should.equal(0)
}

pub fn with_errorware_test() {
  let service =
    with_helper(fn(service, counter) {
      let service = deletion.with_errorware(service, fn(error) { error })
      service.errorware
      |> list.length
      |> should.equal(counter)
      service
    })
  service.middleware
  |> list.length
  |> should.equal(0)
  service.errorware
  |> list.length
  |> should.equal(common.amount_of_iterations)
}

pub fn with_all_test() {
  let serivce =
    with_helper(fn(service, counter) {
      let service =
        deletion.with_middleware(service, fn(name) { Ok(name) })
        |> deletion.with_errorware(fn(error) { error })
      service.middleware
      |> list.length
      |> should.equal(counter)
      service.errorware
      |> list.length
      |> should.equal(counter)
      service
    })
  serivce.middleware
  |> list.length
  |> should.equal(common.amount_of_iterations)
  serivce.errorware
  |> list.length
}

pub fn delete_user_none_test() {
  let service = null()
  list.range(0, common.amount_of_iterations)
  |> list.map(fn(name) { deletion.delete_user(name, service) })
  |> list.map(should.be_ok)
}
