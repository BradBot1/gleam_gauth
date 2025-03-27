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
import gauth/user
import gauth/user/data
import gauth_test/user/common
import gleam/list
import gleam/option
import gleeunit/should

fn data_service() -> data.UserDataService(Int) {
  data.UserDataService(fn(id) {
    case id {
      1 -> option.Some(user.User(1, "demo"))
      _ -> option.None
    }
  })
}

fn data_source() -> data.UserDataSource(Int, String) {
  data.UserDataSource(fn(id) {
    case id {
      1 -> Ok("test")
      _ -> Error(data.NoSuchData(id))
    }
  })
}

pub fn get_service_test() {
  let service = data_service()
  list.range(2, common.amount_of_iterations)
  |> list.map(service.get_user)
  |> list.each(should.be_none)
  service.get_user(1)
  |> should.equal(option.Some(user.User(1, "demo")))
}

pub fn get_source_test() {
  let source = data_source()
  list.range(2, common.amount_of_iterations)
  |> list.map(source.get_data)
  |> list.each(should.be_error)
  source.get_data(1)
  |> should.equal(Ok("test"))
}

pub fn get_source_from_service_test() {
  let service = data_service()
  let source = data_source()
  service.get_user(1)
  |> should.be_some
  |> data.get_data(source)
  |> should.be_ok
  |> should.equal("test")
}
