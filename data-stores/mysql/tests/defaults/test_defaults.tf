terraform {
  required_providers {
    // Experimental: uses built-in providers instead of a dedicated terraform language syntax
    # Because we're currently using a built-in provider as
    # a substitute for dedicated Terraform language syntax
    # for now, test suite modules must always declare a
    # dependency on this provider. This provider is only
    # available when running tests, so you shouldn't use it
    # in non-test modules.
    test = {
      source = "terraform.io/builtin/test"
    }
    # This example also uses the "http" data source to
    # verify the behavior of the hypothetical running
    # service, so we should declare that too.
    http = {
      source = "hashicorp/http"
    }
  }
}

module "main" {
  # source is always ../.. for test suite configurations,
  # because they are placed two subdirectories deep under
  # the main module directory.
  source = "../.."
  db_name = "example_database"
  db_password_secrets_id = "mysql-master-password-stage"

  # This test suite is aiming to test the "defaults" for
  # this module, so it doesn't set any input variables
  # and just lets their default values be selected instead.
}

# As with all Terraform modules, we can use local values
# to do any necessary post-processing of the results from
# the module in preparation for writing test assertions.
locals {
  
}

resource "test_assertions" "db_admin_username_default" {
  # "component" serves as a unique identifier for this
  # particular set of assertions in the test results.
  component = "db_admin_username_default"

  # equal and check blocks serve as the test assertions.
  # the labels on these blocks are unique identifiers for
  # the assertions, to allow more easily tracking changes
  # in success between runs.
  equal "admin_dev" {
    description = "default admin username is admin_dev"
    got = module.main.admin_username
    want = "admin_dev"
  }
}