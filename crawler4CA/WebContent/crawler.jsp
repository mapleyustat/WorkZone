<%@ page import="test.java.edu.uci.ics.crawler4j.examples.basic.fileWorker" %>
<%--
  Created by IntelliJ IDEA.
  User: Vignesh
  Date: 16/5/2014
  Time: 10:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="styles.css"/>
<html>
<head>
    <title>CoAssets Crawler</title>
    <style type="text/css">
        .frame {
            font:12px arial;
            width:100%;
            height:375;
            border:none;
            overflow:scroll;
            border:1px solid black;
            padding:5;
        }
    </style>

</head>
<body style="background-color: gray" onload="selectedValue()">
<img src="CoassetsLogo.png" alt = "CoAssets Logo" width="325" height="90">
<div align="center">
   <h1>CRAWLER</h1>
</div>
    <form method="get" action="crawler">
    <input type="hidden" name="store" value="store">
    <fieldset>
        Provide Only IProperty News URL to Crawl : <input type="text" name="urlToCrawl"/>
        <br>
    <input type="submit" value="go" />
    </fieldset>
    <fieldset onload="scroll()">
    <div class="frame" id="CoAssets Crawler">
        ${requestScope.crawlingDone}
    </div>
    </fieldset>
</form>
</body>
</html>

