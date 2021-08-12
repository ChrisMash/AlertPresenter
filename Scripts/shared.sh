#
# https://github.com/ChrisMash/PublicAPIMonitoringExample
#

#
# Will echo out the first subdirectory found that contains a .framework in it,
# under the specified search path
# Example: findFirstFrameworkSubDirectory "folder1/folder2"
#
findFirstFrameworkSubDirectory() {
    SEARCH_PATH=$1
    for ENTRY in "${SEARCH_PATH}"/*; do
      for SUB_ENTRY in "${ENTRY}"/*; do
        if [[ $SUB_ENTRY == *.framework ]]; then
            echo $SUB_ENTRY
            return 0
        fi
      done
    done
    
    exit 1
}

#
# Will echo out the first subdirectory found that contains a .framework in it,
# with the specified subdirectory, under the specified search path
# Example: findFirstFrameworkFolder "Headers" "folder1/folder2"
#
findFirstFrameworkFolder() {
    DESIRED_SUBDIR=$1
    SEARCH_DIR=$2

    if [[ $SEARCH_DIR == *.xcframework* ]]; then
        # .xcframeworks contain multiple .framework folders, each with a Headers folder
        echo "$(findFirstFrameworkSubDirectory $SEARCH_DIR)/${DESIRED_SUBDIR}"
    elif [[ $SEARCH_DIR == *.framework* ]]; then
        # .frameworks have the Headers folder directly inside
        echo "${SEARCH_DIR}/${DESIRED_SUBDIR}"
    else
        echo "Error: Expected to be looking in a .framework or .xcframework"
        exit 1
    fi
    
    return 0
}
