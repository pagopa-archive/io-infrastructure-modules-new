azurerm_container_group
============================

Manages as an Azure Container Group instance.

Module Input Variables
----------------------

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map | `<map>` | no |
| resource_group_name | The resource group where instantiate the container | string | `` | yes |
| storage_account_name | The storage account name | string | `` | yes |
| access_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot | string | `Hot` | no |
| account_kind | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | string | `Storage` | no |
| account_replication_type | Defines the type of replication to use for this storage account. | string | ``| yes |
| storage_share_name | The storage share name used to mount volume  | string |`` | yes |
| container_object | An object type that contains information about container | object | ``| yes |
| volumes |  Volume information used for mount a share on the container | list(object) |`` | no |
| workspace_id | The log analytics workspace id | string | ``| no |
| workspace_key | The log analytics primary key | string |`` | no |
| log_type |The log type which should be used. Possible values are ContainerInsights and ContainerInstanceLogs  | string | `` | no |
| ip_address_type | Specifies the ip address type of the container. Public or Private. | string | `` | no |
| dns_name_label |The DNS label/name for the container groups IP.  | string | `` | no |
| os_type | The OS for the container group. | string | `` | yes |

Usage
-----

```hcl
module "aci" {

    source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_container_group"

    name                = "spidtestenv"

    storage_account_name     = "spidtestenv"
    access_tier              = "Hot"
    account_tier             = "Standard"
    account_kind             = "StorageV2"
    account_replication_type = "LRS"
    resource_group_name      = dependency.resource_group.outputs.resource_name

    storage_share_name = "spidtestenv"

    // Container Group
    container_object = {
        name     = "spidtestenv"
        image    = "italia/spid-testenv2:latest"
        cpu      = "1"
        memory   = "1.5"
        port     = 80
        protocol = "TCP"
        commands = ["python", "spid-testenv.py", "-c", "/app/conf/config.yml"]
    }

    volume_enabled = true

    volumes = [{
        name                 = "spidtestenv"
        mount_path           = "/app/conf/"
        read_only            = false
    }]

    diagnostics_enabled = true
    workspace_id        = dependency.log_analytics_workspace.outputs.workspace_id
    workspace_key       = dependency.log_analytics_workspace.outputs.primary_shared_key
    log_type            = ["ContainerInsights"]
}
```

Outputs
======

| Name | Description |
|------|-------------|
| id |  The ID of the Container Group.|
| ip_address | The IP address allocated to the container group.|
| fqdn | The FQDN of the container group derived from dns_name_label. |
