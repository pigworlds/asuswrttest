<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title><#Web_Title#> - <#EZQoS#></title>
<link rel="stylesheet" type="text/css" href="index_style.css"> 
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<style type="text/css">
.splitLine{
	background-image: url('/images/New_ui/export/line_export.png');
	background-repeat: no-repeat;
	height: 3px;
	width: 100%;
}
.trafficIcons{
	width:56px;
	height:56px;
	background-image:url('/images/New_ui/networkmap/client-list.png');
	background-repeat:no-repeat;
	border-radius:10px;
	margin-left:10px;
	background-position:50% 61.10%;
}
.txNarrow{
	width:0;
	height:0;
	border-width:0 7px 10px 7px;
	border-style:solid;
	border-color:#444F53 #444F53 #93E7FF #444F53;
}
.rxNarrow{
	width:0;
	height:0;
	border-width:10px 7px 0 7px;
	border-style:solid;
	border-color:#93E7FF #444F53 #444F53 #444F53;
}
.barContainer{
	height:8px;
	padding:3px;
	background-color:#000;
	border-radius:10px;
}
.barContainer div{
	background-color:#93E7FF;
	height:8px;black;
	border-radius:5px;
}
#indicator_upload, #indicator_download{
	-webkit-transform:rotate(-123deg);
    -moz-transform:rotate(-123deg);
    -o-transform:rotate(-123deg);
    msTransform:rotate(-123deg);
    transform:rotate(-123deg);
}
#appTrafficDiv{
	margin-top: 10px;
	width:99%;
	height:510px;
	background-color:#444f53;
	border-radius:10px;
	margin-left:4px;
	font-size:12px;
	font-family: Lucida Console;
	overflow:auto;
}
#appTrafficDiv div table:hover{
	cursor: pointer;
	color: #000;
	background-color: #66777D;
	font-weight: bolder;
}
.appName{
	width:180px;
	font-size:14px;
}
.trafficNum{
	position:absolute;
	font-size:24px;
	text-align:center;
	width:60px;
	font-family: Lucida Console;
	margin:147px 0px 0px 187px;
}
.speedMeter{
	background-image:url('images/New_ui/speedmeter.png');
	height:188px;
	width:270px;
	background-repeat:no-repeat;
	margin:-10px 0px 0px 70px
}
.speedIndictor{
	background-image:url('images/New_ui/indicator.png');
	position:absolute;
	height:100px;
	width:50px;
	background-repeat:no-repeat;
	margin:-110px 0px 0px 194px;
}
</style>
<script type="text/javascript" src="/detect.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script>
var $j = jQuery.noConflict();

var Param = {
	PEAK: 1024*100,
}

function initial(){
	show_menu();
	genClientListOption();
}

function drawTraffic(retObj){
	var converPercent = function(val){
		return ((val/Param.PEAK)*100) < 1 ? 1 : ((val/Param.PEAK)*100) ; 
	}

	var converUnit = function(val){
		if(val > 1024*1024)
			return (val/(1024*1024)).toFixed(2) + " MB";
		else
			return (val/1024).toFixed(2) + " KB";
	}

	var retBarHTML = function(val, narrow){
		var htmlCode = "";
		htmlCode += '<tr><td style="width:385px"><div class="barContainer"><div style="width:';
		htmlCode += converPercent(val);
		htmlCode += '%;"></div></div></td><td style="text-align:right;"><div style="width:80px;">';
		htmlCode += converUnit(val);
		htmlCode += '</div></td><td style="width:20px;"><div class="' + narrow + 'Narrow"></div></td></tr>';
		return htmlCode;
	}

	document.getElementById("appTrafficDiv").innerHTML = "";
	for(var i in retObj){
		var clientCode = "";
		if(i == 'devinfo'){ 
			calTotalTraffic(retObj[i].tx, 'tx');
			calTotalTraffic(retObj[i].rx, 'rx');
			continue;
		}

		Param.PEAK = (retObj[i].tx > Param.PEAK) ? retObj[i].tx : Param.PEAK;
		Param.PEAK = (retObj[i].rx > Param.PEAK) ? retObj[i].rx : Param.PEAK;

		// init an APP
		clientCode += '<div><table><tr>';

		// Icon
		clientCode += '<td style="width:70px;"><div class="trafficIcons" style="background-image:url(\'http://';
		clientCode += clientList[document.getElementById("clientListOption").value].ip + ':' + clientList[document.getElementById("clientListOption").value].callback + '/' + retObj[i].idx;
		clientCode += '\');"></div></div></td>';

		// Name
		clientCode += '<td class="appName" title="' + i + '">' + i + '</td>';

		// traffic
		clientCode += '<td><div><table>';
		clientCode += retBarHTML(retObj[i].tx, "tx");
		clientCode += retBarHTML(retObj[i].rx, "rx");
		clientCode += '</table></div></td>';

		// end
		clientCode += '</tr></table><div class="splitLine"></div></div>';
		$j("#appTrafficDiv").append(clientCode);
	}
}

