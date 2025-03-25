import gauth/user
import gauth/user/creation

fn create_user(name: String) -> user.User(Int) {
  user.User(id: 0, name: name)
}

pub fn new() -> creation.UserCreationService(Int) {
  create_user |> creation.UserCreationService([], [], [])
}
