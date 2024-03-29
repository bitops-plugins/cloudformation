#!/bin/bash
#set -e
set -x

echo ""
echo "Welcome to the CloudFormation BitOps plugin!"

# cloudformation vars
# export CLOUDFORMATION_ROOT="$ENVROOT/cloudformation" 
# export CLOUDFORMATION_BITOPS_CONFIG="$CLOUDFORMATION_ROOT/bitops.config.yaml" 
# export BITOPS_SCHEMA_ENV_FILE="$CLOUDFORMATION_ROOT/ENV_FILE"
# export BITOPS_CONFIG_SCHEMA="$PLUGINS_DIR/cloudformation/bitops.schema.yaml"
export PLUGINS_ROOT_DIR="$BITOPS_PLUGINS_DIR"
export CLOUDFORMATION_ROOT_SCRIPTS="$BITOPS_INSTALLED_PLUGIN_DIR"
export CLOUDFORMATION_ROOT_OPERATIONS="$BITOPS_OPSREPO_ENVIRONMENT_DIR"
export CFN_STACK_NAME="$BITOPS_CFN_STACK_NAME"
export CFN_TEMPLATE_FILENAME="$BITOPS_CFN_TEMPLATE_FILENAME"
export CFN_TEMPLATE_PARAMS_FILENAME="$BITOPS_CFN_TEMPLATE_PARAMS_FILENAME"
export CFN_TEMPLATE_VALIDATION="$BITOPS_CFN_TEMPLATE_VALIDATION"
export CFN_STACK_ACTION="$BITOPS_CFN_STACK_ACTION"
export CFN_PARAMS_FLAG="$BITOPS_CFN_PARAMS_FLAG"
export CFN_CAPABILITY="$BITOPS_CFN_CAPABILITY"

export CLOUDFORMATION_BITOPS_CONFIG="$CLOUDFORMATION_ROOT_OPERATIONS/bitops.config.yaml" 
export BITOPS_SCHEMA_ENV_FILE="$CLOUDFORMATION_ROOT_OPERATIONS/ENV_FILE"
export BITOPS_CONFIG_SCHEMA="$CLOUDFORMATION_ROOT_SCRIPTS/bitops.schema.yaml"

export SCRIPTS_DIR="$CLOUDFORMATION_ROOT_SCRIPTS/scripts"

if [ "$CFN_SKIP_DEPLOY" == "true" ]; then
  echo "CFN_SKIP_DEPLOY is set.  Skipping."
  exit 0
fi

if [ ! -d "$CLOUDFORMATION_ROOT_OPERATIONS" ]; then
  echo "No cloudformation directory.  Skipping."
  exit 0
else
  printf "Deploying cloudformation... ${NC}"
fi


if [ -f "$CLOUDFORMATION_BITOPS_CONFIG" ]; then
  echo "cloudformation - Found BitOps config"
else
  echo "cloudformation - No BitOps config"
fi

# Check for dependent aws plugin
if [ ! -d $PLUGINS_ROOT_DIR/aws ]; then
    echo "aws plugin is missing..."
    exit 1
else
    # Check for dependent kubectl plugin
    if [ ! -d $PLUGINS_ROOT_DIR/kubectl ]; then
    echo "kubectl plugin is missing..."
    exit 1
    else
    echo "All dependent plugins found. Continuing with deployment.."
    fi
fi

aws sts get-caller-identity
result=$?
if [ $result != 0 ]; then
    echo "AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY required for AWS authentication are not set or invalid."
    echo "Check out BitOps documentation to understand what you're missing https://bitops.sh/examples/#docker-run-examples"
    exit $result
fi


# Check for Before Deploy Scripts
# bash $SCRIPTS_DIR/deploy/before-deploy.sh "$CLOUDFORMATION_ROOT_OPERATIONS"

