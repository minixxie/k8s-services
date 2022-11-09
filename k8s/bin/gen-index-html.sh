#!/bin/bash

tmp=$(mktemp /tmp/XXXXXX)
mv "$tmp" "$tmp".html
tmp="$tmp".html

grafanaPwd=$(kubectl get secret -n tools grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)

time=$(TZ=UTC date +"%Y-%m-%d %H:%M:%SZ")

cat <<EOF > "$tmp"
<html>
<body>

<h3>Generated at: $time</h3>
<table border="1">
	<tr>
		<td>Grafana</td>
		<td>
			<a target="_blank" href="http://grafana.minikube/">http://grafana.minikube/</a><br />
			user: admin<br />
			pass: $grafanaPwd<br />
		</td>
	</tr>

</table>

</body>
</html>
EOF

open "$tmp"
sleep 5 && rm -f "$tmp"
