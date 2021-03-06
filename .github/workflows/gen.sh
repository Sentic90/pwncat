#!/usr/bin/env bash

set -e
set -u
set -o pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

TPL_NAME="template-test.tpl"
TPL_PATH="${SCRIPT_PATH}/${TPL_NAME}"
FLW_PATH="${SCRIPT_PATH}"


###
### Build Matrix
###
PYTHON_VERSIONS=("2.7" "3.6" "3.7" "3.8")
OPERATING_SYSTEMS=("ubuntu" "windows" "macos")


for os in ${!OPERATING_SYSTEMS[*]}; do
	for v in ${!PYTHON_VERSIONS[*]}; do
		out_file="${FLW_PATH}/test-${OPERATING_SYSTEMS[${os}]//ubuntu/linux}-${PYTHON_VERSIONS[${v}]}.yml"
		flw_name="${OPERATING_SYSTEMS[${os}]:0:3}-${PYTHON_VERSIONS[${v}]}"
		job_name="[${OPERATING_SYSTEMS[${os}]:0:3}] ${PYTHON_VERSIONS[${v}]}"
		os_name="${OPERATING_SYSTEMS[${os}]}-latest"
		python="${PYTHON_VERSIONS[${v}]}"

		flw_name="${flw_name//ubu/lin}"
		job_name="${job_name//ubu/lin}"

		printf "%s\\n" "-----------------------------------------------------------"
		printf "file:      %s\\n" "${out_file}"
		printf "flw name:  %s\\n" "${flw_name}"
		printf "job name:  %s\\n" "${job_name}"
		printf "OS:        %s\\n" "${os_name}"
		printf "Python:    %s\\n" "${python}"

		cat "${TPL_PATH}" \
			| sed "s/__WORKFLOW_NAME__/${flw_name}/g" \
			| sed "s/__OS__/${os_name}/g" \
			| sed "s/__PYTHON_VERSION__/${python}/g" \
			| sed "s/__JOB_NAME__/${job_name}/g" \
			> "${out_file}"
	done
done
