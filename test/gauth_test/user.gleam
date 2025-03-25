import gauth/user.{User, null_user_factory, simple_user_factory}
import gleam/option.{None, Some}
import gleeunit/should

pub fn null_factory_none_test() {
  null_user_factory().create(None, "demo")
  |> should.be_ok
  |> should.equal(User(id: 0, name: "None"))
}

pub fn null_factory_some_test() {
  null_user_factory().create(Some(1234), "testing")
  |> should.be_ok
  |> should.equal(User(id: 0, name: "None"))
}

pub fn simple_factory_none_test() {
  simple_user_factory().create(None, "funky123")
  |> should.be_error
}

pub fn simple_factory_some_test() {
  simple_user_factory().create(Some(1), "cool_user_name")
  |> should.be_ok
  |> should.equal(User(id: 1, name: "cool_user_name"))
}
