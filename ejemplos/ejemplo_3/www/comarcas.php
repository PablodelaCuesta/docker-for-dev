<?php

$c = new mysqli("192.168.32.2","root","1234","cadiz");
$c->query("SET NAMES utf8");

$result = $c->query("SELECT id,nombre FROM comarca");
$outp = array();
$outp = $result->fetch_all(MYSQLI_ASSOC);
echo json_encode($outp);
$c->close(); ?>