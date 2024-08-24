#!/usr/bin/env bash

export RED="\e[0;31m"
export GRN="\e[0;32m"
export CRESET="\e[0m"

:<<-"TEARDOWN"
	The teardown function is there to cleanly exit the script 
	if some unexpected event occurs. For now it only prints a 
	predefined message but if more cleanup is needed the whole 
	code won't have to be updated
TEARDOWN
teardown(){
	if [ "$1" != "" ]; then echo "$1"; fi
	kill -INT $$
}


:<<-"USAGE"
	Prints usage string and exits
USAGE
usage(){
	usage_string="usage: run_tests test_file"

	teardown "$usage_string"
}

:<<-"COLOR_PRINT"
	Function to print the strings provided as input in the 
	required color.
	This function is not meant to be used directly. Prefer 
	using report_success and report_error
	usage: color_print COLOR string1..stringN
COLOR_PRINT
color_print(){
	printf "%b" "$1"
	shift 1
	echo -n "$@" 
	printf "%b\n" "${CRESET}"
}

:<<-"REPORT_SUCCESS"
	Function to print the strings provided as argument in green 
	to inform the user that everything went right
REPORT_SUCCESS
report_success(){
	color_print "${GRN}" "$@";
}

:<<-"REPORT_ERROR"
	Function to print the strings provided as argument in red to 
	inform the user something went wrong. This function prints 
	to stderr
REPORT_ERROR
report_error(){
	color_print "${RED}" "$@" >&2;
}

:<<-"RUN_TEST"
	Run a given test. The procedure is the following
	1.	Run the script on the first argument and put the output in a temporary file
# To run the script, the eval function will be run on the string provided as an argument
# This allows to pass options to the script without modifying the logic
	2.	Compare the output with the expected output
	The function has to update the failed_tests and the total_tests variables
	usage: run_test test_to_run expected_output
RUN_TEST
run_test(){
	declare tmp_file;

	if [ "$2" = "" ] ; then echo "usage: run_test file_to_test expected_output" ; fi
	if ! tmp_file="$(mktemp /tmp/test_markdown_links_checker.XXXXXXXX)";
	then teardown "Couldn't open temporary file"; fi
	(( "++total_tests" ));
	if ! eval "$1" > "${tmp_file}" 2>&1; then (( "++failed_tests" )); return 1; fi
	if ! diff "${tmp_file}" "$2" >> "${logfile}" 2>&1; then (( "++failed_tests" )); return 1;fi
	return 0;
}

:<<-"RUN_TESTS"
	Run all tests in a provided test file. If the test wants to provide options to the script 
	it also has to specify those options.
	The test and the exoected_output file should be separated using a tab character.
	Ex :
```
-i ignored markdown_input/test_case_1.md \t expected_outputs/test_case_1.txt
markdown_input/test_case_2.md \t expected_output/test_case_2.txt
```
RUN_TESTS
run_tests(){
	declare	tests="$1";
	# shellcheck disable=SC2034
	declare test_comand;
	declare	expected_output;
	declare base_command="bash ../check_links.sh";
	declare line;

	while read -r -u 3 line;
	do
		test_command="$(echo "${line}" | cut -f 1)";
		expected_output="$(echo "${line}" | cut -f 2)";
		if ! run_test "${base_command} ${test_command}" "${expected_output}";
		then report_error "Test : \`${test_command}' failed";
		else report_success "Test : \`${test_command}' succeeded";
		fi;
	done 3<"${tests}";
}

main(){
	declare -i total_tests=0;
	declare -i failed_tests=0;
	declare logfile="/dev/null";

	if [ "$1" = "" ] ; then usage; fi
	run_tests "$1";
	if [ "${failed_tests}" -gt "0" ];
	then report_error "failed_tests: ${failed_tests}/${total_tests}" ; return 1;fi
	report_success "passed_tests: ${total_tests}/${total_tests}";
	return 0;
}

main "$@"
