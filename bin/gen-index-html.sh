#!/bin/bash

tmp=$(mktemp /tmp/XXXXXX)
mv "$tmp" "$tmp".html
tmp="$tmp".html

argocdPwd=$(kubectl get -n argo-cd secret argocd-initial-admin-secret -o go-template='{{.data.password | base64decode}}' ; echo)
kubeappPwd=$(kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}' ; echo)
#grafanaPwd=$(kubectl get secret -n tools grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
grafanaPwd=$(kubectl get secret -n monitor kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
mysqlPwd=$(kubectl get secret --namespace db mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
postgresqlPwd=$(kubectl get secret --namespace db postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

time=$(TZ=UTC date +"%Y-%m-%d %H:%M:%SZ")

cat <<EOF > "$tmp"
<html>
<head>
<style>
div.xterm {
	background-color: #000000;
	font-family: "Courier New", Courier, "Lucida Sans Typewriter", "Lucida Typewriter", monospace;
	color: #ffffff;
	padding: 10px 5px;
}
</style>
<script>
document.addEventListener("DOMContentLoaded", function(event) {
	document.getElementById("copyKubeappsPasswordButton").onclick = async() => {
		await navigator.clipboard.writeText("$kubeappPwd");
	};
	document.getElementById("copyGrafanaPasswordButton").onclick = async() => {
		await navigator.clipboard.writeText("$grafanaPwd");
	};
	document.getElementById("copyArgoCDPasswordButton").onclick = async() => {
		await navigator.clipboard.writeText("$argocdPwd");
	};
});
</script>
</head>
<body>

<h3>Generated at: $time</h3>
<table border="1">
	<tr>
		<td>ArgoCD</td>
		<td>
			<a target="_blank" href="http://argo-cd.local/">http://argo-cd.local/</a><br />
			user: admin<br />
			pass: $argocdPwd <button id="copyArgoCDPasswordButton">copy to clipboard</button><br />
		</td>
	</tr>
	<tr>
		<td>Kubeapps</td>
		<td>
			<a target="_blank" href="http://kubeapps.local/">http://kubeapps.local/</a><br />
			token: $kubeappPwd <button id="copyKubeappsPasswordButton">copy to clipboard</button><br />
		</td>
	</tr>
	<tr>
		<td>Grafana</td>
		<td>
			<a target="_blank" href="http://grafana.local/">http://grafana.local/</a><br />
			user: admin<br />
			pass: $grafanaPwd <button id="copyGrafanaPasswordButton">copy to clipboard</button><br />
			Prometheus: <a target="_blank" href="http://prometheus.local/">http://prometheus.local/</a><br />
			Mimir: <a target="_blank" href="http://mimir.local/prometheus">http://mimir.local/prometheus</a><br />
			Node-exporter: <a target="_blank" href="http://k8s.local:9100/">http://k8s.local:9100/</a><br />
		</td>
	</tr>
	<tr>
	<tr>
		<td>Kafka</td>
		<td>
			<a target="_blank" href="http://kafka-ui.local/">http://kafka-ui.local/</a><br />
		</td>
	</tr>
	<tr>
		<td>MySQL</td>
		<td>
			root pass: $mysqlPwd<br />
			<br />
			<div class="xterm">
			kubectl run mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.31-debian-11-r10 --namespace db --env MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace db mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) --command -- bash -c 'mysql -h mysql.db.svc.cluster.local -uroot -p"\$MYSQL_ROOT_PASSWORD"'
			</div>
			OR
			<div class="xterm">
			cd mysql/ && make cli
			</div>
			MySQL exporter metrics: <a target="_blank" href="http://mysql-exporter.local/">http://mysql-exporter.local/</a>
		</td>
	</tr>
	<tr>
		<td>PostgreSQL</td>
		<td>
			root pass: $postgresqlPwd<br />
			<br />
			<div class="xterm">
			kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace db --image docker.io/bitnami/postgresql:15.1.0-debian-11-r0 --env=PGPASSWORD=\$(kubectl get secret --namespace db postgresql -o jsonpath="{.data.postgres-password}" | base64 -d) --command -- psql --host postgresql -U postgres -d postgres -p 5432
			</div>
			OR
			<div class="xterm">
			cd postgresql/ && make cli
			</div>
		</td>
	</tr>

</table>

</body>
</html>
EOF

open "$tmp"
sleep 5 && rm -f "$tmp"
