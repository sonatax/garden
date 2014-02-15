<?php

require_once '/usr/share/php/Convert.class.php';

$objConv = new Convert();
$sCoord = $objConv->wgs2tky($_GET['lat'], $_GET['lon']);
$aCoord = explode(',', $sCoord);

$cy = $aCoord['1'];
$cx = $aCoord['0'];

date_default_timezone_set('JST');

$sUrl = 'http://jws.jalan.net/APIAdvance/StockSearch/V1/';
$aParam = array(
    'key' => 'ari14435603f57',
    'x' => $cx,
    'y' => $cy,
    'range' => '1',
    'order' => '4',
    'stay_date' => date('Ymd'),
    'stay_count' => '1',
    'count' => '20',
);

$sUrl .= '?' . http_build_query($aParam);

/*
$curl = curl_init($sUrl);
curl_setopt($curl, 'CURLOPT_HEADER', false);
curl_setopt($curl, 'CURLOPT_RETURNTRANSFER', true);
$res = curl_exec($curl);
*/

$xml = simplexml_load_file($sUrl);
$hRes = array();
for($i = 0; $i < count($xml->Plan); $i++) {
    $objItem = $xml->Plan[$i];
    $name = (string)$xml->Plan[$i]->Hotel->HotelName;
    $jx = (string)$xml->Plan[$i]->Hotel->X;
    $jy = (string)$xml->Plan[$i]->Hotel->Y;
    $review = (string)$xml->Plan[$i]->Hotel->NumberOfRatings;
    $stock = (string)$xml->Plan[$i]->Stay->Date->Stock;
    if(empty($stock)) {
    	$stock = '10';
    }
    $sCoord = $objConv->tky2wgs($jy, $jx);
    $aCoord = explode(',', $sCoord);

    $aRes = array(
    	'Name' => $name,
        'Lat' => $aCoord['1'],
        'Lon' => $aCoord['0'],
	'Review' => $review,
        'Stock' => $stock,
    );
    $hRes[$i] = $aRes;
}

echo json_encode($hRes);

?>
