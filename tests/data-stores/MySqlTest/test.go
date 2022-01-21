package MySqlTest

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMySql(t *testing.T) {

	t.Parallel()

	dbName := fmt.Sprintf("TestDbMysql%s", random.UniqueId())
	dbAdminUsername := fmt.Sprintf("testAdminUsername%s", random.UniqueId())

	opts := &terraform.Options{
		TerraformDir: "../examples/data-stores/mysql",
		Vars: map[string]interface{}{
			"db_name":           dbName,
			"db_admin_username": dbAdminUsername,
		},
	}

	defer terraform.Destroy(t, opts)

	terraform.InitAndApply(t, opts)

	infraDbName := terraform.OutputRequired(t, opts, "db_admin_username")

	assert.Equal(t, dbAdminUsername, infraDbName)
}