function ajaxCallJsonp(target){    
    var data = $j.getJSON(target, {format: "json"});

    data.success(function(msg){
    	drawTraffic(msg);
    	setTimeout('getCallback(document.getElementById("clientListOption").value);', 3000);
    });

    data.error(function(msg){
		document.getElementById("appTrafficDiv").innerHTML = "<br/><div style='text-align:center;color:#FC0'>Error on fetch data!</div>";
    });
}

function getCallback(mac){
	ajaxCallJsonp("http://" + clientList[mac].ip + ":" + clientList[mac].callback + "/callback.asp?output=netdev&jsoncallback=?");
}

function genClientListOption(){
	if(clientList.length == 0){
		setTimeout("genClientListOption();", 500);
		return false;
	}

	document.getElementById("clientListOption").options.length = 0;
	for(var i=0; i<clientList.length; i++){
		var clientObj = clientList[clientList[i]];

		if(clientObj.callback == "")
			continue;

		var newItem = new Option(clientObj.name, clientObj.mac);
		document.getElementById("clientListOption").options.add(newItem); 
	}

	getCallback(document.getElementById("clientListOption").value);
}

function calTotalTraffic(val, narrow){
	var traffic_mb = val/1024/1024;
	var angle = 0;
	var rotate = "";

	document.getElementById(narrow + '_speed').innerHTML = traffic_mb.toFixed(2);

	if(traffic_mb <= 1){
		angle = (traffic_mb*33) + (-123);
	}
	else if(traffic_mb > 1 && traffic_mb <= 5){
		angle = ((traffic_mb-1)/4)*32 + 33 +(-123);	
	}
	else if(traffic_mb > 5 && traffic_mb <= 10){
		angle = ((traffic_mb - 5)/5)*25 + (33 + 32) + (-123);
	}
	else if(traffic_mb > 10 && traffic_mb <= 20){
		angle = ((traffic_mb - 10)/10)*32 + (33 + 32 + 25) + (-123)
	}
	else if(traffic_mb > 20 && traffic_mb <= 30){
		angle = ((traffic_mb - 20)/10)*31 + (33 + 32 + 25 + 32) + (-123);	
	}
	else if(traffic_mb > 30 && traffic_mb <= 50){
		angle = ((traffic_mb - 30)/20)*28 + (33 + 32 + 25 + 32 + 31) + (-123);	
	}
	else if(traffic_mb > 50 && traffic_mb <= 75){
		angle = ((traffic_mb - 50)/25)*30 + (33 + 32 + 25 + 32 + 31 + 28) + (-123);
	}
	else if(traffic_mb > 75 && traffic_mb <= 100){
		angle = ((traffic_mb - 75)/25)*34 + (33 + 32 + 25 + 32 + 31 + 28 + 30) + (-123);
	}
	else{
		angle = 123;		
	}
	
	rotate = "rotate("+angle.toFixed(1)+"deg)";
	$j('#indicator_' + narrow).css({
		"-webkit-transform": rotate,
		"-moz-transform": rotate,
		"-o-transform": rotate,
		"msTransform": rotate,
		"transform": rotate
	});
}
</script>
</head>
<body onload="initial();" onunload="unload_body();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="current_page" value="AiStream_ROG.asp">
<input type="hidden" name="next_page" value="AiStream_ROG.asp">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="action_wait" value="">
<input type="hidden" name="flag" value="">
<table class="content" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>
		<td valign="top" width="202">
			<div id="mainMenu"></div>
			<div id="subMenu"></div>
		</td>	
		<td valign="top">
			<div id="tabMenu" class="submenuBlock"></div>		
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" valign="top">				
						<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"  class="FormTitle" id="FormTitle">		
							<tr>
								<td bgcolor="#4D595D" colspan="3" valign="top">
									<div>&nbsp;</div>
									<div class="formfonttitle"><#Menu_TrafficManager#> - ROG First</div>

									<div style="margin-top:-30px;text-align: right;">
										<span style="font-size:14px;font-family: Lucida Console;">Please select: </span>
										<select id="clientListOption" class="input_option" onchange="getCallback(this.value);"></select>	
									</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>

									<div>
										<table style="width:99%;">
											<tr>
												<td style="width:50%;">
													<div class="formfonttitle" style="margin-bottom:0px;">Upload</div>
													<div class="trafficNum" id="tx_speed">0.00</div>
													<div class="speedMeter"></div>
													<div class="speedIndictor" id="indicator_tx"></div>
												</td>
												<td>	
													<div class="formfonttitle" style="margin-bottom:0px;">Download</div>
													<div class="trafficNum" id="rx_speed">0.00</div>
													<div class="speedMeter"></div>
													<div class="speedIndictor" id="indicator_rx"></div>
												</td>
											</tr>
										</table>	
									</div>

									<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
										<div id="appTrafficDiv">
											<div style="width: 100%;text-align: center;margin-top: 50px;">
												<img src="/images/InternetScan.gif" style="width: 50px;">
											</div>
										</div>
									</table>
								</td>
							</tr>
						</table>
					</td>  
				</tr>
			</table>
			<!--===================================End of Main Content===========================================-->
		</td>		
	</tr>
</table>
<div id="footer"></div>
</body>
</html>