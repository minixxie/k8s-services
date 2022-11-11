<?php

header("Content-Type: application/json; charset=utf-8");

echo json_encode([
	"data" => [
		[
			"id" => 1,
			"name" => "Chopin",
		],
	],
	"errors" => [
	],
]);

?>
