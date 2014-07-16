<%@ page import="java.util.ArrayList" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page import="testPkg.AppController" %>
<%--
  Created by IntelliJ IDEA.
  User: Vignesh
  Date: 17/6/2014
  Time: 12:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<c:url value='/resources/css/foundation.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/customized.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/archtek.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/font-awesome.min.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/isotope.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/jquery.fancybox-1.3.4.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/validationEngine.jquery.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/archtek-init.css' />" rel="stylesheet">

<link href='https://fonts.googleapis.com/css?family=Roboto:100,300,400,700|Titillium+Web:400,600' rel='stylesheet' type='text/css'>
<link href="<c:url value='/resources/css/reset.css' />" rel="stylesheet">


<link href="<c:url value='/resources/js/custom.modernizr.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery-1.9.1.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.scrollUp.min.js' />" rel="stylesheet">

<link href="<c:url value='/resources/js/jquery-1.9.1.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery-ui-1.10.2.custom.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.backstretch.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/foundation.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/superfish.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/supersubs.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.hoverIntent.minified.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.fancybox-1.3.4.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.transit.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.touchSwipe.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.carouFredSel-6.1.0-packed.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.hoverdir.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.easing.1.3.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.isotope.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.validationEngine-en.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery.easing.1.3.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery-1.9.0.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jssor.slider.min.js' />" rel="stylesheet">
<link href="<c:url value='/resources/js/jquery-jscroll-min.js' />" rel="stylesheet">



