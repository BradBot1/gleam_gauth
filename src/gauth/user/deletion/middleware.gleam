import gauth/user/deletion.{type UserDeletionError, Generic}

pub fn disabled(
  _user: identifier,
) -> Result(identifier, UserDeletionError(identifier)) {
  Error(Generic("Deletion of users is disabled"))
}
