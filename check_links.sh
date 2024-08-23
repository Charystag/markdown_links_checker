#!/usr/bin/env bash

#First step : Retrieving all the links in a markdown documents

teardown(){
	if [ "$1" != "" ]; then echo "$1"; fi
	kill -INT $$
}

declare -a links

:<<-GET_LINKS
	Function to retrieve all the links in a markdown document.
	The function retrieves the links 
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

get_links "$1"
echo "${links[@]}"
