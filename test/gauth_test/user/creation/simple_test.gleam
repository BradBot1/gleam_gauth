import gauth/user/creation/simple
import gauth_test/user/common
import gleam/list
import gleeunit/should

pub fn creation_integrity() {
  let service = simple.new()
  service
  |> should.equal(simple.new())
  service.errorware |> list.length |> should.equal(0)
  service.finalware |> list.length |> should.equal(0)
  service.middleware |> list.length |> should.equal(0)
}

pub fn id_zero_test() {
  common.generate_names()
  |> list.map(fn(name) { simple.new().create_user(name).id })
  |> list.each(should.equal(_, 0))
}

pub fn name_test() {
  let names = common.generate_names()
  names
  |> list.map(fn(name) { simple.new().create_user(name).name })
  |> list.map2(names, fn(user, name) { user |> should.equal(name) })
}
