<?php
$info = new SplFileInfo($_FILES['file']['name']);
if ($_FILES['file']['type'] == "text/xml" && pathinfo($info->getFilename(), PATHINFO_EXTENSION) === "xml") {
    $xml = file_get_contents($_FILES['file']['tmp_name']);
    $dom = new DOMDocument();
    $dom->loadXml($xml);
    $xpath = new DOMXpath($dom);
    $xlsObjext = $xpath->evaluate('string(//processing-instruction()[name() = "xml-stylesheet"])');
    if(strripos($xlsObjext, "text/xsl")) {
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename='.$info->getBasename('.xml').'.html');
        preg_match('/href="([^&]*)"/', $xlsObjext, $xlsLink, PREG_OFFSET_CAPTURE);

        $xslDoc = new DOMDocument();
        $xslDoc->substituteEntities = TRUE;
        $xslDoc->load( $xlsLink[1][0] );
    
        $xmlDoc = new DOMDocument();
        $xmlDoc->load($_FILES['file']['tmp_name']);
    
        $proc = new XSLTProcessor();
        $proc->importStylesheet($xslDoc);
        echo $proc->transformToXML($xmlDoc);
    } else {
        echo "Невозможно получить стили для документа.";
    }
} else {
    echo "Невернвый тип файла или формат.";
}
?>