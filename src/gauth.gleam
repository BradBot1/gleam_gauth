import gauth/user/creation
import gauth/user/data
import gauth/user/deletion

pub type Auth(indentifier) {
  Auth(
    creation: creation.UserCreationService(indentifier),
    deletion: deletion.UserDeletionService(indentifier),
    data: data.UserDataService(indentifier),
  )
}
