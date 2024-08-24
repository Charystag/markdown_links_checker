# Test Case: Valid HTTP/HTTPS URLs

## Example 1: Standard HTTP/HTTPS Links

This is a valid HTTP link:  
[Example HTTP](http://example.com)

This is a valid HTTPS link:  
[Example HTTPS](https://example.com)

## Example 2: URLs with Parentheses

Here are some valid URLs that include parentheses:

- [Wikipedia Function Page](https://en.wikipedia.org/wiki/Function_\(_mathematics\))
- [Example with multiple parentheses](https://example.com/resource_\(_type_\)_v2)
- [Complex URL with query parameters](https://example.com/search?q=test_\(query\)&sort=asc)

## Example 3: URLs with Encoded Parentheses

URLs with encoded parentheses should be treated as valid:

- [Encoded Parentheses in URL](https://example.com/path%28with%29encoded%29)

## Example 4: URLs in Different Markdown Contexts

### 4.1: URL in a Table

| Description       | Link                                                      |
|-------------------|-----------------------------------------------------------|
| Example Table URL | [Table URL](https://example.com/table_\(_link\))          |

### 4.2: URL in a List

- Valid URL in a list: [List URL](https://example.com/list_\(_link\))

### 4.3: URL in a Blockquote

> Here is a valid URL in a blockquote: [Blockquote URL](https://example.com/quote_\(_link\))

## Example 5: Valid URLs with Anchors

Here are some valid URLs with anchors:

- [URL with anchor](https://example.com/page#section)
- [URL with encoded anchor](https://example.com/page#section%28with%29parentheses)

## Example 6: Valid URL with Port Number

A valid URL with a port number:

- [Example with Port](http://example.com:8080)

## Example 7: Redundant Reference Links

Here is a valid redundant reference link:

[Redundant Link][1]

[1]: https://example.com/redundant_\(_link\)

## Example 8: Valid Mixed Content

Text before the link [Mixed Content](https://example.com/mixed_\(_content\)) and text after the link.


