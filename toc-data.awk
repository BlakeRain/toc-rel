# Initialisation of some variables.
BEGIN {
  # The `okay` flag will be non-zero if we're okay to output this bookmark.
  okay = 1
  # The `offset` variable contains the increment we need to add to the page numbers.
  offset = 0
}

# A function that prints out all the bookmark lines (so long as it's okay).
function output() {
  if (okay) {
    for (i = 1; i <= len; i++) {
      print bookmark[i]
    }
  }
}

# Parse the page offset from the input (use `next` to skip this line).
/Offset: [0-9]+/ {
  offset = $2
  next
}

# Parse the beginning of a bookmark, outputting any previous bookmark.
/BookmarkBegin/ {
  output()
  okay = 1
  len = 0
}

# Match the bookmark page number record, but add the offset to the page number.
/BookmarkPageNumber: [0-9]+/ {
  # Add the line to the 'bookmark' array, but increment the page number by 'offset'
  bookmark[++len] = $1 " " ($2 + offset)
  next
}

# Do not echo a bookmark for the TOC itself.
/BookmarkTitle: Table of Contents/ {
  okay = 0
}

{
  # For all other lines, just add them to the bookmark
  bookmark[++len] = $0
}

# At the end of the input, output any remaining lines.
END {
  output()
}