#export BITOPS_CONFIG_COMMAND="$(ENV_FILE="$BITOPS_SCHEMA_ENV_FILE" DEBUG="" bash $SCRIPTS_DIR/bitops-config/convert-schema.sh $BITOPS_CONFIG_SCHEMA $CLOUDFORMATION_BITOPS_CONFIG)"
#echo "BITOPS_CONFIG_COMMAND: $BITOPS_CONFIG_COMMAND"
#echo "BITOPS_SCHEMA_ENV_FILE: $(cat $BITOPS_SCHEMA_ENV_FILE)"
#source "$BITOPS_SCHEMA_ENV_FILE"

# # Exit if Stack Name not found
# if [[ "${CFN_STACK_NAME=}" == "" ]] || [[ "${CFN_STACK_NAME=}" == "''" ]] || [[ "${CFN_STACK_NAME=}" == "None" ]]; then
#   echo "{\"error\":\"$CFN_STACK_NAME CFN_STACK_NAME config is required in bitops config.Exiting...\"}"
#   exit 1
# fi

# # Exit if CFN Template Filename is not found
# if [[ "${CFN_TEMPLATE_FILENAME==}" == "" ]] || [[ "${CFN_TEMPLATE_FILENAME==}" == "''" ]] || [[ "${CFN_TEMPLATE_FILENAME==}" == "None" ]]; then
#   echo "{\"error\":\"$CFN_TEMPLATE_FILENAME CFN_TEMPLATE_FILENAME config is required in bitops config.Exiting...\"}"
#   exit 1
# fi

# # Exit if CFN Template Parameters Filename is not found
# if [[ "${CFN_PARAMS_FLAG}" == "True" ]] || [[ "${CFN_PARAMS_FLAG}" == "true" ]]; then
#   if [[ "${CFN_TEMPLATE_PARAMS_FILENAME}" == "" ]] || [[ "${CFN_TEMPLATE_PARAMS_FILENAME}" == "''" ]] || [[ "${CFN_TEMPLATE_PARAMS_FILENAME}" == "None" ]]; then
#     echo "{\"error\":\"$CFN_TEMPLATE_PARAMS_FILENAME CFN_TEMPLATE_PARAMS_FILENAME config is required in bitops config.Exiting...\"}"
#     exit 1
#   fi
# fi

echo "cd cloudformation Root: $CLOUDFORMATION_ROOT_OPERATIONS"
cd $CLOUDFORMATION_ROOT_OPERATIONS

# cloud provider auth
# Disabling this as this functionality will be in aws plugins
# echo "cloudformation auth cloud provider"
# bash $SCRIPTS_DIR/aws/sts.get-caller-identity.sh

# always run cfn template validation first
if [[ "${CFN_TEMPLATE_VALIDATION}" == "true" ]] || [[ "${CFN_TEMPLATE_VALIDATION}" == "True" ]]; then
  echo "Running Cloudformation Template Validation"
  bash $CLOUDFORMATION_ROOT_SCRIPTS/scripts/cloudformation_validate.sh "$CFN_TEMPLATE_FILENAME"
fi

if [[ "${CFN_STACK_ACTION}" == "deploy" ]] || [[ "${CFN_STACK_ACTION}" == "Deploy" ]]; then
  echo "Running Cloudformation Deploy Stack"
  bash $CLOUDFORMATION_ROOT_SCRIPTS/scripts/cloudformation_deploy.sh "$CFN_TEMPLATE_FILENAME" "$CFN_PARAMS_FLAG" "$CFN_TEMPLATE_PARAMS_FILENAME" "$CFN_STACK_NAME" "$CFN_CAPABILITY" "$CFN_TEMPLATE_S3_BUCKET" "$CFN_S3_PREFIX"
fi

if [[ "${CFN_STACK_ACTION}" == "delete" ]] || [[ "${CFN_STACK_ACTION}" == "Delete" ]]; then
  echo "Running Cloudformation Delete Stack"
  bash $CLOUDFORMATION_ROOT_SCRIPTS/scripts/cloudformation_delete.sh "$CFN_STACK_NAME"
fi

# Check for After Deploy Scripts
# bash $SCRIPTS_DIR/deploy/after-deploy.sh "$CLOUDFORMATION_ROOT_OPERATIONS"
