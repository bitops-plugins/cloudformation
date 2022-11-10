# Bitops Plugin for Cloudformation

## Table of contents

1. [Introduction](#Introduction)
2. [Installation](https://github.com/bitops-plugins/cloudformation/blob/main/INSTALL.md)
3. [Deployment](#Deployment)

---


## Introduction
This plugin will let BitOps to automatically deploy ``cloudformation`` templates on AWS platform. 

This plugin also manages ``create-stack`` or ``update-stack`` natively at the plugin level.


## Deployment

``cloudformation`` plugin uses ```bitops.config.yaml``` located in the operations repo when deploying resources using aws cloudformation templates.

### Sample Config
```
cloudformation:
  cli:
    validate-cfn: true
    stack-action: deploy
  options:
    cfn-stack-name: bitops-v2-cfntest
    capabilities: CAPABILITY_NAMED_IAM
    cfn-files:
      template-file: template.yaml
      parameters:
        template-param-flag: true
        template-param-file: parameters.json

```

## CLI and options configuration of cloudformation ``bitops.schema.yaml``

### Cloudformation BitOps Schema

[bitops.schema.yaml](https://github.com/bitops-plugins/cloudformation/blob/main/bitops.schema.yaml)


-------------------
### validate-cfn
* **BitOps Property:** `validate-cfn`
* **Environment Variable:** `BITOPS_CFN_TEMPLATE_VALIDATION`
* **default:** `true`

Calls `aws cloudformation validate-template` 

-------------------
### stack-action
* **BitOps Property:** `stack-action`
* **Environment Variable:** `BITOPS_CFN_STACK_ACTION`
* **default:** `deploy`
* **required:** `"True"`

Controls what cloudformation action to apply on the stack. This config is a required parameter. 

### skip-deploy
* **BitOps Property:** `skip-deploy`
* **Environment Variable:** `CFN_SKIP_DEPLOY`
* **default:** `""`
* **Required:** `false`
* **Description:** If set to true, regardless of the stack-action, deployment actions will be skipped.

-------------------

## Options Configuration

-------------------
### cfn-stack-name
* **BitOps Property:** `cfn-stack-name`
* **Environment Variable:** `BITOPS_CFN_STACK_NAME`
* **default:** `""`
* **required:** `"True"`

Cloudformation stack name. This config is a required parameter.

-------------------
### capabilities
* **BitOps Property:** `capabilities`
* **Environment Variable:** `BITOPS_CFN_CAPABILITY`
* **default:** `""`

Allows you to use CloudFormation nested stacks. Both properties must be set in order to use nested stacks.

-------------------

### s3bucket
* **BitOps Property:** `s3bucket`
* **Environment Variable:** `BITOPS_CFN_TEMPLATE_S3_BUCKET`
* **default:** `""`

### s3prefix
* **BitOps Property:** `s3prefix`
* **Environment Variable:** `BITOPS_CFN_S3_PREFIX`
* **default:** `""`

<!-- ### cfn-merge-parameters
* **BitOps Property:** `cfn-merge-parameters` -->

Cloudformation capabilities

-------------------
### cfn-files
* **BitOps Property:** `cfn-files`

Allows for param files to be used. Has the following child-properties

#### template-file
* **BitOps Property:** `cfn-files.template-file`
* **Environment Variable:** `BITOPS_CFN_TEMPLATE_FILENAME`
* **required:** `"True"`

Template file to apply the params against. This config is a required parameter.

#### parameters
* **BitOps Property:** `cfn-files.parameters`

Additional parameters.
###### enabled
* **BitOps Property:** `cfn-files.parameters.template-param-flag`
* **Environment Variable:** `BITOPS_CFN_PARAMS_FLAG`
* **default:** `true`
###### template-param-file
* **BitOps Property:** `cfn-files.parameters.template-param-file`
* **Environment Variable:** `BITOPS_CFN_TEMPLATE_PARAMS_FILENAME`
* **default:** `""`

-------------------
<!-- ### cfn-merge-parameters
* **BitOps Property:** `cfn-merge-parameters`

Allows for param files to be used. Has the following child-properties
#### enabled
* **BitOps Property:** `cfn-files.enabled`
* **Environment Variable:** `CFN_MERGE_PARAMETER`
* **default:** `false`

True if optional option should be used.
#### directory
* **BitOps Property:** `cfn-files.directory`
* **Environment Variable:** `CFN_MERGE_DIRECTORY`
* **default:** `parameters`

The directory within the ansible workspace that contains json files that will be merged. -->

-------------------

## Additional Environment Variable Configuration
Although not captured in `bitops.config.yml`, the following environment variables can be set to further customize behaviour

-------------------
### CFN_SKIP_DEPLOY
Will skill all cloudformation executions. This superseeds all other configuration