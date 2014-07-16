<%--<%@ page import="testPkg.AppController" %>--%>
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
<div>
<img src="CoassetsLogo.png" alt = "CoAssets Logo" width="325" height="90">
</div>
<div style ="font:12px; padding:0px 0px 0px 5px">
   PROPERTY PORTAL WATCH - Company News
</div>
<div align="center" >
       <h1 style="font-family: 'Lucida Sans Unicode', 'Lucida Grande', sans-serif; ">SENTIMENT ANALYZER FOR PROPERTY NEWS <sup>&#945</sup></h1>
</div>

    <form method="get" action="crawler">

    <input type = "hidden" name = "store" value = "retrieve">
    <div style="padding: 5px 5px 5px 5px;border:1px solid black; ">
    <input type= "text" name = "news">
    <input type="submit" value="Search" size = "10">
        </div>
<br>
    <fieldset>
    <div>

   <p style="font-size: 18px;"><b>  POSITIVE: </b></p>
    <c:set var="positiveNews" scope="session" value="${requestScope.positiveNews}"/>
    <c:if test="${positiveNews != null}">
        <c:forEach var="positiveNews" items="${requestScope.positiveNews}">
            <p style="font-size: 18px; "><c:out value="${positiveNews}" /></p>
        </c:forEach>
    </c:if>
    <c:if test="${positiveNews == null}">
        <div>
            <p style="font-size: 18px; ">   Not Available</p>
        </div>

    </c:if>

        <br>
        <p style="font-size: 18px;"> <b>NEGATIVE :</b></p>
        <c:set var="negativeNews" scope="session" value="${requestScope.negativeNews}"/>
        <c:if test="${negativeNews != null}">
            <c:forEach var="negativeNews" items="${requestScope.negativeNews}">
        <p style="font-size: 18px; "> <c:out value="${negativeNews}" /></p>
            </c:forEach>
        </c:if>
        <c:if test="${negativeNews == null}">
            <div>
                <p style="font-size: 18px; ">   Not Available</p>
            </div>

        </c:if>
        <br>
        <p style="font-size: 18px;"> <b> NEUTRAL :</b></p>
        <c:set var="neutralNews" scope="session" value="${requestScope.neutralNews}"/>
        <c:if test="${neutralNews != null}">
            <c:forEach var="neutralNews" items="${requestScope.neutralNews}">
        <p style="font-size: 18px; ">  <c:out value="${neutralNews}" /></p>
            </c:forEach>
        </c:if>
        <c:if test="${neutralNews == null}">
            <div>
                <p style="font-size: 18px; ">Not Available</p>
            </div>
        </c:if>


        <c:set var="vnegativeNews" scope="session" value="${requestScope.vnegativeNews}"/>
        <c:if test="${vnegativeNews != null}">
            <br>
        <p style="font-size: 18px;"> <b>    <c:out value="${requestScope.vnegative}" /> : </b></p>
            <c:forEach var="vnegativeNews" items="${requestScope.vnegativeNews}">
        <p style="font-size: 18px; "> <c:out value="${vnegativeNews}" /></p>
            </c:forEach>
        </c:if>


        <c:set var="vpositiveNews" scope="session" value="${requestScope.vpositiveNews}"/>
        <c:if test="${vpositiveNews != null}">
            <br>
        <p style="font-size: 18px;"> <b>      <c:out value="${requestScope.vpositive}" /> :</b></p>
            <c:forEach var="vpositiveNews" items="${requestScope.vpositiveNews}">
        <p style="font-size: 18px; ">  <c:out value="${vpositiveNews}" /></p>
            </c:forEach>
        </c:if>

    </div>
    </fieldset>
</form>
<div align="right">
    News Courtesy : www.propertyportalwatch.com
</div>
</body>
</html>

