#!/bin/bash

tmp=$(mktemp /tmp/XXXXXX)
mv "$tmp" "$tmp".html
tmp="$tmp".html

argocdPwd=$(kubectl get -n argo-cd secret argocd-initial-admin-secret -o go-template='{{.data.password | base64decode}}' ; echo)
kubeappPwd=$(kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}' ; echo)
#grafanaPwd=$(kubectl get secret -n tools grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
grafanaPwd=$(kubectl get secret -n monitor kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
grafanaPwd=hello123

mysqlPwd=$(kubectl get secret --namespace infra-mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
postgresqlPwd=$(kubectl get secret --namespace db postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

time=$(TZ=UTC date +"%Y-%m-%d %H:%M:%SZ")

cat <<EOF > "$tmp"
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<style>
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

<div class="container">

<table class="table table-bordered">
<thead>
	<tr>
		<td>Name</td>
		<td>URL</td>
		<td>User</td>
		<td>Pass</td>
	</tr>
</thead>
<tbody>
<tr>
	<td><img style="height: 24px;" src="https://prometheus.io/assets/favicons/favicon.ico" /> AlertManager</td>
	<td><a href="http://alertmanager.local" target="_blank">http://alertmanager.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://argo-cd.readthedocs.io/en/stable/assets/logo.png" /> ArgoCD</td>
	<td><a href="http://argo-cd.local" target="_blank">http://argo-cd.local</a></td>
	<td>admin</td>
	<td>$argocdPwd <button title="copy to clipboard" id="copyArgoCDPasswordButton">&#x2398;</button></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://about.gitea.com/gitea.svg?color=indigo&shade=600" /> Gitea</td>
	<td><a href="http://gitea.local" target="_blank">http://gitea.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://grafana.com/static/assets/img/fav32.png" /> Grafana</td>
	<td><a href="http://grafana.local" target="_blank">http://grafana.local</a></td>
	<td>admin</td>
	<td>$grafanaPwd <button title="copy to clipboard" id="copyGrafanaPasswordButton">&#x2398;</button></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://graylog.org/wp-content/uploads/2022/08/favicon32.png" /> Graylog</td>
	<td><a href="http://graylog-ui.local" target="_blank">http://graylog-ui.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://www.jaegertracing.io/img/jaeger-icon-color.png" /> Jaeger</td>
	<td><a href="http://jaeger.local" target="_blank">http://jaeger.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://kafka.apache.org/logos/kafka_logo--simple.png" /> Kafka UI</td>
	<td><a href="http://kafka-ui.local" target="_blank">http://kafka-ui.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://clickhouse.com/favicon.ico" /> Lighthouse (Clickhouse)</td>
	<td><a href="/lighthouse/" target="_blank">/lighthouse/</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://postgis.net/favicon/favicon.svg" /> PostGIS UI</td>
	<td><a href="http://postgis-ui.local" target="_blank">http://postgis-ui.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://www.postgresql.org/favicon.ico" /> Postgres UI</td>
	<td><a href="http://postgres-ui.local" target="_blank">http://postgres-ui.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://prometheus.io/assets/favicons/favicon.ico" /> Prometheus</td>
	<td><a href="http://prometheus.local" target="_blank">http://prometheus.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://qdrant.tech/images/logo_with_text.svg" /> Qdrant</td>
	<td><a href="http://qdrant.local/dashboard" target="_blank">http://qdrant.local/dashboard</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://redis.com/wp-content/themes/wpx/assets/images/logo-redis.svg?auto=webp&quality=85,75&width=120" /> RedisInsight</td>
	<td><a href="http://redisinsight.local" target="_blank">http://redisinsight.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://www.timescale.com/favicon-32x32.png?v=7045a84914f0d48a1c822d466332225b" /> Timescale DB</td>
	<td><a href="http://timescaledb-ui.local" target="_blank">http://timescaledb-ui.local</a></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://www.xuxueli.com/doc/static/xxl-job/images/xxl-logo.jpg" /> XXL Job</td>
	<td><a href="http://xxljob.local/xxl-job-admin" target="_blank">http://xxljob.local/xxl-job-admin</a></td>
	<td>admin</td>
	<td>123456</td>
</tr>
<tr>
	<td><img style="height: 24px;" src="https://zipkin.io/public/favicon.ico" /> ZipKin</td>
	<td><a href="http://zipkin.local" target="_blank">http://zipkin.local</a></td>
	<td></td>
	<td></td>
</tr>
</tbody>
</table>

</div>

</body>
</html>





<html>
<head>
<title>minikube INDEX</title>
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
			pass: $argocdPwd <button title="copy to clipboard" id="copyArgoCDPasswordButton">&#x2398;</button><br />
		</td>
	</tr>
	<tr>
		<td>Kubeapps</td>
		<td>
			<a target="_blank" href="http://kubeapps.local/">http://kubeapps.local/</a><br />
			token: $kubeappPwd <button title="copy to clipboard" id="copyKubeappsPasswordButton">&#x2398;</button><br />
		</td>
	</tr>
	<tr>
		<td>Grafana</td>
		<td>
			<a target="_blank" href="http://grafana.local/">http://grafana.local/</a><br />
			user: admin<br />
			pass: $grafanaPwd <button title="copy to clipboard" id="copyGrafanaPasswordButton">&#x2398;</button><br />
			Prometheus: <a target="_blank" href="http://prometheus.local/">http://prometheus.local/</a><br />
			Mimir: <a target="_blank" href="http://mimir.local/prometheus">http://mimir.local/prometheus</a><br />
			Node-exporter: <a target="_blank" href="http://k8s.local:9100/">http://k8s.local:9100/</a><br />
		</td>
	</tr>
	<tr>
		<td>pgAdmin4</td>
		<td>
			<a target="_blank" href="http://pgadmin4.local/">http://pgadmin4.local/</a><br />
		</td>
	</tr>
	<tr>
		<td>MySQL</td>
		<td>
			root pass: $mysqlPwd<br />
			<br />
			<div class="xterm">
			kubectl run mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.2.0-debian-11-r0 --namespace infra-mysql --env MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace infra-mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) --command -- bash -c 'mysql -h mysql.infra-mysql.svc.cluster.local -uroot -p"\$MYSQL_ROOT_PASSWORD"'
			</div>
			OR
			<div class="xterm">
			cd infra-mysql@8.2.0/ && make cli
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
