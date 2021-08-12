#
# https://github.com/ChrisMash/PublicAPIMonitoringExample
#
# Generates the ObjC API from the specified Swift framework and places it in the specified directory
# with the filename <FRAMEWORK_NAME>_objc_api.txt
#
# NOTE: Should be run with bash rather than sh due to usage of echo -e.
#
# Parameters:
# - The name of the framework file (with extension)
# - The path to the framework file
# - The directory to output the file to
#
# Example: bash gen_objc_api_from_swift_framework.sh Swift_Framework.framework ./ ./api
#

STARTTIME=$(date +%s)

SCRIPT_PATH="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
source "${SCRIPT_PATH}/shared.sh"

FRAMEWORK_NAME_WEXT=$1
FRAMEWORK_DIR=$2
OUTPUT_DIR=$3

# Strip off the extension to get the framework name
FRAMEWORK_NAME="${FRAMEWORK_NAME_WEXT%.*}"
# Generate the path to the Swift framework header
HEADERS_PATH=$(findFirstFrameworkFolder "Headers" "${FRAMEWORK_DIR}/${FRAMEWORK_NAME_WEXT}")
SWIFT_HEADER_PATH="${HEADERS_PATH}/${FRAMEWORK_NAME}-Swift.h"
# Read in the -Swift.h file
SWIFT_HEADER=$(cat ${SWIFT_HEADER_PATH})

API=""

# Go through the -Swift.h file contents. Add relevant lines to $API
while IFS= read -r line; do
    # Trim any whitespace
    TRIMMED_LINE=$(echo "${line}" | tr -d '[:space:]')
    # If it's length is greater than 0
    if [ ${#TRIMMED_LINE} -gt 0 ]; then
        # If it doesn't start with # (e.g. all the rubbish at the top of the file)
        if [[ $TRIMMED_LINE != \#* ]]; then
            # If it doesn't start with @import or @class
            if [[ $TRIMMED_LINE != @import* && $TRIMMED_LINE != @class* ]]; then
                # If it doesn't start with a typdef
                if [[ $TRIMMED_LINE != typedef* ]]; then
                    # If it's not an API doc (e.g. ///)
                    if [[ $TRIMMED_LINE != \/\/\/* ]]; then
                        # Add it to the API
                        API="${API}\n$line"
#                    else
#                        echo "Skipped comment: $line"
                    fi
#                else
#                    echo "Skipped typedef: $line"
                fi
#            else
#                echo "Skipped @import/@class: $line"
            fi
        fi
    fi
done <<< "$SWIFT_HEADER"

# Output the public API to a file
echo -e "${API}" > "${OUTPUT_DIR}/${FRAMEWORK_NAME}_objc_api.txt"

ENDTIME=$(date +%s)
echo "Executed in ~$(($ENDTIME - $STARTTIME))s"
