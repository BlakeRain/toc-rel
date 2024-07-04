# toc-rel

A script that moves a table of contents from the end of a PDF file to just after the cover page.
This is useful when you're using troff/groff and cannot have your macro package move the TOC.

See the following blog post to learn about these scripts in more detail:

https://blakerain.com/blog/moving-toc-in-groff-pdfs/

The script that performs the TOC movement is `toc-rel.sh`, and it has an accompanying AWK script in
`toc-data.awk` which is used to rewrite the bookmarks data in the PDF.

You will need to have the following additional tools to hand:

- [pdfgrep], which is used to search for text in a PDF, and
- [pdftk] which performs the actual PDF modification.

A demonstration file using the ms macro package is included, which can be built using the included
`Makefile`. Running `make` will use `groff` to create the PDF, and then use `toc-rel.sh` to move the
table of contents to just after the cover page, updating any bookmarks as required.

You can find the example PDF for download on the [releases] page.

[pdfgrep]: https://pdfgrep.org/
[pdftk]: https://gitlab.com/pdftk-java/pdftk
[releases]: https://git.blakerain.com/BlakeRain/toc-rel/releases
