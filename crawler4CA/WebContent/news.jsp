<%@ page import="testPkg.AppController" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        .negSentiment{
        color:red;
        }
        .posSentiment{
        color:Green;
        }
        .neutSentiment{
        color:blue;
        }
    </style>

</head>
<body style="background-color: #E6E6E6" onload="selectedValue()">
<img src="CoassetsLogo.png" alt = "CoAssets Logo" width="325" height="90">
<div align="center">
   <h1>CRAWLER</h1>
</div>
    <form method="get" action="crawler">
    <input type = "hidden" name = "store" value = "retrieve">
    <fieldset>
    <input type= "text" name = "news">
    <input type="submit" value="Go">
    </fieldset>
    <fieldset>
    <div class="frame" id="CoAssets Crawler">
        <c:forEach var="positiveNews" items="${requestScope.positiveNews}">
            <c:out value="${positiveNews}" />
        </c:forEach>
    </div>
    </fieldset>
</form>
</body>
</html>