<link href="<c:url value='/resources/js/archtek.js' />" rel="stylesheet">
<link href="<c:url value='/resources/css/foundation.min.css' />" rel="stylesheet">
<script src="<c:url value='/resources/js/jquery.js' />" > </script>
<script src="<c:url value='/resources/js/foundation.js' />"> </script>
<script src="<c:url value='/resources/js/foundation.min.js' />"> </script>

    <title>Highcharts Example</title>

    <script src="<c:url value='http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js' />"> </script>
    <script type="text/javascript">
        $(function () {
            // get the jQuery wrapper
            var $report= $('#report');

            $('#container').highcharts({

                chart: {
                    type: 'scatter',
                    zoomType: 'xy'
                },

                title: {
                    text: 'News Sentiment Analyzer'
                },
                xAxis: {
                    title: {
                        enabled: true,
                        text: 'Date'
                    },
                    type: 'datetime',
                    startOnTick: true,
                    endOnTick: true,
                    showLastLabel: true

                },
                yAxis: {
                    title: {
                        text: 'Sentiment'
                    }
                },
                        plotOptions:{
                            series: {
                                cursor: 'pointer',
                                point: {
                                    events: {
                                        click: function() {
                                            var name = this.series.name;

                                            <% ArrayList posTitle = (ArrayList)request.getAttribute("positiveTitle");
                                                            ArrayList posNews = (ArrayList)request.getAttribute("positiveNews");
                                                            ArrayList negTitle = (ArrayList)request.getAttribute("negativeTitle");
                                                            ArrayList negNews = (ArrayList)request.getAttribute("negativeNews");
                                                            ArrayList neutTitle = (ArrayList)request.getAttribute("neutralTitle");
                                                            ArrayList neutNews = (ArrayList)request.getAttribute("neutralNews");
                                                            System.out.println("asdf"+negNews);

                                                            if(posTitle!=null || posNews!=null || negNews!=null || negTitle!=null || neutTitle!=null || neutNews!=null ){
                                                            if(negTitle.get(0).equals("NoValue")){

                                                            }else{

                                                            }
                                                            %>
                                            if(this.series.name=="Positive") {
                                                            <%if(posTitle.get(0).equals("NoValue")){
                                                                //do nothing
                                                            }else{
                                                            %>
                                                $report.html('<table>'+
                                                             '<tr><td><b>Sentiment</b></td><td><b>News Title</b></td><td><b>News</b></td><td><b>Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<posTitle.size();tempTitle++){%>
                                                             '<tr><td>'+this.series.name+'</td><td>'+"<%=posTitle.get(tempTitle)%>"+'</td><td>'+"<%=posNews.get(tempTitle)%>"+'</td><td>positive neutral negative</td></tr>'+
                                                        <%}%>
                                                             '</table>');
                                                            <%}%>
                                            }
                                            else if(this.series.name=="Negative") {
                                                            <%if(negTitle.get(0).equals("NoValue")){
                                                                //do nothing
                                                            }else{
                                                            %>
                                                $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News Title</b></td><td><b>News</b></td><td><b>Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<negTitle.size();tempTitle++){%>
                                                        '<tr><td>'+this.series.name+'</td><td>'+"<%=negTitle.get(tempTitle)%>"+'</td><td>'+"<%=negNews.get(tempTitle)%>"+'</td><td>positive neutral negative</td></tr>'+
                                                        <%}%>
                                                        '</table>');
                                                            <%}%>
                                            }
                                            else if(this.series.name=="Neutral"){
                                                             <%if(neutTitle.get(0).equals("NoValue")){
                                                                //do nothing
                                                            }else{
                                                            %>
                                                $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News Title</b></td><td><b>News</b></td><td><b>Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<neutTitle.size();tempTitle++){%>
                                                        '<tr><td>'+this.series.name+'</td><td>'+"<%=neutTitle.get(tempTitle)%>"+'</td><td>'+"<%=neutNews.get(tempTitle)%>"+'</td><td>positive neutral negative</td></tr>'+
                                                        <%}%>
                                                        '</table>');
                                                            <%}%>
                                            }
                                            else{
                                                $report.html('Not available - Please provide the period');
                                            }

                                            <%}%>




                                        }
                                    }
                                },
                                marker: {
                                    lineWidth: 1
                                }
                            }
                        },

                series:  [
                    <%ArrayList myList = (ArrayList)request.getAttribute("positiveDate");
                        System.out.println("gsjdfgksdf  "+myList);
                        if(myList!=null){
                    %>
                    <%
                if(posNews.get(0).equals("NoValue"))
                {
                    //do nothing
                }
                else{
                %>
                    {
                    name: 'Positive',
                    color: '#66FF66',
                    data: [
                        <%
                        ArrayList posTitleList = (ArrayList)request.getAttribute("positiveTitle");


                        int j=0;
                        int k=1;
                        int f =0;
                        String val = "";
                        String[] splitVal = new String[3];


                        for(j=0;j<myList.size();j++){
                            val = myList.get(j).toString();
                            splitVal = val.split("-");
                            System.out.println("vvvvvvvvvvvvvvvv  "+val);
                            System.out.println("spspspspspsspspsp  "+splitVal[0]);
                            System.out.println("spspspspspsspspsp  "+splitVal[1]);
                            System.out.println("spspspspspsspspsp  "+splitVal[2]);
                            if(k < myList.size()){
                                %> [Date.UTC(<%=splitVal[0]%>, <%=splitVal[1]%>, <%=splitVal[2]%>,<%=j+f%>), 0.5], <%
                        }
                        else{
                    %>

                        [Date.UTC(<%=splitVal[0]%>, <%=splitVal[1]%>, <%=splitVal[2]%>,,<%=j+f%>), 0.5]

                        <%}f=f+3;}%>
                    ]

                },<%}%>
                        <%}else {%>{
                        name: 'Positive',
                        color: '#66FF66',
                        data:[
                            [Date.UTC(2014,1,1),0]
                        ]

                    },<% }%>

                    <%
                ArrayList myListneg = (ArrayList)request.getAttribute("negativeDate");
                    if(myListneg !=null){
                %>

                    <%
                    if(negNews.get(0).equals("NoValue"))
                    {
                        //do nothing
                    }
                    else{
                    %>
                    {

                    name: 'Negative',
                    color: 'rgba(223, 83, 83, .5)',
                    data: [
                        <% int jneg=0;
                        int kneg=1;
                        int fneg =0;
                        String valneg = "";
                        String[] splitValneg = new String[3];

                        for(jneg=0;jneg<myListneg.size();jneg++){
                            valneg = myListneg.get(jneg).toString();
                            splitValneg = valneg.split("-");
                            System.out.println("vvvvvvvvvvvvvvvv  "+valneg);
                            System.out.println("spspspspspsspspsp  "+splitValneg[0]);
                            System.out.println("spspspspspsspspsp  "+splitValneg[1]);
                            System.out.println("spspspspspsspspsp  "+splitValneg[2]);
                            if(kneg < myListneg.size()){
                                %> [Date.UTC(<%=splitValneg[0]%>, <%=splitValneg[1]%>, <%=splitValneg[2]%>,<%=jneg+fneg%>), -0.5], <%
                        }
                        else{
                    %>

                        [Date.UTC(<%=splitValneg[0]%>, <%=splitValneg[1]%>, <%=splitValneg[2]%>,<%=jneg+fneg%>), -0.5]

                        <%}fneg=fneg+3;}%>
                    ]

                },<%}%>
                        <%}else {
                        %>{
                        name: 'Negative',
                        color: 'rgba(223, 83, 83, .5)',
                        data:[
                            [Date.UTC(2014,1,1),0]
                        ]

                    },<% }%>


                    <% ArrayList myListneut = (ArrayList)request.getAttribute("neutralDate");
                if(myListneut!=null){%>
                  <%
                  if(neutNews.get(0).equals("NoValue"))
                  {
                      //do nothing
                  }
                  else{
                  %>
                    {

                    name: 'Neutral',
                    color: '#40A0A0',
                    data: [
                        <% int jneut=0;
                        int kneut=1;
                        int fneut =0;
                        String valneut = "";
                        String[] splitValneut = new String[3];

                        for(jneut=0;jneut<myListneut.size();jneut++){
                            valneut = myListneut.get(jneut).toString();
                            splitValneut = valneut.split("-");
                            System.out.println("vvvvvvvvvvvvvvvv  "+valneut);
                            System.out.println("spspspspspsspspsp  "+splitValneut[0]);
                            System.out.println("spspspspspsspspsp  "+splitValneut[1]);
                            System.out.println("spspspspspsspspsp  "+splitValneut[2]);
                            if(kneut < myListneut.size()){
                                %> [Date.UTC(<%=splitValneut[0]%>, <%=splitValneut[1]%>, <%=splitValneut[2]%>,<%=jneut+fneut%>), 0], <%
                        }
                        else{
                    %>

                        [Date.UTC(<%=splitValneut[0]%>, <%=splitValneut[1]%>, <%=splitValneut[2]%>,<%=jneut+fneut%>), 0]

                        <%}fneut=fneut+3;}%>
                    ]

                }<%}%>
                        <%}else {%>{
                        name: 'Neutral',
                        color: '#40A0A0',
                        data:[
                                [Date.UTC(2014,1,1),0]
                        ]


                    }<% }%>

                ]

                 }
               );

        });
    </script>
    <style>
        body {
            background: #efefee;
            cursor: auto;
        }

    </style>


