# GAuth

[![Package Version](https://img.shields.io/hexpm/v/gauth)](https://hex.pm/packages/gauth)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gauth/)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/BradBot1/gleam_gauth/test.yml)
![Hex.pm License](https://img.shields.io/hexpm/l/gauth)


A gleam based authentication base for custom, modular, and portable authentication.

## Why?

### Plug and Play

By building the api around a "plug and play" approach, you can easily swap out the underlying data source and middlewares for ones that meet the current needs of an application. This is something that I find myself constantly wishing for with premade solutions.

### No Unwanted Dependencies

Gauth is based around the idea that you should be able to swap out and modify the entier auth stack without consequence. Due to gleams robust type system any invalid setups will be caught at compile time ensuring that if it compiles it will work. (Assuming that the underlying data source is valid)

### Portable

Your auth stack will be able to run in the beam or a JS runtime, depending upon your implementation needs.

## Examples

### DataSource

```gleam
import gleam/option
import gauth/user/data

pub type EmailData {
  EmailData(primary: String, emails: List(String))
}

// Create a resolver to find the email from an ID
pub fn resolve_email(_id: Int) -> Result(EmailData, data.UserDataError(Int)) {
  Ok(EmailData(primary: "primary@example.com", emails: [
    "primary@example.com",
  ]))
}

pub fn main() {
  let data_service = todo
  let email_source = data.UserDataSource(resolve_email)
  case data_service.get_user(1) {
    option.Some(usr) -> case usr |> data.get_data(email_source) {
        Ok(EmailData(_primary, _emails)) -> todo // Do something with the email
        Error(_) -> panic as "Error"
    }
    option.None -> panic as "No user"
  }
}
```

### CreationService

```gleam
import gauth/user
import gauth/user/creation
import gauth/user/creation/errorware as creation_errorware
import gauth/user/creation/finalware as creation_finalware
import gauth/user/creation/middleware as creation_middleware
import gauth/user/creation/simple as creation_simple

pub fn main() {
  let creation_service =
    creation_simple.new()
    |> creation.with_middleware(creation_middleware.trim_name) // Calls string.trim on all names
    |> creation.with_middleware(creation_middleware.within_length(1, 10)) // Ensures the name is within bounds
    |> creation.with_finalware(creation_finalware.logging) // Logs when a user is created
    |> creation.with_errorware(creation_errorware.logging) // Logs when an error occurs
  case creation.create_user("demo", creation_service) {
    Ok(user) -> todo // Do something with the user
    Error(_) -> todo // Process the error
  }
}
```

### DeletionService

```gleam
import gauth/user/deletion
import gauth/user/deletion/simple as deletion_simple
import gleam/int

pub fn main() {
  let deletion_service =
    deletion_simple.new()
    |> deletion.with_middleware(fn(id) {
      io.println("Deletion of user " <> int.to_string(id) <> " attempted")
      Ok(id)
    })
  case deletion.delete_user(1, deletion_service) {
    Ok(_) -> todo // Continue
    Error(_) -> todo // Handle the user not being deleted
  }
}
```

## Related Projects

> This is WIP.

> Have your own you would like to see here? Open an issue

|Name|Description|License|Link|Badges|
|---|---|---|---|---|