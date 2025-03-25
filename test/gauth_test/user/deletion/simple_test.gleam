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
