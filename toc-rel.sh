#!/bin/bash
#
# Relocate the Table of Contents
#
# This script moves the Table of Contents from the end of the PDF to immediately after. This handles
# situations where the TOC is more than one page. Another script, toc-data.awk, modifies the
# bookmarks from the PDF. The TOC bookmark is removed, and all other bookmarks are offset by the
# number of TOC pages.

# Read the PDF content from the standard input into a temporary file.
input=$(mktemp)
cat > "$input"

# Make sure that the commands we use are present: pdfinfo, pdfgrep, and pdftk
if ! command -v pdfinfo > /dev/null; then
  echo "pdfinfo not found. Please install the poppler-utils package." >&2
  exit 1
fi

if ! command -v pdfgrep > /dev/null; then
  echo "pdfgrep not found. Please install the pdfgrep package." >&2
  exit 1
fi

if ! command -v pdftk > /dev/null; then
  echo "pdftk not found. Please install the pdftk package." >&2
  exit 1
fi

# Extract all the data from the input PDF
pdftk "$input" dump_data > "$input".data

# Extract just the bookmarks from the data into a separate file
grep "^Bookmark" "$input".data > "$input".bookmarks
grep -v "^Bookmark" "$input".data > "$input".not-bookmarks

# Find out how many pages there are in the PDF.
pages=$(grep "NumberOfPages:" "$input".not-bookmarks | awk '{print $2}')

# Find out on which page the "Table of Contents" starts
toc_page=$(pdfgrep -m 1 -n "Table of Contents" "$input" | cut -d: -f 1)
toc_count=$((pages - toc_page + 1))

# Renumber all the bookmarks in the PDF, and remove the Table of Contents entry.
(echo "Offset: $toc_count"; cat "$input".bookmarks) | gawk -f toc-data.awk > "$input".bookmarks.modified

# Combine the modified bookmarks with the rest of the extracted PDF data.
cat "$input".not-bookmarks "$input".bookmarks.modified > "$input".data.modified

# Rearrange the pages in the input PDF to move the TOC to immediately after the first page.
pdftk "$input" cat 1 $toc_page-$pages 2-$((toc_page - 1)) output "$input".rearranged

# Now we need to update the bookmarks in the rearranged PDF.
pdftk "$input".rearranged update_info "$input".data.modified output "$input".output

# Clean up the temporary files.
rm "$input"
rm "$input".data
rm "$input".data.modified
rm "$input".bookmarks
rm "$input".bookmarks.modified
rm "$input".not-bookmarks
rm "$input".rearranged

# Output the rearranged PDF
cat "$input".output

