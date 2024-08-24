# Markdown Links Checker

> :fr: French documentation available [here](/docs/README.fr.md)

A tool to check the validity of the markdown links in your documents

# Table of Contents

1.	[How to use the script ?](#How-to-use-the-script-)
2.	[Why this script ?](#Why-this-script-)
3.	[How it works](#How-it-works)

# How to use the script ?

There are two ways in which you can use this script.

## Invocation

By running it directly from this Github Repositoy. You can run the command :
```bash
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links.sh | bash -s -- doc1.md doc2.md ... docN.md
```
Where doc1..docN are the markdown documents you need to verify

## Installation

If you're using bash or zsh as your logging shell, you can install the script by running :
```
if [ ! -f "$HOME/.local/bin/check_links" ]
	then curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links -o "$HOME/.local/bin/check_links" \
	&& { if { echo "$PATH" | grep "$HOME/.local/bin" ; }
		then echo "PATH=\"$HOME/.local/bin:$PATH\"" >> "$HOME/.$(basename $SHELL)rc"; echo "Path : \`$HOME/.local/bin added to path'" ; . "$HOME/.$(basename $SHELL)rc" ; fi ; } \
	&& echo "Script installed at : $HOME/.local/bin/check_links"
else
	echo "Script already installed at : $HOME/.local/bin/check_links"
fi
```

You can then use it by running :
```
check_links doc1.md doc2.md ... docN.md
```

# Why this script ?

I've basically been generating a lot of content using ChatGPT lately and I asked it a lot of times to put links to documentation as I wanted it to source its affirmations. 
Some of them were broken and as I continued, I found mindself in need for a quick and easy way to check the validity of the links in a markdown document. That is why I decided 
to create this small script.

# How it works

Here is an outline of what the script does :

1.	It retrieves all the http(s) urls that are formatted as markdown links
2.	For all these urls, it executes a curl request on this url and checks the response code
	1.	If the response code starts with a 2, the request is considered valid
	2.	Otherwise, the request is considered invalid
3.	It writes the result on stdout or stderr depending on whether or not the request was successful

# Demo Video
Yet to come
