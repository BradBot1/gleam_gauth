import gauth/user/deletion

fn delete_user(
  _name: identifier,
) -> Result(Nil, deletion.UserDeletionError(identifier)) {
  Error(deletion.Generic(
    "SimpleUserDeletionService cannot delete users, please use an alternative if this functionality is needed",
  ))
}

pub fn new() -> deletion.UserDeletionService(identifier) {
  delete_user |> deletion.UserDeletionService([], [])
}
