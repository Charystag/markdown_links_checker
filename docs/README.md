# Markdown Links Checker

> :fr: French documentation available [here](/docs/README.fr.md)

A tool to check the validity of the http urls in your markdown documents

# Table of Contents

1.	[How to use the script ?](#how-to-use-the-script-)
2.	[Why this script ?](#why-this-script-)
3.	[How it works](#how-it-works)
4.	[Technical Considerations](#technical-considerations)
5.	[Demo Video](#demo-video)

# How to use the script ?

There are two ways in which you can use this script.

## Invocation

By running it directly from this Github Repositoy. You can run the command :
```bash
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links.sh | bash -s -- doc1.md doc2.md ... docN.md
```
Where doc1..docN are the markdown documents you need to verify

You can also run :
```bash
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links.sh | bash -s -- -i ignored doc1.md doc2.md ... docN.md
```
Where `ignored` is a file that contains a list of urls that should be ignored by the script

## Installation

You can install the script by running:
```
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_check/master/assets/install.sh | bash -s -- $SHELL
```

You can then use it by running :
```
markdown-links-checker doc1.md doc2.md ... docN.md
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

# Technical Considerations

For now, the script has difficulties to handle the escaped parenthesis. I hope to fix that in the future but you're 
better off ignoring the urls with the `-i` option.

# Demo Video
Yet to come