</head>
<body class="body" style="zoom:1">
<div id="header-container" class="content-width" style="top:0px;">
    <div id="logo-wrapper" style="position: static; padding-bottom: 17px; bottom: 0px;">
        <div id="logo">
            <a href="http://www.coassets.com" >
                <img src="CoassetsLogo.png" width="140">
            </a>
            <p style="display: block;">
                Matching Funders with Opportunities
            </p>
        </div>

    </div>
    <div style="display:inline-block;width:700px;">
       <p style="color:#f5f5f5 ;align:center; padding:60px 0px 0px 80px; font-size: 35;"> News Analytics</p>
    </div>

</div>

<script src="<c:url value='/resources/js/highcharts.js' />"> </script>
<script src="<c:url value='/resources/js/exporting.js' />"> </script>
<script src="<c:url value='/resources/js/highcharts-more.js' />"> </script>

<div class="home-slider-item" style="position: absolute; z-index: 1; width: 1903px; opacity: 1; background: none;">
    <div class="backstretch" style="left: 0px; top: 0px; overflow: hidden; margin: 0px; padding: 0px; height: 624px; width: 1903px; z-index: -999998; position: absolute;"><img src="analytics 3.jpg" style="position: absolute; margin: 0px; padding: 0px; border: none; width: 1960px; height: 624px; max-width: none; z-index: -999999; left: -28.5px; top: 0px;"></div>
</div>

<div id="content-container" class="content-width">
        <div class="large-4 columns" style="width:70%; padding-top:630px;" >
            <div class="module" style="padding: 10px 10px 10px 10px">
            <div id="container" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
             </div>
         </div>
<div class="large-4 columns" style="width:30%;padding-top:630px;">
    <div class="module" style="padding: 10px 10px 10px 10px">
        <div>
            <form method="get" action="crawler">

                <input type = "hidden" name = "store" value = "date">
                    From: <input type="date" name="from">
                    To: <input type="date" name="to">
                    <input type="submit" value="Search" size = "10" class="flat button" style ="padding-top: 0.3rem;padding-bottom: 0.45rem;">

            </form>

        </div>
    </div>
</div>
<c:set var="positiveNews" scope="session" value="${requestScope.positiveNews}"/>
<c:if test="${positiveNews != null}">
    <div class="large-4 columns" style="width:100%;" >
        <div class="module" style="padding: 10px 10px 10px 10px">

            <div id="report"></div>

        </div>
    </div>
</c:if>
    </div>



</body>
</html>
