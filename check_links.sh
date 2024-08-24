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

:<<-"COLOR_PRINT"
	Function to print the strings provided as input in the 
	required color.
	This function is not meant to be used directly. Prefer 
	using report_correct and report_error
	usage: color_print COLOR string1..stringN
COLOR_PRINT
color_print(){
	printf "%s" "$1"
	shift 1
	echo -n "$@" 
	printf "%s\n" "${CRESET}"
}

:<<-"REPORT_CORRECT"
	Function to print the strings provided as argument in green 
	to inform the user that everything went right
REPORT_CORRECT
report_correct(){
	color_print "${GRN}" "$@";
}

:<<-"REPORT_ERROR"
	Function to print the strings provided as argument in red to 
	inform the user something went wrong
REPORT_ERROR
report_error(){
	color_print "${RED}" "$@";
}

:<<-GET_LINKS
	Function to retrieve all the links in a markdown document.
	The function retrieves the links an puts them in the links
	array using the following form :
	line_number:[link_text](link_url)
	ex:
	61:[ListView](https://doc.qt.io/qt-6/qml-qtquick-listview.html)
GET_LINKS
get_links(){
	declare document="$1";
	declare tmp_file;
	declare link;

	if [ "$document" = "" ]; then  teardown "Please provide an input document"; fi
	if ! tmp_file="$(mktemp /tmp/check-links-script.XXXXXXXXXX)" ; then teardown "Couldn't create tmp file" ; fi
	grep -E '\[.+\]\(.+\)' -n -o "${document}"  > "${tmp_file}";
	while IFS=$'\n' read -r link;
	do links+=( "${link}" ); done < "${tmp_file}"
	rm "$tmp_file";
	return 0;
}

:<<-"PARSE_LINK"
	The parse link function is meant to check the format of a link. It takes a 
	http url as an argument and returns true if the url is a valid url and false 
	otherwise

	The url checks now if :
	- The link begins with `http://' or `https://'
PARSE_LINK
parse_link(){
	declare link="$1"

	if ! { echo -n "${link}" | grep -E '^http(s)?://' ; };
	then return 1; else return 0; fi
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

	if ! parse_link "${link}";
	then
		echo "\`${link}' is not a valid http url." >&2;
		return;
	fi
	if ! http_response_code="$(curl -fsSL  "${link}" -w '\n%{response_code}' | tail -n 1)";
	then return 1; else return 0; fi
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
	declare -i length

	length="${#links[@]}"
	if [ "${length}" -eq 0 ] ; 
	then echo "No url found" ; return 0 ; fi
	for (( i = 0; i < ${length}; ++i ));
	do echo "${links[$i]}" ; done
}

main(){
	declare -a links;

	get_links "$1";
	check_links;
}

main "$1"
