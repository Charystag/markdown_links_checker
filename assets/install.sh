#!/usr/bin/env bash
if [ "$1" = "" ]; then echo "usage: ./install.sh path/to/login/shell";kill -INT $$; fi
script_dir="${HOME}/.local/bin";
script_name="markdown-links-checker";
script_url="https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links.sh";

update_path(){
	if (echo "$PATH" | grep "${script_dir}" >/dev/null 2>&1 ); then return 0; fi
	if ! { (echo "$1" | grep bash >/dev/null) || (echo "$1" | grep zsh >/dev/null); };
	then echo "Please add the path ${script_dir} manually to your PATH var";fi
	echo 'PATH=$HOME/.local/bin:$PATH' >> "${HOME}/.$(basename "$1")rc";
	echo "\`${script_dir}' added to path." "Please run \`. \$HOME.$(basename "$1")rc when the script exits"
}

if [ -f "${script_dir}/${script_name}" ]; then echo "Script already installed at: ${script_dir}/${script_name}"; exit 0;fi
if ! curl -fsSL --connect-timeout 10 "${script_url}" -o "${script_dir}/${script_name}" > "${script_dir}/${script_name}";
then echo "Problem fetching resource"; exit 1; fi
update_path "$1"
chmod +x "${script_dir}/${script_name}"
echo "Script installed at : ${script_dir}/${script_name}"
