package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	terraform "github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestHelloWorldAppExample(t *testing.T) {
	mockAddress := "Mock test"
	mockPort := "12345"

	opts := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"mysql_config": map[string]interface{}{
				"address": mockAddress,
				"port":    mockPort,
			},
		},
	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)

	// Init and apply
	terraform.InitAndApply(t, opts)

	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	expectedStatus := 200
	expectedBody := fmt.Sprintf("<h1>\"Hello World! Testing module\"</h1>\n<p>Database address: %s </p>\n<p>Database port: %s </p>", mockAddress, mockPort)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

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
