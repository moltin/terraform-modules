# TODO

- Split Security Groups rules to avoid inline security groups
- Apply `Terrafile` to pull modules as dependencies on a `vendor` folder, it will be ideal if this it's done on Go as Terraform was write on Go e.g. http://bensnape.com/2016/01/14/terraform-design-patterns-the-terrafile/
- Auto-generate ToC on README.md file
- Add option to control `lifecycle` or the resources by variables
- Support variable to optionally `lifecycle { ignore_changes = [ "user_data" ] }` so the instance won't be destroy if `user_data` have change
- Accept different values for `ignore_changes`
