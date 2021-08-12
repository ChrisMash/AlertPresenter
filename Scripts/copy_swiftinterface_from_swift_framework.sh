#
# https://github.com/ChrisMash/PublicAPIMonitoringExample
#
# Copies the specified .swiftinterface file from the specified Swift framework and places it in
# the specified directory with the filename <FRAMEWORK_NAME>_swift_api.txt
#
# Parameters:
# - The name of the framework file (with extension)
# - The path to the framework file
# - The architecture to copy the .swiftinterface of
# - The directory to output the file to
#
# Example: bash copy_swiftinterface_from_swift_framework.sh Swift_Framework.framework ./ arm64 ./api
#

set -x

STARTTIME=$(date +%s)

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${SCRIPT_PATH}/shared.sh"

FRAMEWORK_NAME_WEXT=$1
FRAMEWORK_DIR=$2
INTERFACE=$3
OUTPUT_DIR=$4

# Strip off the extension to get the framework name
FRAMEWORK_NAME="${FRAMEWORK_NAME_WEXT%.*}"
# Generate the path to the .swiftinteface
MODULES_PATH=$(findFirstFrameworkFolder "Modules" "${FRAMEWORK_DIR}/${FRAMEWORK_NAME_WEXT}")
SOURCE_PATH="${MODULES_PATH}/${FRAMEWORK_NAME}.swiftmodule/${INTERFACE}.swiftinterface"

# Copy the .swiftinterface to the output directory
cp $SOURCE_PATH "${OUTPUT_DIR}/${FRAMEWORK_NAME}_swift_api.txt"

ENDTIME=$(date +%s)
echo "Executed in ~$(($ENDTIME - $STARTTIME))s"
