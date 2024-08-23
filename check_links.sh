#!/usr/bin/env bash

#First step : Retrieving all the links in a markdown documents

teardown(){
	if [ "$1" != "" ]; then echo "$1"; fi
	kill -INT $$
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
	declare -i i=0;

	if [ "$document" = "" ]; then  teardown "Please provide an input document"; fi
	if ! tmp_file="$(mktemp /tmp/check-links-script.XXXXXXXXXX)" ; then teardown "Couldn't create tmp file" ; fi
	grep -E '\[.+\]\(.+\)' -n -o "${document}"  > "${tmp_file}";
	while IFS='\n' read -r link;
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
	A variable `http_return_code' should be declared in the enclosing scopr in 
	order for the return code to be registered. The return code will be returned 
	as a string
CHECK_LINK
check_link(){
	declare link="$1";

	if ! parse_link "${link}";
	then
		echo "\`${link}' is not a valid http url." >&2;
		return;
	fi
	if ! http_return_code="$(curl -fsSL  "${link}" -w '\n%{response_code}' | tail -n 1)";
	then return 1; else return 0; fi
}

main(){
	declare -a links;

	get_links "$1";
	echo "${links[@]}";
}

main "$1"
