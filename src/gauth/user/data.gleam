import gauth/user.{type User}
import gleam/option.{type Option}

pub type UserDataError(identifier) {
  NoSuchData(user: user.User(identifier))
  Generic(message: String)
}

pub type UserDataSource(identifier, data_store) {
  UserDataSource(
    get_data: fn(identifier) -> Result(data_store, UserDataError(identifier)),
  )
}

pub type UserDataService(identifier) {
  UserDataService(get_user: fn(identifier) -> Option(User(identifier)))
}

/// A stub method that just unwraps the user's ID and then forwards it to the data store
pub fn get_data(
  user: User(identifier),
  data_source: UserDataSource(identifier, data_store),
) -> Result(data_store, UserDataError(identifier)) {
  user.id |> data_source.get_data()
}
