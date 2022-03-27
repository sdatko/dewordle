#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

DOWNLOAD_CMD=()  # auto-selected in script
GREP_CMD=(grep --extended-regexp --ignore-case)

WORDS_FILE="${HOME}/.dewordle-words"
WORDS_URL='https://users.cs.duke.edu/~ola/ap/linuxwords'


#
# Display usage
#
# In case of no arguments or any dashed option specified.
#
if [ $# -eq 0 ] || [[ " ${*} " =~ [[:space:]](-.*)[[:space:]] ]]; then
    echo
    echo "Usage: $0 POSITIONS [ALPHABET [LETTERS]]"
    echo
    echo 'POSITIONS -- pattern of letters with positions we are sure'
    echo 'ALPHABET -- set of possible letters to check; default is: a-z'
    echo 'LETTERS -- confirmed letters, with unknown positions; default empty'
    echo
    echo 'NOTE: For POSITION, a regular expression is expected with dots (.)'
    echo '      representing any character; for first run just try: .....'
    echo
    echo 'NOTE: For ALPHABET, a negative set can be given, e.g. ^abc means'
    echo '      that none of letters a, b or c should be part of the string.'
    echo
    exit 1
fi


#
# Input arguments
#
POSITIONS="${1}"
ALPHABET="${2:-a-z}"
LETTERS="${3:-}"


#
# Fetch words file
#
# If specified WORDS_FILE does not exist in file system, download it using
# wget or curl. The file content is filtered for 5-letters long words only
# and with letters additionally converted to lowercase for convenience.
#
if [ ! -f "${WORDS_FILE}" ]; then
    if [ "${#DOWNLOAD_CMD[@]}" -eq 0 ] && ( command -v 'wget' &> /dev/null ); then
        DOWNLOAD_CMD=(wget --quiet --output-document=-)
    fi
    if [ "${#DOWNLOAD_CMD[@]}" -eq 0 ] && ( command -v 'curl' &> /dev/null ); then
        DOWNLOAD_CMD=(curl --silent)
    fi
    if [ "${#DOWNLOAD_CMD[@]}" -eq 0 ]; then
        echo 'ERROR: Could not find wget or curl.'
        echo 'Please install one of these before proceeding.'
        exit 2
    fi

    "${DOWNLOAD_CMD[@]}" "${WORDS_URL}" \
        | grep -E '^.....$' \
        | tr '[:upper:]' '[:lower:]' \
        | sort --unique \
        > "${WORDS_FILE}"
fi


#
# Helper function for filtering strings with specified letters
#
# Recursively extracts letter by letter from a given string argument, then
# selects from standard input only the lines that contain the extracted letter.
# When no more letters, finishes with displaying the remaining standard input.
#
function filter_for_letters() {
    letters="${1}"
    n="${#letters}"

    if [ "${n}" -eq 0 ]; then
        cat
    else
        n=$(( n - 1 ))
        letter="${1:0:1}"
        remaining="${1:1:${n}}"

        "${GREP_CMD[@]}" "${letter}" | filter_for_letters "${remaining}"
    fi
}


#
# Find matching words
#
"${GREP_CMD[@]}" "^[${ALPHABET}]{5}$" "${WORDS_FILE}" \
    | "${GREP_CMD[@]}" "${POSITIONS}" \
    | filter_for_letters "${LETTERS}"
