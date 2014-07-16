<%@ page import="testPkg.AppController" %>
<%--
  Created by IntelliJ IDEA.
  User: Vignesh
  Date: 13/6/2014
  Time: 3:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="<c:url value='/resources/css/foundation.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/foundation.min.css' />" rel="stylesheet">
<script src="<c:url value='/resources/js/jquery.js' />" > </script>
<script src="<c:url value='/resources/js/foundation.js' />"> </script>
<script src="<c:url value='/resources/js/foundation.min.js' />"> </script>

<style>
    .panel{
        background: #EEEEEE;
        height: 6%;
        padding-top: 5px;

    }

    .th {
        line-height: 0;
        display: inline-block;
        border: none;
        max-width: 10%;
        box-shadow: none;
        transition:none;
        height: 1%;
        border-radius: 1px;


    }

    .section-title{
        margin-bottom: 10px;
        font-family: "Sentinel SSm A","Sentinel SSm B","Georgia",serif;
        font-size: 24px;
        font-weight: 500;
        letter-spacing: -1px;
        line-height: 1;
        text-align: left;
        width: auto;

    }
    .panel.callout.radius{
        width:450;
        height:450;
        background-color: #EEEEEE;
        border-color: #006699;
    }

    .customPanel{
        margin: 0px;
        padding: 0px;
        background: transparent;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        color: #333333;
        font-size: 12px;
    }



</style>


<html>

<head>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var positiveNewsCount = <c:out value="${requestScope.numPosNews}" />;
            var negativeNewsCount = <c:out value="${requestScope.numNegNews}" />;
            var neutralNewsCount = <c:out value="${requestScope.numNeutNews}" />;
            var VposNewsCount = <c:out value="${requestScope.numVposNews}" />;
            var VnegNewsCount = <c:out value="${requestScope.numVnegNews}" />;
            alert(positiveNewsCount);

            var data = google.visualization.arrayToDataTable([
                ['Sentiment', 'Count'],
                ['Positive',    positiveNewsCount],
                ['Negative',      negativeNewsCount],
                ['Neutral',  neutralNewsCount],
                ['Very Positive', VposNewsCount],
                ['Very Negative', VnegNewsCount]
            ]);

            var options = {
                title: 'News Sentiment Analyzer',
                slices: [{color: '#5CE65C'},{color:'#FF6666'}, {color:'#5CADFF'}, {color:'#009933'}, {color: '#FF0000'}],
                pieSliceText: {color: 'black'},
                chartArea:{left:20,top:0,width:'100%',height:'100%',backgroundColor:'#EEEEEE'},
                backgroundColor:{fill:'#EEEEEE'}



            };
                var chart = new google.visualization.PieChart(document.getElementById('piechart'));
                chart.draw(data, options);


        }


    </script>
    <title></title>
</head>
<body background="#555a5d">

<div class="panel">
    <a class="th [radius]" href="http://www.coassets.com">
        <img src="CoassetsLogo.png">
    </a>
    <h3 style="display: inline-block; padding-top: 4px">&nbsp;Analytics</h3>
</div>
<form method="get" action="crawler">

    <input type = "hidden" name = "store" value = "retrieve">
    <div style="padding: 5px 5px 5px 5px;border:1px solid black; ">
        <input type= "text" name = "news">
        <input type="submit" value="Search" size = "10">
    </div>
</form>
<div style="padding-left: 25%">
<div class="panel callout radius">
    <div id="piechart" style="width: 400px; height: 400px; align-content: center" ></div>
</div>
</div>


</body>
</html>
