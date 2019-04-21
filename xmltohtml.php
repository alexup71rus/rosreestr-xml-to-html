<?php
$v = 7;
$base = [
    "Reestr_Extract_Big" => [
        "https://portal.rosreestr.ru/xsl/EGRP/Reestr_Extract_Big",
        ["ZU", "OKS", "ROOM"],
        ["Common.xsl"]
    ],
    "Reestr_Extract_List" => [
        "https://portal.rosreestr.ru/xsl/EGRP/Reestr_Extract_List",
        [],
        ["Common.xsl","Header.xsl","Footer.xsl","Extract.xsl","Notice.xsl","Refusal.xsl","Output.xsl","List.xsl"]
    ],
];

switch ($_POST['action']) {
    case "check-static-link":
    foreach ($base as $elem) {
        if ($elem[1] && count($elem[2])) {
            foreach ($elem[1] as $elem_) {
                for ($i = 1; $i <= $v; $i++) {
                    $link = $elem[0]."/".$elem_."/0".$i."/";
                    $xlsUri = explode("/", $link);
                    $xlsUriArr = array_slice($xlsUri, 3);
                    @mkdir(__DIR__."/".implode("/", $xlsUriArr), 0755, true);
                    $xsl = @file_get_contents($link.$elem[2][0]);
                    if ($xsl) { file_put_contents(__DIR__."/".implode("/", $xlsUriArr).$elem[2][0], $xsl); }
                }
            }
        } else {
            foreach ($elem[2] as $elem_) {
                for ($i = 1; $i <= $v; $i++) {
                    $link = $elem[0]."/0".$i."/";
                    $xlsUri = explode("/", $link);
                    $xlsUriArr = array_slice($xlsUri, 3);
                    @mkdir(__DIR__."/".implode("/", $xlsUriArr), 0755, true);
                    $xsl = @file_get_contents($link.$elem_);
                    if ($xsl) { file_put_contents(__DIR__."/".implode("/", $xlsUriArr).$elem_, $xsl); }
                }
            }
        }
    }
    echo "ok";
    break;

    case "proc":
    $info = new SplFileInfo($_FILES['file']['name']);
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename='.$info->getBasename('.xml').'.html');
    if ($_FILES['file']['type'] == "text/xml" && pathinfo($info->getFilename(), PATHINFO_EXTENSION) === "xml") {
        $xml = file_get_contents($_FILES['file']['tmp_name']);
        $dom = new DOMDocument();
        $dom->loadXml($xml);
        $xpath = new DOMXpath($dom);
        $xlsObject = $xpath->evaluate('string(//processing-instruction()[name() = "xml-stylesheet"])');
        preg_match('/href="([^&]*)"/', $xlsObject, $xlsLink, PREG_OFFSET_CAPTURE);
        if(strripos($xlsObject, "text/xsl")) {
            $xsl = file_get_contents($xlsLink[1][0]);
            if (!$xsl) {
                $xlsUri = explode("/", $xlsLink[1][0]);
                $xlsUriArr = array_slice($xlsUri, 3);
                echo processFiles(__DIR__."/".implode("/", $xlsUriArr), $_FILES['file']['tmp_name']);
            } else {
                $xslDoc = new DOMDocument();
                $xslDoc->substituteEntities = TRUE;
                $xslDoc->load( $xlsLink[1][0] );
            
                $xmlDoc = new DOMDocument();
                $xmlDoc->load($_FILES['file']['tmp_name']);
            
                $proc = new XSLTProcessor();
                $proc->importStylesheet($xslDoc);
                echo $proc->transformToXML($xmlDoc);
            }
        } else {
            echo "Ошибка при загрузке неизвестных стилей.";
        }
    } else {
        echo "Невернвый тип файла или формат.";
    }
    break;
}

function processFiles ($xsl, $xml, $save = false) {
    $xslDoc = new DOMDocument();
    $xslDoc->substituteEntities = TRUE;
    $xslDoc->load($xsl);
    $proc = new XSLTProcessor();
    $proc->importStylesheet($xslDoc);

    $xmlDoc = new DOMDocument();
    $xmlDoc->load($xml);
    return @$proc->transformToXML($xmlDoc);
}
?>



<?php
// Версия, которая каждый раз обращается на сервер росреестра
// $info = new SplFileInfo($_FILES['file']['name']);
// if ($_FILES['file']['type'] == "text/xml" && pathinfo($info->getFilename(), PATHINFO_EXTENSION) === "xml") {
//     $xml = file_get_contents($_FILES['file']['tmp_name']);
//     $dom = new DOMDocument();
//     $dom->loadXml($xml);
//     $xpath = new DOMXpath($dom);
//     $xlsObjext = $xpath->evaluate('string(//processing-instruction()[name() = "xml-stylesheet"])');
//     if(strripos($xlsObjext, "text/xsl")) {
//         header('Content-Type: application/octet-stream');
//         header('Content-Disposition: attachment; filename='.$info->getBasename('.xml').'.html');
//         preg_match('/href="([^&]*)"/', $xlsObjext, $xlsLink, PREG_OFFSET_CAPTURE);

//         $xslDoc = new DOMDocument();
//         $xslDoc->substituteEntities = TRUE;
//         $xslDoc->load( $xlsLink[1][0] );
    
//         $xmlDoc = new DOMDocument();
//         $xmlDoc->load($_FILES['file']['tmp_name']);
    
//         $proc = new XSLTProcessor();
//         $proc->importStylesheet($xslDoc);
//         echo $proc->transformToXML($xmlDoc);
//     } else {
//         echo "Невозможно получить стили для документа.";
//     }
// } else {
//     echo "Невернвый тип файла или формат.";
// }









// Версия для парсинга xsl
// if ($_FILES['file']['type'] == "text/xml" && pathinfo($info->getFilename(), PATHINFO_EXTENSION) === "xml") {
//     $xml = file_get_contents($_FILES['file']['tmp_name']);
//     $dom = new DOMDocument();
//     $dom->loadXml($xml);
//     $xpath = new DOMXpath($dom);
//     $xlsObject = $xpath->evaluate('string(//processing-instruction()[name() = "xml-stylesheet"])');
//     preg_match('/href="([^&]*)"/', $xlsObject, $xlsLink, PREG_OFFSET_CAPTURE);
//     if(strripos($xlsObject, "text/xsl")) {
//         $xsl = file_get_contents($xlsLink[1][0]);
//         $xlsUri = explode("/", $xlsLink[1][0]);
//         $filename = array_pop($xlsUri);
//         $xlsUriArr = array_slice($xlsUri, 3);
//         if (!$xsl) {
//             echo processFiles(__DIR__."/".implode("/", $xlsUriArr)."/".$filename, $_FILES['file']['tmp_name']);
//         } else {
//             $xslDoc = new DOMDocument();
//             $xslDoc->substituteEntities = TRUE;
//             $xslDoc->load( $xlsLink[1][0] );
        
//             $xmlDoc = new DOMDocument();
//             $xmlDoc->load($_FILES['file']['tmp_name']);
        
//             $proc = new XSLTProcessor();
//             $proc->importStylesheet($xslDoc);
//             echo $proc->transformToXML($xmlDoc);
//         }
//     } else {
//         echo "Ошибка при загрузке неизвестных стилей.";
//     }
// }
?>