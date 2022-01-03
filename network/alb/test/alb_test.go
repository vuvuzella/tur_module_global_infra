package test

import (
  "fmt"
  "testing"
  "time"
  http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAlbExample(t *testing.T) {

  opts := &terraform.Options {
    TerraformDir: "../example",
  }

  // Ensure cleanup even if errors come up
  defer terraform.Destroy(t, opts)

  // Deploy example
  terraform.InitAndApply(t, opts)

  // Get the URL of the ALB
  albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
  url := fmt.Sprintf("http://%s", albDnsName)

  // Test that the ALB's default action is working and returns a 404
  expectedStatus := 404
  expectedBody := "404: page not found"

  // http_helper.HttpGetWithValidation(t, url, expectedStatus, expectedBody)

  // For eventually consistent behavior handling, add retries and timeouts
  maxRetries := 10
  timeBetweenRetries := 10 * time.Second

  // from https://terratest.gruntwork.io/docs/getting-started/quick-start/
  http_helper.HttpGetWithRetry(
	t,
	url,
	nil,
	expectedStatus,
	expectedBody,
	maxRetries,
	timeBetweenRetries,

  )

}
