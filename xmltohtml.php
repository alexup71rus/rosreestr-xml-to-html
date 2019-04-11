<?php
switch ($_POST['action']) {
    case "check-static-link":
    $xslOld = @file_get_contents(__DIR__."/xsl/OKS/Common.xsl");
    $xslNew = @file_get_contents("https://portal.rosreestr.ru/xsl/EGRP/Reestr_Extract_Big/OKS/07/Common.xsl"); // СКОЛЬКО ВЕРСИЙ ССЫЛОК НЕИЗВЕСТНО. ПРИМЕР ДЛЯ OKS
    if ($xslNew == $xslOld) {
        echo "Обновление не требуется";
    } else {
        if (file_put_contents(__DIR__."/xsl/OKS/Common.xsl", $xslNew)) {
            echo "Обновление прошло успешно";
        }
    }
    break;

    case "check-for-file":
    $xml = @file_get_contents($_FILES['file']['tmp_name']);
    $dom = new DOMDocument();
    $dom->loadXml($xml);
    $xpath = new DOMXpath($dom);
    $xlsObjeсt = $xpath->evaluate('string(//processing-instruction()[name() = "xml-stylesheet"])');
    if(strripos($xlsObjeсt, "text/xsl")) {
        preg_match('/href="([^&]*)"/', $xlsObjeсt, $xlsLink, PREG_OFFSET_CAPTURE);
        if(strripos($xlsObjeсt, "text/xsl")) {
            $xlsLinlArray = explode("/", $xlsLink[1][0]);
            $xlsType = $xlsLinlArray[6];
            if($xlsType) {
                if (!file_exists(__DIR__."/xsl/".$xlsType."/Common.xsl")) {
                    $xslNew = @file_get_contents($xlsLink[1][0]);
                    @mkdir(__DIR__."/xsl/".$xlsType);
                    if (file_put_contents(__DIR__."/xsl/".$xlsType."/Common.xsl", $xslNew)) {
                        echo "Обновление прошло успешно";
                    } else {
                        echo "Ошибка при загрузке неизвестных стилей.";
                    }
                } else {
                    $xslOld = @file_get_contents(__DIR__."/xsl/".$xlsType."/Common.xsl");
                    $xslNew = @file_get_contents($xlsLink[1][0]);
                    if ($xslNew == $xslOld) {
                        echo "Обновление не требуется";
                    } else {
                        if (file_put_contents(__DIR__."/xsl/".$xlsType."/Common.xsl", $xslNew)) {
                            echo "Обновление прошло успешно";
                        }
                    }
                }
            }
        }
    } else {
        echo "Невозможно получить стили для документа.";
    }
    break;

    case "proc":
    $info = new SplFileInfo($_FILES['file']['name']);
    if ($_FILES['file']['type'] == "text/xml" && pathinfo($info->getFilename(), PATHINFO_EXTENSION) === "xml") {
        // header('Content-Type: application/octet-stream');
        // header('Content-Disposition: attachment; filename='.$info->getBasename('.xml').'.html');
        $xml = @file_get_contents($_FILES['file']['tmp_name']);
        $dom = new DOMDocument();
        $dom->loadXml($xml);
        $xpath = new DOMXpath($dom);
        $xlsObjeсt = $xpath->evaluate('string(//processing-instruction()[name() = "xml-stylesheet"])');
        preg_match('/href="([^&]*)"/', $xlsObjeсt, $xlsLink, PREG_OFFSET_CAPTURE);
        if(strripos($xlsObjeсt, "text/xsl")) {
            $xlsLinlArray = explode("/", $xlsLink[1][0]);
            $xlsType = $xlsLinlArray[6];
            if($xlsType) {
                if (!file_exists(__DIR__."/xsl/".$xlsType."/Common.xsl")) {
                    $xslNew = @file_get_contents($xlsLink[1][0]);
                    @mkdir(__DIR__."/xsl/".$xlsType);
                    if (file_put_contents(__DIR__."/xsl/".$xlsType."/Common.xsl", $xslNew)) {
                        echo processFiles(__DIR__."/xsl/".$xlsType."/Common.xsl", $_FILES['file']['tmp_name']);
                    } else {
                        echo "Ошибка при загрузке неизвестных стилей.";
                    }
                } else {
                    echo processFiles(__DIR__."/xsl/".$xlsType."/Common.xsl", $_FILES['file']['tmp_name']);
                }
            }
        }
    } else {
        echo "Невернвый тип файла или расширение.";
    }
    break;
}

function processFiles ($xsl, $xml) {
    $xslDoc = new DOMDocument();
    $xslDoc->substituteEntities = TRUE;
    $xslDoc->load($xsl);

    $xmlDoc = new DOMDocument();
    $xmlDoc->load($xml);

    $proc = new XSLTProcessor();
    $proc->importStylesheet($xslDoc);
    return @$proc->transformToXML($xmlDoc);
}
?>