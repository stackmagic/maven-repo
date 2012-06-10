#!/bin/bash
 
for DIR in $(find . -type d | egrep -v "/\."); do
	echo "Updating ${DIR}"
	(
		echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
		echo "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
		echo "	<head><title>Index of ${DIR}</title>"
		echo "	<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" />"
		echo "	<style type=\"text/css\">"
		echo "		table, thead, tbody, tr, td { font-family: monospace; white-space: pre; }"
		echo "		thead { font-weight: bold; }"
		echo "		td.size { text-align: right; }"
		echo "	</style>"
		echo "	</head><body>"
		echo "		<h1>Index of ${DIR}</h1>"
		echo "		<hr/>"
		echo "		<table>"
		echo "			<thead><tr><td>Name</td><td>Changed</td><td>Size</td></tr></thead><tbody>"

		LS="ls -hlp --group-directories-first --time-style=long-iso ${DIR}"
		AWKEXPR='{ printf "<tr><td><a href=\"%s\">%s</a></td><td>%s %s</td><td class=\"size\">%s</td></tr>", $8, $8, $6, $7, $5 }'

		if [ "${DIR}" != "." ]; then
			${LS} -a | grep "\.\./$" | awk  "${AWKEXPR}"
		fi

		${LS} | grep -v "index\.html" | awk '{if(NR>1)print}' | awk "${AWKEXPR}"

		echo "		</tbody></table>"
		echo "	</body>"
		echo "</html>"
	) > "${DIR}/index.html"
done

