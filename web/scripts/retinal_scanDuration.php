<?php
require_once 'duration_generator.class.php';

$begin_date = htmlspecialchars($_POST['from']);
$end_date = htmlspecialchars($_POST['to']);
$rank = htmlspecialchars($_POST['rank']);

$retinal_scan = new duration_generator('retinal_scan', $rank, $begin_date, $end_date);
$retinal_scan->set_threshold(20);
$retinal_scan->set_standard_deviation_scale(1);
$retinal_scan->build_table_data();
echo $retinal_scan->build_table_html();
