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
