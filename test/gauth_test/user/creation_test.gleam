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
import gauth/user/creation
import gauth_test/user/common
import gleam/list
import gleeunit/should

fn null() -> creation.UserCreationService(Int) {
  creation.UserCreationService(
    fn(name) { user.User(id: 0, name: name) },
    [],
    [],
    [],
  )
}

fn with_helper(
  action: fn(creation.UserCreationService(Int), Int) ->
    creation.UserCreationService(Int),
) {
  common.with_helper(null(), action)
}

pub fn with_middleware_test() {
  let service =
    with_helper(fn(service, counter) {
      let service = creation.with_middleware(service, fn(name) { Ok(name) })
      service.middleware
      |> list.length
      |> should.equal(counter)
      service
    })
  service.middleware
  |> list.length
  |> should.equal(common.amount_of_iterations)
  service.finalware
  |> list.length
  |> should.equal(0)
  service.errorware
  |> list.length
  |> should.equal(0)
}

pub fn with_finalware_test() {
  let serivce =
    with_helper(fn(service, counter) {
      let service = creation.with_finalware(service, fn(user) { user })
      service.finalware
      |> list.length
      |> should.equal(counter)
      service
    })
  serivce.middleware
  |> list.length
  |> should.equal(0)
  serivce.finalware
  |> list.length
  |> should.equal(common.amount_of_iterations)
  serivce.errorware
  |> list.length
  |> should.equal(0)
}

pub fn with_errorware_test() {
  let service =
    with_helper(fn(service, counter) {
      let service = creation.with_errorware(service, fn(error) { error })
      service.errorware
      |> list.length
      |> should.equal(counter)
      service
    })
  service.middleware
  |> list.length
  |> should.equal(0)
  service.finalware
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
        creation.with_middleware(service, fn(name) { Ok(name) })
        |> creation.with_finalware(fn(user) { user })
        |> creation.with_errorware(fn(error) { error })
      service.middleware
      |> list.length
      |> should.equal(counter)
      service.finalware
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
  serivce.finalware
  |> list.length
  |> should.equal(common.amount_of_iterations)
  serivce.errorware
  |> list.length
}

pub fn create_user_none_test() {
  let service = null()
  let names = common.generate_names()
  names
  |> list.map(fn(name) { creation.create_user(name, service) })
  |> list.map(should.be_ok)
  |> list.map2(names, fn(user, name) { user.name |> should.equal(name) })
}

pub fn create_user_middleware_mutate_test() {
  let service =
    null()
    |> creation.with_middleware(fn(name) { Ok(name <> " middleware") })
  let names = common.generate_names()
  names
  |> list.map(fn(name) { creation.create_user(name, service) })
  |> list.map(should.be_ok)
  |> list.map2(
    names |> list.map(fn(name) { name <> " middleware" }),
    fn(user, name) { user.name |> should.equal(name) },
  )
}

pub fn create_user_middleware_mutate_chain_test() {
  let service =
    null()
    |> creation.with_middleware(fn(name) { Ok(name <> " middleware") })
    |> creation.with_middleware(fn(name) { Ok(name <> " other middleware") })
  let names = common.generate_names()
  names
  |> list.map(fn(name) { creation.create_user(name, service) })
  |> list.map(should.be_ok)
  |> list.map2(
    names |> list.map(fn(name) { name <> " other middleware middleware" }),
    fn(user, name) { user.name |> should.equal(name) },
  )
}

pub fn create_user_middleware_fail_test() {
  let service =
    null()
    |> creation.with_middleware(fn(name) {
      Error(creation.InvalidName(name, "reason"))
    })
  let names = common.generate_names()
  names
  |> list.map(fn(name) { creation.create_user(name, service) })
  |> list.map(should.be_error)
  |> list.each(fn(error) {
    case error {
      creation.InvalidName(_, reason) -> reason |> should.equal("reason")
      _ -> should.fail()
    }
  })
}

pub fn create_user_middleware_fail_chain_test() {
  let service =
    null()
    |> creation.with_middleware(fn(_) {
      should.fail()
      Error(creation.Generic("Unreachable case"))
    })
    |> creation.with_middleware(fn(name) {
      Error(creation.InvalidName(name, "reason"))
    })
  let names = common.generate_names()
  names
  |> list.map(fn(name) { creation.create_user(name, service) })
  |> list.map(should.be_error)
  |> list.each(fn(error) {
    case error {
      creation.InvalidName(_, reason) -> reason |> should.equal("reason")
      _ -> should.fail()
    }
  })
}

pub fn create_user_finalware_mutate_test() {
  let serivce =
    null()
    |> creation.with_finalware(fn(user) {
      user.User(user.id, user.name <> " finalware")
    })
  let names = common.generate_names()
  names
  |> list.map(fn(name) { creation.create_user(name, serivce) })
  |> list.map(should.be_ok)
  |> list.map2(
    names |> list.map(fn(name) { name <> " finalware" }),
    fn(user, name) { user.name |> should.equal(name) },
  )
}

pub fn create_user_finalware_mutate_chain_test() {
  let serivce =
    null()
    |> creation.with_finalware(fn(user) {
      user.User(user.id, user.name <> " finalware")
    })
    |> creation.with_finalware(fn(user) {
      user.User(user.id, user.name <> " other finalware")
    })
  let names = common.generate_names()
  names
  |> list.map(fn(name) { creation.create_user(name, serivce) })
  |> list.map(should.be_ok)
  |> list.map2(
    names |> list.map(fn(name) { name <> " other finalware finalware" }),
    fn(user, name) { user.name |> should.equal(name) },
  )
}

pub fn create_user_errorware_test() {
  let serivce =
    null()
    |> creation.with_errorware(fn(_) { creation.Generic("errorware") })
    |> creation.with_middleware(fn(name) {
      Error(creation.InvalidName(name, "Always fail"))
    })
  common.generate_names()
  |> list.map(fn(name) { creation.create_user(name, serivce) })
  |> list.map(should.be_error)
  |> list.each(fn(error) {
    case error {
      creation.Generic(message) -> message |> should.equal("errorware")
      _ -> should.fail()
    }
  })
}

pub fn create_user_errorware_chain_test() {
  let serivce =
    null()
    |> creation.with_errorware(fn(_) { creation.Generic("errorware2") })
    |> creation.with_errorware(fn(_) { creation.Generic("errorware") })
    |> creation.with_middleware(fn(name) {
      Error(creation.InvalidName(name, "Always fail"))
    })
  common.generate_names()
  |> list.map(fn(name) { creation.create_user(name, serivce) })
  |> list.map(should.be_error)
  |> list.each(fn(error) {
    case error {
      creation.Generic(message) -> message |> should.equal("errorware2")
      _ -> should.fail()
    }
  })
}
