import gauth/user/creation/simple
import gleam/int
import gleam/list
import gleeunit/should

const amount_of_users = 16_000

fn generate_names() -> List(String) {
  list.range(0, amount_of_users)
  |> list.map(fn(id) { "user " <> int.to_string(id) })
}

pub fn creation_integrity() {
  let service = simple.new()
  service
  |> should.equal(simple.new())
  service.errorware |> list.length |> should.equal(0)
  service.finalware |> list.length |> should.equal(0)
  service.middleware |> list.length |> should.equal(0)
}

pub fn id_zero_test() {
  generate_names()
  |> list.map(fn(name) { simple.new().create_user(name).id })
  |> list.each(should.equal(_, 0))
}

pub fn name_test() {
  let names = generate_names()
  names
  |> list.map(fn(name) { simple.new().create_user(name).name })
  |> list.map2(names, fn(user, name) { user |> should.equal(name) })
}
