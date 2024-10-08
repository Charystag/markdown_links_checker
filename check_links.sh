#!/usr/bin/env bash

export RED="\e[0;31m"
export GRN="\e[0;32m"
export CRESET="\e[0m"

URL_REGEX="https?://((\\\([^[:space:])]*\\\))+|[^[:space:])]+)"
OPTIONS="i:-"
SCRIPT_NAME="markdown-links-checker"

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
	usage_string="usage: ${SCRIPT_NAME} [-i ignored_files] [--] files"

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
	exit_status="1"
}

:<<-"CHECK_EXTENSION"
	Function to check that the input file is indeed a markdown file
CHECK_EXTENSION
check_extension(){
	declare	ext;

	if [ "$1" = "" ] ; then return 1 ; fi
	ext="$(echo "$1" | rev | cut -c 1-3 | rev)"
	if [ "${ext}" != ".md" ] ; then return 1 ; fi
	return 0
}

:<<-GET_LINKS
	Function to retrieve all the links in a markdown document.
	The function retrieves the links an puts them in the links
	array using the following form :
	line_number:link_url
	ex:
	61:https://doc.qt.io/qt-6/qml-qtquick-listview.html
GET_LINKS
get_links(){
	declare document="$1";
	declare tmp_file;
	declare link;

	if [ "$document" = "" ]; then  teardown "Please provide an input document"; fi
	if ! tmp_file="$(mktemp /tmp/check-links-script.XXXXXXXXXX)" ; then teardown "Couldn't create tmp file" ; fi
	grep -E "${URL_REGEX}" -n -o "${document}"  > "${tmp_file}";
	while IFS=$'\n' read -r link;
	do links+=( "${link}" ); done < "${tmp_file}"
	rm "$tmp_file";
	return 0;
}

:<<-"CHECK_LINK"
	This function performs a curl request on the link it receives 
	if it is a valid link.
	A variable `http_response_code' should be declared in the enclosing scope in 
	order for the response code to be registered. The return code will be returned 
	as a string
CHECK_LINK
check_link(){
	declare link="$1";

	if [ "$ignored" != "" ] && grep >/dev/null 2>&1 "${link}" "$ignored"; 
	then http_response_code="299"; return 0; fi
	if ! http_response_code="$(curl --connect-timeout 5 -fsL  "${link}" -w '\n%{response_code}' 2>/dev/null | tail -n 1)";
	then return 1; fi
	if [ "${http_response_code:0:1}" != "2" ] ; then return 1 ; fi
	return 0
}

:<<-"CHECK_LINKS"
	This functions uses the array `links' that has been declared 
	in the main function. It iterates over the links array and checks
	whether or not the links is still functionnal. If the link is functionnal,
	it prints it in green alongside its status code. Otherwise, it prints it in 
	red
CHECK_LINKS
check_links(){
	declare http_response_code;
	declare -i length;
	declare	-i i;
	declare url;
	declare line;

	length="${#links[@]}"
	if [ "${length}" -eq 0 ] ; 
	then report_success "No url found" ; return 0 ; fi
	for (( i = 0; i < length; ++i ));
	do 
		(( ++total_links ))
		url="$(echo "${links[$i]}" | grep -E 'http(s)?://.*' -o)";
		line="$(echo "${links[$i]}" | grep -E '^[0-9]+:' -o | rev | cut -c 2- | rev)";
		if ! check_link "${url}" ; 
		then
			report_error "Error on line : \`${line}'. url: \`${url}'. \
response_code: \`${http_response_code}'"; (( ++broken_links ));
		else
			report_success "Line: \`${line}'. url: \`${url}' is valid. \
response_code: \`${http_response_code}'";
		fi
	done
}

:<<-"PARSE_OPTIONS"
	Function to parse the command line options. The options currently are :

	argument required:
		- i: a file that contains a list of urls that are meant to be ignored 
		because they will return false positives. The http_response_code will be
		`299'
	
	no argument required:
		- -: End of options parsing
PARSE_OPTIONS
parse_options(){
	declare optvar;

	while getopts "$OPTIONS" optvar;
	do case "$optvar" in 
		i )
			ignored="$OPTARG";;
		- )
			break ;;
		? )
			usage ;;
	esac;done
}

#See the section "Parameter Expansion" in the bash manual in order to know what the `!' means
#in terms of expansion. Look for the section about indirection
#https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
main(){
	declare -i i;
	declare ignored;
	declare filename;
	declare -i	exit_status=0;
	declare	-i	broken_links=0;
	declare -i	total_links=0;

	parse_options "$@";
	shift $(( OPTIND - 1 ));
	if [ "$1" = "" ];
	then usage;fi
	for (( i=1; i<$# + 1; ++i ));
	do
		declare -a links;
		filename="${!i}";
		printf "%s\n" "Checking file: \`$(basename "${filename}'")";
		if ! check_extension "$filename";
		then report_error "\`${filename}' is not a markdown file";
		else get_links "${filename}"; check_links;
		fi
		unset links;
	done
	if [ "$exit_status" -gt "0" ] ;
	then report_error "broken links: ${broken_links}/${total_links}";
	else report_success "broken links: ${broken_links}/${total_links}";
	fi
	return "${exit_status}"
}

main "$@"
