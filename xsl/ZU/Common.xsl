<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
	<!ENTITY laquo "&#171;">
	<!ENTITY number "&#8470;">
	<!ENTITY sup2 "&#178;">
]>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:kv="urn://x-artefacts-rosreestr-ru/outgoing/kvzu/7.0.1"
		xmlns:spa="urn://x-artefacts-rosreestr-ru/commons/complex-types/entity-spatial/5.0.1"
		xmlns:cert="urn://x-artefacts-rosreestr-ru/commons/complex-types/certification-doc/1.0"
		xmlns:num="urn://x-artefacts-rosreestr-ru/commons/complex-types/numbers/1.0"
		xmlns:adr="urn://x-artefacts-rosreestr-ru/commons/complex-types/address-output/4.0.1"
		xmlns:tns="urn://x-artefacts-smev-gov-ru/supplementary/commons/1.0.1"
		xmlns:ass="urn://x-artefacts-rosreestr-ru/commons/complex-types/assignation-flat/1.0.1"
		xmlns:nat="urn://x-artefacts-rosreestr-ru/commons/complex-types/natural-objects-output/1.0.1"
		xmlns:doc="urn://x-artefacts-rosreestr-ru/commons/complex-types/document-output/4.0.1">
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" omit-xml-declaration="yes" media-type="text/javascript" encoding="UTF-8"/>
	
	<xsl:param name="max_page_records" select="15"/>
	<xsl:param name="kindRealty" select="'Замельный участок'"/>
	
	<xsl:variable name="certificationDoc" select="kv:KVZU/kv:CertificationDoc"/>
	<xsl:variable name="coordSystems" select="kv:KVZU/kv:CoordSystems"/>
	<xsl:variable name="contractors" select="kv:KVZU/kv:Contractors"/>
	<xsl:variable name="parcels" select="kv:KVZU/kv:Parcels"/>
	<xsl:variable name="parcel" select="kv:KVZU/kv:Parcels/kv:Parcel"/>
	<xsl:variable name="rights" select="$parcels/kv:Parcel/kv:Rights"/>

	<!-- Do not use kv:SubParcels in 3, 3.1, 3.2 -->
	<!--<xsl:variable name="borders" select="$parcel/kv:EntitySpatial/spa:Borders | $parcel/kv:Contours/descendant::spa:Borders | $parcel/kv:CompositionEZ/descendant::spa:Borders | $parcel/kv:SubParcels/descendant::spa:Borders | $parcels/kv:OffspringParcel/kv:EntitySpatial/spa:Borders"/>-->
	<xsl:variable name="borders" select="$parcel/kv:EntitySpatial/spa:Borders | $parcel/kv:Contours/descendant::spa:Borders | $parcel/kv:CompositionEZ/descendant::spa:Borders | $parcels/kv:OffspringParcel/kv:EntitySpatial/spa:Borders"/>
	<xsl:variable name="bordersUnique" select="$borders/spa:Border[not(@Point1=preceding-sibling::spa:Border/@Point1 and @Point2=preceding-sibling::spa:Border/@Point2) or not(@Point1=following-sibling::spa:Border/@Point1 and @Point2=following-sibling::spa:Border/@Point2)]"/>
	<!--<xsl:variable name="spatialElement" select="$parcel/kv:EntitySpatial | $parcel/kv:Contours/descendant::kv:EntitySpatial | $parcel/kv:CompositionEZ/descendant::kv:EntitySpatial | $parcel/kv:SubParcels/descendant::kv:EntitySpatial | $parcels/kv:OffspringParcel/kv:EntitySpatial"/>-->
	<xsl:variable name="spatialElement" select="$parcel/kv:EntitySpatial | $parcel/kv:Contours/descendant::kv:EntitySpatial | $parcel/kv:CompositionEZ/descendant::kv:EntitySpatial | $parcels/kv:OffspringParcel/kv:EntitySpatial"/>
	<xsl:variable name="spatialElementUnique" select="$spatialElement/descendant::spa:SpelementUnit[not(@SuNmb=following::spa:SpelementUnit/@SuNmb and spa:Ordinate/@X=following::spa:SpelementUnit/spa:Ordinate/@X and spa:Ordinate/@Y=following::spa:SpelementUnit/spa:Ordinate/@Y)]"/>

  <xsl:variable name="SubParselspatialElement" select="$parcel/kv:SubParcels/kv:SubParcel/descendant::kv:EntitySpatial"/>
  <xsl:variable name="SubParselspatialElementUnique" select="$SubParselspatialElement/descendant::spa:SpelementUnit[not(@SuNmb=following-sibling::spa:SpelementUnit/@SuNmb and spa:Ordinate/@X=following-sibling::spa:SpelementUnit/spa:Ordinate/@X and spa:Ordinate/@Y=following-sibling::spa:SpelementUnit/spa:Ordinate/@Y)]"/>
 
  <xsl:variable name="ownerNeighbours" select="$parcel/kv:ParcelNeighbours/kv:ParcelNeighbour"/>
	<xsl:variable name="countRights" select="count($rights/kv:Right)"/>
	<xsl:variable name="viewRightsDoc" select="1"/>
	<xsl:variable name="countV1Rights" select="20"/>
	<xsl:variable name="countV3" select="8"/>
	<xsl:variable name="part_4_2_maxrows" select="17"/>
	
	<xsl:variable name="smallcase" select="'абвгдеёжзийклмнопрстуфхцчшщьыъэюя'"/>
	<xsl:variable name="uppercase" select="'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ'"/>
	
	<!--
	<xsl:variable name="year" select="substring(/kv:KVZU/kv:CertificationDoc/cert:Date,1,4)"/>
	<xsl:variable name="month" select="substring(/kv:KVZU/kv:CertificationDoc/cert:Date,6,2)"/>
	<xsl:variable name="day" select="substring(/kv:KVZU/kv:CertificationDoc/cert:Date,9,2)"/>
	-->
	<xsl:variable name="year" select="substring(/kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute/@ExtractDate,7,4)"/>
	<xsl:variable name="month" select="substring(/kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute/@ExtractDate,4,2)"/>
	<xsl:variable name="day" select="substring(/kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute/@ExtractDate,1,2)"/>
	
	<xsl:variable name="SExtract"        select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight"/>
	<xsl:variable name="DeclarAttribute" select="kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute"/>
	<xsl:variable name="FootContent" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:FootContent"/>
	
	<xsl:variable name="Sender" select="kv:KVZU/kv:eDocument/kv:Sender"/>
	
	<xsl:variable name="InfoPIK" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:InfoPIK"/>
	<xsl:variable name="InfoENK" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:InfoENK"/>
	<xsl:variable name="parcelCadastralNumber" select="kv:KVZU/kv:Parcels/kv:Parcel/@CadastralNumber"/>
	<xsl:variable name="HeadContent" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:HeadContent"/>
	
	<xsl:template match="kv:KVZU">
		<html>
			<head>
				<title>Выписка из ЕГРН об объекте недвижимости</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
				<meta name="Content-Script-Type" content="text/javascript"/>
				<meta name="Content-Style-Type" content="text/css"/>
				<style type="text/css">body{background:#fff;color:#000;font-family:times new roman,arial,sans-serif}body,th,font.signature,th.signature,th.pager,.page_title,.topstroke,div.procherk,.td_center,.tbl_clear,.tbl_clear TD,.tbl_section_sign TD,.small_text{text-align:center}th,td{font:10pt times new roman,arial,sans-serif;color:black;FONT-WEIGHT:normal}table{border-collapse:collapse;empty-cells:show}div.floatR{float:right}div.floatL{float:left}th.head{background:White;width:3%;font-weight:bold}th.head,.tbl_page TD,.topstroke,div.procherk,.tbl_section_content TD{vertical-align:top}font.signature,th.signature{font-size:60%}th.signature{font-weight:bolder}th.pager{font-weight:normal}div.page{page-break-before:always}.tbl_page{width:950px;height:700px;border:1px solid #ccc}.tbl_page,.page_title,.topstroke,.td_center{margin:0 auto}.tbl_page,.tbl_section_date TD{text-align:left}.tbl_page TD{padding-top:20px;padding-left:10px;padding-right:10px}.page_title,.tbl_section_title TD{font:bold small Arial,Verdana,Geneva,Helvetica,sans-serif}.page_title,.topstroke{width:90%}.page_title,.understroke{border-bottom:solid;border-bottom-width:1px}.topstroke{border-top:solid;border-top-width:1px}.topstroke,.small_text{font:normal xx-small Arial,Verdana,Geneva,Helvetica,sans-serif}div.procherk{width:10px}div.procherk,.tbl_section_title,.tbl_clear,.tbl_section_sign{width:100%}.tbl_section_title,.tbl_section_date,.tbl_clear,.tbl_section_sign{border:none}.tbl_section_title TD,.tbl_section_date TD,.tbl_section_content TD,.tbl_clear,.tbl_section_sign,.tbl_section_sign TD{padding:0;margin:0}.tbl_section_title TD{padding-top:10px;padding-bottom:10px}.tbl_section_date,.tbl_section_sign{border-color:black}.tbl_section_date TD{padding-right:2px;font:normal x-small Arial,Verdana,Geneva,Helvetica,sans-serif}.tbl_section_content,.tbl_section_content TD{border:1px solid #000}.tbl_section_content TD{padding:4px 3px}.tbl_section_content TD,.tbl_clear TD{font:normal 9pt Arial,Verdana,Geneva,Helvetica,sans-serif}.td_center,.tbl_clear,.tbl_clear TD,.tbl_section_sign TD{vertical-align:middle}.tbl_section_sign{font:bold x-small Arial,Verdana,Geneva,Helvetica,sans-serif}.tbl_section_sign TD{font:normal 10pt Arial,Verdana,Geneva,Helvetica,sans-serif}.windows{height:300px;overflow-y:auto;overflow-x:hidden;scrollbar-face-color:#ccc;scrollbar-shadow-color:Black;scrollbar-highlight-color:#fff;scrollbar-arrow-color:black;scrollbar-base-color:Gray;scrollbar-3dlight-color:#eee;scrollbar-darkshadow-color:#333;scrollbar-track-color:#999}
				.tbl_container{width:100%;border-collapse:collapse;border:0;padding:1px}
				div.title1{text-align:right;padding-right:10px;font-size:100%}div.title2{margin-left:auto;margin-right:auto;font-size:100%;text-align:center;}
				.tbl_section_topsheet{width:100%;border-collapse:collapse;border:1px solid #000;padding:1px}.tbl_section_topsheet th,.tbl_section_topsheet td.in16{border:1px solid #000;vertical-align:middle;margin:0;padding:4px 3px}.tbl_section_topsheet th.left,.tbl_section_topsheet td.left{text-align:left}.tbl_section_topsheet th.vtop,.tbl_section_topsheet td.vtop{vertical-align:top}
				.tbl_section_date{border:none;border-color:#000}.tbl_section_date td{text-align:left;margin:0;padding:0 3px}.tbl_section_date td.nolpad{padding-left:0}.tbl_section_date td.norpad{padding-right:0}.tbl_section_date td.understroke{border-bottom:1px solid #000}
				@media print{p.pagebreak{page-break-before: always;}.noPrint{display:none;}@page{size:landscape;margin:0;margin-top:5px;}.Footer{display:none;}body{margin:0;}}
				.t td{text-align:left}
				</style>
				<xsl:if test="descendant::kv:EntitySpatial">
					<xsl:comment><![CDATA[[if (lt IE 9)|!(IE)]><script type="text/javascript">document.createElement("canvas").getContext||function(){function H(){return this.context_||(this.context_=new w(this))}function I(a,b,c){var d=A.call(arguments,2);return function(){return a.apply(b,d.concat(A.call(arguments)))}}function J(a){var b=a.srcElement;switch(a.propertyName){case "width":b.style.width=b.attributes.width.nodeValue+"px";b.getContext().clearRect();break;case "height":b.style.height=b.attributes.height.nodeValue+"px",b.getContext().clearRect()}}function K(a){a=a.srcElement;if(a.firstChild)a.firstChild.style.width=
a.clientWidth+"px",a.firstChild.style.height=a.clientHeight+"px"}function x(){return[[1,0,0],[0,1,0],[0,0,1]]}function p(a,b){for(var c=x(),d=0;d<3;d++)for(var f=0;f<3;f++){for(var e=0,j=0;j<3;j++)e+=a[d][j]*b[j][f];c[d][f]=e}return c}function B(a,b){b.fillStyle=a.fillStyle;b.lineCap=a.lineCap;b.lineJoin=a.lineJoin;b.lineWidth=a.lineWidth;b.miterLimit=a.miterLimit;b.shadowBlur=a.shadowBlur;b.shadowColor=a.shadowColor;b.shadowOffsetX=a.shadowOffsetX;b.shadowOffsetY=a.shadowOffsetY;b.strokeStyle=a.strokeStyle;
b.globalAlpha=a.globalAlpha;b.arcScaleX_=a.arcScaleX_;b.arcScaleY_=a.arcScaleY_;b.lineScale_=a.lineScale_}function C(a){var b,c=1,a=String(a);if(a.substring(0,3)=="rgb"){b=a.indexOf("(",3);var d=a.indexOf(")",b+1),d=a.substring(b+1,d).split(",");b="#";for(var f=0;f<3;f++)b+=D[Number(d[f])];d.length==4&&a.substr(3,1)=="a"&&(c=d[3])}else b=a;return{color:b,alpha:c}}function L(a){switch(a){case "butt":return"flat";case "round":return"round";default:return"square"}}function w(a){this.m_=x();this.mStack_=
[];this.aStack_=[];this.currentPath_=[];this.fillStyle=this.strokeStyle="#000";this.lineWidth=1;this.lineJoin="miter";this.lineCap="butt";this.miterLimit=k*1;this.globalAlpha=1;this.canvas=a;var b=a.ownerDocument.createElement("div");b.style.width=a.clientWidth+"px";b.style.height=a.clientHeight+"px";b.style.overflow="hidden";b.style.position="absolute";a.appendChild(b);this.element_=b;this.lineScale_=this.arcScaleY_=this.arcScaleX_=1}function E(a,b,c,d){a.currentPath_.push({type:"bezierCurveTo",
cp1x:b.x,cp1y:b.y,cp2x:c.x,cp2y:c.y,x:d.x,y:d.y});a.currentX_=d.x;a.currentY_=d.y}function q(a,b,c){var d;a:{for(d=0;d<3;d++)for(var f=0;f<2;f++)if(!isFinite(b[d][f])||isNaN(b[d][f])){d=!1;break a}d=!0}if(d&&(a.m_=b,c))a.lineScale_=M(N(b[0][0]*b[1][1]-b[0][1]*b[1][0]))}function u(a){this.type_=a;this.r1_=this.y1_=this.x1_=this.r0_=this.y0_=this.x0_=0;this.colors_=[]}function F(){}var s=Math,h=s.round,y=s.sin,z=s.cos,N=s.abs,M=s.sqrt,k=10,r=k/2,A=Array.prototype.slice,G={init:function(a){/MSIE/.test(navigator.userAgent)&&
!window.opera&&(a=a||document,a.createElement("canvas"),a.attachEvent("onreadystatechange",I(this.init_,this,a)))},init_:function(a){a.namespaces.g_vml_||a.namespaces.add("g_vml_","urn:schemas-microsoft-com:vml","#default#VML");a.namespaces.g_o_||a.namespaces.add("g_o_","urn:schemas-microsoft-com:office:office","#default#VML");if(!a.styleSheets.ex_canvas_){var b=a.createStyleSheet();b.owningElement.id="ex_canvas_";b.cssText="canvas{display:inline-block;overflow:hidden;text-align:left;width:300px;height:150px}g_vml_\\:*{behavior:url(#default#VML)}g_o_\\:*{behavior:url(#default#VML)}"}a=
a.getElementsByTagName("canvas");for(b=0;b<a.length;b++)this.initElement(a[b])},initElement:function(a){if(!a.getContext){a.getContext=H;a.innerHTML="";a.attachEvent("onpropertychange",J);a.attachEvent("onresize",K);var b=a.attributes;b.width&&b.width.specified?a.style.width=b.width.nodeValue+"px":a.width=a.clientWidth;b.height&&b.height.specified?a.style.height=b.height.nodeValue+"px":a.height=a.clientHeight}return a}};G.init();for(var D=[],e=0;e<16;e++)for(var v=0;v<16;v++)D[e*16+v]=e.toString(16)+
v.toString(16);e=w.prototype;e.clearRect=function(){this.element_.innerHTML=""};e.beginPath=function(){this.currentPath_=[]};e.moveTo=function(a,b){var c=this.getCoords_(a,b);this.currentPath_.push({type:"moveTo",x:c.x,y:c.y});this.currentX_=c.x;this.currentY_=c.y};e.lineTo=function(a,b){var c=this.getCoords_(a,b);this.currentPath_.push({type:"lineTo",x:c.x,y:c.y});this.currentX_=c.x;this.currentY_=c.y};e.bezierCurveTo=function(a,b,c,d,f,e){f=this.getCoords_(f,e);a=this.getCoords_(a,b);c=this.getCoords_(c,
d);E(this,a,c,f)};e.quadraticCurveTo=function(a,b,c,d){a=this.getCoords_(a,b);c=this.getCoords_(c,d);d={x:this.currentX_+2/3*(a.x-this.currentX_),y:this.currentY_+2/3*(a.y-this.currentY_)};E(this,d,{x:d.x+(c.x-this.currentX_)/3,y:d.y+(c.y-this.currentY_)/3},c)};e.arc=function(a,b,c,d,f,e){c*=k;var j=e?"at":"wa",h=a+z(d)*c-r,i=b+y(d)*c-r,d=a+z(f)*c-r,f=b+y(f)*c-r;h==d&&!e&&(h+=0.125);a=this.getCoords_(a,b);h=this.getCoords_(h,i);d=this.getCoords_(d,f);this.currentPath_.push({type:j,x:a.x,y:a.y,radius:c,
xStart:h.x,yStart:h.y,xEnd:d.x,yEnd:d.y})};e.rect=function(a,b,c,d){this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,b+d);this.closePath()};e.strokeRect=function(a,b,c,d){var f=this.currentPath_;this.beginPath();this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,b+d);this.closePath();this.stroke();this.currentPath_=f};e.fillRect=function(a,b,c,d){var f=this.currentPath_;this.beginPath();this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,
b+d);this.closePath();this.fill();this.currentPath_=f};e.createLinearGradient=function(a,b,c,d){var f=new u("gradient");f.x0_=a;f.y0_=b;f.x1_=c;f.y1_=d;return f};e.createRadialGradient=function(a,b,c,d,f,e){var h=new u("gradientradial");h.x0_=a;h.y0_=b;h.r0_=c;h.x1_=d;h.y1_=f;h.r1_=e;return h};e.drawImage=function(a,b){var c,d,f,e,j,m,i,g;f=a.runtimeStyle.width;e=a.runtimeStyle.height;a.runtimeStyle.width="auto";a.runtimeStyle.height="auto";var l=a.width,n=a.height;a.runtimeStyle.width=f;a.runtimeStyle.height=
e;if(arguments.length==3)c=arguments[1],d=arguments[2],j=m=0,i=f=l,g=e=n;else if(arguments.length==5)c=arguments[1],d=arguments[2],f=arguments[3],e=arguments[4],j=m=0,i=l,g=n;else if(arguments.length==9)j=arguments[1],m=arguments[2],i=arguments[3],g=arguments[4],c=arguments[5],d=arguments[6],f=arguments[7],e=arguments[8];else throw Error("Invalid number of arguments");var o=this.getCoords_(c,d),t=[];t.push(" <g_vml_:group",' coordsize="',k*10,",",k*10,'"',' coordorigin="0,0"',' style="width:',10,
"px;height:",10,"px;position:absolute;");if(this.m_[0][0]!=1||this.m_[0][1]){var r=[];r.push("M11=",this.m_[0][0],",","M12=",this.m_[1][0],",","M21=",this.m_[0][1],",","M22=",this.m_[1][1],",","Dx=",h(o.x/k),",","Dy=",h(o.y/k),"");var p=this.getCoords_(c+f,d),q=this.getCoords_(c,d+e);c=this.getCoords_(c+f,d+e);o.x=s.max(o.x,p.x,q.x,c.x);o.y=s.max(o.y,p.y,q.y,c.y);t.push("padding:0 ",h(o.x/k),"px ",h(o.y/k),"px 0;filter:progid:DXImageTransform.Microsoft.Matrix(",r.join(""),", sizingmethod='clip');")}else t.push("top:",
h(o.y/k),"px;left:",h(o.x/k),"px;");t.push(' ">','<g_vml_:image src="',a.src,'"',' style="width:',k*f,"px;"," height:",k*e,'px;"',' cropleft="',j/l,'"',' croptop="',m/n,'"',' cropright="',(l-j-i)/l,'"',' cropbottom="',(n-m-g)/n,'"'," />","</g_vml_:group>");this.element_.insertAdjacentHTML("BeforeEnd",t.join(""))};e.stroke=function(a){var b=[],c=C(a?this.fillStyle:this.strokeStyle),d=c.color,c=c.alpha*this.globalAlpha;b.push("<g_vml_:shape",' filled="',!!a,'"',' style="position:absolute;width:',10,
"px;height:",10,'px;"',' coordorigin="0 0" coordsize="',k*10," ",k*10,'"',' stroked="',!a,'"',' path="');for(var f=null,e=null,j=null,m=null,i=0;i<this.currentPath_.length;i++){var g=this.currentPath_[i];switch(g.type){case "moveTo":b.push(" m ",h(g.x),",",h(g.y));break;case "lineTo":b.push(" l ",h(g.x),",",h(g.y));break;case "close":b.push(" x ");g=null;break;case "bezierCurveTo":b.push(" c ",h(g.cp1x),",",h(g.cp1y),",",h(g.cp2x),",",h(g.cp2y),",",h(g.x),",",h(g.y));break;case "at":case "wa":b.push(" ",
g.type," ",h(g.x-this.arcScaleX_*g.radius),",",h(g.y-this.arcScaleY_*g.radius)," ",h(g.x+this.arcScaleX_*g.radius),",",h(g.y+this.arcScaleY_*g.radius)," ",h(g.xStart),",",h(g.yStart)," ",h(g.xEnd),",",h(g.yEnd))}if(g){if(f==null||g.x<f)f=g.x;if(j==null||g.x>j)j=g.x;if(e==null||g.y<e)e=g.y;if(m==null||g.y>m)m=g.y}}b.push(' ">');if(a)if(typeof this.fillStyle=="object"){var d=this.fillStyle,l=0,g=c=a=0,n=1;d.type_=="gradient"?(l=d.x1_/this.arcScaleX_,f=d.y1_/this.arcScaleY_,i=this.getCoords_(d.x0_/this.arcScaleX_,
d.y0_/this.arcScaleY_),l=this.getCoords_(l,f),l=Math.atan2(l.x-i.x,l.y-i.y)*180/Math.PI,l<0&&(l+=360),l<1.0E-6&&(l=0)):(i=this.getCoords_(d.x0_,d.y0_),g=j-f,n=m-e,a=(i.x-f)/g,c=(i.y-e)/n,g/=this.arcScaleX_*k,n/=this.arcScaleY_*k,i=s.max(g,n),g=2*d.r0_/i,n=2*d.r1_/i-g);f=d.colors_;f.sort(function(a,b){return a.offset-b.offset});for(var e=f.length,m=f[0].color,j=f[e-1].color,o=f[0].alpha*this.globalAlpha,r=f[e-1].alpha*this.globalAlpha,p=[],i=0;i<e;i++){var q=f[i];p.push(q.offset*n+g+" "+q.color)}b.push('<g_vml_:fill type="',
d.type_,'"',' method="none" focus="100%"',' color="',m,'"',' color2="',j,'"',' colors="',p.join(","),'"',' opacity="',r,'"',' g_o_:opacity2="',o,'"',' angle="',l,'"',' focusposition="',a,",",c,'" />')}else b.push('<g_vml_:fill color="',d,'" opacity="',c,'" />');else a=this.lineScale_*this.lineWidth,a<1&&(c*=a),b.push("<g_vml_:stroke",' opacity="',c,'"',' joinstyle="',this.lineJoin,'"',' miterlimit="',this.miterLimit,'"',' endcap="',L(this.lineCap),'"',' weight="',a,'px"',' color="',d,'" />');b.push("</g_vml_:shape>");
this.element_.insertAdjacentHTML("beforeEnd",b.join(""))};e.fill=function(){this.stroke(!0)};e.closePath=function(){this.currentPath_.push({type:"close"})};e.getCoords_=function(a,b){var c=this.m_;return{x:k*(a*c[0][0]+b*c[1][0]+c[2][0])-r,y:k*(a*c[0][1]+b*c[1][1]+c[2][1])-r}};e.save=function(){var a={};B(this,a);this.aStack_.push(a);this.mStack_.push(this.m_);this.m_=p(x(),this.m_)};e.restore=function(){B(this.aStack_.pop(),this);this.m_=this.mStack_.pop()};e.translate=function(a,b){q(this,p([[1,
0,0],[0,1,0],[a,b,1]],this.m_),!1)};e.rotate=function(a){var b=z(a),a=y(a);q(this,p([[b,a,0],[-a,b,0],[0,0,1]],this.m_),!1)};e.scale=function(a,b){this.arcScaleX_*=a;this.arcScaleY_*=b;q(this,p([[a,0,0],[0,b,0],[0,0,1]],this.m_),!0)};e.transform=function(a,b,c,d,f,e){q(this,p([[a,b,0],[c,d,0],[f,e,1]],this.m_),!0)};e.setTransform=function(a,b,c,d,e,h){q(this,[[a,b,0],[c,d,0],[e,h,1]],!0)};e.clip=function(){};e.arcTo=function(){};e.createPattern=function(){return new F};u.prototype.addColorStop=function(a,
b){b=C(b);this.colors_.push({offset:a,color:b.color,alpha:b.alpha})};G_vmlCanvasManager=G;CanvasRenderingContext2D=w;CanvasGradient=u;CanvasPattern=F}();</script><![endif]]]></xsl:comment>
					<script type="text/javascript"><![CDATA[/* MIT License <http://www.opensource.org/licenses/mit-license.php>*/
window.Canvas=window.Canvas||{};
window.Canvas.Text={equivalentFaces:{arial:["liberation sans","nimbus sans l","freesans","optimer","dejavu sans"],"times new roman":["liberation serif","helvetiker","linux libertine","freeserif"],"courier new":["dejavu sans mono","liberation mono","nimbus mono l","freemono"],georgia:["nimbus roman no9 l","helvetiker"],helvetica:["nimbus sans l","helvetiker","freesans"],tahoma:["dejavu sans","optimer","bitstream vera sans"],verdana:["dejavu sans","optimer","bitstream vera sans"]},genericFaces:{serif:"times new roman,georgia,garamond,bodoni,minion web,itc stone serif,bitstream cyberbit".split(","),
"sans-serif":"arial,verdana,trebuchet,tahoma,helvetica,itc avant garde gothic,univers,futura,gill sans,akzidenz grotesk,attika,typiko new era,itc stone sans,monotype gill sans 571".split(","),monospace:["courier","courier new","prestige","everson mono"],cursive:"caflisch script,adobe poetica,sanvito,ex ponto,snell roundhand,zapf-chancery".split(","),fantasy:["alpha geometrique","critter","cottonwood","fb reactor","studz"]},faces:{},scaling:0.962,_styleCache:{}};
(function(){function p(a){switch(String(a)){case "bolder":case "bold":case "900":case "800":case "700":return"bold";default:case "normal":return"normal"}}function m(a){return document.defaultView&&document.defaultView.getComputedStyle?document.defaultView.getComputedStyle(a,null):a.currentStyle||a.style}function s(){if(!g.xhr)for(var a=[function(){return new XMLHttpRequest},function(){return new ActiveXObject("Msxml2.XMLHTTP")},function(){return new ActiveXObject("Microsoft.XMLHTTP")}],c=0;c<a.length;c++)try{g.xhr=
a[c]();break}catch(b){}return g.xhr}var q=window.opera&&/Opera\/9/.test(navigator.userAgent),k=window.CanvasRenderingContext2D?window.CanvasRenderingContext2D.prototype:document.createElement("canvas").getContext("2d").__proto__,g=window.Canvas.Text;g.options={fallbackCharacter:" ",dontUseMoz:!1,reimplement:!1,debug:!1,autoload:!1};var l=document.getElementsByTagName("script"),l=l[l.length-1].src.split("?");g.basePath=l[0].substr(0,l[0].lastIndexOf("/")+1);if(l[1])for(var l=l[1].split("&"),n=l.length-
1;n>=0;--n){var r=l[n].split("=");g.options[r[0]]=r[1]}var o=!g.options.dontUseMoz&&k.mozDrawText&&!k.fillText;if(k.fillText&&!g.options.reimplement&&!/iphone/i.test(navigator.userAgent))return window._typeface_js={loadFace:function(){}};g.lookupFamily=function(a){var c=this.faces,b,d,e=this.equivalentFaces,f=this.genericFaces;if(c[a])return c[a];if(f[a])for(b=0;b<f[a].length;b++)if(d=this.lookupFamily(f[a][b]))return d;if(!(d=e[a]))return!1;for(b=0;b<d.length;b++)if(a=c[d[b]])return a;return!1};
g.getFace=function(a,c,b){var d=this.lookupFamily(a);if(!d)return!1;if(d&&d[c]&&d[c][b])return d[c][b];if(!this.options.autoload)return!1;var d=this.xhr,e=this.basePath+this.options.autoload+"/"+(a.replace(/[ -]/g,"_")+"-"+c+"-"+b)+".js",d=s();d.open("get",e,!1);d.send(null);if(d.status==200)return eval(d.responseText),this.faces[a][c][b];else throw"Unable to load the font ["+a+" "+c+" "+b+"]";};g.loadFace=function(a){var c=a.familyName.toLowerCase();this.faces[c]=this.faces[c]||{};a.strokeFont?(this.faces[c].normal=
this.faces[c].normal||{},this.faces[c].normal.normal=a,this.faces[c].normal.italic=a,this.faces[c].bold=this.faces[c].normal||{},this.faces[c].bold.normal=a,this.faces[c].bold.italic=a):(this.faces[c][a.cssFontWeight]=this.faces[c][a.cssFontWeight]||{},this.faces[c][a.cssFontWeight][a.cssFontStyle]=a);return a};window._typeface_js={faces:g.faces,loadFace:g.loadFace};g.getFaceFromStyle=function(a){var c=p(a.weight),b=a.family,d,e;for(d=0;d<b.length;d++)if(e=this.getFace(b[d].toLowerCase().replace(/^-webkit-/,
""),c,a.style))return e;return!1};try{k.font="10px sans-serif",k.textAlign="start",k.textBaseline="alphabetic"}catch(t){}k.parseStyle=function(a){if(g._styleCache[a])return this.getComputedStyle(g._styleCache[a]);var c={},b;if(!this._elt)this._elt=document.createElement("span"),this.canvas.appendChild(this._elt);this.canvas.font="10px sans-serif";this._elt.style.font=a;b=m(this._elt);c.size=b.fontSize;c.weight=p(b.fontWeight);c.style=b.fontStyle;b=b.fontFamily.split(",");for(i=0;i<b.length;i++)b[i]=
b[i].replace(/^["'\s]*/,"").replace(/["'\s]*$/,"");c.family=b;return this.getComputedStyle(g._styleCache[a]=c)};k.buildStyle=function(a){return a.style+" "+a.weight+" "+a.size+'px "'+a.family+'"'};k.renderText=function(a,c){var b=g.getFaceFromStyle(c),d=c.size/b.resolution*0.75,e=0,f,j=String(a).split(""),h=j.length;q||(this.scale(d,-d),this.lineWidth/=d);for(f=0;f<h;f++)e+=this.renderGlyph(j[f],b,d,e)};k.renderGlyph=q?function(a,c,b,d){var e,f,j,h=c.glyphs[a]||c.glyphs[g.options.fallbackCharacter];
if(h){if(h.o){c=h._cachedOutline||(h._cachedOutline=h.o.split(" "));j=c.length;for(a=0;a<j;)switch(e=c[a++],e){case "m":this.moveTo(c[a++]*b+d,c[a++]*-b);break;case "l":this.lineTo(c[a++]*b+d,c[a++]*-b);break;case "q":e=c[a++]*b+d;f=c[a++]*-b;this.quadraticCurveTo(c[a++]*b+d,c[a++]*-b,e,f);break;case "b":e=c[a++]*b+d,f=c[a++]*-b,this.bezierCurveTo(c[a++]*b+d,c[a++]*-b,c[a++]*b+d,c[a++]*-b,e,f)}}return h.ha*b}}:function(a,c){var b,d,e,f,j,h=c.glyphs[a]||c.glyphs[g.options.fallbackCharacter];if(h){if(h.o){f=
h._cachedOutline||(h._cachedOutline=h.o.split(" "));j=f.length;for(b=0;b<j;)switch(d=f[b++],d){case "m":this.moveTo(f[b++],f[b++]);break;case "l":this.lineTo(f[b++],f[b++]);break;case "q":d=f[b++];e=f[b++];this.quadraticCurveTo(f[b++],f[b++],d,e);break;case "b":d=f[b++],e=f[b++],this.bezierCurveTo(f[b++],f[b++],f[b++],f[b++],d,e)}}h.ha&&this.translate(h.ha,0)}};k.getTextExtents=function(a,c){var b=0,d=0,e=g.getFaceFromStyle(c),f,j=a.length,h;for(f=0;f<j;f++)h=e.glyphs[a.charAt(f)]||e.glyphs[g.options.fallbackCharacter],
b+=Math.max(h.ha,h.x_max),d+=h.ha;return{width:b,height:e.lineHeight,ha:d}};k.getComputedStyle=function(a){var c,b=m(this.canvas),d={},e=a.size,b=parseFloat(b.fontSize),f=parseFloat(e);for(c in a)d[c]=a[c];d.size=typeof e==="number"||e.indexOf("px")!=-1?f:e.indexOf("em")!=-1?b*f:e.indexOf("%")!=-1?b/100*f:e.indexOf("pt")!=-1?f/0.75:b;return d};k.getTextOffset=function(a,c,b){var d=m(this.canvas),a=this.measureText(a),c=c.size/b.resolution*0.75,e={x:0,y:0,metrics:a,scale:c};switch(this.textAlign){case "center":e.x=
-a.width/2;break;case "right":e.x=-a.width;break;case "start":e.x=d.direction=="rtl"?-a.width:0;break;case "end":e.x=d.direction=="ltr"?-a.width:0}switch(this.textBaseline){case "alphabetic":break;default:case null:case "ideographic":case "bottom":e.y=b.descender;break;case "hanging":case "top":e.y=b.ascender;break;case "middle":e.y=(b.ascender+b.descender)/2}e.y*=c;return e};k.drawText=function(a,c,b,d,e){var d=this.parseStyle(this.font),f=g.getFaceFromStyle(d),j=this.getTextOffset(a,d,f);this.save();
this.translate(c+j.x,b+j.y);if(f.strokeFont&&!e)this.strokeStyle=this.fillStyle;this.lineCap="round";this.beginPath();if(o)this.mozTextStyle=this.buildStyle(d),this[e?"mozPathText":"mozDrawText"](a);else if(this.scale(g.scaling,g.scaling),this.renderText(a,d),f.strokeFont)this.lineWidth=2+d.size*(d.weight=="bold"?0.08:0.015)/2;this[e||f.strokeFont&&!o?"stroke":"fill"]();this.closePath();this.restore();if(g.options.debug)a=Math.floor(j.x+c)+0.5,b=Math.floor(b)+0.5,this.save(),this.strokeStyle="#F00",
this.lineWidth=0.5,this.beginPath(),this.moveTo(a+j.metrics.width,b),this.lineTo(a,b),this.moveTo(a-j.x,b+j.y),this.lineTo(a-j.x,b+j.y-d.size),this.stroke(),this.closePath(),this.restore()};k.fillText=function(a,c,b,d){this.drawText(a,c,b,d,!1)};k.strokeText=function(a,c,b,d){this.drawText(a,c,b,d,!0)};k.measureText=function(a){var c=this.parseStyle(this.font),b={width:0};if(o)this.mozTextStyle=this.buildStyle(c),b.width=this.mozMeasureText(a);else{var d=g.getFaceFromStyle(c),d=c.size/d.resolution*
0.75;b.width=this.getTextExtents(a,c).ha*d*g.scaling}return b}})();
						]]><![CDATA[if (_typeface_js && _typeface_js.loadFace) _typeface_js.loadFace({"glyphs":{"ҷ":{"x_min":47,"x_max":710,"ha":724,"o":"m 710 -204 l 610 -204 l 610 0 l 509 0 l 509 291 q 299 256 396 256 q 161 293 225 256 q 69 399 93 333 q 47 532 47 460 l 47 721 l 169 721 l 169 584 q 175 476 169 505 q 229 387 187 419 q 330 358 270 358 q 509 394 399 358 l 509 721 l 631 721 l 631 100 l 710 100 l 710 -204 "},"ᴴ":{"x_min":34,"x_max":561,"ha":595,"o":"m 561 321 l 472 321 l 472 639 l 123 639 l 123 321 l 34 321 l 34 995 l 123 995 l 123 718 l 472 718 l 472 995 l 561 995 l 561 321 "},"ᵾ":{"x_min":20,"x_max":742,"ha":760,"o":"m 742 329 l 669 329 l 669 298 q 597 70 669 152 q 377 -16 521 -16 q 225 20 293 -16 q 118 133 150 60 q 92 293 92 192 l 92 329 l 20 329 l 20 419 l 92 419 l 92 721 l 214 721 l 214 419 l 547 419 l 547 721 l 669 721 l 669 419 l 742 419 l 742 329 m 547 303 l 547 329 l 214 329 l 214 293 q 251 149 214 204 q 379 84 294 84 q 471 112 428 84 q 531 187 513 141 q 547 303 547 227 "},"Ҿ":{"x_min":7,"x_max":1134,"ha":1196,"o":"m 1134 423 l 360 423 q 447 188 368 273 q 678 99 530 99 q 949 307 892 99 l 1078 273 q 948 69 1043 144 q 722 -14 856 -4 l 722 -208 l 632 -208 l 632 -14 q 434 50 524 -4 q 222 423 247 165 q 7 603 7 423 q 19 699 7 653 l 123 671 q 114 613 114 634 q 153 547 114 563 q 219 540 172 539 q 325 859 227 730 q 676 1012 440 1012 q 1026 860 907 1012 q 1134 486 1134 724 l 1134 423 m 998 540 q 914 793 991 697 q 676 901 828 901 q 438 793 524 901 q 355 540 361 697 l 998 540 "},"ӱ":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 m 169 810 l 169 949 l 297 949 l 297 810 l 169 810 m 422 810 l 422 949 l 550 949 l 550 810 l 422 810 "},"ᴭ":{"x_min":0,"x_max":888,"ha":922,"o":"m 888 321 l 448 321 l 448 515 l 189 515 l 96 321 l 0 321 l 322 995 l 875 995 l 875 916 l 538 916 l 538 708 l 851 708 l 851 629 l 538 629 l 538 400 l 888 400 l 888 321 m 448 594 l 448 916 l 381 916 l 226 594 l 448 594 "},"Á":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 347 1055 l 436 1245 l 597 1245 l 448 1055 l 347 1055 "},"ѩ":{"x_min":92,"x_max":963,"ha":966,"o":"m 963 0 l 837 0 l 745 242 l 679 242 l 679 0 l 557 0 l 557 242 l 494 242 l 403 0 l 275 0 l 371 242 l 214 242 l 214 0 l 92 0 l 92 721 l 214 721 l 214 329 l 406 329 l 562 721 l 677 721 l 963 0 m 713 329 l 618 576 l 526 329 l 713 329 "},"ѷ":{"x_min":18,"x_max":865,"ha":876,"o":"m 865 661 l 808 569 q 683 615 729 615 q 608 536 638 615 l 406 0 l 292 0 l 18 721 l 147 721 l 301 289 q 347 143 326 218 q 392 280 363 200 l 504 589 q 563 694 530 662 q 673 737 604 737 q 865 661 748 737 m 546 810 l 448 810 l 305 1000 l 464 1000 l 546 810 m 310 810 l 207 810 l 66 1000 l 223 1000 l 310 810 "},"҅":{"x_min":-71,"x_max":80,"ha":0,"o":"m 80 795 l 50 738 q -47 806 -22 767 q -71 913 -71 842 l -71 1000 l 71 1000 l 71 881 l 5 881 q 24 824 5 843 q 80 795 37 812 "},"»":{"x_min":96,"x_max":677,"ha":773,"o":"m 537 358 l 359 668 l 459 668 l 677 358 l 460 49 l 360 49 l 537 358 m 275 358 l 96 668 l 198 668 l 411 358 l 198 49 l 96 49 l 275 358 "},"ˌ":{"x_min":196,"x_max":266,"ha":463,"o":"m 266 -276 l 196 -276 l 196 -51 l 266 -51 l 266 -276 "},"∆":{"x_min":17.5,"x_max":831.984375,"ha":850,"o":"m 831 0 l 17 0 l 443 939 l 831 0 m 671 56 l 400 711 l 102 56 l 671 56 "},"˂":{"x_min":76,"x_max":734,"ha":811,"o":"m 76 435 l 76 549 l 734 827 l 734 705 l 212 491 l 734 276 l 734 154 l 76 435 "},"Ԓ":{"x_min":12.609375,"x_max":803,"ha":912,"o":"m 803 -38 q 767 -216 803 -156 q 611 -292 722 -292 q 515 -279 562 -292 l 539 -175 q 596 -185 575 -185 q 664 -132 649 -185 q 671 -34 671 -108 l 671 878 l 312 878 l 312 365 q 305 184 312 229 q 235 23 291 71 q 117 -17 188 -17 q 12 0 73 -17 l 35 115 q 90 102 67 102 q 171 172 153 102 q 180 294 180 204 l 180 995 l 803 995 l 803 -38 "},"ў":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 m 472 986 l 555 986 q 492 855 544 901 q 354 810 440 810 q 215 855 267 810 q 154 986 164 900 l 237 986 q 274 916 246 939 q 350 894 303 894 q 434 916 405 894 q 472 986 462 938 "},"«":{"x_min":91,"x_max":672,"ha":773,"o":"m 231 358 l 406 49 l 307 49 l 91 358 l 308 668 l 408 668 l 231 358 m 493 358 l 672 49 l 569 49 l 357 358 l 569 668 l 672 668 l 493 358 "},"‪":{"x_min":-24,"x_max":293,"ha":0,"o":"m 25 789 l 25 -187 l -24 -187 l -24 837 l 293 837 l 293 789 l 25 789 "},"í":{"x_min":94,"x_max":344,"ha":386,"o":"m 134 0 l 134 721 l 256 721 l 256 0 l 134 0 m 94 810 l 183 1000 l 344 1000 l 195 810 l 94 810 "},"ң":{"x_min":92,"x_max":754,"ha":767,"o":"m 754 -204 l 654 -204 l 654 0 l 553 0 l 553 320 l 214 320 l 214 0 l 92 0 l 92 721 l 214 721 l 214 420 l 553 420 l 553 721 l 675 721 l 675 100 l 754 100 l 754 -204 "},"µ":{"x_min":109,"x_max":690,"ha":800,"o":"m 690 721 l 690 0 l 581 0 l 581 86 q 511 11 545 32 q 401 -16 464 -16 q 301 6 344 -16 q 230 73 269 23 l 230 -276 l 109 -276 l 109 721 l 230 721 l 230 416 q 247 201 230 250 q 304 123 265 151 q 395 95 344 95 q 492 124 449 95 q 552 201 534 154 q 570 414 570 248 l 570 721 l 690 721 "},"Ҫ":{"x_min":69,"x_max":948,"ha":1003,"o":"m 948 315 q 799 68 906 153 q 605 -12 717 2 q 625 -139 625 -88 q 584 -247 625 -206 q 476 -289 544 -289 q 328 -247 407 -289 l 328 -166 q 441 -198 389 -198 q 512 -168 485 -198 q 539 -94 539 -139 q 525 -17 539 -58 q 121 238 228 -12 q 69 504 69 363 q 297 952 69 826 q 538 1012 406 1012 q 787 937 685 1012 q 931 722 890 862 l 801 691 q 535 899 734 899 q 351 848 428 899 q 236 696 269 795 q 205 505 205 603 q 356 142 205 233 q 525 96 434 96 q 816 348 761 96 l 948 315 "},"қ":{"x_min":91,"x_max":601,"ha":608,"o":"m 601 -204 l 501 -204 l 501 0 l 484 0 l 353 223 q 298 299 321 278 q 213 333 262 333 l 213 0 l 91 0 l 91 721 l 213 721 l 213 409 q 312 453 280 409 q 363 561 323 467 q 403 648 390 627 q 472 711 433 698 q 566 721 502 721 l 591 721 l 591 621 l 557 621 q 485 595 506 622 q 452 517 478 586 q 408 428 427 453 q 330 369 382 394 q 485 222 409 348 l 558 100 l 601 100 l 601 -204 "},"˫":{"x_min":66,"x_max":397,"ha":463,"o":"m 397 267 l 130 267 l 130 0 l 66 0 l 66 597 l 130 597 l 130 331 l 397 331 l 397 267 "},"ᵱ":{"x_min":-74.015625,"x_max":717,"ha":773,"o":"m 717 365 q 562 31 717 127 q 403 -16 486 -16 q 214 74 285 -16 l 214 -111 q 241 -117 230 -117 q 291 -58 282 -117 l 379 -58 q 246 -213 374 -213 q 214 -208 232 -213 l 214 -276 l 92 -276 l 92 -155 q 67 -150 76 -150 q 16 -215 14 -150 l -74 -215 q -38 -106 -74 -149 q 63 -60 0 -60 q 92 -63 76 -60 l 92 721 l 203 721 l 203 626 q 411 737 281 737 q 681 555 605 737 q 717 365 717 469 m 592 366 q 551 548 592 474 q 400 641 500 641 q 246 543 300 641 q 202 356 202 463 q 242 174 202 246 q 394 84 292 84 q 550 178 499 84 q 592 366 592 253 "},"ᴤ":{"x_min":43,"x_max":550,"ha":593,"o":"m 550 186 q 288 -16 508 -16 q 118 30 185 -16 q 43 184 43 83 q 88 294 43 249 q 236 352 139 344 l 236 435 q 361 451 321 435 q 420 541 420 475 q 387 610 420 584 q 302 637 355 637 q 159 515 190 637 l 43 534 q 304 737 84 737 q 474 690 407 737 q 550 536 550 637 q 504 426 550 471 q 358 368 454 375 l 358 286 q 232 269 271 286 q 173 179 173 245 q 205 110 173 136 q 290 84 237 84 q 434 206 402 84 l 550 186 "},"ѕ":{"x_min":43,"x_max":642,"ha":695,"o":"m 43 215 l 164 234 q 220 122 174 161 q 351 84 267 84 q 476 118 435 84 q 517 198 517 152 q 480 264 517 240 q 355 305 455 280 q 168 364 220 339 q 89 432 116 389 q 63 529 63 476 q 85 618 63 577 q 145 686 107 659 q 223 722 173 707 q 328 737 272 737 q 478 712 413 737 q 572 646 542 688 q 615 535 603 604 l 496 519 q 448 605 487 574 q 337 637 409 637 q 217 609 253 637 q 181 543 181 581 q 196 500 181 519 q 243 468 211 481 q 351 436 261 461 q 532 380 481 402 q 612 316 583 358 q 642 211 642 274 q 606 96 642 150 q 503 13 570 43 q 351 -16 436 -16 q 137 42 210 -16 q 43 215 63 100 "},"Ш":{"x_min":110,"x_max":1164,"ha":1273,"o":"m 110 995 l 242 995 l 242 117 l 571 117 l 571 995 l 703 995 l 703 117 l 1032 117 l 1032 995 l 1164 995 l 1164 0 l 110 0 l 110 995 "},"M":{"x_min":102,"x_max":1052,"ha":1157,"o":"m 102 0 l 102 995 l 300 995 l 535 291 q 583 143 568 192 q 636 303 600 198 l 875 995 l 1052 995 l 1052 0 l 925 0 l 925 833 l 635 0 l 517 0 l 229 847 l 229 0 l 102 0 "},"ᴻ":{"x_min":34,"x_max":562,"ha":596,"o":"m 562 321 l 481 321 l 481 854 l 124 321 l 34 321 l 34 995 l 115 995 l 115 461 l 472 995 l 562 995 l 562 321 "},"ӊ":{"x_min":92,"x_max":794,"ha":767,"o":"m 794 100 l 653 -204 l 552 -204 l 652 0 l 553 0 l 553 320 l 214 320 l 214 0 l 92 0 l 92 721 l 214 721 l 214 420 l 553 420 l 553 721 l 675 721 l 675 100 l 794 100 "},"―":{"x_min":44,"x_max":1346,"ha":1389,"o":"m 44 311 l 44 409 l 1346 409 l 1346 311 l 44 311 "},"{":{"x_min":39,"x_max":432,"ha":464,"o":"m 39 416 q 123 444 90 417 q 167 517 156 470 q 178 677 178 564 q 183 826 179 790 q 205 918 189 883 q 246 973 222 953 q 309 1005 271 994 q 393 1012 335 1012 l 432 1012 l 432 906 l 410 906 q 317 880 340 906 q 294 766 294 855 q 286 542 294 588 q 244 430 274 469 q 151 360 215 390 q 261 264 227 328 q 295 54 295 200 q 297 -103 295 -77 q 324 -167 302 -149 q 410 -186 346 -186 l 432 -186 l 432 -292 l 393 -292 q 297 -281 327 -292 q 225 -230 254 -265 q 188 -142 196 -195 q 179 33 180 -88 q 167 202 178 155 q 123 276 156 249 q 39 305 90 303 l 39 416 "},"‭":{"x_min":-158,"x_max":159,"ha":0,"o":"m 159 668 l 25 668 l 25 -187 l -24 -187 l -24 668 l -158 668 l -158 959 l 159 959 l 159 911 l -111 911 l -111 716 l 159 716 l 159 668 "},"ҿ":{"x_min":7,"x_max":867,"ha":925,"o":"m 867 362 q 866 330 867 351 l 329 330 q 386 158 335 223 q 547 84 445 84 q 738 233 684 84 l 863 217 q 589 -15 805 3 l 589 -209 l 499 -209 l 499 -14 q 282 96 361 0 q 204 330 209 186 q 7 489 7 330 q 19 585 7 532 l 123 561 q 114 504 114 531 q 148 438 114 453 q 208 430 166 430 q 296 636 224 558 q 539 737 390 737 q 787 626 698 737 q 867 362 867 525 m 738 430 q 691 566 729 520 q 540 637 633 637 q 395 577 451 637 q 335 430 341 520 l 738 430 "},"¼":{"x_min":72,"x_max":1138,"ha":1158,"o":"m 170 -39 l 917 1012 l 1023 1012 l 277 -39 l 170 -39 m 224 498 l 224 873 q 72 797 154 818 l 72 880 q 165 929 114 893 q 249 1007 217 965 l 322 1007 l 322 498 l 224 498 m 969 -21 l 969 83 l 710 83 l 710 166 l 983 488 l 1067 488 l 1067 156 l 1138 156 l 1138 83 l 1067 83 l 1067 -21 l 969 -21 m 969 156 l 969 334 l 813 156 l 969 156 "},"Ӄ":{"x_min":109,"x_max":867,"ha":927,"o":"m 867 173 q 752 -174 867 -51 q 455 -292 643 -292 q 224 -234 326 -292 q 109 -95 121 -176 l 241 -95 q 301 -148 252 -124 q 449 -179 362 -179 q 659 -88 583 -179 q 735 162 735 1 q 676 365 735 283 q 465 466 604 466 l 241 466 l 241 0 l 109 0 l 109 995 l 241 995 l 241 560 q 386 615 338 560 q 460 762 411 644 q 515 879 497 850 q 605 968 552 939 q 714 996 654 996 q 795 994 790 996 l 795 880 q 768 881 786 880 q 742 882 750 882 q 633 833 672 882 q 577 721 611 807 q 489 560 527 595 q 787 435 689 560 q 867 173 867 333 "},"Ê":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 m 480 1170 l 403 1055 l 264 1055 l 410 1245 l 540 1245 l 693 1055 l 554 1055 l 480 1170 "},")":{"x_min":86,"x_max":413,"ha":463,"o":"m 173 -292 l 86 -292 q 288 359 288 33 q 258 612 288 486 q 194 807 235 714 q 86 1011 168 868 l 173 1011 q 360 669 300 840 q 413 360 413 521 q 343 6 413 177 q 173 -292 273 -164 "},"ᵆ":{"x_min":34.3125,"x_max":799,"ha":833,"o":"m 799 680 q 713 553 799 591 q 583 524 674 535 q 468 502 514 515 l 468 483 q 492 402 468 425 q 575 380 517 380 q 684 416 657 380 q 706 472 697 433 l 786 462 q 680 328 761 361 q 575 311 636 311 q 451 334 498 311 q 406 376 424 347 q 250 311 346 311 q 56 442 106 311 q 34 559 34 501 q 35 587 34 572 l 386 587 q 375 669 385 642 q 321 730 360 707 q 247 750 287 750 q 122 648 147 750 l 36 658 q 250 819 84 819 q 431 728 363 819 q 632 819 524 819 q 748 785 702 819 q 799 680 799 747 m 711 677 q 616 754 711 754 q 529 730 569 754 q 473 663 486 705 q 467 564 467 640 q 614 597 502 579 q 683 620 665 605 q 711 677 711 641 m 386 518 l 118 518 q 249 380 130 380 q 347 419 311 380 q 386 518 381 456 "},"э":{"x_min":29,"x_max":653.1875,"ha":709,"o":"m 274 419 l 274 319 l 528 319 q 467 142 516 201 q 330 84 418 84 q 148 263 175 84 l 29 247 q 127 56 47 128 q 335 -16 207 -16 q 573 81 489 -24 q 653 360 657 187 q 565 636 653 536 q 327 737 478 737 q 131 672 206 737 q 41 508 57 608 l 160 489 q 331 636 189 636 q 464 575 412 636 q 528 419 516 515 l 274 419 "},"Ӷ":{"x_min":109,"x_max":752,"ha":752,"o":"m 752 878 l 241 878 l 241 117 l 332 117 l 332 -276 l 215 -276 l 215 0 l 109 0 l 109 995 l 752 995 l 752 878 "},"ӫ":{"x_min":47,"x_max":721,"ha":773,"o":"m 721 370 q 558 28 721 118 q 384 -16 479 -16 q 130 91 220 -16 q 47 360 47 192 q 158 656 47 560 q 384 737 250 737 q 634 631 543 737 q 721 370 721 532 m 593 429 q 536 567 581 516 q 384 636 475 636 q 231 567 292 636 q 175 429 186 516 l 593 429 m 596 329 l 172 329 q 227 158 177 224 q 384 84 284 84 q 540 159 484 84 q 596 329 589 224 m 191 810 l 191 949 l 319 949 l 319 810 l 191 810 m 444 810 l 444 949 l 572 949 l 572 810 l 444 810 "},"ԋ":{"x_min":92,"x_max":1129,"ha":1220,"o":"m 1129 298 q 1057 70 1129 152 q 837 -16 981 -16 q 685 20 753 -16 q 578 133 610 60 q 552 290 552 193 l 552 320 l 214 320 l 214 0 l 92 0 l 92 721 l 214 721 l 214 420 l 552 420 l 552 721 l 674 721 l 674 291 q 723 133 674 183 q 839 84 773 84 q 931 112 888 84 q 991 187 973 140 q 1007 303 1007 227 l 1007 421 l 1129 421 l 1129 298 "},"ш":{"x_min":96,"x_max":1018,"ha":1114,"o":"m 96 721 l 218 721 l 218 100 l 496 100 l 496 721 l 618 721 l 618 100 l 896 100 l 896 721 l 1018 721 l 1018 0 l 96 0 l 96 721 "},"Я":{"x_min":18.71875,"x_max":894,"ha":1003,"o":"m 894 0 l 894 995 l 452 995 q 250 968 320 995 q 140 873 181 941 q 99 723 99 805 q 167 545 99 617 q 378 453 235 472 q 299 403 326 427 q 190 270 242 350 l 18 0 l 183 0 l 314 207 q 409 344 372 296 q 476 410 446 391 q 536 437 505 429 q 609 442 558 442 l 762 442 l 762 0 l 894 0 m 762 556 l 479 556 q 338 574 389 556 q 261 634 287 593 q 235 723 235 675 q 286 839 235 794 q 447 885 337 885 l 762 885 l 762 556 "},"a":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 "},"˿":{"x_min":39,"x_max":424,"ha":463,"o":"m 424 -120 l 125 -120 l 238 -285 l 174 -285 l 39 -92 l 39 -83 l 174 109 l 238 109 l 125 -56 l 424 -56 l 424 -120 "},"ᴔ":{"x_min":55.984375,"x_max":1259,"ha":1311,"o":"m 1259 369 q 1098 28 1259 116 q 918 -16 1017 -16 q 765 17 836 -16 q 651 121 689 54 q 387 -16 556 -16 q 130 107 217 -16 q 56 393 54 214 l 587 393 q 531 563 584 496 q 373 637 473 637 q 188 486 231 637 l 66 503 q 375 737 126 737 q 651 602 562 737 q 919 737 755 737 q 1172 633 1081 737 q 1259 369 1259 534 m 1134 359 q 1085 551 1134 485 q 923 637 1023 637 q 759 546 817 637 q 711 357 711 469 q 759 170 711 245 q 923 84 816 84 q 1108 215 1055 84 q 1134 359 1134 280 m 582 293 l 185 293 q 239 145 192 201 q 380 84 291 84 q 523 145 468 84 q 582 293 575 202 "},"Ӣ":{"x_min":109,"x_max":889,"ha":998,"o":"m 109 995 l 228 995 l 228 207 l 756 995 l 889 995 l 889 0 l 770 0 l 770 785 l 240 0 l 109 0 l 109 995 m 289 1055 l 289 1155 l 712 1155 l 712 1055 l 289 1055 "},"⁭":{"x_min":-158,"x_max":159,"ha":0,"o":"m 25 667 l 25 -187 l -24 -187 l -24 667 l -158 667 l 0 958 l 159 667 l 25 667 "},"Z":{"x_min":27,"x_max":813,"ha":848,"o":"m 27 0 l 27 121 l 536 759 q 639 878 590 827 l 85 878 l 85 995 l 797 995 l 797 878 l 238 188 l 178 117 l 813 117 l 813 0 l 27 0 "}," ":{"x_min":0,"x_max":0,"ha":231,"o":"m 0 0 l 0 0 "},"k":{"x_min":92.234375,"x_max":690,"ha":695,"o":"m 92 0 l 92 995 l 214 995 l 214 428 l 503 721 l 662 721 l 386 452 l 690 0 l 539 0 l 299 368 l 214 285 l 214 0 l 92 0 "},"₯":{"x_min":28,"x_max":1371,"ha":1389,"o":"m 1371 194 q 1311 48 1371 102 q 1161 -3 1255 -3 q 1030 49 1088 -3 l 979 -189 q 945 -276 971 -228 l 811 -276 q 851 -184 826 -252 l 938 186 q 1018 325 958 271 q 1168 381 1082 381 q 1311 332 1256 381 q 1371 194 1371 280 m 991 597 q 899 198 991 358 q 564 0 786 0 q 417 48 488 0 q 329 120 373 84 q 158 0 267 0 q 28 124 28 0 q 65 213 28 177 q 156 249 103 249 q 252 223 210 249 q 292 434 273 339 q 372 766 339 665 q 474 965 412 891 q 184 899 280 954 l 171 940 q 523 1012 311 1011 q 718 1166 571 1064 l 752 1147 q 635 1012 707 1102 q 991 597 991 986 m 1270 185 q 1243 276 1270 236 q 1163 321 1212 321 q 1079 276 1112 321 q 1049 185 1049 236 q 1080 93 1049 135 q 1163 49 1114 49 q 1242 94 1210 49 q 1270 185 1270 135 m 855 591 q 811 841 855 756 q 604 965 752 955 q 516 768 563 906 q 441 466 489 685 q 357 168 397 264 q 439 101 384 145 q 550 64 491 64 q 790 253 707 64 q 855 591 855 400 m 244 167 q 156 197 199 197 q 104 176 126 197 q 82 124 82 155 q 158 57 82 57 q 228 103 207 57 q 244 167 233 115 "},"Ù":{"x_min":109,"x_max":891,"ha":1003,"o":"m 759 995 l 891 995 l 891 420 q 857 181 891 270 q 734 38 823 93 q 502 -17 646 -17 q 273 31 362 -17 q 146 170 184 79 q 109 420 109 261 l 109 995 l 241 995 l 241 420 q 265 229 241 291 q 347 135 289 168 q 490 102 406 102 q 697 167 635 102 q 759 420 759 233 l 759 995 m 589 1055 l 491 1055 l 334 1245 l 497 1245 l 589 1055 "},"ᵗ":{"x_min":34,"x_max":271,"ha":305,"o":"m 271 322 q 208 315 235 315 q 104 366 126 315 q 94 464 94 389 l 94 744 l 34 744 l 34 808 l 94 808 l 94 928 l 176 978 l 176 808 l 259 808 l 259 744 l 176 744 l 176 459 q 182 410 176 423 q 222 392 192 392 q 259 395 235 392 l 271 322 "},"Ҷ":{"x_min":59,"x_max":908,"ha":926,"o":"m 908 -276 l 791 -276 l 791 0 l 685 0 l 685 400 q 375 335 507 335 q 202 377 281 335 q 86 506 115 424 q 59 702 59 582 l 59 995 l 191 995 l 191 714 q 392 449 191 449 q 685 510 531 449 l 685 995 l 817 995 l 817 117 l 908 117 l 908 -276 "},"¢":{"x_min":73,"x_max":702,"ha":773,"o":"m 505 606 l 353 87 q 395 81 376 81 q 517 129 466 81 q 581 264 569 177 l 702 250 q 595 52 679 124 q 397 -19 511 -19 q 327 -9 364 -19 l 247 -277 l 171 -255 l 250 13 q 122 138 172 50 q 73 356 73 225 q 112 563 73 477 q 231 693 152 650 q 392 737 310 737 q 460 732 416 737 l 537 995 l 612 973 l 535 710 q 638 631 602 681 q 689 508 674 582 l 570 490 q 505 606 553 566 m 432 637 q 398 639 410 639 q 294 608 343 639 q 222 512 246 577 q 198 362 198 448 q 219 211 198 273 q 281 120 241 150 l 432 637 "},"⁯":{"x_min":-158,"x_max":159,"ha":0,"o":"m -158 715 l -24 715 l -24 910 l -158 910 l -158 958 l 25 958 l 25 715 l 159 715 l 159 667 l 25 667 l 25 -187 l -24 -187 l -24 667 l -158 667 l -158 715 "},"˖":{"x_min":113,"x_max":349,"ha":463,"o":"m 349 199 l 266 199 l 266 121 l 196 121 l 196 199 l 113 199 l 113 269 l 196 269 l 196 346 l 266 346 l 266 269 l 349 269 l 349 199 "},"В":{"x_min":102,"x_max":852,"ha":926,"o":"m 102 0 l 102 995 l 474 995 q 657 964 588 995 q 765 871 726 934 q 804 740 804 808 q 769 620 804 676 q 664 529 734 563 q 803 438 754 502 q 852 288 852 375 q 822 158 852 218 q 749 65 793 98 q 640 16 706 33 q 480 0 575 0 l 102 0 m 234 576 l 448 576 q 573 587 535 576 q 648 637 623 602 q 674 724 674 672 q 650 812 674 774 q 582 864 626 850 q 432 878 538 878 l 234 878 l 234 576 m 234 117 l 481 117 q 570 121 544 117 q 646 148 615 129 q 696 204 676 167 q 716 288 716 240 q 687 384 716 343 q 608 442 658 425 q 463 459 557 459 l 234 459 l 234 117 "},"І":{"x_min":130,"x_max":262,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 "},"≠":{"x_min":53,"x_max":709,"ha":762,"o":"m 336 283 l 204 -19 l 112 -19 l 244 283 l 53 283 l 53 397 l 294 397 l 376 585 l 53 585 l 53 699 l 426 699 l 558 1000 l 650 1000 l 518 699 l 709 699 l 709 585 l 468 585 l 386 397 l 709 397 l 709 283 l 336 283 "},"‼":{"x_min":119,"x_max":574,"ha":695,"o":"m 156 247 l 119 774 l 119 995 l 270 995 l 270 774 l 235 247 l 156 247 m 124 0 l 124 139 l 265 139 l 265 0 l 124 0 m 460 247 l 423 774 l 423 995 l 574 995 l 574 774 l 539 247 l 460 247 m 428 0 l 428 139 l 569 139 l 569 0 l 428 0 "},"Ғ":{"x_min":-2,"x_max":752,"ha":752,"o":"m 752 878 l 241 878 l 241 543 l 513 543 l 513 453 l 241 453 l 241 0 l 109 0 l 109 453 l -2 453 l -2 543 l 109 543 l 109 995 l 752 995 l 752 878 "},"¥":{"x_min":-2,"x_max":769,"ha":773,"o":"m 324 0 l 324 222 l 42 222 l 42 316 l 324 316 l 324 413 l 42 413 l 42 513 l 273 513 l -2 995 l 134 995 l 330 644 q 382 540 363 584 q 438 649 397 575 l 624 995 l 769 995 l 494 513 l 726 513 l 726 413 l 446 413 l 446 316 l 726 316 l 726 222 l 446 222 l 446 0 l 324 0 "},"U":{"x_min":109,"x_max":891,"ha":1003,"o":"m 759 995 l 891 995 l 891 420 q 857 181 891 270 q 734 38 823 93 q 502 -17 646 -17 q 273 31 362 -17 q 146 170 184 79 q 109 420 109 261 l 109 995 l 241 995 l 241 420 q 265 229 241 291 q 347 135 289 168 q 490 102 406 102 q 697 167 635 102 q 759 420 759 233 l 759 995 "},"ᴷ":{"x_min":34,"x_max":590,"ha":590,"o":"m 590 321 l 472 321 l 232 661 l 123 554 l 123 321 l 34 321 l 34 995 l 123 995 l 123 661 l 457 995 l 577 995 l 295 722 l 590 321 "},"Ñ":{"x_min":106,"x_max":889,"ha":1003,"o":"m 106 0 l 106 995 l 240 995 l 763 213 l 763 995 l 889 995 l 889 0 l 754 0 l 232 781 l 232 0 l 106 0 m 290 1053 q 328 1165 289 1123 q 427 1207 367 1207 q 541 1171 469 1207 q 605 1151 581 1151 q 638 1162 627 1151 q 655 1210 650 1174 l 743 1210 q 704 1093 740 1132 q 610 1055 667 1055 q 498 1093 567 1055 q 431 1118 452 1118 q 394 1101 408 1118 q 380 1053 379 1085 l 290 1053 "},"F":{"x_min":114,"x_max":784,"ha":848,"o":"m 114 0 l 114 995 l 784 995 l 784 878 l 246 878 l 246 569 l 711 569 l 711 452 l 246 452 l 246 0 l 114 0 "},"ᵸ":{"x_min":68,"x_max":461,"ha":528,"o":"m 461 323 l 379 323 l 379 538 l 150 538 l 150 323 l 68 323 l 68 808 l 150 808 l 150 607 l 379 607 l 379 808 l 461 808 l 461 323 "},"Ӹ":{"x_min":114,"x_max":1114,"ha":1230,"o":"m 114 995 l 246 995 l 246 570 l 483 570 q 789 483 716 570 q 863 288 863 397 q 784 86 863 173 q 492 0 705 0 l 114 0 l 114 995 m 246 112 l 486 112 q 666 153 610 112 q 722 287 722 195 q 688 391 722 349 q 600 445 654 433 q 422 457 547 457 l 246 457 l 246 112 m 982 995 l 1114 995 l 1114 0 l 982 0 l 982 995 m 414 1055 l 414 1194 l 542 1194 l 542 1055 l 414 1055 m 667 1055 l 667 1194 l 795 1194 l 795 1055 l 667 1055 "},"Ԝ":{"x_min":17,"x_max":1296,"ha":1312,"o":"m 279 0 l 17 995 l 151 995 l 303 342 q 345 139 326 239 q 390 322 383 298 l 579 995 l 738 995 l 880 491 q 958 139 934 304 q 1008 355 977 233 l 1163 995 l 1296 995 l 1024 0 l 896 0 l 687 757 q 655 874 660 852 q 625 757 639 805 l 416 0 l 279 0 "},"Ќ":{"x_min":109,"x_max":805,"ha":809,"o":"m 109 995 l 241 995 l 241 560 q 367 594 331 560 q 461 762 404 629 q 529 900 502 860 q 605 968 556 941 q 715 996 655 996 q 795 994 790 996 l 795 880 q 768 881 788 880 q 742 882 746 882 q 648 851 679 882 q 577 721 617 820 q 492 562 527 594 q 409 509 457 529 q 600 331 506 483 l 805 0 l 641 0 l 474 270 q 360 424 406 382 q 241 466 314 466 l 241 0 l 109 0 l 109 995 m 357 1055 l 446 1245 l 607 1245 l 458 1055 l 357 1055 "},"∕":{"x_min":-308.578125,"x_max":544.5,"ha":232,"o":"m -308 -39 l 437 1011 l 544 1011 l -202 -39 l -308 -39 "},"‏":{"x_min":-291,"x_max":24,"ha":0,"o":"m 24 -187 l -24 -187 l -24 789 l -204 789 l -111 701 l -144 668 l -291 812 l -144 958 l -111 925 l -204 837 l 24 837 l 24 -187 "},"҄":{"x_min":-220,"x_max":222,"ha":0,"o":"m 222 832 l 178 832 q 156 896 178 870 q 94 925 132 925 q -9 878 71 925 q -142 832 -89 832 l -220 832 l -220 932 l -142 932 q -32 965 -103 932 q 76 998 38 998 q 222 832 222 998 "},"å":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 273 938 q 309 1024 273 988 q 395 1060 346 1060 q 482 1023 446 1060 q 518 935 518 987 q 482 846 518 882 q 396 810 446 810 q 309 846 345 810 q 273 938 273 883 m 325 937 q 346 883 325 905 q 397 862 368 862 q 447 883 426 862 q 469 936 469 905 q 448 988 469 966 q 397 1010 427 1010 q 346 988 368 1010 q 325 937 325 967 "},"ː":{"x_min":123,"x_max":262,"ha":386,"o":"m 262 721 l 200 582 l 184 582 l 123 721 l 262 721 m 262 0 l 123 0 l 184 139 l 200 139 l 262 0 "},"0":{"x_min":58,"x_max":707,"ha":773,"o":"m 58 490 q 94 774 58 667 q 202 940 130 882 q 382 999 273 999 q 523 966 462 999 q 623 873 583 934 q 684 725 662 813 q 707 490 707 638 q 671 207 707 315 q 563 41 635 99 q 382 -17 491 -17 q 156 85 238 -17 q 58 490 58 210 m 183 490 q 240 163 183 244 q 382 83 298 83 q 524 164 466 83 q 582 490 582 245 q 524 817 582 736 q 381 898 467 898 q 246 826 296 898 q 183 490 183 735 "},"”":{"x_min":48,"x_max":400,"ha":463,"o":"m 59 862 l 59 1004 l 190 1004 l 190 892 q 168 760 190 800 q 78 678 139 705 l 48 726 q 102 773 84 741 q 122 862 120 805 l 59 862 m 269 862 l 269 1004 l 400 1004 l 400 892 q 378 760 400 800 q 288 678 349 705 l 258 726 q 312 773 294 741 q 332 862 330 805 l 269 862 "},"Ӕ":{"x_min":0.5,"x_max":1313,"ha":1389,"o":"m 0 0 l 479 995 l 1295 995 l 1295 878 l 795 878 l 795 572 l 1260 572 l 1260 455 l 795 455 l 795 117 l 1313 117 l 1313 0 l 663 0 l 663 287 l 280 287 l 142 0 l 0 0 m 337 404 l 663 404 l 663 878 l 565 878 l 337 404 "},"ᵠ":{"x_min":34,"x_max":577,"ha":611,"o":"m 577 586 q 481 374 577 462 q 349 311 430 328 l 349 136 l 268 136 l 268 311 q 98 395 166 311 q 34 578 34 475 q 84 741 34 671 q 230 819 140 821 l 213 748 q 119 581 119 716 q 156 454 119 506 q 268 383 196 398 l 268 685 q 305 803 268 777 q 373 820 331 820 q 548 709 493 820 q 577 586 577 651 m 490 594 q 471 694 490 651 q 395 751 445 751 q 353 719 363 751 q 349 661 349 703 l 349 387 q 456 463 418 399 q 490 594 490 519 "},"҆":{"x_min":-71,"x_max":80,"ha":0,"o":"m 80 913 q 56 806 80 842 q -41 738 31 767 l -71 795 q -15 824 -28 812 q 3 881 3 843 l -62 881 l -62 1000 l 80 1000 l 80 913 "},"ö":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 m 205 810 l 205 949 l 333 949 l 333 810 l 205 810 m 458 810 l 458 949 l 586 949 l 586 810 l 458 810 "},"ᵶ":{"x_min":27,"x_max":665,"ha":695,"o":"m 665 0 l 27 0 l 27 99 l 243 347 q 195 356 207 356 q 144 292 142 356 l 54 292 q 89 400 53 357 q 191 446 127 446 q 312 426 225 446 l 485 626 q 347 622 407 622 l 54 622 l 54 721 l 643 721 l 643 640 l 436 398 q 490 390 474 390 q 540 448 531 390 l 628 448 q 495 294 623 294 q 368 317 462 294 l 252 182 l 177 99 q 331 105 259 105 l 665 105 l 665 0 "},"ᴪ":{"x_min":83,"x_max":907,"ha":990,"o":"m 907 598 q 888 411 907 470 q 775 269 861 324 q 556 213 695 217 l 556 0 l 434 0 l 434 213 q 161 312 249 218 q 92 445 108 370 q 83 598 83 491 l 83 721 l 205 721 l 205 594 q 215 460 205 502 q 290 355 233 393 q 434 315 342 319 l 434 721 l 556 721 l 556 315 q 767 438 728 324 q 785 594 785 489 l 785 721 l 907 721 l 907 598 "},"þ":{"x_min":92,"x_max":717,"ha":773,"o":"m 92 -276 l 92 995 l 214 995 l 214 644 q 300 713 263 696 q 411 737 349 737 q 574 689 504 737 q 681 555 645 642 q 717 365 717 469 q 677 166 717 254 q 562 31 637 78 q 403 -16 486 -16 q 299 6 347 -16 q 214 74 262 23 l 214 -276 l 92 -276 m 202 356 q 258 150 202 216 q 394 84 314 84 q 534 152 476 84 q 592 366 592 221 q 535 572 592 503 q 400 641 478 641 q 262 568 322 641 q 202 356 202 495 "},"]":{"x_min":27,"x_max":296,"ha":386,"o":"m 296 -276 l 27 -276 l 27 -176 l 174 -176 l 174 895 l 27 895 l 27 995 l 296 995 l 296 -276 "},"ᵍ":{"x_min":34,"x_max":463,"ha":524,"o":"m 463 386 q 449 251 463 295 q 366 150 428 184 q 242 123 316 123 q 107 158 158 123 q 50 281 47 199 l 130 268 q 158 214 134 232 q 242 192 189 192 q 373 279 350 192 q 380 385 380 304 q 244 321 325 321 q 87 396 144 321 q 34 567 34 464 q 132 787 34 721 q 245 819 179 819 q 387 747 330 819 l 387 808 l 463 808 l 463 386 m 386 570 q 355 691 386 642 q 250 750 318 750 q 148 692 182 750 q 119 573 119 644 q 251 390 119 390 q 357 447 322 390 q 386 570 386 494 "},"А":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 "},"₥":{"x_min":92,"x_max":1068,"ha":1157,"o":"m 1068 0 l 946 0 l 946 453 q 939 542 946 515 q 891 611 928 587 q 818 631 860 631 q 741 615 775 631 l 642 411 l 642 0 l 520 0 l 520 161 l 377 -132 l 258 -132 l 520 403 l 520 468 q 392 631 520 631 q 233 524 273 631 q 214 373 214 472 l 214 0 l 92 0 l 92 721 l 201 721 l 201 619 q 419 737 276 737 q 622 612 576 737 l 760 896 l 878 896 l 798 732 q 845 737 822 737 q 1068 494 1068 737 l 1068 0 "},"′":{"x_min":86.859375,"x_max":269.9375,"ha":260,"o":"m 86 643 l 95 828 l 130 995 l 269 995 l 234 828 l 162 643 l 86 643 "},"Ы":{"x_min":114,"x_max":1114,"ha":1230,"o":"m 114 995 l 246 995 l 246 570 l 483 570 q 789 483 716 570 q 863 288 863 397 q 784 86 863 173 q 492 0 705 0 l 114 0 l 114 995 m 246 112 l 486 112 q 666 153 610 112 q 722 287 722 195 q 688 391 722 349 q 600 445 654 433 q 422 457 547 457 l 246 457 l 246 112 m 982 995 l 1114 995 l 1114 0 l 982 0 l 982 995 "},"8":{"x_min":56,"x_max":712,"ha":773,"o":"m 245 540 q 132 619 169 567 q 96 742 96 670 q 174 925 96 851 q 381 999 252 999 q 591 923 512 999 q 671 739 671 847 q 634 619 671 670 q 524 540 598 567 q 664 443 616 510 q 712 284 712 377 q 621 69 712 156 q 384 -17 531 -17 q 146 70 236 -17 q 56 288 56 157 q 105 450 56 385 q 245 540 154 516 m 221 747 q 266 631 221 676 q 384 587 311 587 q 501 631 456 587 q 546 740 546 675 q 499 853 546 807 q 383 899 453 899 q 266 854 312 899 q 221 747 221 809 m 181 287 q 205 185 181 234 q 279 109 230 136 q 385 83 328 83 q 530 139 473 83 q 587 282 587 195 q 528 429 587 371 q 380 487 469 487 q 237 429 294 487 q 181 287 181 372 "},"₵":{"x_min":69,"x_max":948,"ha":1003,"o":"m 948 315 q 799 67 906 152 q 567 -17 701 -9 l 567 -144 l 495 -144 l 495 -16 q 121 237 222 0 q 69 504 69 362 q 297 951 69 826 q 495 1010 389 1002 l 495 1086 l 567 1086 l 567 1011 q 798 929 703 1004 q 931 721 892 854 l 801 691 q 567 898 740 883 l 567 96 q 816 348 767 120 l 948 315 m 495 96 l 495 897 q 236 696 297 878 q 205 505 205 603 q 356 141 205 232 q 495 96 421 102 "},"ѯ":{"x_min":21,"x_max":609,"ha":637,"o":"m 609 -276 l 506 -276 q 461 -225 506 -225 q 374 -258 454 -225 q 245 -292 295 -292 q 88 -250 146 -292 q 21 -108 21 -203 q 111 42 21 -6 q 294 82 183 82 q 408 109 361 82 q 465 206 465 143 q 441 276 465 243 q 384 319 418 309 q 278 327 357 327 q 251 326 272 327 l 251 422 q 335 424 321 422 q 434 528 434 439 q 401 608 434 580 q 316 637 369 637 q 172 515 213 637 l 56 534 q 228 725 97 688 l 119 964 l 217 964 l 317 737 l 396 892 q 503 972 436 972 q 592 909 563 972 l 535 879 q 513 900 525 900 q 477 859 496 900 l 410 724 q 489 682 454 710 q 564 523 564 623 q 478 383 564 435 q 587 202 587 324 q 494 32 587 89 q 298 -16 417 -16 q 200 -33 240 -16 q 146 -108 146 -58 q 244 -191 146 -191 q 359 -152 282 -191 q 468 -114 436 -114 q 573 -163 533 -114 q 609 -276 609 -208 "},"Ӝ":{"x_min":5,"x_max":1277,"ha":1283,"o":"m 709 995 l 709 560 q 842 595 805 560 q 934 762 878 631 q 1002 900 975 860 q 1078 968 1029 941 q 1187 996 1128 996 q 1267 994 1251 996 l 1267 880 q 1241 880 1260 880 q 1214 881 1219 881 q 1121 851 1151 881 q 1050 721 1090 820 q 975 574 1006 613 q 883 509 943 535 q 1072 331 980 482 l 1277 0 l 1114 0 l 947 269 q 836 421 881 377 q 709 466 790 466 l 709 0 l 574 0 l 574 466 q 459 431 509 466 q 343 283 409 397 l 335 269 l 168 0 l 5 0 l 209 331 q 399 509 303 483 q 312 567 346 531 q 231 721 278 603 q 158 854 189 827 q 67 882 128 882 l 15 880 l 15 994 q 90 996 22 996 q 203 969 156 996 q 278 902 251 942 q 348 762 305 861 q 440 595 405 629 q 574 560 476 561 l 574 995 l 709 995 m 449 1055 l 449 1194 l 577 1194 l 577 1055 l 449 1055 m 702 1055 l 702 1194 l 830 1194 l 830 1055 l 702 1055 "},"ѡ":{"x_min":11,"x_max":856,"ha":867,"o":"m 856 721 l 630 0 l 502 0 l 410 242 l 332 0 l 204 0 l 50 406 q 11 721 23 477 l 137 721 q 143 592 139 649 q 168 416 153 455 l 268 148 l 346 410 q 309 721 321 485 l 435 721 q 441 592 437 649 q 466 416 451 455 l 566 148 l 737 721 l 856 721 "},"ᵀ":{"x_min":34,"x_max":567,"ha":601,"o":"m 567 916 l 345 916 l 345 321 l 256 321 l 256 916 l 34 916 l 34 995 l 567 995 l 567 916 "},"R":{"x_min":109,"x_max":984.28125,"ha":1003,"o":"m 109 0 l 109 995 l 550 995 q 752 968 683 995 q 862 873 821 941 q 904 723 904 805 q 835 545 904 617 q 624 453 767 472 q 703 403 676 427 q 812 270 760 350 l 984 0 l 819 0 l 688 207 q 593 344 630 296 q 526 410 556 391 q 466 437 497 429 q 393 442 444 442 l 241 442 l 241 0 l 109 0 m 241 556 l 523 556 q 664 574 613 556 q 741 634 715 593 q 768 723 768 675 q 716 839 768 794 q 555 885 665 885 l 241 885 l 241 556 "},"Ң":{"x_min":112,"x_max":982,"ha":1003,"o":"m 982 -276 l 865 -276 l 865 0 l 759 0 l 759 469 l 244 469 l 244 0 l 112 0 l 112 995 l 244 995 l 244 586 l 759 586 l 759 995 l 891 995 l 891 117 l 982 117 l 982 -276 "},"õ":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 m 162 808 q 200 920 161 878 q 299 962 239 962 q 413 926 341 962 q 477 906 453 906 q 510 917 499 906 q 527 965 522 929 l 615 965 q 576 848 612 887 q 482 810 539 810 q 370 848 439 810 q 303 873 324 873 q 266 856 280 873 q 252 808 251 840 l 162 808 "},"ҭ":{"x_min":26,"x_max":610,"ha":636,"o":"m 610 621 l 379 621 l 379 100 l 458 100 l 458 -204 l 358 -204 l 358 0 l 257 0 l 257 621 l 26 621 l 26 721 l 610 721 l 610 621 "},"ғ":{"x_min":8,"x_max":507,"ha":507,"o":"m 507 621 l 214 621 l 214 440 l 371 440 l 371 350 l 214 350 l 214 0 l 92 0 l 92 350 l 8 350 l 8 440 l 92 440 l 92 721 l 507 721 l 507 621 "},"Ӎ":{"x_min":103,"x_max":1177,"ha":1157,"o":"m 1177 117 l 1049 -276 l 932 -276 l 1025 0 l 925 0 l 925 832 l 636 0 l 517 0 l 230 847 l 230 0 l 103 0 l 103 995 l 301 995 l 536 290 q 583 143 565 202 q 636 302 602 205 l 875 995 l 1052 995 l 1052 117 l 1177 117 "},"˙":{"x_min":156,"x_max":307,"ha":463,"o":"m 156 810 l 156 962 l 307 962 l 307 810 l 156 810 "},"ê":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 m 384 925 l 307 810 l 168 810 l 314 1000 l 444 1000 l 597 810 l 458 810 l 384 925 "},"″":{"x_min":34.859375,"x_max":430.9375,"ha":492,"o":"m 34 643 l 43 828 l 78 995 l 217 995 l 182 828 l 110 643 l 34 643 m 247 643 l 256 828 l 291 995 l 430 995 l 395 828 l 323 643 l 247 643 "},"„":{"x_min":48,"x_max":400,"ha":463,"o":"m 59 0 l 59 142 l 190 142 l 190 30 q 168 -101 190 -61 q 78 -184 139 -156 l 48 -135 q 102 -88 84 -120 q 122 0 120 -56 l 59 0 m 269 0 l 269 142 l 400 142 l 400 30 q 378 -101 400 -61 q 288 -184 349 -156 l 258 -135 q 312 -88 294 -120 q 332 0 330 -56 l 269 0 "},"ӷ":{"x_min":92,"x_max":507,"ha":507,"o":"m 507 621 l 214 621 l 214 100 l 293 100 l 293 -204 l 193 -204 l 193 0 l 92 0 l 92 721 l 507 721 l 507 621 "},"ч":{"x_min":46,"x_max":632,"ha":724,"o":"m 46 721 l 168 721 l 168 584 q 178 456 168 496 q 229 387 189 417 q 330 358 269 358 q 510 394 399 358 l 510 721 l 632 721 l 632 0 l 510 0 l 510 291 q 299 256 397 256 q 153 297 216 256 q 68 399 90 339 q 46 532 46 460 l 46 721 "},"Â":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 450 1170 l 373 1055 l 234 1055 l 380 1245 l 510 1245 l 663 1055 l 524 1055 l 450 1170 "},"ҫ":{"x_min":54,"x_max":682,"ha":695,"o":"m 682 248 q 581 54 662 124 q 461 -7 529 9 q 483 -138 483 -86 q 442 -247 483 -206 q 334 -289 402 -289 q 186 -247 265 -289 l 186 -166 q 299 -198 247 -198 q 370 -168 343 -198 q 397 -94 397 -139 q 383 -16 397 -56 l 382 -16 q 134 92 221 -16 q 54 357 54 192 q 210 693 54 606 q 382 737 289 737 q 670 509 625 737 l 551 491 q 386 637 517 637 q 179 361 179 637 q 380 84 179 84 q 562 264 536 84 l 682 248 "},"ᵪ":{"x_min":0,"x_max":477,"ha":477,"o":"m 477 -276 l 382 -276 l 238 -13 l 92 -276 l 0 -276 l 193 69 l 14 397 l 105 397 l 239 153 l 375 397 l 467 397 l 285 70 l 477 -276 "},"´":{"x_min":151,"x_max":401,"ha":463,"o":"m 151 810 l 240 1000 l 401 1000 l 252 810 l 151 810 "},"‫":{"x_min":-292,"x_max":25,"ha":0,"o":"m -292 789 l -292 837 l 25 837 l 25 -187 l -24 -187 l -24 789 l -292 789 "},"˞":{"x_min":-20.625,"x_max":359,"ha":463,"o":"m 359 279 q 210 241 278 241 q 52 415 76 241 l -3 408 l -20 511 l 139 538 l 154 448 q 170 384 162 401 q 222 351 187 351 q 339 392 253 351 l 359 279 "},"⅍":{"x_min":6,"x_max":1290,"ha":1310,"o":"m 1290 168 q 1213 28 1290 78 q 1054 -16 1148 -16 q 805 170 838 -16 l 903 187 q 1054 65 919 65 q 1143 84 1107 65 q 1188 157 1188 109 q 1140 220 1188 198 q 1057 243 1125 227 q 906 291 948 271 q 821 425 821 332 q 890 553 821 508 q 1036 593 950 593 q 1268 429 1240 593 l 1171 417 q 1044 512 1157 512 q 917 437 917 512 q 967 375 917 395 q 1054 350 979 371 q 1201 304 1160 322 q 1290 168 1290 266 m 1113 995 l 379 -39 l 273 -39 l 1006 995 l 1113 995 m 536 411 l 432 411 l 367 589 l 173 589 l 109 411 l 6 411 l 230 995 l 312 995 l 536 411 m 339 671 l 270 873 l 202 671 l 339 671 "},"И":{"x_min":109,"x_max":889,"ha":998,"o":"m 109 995 l 228 995 l 228 207 l 756 995 l 889 995 l 889 0 l 770 0 l 770 785 l 240 0 l 109 0 l 109 995 "},"ᵨ":{"x_min":34,"x_max":493,"ha":527,"o":"m 493 153 q 435 -18 493 49 q 271 -90 374 -90 q 105 2 167 -90 q 176 -173 108 -137 q 315 -193 213 -193 q 393 -194 381 -193 q 461 -223 440 -199 q 483 -292 477 -242 l 410 -292 q 391 -274 405 -276 q 299 -276 352 -276 q 83 -188 143 -276 q 34 51 34 -115 q 46 223 34 167 q 133 367 68 314 q 268 408 182 408 q 461 294 395 408 q 493 153 493 239 m 407 152 q 375 278 407 226 q 268 342 337 342 q 160 287 198 342 q 127 166 127 240 q 157 38 127 87 q 269 -21 194 -21 q 375 32 338 -21 q 407 152 407 79 "},"Љ":{"x_min":9,"x_max":1416,"ha":1468,"o":"m 799 995 l 799 570 l 1036 570 q 1275 532 1200 570 q 1382 427 1349 494 q 1416 289 1416 360 q 1368 124 1416 196 q 1252 26 1320 52 q 1055 0 1184 0 l 667 0 l 667 878 l 309 878 l 309 365 q 294 136 309 209 q 232 23 279 63 q 113 -17 185 -17 q 9 -1 70 -17 l 32 115 q 87 102 64 102 q 154 135 132 102 q 177 294 177 169 l 177 995 l 799 995 m 799 112 l 1061 112 q 1174 125 1133 112 q 1245 180 1216 139 q 1275 285 1275 220 q 1243 389 1275 347 q 1158 444 1212 431 q 975 457 1105 457 l 799 457 l 799 112 "},"р":{"x_min":92,"x_max":717,"ha":773,"o":"m 92 -276 l 92 721 l 203 721 l 203 626 q 291 709 242 681 q 411 737 341 737 q 574 689 504 737 q 681 555 645 642 q 717 365 717 469 q 677 166 717 255 q 562 31 637 78 q 403 -16 486 -16 q 293 9 342 -16 q 214 74 245 35 l 214 -276 l 92 -276 m 202 356 q 258 150 202 216 q 394 84 314 84 q 534 152 476 84 q 592 366 592 221 q 535 572 592 503 q 400 641 478 641 q 262 568 322 641 q 202 356 202 495 "},"т":{"x_min":27,"x_max":611,"ha":636,"o":"m 27 721 l 611 721 l 611 621 l 380 621 l 380 0 l 258 0 l 258 621 l 27 621 l 27 721 "},"П":{"x_min":109,"x_max":890,"ha":998,"o":"m 109 995 l 890 995 l 890 0 l 758 0 l 758 878 l 241 878 l 241 0 l 109 0 l 109 995 "},"Ö":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 m 358 1055 l 358 1194 l 486 1194 l 486 1055 l 358 1055 m 611 1055 l 611 1194 l 739 1194 l 739 1055 l 611 1055 "},"ᵣ":{"x_min":68,"x_max":333,"ha":333,"o":"m 333 381 l 304 305 q 243 323 274 323 q 164 261 183 323 q 151 165 151 218 l 151 -90 l 68 -90 l 68 397 l 143 397 l 143 323 q 247 408 189 408 q 333 381 290 408 "},"z":{"x_min":27.125,"x_max":665.125,"ha":695,"o":"m 27 0 l 27 98 l 485 626 q 347 622 407 622 l 54 622 l 54 721 l 643 721 l 643 640 l 252 182 l 177 99 q 331 105 259 105 l 665 105 l 665 0 l 27 0 "},"™":{"x_min":152,"x_max":1208,"ha":1389,"o":"m 331 442 l 331 913 l 152 913 l 152 995 l 603 995 l 603 913 l 423 913 l 423 442 l 331 442 m 665 442 l 665 995 l 800 995 l 940 553 l 1075 995 l 1208 995 l 1208 442 l 1124 442 l 1124 906 l 982 442 l 899 442 l 750 913 l 750 442 l 665 442 "},"É":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 m 382 1055 l 471 1245 l 632 1245 l 483 1055 l 382 1055 "},"ұ":{"x_min":14,"x_max":682,"ha":695,"o":"m 682 721 l 409 0 l 628 0 l 628 -90 l 409 -90 l 409 -276 l 287 -276 l 287 -90 l 68 -90 l 68 0 l 287 0 l 14 721 l 144 721 l 294 302 q 346 135 325 216 q 400 302 366 209 l 551 721 l 682 721 "},"ѿ":{"x_min":11,"x_max":856,"ha":867,"o":"m 856 721 l 630 0 l 502 0 l 410 242 l 332 0 l 204 0 l 50 406 q 11 721 23 477 l 137 721 q 143 592 139 649 q 168 416 153 455 l 268 148 l 346 410 q 309 721 321 485 l 435 721 q 441 592 437 649 q 466 416 451 455 l 566 148 l 737 721 l 856 721 m 731 942 l 669 810 l 646 810 l 615 878 l 464 878 l 432 810 l 408 810 l 377 878 l 226 878 l 194 810 l 171 810 l 110 942 l 731 942 "},"и":{"x_min":92,"x_max":684,"ha":776,"o":"m 92 721 l 214 721 l 214 171 l 552 721 l 684 721 l 684 0 l 562 0 l 562 546 l 223 0 l 92 0 l 92 721 "},"³":{"x_min":22,"x_max":438,"ha":463,"o":"m 22 629 l 121 639 q 156 583 134 598 q 225 563 185 563 q 302 589 273 563 q 332 653 332 615 q 307 707 332 687 q 224 728 283 728 q 201 726 216 728 q 187 726 192 726 l 201 801 q 282 820 257 800 q 308 870 308 841 q 287 913 308 895 q 227 931 267 931 q 167 915 189 931 q 131 861 146 900 l 34 877 q 104 977 61 948 q 227 1006 146 1006 q 369 969 325 1006 q 414 878 414 933 q 389 812 414 841 q 320 770 365 783 q 409 721 381 755 q 438 640 438 686 q 384 530 438 577 q 231 484 330 484 q 86 521 136 484 q 22 629 36 559 "},"Ӿ":{"x_min":6,"x_max":917,"ha":926,"o":"m 917 0 l 755 0 l 464 411 l 163 0 l 6 0 l 361 479 l 144 479 l 144 569 l 353 569 l 51 995 l 207 995 l 471 625 l 746 995 l 890 995 l 574 569 l 775 569 l 775 479 l 574 479 l 917 0 "},"ᴣ":{"x_min":34,"x_max":587,"ha":637,"o":"m 587 202 q 504 34 587 93 q 319 -16 432 -16 q 34 202 73 -16 l 149 227 q 209 121 163 161 q 321 82 255 82 q 421 113 380 82 q 465 206 465 149 q 391 313 465 289 q 251 326 353 326 l 251 422 l 423 626 q 286 622 322 622 l 77 622 l 77 721 l 587 721 l 587 640 l 392 416 q 543 342 492 405 q 587 202 587 287 "},"Ӫ":{"x_min":64,"x_max":1016,"ha":1080,"o":"m 1016 495 q 890 132 1016 274 q 540 -17 758 -17 q 286 52 399 -17 q 114 250 167 124 q 64 484 64 369 q 184 858 64 714 q 540 1012 314 1012 q 891 862 761 1012 q 1016 495 1016 719 m 878 556 q 785 793 865 704 q 541 899 690 899 q 297 799 395 899 q 203 556 217 718 l 878 556 m 878 439 l 201 439 q 292 204 211 298 q 539 96 384 96 q 779 195 688 96 q 878 439 865 287 m 352 1055 l 352 1194 l 480 1194 l 480 1055 l 352 1055 m 605 1055 l 605 1194 l 733 1194 l 733 1055 l 605 1055 "},"Ѧ":{"x_min":1,"x_max":924,"ha":928,"o":"m 924 0 l 782 0 l 641 391 l 523 391 l 523 0 l 401 0 l 401 391 l 280 391 l 135 0 l 1 0 l 396 995 l 530 995 l 924 0 m 603 495 l 463 885 l 318 495 l 603 495 "},"[":{"x_min":94,"x_max":363,"ha":386,"o":"m 94 -276 l 94 995 l 363 995 l 363 895 l 216 895 l 216 -176 l 363 -176 l 363 -276 l 94 -276 "},"‖":{"x_min":129,"x_max":447,"ha":574,"o":"m 447 0 l 341 0 l 341 1011 l 447 1011 l 447 0 m 235 0 l 129 0 l 129 1011 l 235 1011 l 235 0 "},"Ҝ":{"x_min":109,"x_max":804,"ha":809,"o":"m 804 0 l 640 0 l 474 270 q 403 375 434 334 l 403 162 l 322 162 l 322 449 q 241 466 287 466 l 241 0 l 109 0 l 109 995 l 241 995 l 241 560 q 322 570 288 560 l 322 843 l 403 843 l 403 643 q 460 762 428 687 q 515 879 497 850 q 604 968 552 939 q 714 996 653 996 q 794 994 789 996 l 794 880 q 767 881 785 880 q 741 882 749 882 q 632 833 671 882 q 576 721 611 807 q 516 593 539 626 q 409 509 477 537 q 598 331 504 483 l 804 0 "},"˱":{"x_min":136,"x_max":327,"ha":463,"o":"m 327 -285 l 136 -162 l 136 -126 l 327 -4 l 327 -81 l 211 -144 l 327 -208 l 327 -285 "},"˨":{"x_min":102,"x_max":430,"ha":532,"o":"m 430 0 l 324 0 l 324 222 l 102 222 l 102 328 l 324 328 l 324 994 l 430 994 l 430 0 "},"∏":{"x_min":109,"x_max":1032,"ha":1143,"o":"m 109 1011 l 1032 1011 l 1032 -292 l 903 -292 l 903 892 l 240 892 l 240 -292 l 109 -292 l 109 1011 "},"ˋ":{"x_min":60,"x_max":315,"ha":463,"o":"m 315 810 l 217 810 l 60 1000 l 223 1000 l 315 810 "},"˃":{"x_min":76,"x_max":734,"ha":811,"o":"m 734 435 l 76 154 l 76 276 l 597 491 l 76 705 l 76 827 l 734 549 l 734 435 "},"Ӏ":{"x_min":130,"x_max":262,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 "},"ª":{"x_min":32,"x_max":487,"ha":514,"o":"m 372 567 q 198 507 289 507 q 76 548 121 507 q 32 655 32 590 q 42 712 32 688 q 75 755 53 736 q 130 786 96 774 q 197 800 154 793 l 297 815 q 363 829 346 825 q 353 892 362 876 q 320 921 344 909 q 256 933 296 933 q 175 910 202 933 q 143 848 149 888 l 50 871 q 109 971 58 931 q 257 1012 161 1012 q 414 969 368 1012 q 460 843 460 926 l 460 677 l 459 634 q 487 507 459 541 l 387 507 q 372 567 373 534 m 362 749 q 231 725 325 740 q 152 698 170 715 q 133 655 133 681 q 156 607 133 627 q 221 588 179 588 q 307 614 270 588 q 356 679 343 640 q 362 749 361 693 "},"ᴄ":{"x_min":54,"x_max":682,"ha":695,"o":"m 562 264 l 682 248 q 581 54 662 124 q 381 -16 500 -16 q 143 80 233 -16 q 54 357 54 177 q 92 561 54 474 q 210 693 131 649 q 382 737 289 737 q 574 677 499 737 q 670 509 648 618 l 551 491 q 490 600 534 563 q 386 637 447 637 q 236 570 294 637 q 179 361 179 504 q 234 149 179 215 q 380 84 290 84 q 500 128 452 84 q 562 264 549 172 "},"ї":{"x_min":3,"x_max":384,"ha":386,"o":"m 134 0 l 134 721 l 256 721 l 256 0 l 134 0 m 3 810 l 3 949 l 131 949 l 131 810 l 3 810 m 256 810 l 256 949 l 384 949 l 384 810 l 256 810 "},"ʵ":{"x_min":0,"x_max":370,"ha":333,"o":"m 370 131 q 304 123 338 123 q 202 175 229 123 q 183 295 183 212 l 183 395 q 85 311 150 311 q 0 337 42 311 l 28 413 q 89 396 58 396 q 169 456 150 396 q 183 553 183 500 l 183 808 l 265 808 l 265 296 q 277 212 265 229 q 315 196 290 196 q 354 202 330 196 l 370 131 "},"₭":{"x_min":21,"x_max":923,"ha":926,"o":"m 923 0 l 749 0 l 435 446 l 338 446 l 234 344 l 234 0 l 102 0 l 102 446 l 21 446 l 21 560 l 102 560 l 102 995 l 234 995 l 234 560 l 292 560 l 726 995 l 904 995 l 488 591 l 511 560 l 905 560 l 905 446 l 595 446 l 923 0 "},"ᴶ":{"x_min":33.9375,"x_max":403,"ha":437,"o":"m 403 536 q 318 334 403 381 q 214 311 274 311 q 34 513 30 311 l 114 524 q 213 390 119 390 q 305 447 284 390 q 314 531 314 472 l 314 995 l 403 995 l 403 536 "},"ʽ":{"x_min":94,"x_max":236,"ha":309,"o":"m 236 726 l 206 678 q 115 760 144 705 q 94 891 94 800 l 94 1004 l 225 1004 l 225 862 l 161 862 q 236 726 165 754 "},"T":{"x_min":32,"x_max":821,"ha":849,"o":"m 360 0 l 360 878 l 32 878 l 32 995 l 821 995 l 821 878 l 492 878 l 492 0 l 360 0 "},"ᵖ":{"x_min":68,"x_max":491,"ha":525,"o":"m 491 568 q 386 342 491 408 q 279 311 335 311 q 151 373 199 311 l 151 135 l 68 135 l 68 808 l 144 808 l 144 745 q 284 819 196 819 q 466 696 415 819 q 491 568 491 637 m 406 569 q 378 692 406 642 q 277 755 344 755 q 173 689 209 755 q 144 563 144 635 q 171 441 144 488 q 273 380 205 380 q 378 443 343 380 q 406 569 406 494 "},"є":{"x_min":55.8125,"x_max":680,"ha":709,"o":"m 435 419 l 435 319 l 181 319 q 241 142 192 201 q 378 84 290 84 q 561 263 533 84 l 680 247 q 581 56 661 128 q 373 -16 501 -16 q 135 81 219 -24 q 56 360 51 187 q 143 636 56 536 q 382 737 230 737 q 577 672 502 737 q 668 508 651 608 l 549 489 q 377 636 519 636 q 244 575 296 636 q 181 419 192 515 l 435 419 "},"Þ":{"x_min":107,"x_max":865,"ha":926,"o":"m 107 0 l 107 995 l 239 995 l 239 793 l 481 793 q 633 783 580 793 q 756 736 706 770 q 835 640 805 701 q 865 504 865 578 q 784 289 865 377 q 493 202 703 202 l 239 202 l 239 0 l 107 0 m 239 319 l 495 319 q 675 366 622 319 q 729 500 729 414 q 697 607 729 562 q 615 666 666 652 q 492 676 582 676 l 239 676 l 239 319 "},"₮":{"x_min":33,"x_max":820,"ha":848,"o":"m 820 878 l 492 878 l 492 659 l 719 781 l 719 667 l 492 545 l 492 404 l 719 526 l 719 412 l 492 290 l 492 0 l 360 0 l 360 220 l 135 100 l 135 214 l 360 334 l 360 475 l 135 355 l 135 469 l 360 589 l 360 878 l 33 878 l 33 995 l 820 995 l 820 878 "},"⁪":{"x_min":-158,"x_max":159,"ha":0,"o":"m -158 715 l -24 715 l -24 910 l -158 910 l -158 958 l 159 958 l 159 910 l 25 910 l 25 715 l 159 715 l 159 667 l 25 667 l 25 -187 l -24 -187 l -24 667 l -158 667 l -158 715 "},"j":{"x_min":-63.75,"x_max":212.875,"ha":308,"o":"m 90 853 l 90 995 l 212 995 l 212 853 l 90 853 m -63 -279 l -41 -175 q 16 -185 -4 -185 q 72 -160 54 -185 q 90 -36 90 -135 l 90 721 l 212 721 l 212 -38 q 178 -224 212 -171 q 31 -292 134 -292 q -63 -279 -17 -292 "},"Ѱ":{"x_min":39,"x_max":1027,"ha":1106,"o":"m 1027 713 q 599 307 1027 313 l 599 0 l 467 0 l 467 307 q 293 367 365 307 q 203 502 231 419 l 39 995 l 171 995 l 335 527 q 467 420 373 420 l 467 995 l 599 995 l 599 420 q 826 507 756 429 q 895 743 895 583 l 895 995 l 1027 995 l 1027 713 "},"1":{"x_min":151,"x_max":518,"ha":773,"o":"m 518 0 l 396 0 l 396 778 q 279 694 351 736 q 151 631 208 652 l 151 749 q 330 865 253 797 q 439 999 407 934 l 518 999 l 518 0 "},"ᵌ":{"x_min":34,"x_max":408,"ha":442,"o":"m 408 457 q 352 345 408 384 q 227 311 303 311 q 34 459 60 311 l 111 476 q 228 377 133 377 q 295 398 268 377 q 325 461 325 421 q 309 508 325 485 q 270 537 293 531 q 199 542 253 542 l 181 542 l 181 606 q 238 607 229 606 q 287 630 269 612 q 305 677 305 649 q 225 750 305 750 q 128 669 155 750 l 50 681 q 225 819 86 819 q 341 782 294 819 q 392 674 392 742 q 334 579 392 614 q 408 457 408 540 "},"ᵁ":{"x_min":34,"x_max":562,"ha":596,"o":"m 562 606 q 544 461 562 514 q 456 348 520 388 q 299 311 397 311 q 59 438 112 311 q 34 606 34 499 l 34 995 l 123 995 l 123 606 q 133 497 123 533 q 195 412 148 439 q 291 390 234 390 q 439 445 399 390 q 473 606 473 491 l 473 995 l 562 995 l 562 606 "},"ҍ":{"x_min":14,"x_max":681,"ha":724,"o":"m 681 218 q 590 47 681 105 q 394 0 514 0 l 90 0 l 90 792 l 14 792 l 14 882 l 90 882 l 90 995 l 212 995 l 212 882 l 286 882 l 286 792 l 212 792 l 212 439 l 366 439 q 577 394 496 439 q 681 218 681 337 m 556 217 q 356 338 556 338 l 212 338 l 212 100 l 340 100 q 556 217 556 100 "},"ℓ":{"x_min":9.5625,"x_max":438,"ha":449,"o":"m 9 285 l 130 445 l 130 753 q 171 959 130 907 q 288 1011 213 1011 q 395 966 353 1011 q 438 848 438 922 q 397 696 438 786 q 245 451 356 606 l 245 168 q 254 93 245 108 q 282 79 264 79 q 323 90 300 79 q 418 152 346 101 l 418 42 q 265 -17 342 -17 q 166 21 202 -17 q 130 146 130 60 l 130 299 l 76 232 l 9 285 m 245 609 q 327 767 311 724 q 343 848 343 811 q 325 913 343 889 q 291 930 311 930 q 260 912 270 930 q 245 763 245 883 l 245 609 "},"ᵈ":{"x_min":34,"x_max":457,"ha":524,"o":"m 457 321 l 380 321 l 380 384 q 243 311 333 311 q 61 433 118 311 q 34 565 34 491 q 131 788 34 724 q 240 820 180 820 q 375 752 326 820 l 375 995 l 457 995 l 457 321 m 382 558 q 354 686 382 636 q 248 751 320 751 q 145 688 178 751 q 119 565 119 641 q 148 442 119 492 q 252 380 183 380 q 354 439 319 380 q 382 558 382 487 "},"˕":{"x_min":113,"x_max":349,"ha":463,"o":"m 349 276 l 266 276 l 266 121 l 196 121 l 196 276 l 113 276 l 113 346 l 349 346 l 349 276 "},"ӡ":{"x_min":52,"x_max":711,"ha":757,"o":"m 711 66 q 617 -187 711 -85 q 371 -292 521 -292 q 152 -216 239 -292 q 52 -10 64 -140 l 180 0 q 238 -135 192 -84 q 371 -192 289 -192 q 526 -115 467 -192 q 581 55 581 -45 q 515 223 581 163 q 348 281 453 281 l 285 281 l 285 389 l 513 626 q 376 622 412 622 l 83 622 l 83 721 l 671 721 l 671 640 l 420 386 q 624 295 543 377 q 711 66 711 206 "},"Ү":{"x_min":-2,"x_max":769,"ha":773,"o":"m 769 995 l 446 425 l 446 0 l 324 0 l 324 425 l -2 995 l 133 995 l 330 644 q 382 540 363 587 q 437 650 399 578 l 623 995 l 769 995 "},"ᴸ":{"x_min":34,"x_max":454,"ha":488,"o":"m 454 321 l 34 321 l 34 995 l 124 995 l 124 400 l 454 400 l 454 321 "},"ᵇ":{"x_min":68,"x_max":491,"ha":524,"o":"m 491 572 q 440 393 491 466 q 280 311 383 311 q 145 384 194 311 l 145 321 l 68 321 l 68 995 l 151 995 l 151 753 q 284 820 203 820 q 435 750 380 820 q 491 572 491 680 m 406 565 q 379 689 406 640 q 277 751 345 751 q 173 689 210 751 q 144 569 144 639 q 167 443 144 481 q 272 380 206 380 q 376 442 340 380 q 406 565 406 493 "},"ӹ":{"x_min":94,"x_max":899,"ha":998,"o":"m 777 721 l 899 721 l 899 0 l 777 0 l 777 721 m 94 721 l 216 721 l 216 438 l 370 438 q 603 379 521 438 q 685 217 685 320 q 616 63 685 127 q 398 0 548 0 l 94 0 l 94 721 m 216 100 l 344 100 q 510 128 460 100 q 560 217 560 157 q 523 301 560 264 q 360 338 486 338 l 216 338 l 216 100 m 304 810 l 304 949 l 432 949 l 432 810 l 304 810 m 557 810 l 557 949 l 685 949 l 685 810 l 557 810 "},"О":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 "},"&":{"x_min":60,"x_max":894,"ha":926,"o":"m 659 117 q 528 17 599 50 q 374 -16 457 -16 q 132 86 221 -16 q 60 274 60 170 q 119 440 60 366 q 296 571 178 514 q 207 696 229 648 q 185 789 185 744 q 255 945 185 879 q 431 1012 325 1012 q 597 949 532 1012 q 662 799 662 886 q 474 556 662 657 l 653 329 q 700 468 683 389 l 827 440 q 739 226 794 310 q 894 74 807 136 l 812 -22 q 659 117 738 25 m 411 635 q 513 717 490 682 q 537 796 537 753 q 504 879 537 847 q 424 912 472 912 q 342 879 375 912 q 310 801 310 847 q 321 752 310 778 q 357 698 333 727 l 411 635 m 582 213 l 360 491 q 226 382 261 432 q 192 282 192 331 q 240 157 192 222 q 375 92 288 92 q 489 125 430 92 q 582 213 547 159 "},"G":{"x_min":74,"x_max":993,"ha":1080,"o":"m 572 390 l 572 507 l 993 507 l 993 138 q 793 21 896 60 q 581 -17 690 -17 q 315 45 435 -17 q 134 227 195 108 q 74 492 74 346 q 134 763 74 638 q 309 950 195 889 q 571 1012 423 1012 q 766 976 679 1012 q 902 879 853 941 q 978 716 952 816 l 859 683 q 803 803 836 759 q 708 872 770 846 q 572 899 647 899 q 416 871 482 899 q 310 799 350 844 q 247 700 270 754 q 210 500 210 608 q 255 278 210 367 q 388 145 301 188 q 574 102 476 102 q 740 134 659 102 q 864 205 822 167 l 864 390 l 572 390 "},"ʲ":{"x_min":-33,"x_max":154,"ha":221,"o":"m 154 899 l 71 899 l 71 994 l 154 994 l 154 899 m 154 293 q 130 169 154 205 q 31 123 99 123 q -33 131 -1 123 l -17 202 q 21 196 8 196 q 66 231 56 196 q 71 296 71 247 l 71 808 l 154 808 l 154 293 "},"`":{"x_min":60,"x_max":315,"ha":463,"o":"m 315 810 l 217 810 l 60 1000 l 223 1000 l 315 810 "},"ˣ":{"x_min":0,"x_max":456,"ha":456,"o":"m 456 321 l 355 321 l 227 502 l 99 321 l 0 321 l 178 573 l 14 808 l 116 808 l 194 698 q 229 645 211 672 q 265 697 241 663 l 344 808 l 443 808 l 278 574 l 456 321 "},"ý":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 m 278 810 l 367 1000 l 528 1000 l 379 810 l 278 810 "},"˶":{"x_min":39,"x_max":517,"ha":463,"o":"m 517 311 l 377 121 l 275 121 l 360 311 l 517 311 m 280 311 l 137 121 l 39 121 l 121 311 l 280 311 "},"ᴍ":{"x_min":96,"x_max":859,"ha":955,"o":"m 96 721 l 285 721 l 473 143 l 683 721 l 859 721 l 859 0 l 737 0 l 737 580 l 524 0 l 415 0 l 215 608 l 215 0 l 96 0 l 96 721 "},"º":{"x_min":31,"x_max":475,"ha":507,"o":"m 253 1012 q 413 944 351 1012 q 475 757 475 876 q 412 570 475 638 q 253 503 350 503 q 93 569 155 503 q 31 754 31 635 q 92 944 31 876 q 253 1012 154 1012 m 253 922 q 164 883 198 922 q 131 757 131 844 q 165 632 131 672 q 253 593 199 593 q 341 632 307 593 q 375 760 375 672 q 340 882 375 843 q 253 922 306 922 "},"Ԁ":{"x_min":50,"x_max":800,"ha":912,"o":"m 800 0 l 421 0 q 50 289 50 0 q 189 531 50 458 q 430 570 264 570 l 668 570 l 668 995 l 800 995 l 800 0 m 668 112 l 668 457 l 491 457 q 348 452 381 457 q 224 391 261 440 q 192 289 192 349 q 261 145 192 187 q 427 112 317 112 l 668 112 "},"∞":{"x_min":104,"x_max":888,"ha":990,"o":"m 466 550 q 578 668 538 640 q 692 708 632 708 q 825 656 763 708 q 888 490 888 604 q 864 364 888 410 q 793 290 841 318 q 692 263 744 263 q 578 301 632 263 q 466 420 538 330 q 270 304 374 304 q 153 356 202 304 q 104 485 104 408 q 153 614 104 562 q 270 667 202 667 q 466 550 374 667 m 513 485 q 621 360 572 394 q 691 338 652 338 q 778 375 743 338 q 813 483 813 413 q 777 593 813 555 q 688 631 741 631 q 626 612 655 631 q 513 485 586 585 m 420 485 q 333 572 365 553 q 270 592 300 592 q 205 564 231 592 q 179 487 179 536 q 206 409 179 438 q 272 381 233 381 q 420 485 340 381 "},"˸":{"x_min":126,"x_max":265,"ha":386,"o":"m 265 856 l 126 856 l 126 995 l 265 995 l 265 856 m 265 274 l 126 274 l 126 413 l 265 413 l 265 274 "},"ԛ":{"x_min":48.71875,"x_max":672.71875,"ha":773,"o":"m 550 -276 l 550 76 q 471 10 522 36 q 362 -16 419 -16 q 141 86 233 -16 q 48 367 48 188 q 86 561 48 475 q 195 692 123 648 q 352 737 267 737 q 562 624 486 737 l 562 721 l 672 721 l 672 -276 l 550 -276 m 173 362 q 232 153 173 223 q 371 84 290 84 q 506 150 450 84 q 562 351 562 216 q 503 568 562 495 q 363 641 443 641 q 229 573 284 641 q 173 362 173 505 "},"я":{"x_min":20.5,"x_max":658,"ha":752,"o":"m 658 721 l 658 0 l 536 0 l 536 281 l 465 281 q 370 264 401 281 q 278 157 339 247 l 171 0 l 20 0 l 151 194 q 272 294 212 282 q 117 369 167 308 q 67 510 67 431 q 133 662 67 604 q 324 721 199 721 l 658 721 m 536 621 l 362 621 q 222 586 253 621 q 191 506 191 552 q 237 411 191 441 q 401 381 283 381 l 536 381 l 536 621 "},"ӛ":{"x_min":57.328125,"x_max":722,"ha":773,"o":"m 722 366 q 638 95 722 199 q 385 -16 548 -16 q 138 94 226 -16 q 57 359 57 196 q 58 392 57 370 l 597 392 q 538 563 590 497 q 377 637 480 637 q 186 489 239 637 l 61 504 q 378 737 124 737 q 635 633 544 737 q 722 366 722 535 m 590 292 l 186 292 q 232 154 194 200 q 384 84 290 84 q 530 144 473 84 q 590 292 584 201 m 178 810 l 178 949 l 306 949 l 306 810 l 178 810 m 431 810 l 431 949 l 559 949 l 559 810 l 431 810 "},"Ё":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 m 278 1055 l 278 1194 l 406 1194 l 406 1055 l 278 1055 m 531 1055 l 531 1194 l 659 1194 l 659 1055 l 531 1055 "}," ":{"x_min":0,"x_max":0,"ha":347,"o":"m 0 0 l 0 0 "},"Г":{"x_min":109,"x_max":752,"ha":752,"o":"m 109 995 l 752 995 l 752 878 l 241 878 l 241 0 l 109 0 l 109 995 "},"‴":{"x_min":-34.140625,"x_max":526.9375,"ha":492,"o":"m -34 643 l -26 828 l 9 995 l 148 995 l 113 828 l 41 643 l -34 643 m 154 643 l 163 828 l 198 995 l 337 995 l 302 828 l 230 643 l 154 643 m 343 643 l 352 828 l 387 995 l 526 995 l 491 828 l 419 643 l 343 643 "},"ᴝ":{"x_min":46,"x_max":783,"ha":829,"o":"m 783 306 q 758 186 783 242 q 697 105 734 131 q 606 67 661 79 q 492 60 569 60 l 46 60 l 46 182 l 445 182 q 574 189 542 182 q 678 330 678 213 q 651 432 678 386 q 573 501 623 481 q 432 522 523 522 l 46 522 l 46 644 l 767 644 l 767 535 l 661 535 q 783 306 783 450 "},"Ь":{"x_min":112,"x_max":862,"ha":912,"o":"m 112 995 l 244 995 l 244 570 l 481 570 q 722 531 647 570 q 829 426 796 492 q 862 289 862 359 q 783 86 862 173 q 490 0 704 0 l 112 0 l 112 995 m 244 112 l 484 112 q 675 163 631 112 q 720 289 720 215 q 687 390 720 349 q 602 444 655 432 q 420 457 548 457 l 244 457 l 244 112 "},"ᵷ":{"x_min":93,"x_max":728,"ha":773,"o":"m 728 80 q 694 -100 728 -17 q 582 -244 656 -194 q 415 -292 512 -292 q 205 -188 287 -292 l 205 -276 l 93 -276 l 93 346 q 113 546 93 481 q 236 696 143 646 q 418 737 310 737 q 619 684 545 737 q 704 504 706 624 l 585 521 q 543 601 577 576 q 419 636 498 636 q 225 507 259 636 q 217 350 216 471 q 416 445 297 445 q 649 334 564 445 q 728 80 728 233 m 603 71 q 562 256 603 185 q 405 344 511 344 q 249 258 300 344 q 207 75 207 187 q 251 -104 207 -31 q 407 -191 306 -191 q 559 -105 507 -191 q 603 71 603 -34 "},"ѝ":{"x_min":92,"x_max":684,"ha":776,"o":"m 92 721 l 214 721 l 214 171 l 552 721 l 684 721 l 684 0 l 562 0 l 562 546 l 223 0 l 92 0 l 92 721 m 458 810 l 360 810 l 203 1000 l 366 1000 l 458 810 "},"ԓ":{"x_min":16,"x_max":718,"ha":810,"o":"m 718 -40 q 683 -224 718 -172 q 536 -292 639 -292 q 440 -279 487 -292 l 464 -175 q 521 -185 500 -185 q 589 -131 574 -185 q 596 -35 596 -107 l 596 621 l 273 621 l 273 261 q 271 134 273 146 q 220 24 262 60 q 114 -5 183 -5 q 16 0 71 -5 l 16 102 l 69 102 q 145 134 135 102 q 151 245 151 151 l 151 721 l 718 721 l 718 -40 "},"¤":{"x_min":50,"x_max":716,"ha":773,"o":"m 144 651 l 50 743 l 127 824 l 222 730 q 382 779 293 779 q 543 730 472 779 l 637 824 l 716 743 l 622 651 q 670 492 670 577 q 622 332 670 407 l 716 240 l 637 160 l 543 255 q 382 205 472 205 q 222 255 293 205 l 127 160 l 50 240 l 144 332 q 96 492 96 407 q 144 651 96 577 m 207 492 q 258 367 207 419 q 382 316 309 316 q 505 367 454 316 q 557 492 557 419 q 505 616 557 564 q 382 668 454 668 q 258 616 309 668 q 207 492 207 564 "},"p":{"x_min":92,"x_max":717,"ha":773,"o":"m 92 -276 l 92 721 l 203 721 l 203 626 q 291 709 242 681 q 411 737 341 737 q 574 689 504 737 q 681 555 645 642 q 717 365 717 469 q 677 166 717 255 q 562 31 637 78 q 403 -16 486 -16 q 293 9 342 -16 q 214 74 245 35 l 214 -276 l 92 -276 m 202 356 q 258 150 202 216 q 394 84 314 84 q 534 152 476 84 q 592 366 592 221 q 535 572 592 503 q 400 641 478 641 q 262 568 322 641 q 202 356 202 495 "},"ӓ":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 178 810 l 178 949 l 306 949 l 306 810 l 178 810 m 431 810 l 431 949 l 559 949 l 559 810 l 431 810 "},"⁮":{"x_min":-158,"x_max":159,"ha":0,"o":"m 25 -187 l -24 -187 l -24 689 l -158 812 l 0 958 l 159 812 l 25 689 l 25 -187 m 91 812 l 0 894 l -90 812 l 0 731 l 91 812 "},"Ѹ":{"x_min":67,"x_max":1480.078125,"ha":1492,"o":"m 1480 721 l 1206 -11 q 1138 -175 1162 -131 q 962 -292 1075 -292 q 884 -277 927 -292 l 870 -162 q 940 -173 910 -173 q 1045 -121 1012 -173 q 1093 -1 1057 -102 l 820 721 l 950 721 l 1153 137 l 1358 721 l 1480 721 m 800 496 q 714 126 800 257 q 433 -17 620 -17 q 152 126 246 -17 q 67 496 67 257 q 152 867 67 735 q 433 1012 246 1012 q 714 867 620 1012 q 800 496 800 735 m 664 496 q 618 783 664 688 q 433 899 563 899 q 248 783 303 899 q 203 496 203 688 q 248 210 203 304 q 433 96 303 96 q 618 210 563 96 q 664 496 664 304 "},"Ю":{"x_min":112,"x_max":1332,"ha":1403,"o":"m 112 995 l 244 995 l 244 549 l 435 549 q 573 886 449 760 q 882 1012 698 1012 q 1204 874 1076 1012 q 1332 502 1332 737 q 1204 120 1332 258 q 878 -17 1077 -17 q 578 102 698 -17 q 437 432 458 221 l 244 432 l 244 0 l 112 0 l 112 995 m 567 493 q 653 200 567 304 q 880 96 739 96 q 1110 200 1024 96 q 1196 501 1196 305 q 1111 794 1196 687 q 883 901 1027 901 q 651 792 736 901 q 567 493 567 684 "},"S":{"x_min":62,"x_max":853,"ha":926,"o":"m 62 319 l 186 330 q 226 207 194 255 q 326 129 259 159 q 479 100 394 100 q 612 122 554 100 q 697 184 669 144 q 726 269 726 223 q 698 351 726 316 q 609 409 671 386 q 432 458 569 425 q 240 520 295 491 q 133 613 168 558 q 99 737 99 668 q 141 878 99 812 q 266 978 184 944 q 449 1012 348 1012 q 644 976 559 1012 q 774 871 728 940 q 823 715 819 802 l 697 705 q 628 847 686 799 q 454 896 569 896 q 280 852 335 896 q 226 746 226 808 q 264 658 226 692 q 463 587 302 623 q 683 523 623 550 q 811 422 770 483 q 853 280 853 360 q 807 131 853 201 q 677 22 762 61 q 485 -17 592 -17 q 259 22 350 -17 q 116 140 168 61 q 62 319 64 219 "},"/":{"x_min":0,"x_max":386.328125,"ha":386,"o":"m 0 -17 l 288 1011 l 386 1011 l 98 -17 l 0 -17 "},"Ӭ":{"x_min":50,"x_max":923.453125,"ha":998,"o":"m 417 572 l 417 455 l 787 455 q 694 190 779 287 q 474 94 608 94 q 177 346 237 94 l 50 313 q 465 -17 136 -17 q 815 134 700 -17 q 923 508 930 286 q 871 756 923 644 q 714 940 820 868 q 462 1012 608 1012 q 203 935 307 1012 q 63 722 99 858 l 192 688 q 463 897 248 897 q 691 809 608 897 q 782 572 773 721 l 417 572 m 279 1055 l 279 1194 l 407 1194 l 407 1055 l 279 1055 m 532 1055 l 532 1194 l 660 1194 l 660 1055 l 532 1055 "},"ˑ":{"x_min":123,"x_max":262,"ha":386,"o":"m 262 721 l 200 582 l 184 582 l 123 721 l 262 721 "},"ђ":{"x_min":0,"x_max":679,"ha":773,"o":"m 92 826 l 0 826 l 0 907 l 92 907 l 92 995 l 214 995 l 214 907 l 446 907 l 446 826 l 214 826 l 214 637 q 309 712 255 687 q 431 737 364 737 q 614 674 550 737 q 679 456 679 612 l 679 -38 q 627 -246 679 -200 q 498 -292 575 -292 q 402 -279 444 -292 l 425 -175 q 482 -185 460 -185 q 535 -163 514 -185 q 557 -36 557 -142 l 557 456 q 518 588 557 544 q 403 632 480 632 q 275 585 336 632 q 214 394 214 538 l 214 0 l 92 0 l 92 826 "},"y":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 "},"‗":{"x_min":-21,"x_max":788,"ha":767,"o":"m -21 -276 l -21 -188 l 788 -188 l 788 -276 l -21 -276 m -21 -451 l -21 -364 l 788 -364 l 788 -451 l -21 -451 "},"ᴘ":{"x_min":90,"x_max":681,"ha":724,"o":"m 681 502 q 577 326 681 383 q 366 282 495 282 l 212 282 l 212 0 l 90 0 l 90 721 l 394 721 q 590 673 516 721 q 681 502 681 616 m 556 502 q 340 621 556 621 l 212 621 l 212 382 l 356 382 q 556 502 556 382 "},"ˊ":{"x_min":151,"x_max":401,"ha":463,"o":"m 401 1000 l 252 810 l 151 810 l 240 1000 l 401 1000 "},"ᵟ":{"x_min":34,"x_max":491,"ha":525,"o":"m 491 560 q 432 382 491 449 q 260 311 369 311 q 92 382 154 311 q 34 558 34 450 q 84 725 34 659 q 237 802 139 797 q 80 935 196 830 l 80 995 l 448 995 l 448 928 l 191 928 q 335 812 235 882 q 451 708 418 755 q 491 560 491 649 m 406 558 q 372 681 406 632 q 262 738 332 738 q 153 680 192 738 q 119 557 119 630 q 154 436 119 486 q 264 380 195 380 q 372 436 334 380 q 406 558 406 485 "},"ᴆ":{"x_min":17,"x_max":714,"ha":766,"o":"m 714 364 q 618 95 714 190 q 351 0 523 0 l 92 0 l 92 317 l 17 317 l 17 417 l 92 417 l 92 721 l 339 721 q 618 629 522 721 q 714 364 714 537 m 589 365 q 338 616 589 616 l 214 616 l 214 417 l 377 417 l 377 317 l 214 317 l 214 105 l 340 105 q 521 170 456 105 q 589 365 589 238 "},"–":{"x_min":-3,"x_max":770,"ha":773,"o":"m -3 311 l -3 409 l 770 409 l 770 311 l -3 311 "},"ë":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 m 202 810 l 202 949 l 330 949 l 330 810 l 202 810 m 455 810 l 455 949 l 583 949 l 583 810 l 455 810 "},"б":{"x_min":62,"x_max":740,"ha":796,"o":"m 618 1018 l 726 1017 q 693 915 718 944 q 630 879 669 887 q 477 871 591 871 q 272 841 326 871 q 193 748 217 812 q 166 583 169 684 q 274 685 212 651 q 412 720 335 720 q 647 622 554 720 q 740 359 740 525 q 693 152 740 233 q 582 28 646 72 q 408 -16 518 -16 q 208 42 280 -16 q 99 192 137 101 q 62 511 62 284 q 158 896 62 797 q 454 995 254 995 q 596 999 579 995 q 618 1018 613 1003 m 612 362 q 558 547 612 475 q 409 619 505 619 q 253 543 308 619 q 199 340 199 467 q 259 148 199 214 q 408 82 320 82 q 555 158 499 82 q 612 362 612 235 "},"у":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 "},"J":{"x_min":39.890625,"x_max":587,"ha":695,"o":"m 40 281 l 159 298 q 201 142 163 184 q 306 100 239 100 q 392 122 356 100 q 441 184 427 145 q 455 309 455 223 l 455 995 l 587 995 l 587 316 q 556 123 587 192 q 461 18 526 54 q 307 -17 395 -17 q 106 58 176 -17 q 40 281 37 133 "},"ӌ":{"x_min":47,"x_max":632,"ha":724,"o":"m 632 0 l 531 0 l 531 -204 l 431 -204 l 431 100 l 510 100 l 510 291 q 299 256 397 256 q 161 293 225 256 q 69 399 93 333 q 47 532 47 460 l 47 721 l 169 721 l 169 584 q 175 476 169 505 q 230 387 187 419 q 330 358 270 358 q 510 394 399 358 l 510 721 l 632 721 l 632 0 "},"˘":{"x_min":31,"x_max":432,"ha":463,"o":"m 349 993 l 432 993 q 369 862 421 908 q 231 817 317 817 q 92 862 144 817 q 31 993 41 907 l 114 993 q 151 923 123 946 q 227 901 180 901 q 311 923 282 901 q 349 993 339 945 "},"ᴁ":{"x_min":17,"x_max":986,"ha":1038,"o":"m 986 0 l 516 0 l 516 219 l 255 219 l 153 0 l 17 0 l 376 721 l 972 721 l 972 616 l 638 616 l 638 424 l 947 424 l 947 319 l 638 319 l 638 105 l 986 105 l 986 0 m 516 319 l 516 616 l 448 616 l 305 319 l 516 319 "},"˄":{"x_min":69,"x_max":742,"ha":811,"o":"m 742 161 l 620 161 l 404 683 l 191 161 l 69 161 l 347 819 l 461 819 l 742 161 "},"҃":{"x_min":-235,"x_max":236,"ha":0,"o":"m 236 945 q 213 891 236 913 q 159 869 191 869 l -83 869 q -83 856 -83 864 q -105 803 -83 825 q -159 781 -127 781 q -212 803 -190 781 q -235 857 -235 825 q -212 910 -235 888 q -158 933 -190 933 l 84 933 q 84 945 84 937 q 106 998 84 976 q 160 1021 128 1021 q 213 998 191 1021 q 236 945 236 976 "},"D":{"x_min":107,"x_max":929,"ha":1003,"o":"m 107 0 l 107 995 l 449 995 q 626 980 565 995 q 772 909 711 961 q 890 739 851 842 q 929 502 929 635 q 902 302 929 389 q 834 157 876 214 q 744 66 793 99 q 625 16 695 33 q 465 0 555 0 l 107 0 m 239 117 l 450 117 q 605 135 549 117 q 694 186 660 153 q 766 313 740 233 q 793 504 793 392 q 741 745 793 661 q 617 857 690 829 q 447 878 564 878 l 239 878 l 239 117 "},"ʸ":{"x_min":0,"x_max":446,"ha":446,"o":"m 446 808 l 260 312 q 214 201 230 230 q 96 123 171 123 q 42 133 72 123 l 34 210 q 80 203 61 203 q 152 238 129 203 q 177 299 160 251 q 184 319 180 308 l 0 808 l 88 808 l 190 525 q 225 412 211 466 q 259 524 240 472 l 363 808 l 446 808 "},"₰":{"x_min":3,"x_max":705,"ha":724,"o":"m 705 817 q 650 613 705 733 q 543 410 628 563 l 674 -50 q 683 -106 683 -82 q 619 -240 683 -187 q 477 -292 560 -292 q 346 -279 410 -292 l 346 -165 q 460 -192 406 -192 q 556 -98 555 -192 q 552 -67 556 -82 l 461 254 q 318 -17 413 168 l 214 133 l 141 0 l 3 0 l 204 364 l 306 220 l 413 427 l 315 774 q 311 824 311 792 q 370 964 311 913 q 513 1012 425 1012 q 655 955 603 1012 q 705 817 705 902 m 580 816 q 562 884 580 857 q 514 911 544 911 q 436 823 436 911 q 438 780 436 792 l 494 583 q 580 816 580 748 "},"ӳ":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 m 174 810 l 256 1000 l 415 1000 l 271 810 l 174 810 m 409 810 l 496 1000 l 653 1000 l 511 810 l 409 810 "},"ц":{"x_min":94,"x_max":755,"ha":796,"o":"m 94 721 l 216 721 l 216 100 l 554 100 l 554 721 l 676 721 l 676 100 l 755 100 l 755 -204 l 655 -204 l 655 0 l 94 0 l 94 721 "},"Л":{"x_min":12,"x_max":803,"ha":912,"o":"m 180 995 l 803 995 l 803 0 l 671 0 l 671 878 l 312 878 l 312 365 q 297 136 312 209 q 235 23 282 63 q 116 -17 188 -17 q 12 -1 73 -17 l 35 115 q 90 102 67 102 q 157 135 135 102 q 180 294 180 169 l 180 995 "},"˴":{"x_min":60,"x_max":315,"ha":463,"o":"m 315 121 l 217 121 l 60 311 l 223 311 l 315 121 "},"$":{"x_min":50,"x_max":707,"ha":773,"o":"m 346 -143 l 346 -21 q 197 20 254 -9 q 98 115 140 49 q 50 276 56 181 l 173 299 q 223 154 187 200 q 346 82 274 89 l 346 465 q 192 529 270 485 q 102 619 133 561 q 71 750 71 677 q 163 961 71 880 q 346 1028 224 1015 l 346 1086 l 418 1086 l 418 1028 q 586 965 524 1017 q 682 782 665 898 l 557 763 q 511 874 546 835 q 418 925 477 912 l 418 573 q 539 536 510 549 q 632 475 596 511 q 687 390 668 439 q 707 282 707 340 q 626 70 707 155 q 418 -20 545 -13 l 418 -143 l 346 -143 m 346 926 q 233 868 274 915 q 193 759 193 822 q 227 655 193 697 q 346 591 262 613 l 346 926 m 418 82 q 535 143 489 90 q 582 274 582 196 q 549 381 582 341 q 418 447 516 422 l 418 82 "},"w":{"x_min":3.5,"x_max":992.5,"ha":1003,"o":"m 221 0 l 3 721 l 131 721 l 244 304 l 286 150 q 324 298 289 161 l 441 721 l 564 721 l 673 302 l 708 164 l 749 303 l 873 721 l 992 721 l 767 0 l 640 0 l 526 431 l 497 554 l 349 0 l 221 0 "},"Ԅ":{"x_min":69,"x_max":1237,"ha":1328,"o":"m 1237 298 q 1165 70 1237 151 q 945 -16 1090 -16 q 644 283 644 -16 q 567 420 644 375 q 406 458 504 458 l 343 458 l 343 573 q 464 579 429 573 q 567 637 529 592 q 604 735 604 680 q 546 855 604 810 q 417 897 493 897 q 292 862 346 897 q 215 759 236 825 q 195 667 195 698 l 69 695 q 418 1012 115 1012 q 636 942 547 1012 q 735 741 735 866 q 603 525 735 602 q 733 437 684 503 q 782 287 782 372 q 947 84 782 84 q 1115 302 1115 84 l 1115 572 l 1237 572 l 1237 298 "},"о":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 "},"Д":{"x_min":0,"x_max":892,"ha":941,"o":"m 197 995 l 803 995 l 803 117 l 892 117 l 892 -232 l 775 -232 l 775 0 l 117 0 l 117 -232 l 0 -232 l 0 117 l 77 117 q 197 849 197 298 l 197 995 m 671 878 l 324 878 l 324 827 q 301 479 324 699 q 212 117 278 259 l 671 117 l 671 878 "},"Ç":{"x_min":69,"x_max":948,"ha":1003,"o":"m 816 348 l 948 315 q 799 68 906 153 q 536 -17 691 -17 q 274 48 375 -17 q 121 238 174 114 q 69 504 69 362 q 128 776 69 660 q 297 951 187 891 q 538 1012 406 1012 q 789 935 687 1012 q 931 721 890 859 l 801 691 q 700 849 766 799 q 535 899 635 899 q 344 844 421 899 q 236 696 267 789 q 205 505 205 603 q 241 284 205 378 q 356 142 278 189 q 525 96 434 96 q 712 159 635 96 q 816 348 788 223 m 429 -120 l 465 0 l 556 0 l 533 -72 q 620 -108 591 -79 q 649 -172 649 -136 q 600 -262 649 -223 q 453 -301 551 -301 q 356 -301 397 -301 l 363 -214 q 426 -216 406 -216 q 516 -198 490 -216 q 536 -165 536 -184 q 528 -143 536 -153 q 499 -127 520 -134 q 429 -120 478 -120 "},"Ӛ":{"x_min":67,"x_max":983.1875,"ha":1045,"o":"m 983 508 q 875 135 987 282 q 525 -17 760 -17 q 174 135 290 -17 q 67 509 67 278 l 67 573 l 842 573 q 754 807 833 722 q 523 897 670 897 q 252 689 308 897 l 123 722 q 269 939 160 863 q 522 1012 373 1012 q 765 945 658 1012 q 932 756 876 878 q 983 508 980 651 m 847 456 l 203 456 q 296 191 210 288 q 525 94 381 94 q 753 191 668 94 q 847 456 839 288 m 327 1055 l 327 1194 l 455 1194 l 455 1055 l 327 1055 m 580 1055 l 580 1194 l 708 1194 l 708 1055 l 580 1055 "},"ӣ":{"x_min":92,"x_max":684,"ha":776,"o":"m 92 721 l 214 721 l 214 171 l 552 721 l 684 721 l 684 0 l 562 0 l 562 546 l 223 0 l 92 0 l 92 721 m 177 810 l 177 910 l 600 910 l 600 810 l 177 810 "},"C":{"x_min":69,"x_max":948,"ha":1003,"o":"m 816 348 l 948 315 q 799 68 906 153 q 536 -17 691 -17 q 274 48 375 -17 q 121 238 174 114 q 69 504 69 362 q 128 776 69 660 q 297 951 187 891 q 538 1012 406 1012 q 789 935 687 1012 q 931 721 890 859 l 801 691 q 700 849 766 799 q 535 899 635 899 q 344 844 421 899 q 236 696 267 789 q 205 505 205 603 q 241 284 205 378 q 356 142 278 189 q 525 96 434 96 q 712 159 635 96 q 816 348 788 223 "},"Ӂ":{"x_min":5,"x_max":1277,"ha":1283,"o":"m 709 995 l 709 560 q 842 595 805 560 q 934 762 878 631 q 1002 900 975 860 q 1078 968 1029 941 q 1187 996 1128 996 q 1267 994 1251 996 l 1267 880 q 1241 880 1260 880 q 1214 881 1219 881 q 1121 851 1151 881 q 1050 721 1090 820 q 975 574 1006 613 q 883 509 943 535 q 1072 331 980 482 l 1277 0 l 1114 0 l 947 269 q 836 421 881 377 q 709 466 790 466 l 709 0 l 574 0 l 574 466 q 459 431 509 466 q 343 283 409 397 l 335 269 l 168 0 l 5 0 l 209 331 q 399 509 303 483 q 312 567 346 531 q 231 721 278 603 q 158 854 189 827 q 67 882 128 882 l 15 880 l 15 994 q 90 996 22 996 q 203 969 156 996 q 278 902 251 942 q 348 762 305 861 q 440 595 405 629 q 574 560 476 561 l 574 995 l 709 995 m 841 1231 q 640 1055 819 1055 q 440 1231 461 1055 l 523 1231 q 636 1139 542 1139 q 758 1231 739 1139 l 841 1231 "},"ᴦ":{"x_min":92,"x_max":507,"ha":507,"o":"m 92 721 l 507 721 l 507 621 l 214 621 l 214 0 l 92 0 l 92 721 "},"˩":{"x_min":102,"x_max":430,"ha":532,"o":"m 430 0 l 102 0 l 102 106 l 324 106 l 324 994 l 430 994 l 430 0 "},"Ҕ":{"x_min":111,"x_max":869,"ha":931,"o":"m 869 220 q 754 -163 869 -27 q 457 -292 645 -292 q 226 -234 328 -292 q 111 -95 123 -176 l 243 -95 q 303 -148 254 -124 q 451 -179 364 -179 q 661 -76 585 -179 q 737 209 737 26 q 494 546 737 546 q 243 484 388 546 l 243 0 l 111 0 l 111 995 l 733 995 l 733 878 l 243 878 l 243 594 q 512 660 389 660 q 791 524 700 660 q 869 220 869 410 "},"È":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 m 575 1055 l 477 1055 l 320 1245 l 483 1245 l 575 1055 "},"X":{"x_min":6.109375,"x_max":918.109375,"ha":927,"o":"m 6 0 l 390 516 l 52 995 l 209 995 l 390 740 q 469 618 446 661 q 547 730 503 670 l 747 995 l 891 995 l 545 522 l 918 0 l 756 0 l 504 354 q 463 416 483 385 q 416 344 430 364 l 164 0 l 6 0 "},"ô":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 m 385 925 l 308 810 l 169 810 l 315 1000 l 445 1000 l 598 810 l 459 810 l 385 925 "},"‟":{"x_min":57,"x_max":410,"ha":463,"o":"m 188 862 l 124 862 q 199 726 125 756 l 168 678 q 81 754 105 706 q 57 891 57 802 l 57 1004 l 188 1004 l 188 862 m 399 862 l 335 862 q 410 726 336 756 l 379 678 q 292 754 316 706 q 268 891 268 802 l 268 1004 l 399 1004 l 399 862 "},"ᴈ":{"x_min":34,"x_max":587,"ha":637,"o":"m 251 326 l 251 422 q 356 428 327 422 q 409 460 384 433 q 434 528 434 487 q 401 607 434 578 q 316 637 368 637 q 172 516 213 637 l 56 535 q 317 737 110 737 q 498 673 433 737 q 564 523 564 610 q 478 383 564 435 q 559 308 532 354 q 587 201 587 263 q 516 44 587 104 q 319 -16 446 -16 q 34 203 73 -16 l 149 227 q 212 119 164 157 q 321 82 259 82 q 424 117 383 82 q 465 206 465 152 q 439 279 465 248 q 384 318 413 311 q 278 326 355 326 q 251 326 272 326 "},"ҝ":{"x_min":91,"x_max":619,"ha":608,"o":"m 619 0 l 484 0 l 354 223 q 333 256 344 239 l 333 111 l 266 111 l 266 322 q 213 333 242 333 l 213 0 l 91 0 l 91 721 l 213 721 l 213 409 q 266 415 243 409 l 266 636 l 333 636 l 333 493 q 363 561 347 523 q 403 648 390 627 q 473 711 433 698 q 567 721 502 721 l 592 721 l 592 621 l 558 621 q 485 595 507 622 q 452 517 479 586 q 401 419 424 446 q 337 369 373 386 q 485 223 409 350 l 619 0 "},"г":{"x_min":92,"x_max":507,"ha":507,"o":"m 92 721 l 507 721 l 507 621 l 214 621 l 214 0 l 92 0 l 92 721 "},"ᵊ":{"x_min":34,"x_max":482,"ha":516,"o":"m 482 569 q 426 386 482 455 q 254 311 365 311 q 88 385 147 311 q 34 564 34 453 l 34 586 l 397 586 q 357 700 392 656 q 250 750 318 750 q 122 652 157 750 l 37 662 q 250 819 79 819 q 424 749 363 819 q 482 569 482 683 m 392 517 l 121 517 q 152 426 126 457 q 254 380 191 380 q 352 419 314 380 q 392 517 387 457 "},"х":{"x_min":10,"x_max":685,"ha":695,"o":"m 10 0 l 274 373 l 30 721 l 180 721 l 294 552 q 343 472 325 504 q 398 549 374 514 l 520 721 l 667 721 l 423 374 l 685 0 l 536 0 l 386 223 l 351 276 l 159 0 l 10 0 "},"Ԋ":{"x_min":111,"x_max":1345,"ha":1436,"o":"m 1345 298 q 1273 70 1345 151 q 1053 -16 1198 -16 q 816 71 886 -16 q 758 294 758 144 l 758 469 l 243 469 l 243 0 l 111 0 l 111 995 l 243 995 l 243 586 l 758 586 l 758 995 l 890 995 l 890 293 q 918 149 890 196 q 1055 84 957 84 q 1223 303 1223 84 l 1223 586 l 1345 586 l 1345 298 "},"Ч":{"x_min":59,"x_max":817,"ha":926,"o":"m 817 0 l 685 0 l 685 400 q 375 335 507 335 q 191 383 271 335 q 85 506 112 432 q 59 702 59 581 l 59 995 l 191 995 l 191 714 q 250 500 191 551 q 392 449 309 449 q 685 510 531 449 l 685 995 l 817 995 l 817 0 "},"˽":{"x_min":20,"x_max":531,"ha":552,"o":"m 531 -285 l 20 -285 l 20 -30 l 124 -30 l 124 -181 l 427 -181 l 427 -30 l 531 -30 l 531 -285 "},"∟":{"x_min":245.515625,"x_max":1114.3125,"ha":1360,"o":"m 245 867 l 313 867 l 313 67 l 1114 67 l 1114 0 l 245 0 l 245 867 "},"ᵳ":{"x_min":-62.015625,"x_max":482,"ha":463,"o":"m 482 697 l 439 584 q 343 611 394 611 q 228 528 256 611 q 212 377 212 481 l 212 325 q 254 315 237 315 q 304 374 295 315 l 392 374 q 258 219 387 219 q 212 227 239 219 l 212 0 l 90 0 l 90 280 q 79 282 83 282 q 28 217 26 282 l -62 217 q -26 325 -62 282 q 75 372 11 372 q 90 371 84 372 l 90 428 q 150 646 90 565 q 349 737 218 737 q 482 697 418 737 "},"ü":{"x_min":89,"x_max":673,"ha":773,"o":"m 564 0 l 564 105 q 335 -16 479 -16 q 216 8 271 -16 q 134 69 160 32 q 96 160 107 106 q 89 274 89 196 l 89 721 l 211 721 l 211 321 q 218 192 211 225 q 267 116 230 143 q 359 89 304 89 q 462 117 414 89 q 530 193 510 145 q 551 334 551 242 l 551 721 l 673 721 l 673 0 l 564 0 m 189 810 l 189 949 l 317 949 l 317 810 l 189 810 m 442 810 l 442 949 l 570 949 l 570 810 l 442 810 "},"ь":{"x_min":90,"x_max":681,"ha":724,"o":"m 90 721 l 212 721 l 212 438 l 366 438 q 599 379 517 438 q 681 217 681 320 q 612 63 681 127 q 394 0 544 0 l 90 0 l 90 721 m 212 100 l 340 100 q 506 128 456 100 q 556 217 556 157 q 519 301 556 264 q 356 338 482 338 l 212 338 l 212 100 "},"˷":{"x_min":4.984375,"x_max":459,"ha":463,"o":"m 459 -119 q 325 -274 454 -274 q 213 -235 283 -274 q 146 -211 167 -211 q 95 -276 93 -211 l 5 -276 q 40 -167 4 -210 q 142 -121 78 -121 q 257 -157 184 -121 q 321 -178 297 -178 q 371 -119 362 -178 l 459 -119 "},"ᴯ":{"x_min":-32,"x_max":582,"ha":576,"o":"m 582 632 l 495 632 q 541 516 541 585 q 471 365 541 417 q 289 321 412 321 l 34 321 l 34 632 l -32 632 l -32 711 l 34 711 l 34 995 l 285 995 q 481 911 430 995 q 508 822 508 868 q 460 711 508 756 l 582 711 l 582 632 m 420 811 q 358 906 420 886 q 256 916 328 916 l 123 916 l 123 711 l 267 711 q 351 719 324 711 q 420 811 420 739 m 449 516 q 376 621 449 597 q 278 632 343 632 l 123 632 l 123 400 l 289 400 q 350 403 331 400 q 435 459 411 414 q 449 516 449 485 "},"Җ":{"x_min":5,"x_max":1278,"ha":1283,"o":"m 1278 -276 l 1161 -276 l 1161 0 l 1113 0 l 948 270 q 854 404 885 373 q 709 466 793 466 l 709 0 l 574 0 l 574 466 q 459 432 508 466 q 342 283 414 401 l 343 285 q 168 0 336 273 l 5 0 l 209 331 q 399 509 303 483 q 292 594 332 537 q 231 720 268 628 q 157 854 189 827 q 67 881 126 882 l 15 880 l 15 994 q 91 995 22 995 q 279 901 216 995 q 348 762 307 861 q 424 613 400 640 q 574 560 470 561 l 574 995 l 709 995 l 709 560 q 858 613 810 560 q 934 762 883 641 q 1002 900 976 860 q 1187 995 1066 995 q 1268 994 1252 995 l 1268 880 q 1241 880 1259 880 q 1215 881 1224 881 q 1107 833 1145 881 q 1050 720 1085 807 q 990 594 1014 629 q 883 509 951 538 q 1072 331 979 483 l 1205 117 l 1278 117 l 1278 -276 "},"Ҍ":{"x_min":3,"x_max":862,"ha":912,"o":"m 862 289 q 490 0 862 0 l 112 0 l 112 728 l 3 728 l 3 818 l 112 818 l 112 995 l 244 995 l 244 818 l 353 818 l 353 728 l 244 728 l 244 570 l 481 570 q 679 547 606 570 q 829 426 786 514 q 862 289 862 359 m 720 289 q 602 444 720 417 q 420 457 548 457 l 244 457 l 244 112 l 484 112 q 650 145 595 112 q 720 289 720 186 "},"€":{"x_min":-19,"x_max":751.140625,"ha":773,"o":"m 536 899 q 344 844 422 899 q 261 752 298 812 q 216 636 223 691 l 679 636 l 660 544 l 205 544 q 205 516 205 529 q 205 454 205 464 l 642 454 l 623 362 l 219 362 q 356 142 248 207 q 525 96 434 96 q 724 162 652 96 l 724 22 q 536 -17 639 -17 q 121 237 229 -17 q 84 362 100 288 l -19 362 l 0 454 l 71 454 q 69 516 69 482 q 69 544 69 529 l -19 544 l 0 636 l 78 636 q 297 952 120 856 q 538 1012 407 1012 q 751 957 664 1012 l 724 831 q 536 899 641 899 "},"ҽ":{"x_min":7,"x_max":867,"ha":925,"o":"m 867 362 q 866 330 867 351 l 329 330 q 386 158 335 223 q 547 84 445 84 q 738 233 684 84 l 863 217 q 546 -16 799 -16 q 298 79 389 -16 q 204 330 210 171 q 7 489 7 330 q 19 585 7 532 l 123 562 q 114 504 114 531 q 148 438 114 453 q 208 430 166 430 q 296 636 224 558 q 539 737 390 737 q 786 626 698 737 q 867 362 867 525 m 738 430 q 691 566 729 520 q 540 637 633 637 q 395 577 452 637 q 335 430 341 519 l 738 430 "},"в":{"x_min":92,"x_max":684,"ha":738,"o":"m 92 721 l 373 721 q 527 703 477 721 q 614 640 578 686 q 651 529 651 593 q 629 439 651 477 q 566 375 608 400 q 650 311 617 358 q 684 201 684 265 q 610 49 677 99 q 417 0 544 0 l 92 0 l 92 721 m 214 417 l 344 417 q 451 425 422 417 q 503 458 480 433 q 527 518 527 483 q 486 598 527 575 q 348 621 446 621 l 214 621 l 214 417 m 214 100 l 375 100 q 518 124 479 100 q 559 207 556 148 q 536 271 559 242 q 478 309 514 301 q 362 317 441 317 l 214 317 l 214 100 "},"С":{"x_min":69,"x_max":948,"ha":1003,"o":"m 816 348 l 948 315 q 799 68 906 153 q 536 -17 691 -17 q 274 48 375 -17 q 121 238 174 114 q 69 504 69 362 q 128 776 69 660 q 297 951 187 891 q 538 1012 406 1012 q 789 935 687 1012 q 931 721 890 859 l 801 691 q 700 849 766 799 q 535 899 635 899 q 344 844 421 899 q 236 696 267 789 q 205 505 205 603 q 241 284 205 378 q 356 142 278 189 q 525 96 434 96 q 712 159 635 96 q 816 348 788 223 "},"ß":{"x_min":104,"x_max":805,"ha":848,"o":"m 104 0 l 104 678 q 134 869 104 802 q 234 973 164 935 q 393 1012 305 1012 q 577 953 510 1012 q 645 817 645 894 q 632 746 645 782 q 589 655 620 709 q 550 579 558 600 q 542 541 542 557 q 557 498 542 519 q 639 432 571 476 q 761 335 731 372 q 805 212 805 283 q 735 51 805 118 q 557 -16 665 -16 q 407 29 471 -16 q 311 147 342 75 l 416 195 q 483 108 450 132 q 555 84 517 84 q 643 119 606 84 q 680 202 680 154 q 658 267 680 240 q 583 327 644 285 q 444 443 470 404 q 417 522 417 481 q 426 576 417 548 q 470 662 435 603 q 515 752 504 722 q 526 805 526 782 q 489 879 526 847 q 390 912 452 912 q 272 867 318 912 q 226 673 226 822 l 226 0 l 104 0 "},"ᵐ":{"x_min":68,"x_max":728,"ha":796,"o":"m 728 321 l 646 321 l 646 627 q 608 734 646 710 q 559 748 587 748 q 440 604 440 748 l 440 321 l 358 321 l 358 637 q 271 748 358 748 q 163 675 191 748 q 151 573 151 641 l 151 321 l 68 321 l 68 808 l 142 808 l 142 739 q 290 819 192 819 q 378 796 343 819 q 427 733 412 774 q 577 819 484 819 q 728 655 728 819 l 728 321 "},"њ":{"x_min":89,"x_max":1081,"ha":1129,"o":"m 611 420 l 766 420 q 999 363 917 420 q 1081 209 1081 307 q 1012 60 1081 121 q 794 0 943 0 l 489 0 l 489 320 l 211 320 l 211 0 l 89 0 l 89 721 l 211 721 l 211 420 l 489 420 l 489 721 l 611 721 l 611 420 m 611 96 l 739 96 q 906 122 857 96 q 956 206 956 149 q 919 285 956 251 q 756 320 883 320 l 611 320 l 611 96 "},"Ӓ":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 271 1055 l 271 1194 l 399 1194 l 399 1055 l 271 1055 m 524 1055 l 524 1194 l 652 1194 l 652 1055 l 524 1055 "},"ᵄ":{"x_min":33.546875,"x_max":483,"ha":517,"o":"m 483 681 q 423 567 483 607 q 363 540 396 549 q 290 528 341 534 q 142 500 190 516 l 142 478 q 165 407 142 428 q 259 380 197 380 q 345 399 316 380 q 388 472 374 419 l 469 461 q 359 328 447 360 q 248 311 310 311 q 89 362 132 311 q 64 418 70 385 q 60 494 60 438 l 60 604 q 55 750 60 723 q 33 809 50 778 l 120 809 q 136 749 132 784 q 315 820 220 820 q 432 786 387 820 q 483 681 483 750 m 395 678 q 296 756 395 756 q 156 678 194 756 q 143 594 143 649 l 143 565 q 278 596 187 583 q 336 607 320 602 q 383 639 369 617 q 395 678 395 657 "},"ᴹ":{"x_min":34,"x_max":675,"ha":709,"o":"m 675 321 l 590 321 l 590 884 l 394 321 l 314 321 l 119 894 l 119 321 l 34 321 l 34 995 l 166 995 l 326 517 q 358 417 343 469 q 395 525 369 453 l 557 995 l 675 995 l 675 321 "},"c":{"x_min":54,"x_max":682,"ha":695,"o":"m 562 264 l 682 248 q 581 54 662 124 q 381 -16 500 -16 q 143 80 233 -16 q 54 357 54 177 q 92 561 54 474 q 210 693 131 649 q 382 737 289 737 q 574 677 499 737 q 670 509 648 618 l 551 491 q 490 600 534 563 q 386 637 447 637 q 236 570 294 637 q 179 361 179 504 q 234 149 179 215 q 380 84 290 84 q 500 128 452 84 q 562 264 549 172 "},"¶":{"x_min":0,"x_max":751,"ha":746,"o":"m 275 -275 l 275 433 q 73 515 147 439 q 0 708 0 591 q 81 917 0 839 q 321 995 163 995 l 751 995 l 751 878 l 653 878 l 653 -275 l 538 -275 l 538 878 l 387 878 l 387 -275 l 275 -275 "},"ᵿ":{"x_min":7,"x_max":781,"ha":789,"o":"m 781 329 l 735 329 q 639 82 734 180 q 396 -16 544 -16 q 151 82 248 -16 q 54 329 54 180 l 7 329 l 7 419 l 64 419 q 203 626 94 534 l 47 626 l 47 721 l 347 721 l 347 631 q 185 419 211 566 l 603 419 q 443 631 578 568 l 443 721 l 742 721 l 742 626 l 585 626 q 724 419 695 534 l 781 419 l 781 329 m 610 329 l 179 329 q 233 156 181 223 q 395 84 292 84 q 559 164 502 84 q 610 329 606 229 "},"­":{"x_min":43,"x_max":420,"ha":463,"o":"m 43 298 l 43 421 l 420 421 l 420 298 l 43 298 "},"ᵏ":{"x_min":68,"x_max":471,"ha":471,"o":"m 471 321 l 369 321 l 207 570 l 150 514 l 150 321 l 68 321 l 68 995 l 150 995 l 150 609 l 345 808 l 452 808 l 266 627 l 471 321 "},"ѫ":{"x_min":83,"x_max":869,"ha":952,"o":"m 869 0 l 747 0 l 747 47 q 703 229 747 182 q 538 277 660 277 l 538 0 l 414 0 l 414 277 q 248 229 291 277 q 205 47 205 182 l 205 0 l 83 0 l 83 47 q 140 288 83 213 q 353 377 201 366 l 146 721 l 807 721 l 599 377 q 811 288 751 366 q 869 47 869 213 l 869 0 m 625 622 l 330 622 l 476 368 l 625 622 "},":":{"x_min":125,"x_max":264,"ha":386,"o":"m 125 582 l 125 721 l 264 721 l 264 582 l 125 582 m 125 0 l 125 139 l 264 139 l 264 0 l 125 0 "},"Ѝ":{"x_min":109,"x_max":889,"ha":998,"o":"m 109 995 l 228 995 l 228 207 l 756 995 l 889 995 l 889 0 l 770 0 l 770 785 l 240 0 l 109 0 l 109 995 m 557 1055 l 459 1055 l 302 1245 l 465 1245 l 557 1055 "},"ˢ":{"x_min":33,"x_max":437,"ha":472,"o":"m 437 464 q 343 330 437 371 q 241 311 298 311 q 33 467 60 311 l 114 480 q 240 380 128 380 q 314 396 283 380 q 352 456 352 417 q 327 500 352 484 q 243 528 311 511 q 145 555 168 547 q 65 614 86 578 q 47 678 47 643 q 102 785 47 745 q 225 819 149 819 q 390 758 345 819 q 419 682 411 729 l 338 672 q 231 750 326 750 q 127 688 127 750 q 168 637 127 653 q 241 616 179 633 q 336 589 323 594 q 417 535 394 568 q 437 464 437 506 "},"₫":{"x_min":109,"x_max":614,"ha":713,"o":"m 460 877 l 396 877 l 396 939 l 460 939 l 460 995 l 545 995 l 545 939 l 614 939 l 614 877 l 545 877 l 545 300 l 466 300 l 466 363 q 325 288 417 288 q 136 414 195 288 q 109 551 109 473 q 209 781 109 716 q 321 815 259 815 q 460 744 409 815 l 460 877 m 196 551 q 233 411 196 463 q 333 359 271 359 q 431 408 394 359 q 467 543 467 458 q 430 691 467 638 q 328 744 393 744 q 231 693 266 744 q 196 551 196 642 m 614 168 l 109 168 l 109 229 l 614 229 l 614 168 "},"ӄ":{"x_min":91,"x_max":709,"ha":765,"o":"m 709 72 q 621 -184 709 -81 q 381 -292 530 -292 q 185 -238 266 -292 q 91 -95 102 -183 l 213 -95 q 381 -192 242 -192 q 530 -111 476 -192 q 579 61 579 -42 q 519 237 579 173 q 353 301 460 301 l 213 301 l 213 0 l 91 0 l 91 721 l 213 721 l 213 409 q 313 453 280 409 q 362 562 324 467 q 403 648 389 627 q 472 711 433 698 q 566 721 501 721 l 591 721 l 591 620 l 557 621 q 485 594 506 621 q 452 517 478 585 q 387 409 423 445 q 614 320 524 409 q 709 72 709 226 "}," ":{"x_min":0,"x_max":0,"ha":386},"У":{"x_min":6.5,"x_max":877.5,"ha":882,"o":"m 6 995 l 139 995 l 463 385 l 747 995 l 877 995 l 504 220 q 390 30 434 75 q 261 -14 345 -14 q 137 9 210 -14 l 137 121 q 249 92 189 92 q 332 122 297 92 q 409 263 367 153 l 6 995 "},"ʾ":{"x_min":170,"x_max":293,"ha":463,"o":"m 293 907 q 257 817 293 854 q 170 781 222 781 l 170 833 q 220 855 200 833 q 241 907 241 877 q 220 957 241 936 q 170 979 199 979 l 170 1029 q 256 993 220 1029 q 293 907 293 957 "},"ү":{"x_min":14,"x_max":682,"ha":695,"o":"m 682 721 l 409 0 l 409 -276 l 287 -276 l 287 0 l 14 721 l 144 721 l 294 302 q 346 135 325 216 q 400 302 366 209 l 551 721 l 682 721 "},"¾":{"x_min":22,"x_max":1138,"ha":1158,"o":"m 170 -39 l 917 1012 l 1023 1012 l 277 -39 l 170 -39 m 22 630 l 121 640 q 156 584 134 599 q 225 564 185 564 q 302 590 273 564 q 332 654 332 616 q 307 708 332 688 q 226 729 283 729 q 187 727 192 727 l 201 802 q 282 821 257 801 q 308 871 308 842 q 287 914 308 896 q 227 932 267 932 q 167 916 189 932 q 131 862 146 901 l 34 878 q 104 978 61 949 q 227 1007 146 1007 q 369 970 325 1007 q 414 879 414 934 q 389 813 414 842 q 320 771 365 784 q 409 722 381 756 q 438 641 438 687 q 384 531 438 578 q 231 485 330 485 q 86 522 136 485 q 22 630 36 560 m 969 -21 l 969 83 l 710 83 l 710 166 l 983 488 l 1067 488 l 1067 156 l 1138 156 l 1138 83 l 1067 83 l 1067 -21 l 969 -21 m 969 156 l 969 334 l 814 156 l 969 156 "},"₳":{"x_min":-2,"x_max":928,"ha":926,"o":"m 928 0 l 778 0 l 663 301 l 246 301 l 137 0 l -2 0 l 113 301 l 0 301 l 0 415 l 156 415 l 208 551 l 0 551 l 0 665 l 252 665 l 378 995 l 522 995 l 656 665 l 926 665 l 926 551 l 703 551 l 758 415 l 926 415 l 926 301 l 805 301 l 928 0 m 526 665 l 518 683 q 447 891 470 811 q 393 700 427 790 l 380 665 l 526 665 m 619 415 l 569 551 l 337 551 l 286 415 l 619 415 "},"ᴎ":{"x_min":92,"x_max":684,"ha":776,"o":"m 92 721 l 214 721 l 214 171 l 552 721 l 684 721 l 684 0 l 562 0 l 562 546 l 223 0 l 92 0 l 92 721 "},"Ѭ":{"x_min":130,"x_max":1382,"ha":1463,"o":"m 1382 0 l 1250 0 l 1250 98 q 1173 343 1250 273 q 954 422 1096 413 l 954 0 l 822 0 l 822 422 q 596 342 664 409 q 526 114 526 271 l 526 0 l 394 0 l 394 139 q 492 422 394 318 l 262 422 l 262 0 l 130 0 l 130 995 l 262 995 l 262 539 l 743 539 l 438 995 l 1350 995 l 1027 529 q 1382 127 1382 490 l 1382 0 m 1121 878 l 672 878 l 896 527 l 1121 878 "},"m":{"x_min":91.5625,"x_max":1068.5625,"ha":1159,"o":"m 91 0 l 91 721 l 200 721 l 200 619 q 290 704 234 672 q 419 737 347 737 q 550 703 499 737 q 622 610 601 670 q 845 737 708 737 q 1010 677 952 737 q 1068 494 1068 618 l 1068 0 l 946 0 l 946 453 q 934 559 946 527 q 891 611 922 591 q 818 631 860 631 q 691 580 742 631 q 641 418 641 529 l 641 0 l 519 0 l 519 468 q 489 590 519 549 q 392 631 459 631 q 296 603 340 631 q 233 524 252 576 q 213 373 213 472 l 213 0 l 91 0 "},"Ҏ":{"x_min":107,"x_max":882.984375,"ha":926,"o":"m 882 440 l 819 377 l 740 456 q 493 405 655 405 l 239 405 l 239 0 l 107 0 l 107 995 l 482 995 q 633 985 578 995 q 836 843 778 960 q 866 707 866 782 q 806 517 866 597 l 882 440 m 730 703 q 701 807 730 763 q 615 869 671 854 q 492 878 583 878 l 239 878 l 239 522 l 495 522 q 646 550 592 522 l 572 623 l 635 687 l 710 613 q 730 703 730 651 "},"Е":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 "}," ":{"x_min":0,"x_max":0,"ha":278,"o":"m 0 0 l 0 0 "},"˔":{"x_min":113,"x_max":349,"ha":463,"o":"m 349 121 l 113 121 l 113 191 l 196 191 l 196 346 l 266 346 l 266 191 l 349 191 l 349 121 "},"ᴬ":{"x_min":0,"x_max":629,"ha":629,"o":"m 629 321 l 527 321 l 449 526 l 168 526 l 95 321 l 0 321 l 258 995 l 353 995 l 629 321 m 422 598 l 351 784 q 303 923 316 879 q 267 795 290 855 l 193 598 l 422 598 "},"á":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 295 810 l 384 1000 l 545 1000 l 396 810 l 295 810 "},"Ӻ":{"x_min":-2,"x_max":752,"ha":752,"o":"m 752 878 l 241 878 l 241 543 l 513 543 l 513 453 l 241 453 l 241 105 l 304 105 l 304 -39 q 269 -224 304 -171 q 122 -292 224 -292 q 26 -279 73 -292 l 50 -175 q 107 -185 86 -185 q 175 -132 160 -185 q 182 -36 182 -108 l 182 0 l 109 0 l 109 453 l -2 453 l -2 543 l 109 543 l 109 995 l 752 995 l 752 878 "},"×":{"x_min":109.1875,"x_max":700.609375,"ha":811,"o":"m 109 277 l 322 491 l 109 704 l 192 786 l 405 573 l 617 786 l 699 704 l 487 491 l 700 278 l 617 196 l 404 408 l 191 195 l 109 277 "},"Ӱ":{"x_min":6.5,"x_max":877.5,"ha":882,"o":"m 6 995 l 139 995 l 463 385 l 747 995 l 877 995 l 504 220 q 390 30 434 75 q 261 -14 345 -14 q 137 9 210 -14 l 137 121 q 249 92 189 92 q 332 122 297 92 q 409 263 367 153 l 6 995 m 257 1055 l 257 1194 l 385 1194 l 385 1055 l 257 1055 m 510 1055 l 510 1194 l 638 1194 l 638 1055 l 510 1055 "},"ӆ":{"x_min":16,"x_max":837,"ha":810,"o":"m 837 100 l 696 -204 l 595 -204 l 695 0 l 596 0 l 596 621 l 273 621 l 273 261 q 271 134 273 146 q 220 24 262 60 q 114 -5 183 -5 q 16 0 71 -5 l 16 102 l 69 102 q 145 134 135 102 q 151 245 151 151 l 151 721 l 718 721 l 718 100 l 837 100 "},"ᵡ":{"x_min":0,"x_max":477,"ha":477,"o":"m 477 135 l 382 135 l 238 397 l 92 135 l 0 135 l 193 480 l 14 808 l 105 808 l 239 564 l 375 808 l 467 808 l 285 481 l 477 135 "},"п":{"x_min":92,"x_max":660,"ha":752,"o":"m 92 721 l 660 721 l 660 0 l 538 0 l 538 621 l 214 621 l 214 0 l 92 0 l 92 721 "},"K":{"x_min":102,"x_max":924,"ha":926,"o":"m 102 0 l 102 995 l 234 995 l 234 502 l 727 995 l 906 995 l 488 591 l 924 0 l 750 0 l 396 502 l 234 345 l 234 0 l 102 0 "},"7":{"x_min":66,"x_max":710,"ha":773,"o":"m 66 865 l 66 982 l 710 982 l 710 887 q 521 618 614 786 q 376 273 427 450 q 330 0 340 148 l 205 0 q 251 283 207 117 q 377 604 295 450 q 553 865 460 759 l 66 865 "},"¨":{"x_min":41,"x_max":422,"ha":463,"o":"m 41 861 l 41 1000 l 169 1000 l 169 861 l 41 861 m 294 861 l 294 1000 l 422 1000 l 422 861 l 294 861 "},"Y":{"x_min":4.265625,"x_max":916.265625,"ha":927,"o":"m 387 0 l 387 421 l 4 995 l 162 995 l 359 693 q 460 526 413 610 q 569 702 506 604 l 763 995 l 916 995 l 519 421 l 519 0 l 387 0 "},"E":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 "},"Ô":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 m 541 1170 l 464 1055 l 325 1055 l 471 1245 l 601 1245 l 754 1055 l 615 1055 l 541 1170 "},"Є":{"x_min":74.546875,"x_max":948,"ha":998,"o":"m 581 572 l 581 455 l 211 455 q 303 190 218 287 q 523 94 389 94 q 821 346 760 94 l 948 313 q 532 -17 861 -17 q 182 134 297 -17 q 75 508 67 286 q 126 756 75 644 q 283 940 177 868 q 535 1012 389 1012 q 794 935 690 1012 q 935 722 898 858 l 806 688 q 534 897 749 897 q 306 809 389 897 q 216 572 224 721 l 581 572 "},"Ï":{"x_min":9,"x_max":390,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 m 9 1055 l 9 1194 l 137 1194 l 137 1055 l 9 1055 m 262 1055 l 262 1194 l 390 1194 l 390 1055 l 262 1055 "},"Ѷ":{"x_min":6,"x_max":1105,"ha":1116,"o":"m 1105 926 l 1044 837 q 931 886 972 886 q 843 810 872 886 l 527 0 l 391 0 l 6 995 l 148 995 l 407 271 q 459 109 438 183 q 512 271 481 186 l 735 873 q 901 1012 787 1012 q 1105 926 983 1012 m 655 1055 l 557 1055 l 414 1245 l 573 1245 l 655 1055 m 419 1055 l 316 1055 l 175 1245 l 332 1245 l 419 1055 "},"ҕ":{"x_min":92,"x_max":710,"ha":762,"o":"m 710 65 q 622 -187 710 -87 q 382 -292 531 -292 q 186 -238 267 -292 q 92 -95 103 -183 l 214 -95 q 382 -192 243 -192 q 531 -115 478 -192 q 580 54 580 -47 q 517 223 580 163 q 354 280 458 280 q 214 261 297 280 l 214 0 l 92 0 l 92 721 l 506 721 l 506 621 l 214 621 l 214 364 q 371 388 291 388 q 612 299 517 388 q 710 65 710 209 "},"ˮ":{"x_min":48,"x_max":400,"ha":463,"o":"m 400 891 q 378 760 400 800 q 288 678 349 705 l 258 726 q 332 862 328 754 l 269 862 l 269 1004 l 400 1004 l 400 891 m 190 891 q 168 760 190 800 q 78 678 139 705 l 48 726 q 122 862 118 754 l 59 862 l 59 1004 l 190 1004 l 190 891 "},"ᴇ":{"x_min":92,"x_max":628,"ha":680,"o":"m 628 0 l 92 0 l 92 721 l 611 721 l 611 616 l 214 616 l 214 423 l 585 423 l 585 319 l 214 319 l 214 105 l 628 105 l 628 0 "}," ":{"x_min":0,"x_max":0,"ha":463,"o":"m 0 0 l 0 0 "},"җ":{"x_min":-4,"x_max":923,"ha":929,"o":"m 923 -204 l 823 -204 l 823 0 l 798 0 l 667 223 q 612 299 635 278 q 527 333 576 333 l 527 0 l 402 0 l 402 333 q 316 300 351 333 q 261 223 294 279 l 130 0 l -4 0 l 129 223 q 285 369 205 348 q 193 449 224 397 q 144 566 182 468 q 114 611 130 601 q 59 621 97 621 q 24 621 51 621 l 24 721 l 41 721 q 140 712 113 721 q 210 650 179 701 q 251 561 223 628 q 301 453 290 469 q 402 409 334 409 l 402 721 l 527 721 l 527 409 q 627 453 594 409 q 677 561 639 469 q 740 679 715 653 q 860 721 780 721 l 906 721 l 906 621 l 872 621 q 800 595 821 623 q 766 517 793 585 q 723 428 741 453 q 644 369 697 394 q 799 222 723 348 l 873 100 l 923 100 l 923 -204 "},"й":{"x_min":92,"x_max":684,"ha":776,"o":"m 92 721 l 214 721 l 214 171 l 552 721 l 684 721 l 684 0 l 562 0 l 562 546 l 223 0 l 92 0 l 92 721 m 515 986 l 598 986 q 535 855 587 901 q 397 810 483 810 q 258 855 310 810 q 197 986 207 900 l 280 986 q 317 916 289 939 q 393 894 346 894 q 477 916 448 894 q 515 986 505 938 "},"b":{"x_min":91,"x_max":716,"ha":773,"o":"m 204 0 l 91 0 l 91 995 l 213 995 l 213 640 q 410 737 290 737 q 536 710 477 737 q 634 634 595 683 q 694 517 672 586 q 716 371 716 449 q 624 85 716 186 q 404 -16 532 -16 q 204 90 276 -16 l 204 0 m 203 365 q 238 178 203 236 q 394 84 295 84 q 532 153 474 84 q 591 361 591 223 q 535 569 591 502 q 399 637 479 637 q 261 567 319 637 q 203 365 203 497 "},"ԅ":{"x_min":56,"x_max":1042,"ha":1133,"o":"m 1042 298 q 970 70 1042 152 q 750 -16 894 -16 q 518 73 593 -16 q 465 227 465 138 q 388 314 465 293 q 251 326 347 326 l 251 422 q 335 424 322 422 q 409 460 382 431 q 434 528 434 487 q 401 608 434 580 q 316 637 368 637 q 172 515 213 637 l 56 534 q 317 737 110 737 q 489 682 420 737 q 564 523 564 623 q 478 383 564 435 q 587 235 587 355 q 615 141 587 180 q 752 84 657 84 q 920 303 920 84 l 920 421 l 1042 421 l 1042 298 "},"ӏ":{"x_min":89,"x_max":211,"ha":309,"o":"m 89 0 l 89 995 l 211 995 l 211 0 l 89 0 "},"ᵰ":{"x_min":-49,"x_max":819,"ha":773,"o":"m 819 431 q 677 241 783 292 l 677 0 l 555 0 l 555 221 q 378 275 491 226 q 214 333 260 326 l 214 0 l 92 0 l 92 299 q 41 216 58 268 l -49 216 q 92 404 -12 354 l 92 721 l 202 721 l 202 618 q 431 737 281 737 q 632 652 571 737 q 670 561 659 614 q 677 443 677 528 l 677 345 q 729 431 712 377 l 819 431 m 555 314 l 555 438 q 490 609 555 569 q 405 631 454 631 q 271 581 328 631 q 215 426 221 537 q 387 371 273 419 q 555 314 504 321 "},"ҋ":{"x_min":92,"x_max":803,"ha":776,"o":"m 588 993 q 387 817 566 817 q 187 993 208 817 l 270 993 q 383 901 289 901 q 505 993 486 901 l 588 993 m 803 100 l 662 -204 l 561 -204 l 661 0 l 562 0 l 562 546 l 223 0 l 92 0 l 92 721 l 214 721 l 214 171 l 552 721 l 684 721 l 684 100 l 803 100 "},"‬":{"x_min":-158,"x_max":159,"ha":0,"o":"m 159 667 l 25 667 l 25 -187 l -24 -187 l -24 667 l -158 667 l -158 958 l 159 958 l 159 667 "},"ф":{"x_min":51,"x_max":1092,"ha":1143,"o":"m 511 995 l 633 995 l 633 650 q 716 715 670 694 q 814 737 761 737 q 1017 630 942 737 q 1092 361 1092 523 q 1011 88 1092 192 q 810 -16 930 -16 q 730 -3 771 -16 q 633 62 689 8 l 633 -276 l 511 -276 l 511 62 q 429 3 474 23 q 333 -16 385 -16 q 135 83 220 -16 q 51 367 51 182 q 127 630 51 524 q 333 737 204 737 q 432 715 388 737 q 511 650 476 694 l 511 995 m 632 358 q 677 139 632 195 q 789 83 721 83 q 916 151 863 83 q 969 366 969 220 q 920 570 969 503 q 795 638 871 638 q 673 568 714 638 q 632 358 632 498 m 175 371 q 226 151 175 218 q 353 84 277 84 q 472 150 432 84 q 511 351 511 217 q 470 565 511 494 q 345 637 428 637 q 222 567 270 637 q 175 371 175 497 "},"˥":{"x_min":102,"x_max":430,"ha":532,"o":"m 430 0 l 324 0 l 324 888 l 102 888 l 102 994 l 430 994 l 430 0 "},"Щ":{"x_min":110,"x_max":1254,"ha":1302,"o":"m 110 995 l 242 995 l 242 117 l 571 117 l 571 995 l 703 995 l 703 117 l 1032 117 l 1032 995 l 1164 995 l 1164 117 l 1254 117 l 1254 -276 l 1137 -276 l 1137 0 l 110 0 l 110 995 "},"L":{"x_min":102,"x_max":723,"ha":773,"o":"m 102 0 l 102 995 l 234 995 l 234 117 l 723 117 l 723 0 l 102 0 "},"ᵉ":{"x_min":34,"x_max":482,"ha":516,"o":"m 482 544 l 119 544 q 158 429 123 473 q 265 380 197 380 q 394 478 358 380 l 479 467 q 265 311 436 311 q 92 380 153 311 q 34 560 34 447 q 90 743 34 674 q 261 819 151 819 q 427 744 368 819 q 482 565 482 676 l 482 544 m 395 613 q 363 703 389 672 q 261 750 324 750 q 164 711 201 750 q 124 613 128 672 l 395 613 "},"Ҡ":{"x_min":28,"x_max":1025,"ha":1030,"o":"m 1025 0 l 861 0 l 694 270 q 603 403 632 372 q 462 466 542 466 l 462 0 l 330 0 l 330 878 l 28 878 l 28 995 l 462 995 l 462 560 q 607 615 559 560 q 681 762 632 644 q 736 879 718 850 q 825 968 772 939 q 934 996 874 996 q 1015 994 1010 996 l 1015 880 q 988 881 1006 880 q 962 882 971 882 q 853 833 892 882 q 797 721 832 807 q 737 593 760 626 q 630 509 698 537 q 820 331 726 483 l 1025 0 "},"ʺ":{"x_min":64,"x_max":428,"ha":493,"o":"m 97 643 l 64 832 l 64 995 l 203 995 l 203 832 l 172 643 l 97 643 m 322 643 l 289 832 l 289 995 l 428 995 l 428 832 l 395 643 l 322 643 "},"À":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 546 1055 l 448 1055 l 291 1245 l 454 1245 l 546 1055 "},"ᵞ":{"x_min":0,"x_max":446,"ha":446,"o":"m 446 808 l 263 321 l 263 135 l 180 135 l 180 321 l 0 808 l 86 808 l 221 424 l 361 808 l 446 808 "},"ᵙ":{"x_min":34,"x_max":532,"ha":566,"o":"m 532 531 q 474 395 532 437 q 412 370 450 377 q 335 365 386 365 l 34 365 l 34 448 l 304 448 q 391 453 368 448 q 461 547 461 469 q 390 663 461 634 q 295 677 357 677 l 34 677 l 34 760 l 521 760 l 521 686 l 449 686 q 532 531 532 629 "},"˅":{"x_min":69,"x_max":742,"ha":811,"o":"m 742 819 l 461 161 l 347 161 l 69 819 l 191 819 l 404 297 l 620 819 l 742 819 "},"ᵅ":{"x_min":34,"x_max":456,"ha":524,"o":"m 456 321 l 373 321 l 373 374 q 245 311 328 311 q 86 392 145 311 q 34 569 34 466 q 133 789 34 727 q 239 819 181 819 q 381 743 329 819 l 381 808 l 456 808 l 456 321 m 381 559 q 341 705 381 657 q 246 754 301 754 q 156 708 194 754 q 119 567 119 662 q 147 442 119 492 q 252 380 183 380 q 353 439 319 380 q 381 559 381 488 "},"½":{"x_min":72,"x_max":1134,"ha":1158,"o":"m 154 -39 l 901 1012 l 1007 1012 l 261 -39 l 154 -39 m 224 498 l 224 873 q 72 797 154 818 l 72 880 q 165 929 114 893 q 249 1007 217 965 l 322 1007 l 322 498 l 224 498 m 712 -21 q 744 55 716 16 q 884 184 786 114 q 1000 276 982 255 q 1026 333 1026 304 q 1002 386 1026 365 q 931 407 978 407 q 864 390 886 407 q 828 330 842 374 l 726 340 q 794 452 745 416 q 933 488 843 488 q 1084 448 1036 488 q 1132 350 1132 408 q 1091 242 1132 293 q 953 126 1061 204 q 872 61 895 84 l 1134 61 l 1134 -21 l 712 -21 "},"ᴧ":{"x_min":18,"x_max":679,"ha":695,"o":"m 679 0 l 553 0 l 393 439 q 348 576 364 519 q 301 431 326 501 l 146 0 l 18 0 l 292 721 l 406 721 l 679 0 "},"ԍ":{"x_min":54,"x_max":682,"ha":776,"o":"m 682 361 q 385 -16 682 -16 q 135 92 224 -16 q 54 357 54 192 q 134 627 54 526 q 382 737 220 737 q 670 509 625 737 l 551 491 q 386 637 517 637 q 179 361 179 637 q 221 172 179 243 q 383 84 273 84 q 512 136 462 84 q 560 260 560 186 l 351 260 l 351 361 l 682 361 "},"'":{"x_min":61,"x_max":200,"ha":265,"o":"m 92 643 l 61 828 l 61 995 l 200 995 l 200 828 l 167 643 l 92 643 "},"Ҽ":{"x_min":7,"x_max":1134,"ha":1196,"o":"m 1134 423 l 360 423 q 447 187 368 272 q 678 98 530 98 q 949 307 892 98 l 1078 273 q 931 55 1040 131 q 678 -17 827 -17 q 435 49 543 -17 q 269 238 324 117 q 222 423 232 318 q 7 604 7 423 q 19 700 7 653 l 123 672 q 114 614 114 635 q 153 547 114 563 q 219 540 172 539 q 325 859 227 730 q 676 1012 440 1012 q 1026 860 906 1012 q 1134 486 1134 723 l 1134 423 m 998 540 q 913 793 991 697 q 676 901 828 901 q 439 793 524 901 q 355 540 361 697 l 998 540 "},"Р":{"x_min":107,"x_max":866,"ha":926,"o":"m 107 0 l 107 995 l 482 995 q 633 985 581 995 q 756 939 706 973 q 835 843 805 904 q 866 707 866 781 q 785 492 866 580 q 493 405 704 405 l 239 405 l 239 0 l 107 0 m 239 522 l 495 522 q 676 569 623 522 q 730 703 730 617 q 698 810 730 765 q 615 869 667 854 q 492 878 582 878 l 239 878 l 239 522 "},"˾":{"x_min":20,"x_max":531,"ha":552,"o":"m 531 -285 l 20 -285 l 20 -30 l 124 -30 l 124 -181 l 531 -181 l 531 -285 "},"ʴ":{"x_min":0,"x_max":265,"ha":333,"o":"m 265 321 l 190 321 l 190 394 q 85 310 143 310 q 0 336 42 310 l 28 412 q 89 395 58 395 q 168 456 149 395 q 182 552 182 499 l 182 808 l 265 808 l 265 321 "},"˛":{"x_min":51,"x_max":281,"ha":463,"o":"m 234 0 q 174 -58 195 -23 q 153 -129 153 -93 q 168 -178 153 -158 q 219 -198 184 -198 q 251 -193 234 -198 q 281 -181 267 -189 l 281 -268 q 188 -292 231 -292 q 128 -282 154 -292 q 85 -254 102 -272 q 59 -215 67 -237 q 51 -167 51 -192 q 75 -79 51 -123 q 144 0 99 -35 l 234 0 "},"ᴕ":{"x_min":46,"x_max":589,"ha":635,"o":"m 589 256 q 515 59 589 134 q 317 -16 441 -16 q 117 58 190 -16 q 46 256 46 131 q 90 407 46 337 q 215 498 139 484 l 215 506 q 108 590 152 519 q 66 721 66 655 l 191 721 q 220 614 191 659 q 317 561 255 561 q 414 614 379 561 q 444 721 444 659 l 569 721 q 526 590 569 655 q 419 506 482 519 l 419 498 q 544 407 495 485 q 589 256 589 337 m 464 261 q 428 382 464 332 q 317 439 387 439 q 206 382 247 439 q 171 261 171 332 q 205 139 171 188 q 317 84 244 84 q 429 139 390 84 q 464 261 464 188 "},"ᵹ":{"x_min":49,"x_max":724,"ha":773,"o":"m 724 45 q 637 -186 724 -91 q 383 -290 541 -290 q 134 -187 227 -290 q 49 42 49 -93 q 135 257 49 160 q 374 370 231 364 q 330 454 330 404 q 381 542 330 503 l 485 622 l 112 622 l 112 721 l 655 721 l 655 632 l 495 514 q 445 453 445 477 q 497 390 445 426 q 666 238 619 304 q 724 45 724 158 m 599 41 q 549 198 599 133 q 386 276 491 276 q 224 200 283 276 q 174 41 174 135 q 227 -113 174 -45 q 389 -190 288 -190 q 550 -113 493 -190 q 599 41 599 -47 "},"Ѿ":{"x_min":74,"x_max":1784,"ha":1858,"o":"m 1784 492 q 1647 124 1784 263 q 1276 -17 1509 -17 q 929 91 1095 -17 q 582 -17 763 -17 q 210 124 348 -17 q 74 492 74 263 q 207 870 74 729 q 571 1012 341 1012 q 865 917 760 1012 l 781 831 q 572 899 701 899 q 298 785 393 899 q 210 500 210 679 q 302 212 210 318 q 574 102 398 102 q 728 129 648 102 q 865 205 812 158 l 865 507 l 994 507 l 994 205 q 1130 129 1046 158 q 1283 102 1210 102 q 1555 212 1459 102 q 1648 500 1648 318 q 1560 785 1648 679 q 1285 899 1464 899 q 1077 831 1157 899 l 994 917 q 1286 1012 1098 1012 q 1650 870 1517 1012 q 1784 492 1784 729 m 1234 1187 l 1172 1055 l 1149 1055 l 1118 1123 l 967 1123 l 935 1055 l 911 1055 l 880 1123 l 729 1123 l 697 1055 l 674 1055 l 613 1187 l 1234 1187 "},"Т":{"x_min":32,"x_max":821,"ha":849,"o":"m 360 0 l 360 878 l 32 878 l 32 995 l 821 995 l 821 878 l 492 878 l 492 0 l 360 0 "},"˓":{"x_min":170,"x_max":293,"ha":463,"o":"m 293 68 q 205 104 240 68 q 170 194 170 141 q 206 280 170 244 q 293 316 242 316 l 293 266 q 242 244 263 266 q 222 194 222 223 q 242 142 222 164 q 293 120 262 120 l 293 68 "},"£":{"x_min":18,"x_max":734,"ha":773,"o":"m 267 549 l 482 549 l 482 449 l 289 449 q 302 389 302 419 q 273 264 302 330 q 181 130 245 198 q 278 145 234 145 q 406 128 335 145 q 564 101 522 101 q 695 139 614 101 l 734 27 q 637 -7 671 0 q 569 -16 602 -16 q 511 -10 540 -16 q 423 14 492 -7 q 333 39 353 35 q 269 45 301 45 q 165 27 220 45 q 64 -19 110 10 l 18 98 q 128 201 83 134 q 174 364 174 268 q 162 449 174 406 l 30 449 l 30 549 l 133 549 q 105 659 111 625 q 99 728 99 694 q 203 948 99 869 q 407 1012 287 1012 q 609 944 530 1012 q 708 755 689 877 l 587 737 q 526 865 576 818 q 404 912 475 912 q 279 863 329 912 q 229 746 229 814 q 267 549 229 670 "},"ᴥ":{"x_min":21,"x_max":823,"ha":843,"o":"m 823 106 q 639 -21 741 -21 q 533 7 574 -21 q 457 88 504 27 l 420 137 l 385 88 q 311 7 341 27 q 204 -21 270 -21 q 21 106 102 -21 l 88 184 q 207 86 139 86 q 270 134 232 86 l 344 230 l 233 376 q 185 529 185 439 q 257 679 185 619 q 422 737 327 737 q 586 679 518 737 q 658 529 658 620 q 609 376 658 439 l 498 230 l 573 134 q 636 86 611 86 q 755 184 704 86 l 823 106 "},"а":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 "},"ә":{"x_min":57.328125,"x_max":722,"ha":773,"o":"m 722 366 q 638 95 722 199 q 385 -16 548 -16 q 138 94 226 -16 q 57 359 57 196 q 58 392 57 370 l 597 392 q 538 563 590 497 q 377 637 480 637 q 186 489 239 637 l 61 504 q 378 737 124 737 q 635 633 544 737 q 722 366 722 535 m 590 292 l 186 292 q 232 154 194 200 q 384 84 290 84 q 530 144 473 84 q 590 292 584 201 "},"v":{"x_min":18,"x_max":678,"ha":694,"o":"m 290 0 l 18 721 l 146 721 l 301 289 q 347 143 326 219 q 392 281 363 200 l 552 721 l 678 721 l 406 0 l 290 0 "},"Ї":{"x_min":9,"x_max":390,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 m 9 1055 l 9 1194 l 137 1194 l 137 1055 l 9 1055 m 262 1055 l 262 1194 l 390 1194 l 390 1055 l 262 1055 "},"Ѯ":{"x_min":69,"x_max":783,"ha":839,"o":"m 783 284 q 371 -17 783 -17 q 262 -33 310 -17 q 195 -102 195 -56 q 313 -179 195 -179 q 447 -146 356 -179 q 578 -114 539 -114 q 683 -163 643 -114 q 719 -276 719 -208 l 616 -276 q 571 -225 616 -225 q 463 -258 558 -225 q 314 -292 368 -292 q 145 -250 208 -292 q 69 -102 69 -201 q 174 59 69 8 q 371 96 251 96 q 645 279 645 96 q 568 418 645 371 q 407 458 505 458 l 344 458 l 344 573 q 465 579 430 573 q 565 633 525 591 q 605 735 605 675 q 547 855 605 810 q 417 897 495 897 q 215 759 260 897 q 195 667 195 698 l 69 695 q 328 1003 108 961 l 221 1239 l 319 1239 l 419 1012 l 498 1167 q 605 1247 538 1247 q 694 1184 665 1247 l 637 1154 q 615 1175 627 1175 q 579 1134 599 1175 l 512 1001 q 637 942 582 985 q 736 741 736 865 q 604 525 736 602 q 734 436 686 502 q 783 284 783 370 "},"û":{"x_min":89,"x_max":673,"ha":773,"o":"m 564 0 l 564 105 q 335 -16 479 -16 q 216 8 271 -16 q 134 69 160 32 q 96 160 107 106 q 89 274 89 196 l 89 721 l 211 721 l 211 321 q 218 192 211 225 q 267 116 230 143 q 359 89 304 89 q 462 117 414 89 q 530 193 510 145 q 551 334 551 242 l 551 721 l 673 721 l 673 0 l 564 0 m 383 925 l 306 810 l 167 810 l 313 1000 l 443 1000 l 596 810 l 457 810 l 383 925 "},"ʻ":{"x_min":87,"x_max":229,"ha":309,"o":"m 229 964 q 154 827 157 934 l 218 827 l 218 685 l 87 685 l 87 797 q 108 928 87 887 q 199 1011 137 983 l 229 964 "},"ˉ":{"x_min":20,"x_max":443,"ha":463,"o":"m 20 832 l 20 932 l 443 932 l 443 832 l 20 832 "},"ᵎ":{"x_min":68,"x_max":151,"ha":218,"o":"m 151 321 l 68 321 l 68 808 l 151 808 l 151 321 m 151 135 l 68 135 l 68 230 l 151 230 l 151 135 "},"ᴮ":{"x_min":34,"x_max":542,"ha":576,"o":"m 542 516 q 472 365 542 418 q 290 321 413 321 l 34 321 l 34 995 l 286 995 q 482 911 431 995 q 509 822 509 868 q 415 679 509 726 q 542 516 542 641 m 422 811 q 359 906 422 886 q 257 916 329 916 l 123 916 l 123 711 l 268 711 q 353 719 326 711 q 422 811 422 739 m 450 516 q 377 621 450 597 q 279 632 344 632 l 123 632 l 123 400 l 290 400 q 350 403 331 400 q 436 459 412 414 q 450 516 450 485 "},"ӻ":{"x_min":-0.0625,"x_max":507,"ha":507,"o":"m 507 621 l 214 621 l 214 439 l 371 439 l 371 349 l 214 349 l 214 105 l 277 105 l 277 -39 q 242 -224 277 -171 q 95 -292 197 -292 q 0 -279 46 -292 l 23 -175 q 80 -185 59 -185 q 148 -132 133 -185 q 155 -36 155 -108 l 155 0 l 92 0 l 92 349 l 8 349 l 8 439 l 92 439 l 92 721 l 507 721 l 507 621 "},"₤":{"x_min":18,"x_max":734,"ha":773,"o":"m 292 417 l 481 417 l 481 317 l 290 317 q 180 130 267 219 q 276 145 233 145 q 405 128 335 145 q 567 101 521 101 q 695 139 614 101 l 734 27 q 572 -16 634 -16 q 424 13 522 -16 q 274 45 321 45 q 64 -19 162 45 l 18 98 q 171 317 149 174 l 30 317 l 30 417 l 171 417 q 143 518 168 438 l 30 518 l 30 618 l 114 618 q 99 731 99 679 q 188 937 99 862 q 409 1012 278 1012 q 606 946 522 1012 q 708 754 690 881 l 587 736 q 527 862 578 813 q 404 912 477 912 q 276 861 324 912 q 229 747 229 810 q 247 618 229 708 l 481 618 l 481 518 l 271 518 q 292 417 288 446 "},"‒":{"x_min":-3,"x_max":770,"ha":773,"o":"m -3 311 l -3 409 l 770 409 l 770 311 l -3 311 "},"x":{"x_min":10,"x_max":685,"ha":695,"o":"m 10 0 l 274 373 l 30 721 l 180 721 l 294 552 q 343 472 325 504 q 398 549 374 514 l 520 721 l 667 721 l 423 374 l 685 0 l 536 0 l 386 223 l 351 276 l 159 0 l 10 0 "},"è":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 m 485 810 l 387 810 l 230 1000 l 393 1000 l 485 810 "},"⸗":{"x_min":44,"x_max":420,"ha":463,"o":"m 420 503 l 44 340 l 44 463 l 420 626 l 420 503 m 420 257 l 44 94 l 44 217 l 420 380 l 420 257 "},"⁬":{"x_min":-158,"x_max":159,"ha":0,"o":"m 25 -187 l -24 -187 l -24 711 l -158 958 l 159 958 l 25 711 l 25 -187 "},".":{"x_min":126,"x_max":265,"ha":386,"o":"m 126 0 l 126 139 l 265 139 l 265 0 l 126 0 "},"Ѡ":{"x_min":74,"x_max":1784,"ha":1858,"o":"m 1784 492 q 1647 124 1784 263 q 1276 -17 1509 -17 q 929 91 1095 -17 q 582 -17 763 -17 q 210 124 348 -17 q 74 492 74 263 q 207 870 74 729 q 571 1012 341 1012 q 865 917 760 1012 l 781 831 q 572 899 701 899 q 298 785 393 899 q 210 500 210 679 q 302 212 210 318 q 574 102 398 102 q 728 129 648 102 q 865 205 812 158 l 865 507 l 994 507 l 994 205 q 1130 129 1046 158 q 1283 102 1210 102 q 1555 212 1459 102 q 1648 500 1648 318 q 1560 785 1648 679 q 1285 899 1464 899 q 1077 831 1157 899 l 994 917 q 1286 1012 1098 1012 q 1650 870 1517 1012 q 1784 492 1784 729 "},"ӑ":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 570 986 q 369 810 548 810 q 169 986 190 810 l 252 986 q 365 894 271 894 q 487 986 468 894 l 570 986 "},"‘":{"x_min":87,"x_max":229,"ha":309,"o":"m 218 827 l 218 685 l 87 685 l 87 797 q 108 928 87 888 q 199 1011 137 983 l 229 963 q 173 917 191 947 q 154 827 156 886 l 218 827 "},"Ѩ":{"x_min":130,"x_max":1243,"ha":1247,"o":"m 1243 0 l 1101 0 l 960 391 l 842 391 l 842 0 l 720 0 l 720 391 l 599 391 l 454 0 l 320 0 l 475 391 l 262 391 l 262 0 l 130 0 l 130 995 l 262 995 l 262 495 l 516 495 l 715 995 l 849 995 l 1243 0 m 922 495 l 782 885 l 637 495 l 922 495 "},"ᵫ":{"x_min":89,"x_max":1204,"ha":1262,"o":"m 1204 361 q 1203 329 1204 350 l 673 329 q 727 157 679 221 q 884 84 783 84 q 1075 232 1021 84 l 1200 216 q 883 -16 1136 -16 q 639 81 732 -16 q 599 137 615 106 q 355 -16 538 -16 q 89 274 89 -16 l 89 721 l 211 721 l 211 321 q 234 162 211 211 q 366 89 269 89 q 551 334 551 89 l 551 721 l 673 721 l 673 672 q 876 737 757 737 q 1123 626 1035 737 q 1204 361 1204 524 m 1075 429 q 1028 566 1066 520 q 877 637 970 637 q 732 576 789 637 q 673 429 679 519 l 1075 429 "},"9":{"x_min":58,"x_max":712,"ha":773,"o":"m 76 230 l 193 241 q 250 120 207 157 q 358 83 292 83 q 457 108 414 83 q 527 177 500 134 q 572 294 553 220 q 590 443 590 367 q 590 467 590 451 q 489 373 553 409 q 352 337 426 337 q 143 426 229 337 q 58 662 58 516 q 147 906 58 814 q 370 999 236 999 q 548 946 467 999 q 670 797 628 894 q 712 517 712 701 q 670 214 712 327 q 547 42 629 101 q 355 -17 465 -17 q 164 47 238 -17 q 76 230 90 112 m 576 669 q 520 836 576 774 q 385 898 464 898 q 243 831 303 898 q 183 658 183 764 q 240 504 183 563 q 381 445 297 445 q 521 504 466 445 q 576 669 576 563 "},"ԝ":{"x_min":3.5,"x_max":992.5,"ha":1003,"o":"m 221 0 l 3 721 l 131 721 l 244 304 l 286 150 q 324 298 289 161 l 441 721 l 564 721 l 673 302 l 708 164 l 749 303 l 873 721 l 992 721 l 767 0 l 640 0 l 526 431 l 497 554 l 349 0 l 221 0 "},"l":{"x_min":89,"x_max":211,"ha":309,"o":"m 89 0 l 89 995 l 211 995 l 211 0 l 89 0 "},"Ъ":{"x_min":0,"x_max":1052,"ha":1099,"o":"m 0 995 l 434 995 l 434 570 l 672 570 q 979 483 906 570 q 1052 287 1052 396 q 967 81 1052 162 q 680 0 883 0 l 302 0 l 302 878 l 0 878 l 0 995 m 434 112 l 674 112 q 854 153 798 112 q 910 286 910 195 q 877 390 910 348 q 789 445 844 433 q 609 457 735 457 l 434 457 l 434 112 "}," ":{"x_min":0,"x_max":0,"ha":116,"o":"m 0 0 l 0 0 "},"Ü":{"x_min":109,"x_max":891,"ha":1003,"o":"m 759 995 l 891 995 l 891 420 q 857 181 891 270 q 734 38 823 93 q 502 -17 646 -17 q 273 31 362 -17 q 146 170 184 79 q 109 420 109 261 l 109 995 l 241 995 l 241 420 q 265 229 241 291 q 347 135 289 168 q 490 102 406 102 q 697 167 635 102 q 759 420 759 233 l 759 995 m 309 1055 l 309 1194 l 437 1194 l 437 1055 l 309 1055 m 562 1055 l 562 1194 l 690 1194 l 690 1055 l 562 1055 "},"à":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 501 810 l 403 810 l 246 1000 l 409 1000 l 501 810 "},"ó":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 m 283 810 l 372 1000 l 533 1000 l 384 810 l 283 810 "},"₴":{"x_min":11,"x_max":763,"ha":773,"o":"m 763 328 l 181 328 q 175 274 175 304 q 221 143 175 197 q 375 82 276 82 q 527 140 471 82 q 585 265 573 188 l 708 241 q 607 49 697 119 q 377 -21 518 -21 q 239 4 307 -21 q 130 71 170 29 q 50 282 50 155 q 53 328 50 304 l 11 328 l 11 442 l 96 442 q 217 536 138 501 q 357 578 234 544 l 11 578 l 11 692 l 552 692 q 565 760 565 721 q 524 869 565 823 q 377 924 475 924 q 244 874 288 924 q 199 764 209 836 l 74 783 q 170 965 90 899 q 366 1028 245 1028 q 594 961 518 1028 q 687 750 687 880 q 681 692 687 719 l 763 692 l 763 578 l 626 578 q 565 529 600 548 q 339 453 513 499 q 302 442 319 448 l 763 442 l 763 328 "},"¦":{"x_min":128,"x_max":234,"ha":361,"o":"m 234 1011 l 234 474 l 128 474 l 128 1011 l 234 1011 m 234 243 l 234 -293 l 128 -293 l 128 243 l 234 243 "},"Ѣ":{"x_min":14,"x_max":1030,"ha":1080,"o":"m 1030 289 q 658 0 1030 0 l 281 0 l 281 728 l 14 728 l 14 845 l 281 845 l 281 995 l 413 995 l 413 845 l 680 845 l 680 728 l 413 728 l 413 570 l 650 570 q 847 547 775 570 q 997 426 954 514 q 1030 289 1030 359 m 888 289 q 770 444 888 417 q 588 457 716 457 l 413 457 l 413 112 l 653 112 q 818 145 764 112 q 888 289 888 186 "},"Ӈ":{"x_min":111,"x_max":891,"ha":1003,"o":"m 891 220 q 772 -163 891 -26 q 472 -292 661 -292 q 233 -237 337 -292 q 111 -95 127 -180 l 243 -95 q 313 -151 254 -125 q 467 -179 380 -179 q 680 -76 602 -179 q 759 207 759 25 l 759 469 l 243 469 l 243 0 l 111 0 l 111 995 l 243 995 l 243 586 l 759 586 l 759 995 l 891 995 l 891 220 "},"ᵃ":{"x_min":34,"x_max":483,"ha":517,"o":"m 483 321 l 396 321 q 380 381 384 346 q 201 311 296 311 q 85 344 129 311 q 34 449 34 381 q 93 563 34 523 q 153 590 120 581 q 226 602 175 596 q 374 631 326 614 l 375 651 q 351 722 375 701 q 257 750 319 750 q 172 731 200 750 q 129 658 142 710 l 48 668 q 157 802 69 770 q 268 819 204 819 q 427 767 384 819 q 452 711 446 744 q 457 635 457 691 l 457 525 q 457 420 457 429 q 483 321 461 359 m 374 536 l 374 566 q 238 534 329 547 q 157 514 209 530 q 122 452 122 493 q 220 375 122 375 q 360 452 322 375 q 374 536 374 481 "},"₢":{"x_min":69,"x_max":948,"ha":1003,"o":"m 948 315 q 803 71 907 158 q 536 -17 696 -17 q 182 134 305 -17 q 69 504 69 272 q 192 868 69 730 q 538 1012 320 1012 q 787 937 685 1012 q 931 722 890 862 l 801 691 q 535 899 734 899 q 280 780 366 899 q 205 505 205 677 q 255 256 205 358 q 429 108 313 141 l 429 585 l 539 585 l 539 475 q 694 601 608 601 q 820 561 756 601 l 777 448 q 688 475 733 475 q 571 384 599 475 q 551 241 551 319 l 551 96 q 816 348 764 110 l 948 315 "},"ҁ":{"x_min":54,"x_max":671,"ha":695,"o":"m 671 509 l 552 491 q 387 637 517 637 q 179 361 179 637 q 380 84 179 84 q 445 92 417 84 l 445 -276 l 323 -276 l 323 -12 q 119 107 190 1 q 54 357 54 204 q 134 627 54 526 q 382 737 221 737 q 572 680 498 737 q 671 509 649 620 "},"Ҧ":{"x_min":109,"x_max":1517,"ha":1579,"o":"m 1517 220 q 1402 -163 1517 -27 q 1105 -292 1293 -292 q 874 -234 977 -292 q 759 -95 771 -176 l 891 -95 q 951 -148 902 -124 q 1099 -179 1012 -179 q 1309 -76 1233 -179 q 1385 209 1385 26 q 1142 546 1385 546 q 891 484 1036 546 l 891 0 l 759 0 l 759 878 l 241 878 l 241 0 l 109 0 l 109 995 l 891 995 l 891 594 q 1160 660 1037 660 q 1439 524 1348 660 q 1517 220 1517 410 "},"е":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 "},"ᵝ":{"x_min":68,"x_max":501,"ha":535,"o":"m 501 512 q 445 367 501 424 q 302 311 390 311 q 150 384 203 311 l 150 135 l 68 135 l 68 783 q 160 976 68 924 q 273 1006 212 1006 q 403 960 351 1006 q 460 836 460 913 q 425 740 460 781 q 334 691 390 700 q 456 635 411 683 q 501 512 501 588 m 415 507 q 393 588 415 551 q 330 644 369 629 q 234 658 294 658 l 223 658 l 223 718 q 384 831 384 718 q 350 907 384 878 q 269 937 317 937 q 201 918 233 937 q 157 865 166 898 q 150 769 150 836 l 150 584 q 156 484 150 512 q 208 401 168 435 q 291 372 244 372 q 383 411 349 372 q 415 507 415 449 "},"ᴛ":{"x_min":27,"x_max":611,"ha":636,"o":"m 27 721 l 611 721 l 611 621 l 380 621 l 380 0 l 258 0 l 258 621 l 27 621 l 27 721 "},"Î":{"x_min":-19.5,"x_max":409.5,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 m 196 1170 l 119 1055 l -19 1055 l 126 1245 l 256 1245 l 409 1055 l 270 1055 l 196 1170 "},"˻":{"x_min":115,"x_max":352,"ha":463,"o":"m 352 -276 l 115 -276 l 115 -51 l 185 -51 l 185 -206 l 352 -206 l 352 -276 "},"e":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 "},"ᵤ":{"x_min":68,"x_max":463,"ha":531,"o":"m 463 -90 l 389 -90 l 389 -17 q 234 -100 332 -100 q 98 -42 140 -100 q 73 19 80 -18 q 68 95 68 45 l 68 397 l 151 397 l 151 127 q 156 40 151 63 q 250 -29 172 -29 q 366 41 337 -29 q 380 136 380 74 l 380 397 l 463 397 l 463 -90 "},"ʱ":{"x_min":68,"x_max":465,"ha":532,"o":"m 465 321 l 382 321 l 382 629 q 279 748 382 748 q 164 677 194 748 q 151 587 151 645 l 151 321 l 68 321 l 68 860 q 204 1004 68 1004 q 281 995 239 1004 l 268 924 q 219 929 242 929 q 165 911 179 929 q 151 853 151 894 l 151 752 q 296 819 208 819 q 448 738 411 819 q 465 629 465 700 l 465 321 "},"₨":{"x_min":109,"x_max":1563,"ha":1617,"o":"m 1563 212 q 1424 13 1563 74 q 1272 -16 1356 -16 q 965 215 1006 -16 l 1086 234 q 1272 84 1107 84 q 1381 108 1336 84 q 1438 198 1438 139 q 1401 264 1438 240 q 1277 305 1377 280 q 1131 346 1165 333 q 1012 433 1044 380 q 985 529 985 477 q 1067 686 985 627 q 1250 737 1136 737 q 1493 646 1428 737 q 1536 535 1524 605 l 1417 519 q 1259 637 1400 637 q 1103 544 1103 637 q 1164 468 1103 493 q 1272 437 1182 461 q 1414 397 1396 404 q 1533 316 1500 366 q 1563 212 1563 274 m 985 0 l 819 0 l 688 207 q 614 315 644 276 q 526 410 562 388 q 466 437 496 430 q 393 442 446 442 l 241 442 l 241 0 l 109 0 l 109 995 l 549 995 q 725 977 665 995 q 862 873 815 950 q 904 723 904 805 q 623 452 904 491 q 702 403 676 427 q 812 270 761 348 l 985 0 m 768 723 q 555 885 768 885 l 241 885 l 241 556 l 523 556 q 741 634 690 556 q 768 723 768 676 "},"₪":{"x_min":105,"x_max":1026,"ha":1131,"o":"m 757 536 l 757 233 l 643 233 l 643 525 q 619 600 643 577 q 542 623 595 623 l 219 623 l 219 0 l 105 0 l 105 720 l 565 720 q 708 669 659 720 q 757 536 757 618 m 374 0 l 374 486 l 488 486 l 488 97 l 811 97 q 891 123 871 97 q 912 194 912 149 l 912 720 l 1026 720 l 1026 183 q 979 52 1026 105 q 834 0 933 0 l 374 0 "},"ᴟ":{"x_min":46,"x_max":783,"ha":829,"o":"m 783 103 q 540 -119 783 -119 l 46 -119 l 46 3 l 499 3 q 588 9 561 3 q 657 57 633 20 q 677 130 677 88 q 464 307 677 307 l 46 307 l 46 429 l 514 429 q 677 556 677 429 q 570 715 677 675 q 419 735 518 735 l 46 735 l 46 857 l 767 857 l 767 748 l 665 748 q 783 529 783 672 q 656 325 783 370 q 783 103 783 240 "}," ":{"x_min":0,"x_max":0,"ha":695,"o":"m 0 0 l 0 0 "},"Ѓ":{"x_min":109,"x_max":752,"ha":752,"o":"m 109 995 l 752 995 l 752 878 l 241 878 l 241 0 l 109 0 l 109 995 m 354 1055 l 443 1245 l 604 1245 l 455 1055 l 354 1055 "},"ò":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 m 482 810 l 384 810 l 227 1000 l 390 1000 l 482 810 "},"Ѽ":{"x_min":74,"x_max":1580,"ha":1654,"o":"m 1308 1127 q 1120 1165 1208 1127 q 983 1234 1051 1199 q 827 1273 904 1273 q 655 1127 690 1273 l 561 1127 q 647 1288 581 1225 q 835 1360 723 1360 q 1067 1289 926 1360 q 1308 1219 1207 1219 l 1308 1127 m 886 1152 q 864 1064 886 1094 q 789 1012 843 1034 l 766 1057 q 810 1081 800 1071 q 825 1127 825 1095 l 773 1127 l 773 1222 l 886 1222 l 886 1152 m 1580 492 q 1461 124 1580 259 q 1105 -17 1336 -17 q 826 50 947 -17 q 547 -17 706 -17 q 192 124 317 -17 q 74 492 74 259 q 196 866 74 728 q 558 1012 325 1012 q 770 954 672 1012 l 701 857 q 559 899 638 899 q 292 785 381 899 q 210 500 210 682 q 540 102 210 102 q 826 198 699 102 q 1113 102 953 102 q 1444 500 1444 102 q 1362 785 1444 682 q 1094 899 1272 899 q 952 857 1015 899 l 884 954 q 1095 1012 981 1012 q 1457 866 1328 1012 q 1580 492 1580 728 "},"^":{"x_min":37.09375,"x_max":615.09375,"ha":652,"o":"m 162 468 l 37 468 l 276 1011 l 374 1011 l 615 468 l 492 468 l 325 872 l 162 468 "},"∙":{"x_min":125,"x_max":264,"ha":386,"o":"m 125 420 l 125 559 l 264 559 l 264 420 l 125 420 "},"ᴊ":{"x_min":45.9375,"x_max":495,"ha":587,"o":"m 495 230 q 438 52 495 117 q 265 -16 377 -16 q 103 45 164 -16 q 46 205 43 106 l 159 217 q 266 84 164 84 q 373 224 373 84 l 373 721 l 495 721 l 495 230 "},"к":{"x_min":91,"x_max":619,"ha":608,"o":"m 91 721 l 213 721 l 213 409 q 295 431 271 409 q 364 561 318 453 q 422 674 400 647 q 474 711 444 701 q 567 721 503 721 l 592 721 l 592 620 l 558 621 q 496 606 509 621 q 452 517 481 591 q 401 419 424 446 q 330 369 378 392 q 485 223 409 348 l 619 0 l 484 0 l 353 222 q 283 311 313 290 q 213 333 254 333 l 213 0 l 91 0 l 91 721 "},"Ӑ":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 663 1231 q 462 1055 641 1055 q 262 1231 283 1055 l 345 1231 q 458 1139 364 1139 q 580 1231 561 1139 l 663 1231 "},"￼":{"x_min":0,"x_max":1389,"ha":1389,"o":"m 1389 780 l 1321 780 l 1321 931 l 1170 931 l 1170 999 l 1389 999 l 1389 780 m 999 931 l 780 931 l 780 999 l 999 999 l 999 931 m 1389 390 l 1321 390 l 1321 609 l 1389 609 l 1389 390 m 1208 414 q 1065 251 1208 251 q 972 281 1007 251 l 1021 335 q 1064 317 1038 317 q 1129 410 1129 317 l 1129 739 l 1208 739 l 1208 414 m 609 931 l 390 931 l 390 999 l 609 999 l 609 931 m 1389 0 l 1170 0 l 1170 68 l 1321 68 l 1321 219 l 1389 219 l 1389 0 m 965 400 q 778 259 965 259 l 616 259 l 616 739 l 775 739 q 945 612 945 739 q 884 514 945 551 q 965 400 965 483 m 219 931 l 68 931 l 68 780 l 0 780 l 0 999 l 219 999 l 219 931 m 999 0 l 780 0 l 780 68 l 999 68 l 999 0 m 579 498 q 523 316 579 381 q 363 251 467 251 q 205 316 260 251 q 151 498 151 381 q 205 681 151 616 q 363 747 260 747 q 523 681 467 747 q 579 498 579 616 m 68 390 l 0 390 l 0 609 l 68 609 l 68 390 m 609 0 l 390 0 l 390 68 l 609 68 l 609 0 m 219 0 l 0 0 l 0 219 l 68 219 l 68 68 l 219 68 l 219 0 m 866 605 q 755 673 866 673 l 695 673 l 695 541 l 763 541 q 866 605 866 541 m 886 400 q 770 475 886 475 l 695 475 l 695 325 l 778 325 q 886 400 886 325 m 500 498 q 363 681 500 681 q 230 498 230 681 q 363 317 230 317 q 500 498 500 317 "},"ᵒ":{"x_min":34,"x_max":490,"ha":524,"o":"m 490 571 q 379 340 490 401 q 262 311 325 311 q 90 383 150 311 q 34 565 34 451 q 109 764 34 699 q 262 819 172 819 q 431 747 369 819 q 490 571 490 680 m 405 568 q 372 692 405 643 q 262 750 334 750 q 150 692 187 750 q 119 565 119 643 q 150 437 119 487 q 262 380 187 380 q 373 439 336 380 q 405 568 405 489 "},"ѻ":{"x_min":19,"x_max":832,"ha":850,"o":"m 832 360 q 752 119 832 219 q 532 -5 670 15 q 426 -78 503 -78 q 320 -5 348 -78 q 98 119 180 15 q 19 360 19 219 q 98 601 19 501 q 320 726 180 705 q 426 799 348 799 q 532 726 503 799 q 752 601 670 705 q 832 360 832 501 m 707 360 q 658 532 707 464 q 521 621 609 601 q 426 569 487 569 q 330 621 364 569 q 193 532 242 601 q 144 360 144 464 q 193 187 144 255 q 330 100 242 119 q 426 152 364 152 q 521 100 487 152 q 658 187 609 119 q 707 360 707 255 "},"ˆ":{"x_min":16.5,"x_max":445.5,"ha":463,"o":"m 232 925 l 155 810 l 16 810 l 162 1000 l 292 1000 l 445 810 l 306 810 l 232 925 "},"ᵻ":{"x_min":17,"x_max":289,"ha":309,"o":"m 289 329 l 214 329 l 214 0 l 92 0 l 92 329 l 17 329 l 17 419 l 92 419 l 92 721 l 214 721 l 214 419 l 289 419 l 289 329 "},"Ԍ":{"x_min":74,"x_max":993,"ha":1080,"o":"m 993 507 q 557 -17 993 -17 q 198 124 326 -17 q 74 492 74 260 q 207 870 74 729 q 571 1012 341 1012 q 978 716 902 1012 l 859 684 q 572 899 796 899 q 297 785 393 899 q 210 500 210 679 q 293 212 210 315 q 557 102 383 102 q 801 208 718 102 q 864 390 864 288 l 572 390 l 572 507 l 993 507 "},"’":{"x_min":73,"x_max":215,"ha":309,"o":"m 84 862 l 84 1004 l 215 1004 l 215 892 q 193 760 215 800 q 103 678 164 705 l 73 726 q 127 773 109 741 q 147 862 145 805 l 84 862 "},"-":{"x_min":43,"x_max":420,"ha":463,"o":"m 43 298 l 43 421 l 420 421 l 420 298 l 43 298 "},"Q":{"x_min":60,"x_max":1029,"ha":1080,"o":"m 859 106 q 1029 14 951 43 l 990 -77 q 776 44 883 -38 q 532 -17 666 -17 q 288 48 397 -17 q 119 231 178 113 q 60 497 60 349 q 119 765 60 644 q 289 948 179 885 q 535 1012 399 1012 q 783 946 673 1012 q 952 763 894 881 q 1010 498 1010 645 q 972 277 1010 375 q 859 106 935 179 m 570 275 q 758 180 684 243 q 874 498 874 285 q 833 709 874 618 q 713 849 792 799 q 536 899 634 899 q 292 798 389 899 q 196 497 196 697 q 291 199 196 303 q 536 96 387 96 q 668 122 606 96 q 539 179 607 162 l 570 275 "},"ј":{"x_min":-63.75,"x_max":212.875,"ha":308,"o":"m 90 853 l 90 995 l 212 995 l 212 853 l 90 853 m -63 -279 l -41 -175 q 16 -185 -4 -185 q 72 -160 54 -185 q 90 -36 90 -135 l 90 721 l 212 721 l 212 -38 q 178 -224 212 -171 q 31 -292 134 -292 q -63 -279 -17 -292 "},"ᴱ":{"x_min":34,"x_max":536,"ha":570,"o":"m 536 321 l 34 321 l 34 995 l 520 995 l 520 916 l 123 916 l 123 709 l 495 709 l 495 630 l 123 630 l 123 400 l 536 400 l 536 321 "},"Ҋ":{"x_min":109,"x_max":1014,"ha":998,"o":"m 697 1227 q 496 1051 675 1051 q 296 1227 317 1051 l 379 1227 q 492 1135 398 1135 q 614 1227 595 1135 l 697 1227 m 1014 117 l 886 -276 l 769 -276 l 863 0 l 769 0 l 770 787 l 240 0 l 109 0 l 109 995 l 228 995 l 228 207 l 757 995 l 889 995 l 889 117 l 1014 117 "},"ҏ":{"x_min":92,"x_max":717.03125,"ha":773,"o":"m 717 24 l 654 -39 l 574 39 q 403 -16 495 -16 q 214 74 285 -16 l 214 -276 l 92 -276 l 92 721 l 203 721 l 203 626 q 411 737 281 737 q 681 555 605 737 q 717 365 717 468 q 677 167 717 254 q 638 101 662 132 l 717 24 m 592 366 q 551 548 592 474 q 400 641 500 641 q 246 543 300 641 q 202 356 202 463 q 242 174 202 246 q 394 84 293 84 q 496 117 451 84 l 427 186 l 490 249 l 555 185 q 592 366 592 252 "},"ӗ":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 m 583 986 q 382 810 561 810 q 182 986 203 810 l 265 986 q 378 894 284 894 q 500 986 481 894 l 583 986 "},"ԏ":{"x_min":26,"x_max":833,"ha":924,"o":"m 833 298 q 761 70 833 152 q 541 -16 685 -16 q 389 20 457 -16 q 282 133 314 60 q 257 292 257 192 l 257 621 l 26 621 l 26 721 l 610 721 l 610 621 l 379 621 l 379 294 q 416 149 379 205 q 543 84 459 84 q 635 112 593 84 q 695 187 677 140 q 711 303 711 227 l 711 421 l 833 421 l 833 298 "},"˯":{"x_min":90,"x_max":371,"ha":463,"o":"m 371 -49 l 248 -240 l 212 -240 l 90 -49 l 167 -49 l 230 -164 l 294 -49 l 371 -49 "},"ҩ":{"x_min":24,"x_max":707,"ha":724,"o":"m 707 24 q 588 -16 657 -16 q 462 9 519 -16 q 336 -16 406 -16 q 99 92 182 -16 q 24 357 24 191 q 87 626 24 522 q 277 737 156 737 q 392 700 346 737 l 339 620 q 282 637 313 637 q 187 566 224 637 q 149 357 149 490 q 200 151 149 222 q 336 84 249 84 q 361 85 349 84 q 276 357 276 188 q 324 545 276 463 q 462 637 379 637 q 600 545 545 637 q 649 357 649 463 q 564 85 649 188 q 588 84 575 84 q 661 110 620 84 l 707 24 m 524 357 q 509 470 524 416 q 461 537 491 537 q 414 470 432 537 q 401 357 401 417 q 462 136 401 205 q 524 357 524 205 "},"#":{"x_min":14,"x_max":756,"ha":773,"o":"m 70 -17 l 129 272 l 14 272 l 14 373 l 149 373 l 199 619 l 14 619 l 14 720 l 220 720 l 280 1011 l 381 1011 l 322 720 l 535 720 l 595 1011 l 697 1011 l 637 720 l 756 720 l 756 619 l 616 619 l 566 373 l 756 373 l 756 272 l 546 272 l 487 -17 l 385 -17 l 444 272 l 230 272 l 171 -17 l 70 -17 m 251 373 l 464 373 l 515 619 l 301 619 l 251 373 "},"ᵛ":{"x_min":0,"x_max":446,"ha":446,"o":"m 446 808 l 261 321 l 185 321 l 0 808 l 86 808 l 191 516 q 222 418 208 468 q 253 510 232 450 l 361 808 l 446 808 "},"Џ":{"x_min":108,"x_max":891,"ha":998,"o":"m 558 0 l 558 -276 l 441 -276 l 441 0 l 108 0 l 108 995 l 240 995 l 240 117 l 759 117 l 759 995 l 891 995 l 891 0 l 558 0 "},"Ѥ":{"x_min":130,"x_max":1269,"ha":1319,"o":"m 1269 313 q 854 -17 1182 -17 q 505 135 620 -17 q 398 455 406 266 l 262 455 l 262 0 l 130 0 l 130 995 l 262 995 l 262 572 l 401 572 q 448 756 411 674 q 613 946 503 878 q 856 1012 720 1012 q 1110 939 1006 1012 q 1256 722 1218 863 l 1127 688 q 856 897 1070 897 q 626 806 710 897 q 539 572 547 720 l 903 572 l 903 455 l 534 455 q 615 204 540 302 q 845 94 699 94 q 1142 346 1081 94 l 1269 313 "},"Å":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 325 1071 q 361 1157 325 1121 q 447 1193 397 1193 q 533 1156 497 1193 q 570 1068 570 1120 q 533 979 570 1015 q 448 943 497 943 q 361 979 397 943 q 325 1071 325 1016 m 377 1070 q 398 1016 377 1038 q 449 995 419 995 q 499 1016 478 995 q 521 1069 521 1038 q 499 1121 521 1099 q 449 1143 478 1143 q 398 1121 419 1143 q 377 1070 377 1100 "},"Ѵ":{"x_min":6,"x_max":1105,"ha":1116,"o":"m 1105 926 l 1044 837 q 931 886 972 886 q 843 810 872 886 l 527 0 l 391 0 l 6 995 l 148 995 l 407 271 q 459 109 438 183 q 512 271 481 186 l 735 873 q 901 1012 787 1012 q 1105 926 983 1012 "},"Ә":{"x_min":67,"x_max":983.1875,"ha":1045,"o":"m 983 508 q 875 135 987 282 q 525 -17 760 -17 q 174 135 290 -17 q 67 509 67 278 l 67 573 l 842 573 q 754 807 833 722 q 523 897 670 897 q 252 689 308 897 l 123 722 q 269 939 160 863 q 522 1012 373 1012 q 765 945 658 1012 q 932 756 876 878 q 983 508 980 651 m 847 456 l 203 456 q 296 191 210 288 q 525 94 381 94 q 753 191 668 94 q 847 456 839 288 "},"ˈ":{"x_min":196,"x_max":266,"ha":463,"o":"m 266 769 l 196 769 l 196 994 l 266 994 l 266 769 "},"¸":{"x_min":73,"x_max":366,"ha":463,"o":"m 146 -104 l 182 16 l 273 16 l 250 -56 q 337 -92 308 -63 q 366 -156 366 -120 q 317 -246 366 -207 q 170 -285 268 -285 q 73 -285 114 -285 l 80 -198 q 143 -200 123 -200 q 233 -182 207 -200 q 253 -149 253 -168 q 245 -127 253 -137 q 216 -111 237 -118 q 146 -104 195 -104 "},"ᴿ":{"x_min":34,"x_max":627,"ha":627,"o":"m 627 321 l 515 321 l 425 461 q 316 599 354 574 q 275 617 294 613 q 226 621 260 621 l 123 621 l 123 321 l 34 321 l 34 995 l 332 995 q 451 982 409 995 q 543 912 512 964 q 572 811 572 866 q 382 628 572 653 q 435 594 418 610 q 509 504 475 557 l 627 321 m 480 811 q 336 920 480 920 l 123 920 l 123 698 l 314 698 q 462 751 427 698 q 480 811 480 778 "},"=":{"x_min":77,"x_max":734,"ha":811,"o":"m 734 585 l 77 585 l 77 699 l 734 699 l 734 585 m 734 283 l 77 283 l 77 397 l 734 397 l 734 283 "},"Ћ":{"x_min":33,"x_max":1123,"ha":1186,"o":"m 33 995 l 828 995 l 828 878 l 497 878 l 497 571 q 793 635 682 635 q 981 591 901 635 q 1092 471 1061 547 q 1123 261 1123 395 l 1123 0 l 991 0 l 991 257 q 972 408 991 354 q 905 493 954 462 q 785 524 857 524 q 497 461 676 524 l 497 0 l 365 0 l 365 878 l 33 878 l 33 995 "},"⁞":{"x_min":126,"x_max":265,"ha":386,"o":"m 265 855 l 126 855 l 126 994 l 265 994 l 265 855 m 265 570 l 126 570 l 126 709 l 265 709 l 265 570 m 265 285 l 126 285 l 126 424 l 265 424 l 265 285 m 265 0 l 126 0 l 126 139 l 265 139 l 265 0 "},"ú":{"x_min":89,"x_max":673,"ha":773,"o":"m 564 0 l 564 105 q 335 -16 479 -16 q 216 8 271 -16 q 134 69 160 32 q 96 160 107 106 q 89 274 89 196 l 89 721 l 211 721 l 211 321 q 218 192 211 225 q 267 116 230 143 q 359 89 304 89 q 462 117 414 89 q 530 193 510 145 q 551 334 551 242 l 551 721 l 673 721 l 673 0 l 564 0 m 299 810 l 388 1000 l 549 1000 l 400 810 l 299 810 "},"˚":{"x_min":110,"x_max":355,"ha":463,"o":"m 110 907 q 146 993 110 957 q 232 1029 182 1029 q 318 992 282 1029 q 355 904 355 956 q 318 815 355 851 q 233 779 282 779 q 146 815 182 779 q 110 907 110 852 m 162 906 q 183 852 162 874 q 234 831 204 831 q 284 852 263 831 q 306 905 306 874 q 284 957 306 935 q 234 979 263 979 q 183 957 204 979 q 162 906 162 936 "},"д":{"x_min":0,"x_max":767,"ha":810,"o":"m 187 721 l 689 721 l 689 100 l 767 100 l 767 -204 l 667 -204 l 667 0 l 100 0 l 100 -204 l 0 -204 l 0 100 l 64 100 q 187 721 192 275 m 289 621 q 181 100 275 268 l 567 100 l 567 621 l 289 621 "},"ᴼ":{"x_min":34,"x_max":677,"ha":711,"o":"m 677 657 q 518 352 677 439 q 355 311 443 311 q 72 481 155 311 q 34 649 34 561 q 116 902 34 805 q 356 1006 202 1006 q 637 837 554 1006 q 677 657 677 757 m 586 657 q 476 895 586 826 q 356 929 423 929 q 177 844 237 929 q 125 647 125 771 q 183 464 125 537 q 354 387 246 387 q 529 468 467 387 q 586 657 586 541 "},"ӥ":{"x_min":92,"x_max":684,"ha":776,"o":"m 92 721 l 214 721 l 214 171 l 552 721 l 684 721 l 684 0 l 562 0 l 562 546 l 223 0 l 92 0 l 92 721 m 198 810 l 198 949 l 326 949 l 326 810 l 198 810 m 451 810 l 451 949 l 579 949 l 579 810 l 451 810 "},"¯":{"x_min":-21,"x_max":788,"ha":767,"o":"m -21 1062 l -21 1150 l 788 1150 l 788 1062 l -21 1062 "},"u":{"x_min":89,"x_max":673,"ha":773,"o":"m 564 0 l 564 105 q 335 -16 479 -16 q 216 8 271 -16 q 134 69 160 32 q 96 160 107 106 q 89 274 89 196 l 89 721 l 211 721 l 211 321 q 218 192 211 225 q 267 116 230 143 q 359 89 304 89 q 462 117 414 89 q 530 193 510 145 q 551 334 551 242 l 551 721 l 673 721 l 673 0 l 564 0 "},"ˏ":{"x_min":151,"x_max":401,"ha":463,"o":"m 401 -86 l 252 -276 l 151 -276 l 240 -86 l 401 -86 "},"З":{"x_min":53,"x_max":783,"ha":839,"o":"m 53 281 l 178 314 q 254 168 192 241 q 419 96 316 96 q 584 149 524 96 q 645 279 645 203 q 581 409 645 361 q 407 458 517 458 l 344 458 l 344 573 q 482 583 434 573 q 568 637 531 594 q 605 735 605 680 q 554 848 605 800 q 417 897 503 897 q 289 859 342 897 q 215 759 235 821 q 195 667 195 697 l 69 695 q 419 1012 115 1012 q 650 930 565 1012 q 736 741 736 849 q 604 525 736 601 q 731 439 680 504 q 783 284 783 374 q 683 69 783 156 q 420 -17 584 -17 q 53 281 137 -17 "},"ʿ":{"x_min":170,"x_max":293,"ha":463,"o":"m 293 781 q 205 817 240 781 q 170 907 170 854 q 206 993 170 957 q 293 1029 242 1029 l 293 979 q 242 957 263 979 q 222 907 222 936 q 242 855 222 877 q 293 833 262 833 l 293 781 "},"ᴐ":{"x_min":12,"x_max":641,"ha":695,"o":"m 641 357 q 561 92 641 192 q 312 -16 474 -16 q 111 55 191 -16 q 12 248 31 127 l 132 264 q 314 84 157 84 q 516 361 516 84 q 307 637 516 637 q 143 491 177 637 l 24 509 q 312 737 68 737 q 484 693 409 737 q 602 561 564 647 q 641 357 641 474 "},"é":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 m 286 810 l 375 1000 l 536 1000 l 387 810 l 286 810 "},"B":{"x_min":102,"x_max":852,"ha":926,"o":"m 102 0 l 102 995 l 474 995 q 657 964 588 995 q 765 871 726 934 q 804 740 804 808 q 769 620 804 676 q 664 529 734 563 q 803 438 754 502 q 852 288 852 375 q 822 158 852 218 q 749 65 793 98 q 640 16 706 33 q 480 0 575 0 l 102 0 m 234 576 l 448 576 q 573 587 535 576 q 648 637 623 602 q 674 724 674 672 q 650 812 674 774 q 582 864 626 850 q 432 878 538 878 l 234 878 l 234 576 m 234 117 l 481 117 q 570 121 544 117 q 646 148 615 129 q 696 204 676 167 q 716 288 716 240 q 687 384 716 343 q 608 442 658 425 q 463 459 557 459 l 234 459 l 234 117 "},"…":{"x_min":162,"x_max":1227,"ha":1389,"o":"m 162 0 l 162 139 l 301 139 l 301 0 l 162 0 m 625 0 l 625 139 l 764 139 l 764 0 l 625 0 m 1088 0 l 1088 139 l 1227 139 l 1227 0 l 1088 0 "},"H":{"x_min":112,"x_max":891,"ha":1003,"o":"m 112 0 l 112 995 l 244 995 l 244 586 l 759 586 l 759 995 l 891 995 l 891 0 l 759 0 l 759 469 l 244 469 l 244 0 l 112 0 "},"î":{"x_min":-12.5,"x_max":416.5,"ha":386,"o":"m 134 0 l 134 721 l 256 721 l 256 0 l 134 0 m 203 925 l 126 810 l -12 810 l 133 1000 l 263 1000 l 416 810 l 277 810 l 203 925 "},"ˤ":{"x_min":34,"x_max":450,"ha":484,"o":"m 450 851 l 370 839 q 259 936 347 936 q 119 750 119 936 q 254 563 119 563 q 299 570 278 563 l 299 321 l 216 321 l 216 499 q 77 584 126 505 q 34 748 34 653 q 139 975 34 917 q 255 1005 192 1005 q 450 851 420 1005 "},"−":{"x_min":77,"x_max":734,"ha":811,"o":"m 734 433 l 77 433 l 77 547 l 734 547 l 734 433 "},"҉":{"x_min":-643,"x_max":643,"ha":0,"o":"m 542 818 l 499 775 q 466 786 483 786 q 407 755 438 786 l 444 718 l 373 648 l 300 721 l 366 788 q 449 832 400 823 q 542 818 500 843 m 643 347 l 583 347 q 504 398 576 398 l 504 346 l 404 346 l 404 450 l 498 450 q 588 422 548 450 q 643 347 631 394 m 41 806 l -63 806 l -63 900 q -34 991 -63 949 q 40 1045 -6 1033 l 40 985 q -11 906 -11 978 l 41 906 l 41 806 m 487 -11 q 470 -75 487 -45 l 427 -32 q 438 0 438 -16 q 407 59 438 28 l 370 23 l 300 93 l 373 167 l 439 100 q 487 -11 487 52 m -300 663 l -373 590 l -440 656 q -484 739 -475 692 q -470 832 -495 790 l -427 789 q -438 756 -438 773 q -407 697 -438 728 l -370 734 l -300 663 m -404 307 l -498 307 q -588 334 -548 307 q -643 410 -631 362 l -583 410 q -504 359 -576 359 l -504 411 l -404 411 l -404 307 m 41 -135 q 13 -225 41 -185 q -62 -280 -14 -268 l -62 -220 q -11 -141 -11 -213 l -63 -141 l -63 -41 l 41 -41 l 41 -135 m -300 36 l -366 -30 q -449 -74 -402 -65 q -542 -60 -500 -85 l -499 -17 q -466 -28 -483 -28 q -407 3 -438 -28 l -444 39 l -373 110 l -300 36 "},"ӎ":{"x_min":95,"x_max":979,"ha":955,"o":"m 979 100 l 838 -204 l 737 -204 l 837 0 l 738 0 l 738 580 l 524 0 l 416 0 l 214 608 l 214 0 l 95 0 l 95 721 l 284 721 l 473 143 l 684 721 l 860 721 l 860 100 l 979 100 "},"₠":{"x_min":9,"x_max":764,"ha":773,"o":"m 764 0 l 335 0 l 335 297 q 95 393 184 297 q 9 645 9 487 q 93 908 9 809 q 337 1011 182 1011 q 526 954 452 1011 q 625 783 603 894 l 506 765 q 341 911 472 911 q 180 831 235 911 q 134 648 134 762 q 181 473 134 539 q 335 399 234 399 l 335 699 l 747 699 l 747 595 l 457 595 l 457 399 l 721 399 l 721 297 l 457 297 l 457 104 l 764 104 l 764 0 "},"ᴂ":{"x_min":45.65625,"x_max":1179,"ha":1235,"o":"m 1179 530 q 1144 418 1179 469 q 1052 343 1109 368 q 860 300 993 317 q 690 267 760 287 q 689 239 689 250 q 725 119 689 153 q 848 85 762 85 q 1008 139 967 85 q 1040 223 1027 165 l 1159 208 q 1002 10 1123 58 q 847 -16 936 -16 q 665 17 734 -16 q 597 81 625 37 q 366 -16 508 -16 q 78 177 152 -16 q 45 349 45 265 q 47 391 45 362 l 568 391 q 551 515 566 473 q 471 607 530 572 q 361 637 421 637 q 176 483 214 637 l 48 499 q 366 737 118 737 q 634 602 533 737 q 932 737 771 737 q 1103 686 1036 737 q 1179 530 1179 630 m 1049 526 q 1005 614 1049 583 q 909 641 967 641 q 781 607 838 641 q 698 506 717 569 q 688 359 688 472 q 905 408 742 382 q 1009 443 980 420 q 1049 526 1049 474 m 568 291 l 171 291 q 366 85 189 85 q 511 143 457 85 q 568 291 561 198 "},"˒":{"x_min":170,"x_max":293,"ha":463,"o":"m 293 194 q 257 104 293 141 q 170 68 222 68 l 170 120 q 220 142 200 120 q 241 194 241 164 q 220 244 241 223 q 170 266 199 266 l 170 316 q 256 280 220 316 q 293 194 293 244 "},"ҵ":{"x_min":26,"x_max":919,"ha":960,"o":"m 919 -204 l 819 -204 l 819 0 l 258 0 l 258 621 l 26 621 l 26 721 l 611 721 l 611 621 l 380 621 l 380 100 l 718 100 l 718 721 l 840 721 l 840 100 l 919 100 l 919 -204 "},"ӭ":{"x_min":29,"x_max":653.1875,"ha":709,"o":"m 274 419 l 274 319 l 528 319 q 467 142 516 201 q 330 84 418 84 q 148 263 175 84 l 29 247 q 127 56 47 128 q 335 -16 207 -16 q 573 81 489 -24 q 653 360 657 187 q 565 636 653 536 q 327 737 478 737 q 131 672 206 737 q 41 508 57 608 l 160 489 q 331 636 189 636 q 464 575 412 636 q 528 419 516 515 l 274 419 m 149 810 l 149 949 l 277 949 l 277 810 l 149 810 m 402 810 l 402 949 l 530 949 l 530 810 l 402 810 "},"ᵬ":{"x_min":-73.015625,"x_max":716,"ha":773,"o":"m 716 371 q 641 106 716 213 q 404 -16 555 -16 q 204 90 276 -16 l 204 0 l 91 0 l 91 840 q 68 845 76 845 q 17 781 15 845 l -73 781 q -37 889 -73 846 q 64 935 0 935 q 91 932 77 935 l 91 995 l 213 995 l 213 885 q 242 879 231 879 q 292 937 283 879 l 380 937 q 247 783 375 783 q 213 787 231 783 l 213 640 q 410 737 290 737 q 634 634 553 737 q 716 371 716 532 m 591 361 q 551 544 591 471 q 399 637 501 637 q 247 547 300 637 q 203 365 203 472 q 238 178 203 236 q 394 84 295 84 q 547 177 495 84 q 591 361 591 252 "},"*":{"x_min":43,"x_max":491,"ha":541,"o":"m 43 812 l 74 908 q 230 842 181 870 q 217 1011 217 964 l 315 1011 q 299 843 312 943 q 459 908 369 878 l 491 812 q 321 773 404 783 q 438 645 363 738 l 357 588 q 264 733 317 641 q 176 588 214 638 l 96 645 q 208 773 175 742 q 43 812 121 790 "},"†":{"x_min":50,"x_max":716,"ha":773,"o":"m 321 -235 l 321 587 l 50 587 l 50 696 l 321 696 l 321 971 l 443 971 l 443 696 l 716 696 l 716 587 l 443 587 l 443 -235 l 321 -235 "},"°":{"x_min":86,"x_max":462,"ha":555,"o":"m 86 824 q 141 957 86 902 q 273 1012 196 1012 q 407 957 352 1012 q 462 824 462 902 q 406 691 462 746 q 273 636 351 636 q 141 690 196 636 q 86 824 86 745 m 160 824 q 193 743 160 776 q 274 710 226 710 q 354 743 321 710 q 388 824 388 776 q 354 904 388 871 q 274 938 321 938 q 193 904 226 938 q 160 824 160 871 "},"Ԃ":{"x_min":50,"x_max":1254,"ha":1345,"o":"m 1254 298 q 1182 70 1254 151 q 962 -16 1107 -16 q 707 107 781 -16 q 421 0 606 0 q 50 289 50 0 q 189 531 50 458 q 429 570 264 570 l 667 570 l 667 995 l 799 995 l 799 293 q 827 149 799 197 q 964 84 866 84 q 1132 303 1132 84 l 1132 570 l 1254 570 l 1254 298 m 667 306 l 667 457 l 491 457 q 348 452 380 457 q 224 391 261 440 q 192 289 192 349 q 261 145 192 187 q 426 112 316 112 q 595 163 528 112 q 667 306 667 217 "},"Õ":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 m 315 1053 q 353 1165 314 1123 q 452 1207 392 1207 q 566 1171 494 1207 q 630 1151 606 1151 q 663 1162 652 1151 q 680 1210 675 1174 l 768 1210 q 729 1093 765 1132 q 635 1055 692 1055 q 523 1093 592 1055 q 456 1118 477 1118 q 419 1101 433 1118 q 405 1053 404 1085 l 315 1053 "},"№":{"x_min":109,"x_max":1432,"ha":1490,"o":"m 109 995 l 240 995 l 728 223 l 728 995 l 853 995 l 853 0 l 722 0 l 232 767 l 232 0 l 109 0 l 109 995 m 944 532 q 1011 723 944 652 q 1189 795 1078 795 q 1366 721 1300 795 q 1432 524 1432 648 q 1363 325 1432 398 q 1184 252 1295 252 q 1016 318 1088 252 q 944 532 944 384 m 1063 528 q 1099 391 1063 437 q 1187 345 1135 345 q 1274 389 1236 345 q 1313 524 1313 433 q 1273 661 1313 619 q 1186 704 1234 704 q 1099 659 1136 704 q 1063 528 1063 615 m 958 180 l 1418 180 l 1418 80 l 958 80 l 958 180 "},"Ҙ":{"x_min":53,"x_max":783,"ha":839,"o":"m 783 284 q 684 69 783 156 q 496 -11 609 4 q 517 -139 517 -90 q 476 -247 517 -206 q 368 -289 436 -289 q 220 -247 299 -289 l 220 -166 q 333 -198 281 -198 q 404 -168 377 -198 q 431 -94 431 -139 q 417 -17 431 -58 q 53 281 137 -15 l 178 314 q 261 161 195 223 q 419 96 330 96 q 573 140 510 96 q 645 279 645 191 q 568 418 645 371 q 407 458 505 458 l 344 458 l 344 573 q 465 579 430 573 q 568 637 530 592 q 605 735 605 680 q 547 855 605 810 q 417 897 494 897 q 292 862 346 897 q 215 759 237 825 q 195 667 195 698 l 69 695 q 419 1012 115 1012 q 637 942 548 1012 q 736 741 736 866 q 604 525 736 602 q 734 436 686 503 q 783 284 783 370 "},"5":{"x_min":58,"x_max":717,"ha":773,"o":"m 58 260 l 186 271 q 251 130 200 177 q 377 83 303 83 q 526 149 465 83 q 587 326 587 216 q 528 491 587 431 q 375 552 470 552 q 269 525 316 552 q 195 456 222 498 l 80 471 l 176 982 l 670 982 l 670 865 l 273 865 l 220 597 q 407 660 309 660 q 627 569 538 660 q 717 337 717 479 q 638 103 717 202 q 377 -17 542 -17 q 155 58 241 -17 q 58 260 70 134 "},"o":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 "},"Ӊ":{"x_min":111,"x_max":1016,"ha":1003,"o":"m 1016 117 l 888 -276 l 771 -276 l 864 0 l 759 0 l 759 469 l 243 469 l 243 0 l 111 0 l 111 995 l 243 995 l 243 586 l 759 586 l 759 995 l 891 995 l 891 117 l 1016 117 "},"₩":{"x_min":17,"x_max":1295,"ha":1311,"o":"m 1295 303 l 1105 303 l 1022 0 l 895 0 l 812 303 l 498 303 l 414 0 l 280 0 l 200 303 l 17 303 l 17 417 l 170 417 l 127 578 l 17 578 l 17 692 l 97 692 l 17 995 l 153 995 l 221 692 l 496 692 l 579 995 l 737 995 l 815 692 l 1090 692 l 1163 995 l 1295 995 l 1211 692 l 1295 692 l 1295 578 l 1180 578 l 1136 417 l 1295 417 l 1295 303 m 1062 578 l 844 578 l 886 417 l 1024 417 l 1062 578 m 705 692 l 654 874 l 604 692 l 705 692 m 996 303 l 915 303 l 957 139 l 996 303 m 780 417 l 736 578 l 573 578 l 529 417 l 780 417 m 465 578 l 246 578 l 282 417 l 421 417 l 465 578 m 389 303 l 308 303 l 345 139 l 389 303 "},"Ѕ":{"x_min":62,"x_max":853,"ha":926,"o":"m 62 319 l 186 330 q 226 207 194 255 q 326 129 259 159 q 479 100 394 100 q 612 122 554 100 q 697 184 669 144 q 726 269 726 223 q 698 351 726 316 q 609 409 671 386 q 432 458 569 425 q 240 520 295 491 q 133 613 168 558 q 99 737 99 668 q 141 878 99 812 q 266 978 184 944 q 449 1012 348 1012 q 644 976 559 1012 q 774 871 728 940 q 823 715 819 802 l 697 705 q 628 847 686 799 q 454 896 569 896 q 280 852 335 896 q 226 746 226 808 q 264 658 226 692 q 463 587 302 623 q 683 523 623 550 q 811 422 770 483 q 853 280 853 360 q 807 131 853 201 q 677 22 762 61 q 485 -17 592 -17 q 259 22 350 -17 q 116 140 168 61 q 62 319 64 219 "},"ᴚ":{"x_min":21,"x_max":658,"ha":752,"o":"m 658 0 l 324 0 q 145 48 214 0 q 67 210 67 104 q 125 359 67 301 q 272 426 180 413 q 152 526 212 437 l 21 721 l 171 721 l 278 563 q 353 469 329 487 q 465 440 391 440 l 536 440 l 536 721 l 658 721 l 658 0 m 536 101 l 536 340 l 401 340 q 262 322 307 340 q 191 214 191 293 q 362 101 191 101 l 536 101 "},"₲":{"x_min":74,"x_max":993,"ha":1080,"o":"m 281 -143 l 342 31 q 227 106 277 60 q 143 211 177 151 q 91 341 109 270 q 74 492 74 412 q 107 706 74 610 q 205 870 141 802 q 361 975 269 938 q 570 1012 453 1012 q 627 1009 599 1012 q 681 1001 655 1006 l 711 1087 l 817 1087 l 776 971 q 905 875 851 938 q 978 716 959 813 l 859 684 q 813 789 843 745 q 737 859 783 833 l 613 507 l 993 507 l 993 138 q 581 -17 797 -17 q 506 -12 542 -17 q 436 0 470 -8 l 386 -143 l 281 -143 m 571 899 q 401 866 470 899 q 289 777 332 833 q 228 650 247 722 q 210 500 210 578 q 223 369 210 426 q 260 269 237 312 q 315 195 283 226 q 382 146 346 165 l 643 892 q 571 899 610 899 m 574 102 q 650 109 609 102 q 729 130 690 116 q 804 163 769 144 q 864 205 839 182 l 864 390 l 572 390 l 475 112 q 525 104 500 106 q 574 102 550 102 "},"d":{"x_min":47,"x_max":672,"ha":773,"o":"m 559 0 l 559 90 q 357 -16 490 -16 q 198 31 271 -16 q 86 164 126 78 q 47 359 47 249 q 82 555 47 467 q 190 690 118 643 q 351 737 262 737 q 467 709 416 737 q 550 638 518 682 l 550 995 l 672 995 l 672 0 l 559 0 m 172 359 q 230 152 172 221 q 368 84 288 84 q 504 149 448 84 q 561 349 561 215 q 503 566 561 497 q 363 636 446 636 q 226 569 281 636 q 172 359 172 502 "},",":{"x_min":115,"x_max":262,"ha":386,"o":"m 123 0 l 123 139 l 262 139 l 262 0 q 234 -123 262 -76 q 149 -197 207 -171 l 115 -145 q 171 -94 153 -127 q 192 0 190 -61 l 123 0 "},"ˬ":{"x_min":27.5,"x_max":456.5,"ha":463,"o":"m 456 -86 l 303 -276 l 173 -276 l 27 -86 l 166 -86 l 243 -201 l 317 -86 l 456 -86 "},"ѣ":{"x_min":14,"x_max":808,"ha":851,"o":"m 808 218 q 717 47 808 105 q 521 0 641 0 l 217 0 l 217 631 l 14 631 l 14 721 l 217 721 l 217 995 l 339 995 l 339 721 l 542 721 l 542 631 l 339 631 l 339 439 l 493 439 q 704 394 623 439 q 808 218 808 337 m 683 217 q 483 338 683 338 l 339 338 l 339 100 l 467 100 q 683 217 683 100 "},"ᴙ":{"x_min":20.5,"x_max":658,"ha":752,"o":"m 658 721 l 658 0 l 536 0 l 536 281 l 465 281 q 370 264 401 281 q 278 157 339 247 l 171 0 l 20 0 l 151 194 q 272 294 212 282 q 117 369 167 308 q 67 510 67 431 q 133 662 67 604 q 324 721 199 721 l 658 721 m 536 621 l 362 621 q 222 586 253 621 q 191 506 191 552 q 237 411 191 441 q 401 381 283 381 l 536 381 l 536 621 "},"\"":{"x_min":64,"x_max":428,"ha":493,"o":"m 97 643 l 64 832 l 64 995 l 203 995 l 203 832 l 172 643 l 97 643 m 322 643 l 289 832 l 289 995 l 428 995 l 428 832 l 395 643 l 322 643 "},"Ӳ":{"x_min":6.5,"x_max":877.5,"ha":882,"o":"m 6 995 l 139 995 l 463 385 l 747 995 l 877 995 l 504 220 q 390 30 434 75 q 261 -14 345 -14 q 137 9 210 -14 l 137 121 q 249 92 189 92 q 332 122 297 92 q 409 263 367 153 l 6 995 m 242 1055 l 324 1245 l 483 1245 l 339 1055 l 242 1055 m 477 1055 l 564 1245 l 721 1245 l 579 1055 l 477 1055 "},"ѥ":{"x_min":92,"x_max":962,"ha":991,"o":"m 962 247 q 863 56 943 128 q 654 -16 788 -11 q 417 81 498 -20 q 338 319 344 173 l 214 319 l 214 0 l 92 0 l 92 721 l 214 721 l 214 419 l 340 419 q 435 647 354 564 q 663 737 520 737 q 852 678 776 737 q 950 508 932 617 l 831 489 q 659 636 801 636 q 519 568 573 636 q 463 419 473 510 l 717 419 l 717 319 l 463 319 q 660 84 486 84 q 843 263 815 84 l 962 247 "},"ҙ":{"x_min":34,"x_max":587,"ha":637,"o":"m 587 202 q 516 44 587 104 q 387 -11 466 0 q 408 -138 408 -89 q 367 -247 408 -206 q 259 -289 327 -289 q 111 -247 190 -289 l 111 -166 q 224 -198 172 -198 q 295 -168 268 -198 q 322 -94 322 -139 q 307 -16 322 -58 q 34 202 72 -11 l 149 227 q 209 121 163 161 q 321 82 255 82 q 421 113 380 82 q 465 206 465 149 q 441 276 465 243 q 384 319 418 309 q 278 327 356 327 q 251 326 272 327 l 251 422 q 335 425 322 423 q 409 460 382 431 q 434 528 434 488 q 401 608 434 580 q 316 637 368 637 q 172 515 213 637 l 56 534 q 317 737 110 737 q 489 682 420 737 q 564 523 564 623 q 478 383 564 435 q 587 202 587 325 "},"Í":{"x_min":90,"x_max":340,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 m 90 1055 l 179 1245 l 340 1245 l 191 1055 l 90 1055 "},"Ú":{"x_min":109,"x_max":891,"ha":1003,"o":"m 759 995 l 891 995 l 891 420 q 857 181 891 270 q 734 38 823 93 q 502 -17 646 -17 q 273 31 362 -17 q 146 170 184 79 q 109 420 109 261 l 109 995 l 241 995 l 241 420 q 265 229 241 291 q 347 135 289 168 q 490 102 406 102 q 697 167 635 102 q 759 420 759 233 l 759 995 m 390 1055 l 479 1245 l 640 1245 l 491 1055 l 390 1055 "}," ":{"x_min":0,"x_max":0,"ha":278,"o":"m 0 0 l 0 0 "},"Ý":{"x_min":4.265625,"x_max":916.265625,"ha":927,"o":"m 387 0 l 387 421 l 4 995 l 162 995 l 359 693 q 460 526 413 610 q 569 702 506 604 l 763 995 l 916 995 l 519 421 l 519 0 l 387 0 m 378 1055 l 467 1245 l 628 1245 l 479 1055 l 378 1055 "},"ᴰ":{"x_min":34,"x_max":590,"ha":624,"o":"m 590 661 q 526 427 590 516 q 384 332 473 354 q 276 321 337 321 l 34 321 l 34 995 l 265 995 q 385 984 341 995 q 563 821 513 954 q 590 661 590 751 m 498 662 q 464 826 498 770 q 379 901 430 881 q 264 916 342 916 l 123 916 l 123 400 l 266 400 q 431 447 384 400 q 481 533 463 479 q 498 662 498 585 "},"ᴞ":{"x_min":46,"x_max":973,"ha":1019,"o":"m 973 306 q 886 104 973 167 q 796 67 850 78 q 682 60 759 60 l 236 60 l 236 182 l 635 182 q 764 189 732 182 q 868 330 868 213 q 840 432 868 385 q 762 501 811 481 q 622 522 713 522 l 236 522 l 236 644 l 957 644 l 957 535 l 851 535 q 973 306 973 450 m 185 417 l 46 417 l 46 545 l 185 545 l 185 417 m 185 164 l 46 164 l 46 292 l 185 292 l 185 164 "},"҂":{"x_min":14,"x_max":685,"ha":699,"o":"m 685 616 l 659 523 l 421 586 l 366 389 l 606 325 l 581 231 l 339 296 l 252 -16 l 154 -16 l 248 321 l 14 384 l 39 477 l 274 414 l 329 611 l 91 674 l 116 768 l 355 704 l 441 1012 l 540 1012 l 447 680 l 685 616 "}," ":{"x_min":0,"x_max":0,"ha":1389,"o":"m 0 0 l 0 0 "},"ѵ":{"x_min":18,"x_max":865,"ha":876,"o":"m 865 661 l 808 569 q 683 615 729 615 q 608 536 638 615 l 406 0 l 292 0 l 18 721 l 147 721 l 301 289 q 347 143 326 218 q 392 280 363 200 l 504 589 q 563 694 530 662 q 673 737 604 737 q 865 661 748 737 "},"​":{"x_min":0,"x_max":0,"ha":0},"ӟ":{"x_min":34,"x_max":587,"ha":637,"o":"m 251 326 l 251 422 q 356 428 327 422 q 409 460 384 433 q 434 528 434 487 q 401 607 434 578 q 316 637 368 637 q 172 516 213 637 l 56 535 q 317 737 110 737 q 498 673 433 737 q 564 523 564 610 q 478 383 564 435 q 559 308 532 354 q 587 201 587 263 q 516 44 587 104 q 319 -16 446 -16 q 34 203 73 -16 l 149 227 q 212 119 164 157 q 321 82 259 82 q 424 117 383 82 q 465 206 465 152 q 439 279 465 248 q 384 318 413 311 q 278 326 355 326 q 251 326 272 326 m 135 810 l 135 949 l 263 949 l 263 810 l 135 810 m 388 810 l 388 949 l 516 949 l 516 810 l 388 810 "},"ᵋ":{"x_min":34,"x_max":408,"ha":442,"o":"m 408 459 q 214 311 381 311 q 89 345 138 311 q 34 458 34 384 q 107 579 34 540 q 50 674 50 615 q 100 781 50 741 q 216 819 148 819 q 392 681 355 819 l 314 669 q 216 750 286 750 q 137 677 137 750 q 190 610 137 620 q 261 606 209 607 l 261 542 l 242 542 q 183 539 194 542 q 134 510 154 534 q 117 461 117 489 q 146 398 117 422 q 213 377 174 377 q 331 476 308 377 l 408 459 "},"ᵭ":{"x_min":47,"x_max":832,"ha":773,"o":"m 832 937 q 698 783 827 783 q 673 785 685 783 l 673 0 l 559 0 l 559 90 q 357 -16 490 -16 q 195 33 268 -16 q 87 164 125 81 q 47 359 47 250 q 191 690 47 596 q 351 737 263 737 q 551 638 479 737 l 551 836 q 519 845 530 845 q 468 781 466 845 l 378 781 q 413 889 377 846 q 515 935 450 935 q 551 929 530 935 l 551 995 l 673 995 l 673 882 q 694 879 685 879 q 744 937 735 879 l 832 937 m 561 349 q 520 540 561 465 q 363 636 469 636 q 210 543 260 636 q 172 359 172 471 q 214 175 172 251 q 368 84 267 84 q 519 170 469 84 q 561 349 561 242 "},"ã":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 156 808 q 194 920 155 878 q 293 962 233 962 q 407 926 335 962 q 471 906 447 906 q 504 917 493 906 q 521 965 516 929 l 609 965 q 570 848 606 887 q 476 810 533 810 q 364 848 433 810 q 297 873 318 873 q 260 856 274 873 q 246 808 245 840 l 156 808 "},"æ":{"x_min":47,"x_max":1180,"ha":1235,"o":"m 1177 221 q 1061 45 1143 107 q 859 -16 980 -16 q 708 16 773 -16 q 591 118 643 49 q 448 16 521 49 q 293 -16 376 -16 q 111 44 176 -16 q 47 190 47 104 q 80 299 47 248 q 174 377 114 350 q 365 420 234 403 q 537 454 467 434 q 537 481 537 470 q 502 601 537 567 q 377 636 466 636 q 278 621 318 636 q 218 581 237 607 q 186 497 198 555 l 67 512 q 121 637 85 591 q 223 710 157 684 q 379 737 290 737 q 561 703 492 737 q 628 640 601 683 q 726 712 672 687 q 859 737 781 737 q 1041 683 969 737 q 1146 542 1113 630 q 1180 370 1180 455 q 1178 329 1180 357 l 658 329 q 682 187 659 231 q 754 113 704 143 q 864 84 804 84 q 982 124 933 84 q 1049 237 1030 164 l 1177 221 m 658 429 l 1055 429 q 993 586 1045 536 q 859 636 942 636 q 718 581 773 636 q 658 429 664 527 m 539 362 q 320 312 485 338 q 217 277 246 300 q 177 194 177 245 q 212 112 177 145 q 317 80 248 80 q 453 118 395 80 q 528 215 511 157 q 539 362 539 250 "},"Ҵ":{"x_min":33,"x_max":1238,"ha":1285,"o":"m 1238 -276 l 1121 -276 l 1121 0 l 366 0 l 366 878 l 33 878 l 33 995 l 829 995 l 829 878 l 498 878 l 498 117 l 1015 117 l 1015 995 l 1147 995 l 1147 117 l 1238 117 l 1238 -276 "},"~":{"x_min":59,"x_max":753,"ha":811,"o":"m 59 378 l 59 517 q 247 598 130 598 q 333 586 288 598 q 460 538 377 574 q 530 513 507 519 q 577 507 554 507 q 669 533 622 507 q 753 600 716 559 l 753 456 q 665 397 709 415 q 565 379 620 379 q 487 388 524 379 q 370 434 450 398 q 236 470 289 470 q 154 451 192 470 q 59 378 115 432 "},"Ӥ":{"x_min":109,"x_max":889,"ha":998,"o":"m 109 995 l 228 995 l 228 207 l 756 995 l 889 995 l 889 0 l 770 0 l 770 785 l 240 0 l 109 0 l 109 995 m 310 1055 l 310 1194 l 438 1194 l 438 1055 l 310 1055 m 563 1055 l 563 1194 l 691 1194 l 691 1055 l 563 1055 "},"¡":{"x_min":157.171875,"x_max":308.171875,"ha":462,"o":"m 303 721 l 303 582 l 162 582 l 162 721 l 303 721 m 271 473 l 308 -53 l 308 -274 l 157 -274 l 157 -53 l 192 473 l 271 473 "},"‌":{"x_min":-24,"x_max":26,"ha":0,"o":"m 26 874 l 26 -187 l -24 -187 l -24 874 l 26 874 "},"ᵘ":{"x_min":68,"x_max":463,"ha":531,"o":"m 463 321 l 389 321 l 389 393 q 234 311 332 311 q 98 368 140 311 q 73 430 80 392 q 68 506 68 456 l 68 808 l 151 808 l 151 538 q 156 451 151 474 q 250 382 172 382 q 366 452 337 382 q 380 547 380 485 l 380 808 l 463 808 l 463 321 "},"ᵥ":{"x_min":0,"x_max":446,"ha":446,"o":"m 446 397 l 261 -90 l 185 -90 l 0 397 l 86 397 l 191 105 q 222 7 208 57 q 253 99 232 39 l 361 397 l 446 397 "},"К":{"x_min":109,"x_max":805,"ha":809,"o":"m 109 995 l 241 995 l 241 560 q 367 594 331 560 q 461 762 404 629 q 529 900 502 860 q 605 968 556 941 q 715 996 655 996 q 795 994 790 996 l 795 880 q 768 881 788 880 q 742 882 746 882 q 648 851 679 882 q 577 721 617 820 q 492 562 527 594 q 409 509 457 529 q 600 331 506 483 l 805 0 l 641 0 l 474 270 q 360 424 406 382 q 241 466 314 466 l 241 0 l 109 0 l 109 995 "},"ᵜ":{"x_min":0,"x_max":543,"ha":543,"o":"m 543 397 q 418 311 488 311 q 347 330 374 311 q 296 385 327 343 l 271 418 l 246 385 q 196 330 216 343 q 124 311 169 311 q 0 397 55 311 l 45 450 q 126 384 80 384 q 169 416 144 384 l 219 481 l 144 579 q 112 682 112 622 q 161 784 112 743 q 272 823 208 823 q 382 784 336 823 q 431 682 431 743 q 398 579 431 622 l 323 481 l 374 416 q 416 384 399 384 q 497 450 462 384 l 543 397 "},"ѳ":{"x_min":46,"x_max":721,"ha":773,"o":"m 721 370 q 558 28 721 118 q 383 -16 478 -16 q 128 91 218 -16 q 46 360 46 192 q 157 656 46 560 q 383 737 250 737 q 634 631 543 737 q 721 370 721 532 m 592 429 q 535 567 581 516 q 383 636 475 636 q 231 567 291 636 q 174 430 185 516 q 278 464 228 464 q 380 430 312 464 q 483 396 447 396 q 592 429 548 396 m 596 329 q 483 296 552 296 q 380 330 447 296 q 278 364 312 364 q 171 329 226 364 q 226 158 176 224 q 383 84 282 84 q 540 159 484 84 q 596 329 589 224 "},"Ԏ":{"x_min":33,"x_max":946,"ha":1037,"o":"m 946 298 q 874 70 946 151 q 655 -16 799 -16 q 418 71 488 -16 q 360 294 360 144 l 360 878 l 33 878 l 33 995 l 821 995 l 821 878 l 492 878 l 492 291 q 520 148 492 195 q 656 84 558 84 q 824 303 824 84 l 824 586 l 946 586 l 946 298 "},"P":{"x_min":107,"x_max":866,"ha":926,"o":"m 107 0 l 107 995 l 482 995 q 633 985 581 995 q 756 939 706 973 q 835 843 805 904 q 866 707 866 781 q 785 492 866 580 q 493 405 704 405 l 239 405 l 239 0 l 107 0 m 239 522 l 495 522 q 676 569 623 522 q 730 703 730 617 q 698 810 730 765 q 615 869 667 854 q 492 878 582 878 l 239 878 l 239 522 "},"%":{"x_min":81,"x_max":1149,"ha":1235,"o":"m 81 756 q 134 937 81 862 q 289 1012 188 1012 q 444 945 383 1012 q 506 748 506 878 q 443 554 506 622 q 291 486 381 486 q 140 553 200 486 q 81 756 81 620 m 293 928 q 217 888 247 928 q 187 743 187 849 q 217 609 187 648 q 293 570 248 570 q 369 609 339 570 q 400 753 400 648 q 369 888 400 849 q 293 928 338 928 m 293 -37 l 837 1012 l 936 1012 l 394 -37 l 293 -37 m 724 233 q 777 414 724 340 q 933 489 830 489 q 1087 422 1026 489 q 1149 225 1149 355 q 1087 31 1149 99 q 933 -37 1025 -37 q 783 30 843 -37 q 724 233 724 98 m 936 405 q 860 365 890 405 q 830 220 830 326 q 860 86 830 125 q 935 47 891 47 q 1012 86 982 47 q 1043 230 1043 125 q 1012 365 1043 326 q 936 405 981 405 "},"ᴉ":{"x_min":92,"x_max":214,"ha":309,"o":"m 214 0 l 92 0 l 92 721 l 214 721 l 214 0 m 214 -276 l 92 -276 l 92 -136 l 214 -136 l 214 -276 "},"_":{"x_min":-21,"x_max":788,"ha":773,"o":"m -21 -276 l -21 -188 l 788 -188 l 788 -276 l -21 -276 "},"ñ":{"x_min":92,"x_max":677,"ha":773,"o":"m 92 0 l 92 721 l 202 721 l 202 618 q 431 737 281 737 q 550 713 496 737 q 632 652 605 690 q 670 561 659 614 q 677 443 677 527 l 677 0 l 555 0 l 555 438 q 540 549 555 512 q 490 608 526 586 q 405 631 453 631 q 270 581 327 631 q 214 393 214 531 l 214 0 l 92 0 m 177 808 q 215 920 176 878 q 314 962 254 962 q 428 926 356 962 q 492 906 468 906 q 525 917 514 906 q 542 965 537 929 l 630 965 q 591 848 627 887 q 497 810 554 810 q 385 848 454 810 q 318 873 339 873 q 281 856 295 873 q 267 808 266 840 l 177 808 "},"‚":{"x_min":73,"x_max":215,"ha":309,"o":"m 84 0 l 84 142 l 215 142 l 215 30 q 193 -101 215 -61 q 103 -184 164 -156 l 73 -135 q 127 -88 109 -120 q 147 0 145 -56 l 84 0 "},"Æ":{"x_min":0.5,"x_max":1313,"ha":1389,"o":"m 0 0 l 479 995 l 1295 995 l 1295 878 l 795 878 l 795 572 l 1260 572 l 1260 455 l 795 455 l 795 117 l 1313 117 l 1313 0 l 663 0 l 663 287 l 280 287 l 142 0 l 0 0 m 337 404 l 663 404 l 663 878 l 565 878 l 337 404 "},"₣":{"x_min":0,"x_max":704,"ha":773,"o":"m 114 167 l 0 167 l 0 268 l 114 268 l 114 995 l 704 995 l 704 878 l 246 878 l 246 569 l 631 569 l 631 452 l 246 452 l 246 268 l 459 268 l 459 167 l 246 167 l 246 0 l 114 0 l 114 167 "},"ы":{"x_min":94,"x_max":899,"ha":998,"o":"m 777 721 l 899 721 l 899 0 l 777 0 l 777 721 m 94 721 l 216 721 l 216 438 l 370 438 q 603 379 521 438 q 685 217 685 320 q 616 63 685 127 q 398 0 548 0 l 94 0 l 94 721 m 216 100 l 344 100 q 510 128 460 100 q 560 217 560 157 q 523 301 560 264 q 360 338 486 338 l 216 338 l 216 100 "},"ѓ":{"x_min":92,"x_max":507,"ha":507,"o":"m 92 721 l 507 721 l 507 621 l 214 621 l 214 0 l 92 0 l 92 721 m 232 810 l 321 1000 l 482 1000 l 333 810 l 232 810 "},"ᴩ":{"x_min":90,"x_max":681,"ha":724,"o":"m 681 502 q 577 326 681 383 q 366 282 495 282 l 212 282 l 212 0 l 90 0 l 90 721 l 394 721 q 590 673 516 721 q 681 502 681 616 m 556 502 q 340 621 556 621 l 212 621 l 212 382 l 356 382 q 556 502 556 382 "},"ᵺ":{"x_min":24,"x_max":997,"ha":1091,"o":"m 997 0 l 875 0 l 875 456 q 723 632 875 632 q 622 604 668 632 q 553 527 573 576 q 533 394 533 478 l 533 0 l 411 0 l 411 336 l 255 118 q 304 104 272 104 q 358 108 325 104 l 376 0 q 283 -10 324 -10 q 180 11 217 -10 l 179 11 l 143 -39 l 37 -39 l 123 82 q 114 210 114 121 l 114 626 l 24 626 l 24 721 l 114 721 l 114 899 l 236 972 l 236 721 l 358 721 l 358 626 l 236 626 l 236 240 l 411 486 l 411 995 l 533 995 l 533 658 l 784 1011 l 890 1011 l 691 732 q 748 737 717 737 q 971 618 917 737 q 997 456 997 563 l 997 0 "},"‮":{"x_min":-158,"x_max":159,"ha":0,"o":"m -158 716 l 112 716 l 112 911 l -158 911 l -158 959 l 159 959 l 159 668 l 25 668 l 25 -187 l -24 -187 l -24 668 l -158 668 l -158 716 "},"ᴽ":{"x_min":34,"x_max":497,"ha":531,"o":"m 497 558 q 265 311 497 311 q 34 558 34 311 q 67 706 34 654 q 169 783 96 753 l 169 790 q 52 995 52 823 l 143 995 q 164 874 143 913 q 264 823 191 823 q 388 995 388 823 l 479 995 q 361 790 479 823 l 361 783 q 463 706 434 753 q 497 558 497 654 m 406 562 q 265 747 406 747 q 125 562 125 747 q 264 387 125 387 q 406 562 406 387 "},"˵":{"x_min":-56,"x_max":424,"ha":463,"o":"m 424 121 l 326 121 l 183 311 l 342 311 l 424 121 m 188 121 l 85 121 l -56 311 l 101 311 l 188 121 "},"ᵲ":{"x_min":-62.015625,"x_max":482,"ha":463,"o":"m 482 697 l 439 584 q 350 611 394 611 q 232 520 260 611 q 212 377 212 455 l 212 325 q 254 315 237 315 q 304 374 295 315 l 392 374 q 258 219 387 219 q 212 227 239 219 l 212 0 l 90 0 l 90 280 q 79 282 83 282 q 28 217 26 282 l -62 217 q -26 325 -62 282 q 75 372 11 372 q 90 371 84 372 l 90 721 l 200 721 l 200 611 q 356 737 269 737 q 482 697 418 737 "},"Њ":{"x_min":112,"x_max":1351,"ha":1403,"o":"m 734 995 l 734 570 l 954 570 q 1175 546 1096 570 q 1302 452 1254 522 q 1351 289 1351 382 q 1299 119 1351 192 q 1180 23 1248 46 q 982 0 1112 0 l 602 0 l 602 457 l 244 457 l 244 0 l 112 0 l 112 995 l 244 995 l 244 570 l 602 570 l 602 995 l 734 995 m 734 112 l 979 112 q 1105 124 1063 112 q 1178 177 1147 136 q 1210 285 1210 218 q 1182 385 1210 343 q 1097 441 1154 426 q 893 457 1041 457 l 734 457 l 734 112 "},"ᴾ":{"x_min":34,"x_max":547,"ha":581,"o":"m 547 800 q 295 595 547 595 l 123 595 l 123 321 l 34 321 l 34 995 l 287 995 q 389 988 350 995 q 526 891 488 971 q 547 800 547 850 m 456 797 q 378 909 456 888 q 295 916 355 916 l 123 916 l 123 674 l 297 674 q 456 797 456 674 "},"›":{"x_min":62,"x_max":370,"ha":463,"o":"m 242 359 l 62 668 l 163 668 l 370 363 l 163 49 l 62 49 l 242 359 "},"ћ":{"x_min":0,"x_max":679,"ha":773,"o":"m 92 907 l 92 995 l 214 995 l 214 907 l 446 907 l 446 826 l 214 826 l 214 637 q 309 712 255 687 q 431 737 364 737 q 614 674 550 737 q 679 456 679 612 l 679 0 l 557 0 l 557 456 q 518 588 557 544 q 403 632 480 632 q 275 585 336 632 q 214 394 214 538 l 214 0 l 92 0 l 92 826 l 0 826 l 0 907 l 92 907 "},"ʶ":{"x_min":68,"x_max":499,"ha":506,"o":"m 499 808 l 410 677 q 328 609 369 617 q 428 563 391 601 q 468 463 468 524 q 415 354 468 391 q 293 321 369 321 l 68 321 l 68 808 l 150 808 l 150 618 l 198 618 q 274 637 248 618 q 325 701 290 650 l 397 808 l 499 808 m 385 465 q 241 549 385 549 l 150 549 l 150 390 l 267 390 q 385 465 385 390 "},"<":{"x_min":76,"x_max":734,"ha":811,"o":"m 76 435 l 76 549 l 734 827 l 734 705 l 212 491 l 734 276 l 734 154 l 76 435 "},"ѭ":{"x_min":92,"x_max":1122,"ha":1205,"o":"m 1122 0 l 1000 0 l 1000 47 q 956 229 1000 182 q 790 277 913 277 l 790 0 l 666 0 l 666 277 q 500 229 543 277 q 457 47 457 182 l 457 0 l 335 0 l 335 47 q 384 277 335 202 l 214 277 l 214 0 l 92 0 l 92 721 l 214 721 l 214 377 l 605 377 l 398 721 l 1060 721 l 851 377 q 1064 288 1003 366 q 1122 47 1122 213 l 1122 0 m 878 622 l 582 622 l 728 368 l 878 622 "},"ӽ":{"x_min":10,"x_max":692,"ha":695,"o":"m 692 -94 q 646 -234 692 -180 q 511 -292 597 -292 q 411 -278 460 -292 l 435 -175 q 496 -185 471 -185 q 550 -160 527 -185 q 573 -98 573 -135 q 515 33 573 -52 l 347 268 l 159 0 l 10 0 l 273 374 l 30 721 l 182 721 l 349 482 l 518 721 l 666 721 l 423 376 l 608 111 q 692 -94 692 -7 "},"¬":{"x_min":77,"x_max":734,"ha":811,"o":"m 734 288 l 619 288 l 619 585 l 77 585 l 77 699 l 734 699 l 734 288 "},"t":{"x_min":24,"x_max":376,"ha":386,"o":"m 358 108 l 376 0 q 283 -10 324 -10 q 180 11 217 -10 q 128 66 143 32 q 114 210 114 100 l 114 626 l 24 626 l 24 721 l 114 721 l 114 899 l 236 972 l 236 721 l 358 721 l 358 626 l 236 626 l 236 203 q 242 136 236 151 q 263 112 248 121 q 304 104 277 104 q 358 108 324 104 "},"Ц":{"x_min":108,"x_max":981,"ha":1028,"o":"m 108 995 l 240 995 l 240 117 l 758 117 l 758 995 l 890 995 l 890 117 l 981 117 l 981 -276 l 864 -276 l 864 0 l 108 0 l 108 995 "},"ù":{"x_min":89,"x_max":673,"ha":773,"o":"m 564 0 l 564 105 q 335 -16 479 -16 q 216 8 271 -16 q 134 69 160 32 q 96 160 107 106 q 89 274 89 196 l 89 721 l 211 721 l 211 321 q 218 192 211 225 q 267 116 230 143 q 359 89 304 89 q 462 117 414 89 q 530 193 510 145 q 551 334 551 242 l 551 721 l 673 721 l 673 0 l 564 0 m 458 810 l 360 810 l 203 1000 l 366 1000 l 458 810 "},"Ԉ":{"x_min":12,"x_max":1257,"ha":1348,"o":"m 1257 298 q 1185 69 1257 150 q 965 -17 1110 -17 q 728 70 798 -17 q 670 293 670 143 l 670 878 l 312 878 l 312 365 q 305 184 312 229 q 235 23 291 71 q 116 -17 188 -17 q 12 0 73 -17 l 34 115 q 90 102 67 102 q 171 172 153 102 q 180 294 180 204 l 180 995 l 802 995 l 802 290 q 830 147 802 194 q 967 83 869 83 q 1135 302 1135 83 l 1135 570 l 1257 570 l 1257 298 "},"ï":{"x_min":3,"x_max":384,"ha":386,"o":"m 134 0 l 134 721 l 256 721 l 256 0 l 134 0 m 3 810 l 3 949 l 131 949 l 131 810 l 3 810 m 256 810 l 256 949 l 384 949 l 384 810 l 256 810 "},"Ф":{"x_min":56,"x_max":1000,"ha":1056,"o":"m 467 874 l 467 1002 l 590 1002 l 590 874 q 890 759 780 863 q 1000 501 1000 655 q 893 244 1000 350 q 590 128 786 138 l 590 0 l 467 0 l 467 128 q 173 235 290 134 q 56 501 56 336 q 172 766 56 667 q 467 874 289 866 m 590 762 l 590 241 q 790 314 717 247 q 864 501 864 382 q 792 686 864 618 q 590 762 720 754 m 467 761 q 268 688 344 755 q 192 501 192 621 q 267 315 192 382 q 467 242 342 247 l 467 761 "},"Ò":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 m 641 1055 l 543 1055 l 386 1245 l 549 1245 l 641 1055 "},"ᵑ":{"x_min":68,"x_max":463,"ha":531,"o":"m 463 294 q 443 173 463 211 q 341 123 415 123 q 276 131 307 123 l 291 202 q 330 196 314 196 q 376 231 366 196 q 381 296 381 246 l 381 617 q 278 748 381 748 q 150 587 150 748 l 150 321 l 68 321 l 68 808 l 142 808 l 142 739 q 297 819 195 819 q 388 797 347 819 q 450 730 435 774 q 463 620 463 692 l 463 294 "},"I":{"x_min":130,"x_max":262,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 "},"˝":{"x_min":39,"x_max":518,"ha":463,"o":"m 39 810 l 121 1000 l 280 1000 l 136 810 l 39 810 m 274 810 l 361 1000 l 518 1000 l 376 810 l 274 810 "},"˼":{"x_min":115,"x_max":352,"ha":463,"o":"m 352 -276 l 115 -276 l 115 -206 l 282 -206 l 282 -51 l 352 -51 l 352 -276 "},"Ҩ":{"x_min":42,"x_max":1023,"ha":1046,"o":"m 1023 25 q 859 -17 950 -17 q 662 22 748 -17 q 464 -17 576 -17 q 141 132 251 -17 q 42 504 42 268 q 139 870 42 728 q 393 1012 237 1012 q 544 974 484 1012 l 489 875 q 393 899 450 899 q 235 778 296 899 q 178 505 178 665 q 241 222 178 329 q 465 96 315 96 q 549 105 509 96 q 428 496 428 237 q 672 899 428 899 q 846 776 784 899 q 902 496 902 666 q 778 105 902 238 q 861 96 817 96 q 968 128 917 96 l 1023 25 m 779 495 q 753 691 779 611 q 672 784 724 784 q 555 502 555 784 q 664 164 555 264 q 779 495 779 266 "},"·":{"x_min":161,"x_max":300,"ha":463,"o":"m 161 432 l 161 571 l 300 571 l 300 432 l 161 432 "},"ҡ":{"x_min":27,"x_max":755,"ha":744,"o":"m 755 0 l 620 0 l 489 223 q 433 299 457 278 q 349 333 398 333 l 349 0 l 227 0 l 227 621 l 27 621 l 27 721 l 349 721 l 349 409 q 449 453 416 409 q 499 561 460 467 q 540 648 527 627 q 609 711 570 698 q 703 721 639 721 l 728 721 l 728 620 l 694 620 q 622 594 643 621 q 588 517 615 585 q 544 428 563 453 q 466 369 518 394 q 621 223 545 348 l 755 0 "},"Һ":{"x_min":109,"x_max":867,"ha":926,"o":"m 867 0 l 735 0 l 735 280 q 697 467 735 405 q 533 546 648 546 q 241 484 394 546 l 241 0 l 109 0 l 109 995 l 241 995 l 241 594 q 550 660 418 660 q 723 617 645 660 q 840 488 810 571 q 867 292 867 414 l 867 0 "},"¿":{"x_min":107,"x_max":748,"ha":848,"o":"m 497 721 l 497 582 l 372 582 l 372 721 l 497 721 m 489 476 q 489 441 489 452 q 469 313 489 366 q 421 234 454 274 q 332 149 396 205 q 250 60 269 93 q 232 -12 232 26 q 287 -138 232 -84 q 424 -192 343 -192 q 554 -143 501 -192 q 623 9 606 -94 l 748 -5 q 647 -217 731 -142 q 426 -292 563 -292 q 193 -212 279 -292 q 107 -20 107 -133 q 137 99 107 45 q 256 232 167 154 q 335 311 316 286 q 362 369 353 337 q 372 476 370 402 l 489 476 "},"Ђ":{"x_min":34,"x_max":1145,"ha":1201,"o":"m 34 995 l 828 995 l 828 878 l 497 878 l 497 567 q 794 635 668 635 q 1048 539 952 635 q 1145 305 1145 443 q 1066 84 1145 185 q 835 -17 987 -17 q 676 6 764 -17 l 697 118 q 803 92 748 92 q 958 151 906 92 q 1011 302 1011 211 q 950 461 1011 398 q 762 525 889 525 q 497 461 652 525 l 497 0 l 365 0 l 365 878 l 34 878 l 34 995 "},"ᴀ":{"x_min":17,"x_max":672,"ha":689,"o":"m 672 0 l 544 0 l 465 219 l 224 219 l 145 0 l 17 0 l 293 721 l 395 721 l 672 0 m 429 321 l 343 570 l 258 321 l 429 321 "},"₱":{"x_min":11,"x_max":912,"ha":926,"o":"m 912 580 l 841 580 q 784 492 821 533 q 493 405 703 405 l 239 405 l 239 0 l 107 0 l 107 580 l 11 580 l 11 670 l 107 670 l 107 731 l 11 731 l 11 821 l 107 821 l 107 995 l 481 995 q 632 985 577 995 q 844 821 791 957 l 912 821 l 912 731 l 864 731 q 865 707 865 720 q 862 670 865 690 l 912 670 l 912 580 m 689 821 q 614 869 659 856 q 492 878 582 878 l 239 878 l 239 821 l 689 821 m 729 703 q 727 731 729 720 l 239 731 l 239 670 l 726 670 q 729 703 729 684 m 686 580 l 239 580 l 239 522 l 495 522 q 686 580 632 522 "},";":{"x_min":115,"x_max":262,"ha":386,"o":"m 123 582 l 123 721 l 262 721 l 262 582 l 123 582 m 123 0 l 123 139 l 262 139 l 262 0 q 234 -123 262 -76 q 149 -197 207 -171 l 115 -144 q 171 -94 153 -127 q 192 0 190 -61 l 123 0 "},"˲":{"x_min":136,"x_max":327,"ha":463,"o":"m 327 -162 l 136 -285 l 136 -208 l 251 -144 l 136 -81 l 136 -4 l 327 -126 l 327 -162 "},"6":{"x_min":52,"x_max":710,"ha":773,"o":"m 692 751 l 571 741 q 524 846 554 813 q 401 899 474 899 q 298 866 343 899 q 207 743 241 824 q 173 512 174 662 q 281 612 217 579 q 415 645 345 645 q 623 555 537 645 q 710 322 710 465 q 669 148 710 229 q 558 25 629 68 q 398 -17 487 -17 q 148 95 245 -17 q 52 465 52 207 q 158 884 52 754 q 409 999 251 999 q 601 933 526 999 q 692 751 677 867 m 192 321 q 218 201 192 258 q 293 113 245 143 q 395 83 342 83 q 529 145 473 83 q 585 315 585 207 q 530 477 585 418 q 390 537 475 537 q 249 477 307 537 q 192 321 192 418 "},"˧":{"x_min":102,"x_max":430,"ha":532,"o":"m 430 0 l 324 0 l 324 444 l 102 444 l 102 550 l 324 550 l 324 994 l 430 994 l 430 0 "},"n":{"x_min":92,"x_max":677,"ha":773,"o":"m 92 0 l 92 721 l 202 721 l 202 618 q 431 737 281 737 q 550 713 496 737 q 632 652 605 690 q 670 561 659 614 q 677 443 677 527 l 677 0 l 555 0 l 555 438 q 540 549 555 512 q 490 608 526 586 q 405 631 453 631 q 270 581 327 631 q 214 393 214 531 l 214 0 l 92 0 "},"ᴳ":{"x_min":34,"x_max":655,"ha":689,"o":"m 655 415 q 377 311 524 311 q 75 475 160 311 q 34 654 34 556 q 71 832 34 750 q 192 964 114 922 q 370 1005 268 1005 q 502 981 444 1005 q 645 805 611 938 l 565 784 q 463 912 536 880 q 370 929 423 929 q 228 891 285 929 q 150 795 176 857 q 125 659 125 732 q 245 419 125 478 q 371 390 304 390 q 568 460 489 390 l 568 586 l 371 586 l 371 665 l 655 665 l 655 415 "},"ʹ":{"x_min":61,"x_max":200,"ha":265,"o":"m 92 643 l 61 828 l 61 995 l 200 995 l 200 828 l 167 643 l 92 643 "},"ᴏ":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 "},"℗":{"x_min":2,"x_max":1025,"ha":1023,"o":"m 513 1012 q 765 945 642 1012 q 956 756 888 879 q 1025 499 1025 633 q 957 245 1025 367 q 768 55 890 123 q 513 -12 646 -12 q 259 55 380 -12 q 69 245 137 123 q 2 499 2 367 q 70 756 2 633 q 262 945 139 879 q 513 1012 385 1012 m 513 927 q 304 871 406 927 q 144 713 202 816 q 87 499 87 610 q 143 287 87 389 q 301 129 200 186 q 513 73 403 73 q 725 129 624 73 q 883 287 827 186 q 940 499 940 389 q 882 713 940 610 q 723 871 825 816 q 513 927 620 927 m 330 217 l 330 768 l 518 768 q 659 752 615 768 q 728 699 702 737 q 754 618 754 661 q 716 516 754 558 q 629 463 679 475 q 518 451 578 451 l 419 451 l 419 217 l 330 217 m 419 527 l 526 527 q 631 550 603 527 q 660 611 660 573 q 646 654 660 635 q 608 683 632 674 q 519 693 584 693 l 419 693 l 419 527 "},"∂":{"x_min":38,"x_max":660,"ha":686,"o":"m 289 772 l 197 813 q 311 965 244 919 q 441 1012 377 1012 q 534 985 493 1012 q 597 923 576 958 q 644 796 629 870 q 660 628 660 723 q 601 280 660 433 q 442 55 542 128 q 246 -17 343 -17 q 95 44 153 -17 q 38 218 38 106 q 141 481 38 371 q 582 627 275 621 q 565 800 579 741 q 519 892 552 860 q 442 925 487 925 q 360 891 400 925 q 289 772 320 857 m 579 540 q 336 494 413 530 q 209 374 259 457 q 160 205 160 291 q 194 112 160 149 q 275 76 229 76 q 383 113 326 76 q 512 272 463 164 q 579 540 562 380 "},"‡":{"x_min":50,"x_max":718,"ha":773,"o":"m 323 -235 l 323 16 l 50 16 l 50 125 l 323 125 l 323 618 l 50 618 l 50 727 l 323 727 l 323 981 l 445 981 l 445 727 l 718 727 l 718 618 l 445 618 l 445 125 l 718 125 l 718 16 l 445 16 l 445 -235 l 323 -235 "},"ԃ":{"x_min":47,"x_max":1126,"ha":1217,"o":"m 1126 298 q 1054 70 1126 152 q 834 -16 978 -16 q 589 106 656 -16 q 356 -16 517 -16 q 195 33 267 -16 q 86 164 125 81 q 47 359 47 250 q 190 690 47 596 q 350 737 262 737 q 549 638 477 737 l 549 995 l 671 995 l 671 293 q 708 149 671 204 q 836 84 752 84 q 928 112 885 84 q 988 187 970 140 q 1004 303 1004 227 l 1004 421 l 1126 421 l 1126 298 m 559 349 q 519 540 559 465 q 362 636 467 636 q 210 543 259 636 q 172 359 172 471 q 214 175 172 251 q 367 84 266 84 q 517 170 467 84 q 559 349 559 242 "},"ᴃ":{"x_min":17,"x_max":723,"ha":738,"o":"m 723 317 l 646 317 l 650 312 q 684 201 686 264 q 610 49 679 101 q 417 0 544 0 l 92 0 l 92 317 l 17 317 l 17 417 l 92 417 l 92 721 l 373 721 q 505 710 463 721 q 615 640 572 693 q 651 529 651 594 q 615 417 651 461 l 723 417 l 723 317 m 527 518 q 466 608 527 585 q 348 621 430 621 l 214 621 l 214 417 l 344 417 q 429 420 408 417 q 503 458 476 428 q 527 518 527 484 m 559 207 q 536 272 559 242 q 478 309 512 302 q 362 317 443 317 l 214 317 l 214 100 l 375 100 q 497 114 459 100 q 559 207 557 138 "},"Ӯ":{"x_min":6.5,"x_max":877.5,"ha":882,"o":"m 6 995 l 139 995 l 463 385 l 747 995 l 877 995 l 504 220 q 390 30 434 75 q 261 -14 345 -14 q 137 9 210 -14 l 137 121 q 249 92 189 92 q 332 122 297 92 q 409 263 367 153 l 6 995 m 236 1055 l 236 1155 l 659 1155 l 659 1055 l 236 1055 "},"√":{"x_min":57.140625,"x_max":762,"ha":762,"o":"m 712 1268 l 762 1268 l 550 -52 l 213 640 l 80 577 l 57 621 l 261 724 l 535 165 l 712 1268 "},"Ѫ":{"x_min":81,"x_max":1070,"ha":1151,"o":"m 1070 0 l 938 0 l 938 98 q 861 342 938 272 q 641 421 784 412 l 641 0 l 509 0 l 509 421 q 283 341 351 408 q 213 114 213 271 l 213 0 l 81 0 l 81 139 q 183 425 81 320 q 436 530 268 512 l 125 995 l 1038 995 l 714 529 q 1070 127 1070 490 l 1070 0 m 809 878 l 360 878 l 583 527 l 809 878 "},"ѹ":{"x_min":46,"x_max":1232.09375,"ha":1245,"o":"m 1232 721 l 958 -11 q 890 -175 914 -131 q 714 -292 827 -292 q 636 -277 679 -292 l 622 -162 q 692 -173 662 -173 q 797 -121 764 -173 q 846 -1 809 -102 l 573 721 l 703 721 l 905 138 l 1110 721 l 1232 721 m 559 360 q 493 91 559 193 q 302 -16 423 -16 q 111 91 180 -16 q 46 360 46 192 q 111 629 46 528 q 302 737 180 737 q 493 629 423 737 q 559 360 559 527 m 434 360 q 404 547 434 473 q 302 636 370 636 q 199 547 234 636 q 171 360 171 473 q 199 173 171 247 q 302 85 234 85 q 404 173 370 85 q 434 360 434 247 "},"ᴅ":{"x_min":92,"x_max":714,"ha":766,"o":"m 714 364 q 618 95 714 191 q 351 0 522 0 l 92 0 l 92 721 l 339 721 q 618 629 522 721 q 714 364 714 537 m 589 365 q 338 616 589 616 l 214 616 l 214 105 l 340 105 q 521 170 456 105 q 589 365 589 238 "},"ӈ":{"x_min":92,"x_max":675,"ha":767,"o":"m 675 66 q 598 -186 675 -89 q 369 -292 516 -292 q 179 -238 255 -292 q 92 -95 103 -185 l 214 -95 q 369 -192 243 -192 q 553 64 553 -192 l 553 320 l 214 320 l 214 0 l 92 0 l 92 721 l 214 721 l 214 420 l 553 420 l 553 721 l 675 721 l 675 66 "},"≈":{"x_min":35,"x_max":728,"ha":762,"o":"m 35 501 l 35 640 q 224 721 107 721 q 308 709 264 721 q 436 661 353 697 q 506 635 482 641 q 553 630 529 630 q 644 656 597 630 q 728 723 691 682 l 728 579 q 640 520 684 538 q 540 502 595 502 q 462 511 499 502 q 345 556 426 520 q 212 593 265 593 q 130 574 168 593 q 35 501 91 555 m 35 256 l 35 395 q 224 476 107 476 q 308 464 264 476 q 436 416 353 452 q 506 391 482 397 q 553 385 529 385 q 644 411 597 385 q 728 478 691 437 l 728 334 q 640 275 684 293 q 540 257 595 257 q 462 266 499 257 q 345 312 426 276 q 212 348 265 348 q 130 329 168 348 q 35 256 91 310 "},"g":{"x_min":45.171875,"x_max":680.171875,"ha":773,"o":"m 69 -59 l 188 -77 q 229 -157 195 -131 q 353 -191 275 -191 q 484 -157 438 -191 q 547 -62 531 -123 q 556 94 556 -25 q 356 0 476 0 q 126 107 208 0 q 45 364 45 214 q 82 554 45 467 q 190 689 119 641 q 357 737 261 737 q 568 634 485 737 l 568 721 l 680 721 l 680 98 q 645 -140 680 -70 q 537 -251 611 -210 q 354 -292 462 -292 q 145 -233 225 -292 q 69 -59 66 -175 m 170 373 q 226 166 170 231 q 367 101 282 101 q 509 165 452 101 q 566 369 566 230 q 507 568 566 501 q 365 636 448 636 q 227 569 284 636 q 170 373 170 503 "},"ʳ":{"x_min":68,"x_max":333,"ha":333,"o":"m 333 792 l 304 716 q 243 734 274 734 q 164 672 183 734 q 151 576 151 629 l 151 321 l 68 321 l 68 808 l 143 808 l 143 734 q 247 819 189 819 q 333 792 290 819 "},"²":{"x_min":17,"x_max":439,"ha":463,"o":"m 17 497 q 48 574 21 535 q 189 702 91 632 q 305 793 287 773 q 331 850 331 821 q 307 904 331 883 q 236 925 283 925 q 169 909 191 925 q 133 848 147 893 l 31 859 q 99 970 50 934 q 238 1006 147 1006 q 389 966 341 1006 q 437 868 437 926 q 396 760 437 811 q 257 644 366 722 q 177 579 201 603 l 439 579 l 439 497 l 17 497 "},"Ã":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 227 1053 q 265 1165 226 1123 q 364 1207 304 1207 q 478 1171 406 1207 q 542 1151 518 1151 q 575 1162 564 1151 q 592 1210 587 1174 l 680 1210 q 641 1093 677 1132 q 547 1055 604 1055 q 435 1093 504 1055 q 368 1118 389 1118 q 331 1101 345 1118 q 317 1053 316 1085 l 227 1053 "},"ⅎ":{"x_min":52,"x_max":588,"ha":680,"o":"m 588 0 l 52 0 l 52 105 l 466 105 l 466 319 l 95 319 l 95 423 l 466 423 l 466 721 l 588 721 l 588 0 "},"ˀ":{"x_min":34,"x_max":450,"ha":484,"o":"m 450 748 q 406 584 450 653 q 268 499 357 505 l 268 321 l 185 321 l 185 569 q 229 563 205 563 q 365 750 365 563 q 224 936 365 936 q 114 839 137 936 l 34 851 q 228 1005 63 1005 q 423 886 371 1005 q 450 748 450 827 "},"Ј":{"x_min":39.890625,"x_max":587,"ha":695,"o":"m 40 281 l 159 298 q 201 142 163 184 q 306 100 239 100 q 392 122 356 100 q 441 184 427 145 q 455 309 455 223 l 455 995 l 587 995 l 587 316 q 556 123 587 192 q 461 18 526 54 q 307 -17 395 -17 q 106 58 176 -17 q 40 281 37 133 "},"‾":{"x_min":-21,"x_max":485,"ha":463,"o":"m -21 832 l -21 932 l 485 932 l 485 832 l -21 832 "},"˰":{"x_min":90,"x_max":371,"ha":463,"o":"m 371 -240 l 294 -240 l 230 -124 l 167 -240 l 90 -240 l 212 -49 l 248 -49 l 371 -240 "},"ᴫ":{"x_min":16,"x_max":718,"ha":810,"o":"m 151 721 l 718 721 l 718 0 l 596 0 l 596 621 l 273 621 l 273 261 q 264 95 273 135 q 220 24 256 54 q 114 -5 183 -5 q 16 0 71 -5 l 16 102 l 69 102 q 123 109 107 102 q 145 134 140 117 q 151 245 151 151 l 151 721 "},"Ұ":{"x_min":-2,"x_max":769,"ha":773,"o":"m 769 995 l 494 512 l 726 512 l 726 412 l 446 412 l 446 0 l 324 0 l 324 412 l 42 412 l 42 512 l 273 512 l -2 995 l 133 995 l 330 646 q 382 542 363 588 q 437 652 399 580 l 623 995 l 769 995 "},"Ӵ":{"x_min":59,"x_max":817,"ha":926,"o":"m 817 0 l 685 0 l 685 400 q 375 335 507 335 q 191 383 271 335 q 85 506 112 432 q 59 702 59 581 l 59 995 l 191 995 l 191 714 q 250 500 191 551 q 392 449 309 449 q 685 510 531 449 l 685 995 l 817 995 l 817 0 m 243 1055 l 243 1194 l 371 1194 l 371 1055 l 243 1055 m 496 1055 l 496 1194 l 624 1194 l 624 1055 l 496 1055 "},"©":{"x_min":2,"x_max":1025,"ha":1023,"o":"m 513 1012 q 765 945 642 1012 q 956 756 888 879 q 1025 499 1025 633 q 957 245 1025 367 q 768 55 890 123 q 513 -12 646 -12 q 259 55 380 -12 q 69 245 137 123 q 2 499 2 367 q 70 756 2 633 q 262 945 139 879 q 513 1012 385 1012 m 513 927 q 304 871 406 927 q 144 713 202 816 q 87 499 87 610 q 143 287 87 389 q 301 129 200 186 q 513 73 403 73 q 725 129 624 73 q 883 287 827 186 q 940 499 940 389 q 882 713 940 610 q 723 871 825 816 q 513 927 620 927 m 678 416 l 761 392 q 674 256 740 307 q 514 206 608 206 q 320 283 395 206 q 246 497 246 360 q 279 653 246 587 q 376 753 313 719 q 519 787 439 787 q 669 743 610 787 q 751 626 729 700 l 670 606 q 610 683 649 656 q 516 711 570 711 q 388 655 438 711 q 338 495 338 599 q 385 338 338 391 q 509 285 433 285 q 616 320 570 285 q 678 416 663 355 "},"˭":{"x_min":20,"x_max":443,"ha":463,"o":"m 443 960 l 20 960 l 20 1060 l 443 1060 l 443 960 m 443 810 l 20 810 l 20 910 l 443 910 l 443 810 "},"ҧ":{"x_min":92,"x_max":1157,"ha":1209,"o":"m 1157 65 q 1069 -187 1157 -87 q 829 -292 978 -292 q 633 -238 713 -292 q 538 -95 549 -183 l 660 -95 q 828 -192 689 -192 q 978 -115 925 -192 q 1027 54 1027 -47 q 964 223 1027 163 q 801 280 904 280 q 660 261 744 280 l 660 0 l 538 0 l 538 621 l 214 621 l 214 0 l 92 0 l 92 721 l 660 721 l 660 364 q 818 388 737 388 q 1059 299 964 388 q 1157 65 1157 209 "},"≥":{"x_min":51,"x_max":710,"ha":762,"o":"m 710 517 l 51 236 l 51 358 l 573 573 l 51 787 l 51 909 l 710 631 l 710 517 m 708 73 l 51 73 l 51 186 l 708 186 l 708 73 "},"ᵦ":{"x_min":68,"x_max":501,"ha":535,"o":"m 501 101 q 445 -43 501 13 q 302 -100 390 -100 q 150 -26 203 -100 l 150 -276 l 68 -276 l 68 372 q 160 565 68 513 q 273 595 212 595 q 403 549 351 595 q 460 425 460 502 q 425 329 460 370 q 334 280 390 289 q 456 224 411 272 q 501 101 501 177 m 415 96 q 393 177 415 140 q 330 233 369 218 q 234 247 294 247 l 223 247 l 223 307 q 384 420 384 307 q 350 496 384 467 q 269 526 317 526 q 201 507 233 526 q 157 454 166 487 q 150 358 150 425 l 150 173 q 156 73 150 101 q 208 -9 168 24 q 291 -39 244 -39 q 383 0 349 -39 q 415 96 415 38 "},"ᴓ":{"x_min":8.703125,"x_max":826.796875,"ha":845,"o":"m 826 94 l 779 29 l 685 102 q 579 43 625 58 q 421 23 513 23 q 122 137 217 23 q 46 361 46 230 q 100 552 46 469 l 8 623 l 56 687 l 152 613 q 244 670 198 653 q 412 698 318 698 q 685 617 583 698 q 799 364 799 529 q 739 161 799 264 l 826 94 m 702 355 q 614 520 702 464 q 426 568 540 568 q 256 533 325 568 l 654 226 q 702 355 702 287 m 584 179 l 188 484 q 146 365 146 431 q 232 196 146 253 q 422 148 305 148 q 513 156 473 148 q 584 179 543 162 "},"ґ":{"x_min":92,"x_max":529,"ha":571,"o":"m 428 721 l 428 995 l 529 995 l 529 621 l 214 621 l 214 0 l 92 0 l 92 721 l 428 721 "},"ÿ":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 m 170 810 l 170 949 l 298 949 l 298 810 l 170 810 m 423 810 l 423 949 l 551 949 l 551 810 l 423 810 "},"Ӆ":{"x_min":12,"x_max":928,"ha":912,"o":"m 928 117 l 800 -276 l 683 -276 l 776 0 l 671 0 l 671 878 l 312 878 l 312 365 q 305 184 312 229 q 235 23 291 71 q 116 -17 188 -17 q 12 0 73 -17 l 34 115 q 90 102 67 102 q 171 172 153 102 q 180 294 180 204 l 180 995 l 803 995 l 803 117 l 928 117 "}," ":{"x_min":0,"x_max":0,"ha":386,"o":"m 0 0 l 0 0 "},"∫":{"x_min":0,"x_max":381,"ha":382,"o":"m 137 643 l 149 1003 q 182 1175 155 1107 q 233 1241 201 1219 q 296 1264 265 1264 q 355 1241 330 1264 q 381 1191 381 1218 q 363 1140 381 1159 q 318 1121 345 1121 q 267 1144 294 1121 q 239 1158 251 1158 q 220 1148 228 1158 q 213 1115 213 1138 q 219 1017 213 1087 q 244 565 244 738 q 233 167 244 520 q 171 -103 227 -33 q 80 -149 134 -149 q 22 -125 44 -149 q 0 -67 0 -102 q 17 -18 0 -36 q 61 0 35 0 q 108 -21 88 0 q 142 -43 128 -43 q 161 -33 153 -43 q 169 -1 169 -24 q 162 79 169 26 q 137 643 137 293 "},"\\":{"x_min":0.34375,"x_max":386,"ha":386,"o":"m 288 -17 l 0 1011 l 98 1011 l 386 -17 l 288 -17 "},"ᴡ":{"x_min":3.5,"x_max":992.5,"ha":1003,"o":"m 221 0 l 3 721 l 131 721 l 244 304 l 286 150 q 324 298 289 161 l 441 721 l 564 721 l 673 302 l 708 164 l 749 303 l 873 721 l 992 721 l 767 0 l 640 0 l 526 431 l 497 554 l 349 0 l 221 0 "},"Ì":{"x_min":44,"x_max":299,"ha":386,"o":"m 130 0 l 130 995 l 262 995 l 262 0 l 130 0 m 299 1055 l 201 1055 l 44 1245 l 207 1245 l 299 1055 "},"ъ":{"x_min":27,"x_max":818,"ha":868,"o":"m 27 721 l 349 721 l 349 439 l 504 439 q 743 374 668 439 q 818 217 818 310 q 745 60 818 121 q 532 0 673 0 l 227 0 l 227 621 l 27 621 l 27 721 m 349 99 l 477 99 q 642 127 593 99 q 691 217 691 155 q 649 305 691 274 q 493 337 607 337 l 349 337 l 349 99 "},"Ҭ":{"x_min":33,"x_max":820,"ha":848,"o":"m 820 878 l 492 878 l 492 117 l 583 117 l 583 -276 l 466 -276 l 466 0 l 360 0 l 360 878 l 33 878 l 33 995 l 820 995 l 820 878 "},"ᴨ":{"x_min":92,"x_max":660,"ha":752,"o":"m 92 721 l 660 721 l 660 0 l 538 0 l 538 621 l 214 621 l 214 0 l 92 0 l 92 721 "},"∩":{"x_min":107,"x_max":892,"ha":998,"o":"m 199 0 l 107 0 l 107 421 q 111 645 107 598 q 142 784 119 729 q 216 892 166 839 q 341 978 267 945 q 499 1012 415 1012 q 653 980 580 1012 q 780 894 726 948 q 858 779 835 840 q 889 626 881 718 q 892 421 892 591 l 892 0 l 801 0 l 801 425 q 796 622 801 579 q 772 745 790 699 q 716 831 754 791 q 620 897 678 871 q 499 923 561 923 q 375 895 436 923 q 275 824 314 868 q 221 727 236 779 q 201 603 205 674 q 199 425 199 566 l 199 0 "},"ᵩ":{"x_min":34,"x_max":577,"ha":611,"o":"m 577 174 q 481 -37 577 50 q 349 -101 430 -83 l 349 -276 l 268 -276 l 268 -101 q 98 -16 166 -101 q 34 166 34 63 q 84 329 34 259 q 230 407 140 409 l 213 336 q 119 169 119 304 q 156 42 119 94 q 268 -29 196 -13 l 268 273 q 305 391 268 365 q 373 408 331 408 q 548 297 493 408 q 577 174 577 239 m 490 182 q 471 282 490 239 q 395 339 445 339 q 353 307 363 339 q 349 249 349 291 l 349 -25 q 456 51 418 -12 q 490 182 490 107 "},"!":{"x_min":119,"x_max":270,"ha":385,"o":"m 156 247 l 119 774 l 119 995 l 270 995 l 270 774 l 235 247 l 156 247 m 124 0 l 124 139 l 265 139 l 265 0 l 124 0 "},"ç":{"x_min":54,"x_max":682,"ha":695,"o":"m 562 264 l 682 248 q 581 54 662 124 q 381 -16 500 -16 q 143 80 233 -16 q 54 357 54 177 q 92 561 54 474 q 210 693 131 649 q 382 737 289 737 q 574 677 499 737 q 670 509 648 618 l 551 491 q 490 600 534 563 q 386 637 447 637 q 236 570 294 637 q 179 361 179 504 q 234 149 179 215 q 380 84 290 84 q 500 128 452 84 q 562 264 549 172 m 276 -120 l 312 0 l 403 0 l 380 -72 q 467 -108 438 -79 q 496 -172 496 -136 q 447 -262 496 -223 q 300 -301 398 -301 q 203 -301 244 -301 l 210 -214 q 273 -216 253 -216 q 363 -198 337 -216 q 383 -165 383 -184 q 375 -143 383 -153 q 346 -127 367 -134 q 276 -120 325 -120 "},"Й":{"x_min":109,"x_max":889,"ha":998,"o":"m 109 995 l 228 995 l 228 207 l 756 995 l 889 995 l 889 0 l 770 0 l 770 785 l 240 0 l 109 0 l 109 995 m 605 1231 l 688 1231 q 625 1100 677 1146 q 487 1055 573 1055 q 348 1100 400 1055 q 287 1231 297 1145 l 370 1231 q 407 1161 379 1184 q 483 1139 436 1139 q 567 1161 538 1139 q 605 1231 595 1183 "},"ӿ":{"x_min":10,"x_max":685,"ha":695,"o":"m 685 0 l 534 0 l 347 267 l 159 0 l 10 0 l 245 334 l 30 334 l 30 424 l 239 424 l 30 721 l 182 721 l 349 481 l 518 721 l 666 721 l 448 424 l 666 424 l 666 334 l 449 334 l 685 0 "},"ᴢ":{"x_min":27.125,"x_max":665.125,"ha":695,"o":"m 27 0 l 27 98 l 485 626 q 347 622 407 622 l 54 622 l 54 721 l 643 721 l 643 640 l 252 182 l 177 99 q 331 105 259 105 l 665 105 l 665 0 l 27 0 "},"Б":{"x_min":113,"x_max":863,"ha":912,"o":"m 113 995 l 758 995 l 758 878 l 245 878 l 245 570 l 482 570 q 691 544 614 570 q 816 450 769 519 q 863 288 863 380 q 829 148 863 213 q 729 41 795 82 q 502 0 662 0 l 113 0 l 113 995 m 245 112 l 508 112 q 667 155 614 112 q 721 285 721 198 q 690 388 721 347 q 605 443 659 429 q 420 457 551 457 l 245 457 l 245 112 "},"ˎ":{"x_min":60,"x_max":315,"ha":463,"o":"m 315 -276 l 217 -276 l 60 -86 l 223 -86 l 315 -276 "},"ҳ":{"x_min":10,"x_max":684,"ha":695,"o":"m 684 -204 l 584 -204 l 584 0 l 533 0 l 346 267 l 159 0 l 10 0 l 272 373 l 30 721 l 182 721 l 296 559 q 348 481 326 517 q 401 557 371 515 l 517 721 l 665 721 l 422 375 l 614 100 l 684 100 l 684 -204 "},"ѧ":{"x_min":4,"x_max":692,"ha":695,"o":"m 692 0 l 566 0 l 474 242 l 408 242 l 408 0 l 286 0 l 286 242 l 223 242 l 132 0 l 4 0 l 291 721 l 406 721 l 692 0 m 442 329 l 347 576 l 255 329 l 442 329 "},"ˡ":{"x_min":68,"x_max":151,"ha":218,"o":"m 151 321 l 68 321 l 68 995 l 151 995 l 151 321 "},"ø":{"x_min":87,"x_max":761,"ha":848,"o":"m 621 677 l 688 765 l 754 717 l 681 623 q 739 517 724 564 q 761 359 761 449 q 646 60 761 156 q 422 -16 553 -16 q 231 38 314 -16 l 161 -53 l 96 -4 l 170 90 q 113 183 130 136 q 87 350 87 256 q 186 645 87 554 q 420 737 286 737 q 522 722 475 737 q 621 677 569 708 m 552 588 q 423 636 491 636 q 272 566 333 636 q 212 360 212 497 q 246 190 212 258 l 552 588 m 604 522 l 299 127 q 419 84 352 84 q 574 153 513 84 q 636 360 636 222 q 627 451 636 412 q 604 522 622 479 "},"â":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 384 925 l 307 810 l 168 810 l 314 1000 l 444 1000 l 597 810 l 458 810 l 384 925 "},"}":{"x_min":32,"x_max":425,"ha":464,"o":"m 425 416 l 425 305 q 340 276 373 303 q 296 202 307 249 q 285 43 286 156 q 281 -106 284 -70 q 258 -198 274 -163 q 217 -252 241 -232 q 154 -284 192 -273 q 70 -292 128 -292 l 32 -292 l 32 -186 l 53 -186 q 146 -160 123 -186 q 170 -46 170 -135 q 176 169 170 123 q 219 289 186 244 q 311 360 251 335 q 201 458 233 397 q 169 666 169 520 q 166 824 169 798 q 139 888 161 870 q 52 906 117 906 l 32 906 l 32 1012 l 69 1012 q 165 1001 136 1012 q 237 950 209 986 q 274 862 266 915 q 284 686 283 808 q 295 518 285 564 q 339 444 306 471 q 425 416 372 417 "},"‰":{"x_min":25.03125,"x_max":1364.03125,"ha":1389,"o":"m 216 -37 l 624 1011 l 713 1011 l 306 -37 l 216 -37 m 25 745 q 78 941 25 880 q 218 1003 131 1003 q 359 941 305 1003 q 414 747 414 879 q 366 547 414 614 q 220 480 319 480 q 79 543 133 480 q 25 745 25 606 m 125 739 q 151 600 125 636 q 222 565 178 565 q 284 595 263 565 q 314 741 314 636 q 284 887 314 844 q 220 919 261 919 q 155 887 178 919 q 125 739 125 845 m 518 227 q 571 423 518 362 q 711 485 624 485 q 852 423 797 485 q 907 230 907 361 q 859 30 907 97 q 713 -37 812 -37 q 572 25 626 -37 q 518 227 518 88 m 618 221 q 644 83 618 119 q 715 47 671 47 q 777 77 756 47 q 807 223 807 118 q 776 369 807 327 q 713 401 753 401 q 648 369 671 401 q 618 221 618 327 m 975 227 q 1028 423 975 362 q 1168 485 1081 485 q 1309 423 1255 485 q 1364 230 1364 361 q 1316 30 1364 97 q 1170 -37 1269 -37 q 1029 25 1083 -37 q 975 227 975 88 m 1075 221 q 1101 83 1075 119 q 1172 47 1128 47 q 1234 77 1213 47 q 1264 223 1264 118 q 1234 369 1264 327 q 1170 401 1211 401 q 1105 369 1128 401 q 1075 221 1075 327 "},"Ä":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 m 262 1055 l 262 1194 l 390 1194 l 390 1055 l 262 1055 m 515 1055 l 515 1194 l 643 1194 l 643 1055 l 515 1055 "},"—":{"x_min":0,"x_max":1389,"ha":1389,"o":"m 0 311 l 0 409 l 1389 409 l 1389 311 l 0 311 "},"N":{"x_min":106,"x_max":889,"ha":1003,"o":"m 106 0 l 106 995 l 240 995 l 763 213 l 763 995 l 889 995 l 889 0 l 754 0 l 232 781 l 232 0 l 106 0 "},"Ӗ":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 m 676 1231 q 475 1055 654 1055 q 275 1231 296 1055 l 358 1231 q 471 1139 377 1139 q 593 1231 574 1139 l 676 1231 "},"⁄":{"x_min":-308.578125,"x_max":544.5,"ha":232,"o":"m -308 -39 l 437 1011 l 544 1011 l -202 -39 l -308 -39 "},"2":{"x_min":41.890625,"x_max":700,"ha":773,"o":"m 700 117 l 700 0 l 42 0 q 56 84 40 44 q 136 216 81 151 q 296 367 192 281 q 516 578 458 500 q 574 725 574 656 q 521 848 574 798 q 385 898 469 898 q 243 844 297 898 q 190 698 190 791 l 65 711 q 162 925 77 851 q 388 999 246 999 q 615 919 531 999 q 699 722 699 840 q 674 605 699 662 q 593 483 650 547 q 404 308 536 419 q 263 183 294 216 q 211 117 231 150 l 700 117 "},"ᵴ":{"x_min":-0.015625,"x_max":693,"ha":695,"o":"m 693 434 q 654 318 690 356 q 624 295 641 305 q 641 212 641 259 q 502 13 641 74 q 350 -16 434 -16 q 43 215 84 -16 l 164 234 q 350 84 185 84 q 459 108 414 84 q 516 198 516 139 q 479 264 516 240 q 354 305 455 280 q 168 364 223 338 q 147 375 161 367 q 103 359 118 378 q 90 311 89 340 l 0 311 q 38 424 0 381 q 78 454 56 443 q 63 529 63 489 q 145 686 63 627 q 328 737 214 737 q 571 646 506 737 q 614 535 602 605 l 495 519 q 337 637 478 637 q 181 544 181 637 q 242 468 181 493 q 350 437 260 461 q 447 412 399 424 q 539 377 505 395 q 555 375 548 375 q 605 434 596 375 l 693 434 "},"М":{"x_min":102,"x_max":1052,"ha":1157,"o":"m 102 0 l 102 995 l 300 995 l 535 291 q 583 143 568 192 q 636 303 600 198 l 875 995 l 1052 995 l 1052 0 l 925 0 l 925 833 l 635 0 l 517 0 l 229 847 l 229 0 l 102 0 "},"₸":{"x_min":32,"x_max":821,"ha":848,"o":"m 360 0 l 360 691 l 32 691 l 32 808 l 821 808 l 821 691 l 492 691 l 492 0 l 360 0 m 32 878 l 32 995 l 821 995 l 821 878 l 32 878 "},"‍":{"x_min":-148,"x_max":150,"ha":0,"o":"m 26 -187 l -24 -187 l -24 755 l -115 664 l -148 697 l -32 811 l -148 925 l -115 958 l 1 842 l 117 958 l 150 925 l 34 811 l 150 697 l 117 664 l 26 755 l 26 -187 "},"˜":{"x_min":4.734375,"x_max":457.75,"ha":462,"o":"m 4 826 q 43 938 4 896 q 142 980 81 980 q 256 944 184 980 q 320 924 296 924 q 353 935 341 924 q 369 983 365 947 l 457 983 q 418 866 455 905 q 325 828 381 828 q 212 866 282 828 q 146 891 167 891 q 108 874 123 891 q 94 826 94 858 l 4 826 "},"Ó":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 m 442 1055 l 531 1245 l 692 1245 l 543 1055 l 442 1055 "}," ":{"x_min":0,"x_max":0,"ha":695,"o":"m 0 0 l 0 0 "},"ˇ":{"x_min":27.5,"x_max":456.5,"ha":463,"o":"m 243 885 l 317 1000 l 456 1000 l 303 810 l 173 810 l 27 1000 l 166 1000 l 243 885 "},"Ў":{"x_min":6.5,"x_max":877.5,"ha":882,"o":"m 6 995 l 139 995 l 463 385 l 747 995 l 877 995 l 504 220 q 390 30 434 75 q 261 -14 345 -14 q 137 9 210 -14 l 137 121 q 249 92 189 92 q 332 122 297 92 q 409 263 367 153 l 6 995 m 589 1231 l 672 1231 q 609 1100 661 1146 q 471 1055 557 1055 q 332 1100 384 1055 q 271 1231 281 1145 l 354 1231 q 391 1161 363 1184 q 467 1139 420 1139 q 551 1161 522 1139 q 589 1231 579 1183 "},"≡":{"x_min":77,"x_max":733,"ha":810,"o":"m 733 736 l 77 736 l 77 849 l 733 849 l 733 736 m 733 433 l 77 433 l 77 547 l 733 547 l 733 433 m 733 131 l 77 131 l 77 245 l 733 245 l 733 131 "},"₦":{"x_min":25,"x_max":970,"ha":1003,"o":"m 970 303 l 889 303 l 889 0 l 754 0 l 551 303 l 232 303 l 232 0 l 106 0 l 106 303 l 25 303 l 25 417 l 106 417 l 106 578 l 25 578 l 25 692 l 106 692 l 106 995 l 240 995 l 443 692 l 763 692 l 763 995 l 889 995 l 889 692 l 970 692 l 970 578 l 889 578 l 889 417 l 970 417 l 970 303 m 763 417 l 763 578 l 519 578 l 627 417 l 763 417 m 291 692 l 232 781 l 232 692 l 291 692 m 763 213 l 763 303 l 703 303 l 763 213 m 475 417 l 367 578 l 232 578 l 232 417 l 475 417 "},"Ω":{"x_min":86,"x_max":1001,"ha":1067,"o":"m 336 109 q 224 197 262 154 q 133 349 165 262 q 102 544 102 437 q 155 788 102 676 q 312 959 209 899 q 548 1019 415 1019 q 898 846 776 1019 q 987 543 987 720 q 950 341 987 429 q 854 190 913 254 q 754 109 819 151 l 1001 113 l 1001 0 l 611 0 l 611 121 q 694 173 665 148 q 777 271 743 215 q 828 393 811 328 q 846 527 846 457 q 812 714 846 620 q 710 858 778 809 q 545 908 642 908 q 344 826 416 908 q 246 529 246 712 q 307 276 246 382 q 477 123 368 171 l 477 0 l 86 0 l 86 114 l 336 109 "},"ᴖ":{"x_min":46,"x_max":721,"ha":773,"o":"m 721 361 l 596 361 q 548 549 596 475 q 383 636 492 636 q 217 549 274 636 q 171 361 171 476 l 46 361 q 130 629 46 529 q 383 737 220 737 q 636 628 546 737 q 721 361 721 526 "},"s":{"x_min":43,"x_max":642,"ha":695,"o":"m 43 215 l 164 234 q 220 122 174 161 q 351 84 267 84 q 476 118 435 84 q 517 198 517 152 q 480 264 517 240 q 355 305 455 280 q 168 364 220 339 q 89 432 116 389 q 63 529 63 476 q 85 618 63 577 q 145 686 107 659 q 223 722 173 707 q 328 737 272 737 q 478 712 413 737 q 572 646 542 688 q 615 535 603 604 l 496 519 q 448 605 487 574 q 337 637 409 637 q 217 609 253 637 q 181 543 181 581 q 196 500 181 519 q 243 468 211 481 q 351 436 261 461 q 532 380 481 402 q 612 316 583 358 q 642 211 642 274 q 606 96 642 150 q 503 13 570 43 q 351 -16 436 -16 q 137 42 210 -16 q 43 215 63 100 "},"?":{"x_min":61,"x_max":703,"ha":773,"o":"m 321 245 q 320 281 320 269 q 340 405 320 353 q 388 484 355 444 q 476 569 413 513 q 559 659 540 625 q 578 732 578 692 q 522 857 578 803 q 385 912 466 912 q 254 862 307 912 q 186 709 202 813 l 61 725 q 161 938 77 864 q 383 1012 245 1012 q 616 932 529 1012 q 703 740 703 852 q 672 619 703 674 q 553 486 642 564 q 475 408 493 433 q 448 350 456 383 q 438 245 439 318 l 321 245 m 299 0 l 299 139 l 438 139 l 438 0 l 299 0 "},"ҹ":{"x_min":47,"x_max":632,"ha":724,"o":"m 632 0 l 510 0 l 510 290 q 367 259 435 267 l 367 114 l 300 114 l 300 255 l 285 255 q 161 292 225 255 q 69 399 93 332 q 47 532 47 459 l 47 721 l 169 721 l 169 584 q 175 476 169 505 q 230 386 187 418 q 300 359 259 364 l 300 547 l 367 547 l 367 359 q 510 393 426 365 l 510 721 l 632 721 l 632 0 "},"•":{"x_min":74,"x_max":418,"ha":486,"o":"m 74 487 q 124 608 74 558 q 245 659 175 659 q 367 608 316 659 q 418 487 418 558 q 367 365 418 416 q 245 315 316 315 q 124 365 175 315 q 74 487 74 416 "},"н":{"x_min":92,"x_max":675,"ha":767,"o":"m 92 721 l 214 721 l 214 420 l 553 420 l 553 721 l 675 721 l 675 0 l 553 0 l 553 320 l 214 320 l 214 0 l 92 0 l 92 721 "},"ᵮ":{"x_min":-43.015625,"x_max":434,"ha":386,"o":"m 434 999 l 415 893 q 344 900 377 900 q 263 872 285 900 q 243 787 243 848 l 243 721 l 383 721 l 383 626 l 243 626 l 243 382 q 273 376 261 376 q 323 434 314 376 l 411 434 q 278 280 406 280 q 243 285 263 280 l 243 0 l 121 0 l 121 337 q 98 342 106 342 q 47 278 45 342 l -43 278 q -7 386 -43 343 q 94 432 30 432 q 121 429 107 432 l 121 626 l 13 626 l 13 721 l 121 721 l 121 797 q 133 905 121 870 q 320 1012 173 1012 q 434 999 371 1012 "},"(":{"x_min":84,"x_max":411,"ha":463,"o":"m 324 -292 q 153 6 223 -164 q 84 360 84 177 q 136 669 84 521 q 324 1011 196 840 l 411 1011 q 302 809 329 869 q 238 614 261 716 q 209 359 209 487 q 411 -292 209 33 l 324 -292 "},"м":{"x_min":96,"x_max":859,"ha":955,"o":"m 96 721 l 285 721 l 473 143 l 683 721 l 859 721 l 859 0 l 737 0 l 737 580 l 524 0 l 415 0 l 215 608 l 215 0 l 96 0 l 96 721 "},"Қ":{"x_min":109,"x_max":804,"ha":809,"o":"m 804 -276 l 687 -276 l 687 0 l 640 0 l 474 270 q 382 403 412 372 q 241 466 321 466 l 241 0 l 109 0 l 109 995 l 241 995 l 241 560 q 385 615 338 560 q 460 762 410 644 q 528 901 502 861 q 713 996 591 996 q 794 994 789 996 l 794 880 q 767 881 785 880 q 741 882 750 882 q 632 833 671 882 q 576 721 611 807 q 516 593 539 626 q 409 509 477 537 q 599 331 505 483 l 731 117 l 804 117 l 804 -276 "},"ᴌ":{"x_min":11,"x_max":506,"ha":558,"o":"m 506 0 l 92 0 l 92 268 l 11 200 l 11 300 l 92 369 l 92 721 l 214 721 l 214 472 l 341 580 l 341 479 l 214 371 l 214 100 l 506 100 l 506 0 "},"з":{"x_min":34,"x_max":587,"ha":637,"o":"m 251 326 l 251 422 q 356 428 327 422 q 409 460 384 433 q 434 528 434 487 q 401 607 434 578 q 316 637 368 637 q 172 516 213 637 l 56 535 q 317 737 110 737 q 498 673 433 737 q 564 523 564 610 q 478 383 564 435 q 559 308 532 354 q 587 201 587 263 q 516 44 587 104 q 319 -16 446 -16 q 34 203 73 -16 l 149 227 q 212 119 164 157 q 321 82 259 82 q 424 117 383 82 q 465 206 465 152 q 439 279 465 248 q 384 318 413 311 q 278 326 355 326 q 251 326 272 326 "},"Ґ":{"x_min":109,"x_max":638,"ha":679,"o":"m 521 995 l 521 1270 l 638 1270 l 638 878 l 241 878 l 241 0 l 109 0 l 109 995 l 521 995 "},"Û":{"x_min":109,"x_max":891,"ha":1003,"o":"m 759 995 l 891 995 l 891 420 q 857 181 891 270 q 734 38 823 93 q 502 -17 646 -17 q 273 31 362 -17 q 146 170 184 79 q 109 420 109 261 l 109 995 l 241 995 l 241 420 q 265 229 241 291 q 347 135 289 168 q 490 102 406 102 q 697 167 635 102 q 759 420 759 233 l 759 995 m 504 1170 l 427 1055 l 288 1055 l 434 1245 l 564 1245 l 717 1055 l 578 1055 l 504 1170 "},"і":{"x_min":92,"x_max":214,"ha":309,"o":"m 92 855 l 92 995 l 214 995 l 214 855 l 92 855 m 92 0 l 92 721 l 214 721 l 214 0 l 92 0 "},"V":{"x_min":6.328125,"x_max":916.5625,"ha":926,"o":"m 390 0 l 6 995 l 149 995 l 407 272 q 459 109 438 185 q 513 272 482 190 l 782 995 l 916 995 l 527 0 l 390 0 "},"ᵕ":{"x_min":34,"x_max":490,"ha":524,"o":"m 490 565 q 433 384 490 452 q 262 311 372 311 q 90 383 151 311 q 34 565 34 451 l 119 565 q 150 438 119 487 q 262 380 188 380 q 373 438 335 380 q 405 565 405 488 l 490 565 "},"ӯ":{"x_min":22,"x_max":683.09375,"ha":695,"o":"m 86 -277 l 72 -162 q 142 -173 112 -173 q 207 -159 182 -173 q 247 -121 232 -145 q 285 -30 259 -103 q 296 0 288 -20 l 22 721 l 152 721 l 303 303 q 356 136 332 223 q 406 300 377 220 l 561 721 l 683 721 l 408 -12 q 340 -175 364 -130 q 265 -263 307 -235 q 164 -292 223 -292 q 86 -277 129 -292 m 141 810 l 141 910 l 564 910 l 564 810 l 141 810 "},"ҥ":{"x_min":92,"x_max":875,"ha":900,"o":"m 875 621 l 675 621 l 675 0 l 553 0 l 553 320 l 214 320 l 214 0 l 92 0 l 92 721 l 214 721 l 214 420 l 553 420 l 553 721 l 875 721 l 875 621 "},"ᵼ":{"x_min":17,"x_max":289,"ha":309,"o":"m 289 329 l 214 329 l 214 0 l 92 0 l 92 329 l 17 329 l 17 419 l 92 419 l 92 721 l 214 721 l 214 419 l 289 419 l 289 329 "},"ᴲ":{"x_min":34,"x_max":536,"ha":570,"o":"m 536 321 l 34 321 l 34 400 l 447 400 l 447 630 l 75 630 l 75 709 l 447 709 l 447 916 l 50 916 l 50 995 l 536 995 l 536 321 "},"ʼ":{"x_min":73,"x_max":215,"ha":309,"o":"m 215 891 q 193 760 215 800 q 103 678 164 705 l 73 726 q 147 862 143 754 l 84 862 l 84 1004 l 215 1004 l 215 891 "},"@":{"x_min":76,"x_max":1361,"ha":1410,"o":"m 788 110 q 689 28 743 59 q 580 -2 634 -2 q 462 33 519 -2 q 370 141 406 68 q 335 302 335 214 q 390 518 335 410 q 527 680 445 626 q 686 735 609 735 q 798 704 745 735 q 890 610 852 673 l 915 715 l 1036 715 l 938 259 q 918 154 918 164 q 931 123 918 136 q 965 110 945 110 q 1060 151 1001 110 q 1182 296 1137 205 q 1228 485 1228 388 q 1169 696 1228 598 q 996 853 1111 794 q 742 913 881 913 q 452 838 583 913 q 248 625 320 764 q 176 328 176 487 q 248 42 176 162 q 457 -134 320 -77 q 760 -192 594 -192 q 1058 -132 938 -192 q 1238 13 1178 -72 l 1361 13 q 1242 -132 1326 -58 q 1042 -248 1158 -205 q 762 -292 926 -292 q 484 -253 611 -292 q 268 -137 357 -214 q 132 41 178 -59 q 76 317 76 169 q 143 633 76 483 q 378 914 226 816 q 748 1012 531 1012 q 1050 943 916 1012 q 1262 738 1184 874 q 1328 483 1328 620 q 1189 133 1328 286 q 919 -3 1065 -3 q 843 11 872 -3 q 800 52 814 25 q 788 110 792 69 m 460 294 q 504 149 460 201 q 604 98 548 98 q 684 120 642 98 q 765 188 726 143 q 827 301 803 233 q 852 439 852 370 q 806 583 852 532 q 694 634 760 634 q 613 611 651 634 q 539 541 575 589 q 481 422 503 492 q 460 294 460 352 "},"℅":{"x_min":66,"x_max":1166,"ha":1230,"o":"m 421 681 l 505 670 q 434 534 491 583 q 295 486 377 486 q 128 553 191 486 q 66 747 66 621 q 129 944 66 877 q 295 1012 192 1012 q 430 970 378 1012 q 497 853 482 929 l 414 840 q 372 916 402 890 q 299 942 342 942 q 194 895 234 942 q 154 749 154 849 q 192 602 154 648 q 294 556 231 556 q 377 586 344 556 q 421 681 411 616 m 277 -37 l 822 1012 l 921 1012 l 378 -37 l 277 -37 m 694 251 q 759 445 694 377 q 930 514 824 514 q 1100 445 1034 514 q 1166 258 1166 377 q 1101 56 1166 124 q 930 -12 1036 -12 q 759 55 824 -12 q 694 251 694 123 m 781 251 q 823 106 781 154 q 929 58 865 58 q 1035 106 993 58 q 1078 253 1078 154 q 1035 395 1078 347 q 929 444 993 444 q 823 395 865 444 q 781 251 781 347 "},"i":{"x_min":92,"x_max":214,"ha":309,"o":"m 92 855 l 92 995 l 214 995 l 214 855 l 92 855 m 92 0 l 92 721 l 214 721 l 214 0 l 92 0 "},"ќ":{"x_min":91,"x_max":619,"ha":608,"o":"m 91 721 l 213 721 l 213 409 q 295 431 271 409 q 364 561 318 453 q 422 674 400 647 q 474 711 444 701 q 567 721 503 721 l 592 721 l 592 620 l 558 621 q 496 606 509 621 q 452 517 481 591 q 401 419 424 446 q 330 369 378 392 q 485 223 409 348 l 619 0 l 484 0 l 353 222 q 283 311 313 290 q 213 333 254 333 l 213 0 l 91 0 l 91 721 m 232 810 l 321 1000 l 482 1000 l 333 810 l 232 810 "},"≤":{"x_min":52,"x_max":711,"ha":762,"o":"m 52 517 l 52 631 l 711 909 l 711 787 l 188 573 l 711 358 l 711 236 l 52 517 m 709 73 l 52 73 l 52 186 l 709 186 l 709 73 "},"˦":{"x_min":102,"x_max":430,"ha":532,"o":"m 430 0 l 324 0 l 324 666 l 102 666 l 102 772 l 324 772 l 324 994 l 430 994 l 430 0 "},"ё":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 m 189 810 l 189 949 l 317 949 l 317 810 l 189 810 m 442 810 l 442 949 l 570 949 l 570 810 l 442 810 "},"˹":{"x_min":115,"x_max":352,"ha":463,"o":"m 352 925 l 185 925 l 185 770 l 115 770 l 115 995 l 352 995 l 352 925 "},"ᵢ":{"x_min":68,"x_max":151,"ha":218,"o":"m 151 488 l 68 488 l 68 583 l 151 583 l 151 488 m 151 -90 l 68 -90 l 68 397 l 151 397 l 151 -90 "},"ԇ":{"x_min":56,"x_max":666,"ha":707,"o":"m 666 -204 l 566 -204 l 566 0 l 465 0 l 465 205 q 390 313 465 287 q 251 326 352 326 l 251 422 q 335 424 322 422 q 409 460 382 431 q 434 528 434 487 q 401 608 434 580 q 316 637 368 637 q 172 515 213 637 l 56 534 q 317 737 110 737 q 489 682 420 737 q 564 523 564 623 q 478 383 564 435 q 587 201 587 324 l 587 100 l 666 100 l 666 -204 "},"Э":{"x_min":50,"x_max":923.453125,"ha":998,"o":"m 417 572 l 417 455 l 787 455 q 694 190 779 287 q 474 94 608 94 q 177 346 237 94 l 50 313 q 465 -17 136 -17 q 815 134 700 -17 q 923 508 930 286 q 871 756 923 644 q 714 940 820 868 q 462 1012 608 1012 q 203 935 307 1012 q 63 722 99 858 l 192 688 q 463 897 248 897 q 691 809 608 897 q 782 572 773 721 l 417 572 "},"ᴜ":{"x_min":92,"x_max":669,"ha":760,"o":"m 92 721 l 214 721 l 214 293 q 263 133 214 183 q 379 84 313 84 q 475 115 434 84 q 531 187 515 146 q 547 303 547 227 l 547 721 l 669 721 l 669 298 q 588 61 669 138 q 377 -16 508 -16 q 210 29 276 -16 q 118 133 144 74 q 92 294 92 192 l 92 721 "},"Ӡ":{"x_min":53,"x_max":798,"ha":839,"o":"m 798 878 l 504 584 q 702 492 626 566 q 783 291 783 413 q 669 55 783 138 q 420 -17 570 -17 q 53 280 137 -17 l 178 313 q 260 160 195 222 q 419 96 329 96 q 573 140 511 96 q 645 285 645 192 q 568 432 645 385 q 407 471 507 471 l 349 471 l 349 590 l 639 878 l 86 878 l 86 995 l 798 995 l 798 878 "},"ӧ":{"x_min":46,"x_max":721,"ha":773,"o":"m 46 360 q 157 656 46 560 q 383 737 250 737 q 626 639 532 737 q 721 370 721 542 q 679 151 721 231 q 557 28 637 72 q 383 -16 478 -16 q 139 81 232 -16 q 46 360 46 178 m 171 360 q 231 152 171 221 q 383 84 292 84 q 535 153 474 84 q 596 364 596 222 q 535 567 596 498 q 383 636 474 636 q 231 567 292 636 q 171 360 171 498 m 191 810 l 191 949 l 319 949 l 319 810 l 191 810 m 444 810 l 444 949 l 572 949 l 572 810 l 444 810 "},"ю":{"x_min":93,"x_max":986,"ha":1042,"o":"m 93 721 l 215 721 l 215 419 l 363 419 q 459 655 379 573 q 668 737 540 737 q 840 692 777 737 q 944 571 903 648 q 986 363 986 494 q 901 80 986 176 q 671 -16 816 -16 q 454 73 536 -16 q 363 319 373 163 l 215 319 l 215 0 l 93 0 l 93 721 m 675 633 q 535 564 585 633 q 486 371 486 495 q 536 153 486 222 q 670 84 586 84 q 807 148 754 84 q 861 354 861 212 q 814 563 861 493 q 675 633 768 633 "},"Ѐ":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 m 577 1055 l 479 1055 l 322 1245 l 485 1245 l 577 1055 "},"Ӟ":{"x_min":53,"x_max":783,"ha":839,"o":"m 53 281 l 178 314 q 254 168 192 241 q 419 96 316 96 q 584 149 524 96 q 645 279 645 203 q 581 409 645 361 q 407 458 517 458 l 344 458 l 344 573 q 482 583 434 573 q 568 637 531 594 q 605 735 605 680 q 554 848 605 800 q 417 897 503 897 q 289 859 342 897 q 215 759 235 821 q 195 667 195 697 l 69 695 q 419 1012 115 1012 q 650 930 565 1012 q 736 741 736 849 q 604 525 736 601 q 731 439 680 504 q 783 284 783 374 q 683 69 783 156 q 420 -17 584 -17 q 53 281 137 -17 m 243 1055 l 243 1194 l 371 1194 l 371 1055 l 243 1055 m 496 1055 l 496 1194 l 624 1194 l 624 1055 l 496 1055 "},"ԑ":{"x_min":50,"x_max":603,"ha":637,"o":"m 603 202 q 317 -16 563 -16 q 132 34 204 -16 q 50 202 50 93 q 158 383 50 325 q 73 523 73 435 q 148 682 73 623 q 319 737 217 737 q 581 534 526 737 l 465 515 q 320 637 423 637 q 236 608 269 637 q 203 528 203 579 q 225 464 203 493 q 281 428 247 435 q 386 422 309 423 l 386 326 q 358 327 364 327 q 270 323 289 327 q 197 280 226 314 q 172 206 172 248 q 216 114 172 150 q 315 82 257 82 q 428 122 381 82 q 488 227 473 161 l 603 202 "},"ˁ":{"x_min":34,"x_max":450,"ha":484,"o":"m 450 851 l 370 839 q 259 936 347 936 q 119 750 119 936 q 254 563 119 563 q 299 570 278 563 l 299 321 l 216 321 l 216 499 q 77 584 126 505 q 34 748 34 653 q 139 975 34 917 q 255 1005 192 1005 q 450 851 420 1005 "},"‹":{"x_min":62,"x_max":377,"ha":463,"o":"m 197 357 l 377 49 l 276 49 l 62 357 l 276 668 l 377 668 l 197 357 "},"Ԛ":{"x_min":60,"x_max":1029,"ha":1080,"o":"m 859 106 q 1029 14 951 43 l 990 -77 q 776 44 883 -38 q 532 -17 666 -17 q 288 48 397 -17 q 119 231 178 113 q 60 497 60 349 q 119 765 60 644 q 289 948 179 885 q 535 1012 399 1012 q 783 946 673 1012 q 952 763 894 881 q 1010 498 1010 645 q 972 277 1010 375 q 859 106 935 179 m 570 275 q 758 180 684 243 q 874 498 874 285 q 833 709 874 618 q 713 849 792 799 q 536 899 634 899 q 292 798 389 899 q 196 497 196 697 q 291 199 196 303 q 536 96 387 96 q 668 122 606 96 q 539 179 607 162 l 570 275 "},"ᴒ":{"x_min":46,"x_max":799,"ha":845,"o":"m 799 369 q 571 82 799 126 l 552 201 q 699 365 699 235 q 423 573 699 573 q 146 372 146 573 q 326 191 146 216 l 311 71 q 118 168 189 89 q 46 370 46 249 q 154 618 46 531 q 419 698 254 698 q 755 541 668 698 q 799 369 799 462 "},"ì":{"x_min":38,"x_max":293,"ha":386,"o":"m 134 0 l 134 721 l 256 721 l 256 0 l 134 0 m 293 810 l 195 810 l 38 1000 l 201 1000 l 293 810 "},"±":{"x_min":53,"x_max":710,"ha":762,"o":"m 324 177 l 324 450 l 53 450 l 53 563 l 324 563 l 324 834 l 439 834 l 439 563 l 710 563 l 710 450 l 439 450 l 439 177 l 324 177 m 710 0 l 53 0 l 53 114 l 710 114 l 710 0 "},"ӵ":{"x_min":46,"x_max":632,"ha":724,"o":"m 46 721 l 168 721 l 168 584 q 178 456 168 496 q 229 387 189 417 q 330 358 269 358 q 510 394 399 358 l 510 721 l 632 721 l 632 0 l 510 0 l 510 291 q 299 256 397 256 q 153 297 216 256 q 68 399 90 339 q 46 532 46 460 l 46 721 m 149 810 l 149 949 l 277 949 l 277 810 l 149 810 m 402 810 l 402 949 l 530 949 l 530 810 l 402 810 "},"|":{"x_min":128,"x_max":234,"ha":361,"o":"m 128 -293 l 128 1011 l 234 1011 l 234 -293 l 128 -293 "},"Ө":{"x_min":64,"x_max":1016,"ha":1080,"o":"m 1016 495 q 890 132 1016 274 q 540 -17 758 -17 q 286 52 399 -17 q 114 250 167 124 q 64 484 64 369 q 184 858 64 714 q 540 1012 314 1012 q 891 862 761 1012 q 1016 495 1016 719 m 878 556 q 785 793 865 704 q 541 899 690 899 q 297 799 395 899 q 203 556 217 718 l 878 556 m 878 439 l 201 439 q 292 204 211 298 q 539 96 384 96 q 779 195 688 96 q 878 439 865 287 "},"§":{"x_min":55,"x_max":709,"ha":773,"o":"m 97 -48 l 220 -30 q 280 -153 238 -117 q 392 -189 321 -189 q 501 -153 462 -189 q 540 -71 540 -118 q 515 -7 540 -36 q 285 158 473 43 q 145 255 184 220 q 80 338 105 290 q 55 437 55 385 q 95 555 55 502 q 207 629 136 608 q 139 714 159 675 q 120 797 120 753 q 187 948 120 884 q 367 1012 255 1012 q 565 951 494 1012 q 651 777 636 891 l 524 764 q 474 879 509 846 q 378 912 438 912 q 277 878 315 912 q 239 804 239 844 q 263 738 239 768 q 471 589 301 692 q 615 493 578 524 q 686 409 663 452 q 709 315 709 365 q 659 183 709 238 q 555 120 631 152 q 636 31 609 79 q 663 -69 663 -15 q 629 -182 663 -129 q 531 -263 595 -235 q 393 -292 467 -292 q 187 -227 263 -292 q 97 -48 111 -162 m 493 165 q 569 225 544 191 q 594 292 594 260 q 558 374 594 331 q 405 488 522 416 q 266 582 312 545 q 189 520 212 551 q 166 450 166 488 q 196 369 166 408 q 336 266 227 330 q 493 165 427 212 "},"҇":{"x_min":-374,"x_max":373,"ha":0,"o":"m 373 909 q 185 947 267 909 q 48 1016 139 970 q -107 1055 -28 1055 q -280 909 -244 1055 l -374 909 q -279 1078 -352 1014 q -99 1142 -206 1142 q 135 1071 -15 1142 q 373 1001 286 1001 l 373 909 "},"ᵓ":{"x_min":34,"x_max":458,"ha":492,"o":"m 458 562 q 404 384 458 450 q 236 311 346 311 q 101 359 155 311 q 34 489 46 407 l 115 500 q 237 380 131 380 q 373 565 373 380 q 232 750 373 750 q 122 652 145 750 l 41 664 q 235 819 70 819 q 432 701 379 819 q 458 562 458 642 "},"џ":{"x_min":92,"x_max":675,"ha":767,"o":"m 433 0 l 433 -205 l 333 -205 l 333 0 l 92 0 l 92 721 l 214 721 l 214 100 l 553 100 l 553 721 l 675 721 l 675 0 l 433 0 "},"ˍ":{"x_min":20,"x_max":443,"ha":463,"o":"m 443 -202 l 20 -202 l 20 -102 l 443 -102 l 443 -202 "},"љ":{"x_min":13,"x_max":1210,"ha":1259,"o":"m 741 721 l 741 438 l 896 438 q 1127 379 1045 438 q 1210 217 1210 321 q 1143 65 1210 131 q 923 0 1077 0 l 619 0 l 619 621 l 280 621 l 280 261 q 266 93 280 142 q 215 20 253 44 q 107 -4 178 -4 q 13 0 88 -4 l 13 100 q 88 93 61 93 q 144 119 130 93 q 158 245 158 146 l 158 721 l 741 721 m 741 100 l 869 100 q 1035 128 985 100 q 1085 217 1085 156 q 1048 301 1085 265 q 886 338 1012 338 l 741 338 l 741 100 "},"һ":{"x_min":92,"x_max":679,"ha":773,"o":"m 92 0 l 92 995 l 214 995 l 214 638 q 429 737 299 737 q 569 705 509 737 q 653 618 628 673 q 679 456 679 562 l 679 0 l 557 0 l 557 456 q 517 590 557 548 q 404 632 477 632 q 302 603 350 632 q 234 527 254 575 q 214 394 214 479 l 214 0 l 92 0 "},"ᵽ":{"x_min":21,"x_max":767,"ha":773,"o":"m 767 329 l 716 329 q 562 31 703 118 q 403 -16 486 -16 q 214 74 285 -16 l 214 -276 l 92 -276 l 92 329 l 21 329 l 21 419 l 92 419 l 92 721 l 203 721 l 203 626 q 412 737 281 737 q 681 555 606 737 q 714 419 707 492 l 767 419 l 767 329 m 590 419 q 538 569 582 509 q 400 641 485 641 q 262 568 322 641 q 205 419 216 512 l 590 419 m 591 329 l 203 329 q 249 162 207 228 q 394 84 301 84 q 541 162 489 84 q 591 329 584 228 "},"q":{"x_min":48.71875,"x_max":672.71875,"ha":773,"o":"m 550 -276 l 550 76 q 471 10 522 36 q 362 -16 419 -16 q 141 86 233 -16 q 48 367 48 188 q 86 561 48 475 q 195 692 123 648 q 352 737 267 737 q 562 624 486 737 l 562 721 l 672 721 l 672 -276 l 550 -276 m 173 362 q 232 153 173 223 q 371 84 290 84 q 506 150 450 84 q 562 351 562 216 q 503 568 562 495 q 363 641 443 641 q 229 573 284 641 q 173 362 173 505 "},"˳":{"x_min":109,"x_max":353,"ha":463,"o":"m 353 -168 q 317 -255 353 -219 q 231 -292 282 -292 q 144 -255 179 -292 q 109 -165 109 -218 q 145 -79 109 -115 q 231 -44 181 -44 q 317 -80 282 -44 q 353 -168 353 -116 m 304 -167 q 283 -115 304 -136 q 232 -94 262 -94 q 181 -115 202 -94 q 161 -165 161 -136 q 181 -217 161 -195 q 232 -240 202 -240 q 283 -218 262 -240 q 304 -167 304 -197 "},"Ӌ":{"x_min":59,"x_max":817,"ha":926,"o":"m 817 0 l 711 0 l 711 -276 l 594 -276 l 594 117 l 685 117 l 685 400 q 375 335 507 335 q 202 377 281 335 q 86 506 115 424 q 59 702 59 582 l 59 995 l 191 995 l 191 714 q 392 449 191 449 q 685 510 531 449 l 685 995 l 817 995 l 817 0 "},"Ҟ":{"x_min":3,"x_max":804,"ha":809,"o":"m 804 0 l 640 0 l 473 270 q 382 403 411 372 q 241 466 321 466 l 241 0 l 109 0 l 109 729 l 3 729 l 3 819 l 109 819 l 109 995 l 241 995 l 241 819 l 352 819 l 352 729 l 241 729 l 241 560 q 386 615 338 560 q 460 762 411 644 q 515 879 497 850 q 604 968 551 939 q 713 996 653 996 q 794 994 789 996 l 794 880 q 767 881 785 880 q 741 882 750 882 q 632 833 671 882 q 576 721 611 807 q 516 593 539 626 q 409 509 477 537 q 599 331 505 483 l 804 0 "},"ᴠ":{"x_min":18,"x_max":678,"ha":694,"o":"m 290 0 l 18 721 l 146 721 l 301 289 q 347 143 326 219 q 392 281 363 200 l 552 721 l 678 721 l 406 0 l 290 0 "},"Ԑ":{"x_min":56,"x_max":786,"ha":839,"o":"m 786 281 q 418 -17 701 -17 q 169 58 271 -17 q 56 284 56 142 q 104 436 56 369 q 234 525 153 502 q 103 741 103 602 q 201 942 103 866 q 419 1012 290 1012 q 770 695 723 1012 l 644 666 q 617 774 644 719 q 550 859 591 830 q 421 897 497 897 q 291 854 345 897 q 234 735 234 809 q 269 638 234 683 q 355 583 305 594 q 495 573 405 573 l 495 458 l 431 458 q 270 418 333 458 q 194 279 194 371 q 265 140 194 191 q 419 96 328 96 q 578 161 509 96 q 661 313 643 222 l 786 281 "},"ᵂ":{"x_min":0,"x_max":865,"ha":865,"o":"m 865 995 l 680 321 l 594 321 l 431 913 q 411 834 421 869 l 269 321 l 178 321 l 0 995 l 91 995 l 193 553 q 222 415 211 475 l 252 539 l 380 995 l 487 995 l 584 653 q 636 415 620 524 q 669 562 648 476 l 775 995 l 865 995 "},"Ж":{"x_min":5,"x_max":1277,"ha":1283,"o":"m 709 995 l 709 560 q 842 595 805 560 q 934 762 878 631 q 1002 900 975 860 q 1078 968 1029 941 q 1187 996 1128 996 q 1267 994 1251 996 l 1267 880 q 1241 880 1260 880 q 1214 881 1219 881 q 1121 851 1151 881 q 1050 721 1090 820 q 975 574 1006 613 q 883 509 943 535 q 1072 331 980 482 l 1277 0 l 1114 0 l 947 269 q 836 421 881 377 q 709 466 790 466 l 709 0 l 574 0 l 574 466 q 459 431 509 466 q 343 283 409 397 l 335 269 l 168 0 l 5 0 l 209 331 q 399 509 303 483 q 312 567 346 531 q 231 721 278 603 q 158 854 189 827 q 67 882 128 882 l 15 880 l 15 994 q 90 996 22 996 q 203 969 156 996 q 278 902 251 942 q 348 762 305 861 q 440 595 405 629 q 574 560 476 561 l 574 995 l 709 995 "},"®":{"x_min":2,"x_max":1025,"ha":1023,"o":"m 513 1012 q 765 945 642 1012 q 956 756 888 879 q 1025 499 1025 633 q 957 245 1025 367 q 768 55 890 123 q 513 -12 646 -12 q 259 55 380 -12 q 69 245 137 123 q 2 499 2 367 q 70 756 2 633 q 262 945 139 879 q 513 1012 385 1012 m 513 927 q 304 871 406 927 q 144 713 202 816 q 87 499 87 610 q 143 287 87 389 q 301 129 200 186 q 513 73 403 73 q 725 129 624 73 q 883 287 827 186 q 940 499 940 389 q 882 713 940 610 q 723 871 825 816 q 513 927 620 927 m 290 217 l 290 768 l 479 768 q 619 752 576 768 q 689 699 663 737 q 715 618 715 661 q 671 513 715 558 q 557 463 628 468 q 603 433 586 450 q 684 324 636 401 l 752 217 l 643 217 l 594 303 q 501 431 537 406 q 430 450 477 450 l 379 451 l 379 217 l 290 217 m 379 527 l 487 527 q 592 550 564 527 q 621 611 621 573 q 607 654 621 635 q 569 683 593 674 q 480 693 545 693 l 379 693 l 379 527 "},"ѽ":{"x_min":54,"x_max":1129,"ha":1183,"o":"m 1068 910 q 880 948 968 910 q 743 1017 811 982 q 587 1056 664 1056 q 415 910 450 1056 l 321 910 q 407 1071 341 1008 q 595 1143 483 1143 q 827 1072 686 1143 q 1068 1002 967 1002 l 1068 910 m 646 935 q 624 847 646 877 q 549 795 603 817 l 526 840 q 570 864 560 854 q 585 910 585 878 l 533 910 l 533 1005 l 646 1005 l 646 935 m 1129 357 q 1049 92 1129 191 q 801 -16 963 -16 q 591 31 686 -16 q 381 -16 497 -16 q 133 92 219 -16 q 54 357 54 191 q 132 626 54 525 q 382 737 218 737 l 382 637 q 179 361 179 637 q 380 84 179 84 q 591 149 494 84 q 802 84 688 84 q 1004 361 1004 84 q 796 637 1004 637 l 796 737 q 1048 627 962 737 q 1129 357 1129 526 "},"Н":{"x_min":112,"x_max":891,"ha":1003,"o":"m 112 0 l 112 995 l 244 995 l 244 586 l 759 586 l 759 995 l 891 995 l 891 0 l 759 0 l 759 469 l 244 469 l 244 0 l 112 0 "},"ᵚ":{"x_min":68,"x_max":728,"ha":796,"o":"m 728 321 l 654 321 l 654 390 q 506 311 603 311 q 417 333 452 311 q 368 396 383 355 q 218 311 311 311 q 68 474 68 311 l 68 808 l 150 808 l 150 501 q 187 395 150 419 q 236 382 208 382 q 356 525 356 382 l 356 808 l 438 808 l 438 492 q 524 382 438 382 q 632 454 604 382 q 645 556 645 488 l 645 808 l 728 808 l 728 321 "},"₧":{"x_min":34.59375,"x_max":1488,"ha":1519,"o":"m 34 995 l 348 995 q 590 907 506 995 q 663 721 654 839 l 725 721 l 725 932 l 848 931 l 848 721 l 1064 721 q 1184 741 1122 741 q 1392 671 1312 741 q 1460 518 1457 616 l 1334 519 q 1294 604 1329 575 q 1189 634 1259 634 q 1086 606 1120 634 q 1052 548 1052 579 q 1090 486 1052 510 q 1236 436 1128 462 q 1390 382 1343 410 q 1462 309 1437 355 q 1488 212 1488 263 q 1408 51 1488 121 q 1196 -18 1328 -18 q 1058 6 1111 -18 q 958 88 1004 31 l 956 0 q 921 -8 937 -5 q 893 -11 905 -11 q 749 41 793 -11 q 725 140 725 71 l 725 623 l 656 623 q 586 493 634 544 q 460 420 537 443 q 274 406 406 406 l 166 406 l 166 0 l 34 0 l 34 995 m 166 879 l 166 521 l 256 521 q 417 537 364 521 q 499 596 469 554 q 529 700 529 637 q 504 797 529 756 q 437 858 480 838 q 305 879 395 879 l 166 879 m 847 622 l 847 178 l 847 157 q 862 116 847 131 q 908 102 878 102 q 925 103 916 102 q 944 108 934 105 q 921 166 928 140 q 915 229 915 192 l 1038 228 q 1087 123 1043 161 q 1204 86 1131 86 q 1327 127 1275 86 q 1366 199 1366 158 q 1342 252 1366 230 q 1196 311 1311 280 q 1044 362 1082 342 q 958 433 985 393 q 931 527 931 474 q 952 622 931 579 l 847 622 "},"л":{"x_min":16,"x_max":718,"ha":810,"o":"m 151 721 l 718 721 l 718 0 l 596 0 l 596 621 l 273 621 l 273 261 q 264 95 273 135 q 220 24 256 54 q 114 -5 183 -5 q 16 0 71 -5 l 16 102 l 69 102 q 123 109 107 102 q 145 134 140 117 q 151 245 151 151 l 151 721 "},"ѱ":{"x_min":49,"x_max":873,"ha":956,"o":"m 873 369 q 854 182 873 241 q 741 40 827 95 q 522 -16 661 -11 l 522 -276 l 400 -276 l 400 -16 q 181 174 227 -16 l 49 721 l 171 721 l 296 193 q 400 86 322 86 l 400 721 l 522 721 l 522 86 q 733 209 694 95 q 751 365 751 260 l 751 721 l 873 721 l 873 369 "},"ˠ":{"x_min":0,"x_max":448,"ha":448,"o":"m 448 808 l 267 395 l 296 327 q 323 230 323 265 q 223 123 323 123 q 124 230 124 123 q 151 327 124 265 l 180 395 l 0 808 l 90 808 l 224 496 l 357 808 l 448 808 m 246 233 q 230 281 246 244 l 224 297 l 217 281 q 201 233 201 244 q 224 198 201 198 q 246 233 246 198 "},"⁫":{"x_min":-158,"x_max":159,"ha":0,"o":"m -111 716 l 112 716 l 112 911 l -111 911 l -111 716 m -158 668 l -158 959 l 159 959 l 159 668 l 25 668 l 25 -187 l -24 -187 l -24 668 l -158 668 "},"ᴑ":{"x_min":46,"x_max":799,"ha":845,"o":"m 799 360 q 691 106 799 195 q 422 23 591 23 q 126 134 222 23 q 46 360 46 227 q 151 611 46 519 q 412 698 251 698 q 754 534 664 698 q 799 360 799 455 m 699 360 q 610 526 699 471 q 418 573 536 573 q 233 524 306 573 q 147 360 147 467 q 233 194 147 251 q 422 148 306 148 q 612 194 538 148 q 699 360 699 250 "},"Ӽ":{"x_min":6,"x_max":915,"ha":926,"o":"m 915 -94 q 866 -234 915 -179 q 727 -292 814 -292 q 627 -278 676 -292 l 651 -175 q 712 -185 687 -185 q 766 -160 743 -185 q 789 -98 789 -135 q 732 37 789 -43 l 465 412 l 163 0 l 6 0 l 390 517 l 51 995 l 207 995 l 471 625 l 746 995 l 890 995 l 545 522 l 835 115 q 915 -94 915 4 "}," ":{"x_min":0,"x_max":0,"ha":386},"∑":{"x_min":83,"x_max":940,"ha":990,"o":"m 95 1011 l 933 1011 l 933 900 l 263 900 l 673 374 l 234 -183 l 940 -183 l 940 -292 l 83 -292 l 83 -165 l 503 368 l 95 892 l 95 1011 "},"Ҁ":{"x_min":69,"x_max":931,"ha":1003,"o":"m 931 722 l 801 692 q 535 899 734 899 q 351 848 428 899 q 236 696 269 795 q 205 505 205 603 q 357 142 205 233 q 526 96 435 96 q 600 104 563 96 l 600 -276 l 468 -276 l 468 -13 q 275 48 354 -2 q 116 249 171 116 q 69 504 69 366 q 297 952 69 826 q 538 1012 406 1012 q 787 937 685 1012 q 931 722 890 862 "},"ʰ":{"x_min":68,"x_max":465,"ha":532,"o":"m 465 321 l 382 321 l 382 630 q 279 749 382 749 q 164 678 194 749 q 151 587 151 646 l 151 321 l 68 321 l 68 995 l 151 995 l 151 753 q 296 820 208 820 q 448 739 411 820 q 465 629 465 701 l 465 321 "},"+":{"x_min":77,"x_max":734,"ha":811,"o":"m 348 160 l 348 433 l 77 433 l 77 547 l 348 547 l 348 818 l 463 818 l 463 547 l 734 547 l 734 433 l 463 433 l 463 160 l 348 160 "},"ᵧ":{"x_min":0,"x_max":446,"ha":446,"o":"m 446 397 l 263 -90 l 263 -276 l 180 -276 l 180 -90 l 0 397 l 86 397 l 221 13 l 361 397 l 446 397 "},"ᴺ":{"x_min":34,"x_max":564,"ha":598,"o":"m 564 321 l 473 321 l 119 850 l 119 321 l 34 321 l 34 995 l 125 995 l 479 465 l 479 995 l 564 995 l 564 321 "},"˗":{"x_min":20,"x_max":443,"ha":463,"o":"m 443 182 l 20 182 l 20 282 l 443 282 l 443 182 "},"ӂ":{"x_min":-3,"x_max":934,"ha":929,"o":"m 528 721 l 528 409 q 609 431 586 409 q 678 562 633 453 q 755 693 721 664 q 861 721 788 721 l 906 721 l 906 620 l 872 621 q 810 606 824 621 q 767 517 796 591 q 717 419 740 446 q 645 369 693 392 q 799 223 724 348 l 934 0 l 799 0 l 668 222 q 598 311 628 290 q 528 333 569 333 l 528 0 l 403 0 l 403 333 q 332 312 362 333 q 262 223 302 291 l 131 0 l -3 0 l 130 223 q 286 369 206 348 q 210 424 231 394 q 145 565 188 454 q 113 611 130 603 q 60 620 95 620 q 25 620 52 620 l 25 721 l 41 721 q 141 712 112 721 q 193 676 170 704 q 252 561 215 649 q 320 432 297 455 q 403 409 343 409 l 403 721 l 528 721 m 676 986 q 475 810 654 810 q 275 986 296 810 l 358 986 q 471 894 377 894 q 593 986 574 894 l 676 986 "},"Ë":{"x_min":110,"x_max":851,"ha":926,"o":"m 110 0 l 110 995 l 828 995 l 828 878 l 242 878 l 242 573 l 791 573 l 791 456 l 242 456 l 242 117 l 851 117 l 851 0 l 110 0 m 297 1055 l 297 1194 l 425 1194 l 425 1055 l 297 1055 m 550 1055 l 550 1194 l 678 1194 l 678 1055 l 550 1055 "}," ":{"x_min":0,"x_max":0,"ha":1389,"o":"m 0 0 l 0 0 "},"ð":{"x_min":50,"x_max":717,"ha":773,"o":"m 209 995 l 356 995 q 439 926 403 956 l 585 995 l 616 925 l 499 869 q 717 354 717 620 q 622 83 717 182 q 382 -16 528 -16 q 113 115 209 -16 q 50 350 50 201 q 137 623 50 527 q 356 720 224 720 q 425 711 395 720 q 499 679 455 703 q 457 757 475 729 q 403 825 439 785 l 217 739 l 187 808 l 348 883 q 209 995 279 938 m 590 359 q 528 557 590 488 q 378 626 467 626 q 232 557 290 626 q 175 347 175 488 q 234 150 175 216 q 382 84 293 84 q 529 153 468 84 q 590 359 590 223 "},"щ":{"x_min":96,"x_max":1099,"ha":1143,"o":"m 96 721 l 218 721 l 218 100 l 496 100 l 496 721 l 618 721 l 618 100 l 896 100 l 896 721 l 1018 721 l 1018 100 l 1099 100 l 1099 -204 l 999 -204 l 999 0 l 96 0 l 96 721 "},"℮":{"x_min":61,"x_max":778,"ha":834,"o":"m 218 360 l 218 109 q 419 27 299 27 q 686 193 590 27 l 736 164 q 578 11 654 46 q 419 -23 502 -23 q 159 85 258 -23 q 61 360 61 193 q 160 635 61 527 q 419 743 260 743 q 667 646 564 743 q 778 360 770 550 l 218 360 m 621 410 l 621 611 q 418 693 534 693 q 218 610 299 693 l 218 410 l 621 410 "},"ᵵ":{"x_min":-47.015625,"x_max":407,"ha":386,"o":"m 407 441 q 274 287 402 287 q 236 293 257 287 l 236 204 q 245 132 236 151 q 304 104 259 104 q 358 108 325 104 l 376 0 q 283 -10 324 -10 q 128 66 162 -10 q 114 210 114 101 l 114 345 q 94 349 103 349 q 43 285 41 349 l -47 285 q -11 393 -47 350 q 90 439 26 439 q 114 436 99 439 l 114 626 l 24 626 l 24 721 l 114 721 l 114 899 l 236 972 l 236 721 l 358 721 l 358 626 l 236 626 l 236 389 q 269 383 255 383 q 319 441 310 383 l 407 441 "},"ᴗ":{"x_min":46,"x_max":721,"ha":773,"o":"m 721 360 q 636 92 721 194 q 383 -16 546 -16 q 130 91 220 -16 q 46 360 46 191 l 171 360 q 217 171 171 244 q 383 85 274 85 q 548 171 492 85 q 596 360 596 245 l 721 360 "},"ӕ":{"x_min":47,"x_max":1180,"ha":1235,"o":"m 1177 221 q 1061 45 1143 107 q 859 -16 980 -16 q 708 16 773 -16 q 591 118 643 49 q 448 16 521 49 q 293 -16 376 -16 q 111 44 176 -16 q 47 190 47 104 q 80 299 47 248 q 174 377 114 350 q 365 420 234 403 q 537 454 467 434 q 537 481 537 470 q 502 601 537 567 q 377 636 466 636 q 278 621 318 636 q 218 581 237 607 q 186 497 198 555 l 67 512 q 121 637 85 591 q 223 710 157 684 q 379 737 290 737 q 561 703 492 737 q 628 640 601 683 q 726 712 672 687 q 859 737 781 737 q 1041 683 969 737 q 1146 542 1113 630 q 1180 370 1180 455 q 1178 329 1180 357 l 658 329 q 682 187 659 231 q 754 113 704 143 q 864 84 804 84 q 982 124 933 84 q 1049 237 1030 164 l 1177 221 m 658 429 l 1055 429 q 993 586 1045 536 q 859 636 942 636 q 718 581 773 636 q 658 429 664 527 m 539 362 q 320 312 485 338 q 217 277 246 300 q 177 194 177 245 q 212 112 177 145 q 317 80 248 80 q 453 118 395 80 q 528 215 511 157 q 539 362 539 250 "},"⃰":{"x_min":-222,"x_max":226,"ha":0,"o":"m -222 1007 l -190 1103 q -34 1037 -83 1065 q -48 1206 -47 1159 l 50 1206 q 34 1038 47 1138 q 194 1103 104 1073 l 226 1007 q 56 968 139 978 q 173 840 98 933 l 92 783 q 0 928 52 836 q -88 783 -50 833 l -168 840 q -56 968 -89 937 q -222 1007 -143 985 "}," ":{"x_min":0,"x_max":0,"ha":773,"o":"m 0 0 l 0 0 "},"Ҹ":{"x_min":59,"x_max":817,"ha":926,"o":"m 817 0 l 685 0 l 685 400 q 481 344 574 360 l 481 155 l 400 155 l 400 335 q 374 335 385 335 q 202 377 281 335 q 86 506 115 424 q 59 702 59 582 l 59 995 l 191 995 l 191 714 q 250 500 191 552 q 392 449 310 448 l 400 449 l 400 755 l 481 755 l 481 455 q 685 510 579 468 l 685 995 l 817 995 l 817 0 "},"₡":{"x_min":69,"x_max":948,"ha":1003,"o":"m 948 315 q 803 71 907 157 q 535 -17 696 -18 l 521 -17 l 505 -76 l 407 -76 l 426 -6 q 337 18 378 2 l 311 -76 l 213 -76 l 253 66 q 69 504 69 202 q 187 862 69 724 q 519 1012 309 1005 l 534 1064 l 632 1064 l 615 1006 q 704 982 660 999 l 728 1064 l 826 1064 l 789 936 q 931 722 891 860 l 801 691 q 751 797 780 755 l 553 97 q 816 348 765 113 l 948 315 m 672 868 q 584 896 635 889 l 369 133 q 457 101 409 110 l 672 868 m 486 897 q 269 765 342 880 q 205 505 205 664 q 290 200 205 310 l 486 897 "},"ä":{"x_min":50,"x_max":714,"ha":773,"o":"m 562 89 q 431 7 494 31 q 296 -16 368 -16 q 113 42 177 -16 q 50 190 50 100 q 74 287 50 243 q 137 357 98 331 q 225 397 176 383 q 334 415 261 407 q 552 458 482 433 q 553 489 553 483 q 518 594 553 564 q 378 636 471 636 q 250 605 292 636 q 190 499 209 575 l 71 515 q 124 638 87 591 q 232 711 161 686 q 396 737 303 737 q 546 715 488 737 q 630 660 603 693 q 668 577 658 627 q 675 464 675 546 l 675 302 q 682 86 675 132 q 714 0 690 41 l 586 0 q 562 89 567 38 m 552 362 q 352 315 485 334 q 245 291 276 305 q 197 251 214 277 q 180 193 180 225 q 217 112 180 145 q 325 80 254 80 q 451 110 396 80 q 532 195 506 141 q 552 317 552 236 l 552 362 m 210 810 l 210 949 l 338 949 l 338 810 l 210 810 m 463 810 l 463 949 l 591 949 l 591 810 l 463 810 "},"¹":{"x_min":73,"x_max":323,"ha":463,"o":"m 225 497 l 225 872 q 73 796 155 817 l 73 879 q 166 928 115 892 q 250 1006 218 964 l 323 1006 l 323 497 l 225 497 "},"Ӧ":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 m 352 1055 l 352 1194 l 480 1194 l 480 1055 l 352 1055 m 605 1055 l 605 1194 l 733 1194 l 733 1055 l 605 1055 "},"W":{"x_min":17,"x_max":1296,"ha":1312,"o":"m 279 0 l 17 995 l 151 995 l 303 342 q 345 139 326 239 q 390 322 383 298 l 579 995 l 738 995 l 880 491 q 958 139 934 304 q 1008 355 977 233 l 1163 995 l 1296 995 l 1024 0 l 896 0 l 687 757 q 655 874 660 852 q 625 757 639 805 l 416 0 l 279 0 "},"‎":{"x_min":-24,"x_max":291,"ha":0,"o":"m 291 812 l 144 668 l 111 701 l 204 789 l 24 789 l 24 -187 l -24 -187 l -24 837 l 204 837 l 111 925 l 144 958 l 291 812 "},"ᵯ":{"x_min":-29,"x_max":1189,"ha":1157,"o":"m 1189 431 q 1090 281 1166 341 q 1068 264 1079 272 l 1068 0 l 946 0 l 946 221 q 920 220 931 220 q 642 262 831 220 l 642 0 l 520 0 l 520 290 q 230 335 319 335 q 214 335 220 335 l 214 0 l 92 0 l 92 269 q 61 217 70 246 l -29 217 q 92 382 -1 320 l 92 721 l 201 721 l 201 619 q 419 737 276 737 q 623 610 578 737 q 845 737 708 737 q 1068 494 1068 737 l 1068 376 q 1099 431 1089 401 l 1189 431 m 946 312 l 946 454 q 939 542 946 515 q 891 611 928 587 q 818 631 860 631 q 642 418 642 631 l 642 357 q 929 312 844 312 q 946 312 939 312 m 520 384 l 520 468 q 392 631 520 631 q 233 524 273 631 q 215 427 219 486 q 238 427 223 427 q 520 384 325 427 "},">":{"x_min":76,"x_max":734,"ha":811,"o":"m 734 435 l 76 154 l 76 276 l 597 491 l 76 705 l 76 827 l 734 549 l 734 435 "},"ө":{"x_min":47,"x_max":721,"ha":773,"o":"m 721 370 q 558 28 721 118 q 384 -16 479 -16 q 130 91 220 -16 q 47 360 47 192 q 158 656 47 560 q 384 737 250 737 q 634 631 543 737 q 721 370 721 532 m 593 429 q 536 567 581 516 q 384 636 475 636 q 231 567 292 636 q 175 429 186 516 l 593 429 m 596 329 l 172 329 q 227 158 177 224 q 384 84 284 84 q 540 159 484 84 q 596 329 589 224 "},"ѐ":{"x_min":51,"x_max":715,"ha":773,"o":"m 584 233 l 710 217 q 600 45 681 106 q 394 -16 519 -16 q 143 81 236 -16 q 51 354 51 178 q 144 636 51 536 q 387 737 238 737 q 623 638 531 737 q 715 361 715 540 q 714 329 715 350 l 176 329 q 243 147 182 210 q 394 84 303 84 q 509 119 461 84 q 584 233 556 155 m 183 429 l 586 429 q 539 566 577 520 q 388 637 481 637 q 246 580 303 637 q 183 429 189 523 m 465 810 l 367 810 l 210 1000 l 373 1000 l 465 810 "},"˪":{"x_min":66,"x_max":397,"ha":463,"o":"m 397 0 l 66 0 l 66 597 l 130 597 l 130 64 l 397 64 l 397 0 "},"҈":{"x_min":-666,"x_max":666,"ha":0,"o":"m 585 658 l 523 658 q 441 759 523 759 q 360 658 360 759 l 298 658 q 441 823 298 823 q 585 658 585 823 m 666 315 l 604 315 q 522 416 604 416 q 441 315 441 416 l 379 315 q 522 480 379 480 q 666 315 666 480 m 137 824 l 75 824 q -6 925 75 925 q -88 824 -88 925 l -150 824 q -6 989 -150 989 q 137 824 137 989 m 585 -62 l 523 -62 q 441 39 523 39 q 360 -62 360 39 l 298 -62 q 441 103 298 103 q 585 -62 585 103 m -298 658 l -360 658 q -441 759 -360 759 q -523 658 -523 759 l -585 658 q -441 823 -585 823 q -298 658 -298 823 m -379 315 l -441 315 q -522 416 -441 416 q -604 315 -604 416 l -666 315 q -522 480 -666 480 q -379 315 -379 480 m 137 -228 l 75 -228 q -6 -127 75 -127 q -88 -228 -88 -127 l -150 -228 q -6 -63 -150 -63 q 137 -228 137 -63 m -298 -62 l -360 -62 q -441 39 -360 39 q -523 -62 -523 39 l -585 -62 q -441 103 -585 103 q -298 -62 -298 103 "},"‛":{"x_min":94,"x_max":236,"ha":309,"o":"m 225 862 l 161 862 q 236 726 162 756 l 205 678 q 118 754 142 706 q 94 891 94 802 l 94 1004 l 225 1004 l 225 862 "},"Ð":{"x_min":-2,"x_max":928,"ha":1003,"o":"m 107 0 l 107 453 l -2 453 l -2 543 l 107 543 l 107 995 l 449 995 q 625 980 564 995 q 771 909 711 961 q 889 739 850 842 q 928 502 928 635 q 879 241 928 350 q 764 82 831 131 q 610 11 697 32 q 465 0 562 0 l 107 0 m 239 117 l 450 117 q 604 135 549 117 q 692 186 660 153 q 765 312 739 233 q 792 504 792 390 q 765 691 792 621 q 698 803 739 761 q 604 861 656 845 q 447 878 553 878 l 239 878 l 239 543 l 513 543 l 513 453 l 239 453 l 239 117 "},"Ҥ":{"x_min":111,"x_max":1193,"ha":1221,"o":"m 1193 878 l 891 878 l 891 0 l 759 0 l 759 469 l 243 469 l 243 0 l 111 0 l 111 995 l 243 995 l 243 586 l 759 586 l 759 995 l 1193 995 l 1193 878 "},"Х":{"x_min":6.109375,"x_max":918.109375,"ha":927,"o":"m 6 0 l 390 516 l 52 995 l 209 995 l 390 740 q 469 618 446 661 q 547 730 503 670 l 747 995 l 891 995 l 545 522 l 918 0 l 756 0 l 504 354 q 463 416 483 385 q 416 344 430 364 l 164 0 l 6 0 "},"r":{"x_min":90,"x_max":482,"ha":463,"o":"m 90 0 l 90 721 l 200 721 l 200 611 q 277 712 242 688 q 356 737 313 737 q 482 697 418 737 l 439 584 q 349 611 394 611 q 277 586 309 611 q 232 520 246 562 q 212 377 212 454 l 212 0 l 90 0 "},"ж":{"x_min":-3,"x_max":934,"ha":929,"o":"m 528 721 l 528 409 q 609 431 586 409 q 678 562 633 453 q 755 693 721 664 q 861 721 788 721 l 906 721 l 906 620 l 872 621 q 810 606 824 621 q 767 517 796 591 q 717 419 740 446 q 645 369 693 392 q 799 223 724 348 l 934 0 l 799 0 l 668 222 q 598 311 628 290 q 528 333 569 333 l 528 0 l 403 0 l 403 333 q 332 312 362 333 q 262 223 302 291 l 131 0 l -3 0 l 130 223 q 286 369 206 348 q 210 424 231 394 q 145 565 188 454 q 113 611 130 603 q 60 620 95 620 q 25 620 52 620 l 25 721 l 41 721 q 141 712 112 721 q 193 676 170 704 q 252 561 215 649 q 320 432 297 455 q 403 409 343 409 l 403 721 l 528 721 "},"Ѳ":{"x_min":65,"x_max":1016,"ha":1080,"o":"m 1016 495 q 891 131 1016 273 q 540 -17 759 -17 q 286 52 400 -17 q 115 250 168 124 q 65 484 65 369 q 185 858 65 715 q 541 1012 313 1012 q 892 862 762 1012 q 1016 495 1016 720 m 878 555 q 785 793 865 704 q 542 899 690 899 q 298 799 396 899 q 204 555 218 717 q 387 603 290 603 q 553 555 442 603 q 731 508 665 508 q 878 555 814 508 m 878 438 q 731 392 816 392 q 553 439 665 392 q 387 487 442 487 q 202 439 288 487 q 292 204 212 298 q 540 96 385 96 q 779 194 687 96 q 878 438 865 287 "},"ӝ":{"x_min":-3,"x_max":934,"ha":929,"o":"m 528 721 l 528 409 q 609 431 586 409 q 678 562 633 453 q 755 693 721 664 q 861 721 788 721 l 906 721 l 906 620 l 872 621 q 810 606 824 621 q 767 517 796 591 q 717 419 740 446 q 645 369 693 392 q 799 223 724 348 l 934 0 l 799 0 l 668 222 q 598 311 628 290 q 528 333 569 333 l 528 0 l 403 0 l 403 333 q 332 312 362 333 q 262 223 302 291 l 131 0 l -3 0 l 130 223 q 286 369 206 348 q 210 424 231 394 q 145 565 188 454 q 113 611 130 603 q 60 620 95 620 q 25 620 52 620 l 25 721 l 41 721 q 141 712 112 721 q 193 676 170 704 q 252 561 215 649 q 320 432 297 455 q 403 409 343 409 l 403 721 l 528 721 m 275 810 l 275 949 l 403 949 l 403 810 l 275 810 m 528 810 l 528 949 l 656 949 l 656 810 l 528 810 "},"Ø":{"x_min":56,"x_max":1028.09375,"ha":1080,"o":"m 847 903 l 961 1030 l 1028 973 l 908 840 q 987 688 966 753 q 1014 496 1014 602 q 952 224 1014 344 q 779 44 890 105 q 542 -17 667 -17 q 373 9 449 -17 q 237 87 315 29 l 123 -40 l 56 16 l 175 150 q 86 323 108 251 q 64 495 64 395 q 125 768 64 648 q 296 950 186 888 q 541 1012 406 1012 q 700 987 632 1012 q 847 903 768 963 m 765 811 q 653 880 701 862 q 541 899 605 899 q 296 798 393 899 q 200 497 200 697 q 214 357 200 418 q 260 245 225 312 l 765 811 m 821 741 l 317 178 q 413 118 369 135 q 538 96 471 96 q 781 200 685 96 q 878 493 878 304 q 821 741 878 634 "},"÷":{"x_min":53,"x_max":709,"ha":762,"o":"m 311 625 l 311 764 l 450 764 l 450 625 l 311 625 m 709 434 l 53 434 l 53 548 l 709 548 l 709 434 m 311 218 l 311 357 l 450 357 l 450 218 l 311 218 "},"с":{"x_min":54,"x_max":682,"ha":695,"o":"m 562 264 l 682 248 q 581 54 662 124 q 381 -16 500 -16 q 143 80 233 -16 q 54 357 54 177 q 92 561 54 474 q 210 693 131 649 q 382 737 289 737 q 574 677 499 737 q 670 509 648 618 l 551 491 q 490 600 534 563 q 386 637 447 637 q 236 570 294 637 q 179 361 179 504 q 234 149 179 215 q 380 84 290 84 q 500 128 452 84 q 562 264 549 172 "},"h":{"x_min":92,"x_max":679,"ha":773,"o":"m 92 0 l 92 995 l 214 995 l 214 638 q 429 737 299 737 q 569 705 509 737 q 653 618 628 673 q 679 456 679 562 l 679 0 l 557 0 l 557 456 q 517 590 557 548 q 404 632 477 632 q 302 603 350 632 q 234 527 254 575 q 214 394 214 479 l 214 0 l 92 0 "},"Ҳ":{"x_min":7,"x_max":918,"ha":926,"o":"m 918 -276 l 801 -276 l 801 0 l 754 0 l 507 345 q 464 410 490 369 q 416 337 428 353 l 164 0 l 7 0 l 390 515 l 52 995 l 209 995 l 391 744 q 472 624 449 665 q 550 736 502 673 l 747 995 l 891 995 l 545 521 l 833 117 l 918 117 l 918 -276 "},"ᴋ":{"x_min":92,"x_max":690,"ha":695,"o":"m 690 0 l 539 0 l 299 368 l 214 285 l 214 0 l 92 0 l 92 721 l 214 721 l 214 428 l 503 721 l 662 721 l 386 453 l 690 0 "},"f":{"x_min":12.71875,"x_max":433.65625,"ha":386,"o":"m 120 0 l 120 626 l 12 626 l 12 721 l 120 721 l 120 797 q 133 905 120 870 q 195 982 151 952 q 319 1012 239 1012 q 433 999 371 1012 l 415 893 q 343 900 377 900 q 264 876 287 900 q 241 787 241 852 l 241 721 l 382 721 l 382 626 l 242 626 l 242 0 l 120 0 "},"“":{"x_min":56,"x_max":408,"ha":463,"o":"m 187 828 l 187 686 l 56 686 l 56 798 q 77 929 56 889 q 168 1012 106 984 l 198 964 q 142 918 160 948 q 123 828 125 887 l 187 828 m 397 828 l 397 686 l 266 686 l 266 798 q 287 929 266 889 q 378 1012 316 984 l 408 964 q 352 918 370 948 q 333 828 335 887 l 397 828 "},"ԉ":{"x_min":16,"x_max":1173,"ha":1264,"o":"m 1173 298 q 1101 70 1173 152 q 881 -16 1025 -16 q 728 20 797 -16 q 621 133 653 60 q 596 292 596 192 l 596 621 l 273 621 l 273 261 q 271 134 273 146 q 220 24 262 60 q 114 -5 183 -5 q 16 0 71 -5 l 16 102 l 69 102 q 145 134 135 102 q 151 245 151 151 l 151 721 l 718 721 l 718 293 q 755 149 718 204 q 883 84 798 84 q 975 112 932 84 q 1035 187 1017 140 q 1051 303 1051 227 l 1051 421 l 1173 421 l 1173 298 "},"ʷ":{"x_min":0,"x_max":668,"ha":668,"o":"m 668 808 l 516 321 l 429 321 l 333 695 l 235 321 l 149 321 l 0 808 l 85 808 l 191 422 l 294 808 l 379 808 l 476 432 l 587 808 l 668 808 "},"A":{"x_min":-1.65625,"x_max":927.828125,"ha":926,"o":"m -1 0 l 378 995 l 522 995 l 927 0 l 778 0 l 663 301 l 246 301 l 138 0 l -1 0 m 283 408 l 622 408 l 518 683 q 447 891 471 809 q 393 699 427 794 l 283 408 "},"O":{"x_min":67,"x_max":1018,"ha":1080,"o":"m 67 484 q 199 871 67 731 q 543 1012 332 1012 q 791 946 680 1012 q 960 762 902 880 q 1018 495 1018 645 q 956 225 1018 344 q 783 44 895 105 q 542 -17 672 -17 q 291 50 402 -17 q 123 236 180 118 q 67 484 67 353 m 203 482 q 299 199 203 302 q 541 96 396 96 q 786 200 690 96 q 882 496 882 304 q 841 708 882 618 q 721 849 800 799 q 543 899 642 899 q 303 803 404 899 q 203 482 203 707 "},"3":{"x_min":58,"x_max":710,"ha":773,"o":"m 58 263 l 180 279 q 251 129 201 175 q 374 84 301 84 q 520 143 461 84 q 580 291 580 203 q 524 430 580 375 q 385 484 469 484 q 298 471 350 484 l 312 578 q 332 576 324 576 q 473 617 410 576 q 536 743 536 658 q 490 854 536 810 q 372 899 444 899 q 253 854 300 899 q 192 719 205 809 l 70 741 q 171 931 92 863 q 369 999 251 999 q 519 964 451 999 q 624 868 588 929 q 661 740 661 808 q 626 622 661 675 q 524 538 591 569 q 661 454 612 518 q 710 294 710 390 q 614 73 710 163 q 374 -17 519 -17 q 156 60 243 -17 q 58 263 70 138 "},"˺":{"x_min":115,"x_max":352,"ha":463,"o":"m 352 770 l 282 770 l 282 925 l 115 925 l 115 995 l 352 995 l 352 770 "},"ҟ":{"x_min":0.328125,"x_max":619,"ha":608,"o":"m 619 0 l 484 0 l 353 223 q 297 299 321 278 q 213 333 262 333 l 213 0 l 91 0 l 91 826 l 1 826 l 0 907 l 91 907 l 91 995 l 213 995 l 213 907 l 446 907 l 446 826 l 213 826 l 213 409 q 313 453 280 409 q 363 561 324 467 q 404 648 391 627 q 473 711 434 698 q 567 721 503 721 l 592 721 l 592 620 l 558 620 q 486 594 507 621 q 452 517 479 585 q 408 428 427 453 q 330 369 382 394 q 485 223 409 348 l 619 0 "},"˟":{"x_min":-3,"x_max":466,"ha":463,"o":"m 466 591 l 400 526 l 231 696 l 62 526 l -3 591 l 167 760 l -3 929 l 62 995 l 231 824 l 400 995 l 466 929 l 295 760 l 466 591 "},"Ԇ":{"x_min":69,"x_max":873,"ha":920,"o":"m 873 -276 l 756 -276 l 756 0 l 650 0 l 650 280 q 570 418 650 371 q 406 458 504 458 l 343 458 l 343 573 q 464 579 429 573 q 567 637 529 592 q 604 735 604 680 q 546 855 604 810 q 417 897 493 897 q 292 862 346 897 q 215 759 236 825 q 195 667 195 698 l 69 695 q 418 1012 115 1012 q 636 942 547 1012 q 735 741 735 866 q 603 525 735 602 q 733 436 684 503 q 782 284 782 369 l 782 117 l 873 117 l 873 -276 "},"4":{"x_min":18,"x_max":706,"ha":773,"o":"m 450 0 l 450 238 l 18 238 l 18 350 l 472 994 l 572 994 l 572 350 l 706 350 l 706 238 l 572 238 l 572 0 l 450 0 m 450 350 l 450 797 l 138 350 l 450 350 "},"ԁ":{"x_min":47,"x_max":672,"ha":773,"o":"m 559 0 l 559 90 q 357 -16 490 -16 q 198 31 271 -16 q 86 164 126 78 q 47 359 47 249 q 82 555 47 467 q 190 690 118 643 q 351 737 262 737 q 467 709 416 737 q 550 638 518 682 l 550 995 l 672 995 l 672 0 l 559 0 m 172 359 q 230 152 172 221 q 368 84 288 84 q 504 149 448 84 q 561 349 561 215 q 503 566 561 497 q 363 636 446 636 q 226 569 281 636 q 172 359 172 502 "},"Ѻ":{"x_min":22,"x_max":1134,"ha":1157,"o":"m 1134 497 q 1017 153 1134 290 q 690 -9 897 12 q 576 -82 657 -82 q 465 -9 497 -82 q 138 153 258 12 q 22 497 22 290 q 138 840 22 703 q 465 1003 258 981 q 576 1076 497 1076 q 690 1003 657 1076 q 1017 840 897 981 q 1134 497 1134 703 m 998 497 q 907 774 998 666 q 683 888 820 875 q 576 828 648 828 q 471 888 506 828 q 249 774 335 875 q 158 497 158 666 q 249 219 158 327 q 471 106 335 118 q 576 166 506 166 q 683 106 648 166 q 907 219 820 118 q 998 497 998 327 "},"ᵔ":{"x_min":34,"x_max":490,"ha":524,"o":"m 490 565 l 405 565 q 373 691 405 641 q 262 750 335 750 q 150 691 188 750 q 119 565 119 642 l 34 565 q 90 746 34 678 q 262 819 151 819 q 433 745 372 819 q 490 565 490 677 "},"ᴵ":{"x_min":71,"x_max":161,"ha":232,"o":"m 161 321 l 71 321 l 71 995 l 161 995 l 161 321 "}},"cssFontWeight":"normal","ascender":1258,"underlinePosition":-217,"cssFontStyle":"normal","boundingBox":{"yMin":-451,"xMin":-666,"yMax":1360,"xMax":1784},"resolution":1000,"original_font_information":{"postscript_name":"ArialMT","version_string":"Version 5.06","vendor_url":"","full_font_name":"Arial","font_family_name":"Arial","copyright":"© 2010 The Monotype Corporation. All Rights Reserved.","description":"","trademark":"Arial is a trademark of The Monotype Corporation.","designer":"Monotype Type Drawing Office - Robin Nicholas, Patricia Saunders 1982","designer_url":"","unique_font_identifier":"Monotype:Arial Regular:Version 5.06 (Microsoft)","license_url":"","license_description":"You may use this font to display and print content as permitted by the license terms for the product in which this font is included. You may only (i) embed this font in content as permitted by the embedding restrictions included in this font; and (ii) temporarily download this font to a printer or other output device to help print content.","manufacturer_name":"The Monotype Corporation","font_sub_family_name":"Regular"},"descender":-295,"familyName":"Arial","lineHeight":1597,"underlineThickness":150});
						]]>
						<![CDATA[var originX=0,originY=0,mousePrevX=0,mousePrevY=0,button="NONE",countContours=0,Coords=[];
function load(a){var b;b=document.getElementById(a);if(b.getContext){b.addEventListener&&b.addEventListener("DOMMouseScroll",wheel,false);b.onmousewheel=wheel;b.onmouseup=up;b.onmousedown=down;b.onmousemove=move;var c=document.createAttribute("dirzoom");c.nodeValue=0;b.attributes.setNamedItem(c);c=document.createAttribute("zoom");c.nodeValue=2;b.attributes.setNamedItem(c);c=document.createAttribute("widthcanvas");c.nodeValue=360;b.attributes.setNamedItem(c);c=document.createAttribute("heightcanvas");
c.nodeValue=240;b.attributes.setNamedItem(c);draw(b,0,0,a)}}
function draw(a,b,c,d){var e=a.attributes.getNamedItem("zoom"),f=a.attributes.getNamedItem("widthcanvas"),h=a.attributes.getNamedItem("heightcanvas"),g=parseInt(f.nodeValue),i=parseInt(h.nodeValue);if(b>0&&c!=0)g+=180,i+=120,e.nodeValue<10&&e.nodeValue++;else if(g>360&&i>240&&c!=0)g-=180,i-=120,e.nodeValue>10&&e.nodeValue--;else if(g<=360&&i<=240)e.nodeValue=2;f.nodeValue=g;h.nodeValue=i;a.attributes.setNamedItem(e);a.attributes.setNamedItem(f);a.attributes.setNamedItem(h);b=Coords.length-1;isNaN(parseInt(d.substring(6,
a.length)))||(b=parseInt(d.substring(6,a.length)));countContours=0;d=="canvas"?drawAll(a,g,i):drawPolygon(a,b,g,i)}
function drawAll(a,b,c){a=a.getContext("2d");a.clearRect(-100,-100,b+360,c+240);a.strokeStyle="Black";b=(maxY-minY)/b;c=(maxX-minX)/c;c=b<c?c:b;for(b=Coords.length-1;b>=0;b--){if("S"!=Coords[b][0][0].charAt(0)){var d=[];a.save();a.beginPath();for(var e=0;e<Coords[b].length;e++){x1=(maxX-Coords[b][e][1])/c+0;y1=(Coords[b][e][2]-minY)/c+0;a.moveTo(y1,x1);for(var f=1;f<Coords[b][e].length/2;f++)x2=(maxX-Coords[b][e][f*2-1])/c+0,y2=(Coords[b][e][f*2]-minY)/c+0,a.lineTo(y2,x2),d[f-1]=new Point(y2,x2);a.lineTo(y1,x1);a.closePath()}a.stroke();
a.restore();countContours++;d=(new Contour(d)).centroid();a.fillStyle="Gray";a.fillText(Coords[b][0][0].substring(1),d.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,d.y);}}}
function drawPolygon(a,b,c,d){a=a.getContext("2d");a.clearRect(-100,-100,c+360,d+240);a.strokeStyle="Black";var e=eval("minX"+b),f=eval("minY"+b),h=eval("maxX"+b),c=(eval("maxY"+b)-f)/c,d=(h-e)/d,d=c<d?d:c,c=[];a.save();a.beginPath();for(e=0;e<Coords[b].length;e++){x1=(h-Coords[b][e][1])/d+0;y1=(Coords[b][e][2]-f)/d+0;a.moveTo(y1,x1);for(var g=1;g<Coords[b][e].length/2;g++)x2=(h-Coords[b][e][g*2-1])/d+0,y2=(Coords[b][e][g*2]-f)/d+0,a.lineTo(y2,x2),c[g-1]=new Point(y2,x2);a.lineTo(y1,x1);a.closePath()}a.stroke();
a.restore();countContours++;f=(new Contour(c)).centroid();a.fillStyle="Gray";a.fillText(Coords[b][0][0].substring(1),f.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,f.y);}
function Point(a,b){this.x=a;this.y=b}function Contour(a){this.pts=a||[]}Contour.prototype.area=function(){for(var a=0,b=this.pts,c=b.length,d=c-1,e,f=0;f<c;d=f++)e=b[f],d=b[d],a+=e.x*d.y,a-=e.y*d.x;a/=2;return a};Contour.prototype.centroid=function(){var a=this.pts,b=a.length,c=0,d=0,e;e=b-1;for(var f,h,g=0;g<b;e=g++)f=a[g],h=a[e],e=f.x*h.y-h.x*f.y,c+=(f.x+h.x)*e,d+=(f.y+h.y)*e;e=this.area()*6;return new Point(c/e,d/e)};
function wheel(a){var b=0;if(!a)a=window.event;a.wheelDelta?(b=a.wheelDelta/120,window.opera&&(b=-b)):a.detail&&(b=-a.detail/3);draw(this,b,1,this.id);this.attributes.getNamedItem("dirzoom").nodeValue=b;a.preventDefault&&a.preventDefault();a.returnValue=false}
function move(a){if(!a)a=window.event;if(a!=void 0){if(button=="LEFT"){var b=a.clientX-this.offsetLeft,c=a.clientY-this.offsetTop,d=this.attributes.getNamedItem("zoom");context=this.getContext("2d");mousePrevX>b&&context.translate(originX-d.nodeValue,originY);mousePrevX<b&&context.translate(originX+d.nodeValue,originY);mousePrevY>c&&context.translate(originX,originY-d.nodeValue);mousePrevY<c&&context.translate(originX,originY+d.nodeValue);mousePrevX=b;mousePrevY=c;draw(this,this.attributes.getNamedItem("dirzoom").nodeValue,
0,this.id)}a.preventDefault&&a.preventDefault();a.returnValue=false}}function up(){button="NONE"}function down(a){if(!a)a=window.event;a!=void 0&&(button=a.which==null?a.button<2?"LEF­T":a.button==4?"MIDDLE":"RIGHT":a.which<2?"LEFT":a.which==2?"MIDDLE":"RIGHT")};
						]]>
						<xsl:apply-templates select="descendant::kv:EntitySpatial">
							<xsl:with-param name="count" select="count(descendant::kv:EntitySpatial)"/>
						</xsl:apply-templates>
					</script>
					<script type="text/javascript">
						<xsl:variable name="minX">
							<xsl:for-each select="descendant::spa:Ordinate/@X">
								<xsl:sort data-type="number" order="ascending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="minY">
							<xsl:for-each select="descendant::spa:Ordinate/@Y">
								<xsl:sort data-type="number" order="ascending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="maxX">
							<xsl:for-each select="descendant::spa:Ordinate/@X">
								<xsl:sort data-type="number" order="descending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="maxY">
							<xsl:for-each select="descendant::spa:Ordinate/@Y">
								<xsl:sort data-type="number" order="descending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:text>var minX = </xsl:text>
						<xsl:value-of select="$minX"/>
						<xsl:text>;</xsl:text>
						<xsl:text>var minY = </xsl:text>
						<xsl:value-of select="$minY"/>
						<xsl:text>;</xsl:text>
						<xsl:text>var maxX = </xsl:text>
						<xsl:value-of select="$maxX"/>
						<xsl:text>;</xsl:text>
						<xsl:text>var maxY = </xsl:text>
						<xsl:value-of select="$maxY"/>
						<xsl:text>;</xsl:text>
					</script>
				</xsl:if>
			</head>
			<xsl:element name="body">
				<xsl:attribute name="onload">
					try { load('canvas'); } catch(e) { }
					<xsl:call-template name="BodyFunctionCycle">
						<xsl:with-param name="total" select="count(descendant::kv:EntitySpatial[parent::kv:SubParcel] | descendant::kv:EntitySpatial[parent::kv:Contour] | descendant::kv:EntitySpatial[parent::kv:EntryParcel] | descendant::kv:EntitySpatial[parent::kv:Parcel])"/>
						<xsl:with-param name="cur_index" select="0"/>
					</xsl:call-template>
				</xsl:attribute>
				<table border="0" cellspacing="0" cellpadding="0" width="900px" height="700px" align="center">
					<tr>
						<td valign="top">
              <xsl:choose>
                <xsl:when test="kv:Parcels">
                  <xsl:apply-templates select="$parcel"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="OBJ_FROM_EGRP"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
					</tr>
				</table>
			</xsl:element>
			<script type="text/javascript">
			/*
			var part_names = ["1", "2", "3", "3.1", "3.2", "4", "4.1", "4.2", "5", "6", "7", "8", "9", "10"];
			for (var i = 0; i &lt; part_names.length; ++i) {
				var part_name = part_names[i];
				var total_part_lists = document.getElementsByName("total_part_" + part_name);
				var part_lists = document.getElementsByName("part_list_" + part_name);
				if (part_lists) {
						for (var s = 0; s &lt; total_part_lists.length; ++s)
							total_part_lists[s].innerHTML = "<u><b>&nbsp;" + total_part_lists.length + "&nbsp;</b></u>";
						for (var s = 0; s &lt; part_lists.length; ++s)
							part_lists[s].innerHTML = "<u><b>&nbsp;" + (s + 1) + "&nbsp;</b></u>";
				}
			}
			var all_sheets = document.getElementsByName("all_sheets");
			for (var i = 0; i &lt; all_sheets.length; ++i)
				all_sheets[i].innerHTML = "<u><b>&nbsp;" + all_sheets.length + "&nbsp;</b></u>";
			*/
			</script>
		</html>
	</xsl:template>	
	<xsl:template match="kv:Parcel">
		<xsl:variable name="countOwners">
			<xsl:if test="string($countRights)">
				<xsl:choose>
					<xsl:when test="$countRights &lt; 4 and count($rights/descendant::kv:Document) &lt; 2 and count($rights/descendant::kv:Owner) &lt; 6">
						<xsl:value-of select="0"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ceiling($countRights div ($countV1Rights))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line5">
			<xsl:if test="(count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not((count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line11">
			<xsl:if test="string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line9">
			<xsl:if test="string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line16">
			<xsl:if test="not(kv:Name='05') and not(kv:Name='02')">
				<xsl:value-of select="0"/>
			</xsl:if>
			<xsl:if test="kv:Name='02'">
				<xsl:value-of select="ceiling(count(kv:CompositionEZ/kv:EntryParcel) div $max_page_records)"/>
			</xsl:if>
			<xsl:if test="kv:Name='05'">
				<xsl:value-of select="ceiling(count(kv:Contours/kv:Contour) div $max_page_records)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line18">
			<xsl:if test="not(kv:NaturalObjects)">
				<xsl:value-of select="0"/>
			</xsl:if>
			<xsl:if test="kv:NaturalObjects">
				<xsl:value-of select="ceiling(count(kv:NaturalObjects/nat:NaturalObject) div $max_page_records)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list1">
			<xsl:value-of select="1+$countOwners+$countV1Line18+$countV1Line16+$countV1Line11+$countV1Line9+$countV1Line5"/>
		</xsl:variable>
		<xsl:variable name="list2">
			<xsl:if test="count(descendant::kv:EntitySpatial) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count(descendant::kv:EntitySpatial) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list2c">
			<xsl:value-of select="count(descendant::kv:EntitySpatial[parent::kv:Contour]|descendant::kv:EntitySpatial[parent::kv:EntryParcel])"/>
		</xsl:variable>
		<xsl:variable name="list3">
			<!--<xsl:value-of select="ceiling((count(kv:SubParcels/kv:SubParcel)+count(kv:Encumbrances/kv:Encumbrance)) div ($countV3))"/>-->
			<xsl:value-of select="ceiling(count(kv:SubParcels/kv:SubParcel) div ($countV3))"/>
		</xsl:variable>
		<xsl:variable name="list4">
			<xsl:value-of select="count(descendant::kv:EntitySpatial[parent::kv:SubParcel])"/>
		</xsl:variable>
		<xsl:variable name="page_rec_list5">
			<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30]) &gt; 0">
				<xsl:value-of select="15"/>
			</xsl:if>
			<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30]) &gt; 0)">
				<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>25]) &gt; 0">
					<xsl:value-of select="16"/>
				</xsl:if>
				<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>25]) &gt; 0)">
					<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20]) &gt; 0">
						<xsl:value-of select="17"/>
					</xsl:if>
					<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20]) &gt; 0)">
						<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>15]) &gt; 0">
							<xsl:value-of select="18"/>
						</xsl:if>
						<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>15]) &gt; 0)">
							<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10]) &gt; 0">
								<xsl:value-of select="19"/>
							</xsl:if>
							<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10]) &gt; 0)">
								<xsl:value-of select="$max_page_records"/>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countNeighbours" select="count($ownerNeighbours)"/>
		<xsl:variable name="list5">
			<xsl:value-of select="ceiling(count($bordersUnique) div ($page_rec_list5))"/>
		</xsl:variable>
		<xsl:variable name="list5neighb">
			<xsl:value-of select="ceiling($countNeighbours div ($max_page_records))"/>
		</xsl:variable>
		<xsl:variable name="list6">
			<xsl:value-of select="ceiling(count($spatialElementUnique) div ($max_page_records))"/>
		</xsl:variable>
		<xsl:variable name="listAll">
			<xsl:value-of select="$list6+$list5neighb+$list5+$list4+$list3+$list2c+$list2+$list1"/>
		</xsl:variable>
		<xsl:variable name="subParcels" select="kv:SubParcels"/>
    <!-- переменные для определения последнего раздела -->
    <xsl:variable name="section_3_exists">
      <xsl:if test="$list2 &gt; 0">
        <xsl:value-of select="1"/>
      </xsl:if>
      <xsl:if test="not($list2 &gt; 0)">
        <xsl:value-of select="0"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="section_3_1_exists">
      <xsl:if test="$bordersUnique">
        <xsl:value-of select="1"/>
      </xsl:if>
      <xsl:if test="not($bordersUnique)">
        <xsl:value-of select="0"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="section_3_2_exists">
      <xsl:if test="$spatialElementUnique">
        <xsl:value-of select="1"/>
      </xsl:if>
      <xsl:if test="not($spatialElementUnique)">
        <xsl:value-of select="0"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="section_4_exists">
      <xsl:if test="$list4 &gt; 0">
        <xsl:value-of select="1"/>
      </xsl:if>
      <xsl:if test="not($list4 &gt; 0)">
        <xsl:value-of select="0"/>
      </xsl:if>
    </xsl:variable>
	<xsl:variable name="section_4_a_exists">
      <xsl:if test="($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1)">
        <xsl:value-of select="1"/>
      </xsl:if>
      <xsl:if test="not(($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1))">
        <xsl:value-of select="0"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="section_4_1_exists">
      <xsl:if test="$list3 &gt; 0">
        <xsl:value-of select="1"/>
      </xsl:if>
      <xsl:if test="not($list3 &gt; 0)">
        <xsl:value-of select="0"/>
      </xsl:if>
    </xsl:variable>
	<xsl:variable name="section_4_2_exists">
		<xsl:if test="kv:SubParcels/kv:SubParcel/descendant::spa:SpatialElement">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not(kv:SubParcels/kv:SubParcel)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
		<table class="tbl_container">
			<tr>
				<th>
          <!-- Заголовок -->
					<div>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<th style="border-bottom-style:solid;border-width:1px;text-align: center;">
									<b>
										<!--<xsl:value-of select="$certificationDoc/cert:Organization"/>-->
										<xsl:value-of select="$HeadContent/kv:DeptName"/>
									</b>
								</th>
							</tr>
							<tr>
								<th valign="top" style="text-align: center;">
									<font style="font-size:80%;">полное наименование органа регистрации прав</font>
								</th>
							</tr>
						</table>
					</div>
          <!-- Раздел 1 -->
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'1'"/>
					</xsl:call-template>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topKind"/>
							</th>
						</tr>				
						<tr>
							<th>
								<xsl:call-template name="Form1">
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="section_4_1_exists" select="$section_4_1_exists"/>
								</xsl:call-template>                                 
						  </th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		<!-- Раздел 2 -->
		<xsl:if test="$SExtract/kv:ExtractObject">
		  <tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'2'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
					<xsl:for-each select="$SExtract/kv:ExtractObject">
						<xsl:variable name="currentPosition">
						<xsl:value-of select="position()"/>
						</xsl:variable>
						<!--<xsl:if test="$currentPosition &gt; 1">
						<tr><th>
							<xsl:call-template name="OKSBottom"/>
						</th></tr>
						</xsl:if>-->
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="$currentPosition"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
									<xsl:with-param name="curRazd" select="'2'"/>
								</xsl:call-template>
							</th>
						</tr>
					<tr>
						<th>
						<xsl:call-template name="ExtractObjectTemplate">
							<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
							<xsl:with-param name="posNumber" select="$currentPosition"/>
							<xsl:with-param name="ExtractObject" select="self::node()"/>
						</xsl:call-template>
						</th>
					</tr>
					</xsl:for-each>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
      </xsl:if>
		<!-- Раздел 3 -->
		<xsl:if test="$list2 &gt; 0">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">					
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'3'"/>
								</xsl:call-template>
							</th>
						</tr>					
						<tr>
							<th>
								<xsl:call-template name="V2_Form">
									<xsl:with-param name="prev_pages_total" select="$list1"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="formKind" select="'2'"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 3 по частям -->
		<xsl:if test="count($parcel/kv:EntitySpatial | $parcel/kv:Contours/kv:Contour | $parcel/kv:CompositionEZ/kv:EntryParcel) &gt; 1">
			<xsl:variable name="start_with" select="count($parcel/kv:SubParcels/kv:SubParcel/kv:EntitySpatial)"/>
			<xsl:for-each select="$parcel/kv:EntitySpatial | $parcel/kv:Contours/descendant::kv:EntitySpatial | $parcel/kv:CompositionEZ/descendant::kv:EntitySpatial">
				<xsl:call-template name="V3_FormPart">
					<xsl:with-param name="index_cur" select="$start_with + position() - 1"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<!-- Раздел 3.1 -->
		<xsl:if test="$bordersUnique">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3.1'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">					
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'3.1'"/>
								</xsl:call-template>
							</th>
						</tr>					
						<tr>
							<th>
								<xsl:if test="$bordersUnique">
									<xsl:call-template name="Section_3_1">
										<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c+$list3+$list4"/>
										<xsl:with-param name="border_pages_total" select="$list5"/>
										<xsl:with-param name="cur_index" select="0"/>
										<xsl:with-param name="listAll" select="1"/>
										<xsl:with-param name="countNeighbours" select="$countNeighbours"/>
										<xsl:with-param name="page_rec_list5" select="$page_rec_list5"/>
										<xsl:with-param name="is_first" select="0"/>
									</xsl:call-template>
								</xsl:if>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 3.2 -->
		<xsl:if test="$spatialElementUnique">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3.2'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">						
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'3.2'"/>
								</xsl:call-template>
							</th>
						</tr>						
						<tr>
							<th>
								<xsl:call-template name="Section_3_2">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c+$list3+$list4+$list5+$list5neighb"/>
									<xsl:with-param name="point_pages_total" select="$list6"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 4
		23.03.2016 разделы 4, 4.1, 4.2 только для KVZU/Parcels/Parcel/SubParcels
		<xsl:if test="($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1)">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'4'"/>
								</xsl:call-template>
							</th>
						</tr>						
						<tr>
							<th>
								<xsl:call-template name="Section_4_a_Cycle">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2"/>
									<xsl:with-param name="contour_pages_total" select="$list2c"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="listAll" select="1"/>
									<xsl:with-param name="formKind" select="'2'"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>               
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>-->
	  <!-- Раздел 4 (продолжение) -->
		<xsl:if test="$list4 &gt; 0">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">					
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'4'"/>
								</xsl:call-template>
							</th>
						</tr>						
						<tr>
							<th>
								<xsl:call-template name="Section_4_Cycle">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c+$list3"/>
									<xsl:with-param name="part_pages_total" select="$list4"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="formKind" select="'4'"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 4.1 -->
		<xsl:if test="$list3 &gt; 0">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4.1'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">						
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'4.1'"/>
								</xsl:call-template>
							</th>
						</tr>						
						<tr>
							<th>
								<xsl:call-template name="Section_4_1_Cycle">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c"/>
									<xsl:with-param name="border_pages_total" select="$list3"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="cadnum" select="@CadastralNumber"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 4.2 -->
		<xsl:if test="($section_4_2_exists) &gt; 0">
			<tr>
				<th>
					<xsl:for-each select="kv:SubParcels/kv:SubParcel">
						<table class="tbl_container">						
							<tr>
								<th>
									<xsl:call-template name="newPageDiv"/>
									<xsl:call-template name="Title">
										<xsl:with-param name="pageNumber" select="'4.2'"/>
									</xsl:call-template>
									<br/>
									<xsl:call-template name="topSheets">
										<xsl:with-param name="curSheet" select="1"/>
										<xsl:with-param name="allSheets" select="$listAll"/>
										<xsl:with-param name="cadNum" select="@CadastralNumber"/>
										<xsl:with-param name="curRazd" select="'4.2'"/>
									</xsl:call-template>
								</th>
							</tr>						
						</table>
						<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									Сведения о характерных точках границы части (частей) земельного участка
								</td>
							</tr>
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									Учетный номер части: <xsl:value-of select="./@NumberRecord"/>
								</td>
							</tr>
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									<xsl:variable name="entSys" select="string(kv:EntitySpatial/@EntSys)"/>
									Система координат: <xsl:value-of select="$coordSystems/node()[string(@CsId)=$entSys]/@Name"/><br/>
									Зона №
								</td>
							</tr>
							<tr height="30px">
								<th width="5%" rowspan="2">Номер точки</th>
								<th colspan="2">Координаты, м</th>
								<th rowspan="2" width="25%">Описание закрепления<br/>на местности</th>
								<th rowspan="2" width="35%">Средняя квадратическая погрешность определения координат характерных точек границы части земельного участка, м</th>
							</tr>
							<tr>
								<th width="10%">X</th>
								<th width="10%">Y</th>
							</tr>
							<tr>
								<td style="text-align:center">1</td>
								<td style="text-align:center">2</td>
								<td style="text-align:center">3</td>
								<td style="text-align:center">4</td>
								<td style="text-align:center">5</td>
							</tr>
							<!--<xsl:for-each select="kv:EntitySpatial/spa:SpatialElement/spa:SpelementUnit">-->
              <xsl:for-each select="$SubParselspatialElementUnique[position() &lt; (count($SubParselspatialElementUnique)+1)]">  
								<xsl:sort data-type="number" order="ascending" select="@SuNmb"/>
								<xsl:if test="position()>1 and (position() mod $part_4_2_maxrows)=0">
									<!-- page break -->
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
									<xsl:call-template name="OKSBottomLast"/> <!-- Signature and Stamp on all pages -->
									<xsl:call-template name="newPage"/>
									<xsl:call-template name="Title">
										<xsl:with-param name="pageNumber" select="'4.2'"/>
									</xsl:call-template>
									<xsl:call-template name="topSheets">
										<xsl:with-param name="curSheet" select="__"/>
										<xsl:with-param name="allSheets" select="__"/>
										<xsl:with-param name="curRazd" select="4.2"/>
									</xsl:call-template>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'br/', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=5% rowspan=2 class=centr', '&gt;', 'Номер точки', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th colspan=2 class=centr', '&gt;', 'Координаты, м', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=25% class=centr rowspan=2', '&gt;', 'Описание закрепления', '&lt;', 'br/', '&gt;', 'на местности', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr rowspan=2', '&gt;', 'Средняя квадратическая погрешность определения координат характерных точек границы части земельного участка, м', '&lt;', '/th', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'X', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'Y', '&lt;', '/th', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '1', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '2', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '3', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '4', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '5', '&lt;', '/th', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
								</xsl:if>
								<tr>
                  <td style="text-align:center;"><xsl:value-of select="@SuNmb"/></td>
                  <td style="text-align:center;"><xsl:value-of select="spa:Ordinate/@X"/></td>
									<td style="text-align:center;"><xsl:value-of select="spa:Ordinate/@Y"/></td>
									<td style="text-align:center">
										<xsl:value-of select="spa:Ordinate/@GeopointZacrep"/>
										<xsl:if test="not(string(spa:Ordinate/@GeopointZacrep))">
											<xsl:call-template name="no_data"/>
										</xsl:if>
									</td>
									<td style="text-align:center">
										<xsl:value-of select="spa:Ordinate/@DeltaGeopoint"/>
										<xsl:if test="not(string(spa:Ordinate/@DeltaGeopoint))">
											<xsl:call-template name="no_data"/>
										</xsl:if>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<xsl:call-template name="OKSBottom"/>
					</xsl:for-each>
				</th>
			</tr>
		</xsl:if>
		</table>
	</xsl:template>

  <xsl:template name="OBJ_FROM_EGRP">
    <table class="tbl_container">
      <tr>
        <th>
          <!-- Заголовок -->
          <div>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <th style="border-bottom-style:solid;border-width:1px;text-align: center;">
                  <b>
                    <!--<xsl:value-of select="$certificationDoc/cert:Organization"/>-->
                    <xsl:value-of select="$HeadContent/kv:DeptName"/>
                  </b>
                </th>
              </tr>
              <tr>
                <th valign="top" style="text-align: center;">
                  <font style="font-size:80%;">полное наименование органа регистрации прав</font>
                </th>
              </tr>
            </table>
          </div>
          <!-- Раздел 1 -->
          <xsl:call-template name="Title">
            <xsl:with-param name="pageNumber" select="'1'"/>
          </xsl:call-template>
          <table class="tbl_container">
            <tr>
              <th>
                <xsl:call-template name="topKind"/>
              </th>
            </tr>
          </table>
          <xsl:call-template name="topSheets">
            <xsl:with-param name="curSheet" select="2"/>
            <xsl:with-param name="cadNum" select="kv:Object/CadastralNumber"/>
            <xsl:with-param name="curRazd" select="'1'"/>
          </xsl:call-template>
        </th>
      </tr>
    </table> 
    <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">      
      <tr valign="top">
        <td width="35%" style="text-align: left">
          <xsl:text>Номер кадастрового квартала:</xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>дата присвоения кадастрового номера: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Ранее присвоенный государственный учетный номер: </xsl:text>
        </td>
        <td width="35%" style="text-align:left">
          <xsl:choose>
            <xsl:when test="kv:Object/kv:ConditionalNumber">
              <xsl:apply-templates select="kv:Object/kv:ConditionalNumber"/>
            </xsl:when>
            <xsl:when test="kv:Object/kv:CadastralNumber">
              <xsl:apply-templates select="kv:Object/kv:CadastralNumber"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="no_data"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Адрес: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kv:Object/kv:Address/kv:Content"/>
          <xsl:if test="not(kv:Object/kv:Address/kv:Content)">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Площадь: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kv:Object/kv:Area/kv:AreaText"/>
          <xsl:if test="not(kv:Object/kv:Area/kv:AreaText)">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align: left">
          <xsl:text>Кадастровая стоимость:</xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Кадастровые номера расположенных в пределах земельного участка объектов недвижимости: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
		<tr valign="top">
			<td width="35%" style="text-align:left">
				<xsl:text>Кадастровые номера объектов недвижимости, из которых образован объект недвижимости: </xsl:text>
			</td>
			<td style="text-align:left">
				<xsl:for-each select="kv:PrevCadastralNumbers/kv:CadastralNumber">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not(kv:PrevCadastralNumbers/kv:CadastralNumber)">
					<xsl:call-template name="no_data"/>
				</xsl:if>
			</td>
		</tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Кадастровые номера оразованных объектов недвижимости: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Сведения о включении объекта недвижимости в состав предприятия как имущественного комплекса: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="$SExtract/kv:InfoPIK"/>
          <xsl:if test="not($SExtract/kv:InfoPIK)">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </td>
      </tr>
     <!-- <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Сведения о включении объекта недвижимости в состав единого недвижимого комплекса: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="$SExtract/kv:InfoENK"/>
          <xsl:if test="not($SExtract/kv:InfoENK)">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </td>
      </tr>-->
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Категория земель: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kv:Object/kv:GroundCategoryText"/>
          <xsl:if test="not(kv:Object/kv:GroundCategoryText)">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Виды разрешенного использования: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kv:Object/kv:Assignation_Code_Text"/>
          <xsl:if test="not(kv:Object/kv:Assignation_Code_Text)">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Сведения о кадастровом инженере: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Сведения о лесах, водных объектах и об иных природных объектах, расположенных в пределах земельного участка: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Сведения о том, что земельный участок полностью или частично расположен в границах зоны с особыми условиями использования территории или территории объекта культурного наследия: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о том, что земельный участок расположен в границах особой экономической зоны, территории опережающего социально-экономического развития, зоны территориального развития в Российской Федерации, игорной зоны:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о том, что земельный участок расположен в границах особо охраняемой природной территории, охотничьих угодий, лесничеств, лесопарков:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о результатах проведения государственного земельного надзора:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о расположении земельного участка в границах территории, в отношении которой утвержден проект межевания территории:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Условный номер замельного участка:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о принятии акта и (или) заключении договора, предусматривающих предоставление в соответствии с земельным законодательством исполнительным органом государственной власти или органом местного самоуправления находящегося в государственной или муниципальной собственности земельного участка для строительства наемного дома социального использования или наемного дома коммерческого использования:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о том, что земельный участок или земельные участки образованы на основании решения об изъятии земельного участка и (или) расположенного на нем объекта недвижимости для государственных или муниципальных нужд:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о том, что земельный участок образован из земель или земельного участка, государственная собственность на которые не разграничена:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr>
        <td width="35%" style="text-align:left">Сведения о наличии земельного спора о местоположении границ земельных участков:</td>
        <td width="35%" style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Статус записи об объекте недвижимости: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:call-template name="no_data"/>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Особые отметки: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:text>Сведения об объекте недвижимости сформированы по данным ранее внесенным в Единый Государственный реестр прав.</xsl:text>
          <br/>
          <xsl:text>Сведения необходимые для заполнения разделов 3-4 отсутствуют.</xsl:text>
        </td>
      </tr>
      <tr valign="top">
        <td style="text-align:left">
          <xsl:text>Получатель выписки: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:value-of select="$FootContent/kv:Recipient"/>
        </td>
      </tr>
    </table>
    <xsl:call-template name="OKSBottom"/>
      <!-- Раздел 2 -->
      <xsl:if test="$SExtract/kv:ExtractObject">
        <tr>
          <th>
            <xsl:call-template name="Title">
              <xsl:with-param name="pageNumber" select="'2'"/>
            </xsl:call-template>
            <br/>
            <table class="tbl_container">
              <xsl:for-each select="$SExtract/kv:ExtractObject">
                <xsl:variable name="currentPosition">
                  <xsl:value-of select="position()"/>
                </xsl:variable>
                <!--<xsl:if test="$currentPosition &gt; 1">
						<tr><th>
							<xsl:call-template name="OKSBottom"/>
						</th></tr>
						</xsl:if>-->
                <tr>
                  <th>
                    <xsl:call-template name="topSheets">
                      <xsl:with-param name="curSheet" select="$currentPosition"/>
                      <xsl:with-param name="allSheets" select="1"/>
                      <xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
                      <xsl:with-param name="curRazd" select="'2'"/>
                    </xsl:call-template>
                  </th>
                </tr>
                <tr>
                  <th>
                    <xsl:call-template name="ExtractObjectTemplate">
                      <xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
                      <xsl:with-param name="posNumber" select="$currentPosition"/>
                      <xsl:with-param name="ExtractObject" select="self::node()"/>
                    </xsl:call-template>
                  </th>
                </tr>
              </xsl:for-each>
            </table>
            <xsl:call-template name="OKSBottom"/>
          </th>
        </tr>
      </xsl:if> 
  </xsl:template>
  
	<xsl:template name="BodyFunctionCycle">
		<xsl:param name="total"/>
		<xsl:param name="cur_index"/>
		<xsl:if test="$cur_index &lt; $total">
			try { load('canvas<xsl:value-of select="$cur_index"/>'); } catch(e) { }
			<xsl:call-template name="BodyFunctionCycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="total" select="$total"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
  <xsl:template name="topSheets">
    <xsl:param name="curSheet"/>
    <xsl:param name="allSheets"/>
    <xsl:param name="SheetsinRazd"/>
    <xsl:param name="curRazd"/>
    <!--<xsl:param name="allRazd"/>-->
    <xsl:param name="ExtractDate"/>
    <xsl:param name="ExtractNumber"/>
	<xsl:variable name="list2">
		<xsl:if test="$SExtract/kv:ExtractObject">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($SExtract/kv:ExtractObject)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list3">
		<xsl:if test="count(descendant::kv:EntitySpatial) &gt; 0">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="count(descendant::kv:EntitySpatial) = 0">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list31">
		<xsl:if test="$bordersUnique">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($bordersUnique)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list32">
		<xsl:if test="$spatialElementUnique">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($spatialElementUnique)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list2c">
		<xsl:value-of select="count(descendant::kv:EntitySpatial[parent::kv:Contour]|descendant::kv:EntitySpatial[parent::kv:EntryParcel])"/>
	</xsl:variable>
	<xsl:variable name="list4">
		<xsl:if test="($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1)">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not(($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1))">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list41c">
		<xsl:value-of select="ceiling((count(kv:SubParcels/kv:SubParcel)+count(kv:Encumbrances/kv:Encumbrance)) div ($countV3))"/>
	</xsl:variable>
	<xsl:variable name="list41">
		<xsl:if test="$list41c &gt; 0">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($list41c &gt; 0)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="allRazd" select="1 + $list2 + $list3 + $list31 + $list32 + $list4 + $list41"/>
    <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
      <tr>
        <td colspan="4" style="text-align:left">
          <b>
            <xsl:text>Земельный участок</xsl:text>
          </b>
        </td>
      </tr>
      <tr>
        <th colspan="4" style="text-align:center" valign="top">
          <font style="FONT-SIZE: 60%;">(вид объекта недвижимости)</font>
        </th>
      </tr>     
      <tr>
        <td width="25%">
			<xsl:text>Лист № </xsl:text>
			<xsl:element name="span">
					<xsl:attribute name="name">part_list_<xsl:value-of select="$curRazd"/></xsl:attribute>
					<!--<u><b>&nbsp;<xsl:value-of select="$curSheet"/>&nbsp;</b></u>-->
					___
			</xsl:element>
			<xsl:text>Раздела  </xsl:text>
			<u><b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b></u>
		</td>
        <td width="25%">
          <xsl:text>Всего листов раздела </xsl:text>
			<u><b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b></u>
			<b>
				<xsl:text>: </xsl:text>
			</b>
				<xsl:element name="span">
					<xsl:attribute name="name">total_part_<xsl:value-of select="$curRazd"/></xsl:attribute>
					<!--<u><b>&nbsp;<xsl:value-of select="$SheetsinRazd"/>&nbsp;</b></u>-->
					___
			</xsl:element>
        </td>
		<td width="20%">
			<xsl:text>Всего разделов:  </xsl:text>
				<!--<xsl:if test="kv:KVOKS/kv:Object">
						--><!-- kv:KVOKS/kv:Object имеет только 2 раздела --><!--
						<u><b>&nbsp;2&nbsp;</b></u>
				</xsl:if>
				<xsl:if test="not(kv:KVOKS/kv:Object)">
					<u><b>&nbsp;<xsl:value-of select="$allRazd"/>&nbsp;</b></u>
				</xsl:if>-->
				___
		</td>
				<td width="30%">
					<xsl:text>Всего листов выписки: </xsl:text>
						<span name="all_sheets">
							  <!--<u>
								<b>
								  &nbsp;<xsl:value-of select="$allSheets"/>&nbsp;
								</b>
							  </u>-->
							  ___
						</span>
				</td>
      </tr>    
      <tr>
        <td colspan="4">
          <b>
            &nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractDate"/>&nbsp;
            <xsl:if test="$DeclarAttribute/@ExtractNumber!='0'">
              &nbsp;<xsl:text> № </xsl:text>&nbsp;
              &nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractNumber"/>&nbsp;
            </xsl:if>
          </b>
        </td>
      </tr>    
      <tr>
        <td colspan="2">
          <xsl:text>Кадастровый номер: </xsl:text>
        </td>
        <td colspan="2">
          <b>
            <xsl:value-of select="$parcel/@CadastralNumber"/>
            <xsl:if test="not($parcel/@CadastralNumber)">
              <xsl:call-template name="no_data"/>
            </xsl:if>
			<xsl:if test="/kv:KVZU/kv:Parcels/kv:Parcel/kv:CompositionEZ">&nbsp;(единое землепользование)</xsl:if>
          </b>
        </td>
      </tr>
    </table>
  </xsl:template>
	<xsl:template name="section_date">
		<!--
						&nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractDate"/>&nbsp;
						<xsl:if test="$DeclarAttribute/@ExtractNumber!='0'">
						  &nbsp;<xsl:text> № </xsl:text>&nbsp;
						  &nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractNumber"/>&nbsp;
						</xsl:if>
		-->
		<table class="tbl_section_date">
			<tr>
				<td>&laquo;</td>
				<td class="understroke">
					<xsl:if test="$day">
					<xsl:value-of select="$day"/>
					</xsl:if>
					<xsl:if test="not($day)">
					____
					</xsl:if>
				</td>
				<td>&raquo;</td>
				<td class="understroke">
					<xsl:variable name="var" select="document('dict/months.xml')"/>
					<xsl:value-of select="$var/row_list/row[CODE=$month]/NAME"/>
				</td>
				<td class="norpad">
					<xsl:value-of select="$year"/>
				</td>
				<td class="nolpad">&nbsp;г.&nbsp;&number;</td>
				<td class="understroke">
					<!--<xsl:value-of select="$certificationDoc/cert:Number"/>-->
					<xsl:if test="$DeclarAttribute/@ExtractNumber!='0'">
					<xsl:value-of select="$DeclarAttribute/@ExtractNumber"/>
					</xsl:if>
					<xsl:if test="not($DeclarAttribute/@ExtractNumber!='0')">
					_______________
					</xsl:if>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Title">
		<xsl:param name="pageNumber"/>
    <!--<xsl:if test="$pageNumber != '1'">
      <xsl:call-template name="newPage"/>
    </xsl:if>-->
		<div class="title1">
			<xsl:text>Раздел </xsl:text>
			<xsl:value-of select="$pageNumber"/>
		</div>
		<div class="title2">
			<xsl:text>Выписка из Единого государственного реестра недвижимости об объекте недвижимости</xsl:text>
      <br/>
			<xsl:choose>
				<xsl:when test="$pageNumber='1'"><b>Сведения о характеристиках объекта недвижимости</b></xsl:when>
				<xsl:when test="$pageNumber='2'"><b>Сведения о зарегистрированных правах</b></xsl:when>
				<xsl:when test="$pageNumber='3'"><b>Описание местоположения земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='3.1'"><b>Описание местоположения земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='3.2'"><b>Описание местоположения земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='4'"><b>Сведения о частях земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='4.1'"><b>Сведения о частях земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='4.2'"><b>Сведения о частях земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='5'"><b>Описание местоположения объекта недвижимости</b></xsl:when>
				<xsl:when test="$pageNumber='6'"><b>Сведения о частях объекта недвижимости</b></xsl:when>
				<xsl:when test="$pageNumber='7'"><b>Перечень помещений, машино-мест, расположенных в здании, сооружении</b></xsl:when>
				<xsl:when test="$pageNumber='8'"><b>План расположения помещения, машино-места на этаже (плане этажа)</b></xsl:when>
				<xsl:when test="$pageNumber='9'"><b>Сведения о части (частях) помещения</b></xsl:when>
				<xsl:when test="$pageNumber='10'"><b>Описание местоположения машино-места</b></xsl:when>
				<xsl:otherwise><b>КАДАСТРОВАЯ ВЫПИСКА</b></xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template name="HeadNumbers">
		<xsl:param name="pageNumber"/>
		<table class="tbl_section_topsheet">
			<!--<tr>
				<th colspan="2">
					<xsl:call-template name="section_date"/>
				</th>
			</tr>
			<tr>
				<th class="left" width="50%">
					<nobr>Кадастровый номер:</nobr>
				</th>
				<th class="left" width="50%">
					<xsl:value-of select="$cadNum"/>
				</th>
			</tr>-->
			<xsl:if test="$pageNumber=1">
				<tr>
					<th class="left" width="50%">
						<nobr>Номер кадастрового квартала:</nobr>
					</th>
					<th class="left" width="50%">
						<xsl:for-each select="kv:CadastralBlocks/kv:CadastralBlock">
							<xsl:value-of select="text()"/>
							<xsl:if test="position()!=last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</th>
				</tr>
				<!--<tr>
					<th class="left" width="50%">
						<xsl:text>Предыдущие номера ???:</xsl:text>
					</th>
					<th class="left" width="50%">
						<xsl:for-each select="kv:PrevCadastralNumbers/kv:CadastralNumber|kv:OldNumbers/num:OldNumber/@Number">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="not(kv:PrevCadastralNumbers/kv:CadastralNumber|kv:OldNumbers/num:OldNumber)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</th>
				</tr>-->
				<tr>
					<th class="left" width="50%">
						<xsl:text>Дата присвоения кадастрового номера:</xsl:text>
					</th>
					<th class="left" width="50%">
						<!--
						<xsl:apply-templates select="@DateCreated" mode="digitsXmlWithoutYear"/>
						<xsl:if test="not(@DateCreated)">
							<xsl:call-template name="procherk"/>
							<xsl:call-template name="no_data"/>
						</xsl:if>
						-->
					<xsl:if test="string(@DateCreatedDoc)">
						<xsl:apply-templates select="@DateCreatedDoc"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc))">
						<xsl:apply-templates select="@DateCreated"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc)) and not(string(@DateCreated))">
						<!--<xsl:call-template name="procherk"/>-->
						<xsl:call-template name="no_data"/>
					</xsl:if>
					</th>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template name="OKSBottom">
		<table class="tbl_container">
			<tr>
				<th>
					<br/>
					<xsl:call-template name="Worker"/>
				</th>
			</tr>
		</table>
		<div class="title2">М.П.</div>
	</xsl:template>
	<xsl:template name="OKSBottomLast">
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Worker"/>
				</th>
			</tr>
		</table>
		<div class="title2">М.П.</div>
	</xsl:template>
	<xsl:template name="procherk">
		<div class="procherk">_____</div>
	</xsl:template>
	<xsl:template name="no_data">
		<xsl:text>данные отсутствуют</xsl:text>
	</xsl:template>
	<xsl:template name="Worker">
		<table class="tbl_section_topsheet">
			<tr>
				<th width="40%" style="text-align: left;">
					<!--
					<xsl:value-of select="$certificationDoc/cert:Official/cert:Appointment"/>
					<xsl:if test="not($certificationDoc/cert:Official)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
					-->
					<xsl:value-of select="$Sender/@Appointment"/>
				</th>
				<th width="30%"/>
				<th width="30%" style="text-align: left;">
					<!--
					<xsl:if test="string($certificationDoc/cert:Official/tns:FirstName)">
						<xsl:call-template name="upperCase">
							<xsl:with-param name="text">
								<xsl:value-of select="substring($certificationDoc/cert:Official/tns:FirstName,1,1)"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>.</xsl:text>
					</xsl:if>
					<xsl:if test="string($certificationDoc/cert:Official/tns:Patronymic)">
						<xsl:call-template name="upperCase">
							<xsl:with-param name="text">
								<xsl:value-of select="substring($certificationDoc/cert:Official/tns:Patronymic,1,1)"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="string($certificationDoc/cert:Official/tns:FamilyName)">
						<xsl:call-template name="upperCase">
							<xsl:with-param name="text">
								<xsl:value-of select="substring($certificationDoc/cert:Official/tns:FamilyName,1,1)"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:value-of select="substring($certificationDoc/cert:Official/tns:FamilyName,2)"/>
					</xsl:if>
					<xsl:if test="not($certificationDoc/cert:Official)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
					-->
					<xsl:value-of select="$DeclarAttribute/@Registrator"/>
				</th>
			</tr>			
			<tr>
				<th style="text-align: center;">полное наименование должности</th>
				<th style="text-align: center;">подпись</th>
				<th style="text-align: center;">инициалы, фамилия</th>
			</tr>			
		</table>
	</xsl:template>
	<xsl:template name="upperCase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, $smallcase, $uppercase)"/>
	</xsl:template>	
	<xsl:template match="kv:EntitySpatial">
		<xsl:param name="count"/>
		<xsl:variable name="itemEntity" select="$count - count(following::kv:EntitySpatial) - 1"/>
		<xsl:text>&#xa;&#xd;</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>] = new Array();</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0] = new Array();</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0][0] = "</xsl:text>
		<xsl:if test="parent::kv:Parcel">
			<xsl:text>Z</xsl:text>
			<xsl:value-of select="ancestor::kv:Parcel/@CadastralNumber"/>
		</xsl:if>
		<xsl:if test="parent::kv:OffspringParcel">
			<xsl:text>Z</xsl:text>
			<xsl:value-of select="ancestor::kv:OffspringParcel/@CadastralNumber"/>
		</xsl:if>
		<xsl:if test="parent::kv:EntryParcel">
			<xsl:text>P</xsl:text>
			<xsl:value-of select="ancestor::kv:EntryParcel/@CadastralNumber"/>
		</xsl:if>
		<xsl:if test="parent::kv:SubParcel">
			<xsl:text>S</xsl:text>
			<xsl:value-of select="ancestor::kv:Parcel/@CadastralNumber"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="ancestor::kv:SubParcel/@NumberRecord"/>
		</xsl:if>
		<xsl:if test="parent::kv:Contour">
			<xsl:text>C</xsl:text>
			<xsl:value-of select="ancestor::kv:Parcel/@CadastralNumber"/>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="ancestor::kv:Contour/@NumberRecord"/>
			<xsl:text>)</xsl:text>
		</xsl:if>
		<xsl:text>";</xsl:text>
		<xsl:apply-templates select="descendant::spa:SpatialElement">
			<xsl:with-param name="itemEntity" select="$itemEntity"/>
			<xsl:with-param name="count" select="count(descendant::spa:SpatialElement)"/>
		</xsl:apply-templates>
		<xsl:variable name="minX">
			<xsl:for-each select="descendant::spa:Ordinate/@X">
				<xsl:sort data-type="number" order="ascending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="minY">
			<xsl:for-each select="descendant::spa:Ordinate/@Y">
				<xsl:sort data-type="number" order="ascending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxX">
			<xsl:for-each select="descendant::spa:Ordinate/@X">
				<xsl:sort data-type="number" order="descending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxY">
			<xsl:for-each select="descendant::spa:Ordinate/@Y">
				<xsl:sort data-type="number" order="descending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:text>var minX</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$minX"/>
		<xsl:text>;</xsl:text>
		<xsl:text>var minY</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$minY"/>
		<xsl:text>;</xsl:text>
		<xsl:text>var maxX</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$maxX"/>
		<xsl:text>;</xsl:text>
		<xsl:text>var maxY</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$maxY"/>
		<xsl:text>;</xsl:text>
	</xsl:template>
	<xsl:template match="spa:SpatialElement">
		<xsl:param name="count"/>
		<xsl:param name="itemEntity"/>
		<xsl:variable name="itemElement" select="$count - count(following-sibling::spa:SpatialElement) - 1"/>
		<xsl:if test="$itemElement > 0">
			<xsl:text>Coords[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>] = new Array();</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="descendant::spa:SpelementUnit">
			<xsl:with-param name="itemEntity" select="$itemEntity"/>
			<xsl:with-param name="itemElement" select="$itemElement"/>
			<xsl:with-param name="count" select="count(descendant::spa:SpelementUnit)"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="spa:SpelementUnit">
		<xsl:param name="count"/>
		<xsl:param name="itemEntity"/>
		<xsl:param name="itemElement"/>
		<xsl:variable name="itemUnit" select="$count - count(following-sibling::spa:SpelementUnit)"/>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="$itemElement"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="($itemUnit * 2) - 1"/>
		<xsl:text>] = </xsl:text>
		<xsl:value-of select="spa:Ordinate/@X"/>
		<xsl:text>;</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="$itemElement"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="($itemUnit * 2)"/>
		<xsl:text>] = </xsl:text>
		<xsl:value-of select="spa:Ordinate/@Y"/>
		<xsl:text>;</xsl:text>
	</xsl:template>
	<xsl:template name="newPage">
		<!--<div style="page-break-after:always"> </div>-->
		<p class="pagebreak"/>
	</xsl:template>
	<xsl:template name="newPageDiv">
		<div style="page-break-after:always"> </div>
	</xsl:template>
	<xsl:template name="Section_3_1">
		<!--В5-->
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="border_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="countNeighbours"/>
		<xsl:param name="page_rec_list5"/>
		<xsl:param name="is_first"/>
		<xsl:variable name="cur_position" select="$cur_index * $page_rec_list5"/>
		<xsl:if test="$cur_index &lt; $border_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3.1'"/>
					</xsl:call-template>
					<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'3.1'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="Borders_Form">
				<xsl:with-param name="position_cur" select="$cur_position"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="list5" select="$border_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="countNeighbours" select="$countNeighbours"/>
				<xsl:with-param name="page_rec_list5" select="$page_rec_list5"/>
			</xsl:call-template>
			<xsl:call-template name="Section_3_1">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="border_pages_total" select="$border_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="countNeighbours" select="$countNeighbours"/>
				<xsl:with-param name="page_rec_list5" select="$page_rec_list5"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Borders_Form">
		<xsl:param name="position_cur"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="list5"/>
		<xsl:param name="listAll"/>
		<xsl:param name="countNeighbours"/>
		<xsl:param name="page_rec_list5"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
						<tr>

							<td style="text-align:left;padding-left:5px" colspan="8">
								Описание местоположения границ земельного участка
							</td>
						</tr>
									<tr valign="top" height="40px">
										<th style="text-align:center" width="4%" rowspan="2">Номер п/п</th>
										<th style="text-align:center" width="12%" colspan="2">Номер точки</th>
										<!--<th style="text-align:center" width="4%">Номер точки</th>-->
										<th style="text-align:center" width="8%" rowspan="2">Дирекционный угол</th>
										<th style="text-align:center" width="8%" rowspan="2">Горизонтальное проложение, м</th>
										<th style="text-align:center" rowspan="2">Описание закрепления<br/>на местности</th>
										<th style="text-align:center" rowspan="2">Кадастровые номера<br/> смежных участков</th>
										<th style="text-align:center" rowspan="2">Сведения об адресах правообладателей<br/> смежных земельных участков</th>
									</tr>
									<tr valign="top" height="30px">
										<th style="text-align:center" width="6%">начальная</th>
										<th style="text-align:center" width="6%">конечная</th>
									</tr>
									<tr>
										<th style="text-align:center">1</th>
										<th style="text-align:center">2</th>
										<th style="text-align:center">3</th>
										<th style="text-align:center">4</th>
										<th style="text-align:center">5</th>
										<th style="text-align:center">6</th>
										<th style="text-align:center">7</th>
										<th style="text-align:center">8</th>
									</tr>
									<xsl:for-each select="$bordersUnique[position() &lt; (count($bordersUnique)+1)]">
										<xsl:sort data-type="number" order="ascending" select="@Point1"/>
										<xsl:if test="(position() &lt; $page_rec_list5+1+$position_cur) and (position() &gt; $position_cur)">
											<tr>
												<xsl:variable name="num_pp" select="position()"/>
												<xsl:variable name="num_pp1" select="@Spatial"/>
												<xsl:variable name="point1" select="@Point1"/>
												<xsl:variable name="point2" select="@Point2"/>
												<td style="text-align:center">
													<xsl:value-of select="$num_pp"/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="$point1"/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="$point2"/>
												</td>
												<td style="text-align:center">
													<xsl:if test="spa:Edge/spa:DirectionAngle">
														<xsl:value-of select="spa:Edge/spa:DirectionAngle/spa:Degree"/>
														<span style="VERTICAL-ALIGN: super; FONT-SIZE: 70%">o</span>
														<xsl:text> </xsl:text>
														<xsl:if test="string(spa:Edge/spa:DirectionAngle/spa:Minute)">
															<xsl:value-of select="spa:Edge/spa:DirectionAngle/spa:Minute"/>'
														</xsl:if>
													</xsl:if>
													<xsl:if test="not(spa:Edge/spa:DirectionAngle)">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<br/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="spa:Edge/spa:Length"/>
													<xsl:if test="not(string(spa:Edge/spa:Length))">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<br/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="spa:Edge/spa:Definition"/>
													<xsl:if test="not(string(spa:Edge/spa:Definition))">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<br/>
												</td>
												<td style="text-align:center">
													<xsl:variable name="fontSize">
														<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30">
															<xsl:value-of select="75"/>
														</xsl:if>
														<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30)">
															<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20">
																<xsl:value-of select="80"/>
															</xsl:if>
															<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20)">
																<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10">
																	<xsl:value-of select="85"/>
																</xsl:if>
																<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10)">
																	<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>5">
																		<xsl:value-of select="90"/>
																	</xsl:if>
																	<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>5)">
																		<xsl:value-of select="100"/>
																	</xsl:if>
																</xsl:if>
															</xsl:if>
														</xsl:if>
													</xsl:variable>
													<font style="FONT-SIZE: {$fontSize}%;">
														<xsl:for-each select="spa:Edge/spa:Neighbours/spa:CadastralNumber">
															<xsl:value-of select="."/>
															<xsl:if test="position()!=last()">, </xsl:if>
														</xsl:for-each>
														<xsl:if test="not(string(spa:Edge/spa:Neighbours/spa:CadastralNumber[1]))">
															<!--<xsl:call-template name="procherk"/>-->
															<xsl:call-template name="no_data"/>
														</xsl:if>
													</font>
													<br/>
												</td>
												<td>
													<xsl:if test="not(string(spa:Edge/spa:Neighbours/spa:CadastralNumber[1]))">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<xsl:if test="string(spa:Edge/spa:Neighbours/spa:CadastralNumber[1])">
														<xsl:variable name="neighbour" select="spa:Edge/spa:Neighbours/spa:CadastralNumber[1]"/>
														<xsl:if test="not($countNeighbours = 0)">
															<xsl:if test="$ownerNeighbours[@CadastralNumber=$neighbour]">
																<xsl:for-each select="$ownerNeighbours[@CadastralNumber=$neighbour]/kv:OwnerNeighbour">
																	<xsl:if test="position() &gt; 1"><xsl:text>; </xsl:text><br/></xsl:if>
																	<xsl:value-of select="kv:ContactAddress"/>
																	<xsl:if test="kv:Email">
																		<xsl:text>, </xsl:text>
																		<xsl:value-of select="kv:Email"/>
																	</xsl:if>
																</xsl:for-each>
																<!--<xsl:text>Адреса правообладателей прилагаются на дополнительном листе</xsl:text>-->
															</xsl:if>
															<xsl:if test="not($ownerNeighbours[@CadastralNumber=$neighbour])">
																<xsl:text>Адрес отсутствует</xsl:text>
															</xsl:if>
														</xsl:if>
														<xsl:if test="$countNeighbours = 0">
															<xsl:text>Адрес отсутствует</xsl:text>
														</xsl:if>
													</xsl:if>
												</td>
											</tr>
										</xsl:if>
									</xsl:for-each>
					</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="ExtractObjectTemplate">
		<xsl:param name="ExtractObject"/>
		<xsl:param name="cadNum"/>
		<xsl:param name="posNumber"/>
		<!--<xsl:call-template name="newPage"/>-->
		<!--<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="'2'"/>
		</xsl:call-template>-->
		<!--<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="1"/>
			<xsl:with-param name="allSheets" select="__"/>
			<xsl:with-param name="curRazd" select="2"/>
		</xsl:call-template>-->
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<xsl:call-template name="Rights">
				<xsl:with-param name="Rights" select="$ExtractObject/kv:ObjectRight"/>
				<xsl:with-param name="cadNum" select="$cadNum"/>
				<xsl:with-param name="posNumber" select="$posNumber"/>
			</xsl:call-template>
		</table>
		<!--<xsl:call-template name="OKSBottom"/>-->
	</xsl:template>
	<xsl:template name="Rights">
		<xsl:param name="Rights"/>
		<xsl:param name="cadNum"/>
		<xsl:param name="posNumber"/>
		<xsl:for-each select="$Rights/kv:Right">
			<xsl:variable name="RightIndex" select="position()"/>
			<xsl:variable name="Encumbrances" select="count(kv:Encumbrance)"/>
			<xsl:variable name="Mdf_Encumb" select="count(kv:Encumbrance/kv:MdfDate)"/>
			<xsl:if test="position()>1 and
				(
					$Encumbrances>0 or
					(./kv:Registration and position() mod 5=0) or
					($Encumbrances=0 and ./kv:NoRegistration and (position() mod 20)=0)
				)"
				>
				<!-- page break -->
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
				<xsl:call-template name="OKSBottom"/> <!-- Signature and Stamp after the each Right -->
				<!--<xsl:if test="not(/kv:KVZU/kv:Parcels)">-->
					<xsl:call-template name="newPage"/>
				<!--</xsl:if>-->
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="2"/>
					<xsl:with-param name="cadNum" select="$cadNum"/>
				</xsl:call-template>
				<br/>
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
			</xsl:if>
	
		  <tr>
			<td width="1%">1.</td>
			<td width="50%" colspan="2">
				<xsl:call-template name="Panel">
					<xsl:with-param name="Text">
					  <xsl:text>Правообладатель (правообладатели):</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td width="1%">
			  <xsl:text>1.</xsl:text>
			  <xsl:value-of select="position()"/>
			  <xsl:text>.</xsl:text>
			</td>
			<td width="50%">
			  <xsl:call-template name="Panel">
				<xsl:with-param name="Text">
				  <xsl:choose>
					<xsl:when test="kv:Owner">
					  <xsl:for-each select="kv:Owner">
						<xsl:if test="not(position()=1)">
						  <xsl:text>;</xsl:text>
						  <br />
						</xsl:if>
						<xsl:choose>
						  <xsl:when test="kv:Person">
							<xsl:call-template name="Value">
							  <xsl:with-param name="Node" select="kv:Person/kv:Content"/>
							</xsl:call-template>
							<xsl:choose>
							  <xsl:when test="Person/MdfDate">
								<br />
								<i style='mso-bidi-font-style:normal'>
								  <xsl:text>Дата модификации:</xsl:text>
								  <xsl:call-template name="Value">
									<xsl:with-param name="Node" select="Person/MdfDate"/>
								  </xsl:call-template>
								</i>
							  </xsl:when>
							</xsl:choose>
						  </xsl:when>
						  <xsl:when test="kv:Organization">
							<xsl:call-template name="Value">
							  <xsl:with-param name="Node" select="kv:Organization/kv:Content"/>
							</xsl:call-template>
							<xsl:choose>
							  <xsl:when test="Organization/MdfDate">
								<br />
								<i style='mso-bidi-font-style:normal'>
								  <xsl:text>Дата модификации:</xsl:text>
								  <xsl:call-template name="Value">
									<xsl:with-param name="Node" select="Organization/MdfDate"/>
								  </xsl:call-template>
								</i>
							  </xsl:when>
							</xsl:choose>
						  </xsl:when>
						  <xsl:when test="kv:Governance">
							<xsl:call-template name="Value">
							  <xsl:with-param name="Node" select="kv:Governance/kv:Content"/>
							</xsl:call-template>
						  </xsl:when>
						</xsl:choose>
					  </xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
					  <xsl:call-template name="Value">
						<xsl:with-param name="Node" select="kv:NoOwner"/>
					  </xsl:call-template>
					</xsl:otherwise>
				  </xsl:choose>
				</xsl:with-param>
			  </xsl:call-template>
			</td>
		  </tr>
		  <xsl:choose>      
		  <xsl:when test="kv:NoRegistration and kv:Owner">
			<br></br>
		  </xsl:when>  
		  <xsl:otherwise>
		  <tr>
			<td>2.</td>
			<td colspan="2">
			  <xsl:call-template name="Panel">
				<xsl:with-param name="Text">
				  <xsl:text>Вид, номер и дата государственной регистрации права:</xsl:text>
				</xsl:with-param>
			  </xsl:call-template>
			</td>
			<td>
			  <xsl:text>2.</xsl:text>
			  <xsl:value-of select="position()"/>
			  <xsl:text>.</xsl:text>
			</td>
			<td>
			  <xsl:call-template name="Panel">
				<xsl:with-param name="Text">
				  <xsl:choose>
					<xsl:when test="kv:Registration">
					  <xsl:call-template name="Value">
						<xsl:with-param name="Node" select="kv:Registration/kv:Name"/>
					  </xsl:call-template>
					  <xsl:call-template name="Value">
						<xsl:with-param name="Node" select="kv:Registration/kv:RestorCourt"/>
					  </xsl:call-template>
					  <xsl:choose>
						<xsl:when test="kv:Registration/kv:MdfDate">
						  <br />
						  <i style='mso-bidi-font-style:normal'>
							<xsl:text>Дата модификации:</xsl:text>
							<xsl:call-template name="Value">
							  <xsl:with-param name="Node" select="kv:Registration/kv:MdfDate"/>
							</xsl:call-template>
						  </i>
						</xsl:when>
					  </xsl:choose>
					</xsl:when>
					<xsl:otherwise>
					  <xsl:call-template name="Value">
						<xsl:with-param name="Node" select="kv:NoRegistration"/>
					  </xsl:call-template>
					</xsl:otherwise>
				  </xsl:choose>
				</xsl:with-param>
			  </xsl:call-template>
			</td>
		  </tr>
		<tr>
			<td rowspan="{$Encumbrances*6+$Mdf_Encumb+1}">3.</td>
			<td colspan="2">
			  <xsl:call-template name="Panel">
				<xsl:with-param name="Text">
				  <xsl:text>Ограничение прав и обременение объекта недвижимости:</xsl:text>
				</xsl:with-param>
			  </xsl:call-template>
			</td>
			<td colspan="2">
			  <xsl:call-template name="Panel">
				<xsl:with-param name="Text">
				  <xsl:choose>
					<xsl:when test="kv:Encumbrance">&#160;</xsl:when>
					<xsl:otherwise>
					  <xsl:call-template name="Value">
						<xsl:with-param name="Node" select="kv:NoEncumbrance"/>
					  </xsl:call-template>
					</xsl:otherwise>
				  </xsl:choose>
				</xsl:with-param>
			  </xsl:call-template>
			</td>
		</tr>
			<xsl:for-each select="kv:Encumbrance">
				<xsl:variable name="Mdf_D" select="count(MdfDate)"/>
				<xsl:variable name="encs">
					<xsl:if test="(position() &gt; 2) and (position() &gt; (floor(count(../kv:Encumbrance) div 3) * 3 - 1))"><xsl:value-of select="count(../kv:Encumbrance) - (floor(count(../kv:Encumbrance) div 3) * 3 - 1)"/></xsl:if>
					<xsl:if test="not((position() &gt; 2) and (position() &gt; (floor(count(../kv:Encumbrance) div 3) * 3 - 1)))">3</xsl:if>
				</xsl:variable>
				<xsl:if test="(position() mod 3) = 0">
					<!-- page break -->
					<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
					<xsl:call-template name="OKSBottom"/> <!-- Signature and Stamp after the each Right -->
					<!--<xsl:if test="not(/kv:KVZU/kv:Parcels)">-->
						<xsl:call-template name="newPage"/>
					<!--</xsl:if>-->
					<xsl:call-template name="topSheets">
						<xsl:with-param name="curSheet" select="2"/>
						<xsl:with-param name="allSheets" select="__"/>
						<xsl:with-param name="curRazd" select="2"/>
						<xsl:with-param name="cadNum" select="$cadNum"/>
					</xsl:call-template>
					<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
				</xsl:if>
				<tr>
					<xsl:if test="(position() &gt; 2) and (position() mod 3) = 0"><td rowspan="{(6+$Mdf_D)*$encs}">&nbsp;&nbsp;</td></xsl:if>
					<td rowspan="{6+$Mdf_D}" width="1%">
						<xsl:text>3.</xsl:text>
						<xsl:value-of select="$RightIndex"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="position()"/>
						<xsl:text>.</xsl:text>
					</td>
					<td>
						<xsl:call-template name="Panel">
						  <xsl:with-param name="Text">
							<xsl:text>вид:</xsl:text>
						  </xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
						<xsl:call-template name="Panel">
						  <xsl:with-param name="Text">
							<xsl:call-template name="Value">
							  <xsl:with-param name="Node" select="kv:Name"/>
							</xsl:call-template>
							<xsl:if test="kv:ShareText">
							  <xsl:text>, </xsl:text>
							  <xsl:call-template name="Value">
								<xsl:with-param name="Node" select="kv:ShareText"/>
							  </xsl:call-template>
							</xsl:if>
						  </xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
			<tr>
			  <td>
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:text>дата государственной регистрации:</xsl:text>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			  <td colspan="2">
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:call-template name="Value">
					  <xsl:with-param name="Node" select="kv:RegDate"/>
					</xsl:call-template>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			</tr>
			<tr>
			  <td>
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:text>номер государственной регистрации:</xsl:text>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			  <td colspan="2">
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:call-template name="Value">
					  <xsl:with-param name="Node" select="kv:RegNumber"/>
					</xsl:call-template>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			</tr>
			<tr>
			  <td>
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:text>срок, на который установлено ограничение прав и обременение объекта недвижимости:</xsl:text>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			  <td colspan="2">
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:choose>
					  <xsl:when test="kv:Duration/kv:Term">
						<xsl:call-template name="Value">
						  <xsl:with-param name="Node" select="kv:Duration/kv:Term"/>
						</xsl:call-template>
					  </xsl:when>
					  <xsl:when test="kv:Duration/kv:Started">
						<xsl:if test="kv:Duration/kv:Started">
						  <xsl:text>с </xsl:text>
						  <xsl:call-template name="Value">
							<xsl:with-param name="Node" select="kv:Duration/kv:Started"/>
						  </xsl:call-template>
						</xsl:if>
						<xsl:if test="kv:Duration/kv:Stopped">
						  <xsl:text> по </xsl:text>
						  <xsl:call-template name="Value">
							<xsl:with-param name="Node" select="kv:Duration/kv:Stopped"/>
						  </xsl:call-template>
						</xsl:if>
					  </xsl:when>
					  <xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			</tr>
			<tr>
			  <td>
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:text>лицо, в пользу которого установлено ограничение прав и обременение объекта недвижимости:</xsl:text>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			  <td colspan="2">
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:choose>
					  <xsl:when test="kv:Owner">
						<xsl:for-each select="kv:Owner">
						  <xsl:if test="not(position()=1)">
							<xsl:text>;</xsl:text>
							<br />
						  </xsl:if>
						  <xsl:choose>
							<xsl:when test="kv:Person">
							  <xsl:call-template name="Value">
								<xsl:with-param name="Node" select="kv:Person/kv:Content"/>
							  </xsl:call-template>
							  <xsl:choose>
								<xsl:when test="Person/MdfDate">
								  <br />
								  <i style='mso-bidi-font-style:normal'>
									<xsl:text>Дата модификации:</xsl:text>
									<xsl:call-template name="Value">
									  <xsl:with-param name="Node" select="Person/MdfDate"/>
									</xsl:call-template>
								  </i>
								</xsl:when>
							  </xsl:choose>
							</xsl:when>
							<xsl:when test="kv:Organization">
							  <xsl:call-template name="Value">
								<xsl:with-param name="Node" select="kv:Organization/kv:Content"/>
							  </xsl:call-template>
							  <xsl:choose>
								<xsl:when test="Organization/MdfDate">
								  <br />
								  <i style='mso-bidi-font-style:normal'>
									<xsl:text>Дата модификации:</xsl:text>
									<xsl:call-template name="Value">
									  <xsl:with-param name="Node" select="Organization/MdfDate"/>
									</xsl:call-template>
								  </i>
								</xsl:when>
							  </xsl:choose>
							</xsl:when>
							<xsl:when test="kv:Governance">
							  <xsl:call-template name="Value">
								<xsl:with-param name="Node" select="kv:Governance/kv:Content"/>
							  </xsl:call-template>
							</xsl:when>
						  </xsl:choose>
						</xsl:for-each>
					  </xsl:when>
					  <xsl:otherwise>
						<xsl:call-template name="Value">
						  <xsl:with-param name="Node" select="kv:AllShareOwner"/>
						</xsl:call-template>
					  </xsl:otherwise>
					</xsl:choose>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			</tr>
			<tr>
			  <td>
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:text>основание государственной регистрации:</xsl:text>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			  <td colspan="2">
				<xsl:call-template name="Panel">
				  <xsl:with-param name="Text">
					<xsl:choose>
					  <xsl:when test="kv:DocFound">
						<xsl:for-each select="kv:DocFound">
						  <xsl:if test="not(position()=1)">
							<xsl:text>;</xsl:text>
							<br />
						  </xsl:if>
						  <xsl:call-template name="Value">
							<xsl:with-param name="Node" select="kv:Content"/>
						  </xsl:call-template>
						</xsl:for-each>
					  </xsl:when>
					  <xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				  </xsl:with-param>
				</xsl:call-template>
			  </td>
			</tr>
			<xsl:choose>
			  <xsl:when test="MdfDate">
				<tr>
				  <td>
					<i style='mso-bidi-font-style:normal'>
					  <xsl:call-template name="Panel">
						<xsl:with-param name="Text">
						  <xsl:text>дата модификации:</xsl:text>
						</xsl:with-param>
					  </xsl:call-template>
					</i>
				  </td>
				  <td colspan="2">
					<i style='mso-bidi-font-style:normal'>
					  <xsl:call-template name="Panel">
						<xsl:with-param name="Text">
						  <xsl:call-template name="Value">
							<xsl:with-param name="Node" select="MdfDate"/>
						  </xsl:call-template>
						</xsl:with-param>
					  </xsl:call-template>
					</i>
				  </td>
				</tr>
			  </xsl:when>
			</xsl:choose>
		  </xsl:for-each>
		  </xsl:otherwise>
		  </xsl:choose>
		</xsl:for-each>
			<xsl:if test="/kv:KVZU/kv:Parcels">
				<tr>
					<td>4.</td>
					<td colspan="2">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Договоры участия в долевом строительстве:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
						<xsl:if test="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:DocShareHolding">
							<xsl:value-of select="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:DocShareHolding"/>
							<!--<xsl:for-each select="../kv:DocShareHolding">
								<xsl:value-of select="."/>
								<xsl:if test="not(position()=last())">, </xsl:if>
							</xsl:for-each>-->
						</xsl:if>
						<xsl:if test="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:NoShareHolding">
							<xsl:value-of select="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:NoShareHolding"/>
						</xsl:if>
						<xsl:if test="not($SExtract/kv:ExtractObject/kv:ObjectRight/kv:DocShareHolding | $SExtract/kv:ExtractObject/kv:ObjectRight/kv:NoShareHolding)">
							<xsl:text>данные отсутствуют</xsl:text>
						</xsl:if>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td>5.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Заявленные в судебном порядке права требования:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightClaim"/>
				</td>
			</tr>
			<tr>
				<td>6.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о возражении в отношении зарегистрированного права:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightAgainst"/>
				</td>
			</tr>
			<tr>
				<td>7.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о наличии решения об изъятии объекта недвижимости для государственных и муниципальных нужд:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightSteal"/>
				</td>
			</tr>
			<tr>
				<td>8.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о невозможности государственной регистрации без личного участия правообладателя или его законного представителя:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:value-of select="$SExtract/kv:ExtractObject/kv:InabilityRegWithoutOwner"/>
				</td>
			</tr>
			<tr>
				<td>9.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Правопритязания и сведения о наличии поступивших, но не рассмотренных заявлений о проведении государственной регистрации права (перехода, прекращения права), ограничения права или обременения объекта недвижимости, сделки в отношении объекта недвижимости:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightAssert"/>
				</td>
			</tr>
			<tr>
				<td>10.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения об осуществлении государственной регистрации сделки, права, ограничения права без необходимого в силу закона согласия третьего лица, органа:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:value-of select="$SExtract/kv:ExtractObject/kv:WithoutThirdParty"/>
				</td>
			</tr>
			<xsl:if test="/kv:KVZU/kv:Parcels">
				<tr>
					<td>11.</td>
					<td colspan="2">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Сведения о невозможности государственной регистрации перехода, прекращения, ограничения права на земельный участок из земель сельскохозяйственного назначения:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
						<xsl:value-of select="$SExtract/kv:ExtractObject/kv:InabilityRegZU"/>
					</td>
				</tr>
			</xsl:if>
	</xsl:template>
	<xsl:template name="Panel">
		<xsl:param name="Text"/>
		<xsl:copy-of select="$Text"/>
	</xsl:template>
	<xsl:template name="Value">
		<xsl:param name="Node"/>
		<xsl:call-template name="Replace">
			<xsl:with-param name="Old" select="'&#10;'"/>
			<xsl:with-param name="New">
				<br/>
			</xsl:with-param>
			<xsl:with-param name="Text">
				<xsl:call-template name="Replace">
					<xsl:with-param name="Old" select="';'"/>
					<xsl:with-param name="New" select="'; '" />
					<xsl:with-param name="Text">
						<xsl:call-template name="Replace">
							<xsl:with-param name="Old" select="','"/>
							<xsl:with-param name="New" select="', '" />
							<xsl:with-param name="Text" select="$Node" />
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Replace">
		<xsl:param name="Text"/>
		<xsl:param name="Old"/>
		<xsl:param name="New"/>
		<xsl:choose>
			<xsl:when test="contains($Text, $Old)">
				<xsl:variable name="Before" select="substring-before($Text, $Old)"/>
				<xsl:value-of select="$Before"/>
				<xsl:choose>
					<xsl:when test="string($New)">
						<xsl:value-of select="$New"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$New"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="Replace">
					<xsl:with-param name="Text">
						<xsl:choose>
							<xsl:when test="string-length($Before) > 0 and $Before = substring-before($Text, $New)">
								<xsl:value-of select="substring-after($Text, $New)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after($Text, $Old)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="Old" select="$Old"/>
					<xsl:with-param name="New" select="$New"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$Text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Section_4_a_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="contour_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:param name="is_first"/>
		<xsl:if test="$cur_index &lt; $contour_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4'"/>
					</xsl:call-template>
					<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'4'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="V2_FormC">
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'2'"/>
			</xsl:call-template>
			<xsl:call-template name="Section_4_a_Cycle">
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="contour_pages_total" select="$contour_pages_total"/>
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'2'"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V2_FormC">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:variable name="canvas" select="concat('canvas', $index_cur+count(descendant::kv:EntitySpatial[parent::kv:SubParcel]))"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<th colspan="4" style="text-align:left;">План (чертеж, схема) земельного участка</th>
			</tr>
			<tr>
				<th colspan="4">
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id">
											<xsl:value-of select="$canvas"/>
										</xsl:attribute>
										<!--<xsl:attribute name="width">900</xsl:attribute>
										<xsl:attribute name="height">600</xsl:attribute>-->
										<xsl:attribute name="width">360</xsl:attribute>
										<xsl:attribute name="height">240</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
				</th>
			</tr>
			<tr>
				<th width="25%">Масштаб 1: 
				<!--<xsl:call-template name="procherk"/>-->
				<xsl:call-template name="no_data"/>
				</th>
				<th width="25%">Условные обозначения: </th>
				<th width="25%"></th>
				<th width="25%"></th>
			</tr>
			</table>
			</th></tr>
		</table>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template name="Section_3_2">
		<!--КВ6-->
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="point_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="is_first"/>
		<xsl:variable name="cur_position" select="$cur_index * $max_page_records"/>
		<xsl:if test="$cur_index &lt; $point_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
				<xsl:call-template name="Title">
					<xsl:with-param name="pageNumber" select="'3.2'"/>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'3.2'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="Point_Form">
				<xsl:with-param name="position_cur" select="$cur_position"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Section_3_2">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="point_pages_total" select="$point_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Point_Form">
		<xsl:param name="position_cur"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="listAll"/>
		<!--<xsl:call-template name="newPage"/>-->
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									Сведения о характерных точках границы земельного участка
								</td>
							</tr>
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
                                    <xsl:variable name="entSys" select="string(kv:EntitySpatial/@EntSys)"/>
                                    Система координат: <xsl:value-of select="$coordSystems/node()[string(@CsId)=$entSys]/@Name"/><br/>
                                    Зона №
								</td>
							</tr>
										<tr height="30px">
											<th width="5%" rowspan="2">Номер точки</th>
											<th colspan="2">Координаты</th>
											<th rowspan="2" width="30%">Описание закрепления на местности</th>
											<th rowspan="2" width="30%">Средняя квадратическая погрешность определения координат характерных точек границ земельного участка, м</th>
										</tr>
										<tr>
											<th width="10%">X</th>
											<th width="10%">Y</th>
										</tr>
										<tr>
											<td style="text-align:center">1</td>
											<td style="text-align:center">2</td>
											<td style="text-align:center">3</td>
											<td style="text-align:center">4</td>
											<td style="text-align:center">5</td>
										</tr>
										<xsl:for-each select="$spatialElementUnique[position() &lt; (count($spatialElementUnique)+1)]">
											<xsl:sort data-type="number" order="ascending" select="@SuNmb"/>
											<xsl:if test="(position() &lt; $max_page_records+1+$position_cur) and (position() &gt; $position_cur)">
												<xsl:variable name="num_pp" select="@Spatial_ID"/>
												<xsl:variable name="point" select="@SuNmb"/>
												<tr>
													<td style="text-align:center">
														<xsl:value-of select="@SuNmb"/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@X"/>
														<br/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@Y"/>
														<br/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@GeopointZacrep"/>
														<xsl:if test="not(string(spa:Ordinate/@GeopointZacrep))">
															<!--<xsl:call-template name="procherk"/>-->
															<xsl:call-template name="no_data"/>
														</xsl:if>
														<br/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@DeltaGeopoint"/>
														<xsl:if test="not(string(spa:Ordinate/@DeltaGeopoint))">
															<!--<xsl:call-template name="procherk"/>-->
															<xsl:call-template name="no_data"/>
														</xsl:if>
														<br/>
													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
						</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Section_4_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="part_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:param name="is_first"/>
		<xsl:if test="$cur_index &lt; $part_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
				<xsl:call-template name="Title">
					<xsl:with-param name="pageNumber" select="'4'"/>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'4'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="V4_Form">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'4'"/>
			</xsl:call-template>
			<xsl:call-template name="Section_4_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="part_pages_total" select="$part_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V4_Form">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:variable name="canvas" select="concat('canvas', $index_cur)"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<th style="text-align:left; BORDER-STYLE: solid; border-width:1px;padding-left:5px" colspan="2">
								План (чертеж, схема) части земельного участка
							</th>
							<th style="text-align:left;" colspan="2">
								Учетный номер части:
								<u>
									<b>
										<xsl:value-of select="concat(@CadastralNumber, '/', descendant::kv:EntitySpatial[parent::kv:SubParcel][$index_cur+1]/parent::node()/@NumberRecord)"/>
									</b>
								</u>
							</th>
						</tr>
						<tr>
							<th colspan="4">
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id">
											<xsl:value-of select="$canvas"/>
										</xsl:attribute>
										<!--<xsl:attribute name="width">900</xsl:attribute>
										<xsl:attribute name="height">600</xsl:attribute>-->
										<xsl:attribute name="width">360</xsl:attribute>
										<xsl:attribute name="height">240</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</th>
						</tr>
						<tr>
							<th style="text-align:left;" width="25%">
								Масштаб 1:
							<!--<xsl:call-template name="procherk"/>-->
							<xsl:call-template name="no_data"/>
							</th>
							<th style="text-align:left;" width="25%">
								Условные обозначения:  
							</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
						</tr>
					</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Section_4_1_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="border_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="cadnum"/>
		<xsl:param name="listAll"/>
		<xsl:param name="is_first"/>
		<xsl:if test="$cur_index &lt; $border_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
					<xsl:call-template name="newPage"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4.1'"/>
					</xsl:call-template>
					<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'4.1'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="V3_Form">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="cadnum" select="$cadnum"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Section_4_1_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="border_pages_total" select="$border_pages_total"/>
				<xsl:with-param name="cadnum" select="$cadnum"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V3_Form">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="cadnum"/>
		<xsl:param name="listAll"/>
		<xsl:variable name="position_cur" select="$index_cur * $countV3"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:variable name="list3_1" select="count(kv:SubParcels/kv:SubParcel)"/>
		<xsl:variable name="dif" select="$countV3+0-count(kv:SubParcels/kv:SubParcel) mod $countV3"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
									<tr>
										<td style="text-align:center" width="20%">Учетный номер части</td>
										<td style="text-align:center" width="20%">
											<xsl:text>Площадь (м</xsl:text>
											<sup>2</sup>
											<xsl:text>)</xsl:text>
										</td>
										<td style="text-align:center" width="60%">Содержание ограничения в использовании или ограничения права на объект недвижимости или обременения объекта недвижимости</td>
									</tr>
									<tr>
										<td style="text-align:center">1</td>
										<td style="text-align:center">2</td>
										<td style="text-align:center">3</td>
									</tr>
									<xsl:for-each select="kv:SubParcels/kv:SubParcel[position() &gt; $position_cur][position() &lt; $countV3+1]">
										<tr>
											<td style="text-align:center">
												<xsl:if test="kv:Encumbrance">
													<xsl:if test="@Full!='1'">
														<xsl:value-of select="@NumberRecord"/>
													</xsl:if>
													<xsl:if test="@Full='1'">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(kv:Encumbrance)">
													<xsl:if test="@Full!='1'">
														<xsl:value-of select="@NumberRecord"/>
													</xsl:if>
													<xsl:if test="@Full='1'">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
												</xsl:if>
												<br/>
											</td>
											<td style="text-align:center">
												<xsl:if test="@Full='1'">
													весь
												</xsl:if>
												<xsl:if test="@Full!='1' or not(@Full)">
													<xsl:if test="string(kv:Area/kv:Area)">
														<xsl:value-of select="kv:Area/kv:Area"/>
														<xsl:text> </xsl:text>
													</xsl:if>
												</xsl:if>
												<br/>
											</td>
											<td style="text-align:left">
												<xsl:apply-templates select="kv:Encumbrance"/>
												<xsl:if test="(@State='05')">
													<xsl:if test="kv:Encumbrance">
														<xsl:text>, </xsl:text>
													</xsl:if>
													<xsl:text>Временные</xsl:text>
													<xsl:if test="@DateExpiry">
														<xsl:text>. Дата истечения срока действия временного характера - </xsl:text>
														<xsl:apply-templates select="@DateExpiry"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(@State) and not(string(kv:Encumbrance))">
													<!--<xsl:call-template name="procherk"/>-->
													<xsl:call-template name="no_data"/>
												</xsl:if>
												<br/>
											</td>
										</tr>
									</xsl:for-each>
									<xsl:if test="$position_cur+$countV3 &gt; $list3_1 and $position_cur &lt; $list3_1+1">
										<xsl:for-each select="kv:Encumbrances/kv:Encumbrance[position() &lt; $dif+1]">
											<tr>
												<!--<td style="text-align:center">
													<xsl:value-of select="position()+$position_cur+$countV3+0-$dif"/>
												</td>-->
                        <!--эта штука каким-то непостижимым образом вытаскивает ограничения из основного участка
                             <xsl:call-template name="PartOfEncumbrance"/>-->
											</tr>
										</xsl:for-each>
									</xsl:if>
									<xsl:if test="$position_cur &gt; $list3_1">
										<xsl:for-each select="kv:Encumbrances/kv:Encumbrance[position() &gt; $position_cur+0-$list3_1][position() &lt; $countV3+1]">
											<tr>
												<!--<td style="text-align:center">
													<xsl:value-of select="$position_cur+position()"/>
												</td>-->
                        <!--эта штука каким-то непостижимым образом вытаскивает ограничения из основного участка
                        <xsl:call-template name="PartOfEncumbrance"/>-->
											</tr>
										</xsl:for-each>
									</xsl:if>
					</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="V3_FormPart">
		<xsl:param name="index_cur"/>
		<xsl:variable name="canvas" select="concat('canvas', $index_cur)"/>
		<tr>
			<th>
				<xsl:call-template name="newPageDiv"/>
				<xsl:call-template name="Title">
					<xsl:with-param name="pageNumber" select="'3'"/>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'3'"/>
					<!--<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>-->
				</xsl:call-template>
				<br/>
				<table class="tbl_container"><tr><th>
					<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<th style="text-align:left; BORDER-STYLE: solid; border-width:1px;padding-left:5px" colspan="4">
								План (чертеж, схема) земельного участка
							</th>
						</tr>
						<tr>
							<th colspan="4">
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id">
											<xsl:value-of select="$canvas"/>
										</xsl:attribute>
										<xsl:attribute name="width">360</xsl:attribute>
										<xsl:attribute name="height">240</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</th>
						</tr>
						<tr>
							<th style="text-align:left;" width="25%">
								Масштаб 1:
								<xsl:call-template name="no_data"/>
							</th>
							<th style="text-align:left;" width="25%">
								Условные обозначения:  
							</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
						</tr>
					</table>
				</th></tr></table>
				<xsl:call-template name="OKSBottom"/>
			</th>
		</tr>
	</xsl:template>
<xsl:template name="PartOfEncumbrance">
		<td style="text-align:center">
			<!--<xsl:call-template name="procherk"/>-->
			<xsl:call-template name="no_data"/>
		</td>
		<td style="text-align:center">
			<xsl:text>весь</xsl:text>
		</td>
		<td style="text-align:left;padding-left:5px">
      <xsl:apply-templates select="."/>
		</td>
	</xsl:template>
  
	<xsl:template name="Form1">
		<xsl:param name="cadNum"/>
		<xsl:param name="section_4_1_exists"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="2"/>
			<xsl:with-param name="cadNum" select="$cadNum"/>
			<xsl:with-param name="curRazd" select="'1'"/>
			<!--<xsl:with-param name="allSheets" select="$listAll"/>-->
		</xsl:call-template>
    <br/>
		<table class="tbl_section_topsheet">
      <tr>
        <th width="40%" class="left vtop">
          <xsl:text>Номер кадастрового квартала:</xsl:text>
        </th>
        <th colspan="3" class="left vtop">
          <xsl:value-of select="kv:CadastralBlock"/>
          <xsl:if test="not(string(kv:CadastralBlock))">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </th>
      </tr>
      <tr>
        <th width="40%" class="left vtop">
          <xsl:text>Дата присвоения кадастрового номера: </xsl:text>
        </th>
        <th colspan="3" class="left vtop">
          <xsl:if test="string(@DateCreatedDoc)">
            <xsl:apply-templates select="@DateCreatedDoc"/>
          </xsl:if>
          <xsl:if test="not(string(@DateCreatedDoc))">
            <xsl:apply-templates select="@DateCreated"/>
          </xsl:if>
          <xsl:if test="not(string(@DateCreatedDoc)) and not(string(@DateCreated))">
            <xsl:call-template name="no_data"/>
          </xsl:if>
        </th>
      </tr>
			<tr>
				<th width="40%" class="left vtop">Ранее присвоенный государственный учетный номер:</th>
				<th width="60%" colspan="3" class="left vtop">
					<xsl:for-each select="kv:OldNumbers/num:OldNumber/@Number">
						<xsl:variable name="old_numbers" select="document('schema/KVZU_v07/SchemaCommon/dOldNumber_v01.xsd')"/>
						<xsl:variable name="type" select="../@Type"/>
						<xsl:value-of select="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation"/>
						<xsl:if test="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation">: </xsl:if>
						<xsl:value-of select="."/>
						<xsl:if test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="not(kv:OldNumbers/num:OldNumber)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Адрес:</th>
				<th colspan="3" class="left vtop">					
          <xsl:apply-templates select="kv:Location"/>
          <xsl:if test="not(kv:Location)">
            <xsl:text>данные отсутствуют</xsl:text>
          </xsl:if>
				</th>
			</tr>
			<tr>			
        <xsl:call-template name="line12Area"/>
			</tr>
			<tr>
				<th class="left vtop">Кадастровая стоимость, руб.:</th>
				<th colspan="3" class="left vtop">
					<xsl:if test="kv:CadastralCost">
						<xsl:value-of select="kv:CadastralCost/@Value"/>
					</xsl:if>
					<xsl:if test="not(kv:CadastralCost)">
						<span class="left">
							<xsl:call-template name="no_data"/>
						</span>
					</xsl:if>
				</th>
			</tr>
			<tr>
					<th width="40%" class="left vtop">Кадастровые номера расположенных в пределах земельного участка объектов недвижимости:</th>
					<th width="60%" class="left vtop">
					<xsl:apply-templates select="kv:InnerCadastralNumbers"/>
					<xsl:if test="not(kv:InnerCadastralNumbers)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
					</th>
			</tr>	
			<tr>
				<th class="left vtop">Кадастровые номера объектов недвижимости, из которых образован объект недвижимости:</th>
				<th class="left vtop">
					<xsl:for-each select="kv:PrevCadastralNumbers/kv:CadastralNumber">
						<xsl:value-of select="."/>
						<xsl:if test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="not(kv:PrevCadastralNumbers/kv:CadastralNumber)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>     
			<tr>
				<th class="left vtop">Кадастровые номера образованных объектов недвижимости:</th>
				<th class="left vtop">
				<xsl:apply-templates select="kv:AllOffspringParcel"/>
				<xsl:if test="not(string(kv:AllOffspringParcel/kv:CadastralNumber[1]))">
					<xsl:call-template name="no_data"/>
				</xsl:if>
				</th>
			</tr>		
			<tr>
				<th class="left vtop">Сведения о включении объекта недвижимости в состав предприятия как имущественного комплекса:</th>
				<th class="left vtop">
				<xsl:if test="$InfoPIK">
					<xsl:value-of select="$InfoPIK"/>
				</xsl:if>
				<xsl:if test="not($InfoPIK)">
					<xsl:call-template name="no_data"/>
				</xsl:if>
				</th>
			</tr>
     </table>
		<!--<xsl:call-template name="newPage"/>-->
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
		<xsl:call-template name="OKSBottom"/>
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=tbl_container', '&gt;')"/>-->
		<xsl:call-template name="newPage"/>
		<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="'1'"/>
		</xsl:call-template>
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="3"/>
			<xsl:with-param name="cadNum" select="$cadNum"/>
			<xsl:with-param name="curRazd" select="'1'"/>
		</xsl:call-template>
    <br/>
		<table class="tbl_section_topsheet">
      <tr>
				<th class="left vtop">Категория земель:</th>
				<th class="left vtop">
					<xsl:variable name="categories" select="document('schema/KVZU_v07/SchemaCommon/dCategories_v01.xsd')"/>
					<xsl:variable name="kod_z" select="kv:Category"/>
					<xsl:value-of select="$categories//xs:enumeration[@value=$kod_z]/xs:annotation/xs:documentation"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Виды разрешенного использования:</th>
				<th class="left vtop">
				<xsl:if test="string(kv:Utilization/@LandUse)">
					<xsl:variable name="var0" select="document('schema/KVZU_v07/SchemaCommon/dAllowedUse_v02.xsd')"/>
					<xsl:variable name="kod" select="kv:Utilization/@LandUse"/>
					<xsl:value-of select="$var0//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
				</xsl:if>
				<xsl:if test="string(kv:Utilization/@ByDoc) and not(string(kv:Utilization/@LandUse))">
					<xsl:value-of select="normalize-space(kv:Utilization/@ByDoc)"/>
					<!--<xsl:if test="string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200">
						<xsl:text>Сведения о разрешенном использовании прилагаются на дополнительном листе </xsl:text>
					</xsl:if>
					<xsl:if test="not(string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200)">
						<xsl:value-of select="normalize-space(kv:Utilization/@ByDoc)"/>
					</xsl:if>-->
				</xsl:if>
				<xsl:if test="not(string(kv:Utilization/@ByDoc)) and not(string(kv:Utilization/@ByDoc)) and not(string(kv:Utilization/@LandUse))">
					<xsl:variable name="var0_1" select="document('schema/KVZU_v07/SchemaCommon/dUtilizations_v01.xsd')"/>
					<xsl:variable name="kod" select="kv:Utilization/@Utilization"/>
					<xsl:value-of select="$var0_1//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
					<xsl:if test="not(string($var0_1//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation))">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</xsl:if>
				</th>
			</tr>	
			<tr>
				<th width="40%" class="left vtop">Сведения о кадастровом инженере:</th>
				<th width="60%" class="left vtop">
				<xsl:for-each select="$contractors/kv:Contractor">
					<xsl:value-of select="normalize-space(concat(kv:FamilyName,' ',kv:FirstName,' ',kv:Patronymic,' №',kv:NCertificate))"/>
					<xsl:if test="kv:Organization">
						<xsl:value-of select="concat(', ',kv:Organization/kv:Name)"/>
					</xsl:if>
					<xsl:if test="@Date">
						<xsl:text>, </xsl:text>
						<xsl:apply-templates select="@Date"/>
					</xsl:if>
					<xsl:if test="position()!=last()">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not($contractors)">
					<!--<xsl:call-template name="procherk"/>-->
					<xsl:call-template name="no_data"/>
				</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о лесах, водных объектах и об иных природных объектах, расположенных в пределах земельного участка:</th>
				<th class="left vtop">
											<xsl:variable name="natural" select="document('schema/KVZU_v07/SchemaCommon/dNaturalObjects_v01.xsd')"/>
											<xsl:variable name="forest" select="document('schema/KVZU_v07/SchemaCommon/dForestUse_v01.xsd')"/>
											<xsl:variable name="forestProt" select="document('schema/KVZU_v07/SchemaCommon/dForestCategoryProtective_v01.xsd')"/>
											<xsl:variable name="forestEnc" select="document('schema/KVZU_v07/SchemaCommon/dForestEncumbrances_v01.xsd')"/>
											<xsl:for-each select="kv:NaturalObjects/nat:NaturalObject">
												<xsl:variable name="kod0" select="nat:Kind"/>
												<xsl:value-of select="$natural//xs:enumeration[@value=$kod0]/xs:annotation/xs:documentation"/>
												<xsl:if test="nat:Forestry or nat:ForestUse or nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther"> (</xsl:if>
												<xsl:if test="nat:Forestry">
													<xsl:text>Наименование: </xsl:text>
													<xsl:value-of select="nat:Forestry"/>
													<xsl:if test="nat:ForestUse or nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:ForestUse">
													<xsl:text>Целевое назначение (категория) лесов: </xsl:text>
													<xsl:variable name="kod1" select="nat:ForestUse"/>
													<xsl:value-of select="$forest//xs:enumeration[@value=$kod1]/xs:annotation/xs:documentation"/>
													<xsl:if test="nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:ProtectiveForest">
													<xsl:text>Категория защитных лесов: </xsl:text>
													<xsl:variable name="kod3" select="nat:ProtectiveForest"/>
													<xsl:value-of select="$forestProt//xs:enumeration[@value=$kod3]/xs:annotation/xs:documentation"/>
													<xsl:if test="nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:QuarterNumbers">
													<xsl:text>Номера лесных кварталов: </xsl:text>
													<xsl:value-of select="nat:QuarterNumbers"/>
													<xsl:if test="nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:TaxationSeparations">
													<xsl:text>Номера лесотаксационных выделов: </xsl:text>
													<xsl:value-of select="nat:TaxationSeparations"/>
													<xsl:if test="nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:ForestEncumbrances">
													<xsl:text>Виды разрешенного использования лесов: </xsl:text>
													<xsl:for-each select="nat:ForestEncumbrances/nat:ForestEncumbrance">
														<xsl:variable name="kod2" select="text()"/>
														<xsl:value-of select="$forestEnc//xs:enumeration[@value=$kod2]/xs:annotation/xs:documentation"/>
														<xsl:if test="position()!=last()">; </xsl:if>
													</xsl:for-each>
													<xsl:if test="nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:WaterObject">
													<xsl:text>Вид водного объекта: </xsl:text>
													<xsl:value-of select="nat:WaterObject"/>
													<xsl:if test="nat:NameOther or nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:NameOther">
													<xsl:text>Наименование: </xsl:text>
													<xsl:value-of select="nat:NameOther"/>
													<xsl:if test="nat:CharOther">; </xsl:if>
												</xsl:if>
												<xsl:if test="nat:CharOther">
													<xsl:text>Характеристика: </xsl:text>
													<xsl:value-of select="nat:CharOther"/>
												</xsl:if>
												<xsl:if test="nat:Forestry or nat:ForestUse or nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">)</xsl:if>
												<xsl:if test="position()!=last()">
													<br/>
												</xsl:if>
											</xsl:for-each>
          <xsl:if test="not(kv:NaturalObjects)">
            <xsl:call-template name="no_data"/>
          </xsl:if>  
        </th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок полностью или частично расположен в границах зоны с особыми условиями использования территории или территории объекта культурного наследия</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок расположен в границах особой экономической зоны, территории опережающего социально-экономического развития, зоны территориального развития в Российской Федерации, игорной зоны:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок расположен в границах особо охраняемой природной территории, охотничьих угодий, лесничеств, лесопарков:</th>
				<th class="left vtop">	
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о результатах проведения государственного земельного надзора:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о расположении земельного участка в границах территории, в отношении которой утвержден проект межевания территории:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
		</table>
		<!--<xsl:call-template name="newPage"/>-->
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
		<xsl:call-template name="OKSBottom"/>
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=tbl_container', '&gt;')"/>-->
		<xsl:call-template name="newPage"/>
		<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="'1'"/>
		</xsl:call-template>
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="4"/>
			<xsl:with-param name="cadNum" select="$cadNum"/>
			<xsl:with-param name="curRazd" select="'1'"/>
		</xsl:call-template>
		<br/>
		<table class="tbl_section_topsheet">
			<tr>
				<th width="40%" class="left vtop">Условный номер земельного участка:</th>
				<th width="60%" class="left vtop">
          <xsl:call-template name="no_data"/>
				</th>
			</tr>		
			<tr>
				<th class="left vtop">Сведения о принятии акта и (или) заключении договора, предусматривающих предоставление в соответствии с земельным законодательством исполнительным органом государственной власти или органом местного самоуправления находящегося в государственной или муниципальной собственности земельного участка для строительства наемного дома социального использования или наемного дома коммерческого использования:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок или земельные участки образованы на основании решения об изъятии земельного участка и (или) расположенного на нем объекта недвижимости для государственных или муниципальных нужд:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок образован из земель или земельного участка, государственная собственность на которые не разграничена:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th width="40%" class="left vtop">Сведения о наличии земельного спора о местоположении границ земельных участков:</th>
				<th width="60%" class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Статус записи об объекте недвижимости:</th>
				<th class="left vtop">
					<xsl:if test="@State='05'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "временные"</xsl:text>
					<xsl:if test="@DateExpiry">
					<xsl:text>. Дата истечения срока действия временного характера - </xsl:text>
						<xsl:apply-templates select="@DateExpiry" mode="digitsXmlWithoutYear"/>
					</xsl:if>
					</xsl:if>
					<xsl:if test="@State='07' or @State='08'">
						<xsl:text>Объект недвижимости снят с кадастрового учета - </xsl:text>
						<xsl:apply-templates select="@DateRemoved" mode="digitsXmlWithoutYear"/>
					</xsl:if>
					<xsl:if test="@State='06'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "актуальные"</xsl:text>
					</xsl:if>
					<xsl:if test="@State='01'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "актуальные, ранее учтенные"</xsl:text>
					</xsl:if>
					<xsl:if test="not(@State)">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Особые отметки:</th>
				<th class="left vtop">
					<xsl:value-of select="$parcel/kv:SpecialNote"/>
          <xsl:if test="count(kv:Contours/kv:Contour) &gt; 0">
            <xsl:if test="not(contains($parcel/kv:SpecialNote, 'Список учетных номеров контуров границы'))">
              <xsl:if test="not(contains($parcel/kv:SpecialNote, 'Состав земельного участка'))">
            <br/>
            <xsl:text>Состав земельного участка:</xsl:text>
            <br/>
            <xsl:for-each select="kv:Contours/kv:Contour|kv:CompositionEZ/kv:EntryParcel">
              <xsl:sort select="ceiling(@NumberRecord|@CadastralNumber)" order="ascending" data-type="number"/>
              <xsl:value-of select="position()"/>
              <xsl:text>) №</xsl:text>
              <xsl:value-of select="@NumberRecord|@CadastralNumber"/>
              <xsl:if test="string(kv:Area/kv:Area)">
                <xsl:text> площадь: </xsl:text>
                <xsl:value-of select="kv:Area/kv:Area"/>
                <xsl:text> кв.м</xsl:text>
              </xsl:if>
              <br/>
            </xsl:for-each>
              </xsl:if>
            </xsl:if>   
          </xsl:if>
					<xsl:if test="not($SExtract/kv:ExtractObject)">
						<xsl:text> Сведения необходимые для заполнения раздела 2 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count(descendant::kv:EntitySpatial) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 3 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="not($bordersUnique)">
						<xsl:text> Сведения необходимые для заполнения раздела 3.1 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="not($spatialElementUnique)">
						<xsl:text> Сведения необходимые для заполнения раздела 3.2 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count(descendant::kv:EntitySpatial[parent::kv:SubParcel]) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 4 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="$section_4_1_exists=0">
						<xsl:text> Сведения необходимые для заполнения раздела 4.1 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count(//kv:SubParcel/kv:EntitySpatial/spa:SpatialElement/spa:SpelementUnit) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 4.2 отсутствуют.</xsl:text>
					</xsl:if>
					<!--<xsl:if test="count(kv:Contours/kv:Contour) &gt; 0">
						<xsl:if test="$parcel/kv:SpecialNote"> </xsl:if>
						<xsl:if test="$section_4_1_exists">
							<xsl:text>Список кадастровых номеров обособленных (условных) участков, входящих в единое землепользование, приведен в разделе 4.1.</xsl:text>
						</xsl:if>
					</xsl:if>-->
					<!--<xsl:if test="count(kv:CompositionEZ/kv:EntryParcel) &gt; 0">
						<xsl:if test="$parcel/kv:SpecialNote"> </xsl:if>
						<xsl:if test="$section_4_1_exists">
							<xsl:text>Список кадастровых номеров обособленных (условных) участков, входящих в единое землепользование, приведен в разделе 4.1.</xsl:text>
						</xsl:if>
					</xsl:if>-->
					<xsl:if test="not($parcel/descendant::kv:EntitySpatial) and not(contains(string($parcel/kv:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства'))">
						<xsl:text> Граница земельного участка не установлена в соответствии с требованиями земельного законодательства</xsl:text>
					</xsl:if>
					<xsl:if test="kv:CompositionEZ">
						<br/>
						<xsl:text>Список кадастровых номеров (площадей) обособленных (условных) участков, входящих в единое землепользование: </xsl:text>
						<xsl:for-each select="kv:CompositionEZ/kv:EntryParcel">
							<xsl:if test="position() &gt; 1">, </xsl:if>
							<xsl:value-of select="@CadastralNumber"/>&nbsp;(<xsl:value-of select="kv:Area/kv:Area"/>кв.м)
							  <xsl:if test="@State='07' or @State='08'">
										<xsl:text>(снят с учета </xsl:text>
										<xsl:apply-templates select="@DateRemoved"/>
										<xsl:text>) </xsl:text>
							  </xsl:if>
							<xsl:if test="position() = last()">.</xsl:if>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="not(string($parcel/kv:SpecialNote))
									and $SExtract/kv:ExtractObject
									and count(descendant::kv:EntitySpatial) &gt; 0
									and $bordersUnique
									and $spatialElementUnique
									and count(descendant::kv:EntitySpatial[parent::kv:SubParcel]) &gt; 0
									and $section_4_1_exists &gt; 0
									and count(//kv:SubParcel/kv:EntitySpatial/spa:SpatialElement/spa:SpelementUnit) &gt; 0
									and not(kv:Contours)
									and not(kv:CompositionEZ)
									and not(not($parcel/descendant::kv:EntitySpatial)	and not(contains(string($parcel/kv:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства')))">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>  
		<xsl:variable name="countOwners">
			<xsl:if test="string($countRights)">
				<xsl:choose>
					<xsl:when test="$countRights &lt; 4 and count($rights/descendant::kv:Document) &lt; 2 and count($rights/descendant::kv:Owner) &lt; 6">
						<xsl:value-of select="0"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ceiling($countRights div ($countV1Rights))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line11">
			<xsl:if test="string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line9">
			<xsl:if test="string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line5">
			<xsl:if test="(count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not((count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line16">
			<xsl:if test="not(kv:Name='05') and not(kv:Name='02')">
				<xsl:value-of select="0"/>
			</xsl:if>
			<xsl:if test="kv:Name='02'">
				<xsl:value-of select="ceiling(count(kv:CompositionEZ/kv:EntryParcel) div $max_page_records)"/>
			</xsl:if>
			<xsl:if test="kv:Name='05'">
				<xsl:value-of select="ceiling(count(kv:Contours/kv:Contour) div $max_page_records)"/>
			</xsl:if>
		</xsl:variable>				
			<tr>
				<th class="left vtop">Получатель выписки:</th>
				<th class="left vtop">
					<xsl:value-of select="$FootContent/kv:Recipient"/>
				</th>
			</tr>
		</table>
	</xsl:template>
  
	<xsl:template name="smallCase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, $uppercase, $smallcase)"/>
	</xsl:template>
	<xsl:template name="topKind">
		<table class="tbl_container">
				<tr>
					<td align="left" width="100%">
            <xsl:value-of select="$HeadContent/kv:Content"/>
					</td>
				</tr>
		</table>
	</xsl:template>
	<xsl:template match="kv:PrevCadastralNumbers|kv:OldNumbers|kv:InnerCadastralNumbers|kv:AllOffspringParcel">
		<xsl:for-each select="kv:CadastralNumber|num:OldNumber">
			<xsl:value-of select="text()|@Number"/>
			<xsl:if test="position()!=last()">, </xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="CountoursLine16">
		<xsl:param name="countPrev"/>
		<xsl:param name="countCurrent"/>
		<xsl:if test="not(contains($parcel/kv:SpecialNote, 'Граница земельного участка состоит из'))">
			<xsl:value-of select="concat('Граница земельного участка состоит из ',count(kv:Contours/kv:Contour),' контуров. ')"/>
		</xsl:if>    
	<!--	<xsl:text>Список учетных номеров контуров границы земельного участка приведен на </xsl:text>
		<xsl:if test="$countCurrent &gt; 1">
			<xsl:value-of select="concat('листах № ',1+$countPrev,' - ',$countPrev+$countCurrent,'. ')"/>
		</xsl:if>
		<xsl:if test="not($countCurrent &gt; 1)">
			<xsl:value-of select="concat('листе № ',1+$countPrev,'. ')"/>
		</xsl:if>-->
	</xsl:template>
	<xsl:template name="CompositionLine16">
		<xsl:param name="countPrev"/>
		<xsl:param name="countCurrent"/>
		<xsl:text>Список кадастровых номеров обособленных (условных) участков, входящих в единое землепользование, приведен на </xsl:text>
		<xsl:if test="$countCurrent &gt; 1">
			<xsl:value-of select="concat('листах № ',1+$countPrev,' - ',$countPrev+$countCurrent,'. ')"/>
		</xsl:if>
		<xsl:if test="not($countCurrent &gt; 1)">
			<xsl:value-of select="concat('листе № ',1+$countPrev,'. ')"/>
		</xsl:if>
	</xsl:template>
  <xsl:template name="line12Area">
    <xsl:variable name="var" select="document('dict/unit_measure_qual.xml')"/>
    <th style="text-align:left" colspan="">
      <xsl:text>Площадь: </xsl:text>
    </th>
    <th style="text-align:left" colspan="">
      <xsl:if test="string(kv:Area/kv:Area)">
        <xsl:value-of select="kv:Area/kv:Area"/>
        <xsl:text> </xsl:text>
        <xsl:if test="string(kv:Area/kv:Inaccuracy) and ceiling(kv:Area/kv:Inaccuracy)!=0">
          +/-
          <xsl:value-of select="kv:Area/kv:Inaccuracy"/>
        </xsl:if>
        <xsl:variable name="kod3" select="kv:Area/kv:Unit"/>
        <xsl:value-of select="$var/row_list/row[COD_OKEI=$kod3]/SHORT_VALUE"/>
        <br/>
      </xsl:if>
      <xsl:if test="not(string(kv:Area/kv:Area))">
        <xsl:call-template name="procherk"/>
      </xsl:if>
    </th>
  </xsl:template>
  <xsl:template match="kv:Location">
    <xsl:if test="string(kv:inBounds) and kv:inBounds!='2'">
      <xsl:text> установлено относительно ориентира, расположенного </xsl:text>
      <xsl:if test="kv:inBounds='1'">
        <xsl:text>в границах участка. </xsl:text>
      </xsl:if>
      <xsl:if test="kv:inBounds='0'">
        <xsl:text>за пределами участка. </xsl:text>
      </xsl:if>
      <xsl:if test="kv:Elaboration/kv:ReferenceMark">
        <xsl:text>Ориентир </xsl:text>
        <xsl:value-of select="kv:Elaboration/kv:ReferenceMark"/>
        <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:if test="kv:Elaboration/kv:Direction">
        <xsl:text>Участок находится примерно в </xsl:text>
        <xsl:value-of select="kv:Elaboration/kv:Distance"/>
        <xsl:text> от ориентира по направлению на </xsl:text>
        <xsl:value-of select="kv:Elaboration/kv:Direction"/>
        <xsl:text>. </xsl:text>
      </xsl:if>
      <br/>
      <xsl:text>Почтовый адрес ориентира: </xsl:text>
      <xsl:apply-templates select="kv:Address"/>
    </xsl:if>
    <xsl:if test="not(string(kv:inBounds)) or kv:inBounds='2'">
      <xsl:apply-templates select="kv:Address"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="kv:Address">
    <xsl:if test="not(string(adr:Note))">
      <xsl:if test="string(adr:PostalCode)">
        <xsl:value-of select="adr:PostalCode"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:Region)">
        <xsl:variable name="region" select="document('schema/KVZU_v07/SchemaCommon/dRegionsRF_v01.xsd')"/>
        <xsl:variable name="kod" select="adr:Region"/>
        <xsl:value-of select="$region//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
        <xsl:if test="adr:District or adr:City or adr:UrbanDistrict or adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:District/@Name)">
        <xsl:value-of select="adr:District/@Name"/>&nbsp;<xsl:value-of select="adr:District/@Type"/>
        <xsl:if test="adr:City or adr:UrbanDistrict or adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:City/@Name)">
        <xsl:value-of select="adr:City/@Type"/>&nbsp;<xsl:value-of select="adr:City/@Name"/>
        <xsl:if test="adr:UrbanDistrict or adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:UrbanDistrict/@Name)">
        <xsl:value-of select="adr:UrbanDistrict/@Type"/>&nbsp;<xsl:value-of select="adr:UrbanDistrict/@Name"/>
        <xsl:if test="adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:SovietVillage/@Name)">
        <xsl:value-of select="adr:SovietVillage/@Type"/>&nbsp;<xsl:value-of select="adr:SovietVillage/@Name"/>
        <xsl:if test="adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:Locality/@Name)">
        <xsl:value-of select="adr:Locality/@Type"/>&nbsp;<xsl:value-of select="adr:Locality/@Name"/>
        <xsl:if test="adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:Street/@Name)">
        <xsl:value-of select="adr:Street/@Type"/>&nbsp;<xsl:value-of select="adr:Street/@Name"/>
        <xsl:if test="adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:Level1/@Value)">
        <xsl:value-of select="adr:Level1/@Type"/>&nbsp;<xsl:value-of select="adr:Level1/@Value"/>
        <xsl:if test="adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:Level2/@Value)">
        <xsl:value-of select="adr:Level2/@Type"/>&nbsp;<xsl:value-of select="adr:Level2/@Value"/>
        <xsl:if test="adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="string(adr:Level3/@Value)">
        <xsl:value-of select="adr:Level3/@Type"/>&nbsp;<xsl:value-of select="adr:Level3/@Value"/>
        <xsl:if test="adr:Apartment or adr:Other">, </xsl:if>
      </xsl:if>
      <xsl:if test="string(adr:Apartment/@Value)">
        <xsl:value-of select="adr:Apartment/@Type"/>&nbsp;<xsl:value-of select="adr:Apartment/@Value"/>
        <xsl:if test="adr:Other">, </xsl:if>
      </xsl:if>
      <xsl:if test="string(adr:Other)">
        <xsl:value-of select="adr:Other"/>&nbsp;
      </xsl:if>
    </xsl:if>
    <xsl:value-of select="adr:Note"/>
  </xsl:template>
  <xsl:template name="V2_Form">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<!--<xsl:call-template name="newPage"/>-->
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<th colspan="4" style="text-align:left;">План (чертеж, схема) земельного участка</th>
			</tr>
			<tr>
				<th colspan="4">
								<div align="center">
									<canvas id="canvas" width="360" height="240" style="cursor: pointer;"/>
								</div>
				</th>
			</tr>
			<tr>
				<th width="25%">Масштаб 1: 
				<!--<xsl:call-template name="procherk"/>-->
				<xsl:call-template name="no_data"/>
				</th>
				<th width="25%">Условные обозначения: </th>
				<th width="25%"></th>
				<th width="25%"></th>
			</tr>
			</table>
			</th></tr>
		</table>
	</xsl:template>
	<xsl:template match="@DateCreatedDoc|@DateCreated|@DateRemoved|@DateExpiry|@Date|doc:Date|kv:RegDate|kv:Started|kv:Stopped">
		<xsl:value-of select="substring(.,9,2)"/>.<xsl:value-of select="substring(.,6,2)"/>.<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	<xsl:template match="kv:Encumbrance">
		<xsl:if test="not(string(kv:Name)) or (starts-with(kv:Type, '022004'))">
			<xsl:variable name="nazn" select="document('schema/KVZU_v07/SchemaCommon/dEncumbrances_v03.xsd')"/>
			<xsl:variable name="kod_nazn" select="kv:Type"/>
			<xsl:value-of select="$nazn//xs:enumeration[@value=$kod_nazn]/xs:annotation/xs:documentation"/>
		</xsl:if>
		<xsl:if test="string(kv:Name)">
			<xsl:value-of select="concat(', ', kv:Name)"/>
		</xsl:if>
		<xsl:if test="kv:OwnersRestrictionInFavorem">
			<xsl:text>, </xsl:text>
			<xsl:for-each select="kv:OwnersRestrictionInFavorem/kv:OwnerRestrictionInFavorem">
				<xsl:apply-templates select="." mode="seq"/>
				<xsl:if test="position()!=last()">, </xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="string(kv:AccountNumber) or string(kv:CadastralNumberRestriction)">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="kv:AccountNumber|kv:CadastralNumberRestriction"/>
		</xsl:if>
		<xsl:if test="kv:Document">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="kv:Document/doc:Name"/>
			<xsl:if test="not(string(kv:Document/doc:Name))">
				<xsl:variable name="var" select="document('schema/KVZU_v07/SchemaCommon/dAllDocumentsOut_v03.xsd')"/>
				<xsl:variable name="kod" select="kv:Document/doc:CodeDocument"/>
				<xsl:value-of select="$var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
			</xsl:if>
			<xsl:if test="string(kv:Document/doc:Number)">
				<xsl:text> </xsl:text>№ <xsl:value-of select="kv:Document/doc:Number"/>
			</xsl:if>
			<xsl:if test="string(kv:Document/doc:Date)">
				<xsl:text> </xsl:text>от
				<xsl:apply-templates select="kv:Document/doc:Date"/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="kv:Duration">
			<xsl:text>, срок действия: </xsl:text>
			<xsl:apply-templates select="kv:Duration/kv:Started"/>
			<xsl:if test="string(kv:Duration/kv:Stopped)">
				<xsl:text> - </xsl:text>
				<xsl:apply-templates select="kv:Duration/kv:Stopped"/>
			</xsl:if>
			<xsl:if test="string(kv:Duration/kv:Term)">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="kv:Duration/kv:Term"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:OwnerRestrictionInFavorem" mode="seq">
		<xsl:if test="kv:Person">
			<xsl:value-of select="kv:Person/kv:FamilyName"/>
			<xsl:text> </xsl:text>
			<xsl:if test="string(kv:Person/kv:FirstName)">
				<xsl:value-of select="substring(kv:Person/kv:FirstName,1,1)"/>.
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:if test="string(kv:Person/kv:Patronymic)">
				<xsl:value-of select="substring(kv:Person/kv:Patronymic,1,1)"/>.
			</xsl:if>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:if test="string(kv:Organization/kv:Name)">
			<xsl:value-of select="kv:Organization/kv:Name"/>
		</xsl:if>
		<xsl:if test="string(kv:Governance/kv:Name)">
			<xsl:value-of select="kv:Governance/kv:Name"/>
		</xsl:if>
		<xsl:if test="not(string(kv:Person/kv:FamilyName)) and not(string(kv:Organization/kv:Name)) and not(string(kv:Governance/kv:Name))">
			<xsl:call-template name="procherk"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:Encumbrances">
		<xsl:for-each select="kv:Encumbrance">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>