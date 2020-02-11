## Install
- `yarn`
- Install kotlin and gradle somehow
- Install xmllint

## Run

`./do-compare.bash ${path_to_xhtml_file}`

An example `bad.html` and `bad.out.xhtml` have been included as a demonstration.

## Current Process Example
- Let's have an assembled book, say Chemistry, with the file extension changed to html - `chemistry.html`
- `xmllint --pretty 1 chemistry.html > chemistry.formatted`
- `gradle run` (This is hardcoded to chemistry right now)
- `yarn node index.js chemistry.formatted.patched`
- `colordiff chemistry.formatted.patched.html chemistry.formatted.patched.out.xhtml > diff.diff`

## Issues Found
- Empty elements that are not self-closing cause undesired nesting (e.g. empty span in metadata)
  When the trailing `/` is ignored, it must still be valid html
