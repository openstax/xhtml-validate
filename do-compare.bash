input_file=$1

f_temp_base="temp-file"
f_temp_in="./${f_temp_base}.html"
f_temp_out="./${f_temp_base}.out.xhtml"
f_in="./canonical.in.xhtml"
f_out="./canonical.out.xhtml"

[[ -f "${f_temp_in}" ]] && rm "${f_temp_in}"
[[ -f "${f_temp_out}" ]] && rm "${f_temp_out}"
[[ -f "${f_in}" ]] && rm "${f_in}"
[[ -f "${f_out}" ]] && rm "${f_out}"

# xsltproc lint-input.xsl "${input_file}" > "${f_temp_in}"
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/saxon.rb#L4
saxon "-s:${input_file}" -xsl:./lint-input.xsl "-o:${f_temp_in}"

node index.js "${f_temp_base}"

xmllint --pretty 1 "${f_temp_in}" > "${f_in}" || exit 110
xmllint --pretty 1 "${f_temp_out}" > "${f_out}" || exit 110

diff "${f_in}" "${f_out}"