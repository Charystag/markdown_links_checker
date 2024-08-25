# Test Case: Broken HTTP/HTTPS URLs (No Parentheses)

This test case includes broken HTTP/HTTPS URLs that should return a `404 Not Found` or another error status.

## Example 1: Nonexistent Domains

- [Nonexistent Domain HTTP](http://thisdomaindoesnotexist123456.com)
- [Nonexistent Domain HTTPS](https://thisdomaindoesnotexist123456.com)

## Example 2: Valid Domain with Invalid Path

- [Google Invalid Path](https://www.google.com/thispagedoesnotexist)
- [GitHub Invalid Path](https://github.com/thispagedoesnotexist)

## Example 3: Typo in Domain Name

- [Typo in Domain](http://wwww.example.com)  <!-- Note the extra 'w' -->
- [Typo in Domain HTTPS](https://githbusss.com)

## Example 4: Invalid Top-Level Domains (TLDs)

- [Invalid TLD](http://example.invalidtld)
- [Another Invalid TLD](https://website.nonexistenttld)

## Example 5: URLs with Correct Domain but Not Found

- [Wikipedia Nonexistent Page](https://en.wikipedia.org/wiki/This_Page_Does_Not_Exist)
- [BBC Nonexistent Article](https://www.bbc.com/thisarticleisnotfound)

## Example 6: URLs in Different Markdown Contexts

### 6.1: URL in a Table

| Description        | Link                                               |
|--------------------|----------------------------------------------------|
| Broken Table URL   | [Broken Table URL](https://example.com/brokenpath)  |

### 6.2: URL in a List

- Broken URL in a list: [Broken List URL](https://example.com/brokenlist)

### 6.3: URL in a Blockquote

> Here is a broken URL in a blockquote: [Broken Blockquote URL](https://example.com/brokenquote)

## Example 7: Redundant Reference Links (Broken)

Here is a broken redundant reference link:

[Broken Redundant Link][1]

[1]: https://example.com/brokenredundant

## Example 8: Mixed Content with Broken Links

Text before the broken link [Broken Mixed Content](https://example.com/broken_mixed) and text after the link.
