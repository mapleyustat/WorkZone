<%@ page import="java.util.ArrayList" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page import="testPkg.AppController" %>
<%@ page import="org.joda.time.LocalDate" %>
<%@ page import="java.util.Collections" %>
<%@ page import="stanTagger.AmazonDynamoDBSample" %>
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
<link href="<c:url value='/resources/css/validationEngine.jquery.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/archtek-init.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/foundation.min.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/general_enclosed_foundicons.css' />" rel="stylesheet">
<link href="<c:url value='/resources/css/jquery-ui.css' />" rel="stylesheet">


<link href='https://fonts.googleapis.com/css?family=Roboto:100,300,400,700|Titillium+Web:400,600' rel='stylesheet' type='text/css'>


<script src="<c:url value='/resources/js/custom.modernizr.js' />"> </script>
<%--<script src="<c:url value='/resources/js/jquery.scrollUp.min.js' />"> </script>--%>
<%--<script src="<c:url value='/resources/js/jquery.backstretch.min.js' />"> </script>--%>
<%--<script src="<c:url value='/resources/js/jquery-1.9.1.min.js' />"> </script>--%>
<script src="<c:url value='/resources/js/archtek.js' />"> </script>
<script src="<c:url value='/resources/js/foundation.js' />"> </script>
<script src="<c:url value='/resources/js/foundation.min.js' />"> </script>
<script src="<c:url value='/resources/js/foundation.dropdown.js' />"> </script>
<script src="<c:url value='/resources/js/foundation.abide.js' />"> </script>
<script src="<c:url value='/resources/js/jquery-1.11.1.js' />"> </script>


<title>CoAssets Analytics</title>

<%--<script src="<c:url value='http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js' />"> </script>--%>
<script src="<c:url value='/resources/js/jquery-ui.js' />"> </script>
<%--call --%>
<% String text = request.getParameter("input");
    String sentVal = request.getParameter("output");
    if(text!=null && sentVal!=null) {
        try {
            String message = AmazonDynamoDBSample.updateOpinion(text, sentVal);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<%--Ajax script--%>
<script type="text/javascript">
    $(document).ready(function() {
        fire_on_event();
    });
    function fire_on_event(){
        $('.positive').on('change',function ()
        {
            if (confirm("Are you sure ! You want to update?") == true) {
                //updating
                $.ajax({
                    type: "post",
                    url: "mainpageForCombined.jsp", //this is my servlet
                    data: {
                        input: $(this).data('news'),
                        output: $(this).val()
                    },
                    success: function(){
                        $('#output').html('<i class="foundicon-checkmark"></i>');
//                    $('#report').reload(true);
                    }
                });
            } else {
                $('#output').html('<i class="foundicon-remove"></i>');
//                $('#report').reload();
            }
        });
        $('.negative').on('change',function ()
        {   if (confirm("Are you sure ! You want to update?") == true) {
            //updating
            $.ajax({
                type: "post",
                url: "mainpageForCombined.jsp", //this is my servlet
                data: {
                    input: $(this).data('news'),
                    output: $(this).val()
                },
                success: function(){
                    $('#output').html('<i class="foundicon-checkmark"></i>');
                }
            });
        } else {
            $('#output').html('<i class="foundicon-remove"></i>');
        }
        });
        $('.neutral').on('change',function ()
        {   if (confirm("Are you sure ! You want to update?") == true) {
            //updating
            $.ajax({
                type: "post",
                url: "mainpageForCombined.jsp", //this is my servlet
                data: {
                    input: $(this).data('news'),
                    output: $(this).val()
                },
                success: function(){
                    $('#output').html('<i class="foundicon-checkmark"></i>');
                }
            });
        } else {
            $('#output').html('<i class="foundicon-remove"></i>');
        }
        });
        $('.veryNegative').on('change',function ()
        {   if (confirm("Are you sure ! You want to update?") == true) {
            //updating
            $.ajax({
                type: "post",
                url: "mainpageForCombined.jsp", //this is my servlet
                data: {
                    input: $(this).data('news'),
                    output: $(this).val()
                },
                success: function(){
                    $('#output').html('<i class="foundicon-checkmark"></i>');
                }
            });
        } else {
            $('#output').html('<i class="foundicon-remove"></i>');
        }
        });
        $('.veryPositive').on('change',function ()
        {   if (confirm("Are you sure ! You want to update?") == true) {
            //updating
            $.ajax({
                type: "post",
                url: "mainpageForCombined.jsp", //this is my servlet
                data: {
                    input: $(this).data('news'),
                    output: $(this).val()
                },
                success: function(){
                    $('#output').html('<i class="foundicon-checkmark"></i>');
                }
            });
        } else {
            $('#output').html('<i class="foundicon-remove"></i>');
        }
        });
    }
    //    $(document).ready(function() {
    //        $('.check').on('change',function ()
    //        {   alert(this);
    //            $.ajax({
    //                type: "post",
    //                url: "mainPageForOpinion.jsp", //this is my servlet
    //                data: {
    //                    input: $('#id').val(),
    //                    output: $(this).val()
    //                },
    //                success: function(){
    //                    $('#output').html("Updated");
    //                }
    //            });
    //        });
    //    });

</script>
<script type="text/javascript">
$(function () {
    // get the jQuery wrapper
    var $report= $('#report');

    $('#container').highcharts({

                chart: {
                    type: 'bubble',
                    zoomType: 'xy'
                },

                title: {
                    text: 'News Sentiments - Daily view'
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
                tooltip:{
                    headerFormat: '<b>{series.name}</b><br>',
                    pointFormat: '{point.x:%e. %b}'
                },
                plotOptions:{
                    series: {
                        cursor: 'pointer',
                        point: {
                            events: {
                                click: function() {
                                    var name = this.series.name;
                                    function submitDB() {
                                        alert("in function!")
                                    }

                                    <% ArrayList posTitle = (ArrayList)request.getAttribute("positiveTitle");
                                                    ArrayList posNews = (ArrayList)request.getAttribute("positiveNews");
                                                    ArrayList posDate = (ArrayList)request.getAttribute("positiveDate");
                                                    ArrayList negTitle = (ArrayList)request.getAttribute("negativeTitle");
                                                    ArrayList negNews = (ArrayList)request.getAttribute("negativeNews");
                                                    ArrayList negDate = (ArrayList)request.getAttribute("negativeDate");
                                                    ArrayList neutTitle = (ArrayList)request.getAttribute("neutralTitle");
                                                    ArrayList neutNews = (ArrayList)request.getAttribute("neutralNews");
                                                    ArrayList neutDate = (ArrayList)request.getAttribute("neutralDate");
                                                    ArrayList vnegTitle = (ArrayList)request.getAttribute("vnegativeTitle");
                                                    ArrayList vnegNews = (ArrayList)request.getAttribute("vnegativeNews");
                                                    ArrayList vnegDate = (ArrayList)request.getAttribute("vnegativeDate");
                                                    ArrayList vposTitle = (ArrayList)request.getAttribute("vpositiveTitle");
                                                    ArrayList vposNews = (ArrayList)request.getAttribute("vpositiveNews");
                                                    ArrayList vposDate = (ArrayList)request.getAttribute("vpositiveDate");
                                                    ArrayList view = (ArrayList)request.getAttribute("view");
                                                    ArrayList posSource = (ArrayList)request.getAttribute("positiveSource");
                                                    ArrayList negSource = (ArrayList)request.getAttribute("negativeSource");
                                                    ArrayList neutSource = (ArrayList)request.getAttribute("neutralSource");
                                                    ArrayList vnegSource = (ArrayList)request.getAttribute("vnegativeSource");
                                                    ArrayList vposSource = (ArrayList)request.getAttribute("vpositiveSource");
                                                    ArrayList posOpinion = (ArrayList)request.getAttribute("positiveOpinion");
                                                    ArrayList negOpinion = (ArrayList)request.getAttribute("negativeOpinion");
                                                    ArrayList neutOpinion = (ArrayList)request.getAttribute("neutralOpinion");
                                                    ArrayList vnegOpinion = (ArrayList)request.getAttribute("vnegativeOpinion");
                                                    ArrayList vposOpinion = (ArrayList)request.getAttribute("vpositiveOpinion");
//                                                    System.out.println("neutralOpinion"+neutOpinion);


                                                    boolean noPos=false;
                                                    boolean noNeg=false;
                                                    boolean noNeut=false;
                                                    boolean noVneg=false;
                                                    boolean noVpos=false;
                                                    String replacingQuotes = "";




                                                    if(posTitle!=null || posNews!=null || negNews!=null || negTitle!=null || neutTitle!=null || neutNews!=null ||vnegTitle!=null||vnegNews!=null||vposTitle!=null||vposNews!=null||posDate!=null||negDate!=null||neutDate!=null||vposDate!=null||vnegDate!=null||
                                                    posOpinion!=null||negOpinion!=null||neutOpinion!=null||vnegOpinion!=null||vposOpinion!=null||posSource!=null||negSource!=null||neutSource!=null||vnegSource!=null||vposSource!=null){
                                                    if(negTitle.get(0).equals("NoValue")){

                                                    }else{

                                                    }
                                                    %>
                                    if(this.series.name=="Positive") {
                                        <%if(posTitle.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html(
                                                        '<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<posTitle.size();tempTitle++){
                                                            replacingQuotes= (String)posNews.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=posTitle.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=posDate.get(tempTitle)%>"+'</td><td><%=posSource.get(tempTitle)%></td><td><select class="positive" id="op<%=tempTitle%>" data-news="<%=posTitle.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5" selected="selected">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Negative") {
                                        <%if(negTitle.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<negTitle.size();tempTitle++){
                                                            replacingQuotes= (String)negNews.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=negTitle.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=negDate.get(tempTitle)%>"+'</td><td><%=negSource.get(tempTitle)%></td><td><select class="negative" id="op<%=tempTitle%>" data-news="<%=negTitle.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5" selected="selected">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Neutral"){
                                        <%if(neutTitle.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<neutTitle.size();tempTitle++){
                                                            replacingQuotes= (String)neutNews.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=neutTitle.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=neutDate.get(tempTitle)%>"+'</td><td><%=neutSource.get(tempTitle)%></td><td><select class="neutral" id="op<%=tempTitle%>" data-news="<%=neutTitle.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" selected="selected">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Negative"){
                                        <%if(vnegTitle.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<vnegTitle.size();tempTitle++){
                                                            replacingQuotes= (String)vnegNews.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=vnegTitle.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vnegDate.get(tempTitle)%>"+'</td><td><%=vnegSource.get(tempTitle)%></td><td><select class="veryNegative" id="op<%=tempTitle%>" data-news="<%=vnegTitle.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" >Neutral</option><option value="-0.5">Negative</option><option value="-1" selected="selected">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Positive"){
                                        <%if(vposTitle.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<vposTitle.size();tempTitle++){
                                                            replacingQuotes= (String)vposNews.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=vposTitle.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vposDate.get(tempTitle)%>"+'</td><td><%=vposSource.get(tempTitle)%></td><td><select class="veryPositive" id="op<%=tempTitle%>" data-news="<%=vposTitle.get(tempTitle)%>"><option value="1" selected="selected">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
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
                        if(myList!=null){
                    %>
                    <%
                if(posNews.get(0).equals("NoValue"))
                {
                    //do nothing
                    noPos = true;
                }
                else{
                %>
                    {
                        name: 'Positive',
                        color: '#66FF66',
                        data: [
                            <%



                            int j=0;
                            int k=1;
                            double f =0;
                            String val = "";
                            String tempval="";
                            String[] splitVal = new String[3];
                            int checkPos=0;
                            int count=0;


                            for(j=0;j<myList.size();j++){
                                val = myList.get(j).toString();
                                if(val.equals(tempval)){
                                    count=count+1;
                                }
                                splitVal = val.split("-");
                                checkPos = Integer.valueOf(splitVal[1]);
                                checkPos = checkPos-1;
                                splitVal[1]=String.valueOf(checkPos);
                                if(k < myList.size()){
                                    if(count!=0){
                                    %> [Date.UTC(<%=splitVal[0]%>, <%=splitVal[1]%>, <%=splitVal[2]%>), 0.5, <%=count+1%>], <% count=0;
                                    }else{
                                       %> [Date.UTC(<%=splitVal[0]%>, <%=splitVal[1]%>, <%=splitVal[2]%>), 0.5, <%=count+1%>],<% count=0;
                                    }
                        }
                        else{
                    %>

                            <% if(count!=0){%>
                            [Date.UTC(<%=splitVal[0]%>, <%=splitVal[1]%>, <%=splitVal[2]%>), 0.5,<%=count+1%>]
                                    <% count=0; }else{
                                         %> [Date.UTC(<%=splitVal[0]%>, <%=splitVal[1]%>, <%=splitVal[2]%>),0.5, <%=count+1%>]<% count=0;
                            }%>

                            <%}f=f+0.5;
                                tempval = val;
                            }%>
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Positive',
                        color: '#66FF66',
                        data:[
                            [Date.UTC(2014,1,1),0,1]
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
                        noNeg = true;
                    }
                    else{
                    %>
                    {

                        name: 'Negative',
                        color: 'rgba(223, 83, 83, .5)',
                        data: [
                            <% int jneg=0;
                            int kneg=1;
                            double fneg =0;
                            String valneg = "";
                            String tempvalneg="";
                            String[] splitValneg = new String[3];
                            int checkNeg = 0;
                            int countNeg=0;

                            for(jneg=0;jneg<myListneg.size();jneg++){
                                valneg = myListneg.get(jneg).toString();
                                if(valneg.equals(tempvalneg)){
                                    countNeg=countNeg+1;
                                }
                                splitValneg = valneg.split("-");
                                checkNeg = Integer.valueOf(splitValneg[1]);
                                checkNeg = checkNeg-1;
                                splitValneg[1]=String.valueOf(checkNeg);
                                if(kneg < myListneg.size()){
                                    if(countNeg!=0){
                                    %> [Date.UTC(<%=splitValneg[0]%>, <%=splitValneg[1]%>, <%=splitValneg[2]%>), -0.5, <%=countNeg+1%>], <% countNeg=0;
                                    }else{
                                       %> [Date.UTC(<%=splitValneg[0]%>, <%=splitValneg[1]%>, <%=splitValneg[2]%>), -0.5, <%=countNeg+1%>],<% countNeg=0;
                                    }
                        }
                        else{
                    %>
                            <% if(countNeg!=0){%>
                            [Date.UTC(<%=splitValneg[0]%>, <%=splitValneg[1]%>, <%=splitValneg[2]%>), -0.5,<%=countNeg+1%>]
                                    <% countNeg=0; }else{
                                         %> [Date.UTC(<%=splitValneg[0]%>, <%=splitValneg[1]%>, <%=splitValneg[2]%>),-0.5, <%=countNeg+1%>]<% countNeg=0;
                            }%>

                            <%}fneg=fneg+0.5;
                                tempvalneg = valneg;
                            }%>
                        ]

                    },<%}%>
                        <%}else {
                        %>{
                        name: 'Negative',
                        color: 'rgba(223, 83, 83, .5)',
                        data:[
                            [Date.UTC(2014,1,1),0,1]
                        ]

                    },<% }%>


                    <% ArrayList myListneut = (ArrayList)request.getAttribute("neutralDate");
                if(myListneut!=null){%>
                    <%
                    if(neutNews.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noNeut = true;
                    }
                    else{
                    %>
                    {

                        name: 'Neutral',
                        color: '#40A0A0',
                        data: [
                            <% int jneut=0;
                            int kneut=1;
                            double fneut =0;
                            String valneut = "";
                            String tempvalneut="";
                            String[] splitValneut = new String[3];
                            int checkNeut = 0;
                            int countNeut=0;


                            /////////////////////////////////////daily/////////////////////////////////////////////////

                            for(jneut=0;jneut<myListneut.size();jneut++){
                                valneut = myListneut.get(jneut).toString();
                                if(valneut.equals(tempvalneut)){
                                    countNeut=countNeut+1;
                                }
                                splitValneut = valneut.split("-");
                                checkNeut = Integer.valueOf(splitValneut[1]);
                                checkNeut = checkNeut-1;
                                splitValneut[1]=String.valueOf(checkNeut);
                                if(kneut < myListneut.size()){
                                    if(countNeut!=0){
                                    %> [Date.UTC(<%=splitValneut[0]%>, <%=splitValneut[1]%>, <%=splitValneut[2]%>), 0, <%=countNeut+1%>], <% countNeut=0;
                                    }else{
                                       %> [Date.UTC(<%=splitValneut[0]%>, <%=splitValneut[1]%>, <%=splitValneut[2]%>), 0, <%=countNeut+1%>],<% countNeut=0;
                                    }
                        }
                        else{
                    %>
                            <% if(countNeut!=0){%>
                            [Date.UTC(<%=splitValneut[0]%>, <%=splitValneut[1]%>, <%=splitValneut[2]%>), 0,<%=countNeut+1%>]
                                    <% countNeut=0; }else{
                                         %> [Date.UTC(<%=splitValneut[0]%>, <%=splitValneut[1]%>, <%=splitValneut[2]%>),0, <%=countNeut+1%>]<% countNeut=0;
                            }%>
                            <%}fneut=fneut+0.5;
                                tempvalneut = valneut;
                            }%>
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Neutral',
                        color: '#40A0A0',
                        data:[
                            [Date.UTC(2014,1,1),0,1]
                        ]


                    },<% }%>

                    <% ArrayList myListvneg = (ArrayList)request.getAttribute("vnegativeDate");
            if(myListvneg!=null){%>
                    <%
                    if(vnegNews.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noVneg = true;
                    }
                    else{
                    %>
                    {

                        name: 'Very Negative',
                        color: '#FF0000',
                        data: [
                            <% int jvneg=0;
                            int kvneg=1;
                            double fvneg =0;
                            String valvneg = "";
                            String tempvalvneg ="";
                            String[] splitValvneg = new String[3];
                            int checkVneg =0;
                            int countVneg=0;

                            for(jvneg=0;jvneg<myListvneg.size();jvneg++){
                                valvneg = myListvneg.get(jvneg).toString();
                                if(valvneg.equals(tempvalvneg)){
                                    countVneg=countVneg+1;
                                }
                                splitValvneg = valvneg.split("-");
                                checkVneg = Integer.valueOf(splitValvneg[1]);
                                checkVneg = checkVneg-1;
                                splitValvneg[1]=String.valueOf(checkVneg);
                                if(kvneg < myListvneg.size()){
                                    if(countVneg!=0){
                                    %> [Date.UTC(<%=splitValvneg[0]%>, <%=splitValvneg[1]%>, <%=splitValvneg[2]%>), -1, <%=countVneg+1%>], <% countVneg=0;
                                    }else{
                                       %> [Date.UTC(<%=splitValvneg[0]%>, <%=splitValvneg[1]%>, <%=splitValvneg[2]%>), -1, <%=countVneg+1%>],<% countVneg=0;
                                    }
                        }
                        else{
                    %>

                            <% if(countVneg!=0){%>
                            [Date.UTC(<%=splitValvneg[0]%>, <%=splitValvneg[1]%>, <%=splitValvneg[2]%>), -1,<%=countVneg+1%>]
                                    <% countVneg=0; }else{
                                         %> [Date.UTC(<%=splitValvneg[0]%>, <%=splitValvneg[1]%>, <%=splitValvneg[2]%>),-1, <%=countVneg+1%>]<% countVneg=0;
                            }%>

                            <%}fvneg=fvneg+0.5;
                            tempvalvneg = valvneg;
                            }%>
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Very Negative',
                        color: '#FF0000',
                        data:[
                            [Date.UTC(2014,1,1),0,1]
                        ]


                    },<% }%>


                    <% ArrayList myListvpos = (ArrayList)request.getAttribute("vpositiveDate");
            if(myListvpos!=null){%>
                    <%
                    if(vposNews.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noVpos = true;
                    }
                    else{
                    %>
                    {

                        name: 'Very Positive',
                        color: '#009933',
                        data: [
                            <% int jvpos=0;
                            int kvpos=1;
                            double fvpos =0;
                            String valvpos = "";
                            String tempvalvpos="";
                            String[] splitValvpos = new String[3];
                            int checkVpos = 0;
                            int countVpos=0;

                            for(jvpos=0;jvpos<myListvpos.size();jvpos++){
                                valvpos = myListvpos.get(jvpos).toString();
                                if(valvpos.equals(tempvalvpos)){
                                    countVpos=countVpos+1;
                                }
                                splitValvpos = valvpos.split("-");
                                checkVpos = Integer.valueOf(splitValvpos[1]);
                                checkVpos = checkVpos-1;
                                splitValvpos[1]=String.valueOf(checkVpos);
                                if(kvpos < myListvpos.size()){
                                    if(countVpos!=0){
                                    %> [Date.UTC(<%=splitValvpos[0]%>, <%=splitValvpos[1]%>, <%=splitValvpos[2]%>), 1, <%=countVpos+1%>], <% countVpos=0;
                                    }else{
                                       %> [Date.UTC(<%=splitValvpos[0]%>, <%=splitValvpos[1]%>, <%=splitValvpos[2]%>), 1, <%=countVpos+1%>],<% countVpos=0;
                                    }
                        }
                        else{
                    %>

                            <% if(countVpos!=0){%>
                            [Date.UTC(<%=splitValvpos[0]%>, <%=splitValvpos[1]%>, <%=splitValvpos[2]%>), 1,<%=countVpos+1%>]
                                    <% countVpos=0; }else{
                                         %> [Date.UTC(<%=splitValvpos[0]%>, <%=splitValvpos[1]%>, <%=splitValvpos[2]%>),1, <%=countVpos+1%>]<% countVpos=0;
                            }%>

                            <%}fvpos=fvpos+0.5;
                                tempvalvpos = valvpos;
                            }%>
                        ]

                    }<%}%>
                        <%}else {%>{
                        name: 'Very Positive',
                        color: '#009933',
                        data:[
                            [Date.UTC(2014,1,1),0,1]
                        ]


                    }<% }%>


                ]

            }

    );

    ///////////////////////////////////////weekly/////////////////////////////////////////////////
    $('#container1').highcharts({

                chart: {
                    type: 'bubble',
                    zoomType: 'xy'
                },

                title: {
                    text: 'News Sentiments - Weekly view'
                },
                xAxis: {
                    title: {
                        enabled: true,
                        text: 'Week'
                    },
                    tickInterval: 1


                },
                yAxis: {
                    title: {
                        text: 'Sentiment'
                    }
                },
//                tooltip:{
//                    headerFormat: '<b>{series.name}</b><br>',
//                    pointFormat: '{point.x:%e. %b}'
//                },
                plotOptions:{
                    series: {
                        cursor: 'pointer',
                        point: {
                            events: {
                                click: function() {
                                    var name = this.series.name;

                                    <% ArrayList posTitleW = (ArrayList)request.getAttribute("positiveTitle");
                                                    ArrayList posNewsW = (ArrayList)request.getAttribute("positiveNews");
                                                    ArrayList posDateW = (ArrayList)request.getAttribute("positiveDate");
                                                    ArrayList negTitleW = (ArrayList)request.getAttribute("negativeTitle");
                                                    ArrayList negNewsW = (ArrayList)request.getAttribute("negativeNews");
                                                    ArrayList negDateW = (ArrayList)request.getAttribute("negativeDate");
                                                    ArrayList neutTitleW = (ArrayList)request.getAttribute("neutralTitle");
                                                    ArrayList neutNewsW = (ArrayList)request.getAttribute("neutralNews");
                                                    ArrayList neutDateW = (ArrayList)request.getAttribute("neutralDate");
                                                    ArrayList vnegTitleW = (ArrayList)request.getAttribute("vnegativeTitle");
                                                    ArrayList vnegNewsW = (ArrayList)request.getAttribute("vnegativeNews");
                                                    ArrayList vnegDateW = (ArrayList)request.getAttribute("vnegativeDate");
                                                    ArrayList vposTitleW = (ArrayList)request.getAttribute("vpositiveTitle");
                                                    ArrayList vposNewsW = (ArrayList)request.getAttribute("vpositiveNews");
                                                    ArrayList vposDateW = (ArrayList)request.getAttribute("vpositiveDate");
                                                    ArrayList posSourceW = (ArrayList)request.getAttribute("positiveSource");
                                                    ArrayList negSourceW = (ArrayList)request.getAttribute("negativeSource");
                                                    ArrayList neutSourceW = (ArrayList)request.getAttribute("neutralSource");
                                                    ArrayList vnegSourceW = (ArrayList)request.getAttribute("vnegativeSource");
                                                    ArrayList vposSourceW = (ArrayList)request.getAttribute("vpositiveSource");
//                                                    System.out.println("asdf"+posTitleW);
//                                                    System.out.println("asdf"+negTitleW);
//                                                    System.out.println("asdf"+neutTitleW);
//                                                    System.out.println("asdfPOS"+vposTitleW);
//                                                    System.out.println("asdfNEG"+vnegTitleW);
                                                    boolean noPosW=false;
                                                    boolean noNegW=false;
                                                    boolean noNeutW=false;
                                                    boolean noVnegW=false;
                                                    boolean noVposW=false;
                                                    ArrayList dates = (ArrayList)request.getAttribute("dates");



                                                    if(posTitleW!=null || posNewsW!=null || negNewsW!=null || negTitleW!=null || neutTitleW!=null || neutNewsW!=null ||vnegTitleW!=null||vnegNewsW!=null||vposTitleW!=null||vposNewsW!=null||posDateW!=null||negDateW!=null||neutDateW!=null||vposDateW!=null||vnegDateW!=null||dates!=null||
                                                    posSourceW!=null||negSourceW!=null||neutSourceW!=null||vnegSourceW!=null||vposSourceW!=null){
                                                    if(negTitleW.get(0).equals("NoValue")){

                                                    }else{

                                                    }
                                                    %>
                                    if(this.series.name=="Positive") {
                                        <%if(posTitleW.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<posTitleW.size();tempTitle++){
                                                            replacingQuotes= (String)posNewsW.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=posTitleW.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=posDateW.get(tempTitle)%>"+'</td><td><%=posSourceW.get(tempTitle)%></td><td><select class="positive" id="op<%=tempTitle%>" data-news="<%=posTitleW.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5" selected="selected">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Negative") {
                                        <%if(negTitleW.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<negTitleW.size();tempTitle++){
                                                            replacingQuotes= (String)negNewsW.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=negTitleW.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=negDateW.get(tempTitle)%>"+'</td><td><%=negSourceW.get(tempTitle)%></td><td><select class="negative" id="op<%=tempTitle%>" data-news="<%=negTitleW.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5" selected="selected">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Neutral"){
                                        <%if(neutTitleW.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<neutTitleW.size();tempTitle++){
                                                            replacingQuotes= (String)neutNewsW.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=neutTitleW.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=neutDateW.get(tempTitle)%>"+'</td><td><%=neutSourceW.get(tempTitle)%></td><td><select class="neutral" id="op<%=tempTitle%>" data-news="<%=neutTitleW.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" selected="selected">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Negative"){
                                        <%if(vnegTitleW.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<vnegTitleW.size();tempTitle++){
                                                            replacingQuotes= (String)vnegNewsW.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=vnegTitleW.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vnegDateW.get(tempTitle)%>"+'</td><td><%=vnegSourceW.get(tempTitle)%></td><td><select class="veryNegative" id="op<%=tempTitle%>" data-news="<%=vnegTitleW.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" >Neutral</option><option value="-0.5">Negative</option><option value="-1" selected="selected">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Positive"){
                                        <%if(vposTitleW.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<vposTitleW.size();tempTitle++){
                                                            replacingQuotes= (String)vposNewsW.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#145;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=vposTitleW.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vposDateW.get(tempTitle)%>"+'</td><td><%=vposSourceW.get(tempTitle)%></td><td><select class="veryPositive" id="op<%=tempTitle%>" data-news="<%=vposTitleW.get(tempTitle)%>"><option value="1" selected="selected">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
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
                    <%ArrayList myListW = (ArrayList)request.getAttribute("positiveDate");
                        if(myListW!=null){
                    %>
                    <%
                if(posNewsW.get(0).equals("NoValue"))
                {
                    //do nothing
                    noPosW = true;
                }
                else{
                %>
                    {
                        name: 'Positive',
                        color: '#66FF66',
                        data: [
                                <%



                                int j=0;
                                int k=1;
                                double f =0;
                                String val = "";
                                String tempval="";
                                String[] splitVal = new String[3];
                                int checkPos=0;
                                int count=0;

                               /////////////////////////////////////weekly/////////////////////////////////////////////////
                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                 for(j=1;j<=dates.size();j++){
                                     if(j<=(7*week)){
                                        for(temp=0;temp<myListW.size();temp++){
                                            if(dates.get(j-1).equals(myListW.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{
                                     if(daysCount!=0){
                                        %>[<%=week%>,0.5,<%=daysCount%>],<%
                                 }
                                 daysCount=0;
                                 if((j-1)==(7*week)){
                                    for(temp=0;temp<myListW.size();temp++){
                                        if(dates.get(j-1).equals(myListW.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }
                             if(daysCount!=0){
                             %>
                            [<%=week%>,0.5,<%=daysCount%>]
                            <%
                               }%>
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Positive',
                        color: '#66FF66',
                        data:[
                            [0,0,1]
                        ]

                    },<% }%>

                    <%
                ArrayList myListnegW = (ArrayList)request.getAttribute("negativeDate");
                    if(myListnegW !=null){
                %>

                    <%
                    if(negNewsW.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noNegW = true;
                    }
                    else{
                    %>
                    {

                        name: 'Negative',
                        color: 'rgba(223, 83, 83, .5)',
                        data: [
                                <% int jneg=0;
                                int kneg=1;
                                double fneg =0;
                                String valneg = "";
                                String tempvalneg="";
                                String[] splitValneg = new String[3];
                                boolean checkNeg = false;
                                int countNeg=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                 for(jneg=1;jneg<=dates.size();jneg++){
                                     if(jneg<=(7*week)){
                                        for(temp=0;temp<myListnegW.size();temp++){
                                            if(dates.get(jneg-1).equals(myListnegW.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{
                                     if(daysCount!=0){
                                        %>[<%=week%>,-0.5,<%=daysCount%>],<%
                                 }
                                 daysCount=0;
                                 if((jneg-1)==(7*week)){
                                    for(temp=0;temp<myListnegW.size();temp++){
                                        if(dates.get(jneg-1).equals(myListnegW.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }
                             if(daysCount!=0){
                             %>
                            [<%=week%>,-0.5,<%=daysCount%>]
                            <%
                               }%>
                        ]

                    },<%}%>
                        <%}else {
                        %>{
                        name: 'Negative',
                        color: 'rgba(223, 83, 83, .5)',
                        data:[
                            [0,0,0]
                        ]

                    },<% }%>


                    <% ArrayList myListneutW = (ArrayList)request.getAttribute("neutralDate");

                if(myListneutW!=null){%>
                    <%
                    if(neutNewsW.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noNeutW = true;
                    }
                    else{
                    %>
                    {

                        name: 'Neutral',
                        color: '#40A0A0',
                        data: [
                                <% int jneut=0;
                                int kneut=1;
                                double fneut =0;
                                String valneut = "";
                                String tempvalneut="";
                                String[] splitValneut = new String[3];
                                int checkNeut = 0;
                                int countNeut=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                 for(jneut=1;jneut<=dates.size();jneut++){
                                     if(jneut<=(7*week)){
                                        for(temp=0;temp<myListneutW.size();temp++){
                                            if(dates.get(jneut-1).equals(myListneutW.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{
                                     if(daysCount!=0){
                                        %>[<%=week%>,0,<%=daysCount%>],<%
                                 }
                                 daysCount=0;
                                 if((jneut-1)==(7*week)){
                                    for(temp=0;temp<myListneutW.size();temp++){
                                        if(dates.get(jneut-1).equals(myListneutW.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }
                             if(daysCount!=0){
                             %>
                            [<%=week%>,0,<%=daysCount%>]
                            <%
                               }
                              %>
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Neutral',
                        color: '#40A0A0',
                        data:[
                            [0,0,0]
                        ]


                    },<% }%>

                    <% ArrayList myListvnegW = (ArrayList)request.getAttribute("vnegativeDate");
            if(myListvnegW!=null){%>
                    <%
                    if(vnegNewsW.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noVnegW = true;
                    }
                    else{
                    %>
                    {

                        name: 'Very Negative',
                        color: '#FF0000',
                        data: [
                                <% int jvneg=0;
                                int kvneg=1;
                                double fvneg =0;
                                String valvneg = "";
                                String tempvalvneg ="";
                                String[] splitValvneg = new String[3];
                                int checkVneg =0;
                                int countVneg=0;

                                 /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                 for(jvneg=1;jvneg<=dates.size();jvneg++){
                                     if(jvneg<=(7*week)){
                                        for(temp=0;temp<myListvnegW.size();temp++){
                                            if(dates.get(jvneg-1).equals(myListvnegW.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{
                                     if(daysCount!=0){
                                        %>[<%=week%>,-1,<%=daysCount%>],<%
                                 }
                                 daysCount=0;
                                 if((jvneg-1)==(7*week)){
                                    for(temp=0;temp<myListvnegW.size();temp++){
                                        if(dates.get(jvneg-1).equals(myListvnegW.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }
                             if(daysCount!=0){
                             %>
                            [<%=week%>,-1,<%=daysCount%>]
                            <%
                               }%>
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Very Negative',
                        color: '#FF0000',
                        data:[
                            [0,0,0]
                        ]


                    },<% }%>


                    <% ArrayList myListvposW = (ArrayList)request.getAttribute("vpositiveDate");
            if(myListvposW!=null){%>
                    <%
                    if(vposNewsW.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noVposW = true;
                    }
                    else{
                    %>
                    {

                        name: 'Very Positive',
                        color: '#009933',
                        data: [
                                <% int jvpos=0;
                                int kvpos=1;
                                double fvpos =0;
                                String valvpos = "";
                                String tempvalvpos="";
                                String[] splitValvpos = new String[3];
                                int checkVpos = 0;
                                int countVpos=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                 for(jvpos=1;jvpos<=dates.size();jvpos++){
                                     if(jvpos<=(7*week)){
                                        for(temp=0;temp<myListvposW.size();temp++){
                                            if(dates.get(jvpos-1).equals(myListvposW.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{
                                     if(daysCount!=0){
                                        %>[<%=week%>,1,<%=daysCount%>],<%
                                 }
                                 daysCount=0;
                                 if((jvpos-1)==(7*week)){
                                    for(temp=0;temp<myListvposW.size();temp++){
                                        if(dates.get(jvpos-1).equals(myListvposW.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }
                             if(daysCount!=0){
                             %>
                            [<%=week%>,1,<%=daysCount%>]
                            <%
                               }%>
                        ]

                    }<%}%>
                        <%}else {%>{
                        name: 'Very Positive',
                        color: '#009933',
                        data:[
                            [0,0,0]
                        ]


                    }<% }%>


                ]

            }

    );
    ///////////////////////////Monthly//////////////////////////////////////////////////////////////////////////////////////////
    $('#container2').highcharts({

                chart: {
                    type: 'bubble',
                    zoomType: 'xy'
                },

                title: {
                    text: 'News Sentiments - Monthly view'
                },
                xAxis: {
                    title: {
                        enabled: true,
                        text: 'Month'
                    },
                    tickInterval: 1,
                    categories: ['Jan','Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

                },
                yAxis: {
                    title: {
                        text: 'Sentiment'
                    }
                },
                tooltip:{
                    headerFormat: '<b>{series.name}</b><br>',
                    pointFormat: '{point.x:%e. %b}'
                },
                plotOptions:{
                    series: {
                        cursor: 'pointer',
                        point: {
                            events: {
                                click: function() {
                                    var name = this.series.name;

                                    <% ArrayList posTitleM = (ArrayList)request.getAttribute("positiveTitle");
                                                    ArrayList posNewsM = (ArrayList)request.getAttribute("positiveNews");
                                                    ArrayList posDateM = (ArrayList)request.getAttribute("positiveDate");
                                                    ArrayList negTitleM = (ArrayList)request.getAttribute("negativeTitle");
                                                    ArrayList negNewsM = (ArrayList)request.getAttribute("negativeNews");
                                                    ArrayList negDateM = (ArrayList)request.getAttribute("negativeDate");
                                                    ArrayList neutTitleM = (ArrayList)request.getAttribute("neutralTitle");
                                                    ArrayList neutNewsM = (ArrayList)request.getAttribute("neutralNews");
                                                    ArrayList neutDateM = (ArrayList)request.getAttribute("neutralDate");
                                                    ArrayList vnegTitleM = (ArrayList)request.getAttribute("vnegativeTitle");
                                                    ArrayList vnegNewsM = (ArrayList)request.getAttribute("vnegativeNews");
                                                    ArrayList vnegDateM = (ArrayList)request.getAttribute("vnegativeDate");
                                                    ArrayList vposTitleM = (ArrayList)request.getAttribute("vpositiveTitle");
                                                    ArrayList vposNewsM = (ArrayList)request.getAttribute("vpositiveNews");
                                                    ArrayList vposDateM = (ArrayList)request.getAttribute("vpositiveDate");
                                                    ArrayList posSourceM = (ArrayList)request.getAttribute("positiveSource");
                                                    ArrayList negSourceM = (ArrayList)request.getAttribute("negativeSource");
                                                    ArrayList neutSourceM = (ArrayList)request.getAttribute("neutralSource");
                                                    ArrayList vnegSourceM = (ArrayList)request.getAttribute("vnegativeSource");
                                                    ArrayList vposSourceM = (ArrayList)request.getAttribute("vpositiveSource");
//                                                    System.out.println("asdf"+posTitleM);
//                                                    System.out.println("asdf"+negTitleM);
//                                                    System.out.println("asdf"+neutTitleM);
//                                                    System.out.println("asdfPOS"+vposTitleM);
//                                                    System.out.println("asdfNEG"+vnegTitleM);
                                                    boolean noPosM=false;
                                                    boolean noNegM=false;
                                                    boolean noNeutM=false;
                                                    boolean noVnegM=false;
                                                    boolean noVposM=false;
                                                    ArrayList datesForMonth = (ArrayList)request.getAttribute("dates");



                                                    if(posTitleM!=null || posNewsM!=null || negNewsM!=null || negTitleM!=null || neutTitleM!=null || neutNewsM!=null ||vnegTitleM!=null||vnegNewsM!=null||vposTitleM!=null||vposNewsM!=null||posDateM!=null||negDateM!=null||neutDateM!=null||vposDateM!=null||vnegDateM!=null||dates!=null||
                                                    posSourceM!=null||negSourceM!=null||neutSourceM!=null||vposSourceM!=null||vnegSourceM!=null){
                                                    if(negTitleM.get(0).equals("NoValue")){

                                                    }else{

                                                    }
                                                    %>
                                    if(this.series.name=="Positive") {
                                        <%if(posTitleM.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<posTitleM.size();tempTitle++){
                                                            replacingQuotes= (String)posNewsM.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=posTitleM.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=posDateM.get(tempTitle)%>"+'</td><td><%=posSourceM.get(tempTitle)%></td><td><select class="positive" id="op<%=tempTitle%>" data-news="<%=posTitleM.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5" selected="selected">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Negative") {
                                        <%if(negTitleM.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<negTitleM.size();tempTitle++){
                                                            replacingQuotes= (String)negNewsM.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=negTitleM.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=negDateM.get(tempTitle)%>"+'</td><td><%=negSourceM.get(tempTitle)%></td><td><select class="negative" id="op<%=tempTitle%>" data-news="<%=negTitleM.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5" selected="selected">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Neutral"){
                                        <%if(neutTitleM.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<neutTitleM.size();tempTitle++){
                                                            replacingQuotes= (String)neutNewsM.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=neutTitleM.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=neutDateM.get(tempTitle)%>"+'</td><td><%=neutSourceM.get(tempTitle)%></td><td><select class="neutral" id="op<%=tempTitle%>" data-news="<%=neutTitleM.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" selected="selected">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Negative"){
                                        <%if(vnegTitleM.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<vnegTitleM.size();tempTitle++){
                                                            replacingQuotes= (String)vnegNewsM.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=vnegTitleM.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vnegDateM.get(tempTitle)%>"+'</td><td><%=vnegSourceM.get(tempTitle)%></td><td><select class="veryNegative" id="op<%=tempTitle%>" data-news="<%=vnegTitleM.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" >Neutral</option><option value="-0.5">Negative</option><option value="-1" selected="selected">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Positive"){
                                        <%if(vposTitleM.get(0).equals("NoValue")){
                                           //do nothing
                                       }else{
                                       %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%   for(int tempTitle=0;tempTitle<vposTitleM.size();tempTitle++){
                                                            replacingQuotes= (String)vposNewsM.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>'+this.series.name+'</td><td><a href='+"<%=vposTitleM.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vposDateM.get(tempTitle)%>"+'</td><td><%=vposSourceM.get(tempTitle)%></td><td><select class="veryPositive" id="op<%=tempTitle%>" data-news="<%=vposTitleM.get(tempTitle)%>"><option value="1" selected="selected">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%}%>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
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
                    <%ArrayList myListM = (ArrayList)request.getAttribute("positiveDate");
                        if(myListM!=null){
                    %>
                    <%
                if(posNewsM.get(0).equals("NoValue"))
                {
                    //do nothing
                    noPosM = true;
                }
                else{
                %>
                    {
                        name: 'Positive',
                        color: '#66FF66',
                        data: [
                                <%



                                int j=0;
                                int k=1;
                                double f =0;
                                String val = "";
                                String tempval="";
                                String[] splitVal = new String[3];
                                boolean checkPos=true;
                                int count=0;

                               /////////////////////////////////////monthly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                String tempneut = ""; //this is common for all the 5 points

                                for(j=0;j<myListM.size();j++){
                                    val = myListM.get(j).toString();
                                    splitVal = val.split("-");
                                    if(checkPos){
                                        if(myListM.get(0)!=null){
                                            tempneut = splitVal[1];
                                            checkPos=false;
                                        }
                                    }
                                    if(splitVal[1].equals(tempneut))
                                    {
                                        daysCount++;
                                    }
                                    else{
                                        %>[<%=tempneut%>,0.5,<%=daysCount%>],<%
                                        tempneut=splitVal[1];
                                        daysCount=0;
                                    }if(daysCount==0){daysCount++;}
                                }if(daysCount==0){daysCount++;}
                                %>[<%=tempneut%>,0.5,<%=daysCount%>]
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Positive',
                        color: '#66FF66',
                        data:[
                            [0,0,1]
                        ]

                    },<% }%>

                    <%
                ArrayList myListnegM = (ArrayList)request.getAttribute("negativeDate");
                    if(myListnegM !=null){
                %>

                    <%
                    if(negNewsM.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noNegM = true;
                    }
                    else{
                    %>
                    {

                        name: 'Negative',
                        color: 'rgba(223, 83, 83, .5)',
                        data: [
                                <% int jneg=0;
                                int kneg=1;
                                double fneg =0;
                                String valneg = "";
                                String tempvalneg="";
                                String[] splitValneg = new String[3];
                                boolean checkNeg = true;
                                int countNeg=0;

                                /////////////////////////////////////monthly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                String tempneut = "";

                                for(jneg=0;jneg<myListnegM.size();jneg++){
                                    valneg = myListnegM.get(jneg).toString();
                                    splitValneg = valneg.split("-");
                                    if(checkNeg){
                                    if(myListnegM.get(0)!=null){
                                        tempneut = splitValneg[1];
                                        checkNeg=false;
                                    }
                                    }
                                    if(splitValneg[1].equals(tempneut))
                                    {
                                        daysCount++;
                                    }
                                    else{
                                        %>[<%=tempneut%>,-0.5,<%=daysCount%>],<%
                                        tempneut=splitValneg[1];
                                        daysCount=0;
                                    }if(daysCount==0){daysCount++;}
                                }if(daysCount==0){daysCount++;}
                                %>[<%=tempneut%>,-0.5,<%=daysCount%>]
                        ]

                    },<%}%>
                        <%}else {
                        %>{
                        name: 'Negative',
                        color: 'rgba(223, 83, 83, .5)',
                        data:[
                            [0,0,0]
                        ]

                    },<% }%>


                    <% ArrayList myListneutM = (ArrayList)request.getAttribute("neutralDate");

                if(myListneutM!=null){%>
                    <%
                    if(neutNewsM.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noNeutM = true;
                    }
                    else{
                    %>
                    {

                        name: 'Neutral',
                        color: '#40A0A0',
                        data: [
                                <% int jneut=0;
                                int kneut=1;
                                double fneut =0;
                                String valneut = "";
                                String tempvalneut="";
                                String[] splitValneut = new String[3];
                                boolean checkNeut = true;
                                int countNeut=0;

                                /////////////////////////////////////monthly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                String tempneut = "";

                                for(jneut=0;jneut<myListneutM.size();jneut++){
                                    valneut = myListneutM.get(jneut).toString();
                                    splitValneut = valneut.split("-");
                                    if(checkNeut){
                                    if(myListneutM.get(0)!=null){
                                        tempneut = splitValneut[1];
                                        checkNeut=false;
                                    }
                                    }
                                    if(splitValneut[1].equals(tempneut))
                                    {
                                        daysCount++;
                                    }
                                    else{

                                        %>[<%=tempneut%>,0,<%=daysCount%>],<%
                                        tempneut=splitValneut[1];
                                        daysCount=0;
                                    }if(daysCount==0){daysCount++;}
                                }
                                if(daysCount==0){daysCount++;}
                              %>[<%=tempneut%>,0,<%=daysCount%>]
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Neutral',
                        color: '#40A0A0',
                        data:[
                            [0,0,0]
                        ]


                    },<% }%>

                    <% ArrayList myListvnegM = (ArrayList)request.getAttribute("vnegativeDate");
            if(myListvnegM!=null){%>
                    <%
                    if(vnegNewsM.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noVnegM = true;
                    }
                    else{
                    %>
                    {

                        name: 'Very Negative',
                        color: '#FF0000',
                        data: [
                                <% int jvneg=0;
                                int kvneg=1;
                                double fvneg =0;
                                String valvneg = "";
                                String tempvalvneg ="";
                                String[] splitValvneg = new String[3];
                                boolean checkVneg = true;
                                int countVneg=0;

                                 /////////////////////////////////////monthly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                String tempneut = "";

                                for(jvneg=0;jvneg<myListvnegM.size();jvneg++){
                                    valvneg = myListvnegM.get(jvneg).toString();
                                    splitValvneg = valvneg.split("-");
                                    if(checkVneg){
                                    if(myListvnegM.get(0)!=null){
                                        tempneut = splitValvneg[1];
                                        checkVneg=false;
                                    }
                                    }
                                    if(splitValvneg[1].equals(tempneut))
                                    {
                                        daysCount++;
                                    }
                                    else{
                                        %>[<%=tempneut%>,-1,<%=daysCount%>],<%
                                        tempneut=splitValvneg[1];
                                        daysCount=0;
                                    }if(daysCount==0){daysCount++;}
                                }if(daysCount==0){daysCount++;}
                                %>[<%=tempneut%>,-1,<%=daysCount%>]
                        ]

                    },<%}%>
                        <%}else {%>{
                        name: 'Very Negative',
                        color: '#FF0000',
                        data:[
                            [0,0,0]
                        ]


                    },<% }%>


                    <% ArrayList myListvposM = (ArrayList)request.getAttribute("vpositiveDate");
            if(myListvposM!=null){%>
                    <%
                    if(vposNewsM.get(0).equals("NoValue"))
                    {
                        //do nothing
                        noVposM = true;
                    }
                    else{
                    %>
                    {

                        name: 'Very Positive',
                        color: '#009933',
                        data: [
                                <% int jvpos=0;
                                int kvpos=1;
                                double fvpos =0;
                                String valvpos = "";
                                String tempvalvpos="";
                                String[] splitValvpos = new String[3];
                                boolean checkVpos = true;
                                int countVpos=0;

                                /////////////////////////////////////monthly/////////////////////////////////////////////////

                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;

                                String tempneut = "";

                                for(jvpos=0;jvpos<myListvposM.size();jvpos++){
                                    valvpos = myListvposM.get(jvpos).toString();
                                    splitValvpos = valvpos.split("-");
                                    if(checkVpos){
                                    if(myListvposM.get(0)!=null){
                                        tempneut = splitValvpos[1];
                                        checkVpos=false;
                                    }
                                    }
                                    if(splitValvpos[1].equals(tempneut))
                                    {
                                        daysCount++;
                                    }
                                    else{
                                        %>[<%=tempneut%>,1,<%=daysCount%>],<%
                                        tempneut=splitValvpos[1];
                                        daysCount=0;
                                    }if(daysCount==0){daysCount++;}
                                }if(daysCount==0){daysCount++;}
                                %>[<%=tempneut%>,1,<%=daysCount%>]
                        ]

                    }<%}%>
                        <%}else {%>{
                        name: 'Very Positive',
                        color: '#009933',
                        data:[
                            [0,0,0]
                        ]


                    }<% }%>


                ]

            }

    );

    //////////////////////////////summed up/////////////////////////////////////////////////////////////////////////////

    $('#container3').highcharts({

                chart: {
                    zoomType: 'xy'
                },

                title: {
                    text: 'Overall Sentiments - Weekly trend'
                },
                yAxis: [{//primary
                    title: {
                        text: 'Sentiment',
                        style: {
                            color: '#853385'
                        }
                    }
                },
                    {//secondary
                        title: {
                            text: 'NewsCount',
                            style: {
                                color: '#853385'
                            }
                        },
                        opposite: true
                    }
                ],
                <%--tooltip:{--%>
                <%--headerFormat: '<b>Overall sentiments</b><br>',--%>
                <%--pointFormat: '<table><tr><td><b>Sentiments<b></td><td>Count</td></tr>' +--%>
                <%--'<tr><td>Positive</td><td><%=sum%></td></tr></table>{point.x:%e. %b}'--%>
                <%--},--%>
                plotOptions:{
                    series: {
                        cursor: 'pointer',
                        point: {
                            events: {
                                click: function() {
                                    var name = this.series.name;

                                    <% ArrayList posTitleSum = (ArrayList)request.getAttribute("positiveTitle");
                                                    ArrayList posNewsSum = (ArrayList)request.getAttribute("positiveNews");
                                                    ArrayList posDateSum = (ArrayList)request.getAttribute("positiveDate");
                                                    ArrayList negTitleSum = (ArrayList)request.getAttribute("negativeTitle");
                                                    ArrayList negNewsSum = (ArrayList)request.getAttribute("negativeNews");
                                                    ArrayList negDateSum = (ArrayList)request.getAttribute("negativeDate");
                                                    ArrayList neutTitleSum = (ArrayList)request.getAttribute("neutralTitle");
                                                    ArrayList neutNewsSum = (ArrayList)request.getAttribute("neutralNews");
                                                    ArrayList neutDateSum = (ArrayList)request.getAttribute("neutralDate");
                                                    ArrayList vnegTitleSum = (ArrayList)request.getAttribute("vnegativeTitle");
                                                    ArrayList vnegNewsSum = (ArrayList)request.getAttribute("vnegativeNews");
                                                    ArrayList vnegDateSum = (ArrayList)request.getAttribute("vnegativeDate");
                                                    ArrayList vposTitleSum = (ArrayList)request.getAttribute("vpositiveTitle");
                                                    ArrayList vposNewsSum = (ArrayList)request.getAttribute("vpositiveNews");
                                                    ArrayList vposDateSum = (ArrayList)request.getAttribute("vpositiveDate");
                                                    ArrayList posSourceSum = (ArrayList)request.getAttribute("positiveSource");
                                                    ArrayList negSourceSum = (ArrayList)request.getAttribute("negativeSource");
                                                    ArrayList neutSourceSum = (ArrayList)request.getAttribute("neutralSource");
                                                    ArrayList vnegSourceSum = (ArrayList)request.getAttribute("vnegativeSource");
                                                    ArrayList vposSourceSum = (ArrayList)request.getAttribute("vpositiveSource");
//                                                    System.out.println("asdf"+posTitleSum);
//                                                    System.out.println("asdf"+negTitleSum);
//                                                    System.out.println("asdf"+neutTitleSum);
//                                                    System.out.println("asdfPOS"+vposTitleSum);
//                                                    System.out.println("asdfNEG"+vnegTitleSum);
                                                    boolean noPosSum=false;
                                                    boolean noNegSum=false;
                                                    boolean noNeutSum=false;
                                                    boolean noVnegSum=false;
                                                    boolean noVposSum=false;
                                                    double sum = 0; double sop =0; double posPresent=0; double negPresent=0; double neutPresent=0; double vnegPresent=0;  double vposPresent=0;



                                                    if(posTitleSum!=null || posNewsSum!=null || negNewsSum!=null || negTitleSum!=null || neutTitleSum!=null || neutNewsSum!=null ||vnegTitleSum!=null||vnegNewsSum!=null||vposTitleSum!=null||vposNewsSum!=null||posDateSum!=null||negDateSum!=null||neutDateSum!=null||vposDateSum!=null||vnegDateSum!=null||dates!=null){
                                                    if(negTitleSum.get(0).equals("NoValue")){

                                                    }else{

                                                    }
                                                    %>
                                    if(this.series.name=="Sentiment") {
                                        <%if(posTitleSum.get(0).equals("NoValue")&&negTitleSum.get(0).equals("NoValue")&&neutTitleSum.get(0).equals("NoValue")&&vposTitleSum.get(0).equals("NoValue")&&vnegTitleSum.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!posTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<posTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)posNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Positive</td><td><a href='+"<%=posTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=posDateSum.get(tempTitle)%>"+'</td><td><%=posSourceSum.get(tempTitle)%></td><td><select class="positive" id="op<%=tempTitle%>" data-news="<%=posTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5" selected="selected">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!negTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<negTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)negNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Negative</td><td><a href='+"<%=negTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=negDateSum.get(tempTitle)%>"+'</td><td><%=negSourceSum.get(tempTitle)%></td><td><select class="negative" id="op<%=tempTitle%>" data-news="<%=negTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5" selected="selected">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!neutTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<neutTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)neutNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Neutral</td><td><a href='+"<%=neutTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=neutDateSum.get(tempTitle)%>"+'</td><td><%=neutSourceSum.get(tempTitle)%></td><td><select class="neutral" id="op<%=tempTitle%>" data-news="<%=neutTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" selected="selected">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!vposTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vposTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)vposNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very positive</td><td><a href='+"<%=vposTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vposDateSum.get(tempTitle)%>"+'</td><td><%=vposSourceSum.get(tempTitle)%></td><td><select class="veryPositive" id="op<%=tempTitle%>" data-news="<%=vposTitleSum.get(tempTitle)%>"><option value="1" selected="selected">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!vnegTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vnegTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)vnegNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very negative</td><td><a href='+"<%=vnegTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vnegDateSum.get(tempTitle)%>"+'</td><td><%=vnegSourceSum.get(tempTitle)%></td><td><select class="veryNegative" id="op<%=tempTitle%>" data-news="<%=vnegTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" >Neutral</option><option value="-0.5">Negative</option><option value="-1" selected="selected">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Positive Count"){
                                        <%if(posTitleSum.get(0).equals("NoValue")&&negTitleSum.get(0).equals("NoValue")&&neutTitleSum.get(0).equals("NoValue")&&vposTitleSum.get(0).equals("NoValue")&&vnegTitleSum.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!posTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<posTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)posNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Positive</td><td><a href='+"<%=posTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=posDateSum.get(tempTitle)%>"+'</td><td><%=posSourceSum.get(tempTitle)%></td><td><select class="positive" id="op<%=tempTitle%>" data-news="<%=posTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5" selected="selected">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Negative Count"){
                                        <%if(posTitleSum.get(0).equals("NoValue")&&negTitleSum.get(0).equals("NoValue")&&neutTitleSum.get(0).equals("NoValue")&&vposTitleSum.get(0).equals("NoValue")&&vnegTitleSum.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!negTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<negTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)negNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Negative</td><td><a href='+"<%=negTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=negDateSum.get(tempTitle)%>"+'</td><td><%=negSourceSum.get(tempTitle)%></td><td><select class="negative" id="op<%=tempTitle%>" data-news="<%=negTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5" selected="selected">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Neutral Count"){
                                        <%if(posTitleSum.get(0).equals("NoValue")&&negTitleSum.get(0).equals("NoValue")&&neutTitleSum.get(0).equals("NoValue")&&vposTitleSum.get(0).equals("NoValue")&&vnegTitleSum.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!neutTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<neutTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)neutNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Neutral</td><td><a href='+"<%=neutTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=neutDateSum.get(tempTitle)%>"+'</td><td><%=neutSourceSum.get(tempTitle)%></td><td><select class="neutral" id="op<%=tempTitle%>" data-news="<%=neutTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" selected="selected">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Positive Count"){
                                        <%if(posTitleSum.get(0).equals("NoValue")&&negTitleSum.get(0).equals("NoValue")&&neutTitleSum.get(0).equals("NoValue")&&vposTitleSum.get(0).equals("NoValue")&&vnegTitleSum.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!vposTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vposTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)vposNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very positive</td><td><a href='+"<%=vposTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vposDateSum.get(tempTitle)%>"+'</td><td><%=vposSourceSum.get(tempTitle)%></td><td><select class="veryPositive" id="op<%=tempTitle%>" data-news="<%=vposTitleSum.get(tempTitle)%>"><option value="1" selected="selected">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=="Very Negative Count"){
                                        <%if(posTitleSum.get(0).equals("NoValue")&&negTitleSum.get(0).equals("NoValue")&&neutTitleSum.get(0).equals("NoValue")&&vposTitleSum.get(0).equals("NoValue")&&vnegTitleSum.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!vnegTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vnegTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)vnegNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very negative</td><td><a href='+"<%=vnegTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vnegDateSum.get(tempTitle)%>"+'</td><td><%=vnegSourceSum.get(tempTitle)%></td><td><select class="veryNegative" id="op<%=tempTitle%>" data-news="<%=vnegTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" >Neutral</option><option value="-0.5">Negative</option><option value="-1" selected="selected">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
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
                    },
                    column: {
                        stacking: 'normal'
                    }
                },

                series:  [
                    <%ArrayList myListSum = (ArrayList)request.getAttribute("positiveDate");
                    ArrayList myListnegSum = (ArrayList)request.getAttribute("negativeDate");
                    ArrayList myListneutSum = (ArrayList)request.getAttribute("neutralDate");
                    ArrayList myListvnegSum = (ArrayList)request.getAttribute("vnegativeDate");
                    ArrayList myListvposSum = (ArrayList)request.getAttribute("vpositiveDate");



                        if(myListSum!=null||myListnegSum!=null||myListneutSum!=null||myListvnegSum!=null||myListvposSum!=null){
                    %>
                    <%
                if(posNewsSum.get(0).equals("NoValue")&&negNewsSum.get(0).equals("NoValue")&&neutNewsSum.get(0).equals("NoValue")&&vnegNewsSum.get(0).equals("NoValue")&&vposNewsSum.get(0).equals("NoValue"))
                {
                    //do nothing
                    noPosSum = true;
                }
                else{
                            int j=0;
                            int k=1;
                            double f =0;
                            String val = "";
                            String tempval="";
                            String[] splitVal = new String[3];
                            int checkPos=0;
                            int count=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////
                             int daysCount =0;
                             int numOfDays =1;
                             int week = 1;
                             int temp=0;
                             ArrayList<Integer> posCount = new ArrayList<Integer>();

                             int jneg=0;
                                int kneg=1;
                                double fneg =0;
                                String valneg = "";
                                String tempvalneg="";
                                String[] splitValneg = new String[3];
                                boolean checkNeg = false;
                                int countNeg=0;
                                ArrayList<Integer> negCount = new ArrayList<Integer>();
                             /////////////////////////////////////weekly/////////////////////////////////////////////////

                                            int jneut=0;
                                            int kneut=1;
                                            double fneut =0;
                                            String valneut = "";
                                            String tempvalneut="";
                                            String[] splitValneut = new String[3];
                                            int checkNeut = 0;
                                            int countNeut=0;
                                            ArrayList<Integer> neutCount = new ArrayList<Integer>();

                             /////////////////////////////////////weekly/////////////////////////////////////////////////
                             int jvneg=0;
                                int kvneg=1;
                                double fvneg =0;
                                String valvneg = "";
                                String tempvalvneg ="";
                                String[] splitValvneg = new String[3];
                                int checkVneg =0;
                                int countVneg=0;
                                ArrayList<Integer> vnegCount = new ArrayList<Integer>();

                             /////////////////////////////////////weekly/////////////////////////////////////////////////
                             int jvpos=0;
                           int kvpos=1;
                           double fvpos =0;
                           String valvpos = "";
                           String tempvalvpos="";
                           String[] splitValvpos = new String[3];
                           int checkVpos = 0;
                           int countVpos=0;
                           ArrayList<Integer> vposCount = new ArrayList<Integer>();

                           /////////////////////////////////////weekly/////////////////////////////////////////////////
                                    int valposCount = 0;
                                    int valnegCount = 0;
                                    int valneutCount = 0;
                                    int valvnegCount = 0;
                                    int valvposCount = 0;
                                    int maxValue=0;
                                    java.util.List<Integer> data = new ArrayList<Integer>();
                %>
                    {
                        name: 'Positive Count',
                        type: 'column',
                        color: '#66FF66',
                        yAxis: 1,
                        data: [
                            <%





                             for(j=1;j<=dates.size();j++){
                                 if(j<=(7*week)){
                                    for(temp=0;temp<myListSum.size();temp++){
                                        if(dates.get(j-1).equals(myListSum.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                 else{

                                    posCount.add(daysCount);

                                 daysCount=0;
                                 if((j-1)==(7*week)){
                                    for(temp=0;temp<myListSum.size();temp++){
                                        if(dates.get(j-1).equals(myListSum.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }

                             posCount.add(daysCount);
                           %>
//
                            <%



                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;


                                 for(jneg=1;jneg<=dates.size();jneg++){
                                     if(jneg<=(7*week)){
                                        for(temp=0;temp<myListnegSum.size();temp++){
                                            if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        negCount.add(daysCount);

                                                         daysCount=0;
                                                         if((jneg-1)==(7*week)){
                                                            for(temp=0;temp<myListnegSum.size();temp++){
                                                                if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                                    daysCount=daysCount+1;
                                                                }
                                                            }
                                                         }
                                                            week++;

                                                         }
                                                     }

                                                     negCount.add(daysCount);
                                                     %>
//
                            <%

                                             daysCount =0;
                                             numOfDays =1;
                                             week = 1;
                                             temp=0;


                                             for(jneut=1;jneut<=dates.size();jneut++){
                                                 if(jneut<=(7*week)){
                                                    for(temp=0;temp<myListneutSum.size();temp++){
                                                        if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                            daysCount=daysCount+1;
                                                        }
                                                    }
                                                 }
                                                 else{

                                                    neutCount.add(daysCount);

                                         daysCount=0;
                                         if((jneut-1)==(7*week)){
                                            for(temp=0;temp<myListneutSum.size();temp++){
                                                if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                    daysCount=daysCount+1;
                                                }
                                            }
                                         }
                                            week++;

                                         }
                                     }

                                    neutCount.add(daysCount);

                                    %>
//
                            <%

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;


                                 for(jvneg=1;jvneg<=dates.size();jvneg++){
                                     if(jvneg<=(7*week)){
                                        for(temp=0;temp<myListvnegSum.size();temp++){
                                            if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                       vnegCount.add(daysCount);

                             daysCount=0;
                             if((jvneg-1)==(7*week)){
                                for(temp=0;temp<myListvnegSum.size();temp++){
                                    if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                        daysCount=daysCount+1;
                                    }
                                }
                             }
                                week++;

                             }
                         }

                            vnegCount.add(daysCount);
                            %>
//
                            <%

                           daysCount =0;
                           numOfDays =1;
                           week = 1;
                           temp=0;


                            for(jvpos=1;jvpos<=dates.size();jvpos++){
                                if(jvpos<=(7*week)){
                                   for(temp=0;temp<myListvposSum.size();temp++){
                                       if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                           daysCount=daysCount+1;
                                       }
                                   }
                                }
                                else{

                                   vposCount.add(daysCount);

                               daysCount=0;
                               if((jvpos-1)==(7*week)){
                                  for(temp=0;temp<myListvposSum.size();temp++){
                                      if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                          daysCount=daysCount+1;
                                      }
                                  }
                               }
                                  week++;

                               }
                           }

                            vposCount.add(daysCount);
                       %>

//calcualting value
                            <%
                                    valposCount = posCount.size();
                                    valnegCount = negCount.size();
                                    valneutCount = neutCount.size();
                                    valvnegCount = vnegCount.size();
                                    valvposCount = vposCount.size();
                                    data.add(valposCount);
                                    data.add(valnegCount);
                                    data.add(valneutCount);
                                    data.add(valvnegCount);
                                    data.add(valvposCount);
                                    Collections.sort(data);
                                    maxValue = data.get(4);
                                    java.util.List<Integer> posTotalList = new ArrayList<Integer>();

                                    for(int m=0;m<maxValue;m++){
                                        if(m<valposCount){
                                            posPresent = posCount.get(m);
                                        }else{
                                            posPresent = 0;
                                        }
                                        if(m<valnegCount){
                                            negPresent = negCount.get(m);
                                        }else{
                                            negPresent = 0;
                                        }
                                        if(m<valneutCount){
                                            neutPresent = neutCount.get(m);
                                        }else{
                                            neutPresent = 0;
                                        }
                                        if(m<valvnegCount){
                                            vnegPresent = vnegCount.get(m);
                                        }else{
                                            vnegPresent = 0;
                                        }
                                        if(m<valvposCount){
                                            vposPresent = vposCount.get(m);
                                        }else{
                                            vposPresent = 0;
                                        }
                                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                                        if(sum!=0){
                                        %>
                            <%=posPresent%>,

                            <%
                                }
                            }

                            %>

                        ]

                    },
                    {
                        name: 'Negative Count',
                        type: 'column',
                        color: 'rgba(223, 83, 83, .5)',
                        yAxis: 1,
                        data: [
                            <%
                        for(int m=0;m<maxValue;m++){
                        if(m<valposCount){
                            posPresent = posCount.get(m);
                        }else{
                            posPresent = 0;
                        }
                        if(m<valnegCount){
                            negPresent = negCount.get(m);
                        }else{
                            negPresent = 0;
                        }
                        if(m<valneutCount){
                            neutPresent = neutCount.get(m);
                        }else{
                            neutPresent = 0;
                        }
                        if(m<valvnegCount){
                            vnegPresent = vnegCount.get(m);
                        }else{
                            vnegPresent = 0;
                        }
                        if(m<valvposCount){
                            vposPresent = vposCount.get(m);
                        }else{
                            vposPresent = 0;
                        }
                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                        if(sum!=0){
                        %>
                            <%=negPresent%>,

                            <%
                                }
                            }

                            %>
                        ]
                    },
                    {
                        name: 'Neutral Count',
                        type: 'column',
                        color: '#40A0A0',
                        yAxis: 1,
                        data: [
                            <%
                        for(int m=0;m<maxValue;m++){
                        if(m<valposCount){
                            posPresent = posCount.get(m);
                        }else{
                            posPresent = 0;
                        }
                        if(m<valnegCount){
                            negPresent = negCount.get(m);
                        }else{
                            negPresent = 0;
                        }
                        if(m<valneutCount){
                            neutPresent = neutCount.get(m);
                        }else{
                            neutPresent = 0;
                        }
                        if(m<valvnegCount){
                            vnegPresent = vnegCount.get(m);
                        }else{
                            vnegPresent = 0;
                        }
                        if(m<valvposCount){
                            vposPresent = vposCount.get(m);
                        }else{
                            vposPresent = 0;
                        }
                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                        if(sum!=0){
                        %>
                            <%=neutPresent%>,

                            <%
                                }
                            }

                            %>
                        ]
                    },
                    {
                        name: 'Very Positive Count',
                        type: 'column',
                        color: '#009933',
                        yAxis: 1,
                        data: [
                            <%
                        for(int m=0;m<maxValue;m++){
                        if(m<valposCount){
                            posPresent = posCount.get(m);
                        }else{
                            posPresent = 0;
                        }
                        if(m<valnegCount){
                            negPresent = negCount.get(m);
                        }else{
                            negPresent = 0;
                        }
                        if(m<valneutCount){
                            neutPresent = neutCount.get(m);
                        }else{
                            neutPresent = 0;
                        }
                        if(m<valvnegCount){
                            vnegPresent = vnegCount.get(m);
                        }else{
                            vnegPresent = 0;
                        }
                        if(m<valvposCount){
                            vposPresent = vposCount.get(m);
                        }else{
                            vposPresent = 0;
                        }
                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                        if(sum!=0){
                        %>
                            <%=vposPresent%>,

                            <%
                                }
                            }

                            %>
                        ]
                    },
                    {
                        name: 'Very Negative Count',
                        type: 'column',
                        color: '#FF0000',
                        yAxis: 1,
                        data: [
                            <%
                        for(int m=0;m<maxValue;m++){
                        if(m<valposCount){
                            posPresent = posCount.get(m);
                        }else{
                            posPresent = 0;
                        }
                        if(m<valnegCount){
                            negPresent = negCount.get(m);
                        }else{
                            negPresent = 0;
                        }
                        if(m<valneutCount){
                            neutPresent = neutCount.get(m);
                        }else{
                            neutPresent = 0;
                        }
                        if(m<valvnegCount){
                            vnegPresent = vnegCount.get(m);
                        }else{
                            vnegPresent = 0;
                        }
                        if(m<valvposCount){
                            vposPresent = vposCount.get(m);
                        }else{
                            vposPresent = 0;
                        }
                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                        if(sum!=0){
                        %>
                            <%=vnegPresent%>,

                            <%
                                }
                            }

                            %>
                        ]
                    },
                    {
                        name: 'Sentiment',
                        type: 'line',
                        color: '#6600CC',
                        data: [
                            <%



                            j=0;
                            k=1;
                            f =0;
                            val = "";
                            tempval="";
                            splitVal = new String[3];
                            checkPos=0;
                            count=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////
                             daysCount =0;
                             numOfDays =1;
                             week = 1;
                             temp=0;
                             posCount.clear();

                             for(j=1;j<=dates.size();j++){
                                 if(j<=(7*week)){
                                    for(temp=0;temp<myListSum.size();temp++){
                                        if(dates.get(j-1).equals(myListSum.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                 else{

                                    posCount.add(daysCount);

                                 daysCount=0;
                                 if((j-1)==(7*week)){
                                    for(temp=0;temp<myListSum.size();temp++){
                                        if(dates.get(j-1).equals(myListSum.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }

                             posCount.add(daysCount);
                           %>
//
                            <% jneg=0;
                               kneg=1;
                                fneg =0;
                                valneg = "";
                                tempvalneg="";
                                splitValneg = new String[3];
                                checkNeg = false;
                                countNeg=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 negCount.clear();


                                 for(jneg=1;jneg<=dates.size();jneg++){
                                     if(jneg<=(7*week)){
                                        for(temp=0;temp<myListnegSum.size();temp++){
                                            if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        negCount.add(daysCount);

                                                         daysCount=0;
                                                         if((jneg-1)==(7*week)){
                                                            for(temp=0;temp<myListnegSum.size();temp++){
                                                                if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                                    daysCount=daysCount+1;
                                                                }
                                                            }
                                                         }
                                                            week++;

                                                         }
                                                     }

                                                     negCount.add(daysCount);
                                                     %>
//
                            <% jneut=0;
                                            kneut=1;
                                            fneut =0;
                                            valneut = "";
                                            tempvalneut="";
                                            splitValneut = new String[3];
                                            checkNeut = 0;
                                            countNeut=0;

                                            /////////////////////////////////////weekly/////////////////////////////////////////////////

                                             daysCount =0;
                                             numOfDays =1;
                                             week = 1;
                                             temp=0;
                                             neutCount.clear();

                                             for(jneut=1;jneut<=dates.size();jneut++){
                                                 if(jneut<=(7*week)){
                                                    for(temp=0;temp<myListneutSum.size();temp++){
                                                        if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                            daysCount=daysCount+1;
                                                        }
                                                    }
                                                 }
                                                 else{

                                                    neutCount.add(daysCount);

                                         daysCount=0;
                                         if((jneut-1)==(7*week)){
                                            for(temp=0;temp<myListneutSum.size();temp++){
                                                if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                    daysCount=daysCount+1;
                                                }
                                            }
                                         }
                                            week++;

                                         }
                                     }

                                    neutCount.add(daysCount);

                                    %>
//
                            <% jvneg=0;
                               kvneg=1;
                                fvneg =0;
                                valvneg = "";
                                tempvalvneg ="";
                                splitValvneg = new String[3];
                                checkVneg =0;
                                countVneg=0;

                                 /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 vnegCount.clear();

                                 for(jvneg=1;jvneg<=dates.size();jvneg++){
                                     if(jvneg<=(7*week)){
                                        for(temp=0;temp<myListvnegSum.size();temp++){
                                            if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                       vnegCount.add(daysCount);

                             daysCount=0;
                             if((jvneg-1)==(7*week)){
                                for(temp=0;temp<myListvnegSum.size();temp++){
                                    if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                        daysCount=daysCount+1;
                                    }
                                }
                             }
                                week++;

                             }
                         }

                            vnegCount.add(daysCount);
                            %>
//
                            <% jvpos=0;
                           kvpos=1;
                           fvpos =0;
                           valvpos = "";
                            tempvalvpos="";
                            splitValvpos = new String[3];
                           checkVpos = 0;
                           countVpos=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////

                           daysCount =0;
                           numOfDays =1;
                           week = 1;
                           temp=0;
                           vposCount.clear();

                            for(jvpos=1;jvpos<=dates.size();jvpos++){
                                if(jvpos<=(7*week)){
                                   for(temp=0;temp<myListvposSum.size();temp++){
                                       if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                           daysCount=daysCount+1;
                                       }
                                   }
                                }
                                else{

                                   vposCount.add(daysCount);

                               daysCount=0;
                               if((jvpos-1)==(7*week)){
                                  for(temp=0;temp<myListvposSum.size();temp++){
                                      if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                          daysCount=daysCount+1;
                                      }
                                  }
                               }
                                  week++;

                               }
                           }

                            vposCount.add(daysCount);
                       %>

//calcualting value
                            <%
                                    valposCount = posCount.size();
                                    valnegCount = negCount.size();
                                    valneutCount = neutCount.size();
                                    valvnegCount = vnegCount.size();
                                    valvposCount = vposCount.size();
                                    data.clear();
                                    data.add(valposCount);
                                    data.add(valnegCount);
                                    data.add(valneutCount);
                                    data.add(valvnegCount);
                                    data.add(valvposCount);
                                    Collections.sort(data);
                                    maxValue = data.get(4);

                                    for(int m=0;m<maxValue;m++){
                                        if(m<valposCount){
                                            posPresent = posCount.get(m);
                                        }else{
                                            posPresent = 0;
                                        }
                                        if(m<valnegCount){
                                            negPresent = negCount.get(m);
                                        }else{
                                            negPresent = 0;
                                        }
                                        if(m<valneutCount){
                                            neutPresent = neutCount.get(m);
                                        }else{
                                            neutPresent = 0;
                                        }
                                        if(m<valvnegCount){
                                            vnegPresent = vnegCount.get(m);
                                        }else{
                                            vnegPresent = 0;
                                        }
                                        if(m<valvposCount){
                                            vposPresent = vposCount.get(m);
                                        }else{
                                            vposPresent = 0;
                                        }
                                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                                        if(sum!=0){
                                        %>
                            <%=sop%>,

                            <%
                                }
                            }

                            %>

                        ]

                    },
                    <% }%>
                        <%}else {%>{
                        name: 'Sentiment',
                        type: 'line',
                        data:[0]

                    },{
                        name: 'NewsCount',
                        type: 'column',
                        yAxis: 1,
                        data:[0]

                    }

                    <% }%>

                ],
                xAxis: [
                    {
                        categories: [
                            <%
                            if(myListSum!=null||myListnegSum!=null||myListneutSum!=null||myListvnegSum!=null||myListvposSum!=null){


                                int j=0;
                                int k=1;
                                double f =0;
                                String val = "";
                                String tempval="";
                                String[] splitVal = new String[3];
                                int checkPos=0;
                                int count=0;

                               /////////////////////////////////////weekly/////////////////////////////////////////////////
                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;
                                 ArrayList<Integer> posCount = new ArrayList<Integer>();

                                 for(j=1;j<=dates.size();j++){
                                     if(j<=(7*week)){
                                        for(temp=0;temp<myListSum.size();temp++){
                                            if(dates.get(j-1).equals(myListSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        posCount.add(daysCount);

                                     daysCount=0;
                                     if((j-1)==(7*week)){
                                        for(temp=0;temp<myListSum.size();temp++){
                                            if(dates.get(j-1).equals(myListSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                        week++;

                                     }
                                 }

                                 posCount.add(daysCount);
                               %>
//
                            <% int jneg=0;
                                int kneg=1;
                                double fneg =0;
                                String valneg = "";
                                String tempvalneg="";
                                String[] splitValneg = new String[3];
                                boolean checkNeg = false;
                                int countNeg=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 ArrayList<Integer> negCount = new ArrayList<Integer>();

                                 for(jneg=1;jneg<=dates.size();jneg++){
                                     if(jneg<=(7*week)){
                                        for(temp=0;temp<myListnegSum.size();temp++){
                                            if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        negCount.add(daysCount);

                                                         daysCount=0;
                                                         if((jneg-1)==(7*week)){
                                                            for(temp=0;temp<myListnegSum.size();temp++){
                                                                if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                                    daysCount=daysCount+1;
                                                                }
                                                            }
                                                         }
                                                            week++;

                                                         }
                                                     }

                                                     negCount.add(daysCount);
                                                     %>
//
                            <% int jneut=0;
                                            int kneut=1;
                                            double fneut =0;
                                            String valneut = "";
                                            String tempvalneut="";
                                            String[] splitValneut = new String[3];
                                            int checkNeut = 0;
                                            int countNeut=0;

                                            /////////////////////////////////////weekly/////////////////////////////////////////////////

                                             daysCount =0;
                                             numOfDays =1;
                                             week = 1;
                                             temp=0;
                                             ArrayList<Integer> neutCount = new ArrayList<Integer>();

                                             for(jneut=1;jneut<=dates.size();jneut++){
                                                 if(jneut<=(7*week)){
                                                    for(temp=0;temp<myListneutSum.size();temp++){
                                                        if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                            daysCount=daysCount+1;
                                                        }
                                                    }
                                                 }
                                                 else{

                                                    neutCount.add(daysCount);

                                         daysCount=0;
                                         if((jneut-1)==(7*week)){
                                            for(temp=0;temp<myListneutSum.size();temp++){
                                                if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                    daysCount=daysCount+1;
                                                }
                                            }
                                         }
                                            week++;

                                         }
                                     }

                                    neutCount.add(daysCount);

                                    %>
//
                            <% int jvneg=0;
                                int kvneg=1;
                                double fvneg =0;
                                String valvneg = "";
                                String tempvalvneg ="";
                                String[] splitValvneg = new String[3];
                                int checkVneg =0;
                                int countVneg=0;

                                 /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 ArrayList<Integer> vnegCount = new ArrayList<Integer>();

                                 for(jvneg=1;jvneg<=dates.size();jvneg++){
                                     if(jvneg<=(7*week)){
                                        for(temp=0;temp<myListvnegSum.size();temp++){
                                            if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                       vnegCount.add(daysCount);

                             daysCount=0;
                             if((jvneg-1)==(7*week)){
                                for(temp=0;temp<myListvnegSum.size();temp++){
                                    if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                        daysCount=daysCount+1;
                                    }
                                }
                             }
                                week++;

                             }
                         }

                            vnegCount.add(daysCount);
                            %>
//
                            <% int jvpos=0;
                           int kvpos=1;
                           double fvpos =0;
                           String valvpos = "";
                           String tempvalvpos="";
                           String[] splitValvpos = new String[3];
                           int checkVpos = 0;
                           int countVpos=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////

                           daysCount =0;
                           numOfDays =1;
                           week = 1;
                           temp=0;
                           ArrayList<Integer> vposCount = new ArrayList<Integer>();

                            for(jvpos=1;jvpos<=dates.size();jvpos++){
                                if(jvpos<=(7*week)){
                                   for(temp=0;temp<myListvposSum.size();temp++){
                                       if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                           daysCount=daysCount+1;
                                       }
                                   }
                                }
                                else{

                                   vposCount.add(daysCount);

                               daysCount=0;
                               if((jvpos-1)==(7*week)){
                                  for(temp=0;temp<myListvposSum.size();temp++){
                                      if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                          daysCount=daysCount+1;
                                      }
                                  }
                               }
                                  week++;

                               }
                           }

                            vposCount.add(daysCount);
                       %>

//calcualting value
                            <%
                                    int valposCount = posCount.size();
                                    int valnegCount = negCount.size();
                                    int valneutCount = neutCount.size();
                                    int valvnegCount = vnegCount.size();
                                    int valvposCount = vposCount.size();
                                    java.util.List<Integer> data = new ArrayList<Integer>();
                                    data.add(valposCount);
                                    data.add(valnegCount);
                                    data.add(valneutCount);
                                    data.add(valvnegCount);
                                    data.add(valvposCount);
                                    Collections.sort(data);
                                    int maxValue = data.get(4);
                                    java.util.List<Integer> posTotalList = new ArrayList<Integer>();

                                    for(int m=0;m<maxValue;m++){
                                        if(m<valposCount){
                                            posPresent = posCount.get(m);
                                        }else{
                                            posPresent = 0;
                                        }
                                        if(m<valnegCount){
                                            negPresent = negCount.get(m);
                                        }else{
                                            negPresent = 0;
                                        }
                                        if(m<valneutCount){
                                            neutPresent = neutCount.get(m);
                                        }else{
                                            neutPresent = 0;
                                        }
                                        if(m<valvnegCount){
                                            vnegPresent = vnegCount.get(m);
                                        }else{
                                            vnegPresent = 0;
                                        }
                                        if(m<valvposCount){
                                            vposPresent = vposCount.get(m);
                                        }else{
                                            vposPresent = 0;
                                        }
                                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                                        if(sum!=0){
                                        %>
                            '<%=m+1%>',
                            <%}}%>

                            <%} else {%>
                            '1'
                            <%}%>
                        ]

                    }]

            }

    );

    //////////////////////////////summed up/////////////////////////////////////////////////////////////////////////////
    <%if(request.getAttribute("fromSearch")!= null && request.getAttribute("fromSearch").equals("present")){%>
    $('#container4').highcharts({

                chart: {
                    zoomType: 'xy'
                },

                title: {
                    text: 'Weekly trend comparison'
                },
                yAxis: [{//primary
                    title: {
                        text: 'Sentiment',
                        style: {
                            color: '#853385'
                        }
                    }
                }
                ],
                <%--tooltip:{--%>
                <%--headerFormat: '<b>Overall sentiments</b><br>',--%>
                <%--pointFormat: '<table><tr><td><b>Sentiments<b></td><td>Count</td></tr>' +--%>
                <%--'<tr><td>Positive</td><td><%=sum%></td></tr></table>{point.x:%e. %b}'--%>
                <%--},--%>
                plotOptions:{
                    series: {
                        cursor: 'pointer',
                        point: {
                            events: {
                                click: function() {
                                    var name = this.series.name;

                                    <% posTitleSum = (ArrayList)request.getAttribute("positiveTitle");
                                                    posNewsSum = (ArrayList)request.getAttribute("positiveNews");
                                                    posDateSum = (ArrayList)request.getAttribute("positiveDate");
                                                    negTitleSum = (ArrayList)request.getAttribute("negativeTitle");
                                                    negNewsSum = (ArrayList)request.getAttribute("negativeNews");
                                                    negDateSum = (ArrayList)request.getAttribute("negativeDate");
                                                    neutTitleSum = (ArrayList)request.getAttribute("neutralTitle");
                                                    neutNewsSum = (ArrayList)request.getAttribute("neutralNews");
                                                    neutDateSum = (ArrayList)request.getAttribute("neutralDate");
                                                    vnegTitleSum = (ArrayList)request.getAttribute("vnegativeTitle");
                                                    vnegNewsSum = (ArrayList)request.getAttribute("vnegativeNews");
                                                    vnegDateSum = (ArrayList)request.getAttribute("vnegativeDate");
                                                    vposTitleSum = (ArrayList)request.getAttribute("vpositiveTitle");
                                                    vposNewsSum = (ArrayList)request.getAttribute("vpositiveNews");
                                                    vposDateSum = (ArrayList)request.getAttribute("vpositiveDate");
                                                    posSourceSum = (ArrayList)request.getAttribute("positiveSource");
                                                    negSourceSum = (ArrayList)request.getAttribute("negativeSource");
                                                    neutSourceSum = (ArrayList)request.getAttribute("neutralSource");
                                                    vnegSourceSum = (ArrayList)request.getAttribute("vnegativeSource");
                                                    vposSourceSum = (ArrayList)request.getAttribute("vpositiveSource");
//                                                    System.out.println("asdf"+posTitleSum);
//                                                    System.out.println("asdf"+negTitleSum);
//                                                    System.out.println("asdf"+neutTitleSum);
//                                                    System.out.println("asdfPOS"+vposTitleSum);
//                                                    System.out.println("asdfNEG"+vnegTitleSum);
                                ArrayList posTitleSum1 = (ArrayList)request.getAttribute("positiveTitle2");
                                                    ArrayList posNewsSum1 = (ArrayList)request.getAttribute("positiveNews2");
                                                    ArrayList posDateSum1 = (ArrayList)request.getAttribute("positiveDate2");
                                                    ArrayList negTitleSum1 = (ArrayList)request.getAttribute("negativeTitle2");
                                                    ArrayList negNewsSum1 = (ArrayList)request.getAttribute("negativeNews2");
                                                    ArrayList negDateSum1 = (ArrayList)request.getAttribute("negativeDate2");
                                                    ArrayList neutTitleSum1 = (ArrayList)request.getAttribute("neutralTitle2");
                                                    ArrayList neutNewsSum1 = (ArrayList)request.getAttribute("neutralNews2");
                                                    ArrayList neutDateSum1 = (ArrayList)request.getAttribute("neutralDate2");
                                                    ArrayList vnegTitleSum1 = (ArrayList)request.getAttribute("vnegativeTitle2");
                                                    ArrayList vnegNewsSum1 = (ArrayList)request.getAttribute("vnegativeNews2");
                                                    ArrayList vnegDateSum1 = (ArrayList)request.getAttribute("vnegativeDate2");
                                                    ArrayList vposTitleSum1 = (ArrayList)request.getAttribute("vpositiveTitle2");
                                                    ArrayList vposNewsSum1 = (ArrayList)request.getAttribute("vpositiveNews2");
                                                    ArrayList vposDateSum1 = (ArrayList)request.getAttribute("vpositiveDate2");
                                                    ArrayList posSourceSum1 = (ArrayList)request.getAttribute("positiveSource2");
                                                    ArrayList negSourceSum1 = (ArrayList)request.getAttribute("negativeSource2");
                                                    ArrayList neutSourceSum1 = (ArrayList)request.getAttribute("neutralSource2");
                                                    ArrayList vnegSourceSum1 = (ArrayList)request.getAttribute("vnegativeSource2");
                                                    ArrayList vposSourceSum1 = (ArrayList)request.getAttribute("vpositiveSource2");
                                                   noPosSum=false;
                                                    noNegSum=false;
                                                    noNeutSum=false;
                                                     noVnegSum=false;
                                                     noVposSum=false;
                                                     sum = 0;  sop =0;  posPresent=0;  negPresent=0;  neutPresent=0;  vnegPresent=0;   vposPresent=0;



                                                    if(posTitleSum!=null || posNewsSum!=null || negNewsSum!=null || negTitleSum!=null || neutTitleSum!=null || neutNewsSum!=null ||vnegTitleSum!=null||vnegNewsSum!=null||vposTitleSum!=null||vposNewsSum!=null||posDateSum!=null||negDateSum!=null||neutDateSum!=null||vposDateSum!=null||vnegDateSum!=null||dates!=null||posTitleSum1!=null || posNewsSum1!=null || negNewsSum1!=null || negTitleSum1!=null || neutTitleSum1!=null || neutNewsSum1!=null ||vnegTitleSum1!=null||vnegNewsSum1!=null||vposTitleSum1!=null||vposNewsSum1!=null||posDateSum1!=null||negDateSum1!=null||neutDateSum1!=null||vposDateSum1!=null||vnegDateSum1!=null){
                                                    if(negTitleSum.get(0).equals("NoValue")){

                                                    }else{

                                                    }
                                                    %>
                                    if(this.series.name=='<%=request.getParameter("search")%>') {
                                        <%if(posTitleSum.get(0).equals("NoValue")&&negTitleSum.get(0).equals("NoValue")&&neutTitleSum.get(0).equals("NoValue")&&vposTitleSum.get(0).equals("NoValue")&&vnegTitleSum.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!posTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<posTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)posNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Positive</td><td><a href='+"<%=posTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=posDateSum.get(tempTitle)%>"+'</td><td><%=posSourceSum.get(tempTitle)%></td><td><select class="positive" id="op<%=tempTitle%>" data-news="<%=posTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5" selected="selected">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!negTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<negTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)negNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Negative</td><td><a href='+"<%=negTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=negDateSum.get(tempTitle)%>"+'</td><td><%=negSourceSum.get(tempTitle)%></td><td><select class="negative" id="op<%=tempTitle%>" data-news="<%=negTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5" selected="selected">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!neutTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<neutTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)neutNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Neutral</td><td><a href='+"<%=neutTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=neutDateSum.get(tempTitle)%>"+'</td><td><%=neutSourceSum.get(tempTitle)%></td><td><select class="neutral" id="op<%=tempTitle%>" data-news="<%=neutTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" selected="selected">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!vposTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vposTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)vposNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very positive</td><td><a href='+"<%=vposTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vposDateSum.get(tempTitle)%>"+'</td><td><%=vposSourceSum.get(tempTitle)%></td><td><select class="veryPositive" id="op<%=tempTitle%>" data-news="<%=vposTitleSum.get(tempTitle)%>"><option value="1" selected="selected">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!vnegTitleSum.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vnegTitleSum.size();tempTitle++){
                                                        replacingQuotes= (String)vnegNewsSum.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very negative</td><td><a href='+"<%=vnegTitleSum.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vnegDateSum.get(tempTitle)%>"+'</td><td><%=vnegSourceSum.get(tempTitle)%></td><td><select class="veryNegative" id="op<%=tempTitle%>" data-news="<%=vnegTitleSum.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" >Neutral</option><option value="-0.5">Negative</option><option value="-1" selected="selected">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
                                        <%}%>
                                    }
                                    else if(this.series.name=='<%=request.getParameter("search1")%>') {
                                        <%if(posTitleSum1.get(0).equals("NoValue")&&negTitleSum1.get(0).equals("NoValue")&&neutTitleSum1.get(0).equals("NoValue")&&vposTitleSum1.get(0).equals("NoValue")&&vnegTitleSum1.get(0).equals("NoValue")){
                                            //do nothing
                                        }else{
                                        %>
                                        $report.html('<table>'+
                                                        '<tr><td><b>Sentiment</b></td><td><b>News</b></td><td><b>Date</b></td><td><b>News Courtesy</b></td><td><b>User Opinion</b></td></tr>' +
                                                        <%
                                                        if(!posTitleSum1.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<posTitleSum1.size();tempTitle++){
                                                        replacingQuotes= (String)posNewsSum1.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Positive</td><td><a href='+"<%=posTitleSum1.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=posDateSum1.get(tempTitle)%>"+'</td><td><%=posSourceSum1.get(tempTitle)%></td><td><select class="positive" id="op<%=tempTitle%>" data-news="<%=posTitleSum1.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5" selected="selected">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!negTitleSum1.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<negTitleSum1.size();tempTitle++){
                                                        replacingQuotes= (String)negNewsSum1.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Negative</td><td><a href='+"<%=negTitleSum1.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=negDateSum1.get(tempTitle)%>"+'</td><td><%=negSourceSum1.get(tempTitle)%></td><td><select class="negative" id="op<%=tempTitle%>" data-news="<%=negTitleSum1.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5" selected="selected">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!neutTitleSum1.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<neutTitleSum1.size();tempTitle++){
                                                        replacingQuotes= (String)neutNewsSum1.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Neutral</td><td><a href='+"<%=neutTitleSum1.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=neutDateSum1.get(tempTitle)%>"+'</td><td><%=neutSourceSum1.get(tempTitle)%></td><td><select class="neutral" id="op<%=tempTitle%>" data-news="<%=neutTitleSum1.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" selected="selected">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!vposTitleSum1.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vposTitleSum1.size();tempTitle++){
                                                        replacingQuotes= (String)vposNewsSum1.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very positive</td><td><a href='+"<%=vposTitleSum1.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vposDateSum1.get(tempTitle)%>"+'</td><td><%=vposSourceSum1.get(tempTitle)%></td><td><select class="veryPositive" id="op<%=tempTitle%>" data-news="<%=vposTitleSum1.get(tempTitle)%>"><option value="1" selected="selected">Very Positive</option><option value="0.5">Positive</option><option value="0">Neutral</option><option value="-0.5">Negative</option><option value="-1">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        <%
                                                        if(!vnegTitleSum1.get(0).equals("NoValue")){
                                                        for(int tempTitle=0;tempTitle<vnegTitleSum1.size();tempTitle++){
                                                        replacingQuotes= (String)vnegNewsSum1.get(tempTitle);replacingQuotes=replacingQuotes.replaceAll("'","&#180;");
                                                        %>
                                                        '<tr><td>Very negative</td><td><a href='+"<%=vnegTitleSum1.get(tempTitle)%>"+' target = "_blank">'+"<%=replacingQuotes%>"+'</a></td><td>'+"<%=vnegDateSum1.get(tempTitle)%>"+'</td><td><%=vnegSourceSum1.get(tempTitle)%></td><td><select class="veryNegative" id="op<%=tempTitle%>" data-news="<%=vnegTitleSum1.get(tempTitle)%>"><option value="1">Very Positive</option><option value="0.5">Positive</option><option value="0" >Neutral</option><option value="-0.5">Negative</option><option value="-1" selected="selected">Very Negative</option></select></td></tr>'+
                                                        <%
                                                        }
                                                        }
                                                        %>
                                                        '</table>'+
                                                        '<script type="text/javascript">'+
                                                        'fire_on_event();'+
                                                        '</'+'script>'
                                        );
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
                    },
                    column: {
                        stacking: 'normal'
                    }
                },

                series:  [
                    <%myListSum = (ArrayList)request.getAttribute("positiveDate");
                    myListnegSum = (ArrayList)request.getAttribute("negativeDate");
                    myListneutSum = (ArrayList)request.getAttribute("neutralDate");
                    myListvnegSum = (ArrayList)request.getAttribute("vnegativeDate");
                    myListvposSum = (ArrayList)request.getAttribute("vpositiveDate");

                    ArrayList myListSum1 = (ArrayList)request.getAttribute("positiveDate2");
                    ArrayList myListnegSum1 = (ArrayList)request.getAttribute("negativeDate2");
                    ArrayList myListneutSum1 = (ArrayList)request.getAttribute("neutralDate2");
                    ArrayList myListvnegSum1 = (ArrayList)request.getAttribute("vnegativeDate2");
                    ArrayList myListvposSum1 = (ArrayList)request.getAttribute("vpositiveDate2");



                        if(myListSum!=null||myListnegSum!=null||myListneutSum!=null||myListvnegSum!=null||myListvposSum!=null){
                    %>
                    <%
                if(posNewsSum.get(0).equals("NoValue")&&negNewsSum.get(0).equals("NoValue")&&neutNewsSum.get(0).equals("NoValue")&&vnegNewsSum.get(0).equals("NoValue")&&vposNewsSum.get(0).equals("NoValue"))
                {
                    //do nothing
                    noPosSum = true;
                }
                else{
                            int j=0;
                            int k=1;
                            double f =0;
                            String val = "";
                            String tempval="";
                            String[] splitVal = new String[3];
                            int checkPos=0;
                            int count=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////
                             int daysCount =0;
                             int numOfDays =1;
                             int week = 1;
                             int temp=0;
                             ArrayList<Integer> posCount = new ArrayList<Integer>();

                             int jneg=0;
                                int kneg=1;
                                double fneg =0;
                                String valneg = "";
                                String tempvalneg="";
                                String[] splitValneg = new String[3];
                                boolean checkNeg = false;
                                int countNeg=0;
                                ArrayList<Integer> negCount = new ArrayList<Integer>();
                             /////////////////////////////////////weekly/////////////////////////////////////////////////

                                            int jneut=0;
                                            int kneut=1;
                                            double fneut =0;
                                            String valneut = "";
                                            String tempvalneut="";
                                            String[] splitValneut = new String[3];
                                            int checkNeut = 0;
                                            int countNeut=0;
                                            ArrayList<Integer> neutCount = new ArrayList<Integer>();

                             /////////////////////////////////////weekly/////////////////////////////////////////////////
                             int jvneg=0;
                                int kvneg=1;
                                double fvneg =0;
                                String valvneg = "";
                                String tempvalvneg ="";
                                String[] splitValvneg = new String[3];
                                int checkVneg =0;
                                int countVneg=0;
                                ArrayList<Integer> vnegCount = new ArrayList<Integer>();

                             /////////////////////////////////////weekly/////////////////////////////////////////////////
                             int jvpos=0;
                           int kvpos=1;
                           double fvpos =0;
                           String valvpos = "";
                           String tempvalvpos="";
                           String[] splitValvpos = new String[3];
                           int checkVpos = 0;
                           int countVpos=0;
                           ArrayList<Integer> vposCount = new ArrayList<Integer>();

                           /////////////////////////////////////weekly/////////////////////////////////////////////////
                                    int valposCount = 0;
                                    int valnegCount = 0;
                                    int valneutCount = 0;
                                    int valvnegCount = 0;
                                    int valvposCount = 0;
                                    int maxValue=0;
                                    java.util.List<Integer> data = new ArrayList<Integer>();
                %>

                    {
                        name: '<%=request.getParameter("search")%>',
                        type: 'line',
                        color: '#6600CC',
                        data: [
                            <%



                            j=0;
                            k=1;
                            f =0;
                            val = "";
                            tempval="";
                            splitVal = new String[3];
                            checkPos=0;
                            count=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////
                             daysCount =0;
                             numOfDays =1;
                             week = 1;
                             temp=0;
                             posCount.clear();

                             for(j=1;j<=dates.size();j++){
                                 if(j<=(7*week)){
                                    for(temp=0;temp<myListSum.size();temp++){
                                        if(dates.get(j-1).equals(myListSum.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                 else{

                                    posCount.add(daysCount);

                                 daysCount=0;
                                 if((j-1)==(7*week)){
                                    for(temp=0;temp<myListSum.size();temp++){
                                        if(dates.get(j-1).equals(myListSum.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }

                             posCount.add(daysCount);
                           %>
//
                            <% jneg=0;
                               kneg=1;
                                fneg =0;
                                valneg = "";
                                tempvalneg="";
                                splitValneg = new String[3];
                                checkNeg = false;
                                countNeg=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 negCount.clear();


                                 for(jneg=1;jneg<=dates.size();jneg++){
                                     if(jneg<=(7*week)){
                                        for(temp=0;temp<myListnegSum.size();temp++){
                                            if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        negCount.add(daysCount);

                                                         daysCount=0;
                                                         if((jneg-1)==(7*week)){
                                                            for(temp=0;temp<myListnegSum.size();temp++){
                                                                if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                                    daysCount=daysCount+1;
                                                                }
                                                            }
                                                         }
                                                            week++;

                                                         }
                                                     }

                                                     negCount.add(daysCount);
                                                     %>
//
                            <% jneut=0;
                                            kneut=1;
                                            fneut =0;
                                            valneut = "";
                                            tempvalneut="";
                                            splitValneut = new String[3];
                                            checkNeut = 0;
                                            countNeut=0;

                                            /////////////////////////////////////weekly/////////////////////////////////////////////////

                                             daysCount =0;
                                             numOfDays =1;
                                             week = 1;
                                             temp=0;
                                             neutCount.clear();

                                             for(jneut=1;jneut<=dates.size();jneut++){
                                                 if(jneut<=(7*week)){
                                                    for(temp=0;temp<myListneutSum.size();temp++){
                                                        if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                            daysCount=daysCount+1;
                                                        }
                                                    }
                                                 }
                                                 else{

                                                    neutCount.add(daysCount);

                                         daysCount=0;
                                         if((jneut-1)==(7*week)){
                                            for(temp=0;temp<myListneutSum.size();temp++){
                                                if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                    daysCount=daysCount+1;
                                                }
                                            }
                                         }
                                            week++;

                                         }
                                     }

                                    neutCount.add(daysCount);

                                    %>
//
                            <% jvneg=0;
                               kvneg=1;
                                fvneg =0;
                                valvneg = "";
                                tempvalvneg ="";
                                splitValvneg = new String[3];
                                checkVneg =0;
                                countVneg=0;

                                 /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 vnegCount.clear();

                                 for(jvneg=1;jvneg<=dates.size();jvneg++){
                                     if(jvneg<=(7*week)){
                                        for(temp=0;temp<myListvnegSum.size();temp++){
                                            if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                       vnegCount.add(daysCount);

                             daysCount=0;
                             if((jvneg-1)==(7*week)){
                                for(temp=0;temp<myListvnegSum.size();temp++){
                                    if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                        daysCount=daysCount+1;
                                    }
                                }
                             }
                                week++;

                             }
                         }

                            vnegCount.add(daysCount);
                            %>
//
                            <% jvpos=0;
                           kvpos=1;
                           fvpos =0;
                           valvpos = "";
                            tempvalvpos="";
                            splitValvpos = new String[3];
                           checkVpos = 0;
                           countVpos=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////

                           daysCount =0;
                           numOfDays =1;
                           week = 1;
                           temp=0;
                           vposCount.clear();

                            for(jvpos=1;jvpos<=dates.size();jvpos++){
                                if(jvpos<=(7*week)){
                                   for(temp=0;temp<myListvposSum.size();temp++){
                                       if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                           daysCount=daysCount+1;
                                       }
                                   }
                                }
                                else{

                                   vposCount.add(daysCount);

                               daysCount=0;
                               if((jvpos-1)==(7*week)){
                                  for(temp=0;temp<myListvposSum.size();temp++){
                                      if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                          daysCount=daysCount+1;
                                      }
                                  }
                               }
                                  week++;

                               }
                           }

                            vposCount.add(daysCount);
                       %>

//calcualting value
                            <%
                                    valposCount = posCount.size();
                                    valnegCount = negCount.size();
                                    valneutCount = neutCount.size();
                                    valvnegCount = vnegCount.size();
                                    valvposCount = vposCount.size();
                                    data.clear();
                                    data.add(valposCount);
                                    data.add(valnegCount);
                                    data.add(valneutCount);
                                    data.add(valvnegCount);
                                    data.add(valvposCount);
                                    Collections.sort(data);
                                    maxValue = data.get(4);

                                    for(int m=0;m<maxValue;m++){
                                        if(m<valposCount){
                                            posPresent = posCount.get(m);
                                        }else{
                                            posPresent = 0;
                                        }
                                        if(m<valnegCount){
                                            negPresent = negCount.get(m);
                                        }else{
                                            negPresent = 0;
                                        }
                                        if(m<valneutCount){
                                            neutPresent = neutCount.get(m);
                                        }else{
                                            neutPresent = 0;
                                        }
                                        if(m<valvnegCount){
                                            vnegPresent = vnegCount.get(m);
                                        }else{
                                            vnegPresent = 0;
                                        }
                                        if(m<valvposCount){
                                            vposPresent = vposCount.get(m);
                                        }else{
                                            vposPresent = 0;
                                        }
                                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                                        if(sum!=0){
                                        %>
                            <%=sop%>,

                            <%
                                }
                                else{%>
                            0,
                            <%}

                    }

                    %>

                        ]

                    },
                    {
                        name: '<%=request.getParameter("search1")%>',
                        type: 'line',
                        color: '#800000',
                        data: [
                            <%



                            j=0;
                            k=1;
                            f =0;
                            val = "";
                            tempval="";
                            splitVal = new String[3];
                            checkPos=0;
                            count=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////
                             daysCount =0;
                             numOfDays =1;
                             week = 1;
                             temp=0;
                             posCount.clear();

                             for(j=1;j<=dates.size();j++){
                                 if(j<=(7*week)){
                                    for(temp=0;temp<myListSum1.size();temp++){
                                        if(dates.get(j-1).equals(myListSum1.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                 else{

                                    posCount.add(daysCount);

                                 daysCount=0;
                                 if((j-1)==(7*week)){
                                    for(temp=0;temp<myListSum1.size();temp++){
                                        if(dates.get(j-1).equals(myListSum1.get(temp))){
                                            daysCount=daysCount+1;
                                        }
                                    }
                                 }
                                    week++;

                                 }
                             }

                             posCount.add(daysCount);
                           %>
//
                            <% jneg=0;
                               kneg=1;
                                fneg =0;
                                valneg = "";
                                tempvalneg="";
                                splitValneg = new String[3];
                                checkNeg = false;
                                countNeg=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 negCount.clear();


                                 for(jneg=1;jneg<=dates.size();jneg++){
                                     if(jneg<=(7*week)){
                                        for(temp=0;temp<myListnegSum1.size();temp++){
                                            if(dates.get(jneg-1).equals(myListnegSum1.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        negCount.add(daysCount);

                                                         daysCount=0;
                                                         if((jneg-1)==(7*week)){
                                                            for(temp=0;temp<myListnegSum1.size();temp++){
                                                                if(dates.get(jneg-1).equals(myListnegSum1.get(temp))){
                                                                    daysCount=daysCount+1;
                                                                }
                                                            }
                                                         }
                                                            week++;

                                                         }
                                                     }

                                                     negCount.add(daysCount);
                                                     %>
//
                            <% jneut=0;
                                            kneut=1;
                                            fneut =0;
                                            valneut = "";
                                            tempvalneut="";
                                            splitValneut = new String[3];
                                            checkNeut = 0;
                                            countNeut=0;

                                            /////////////////////////////////////weekly/////////////////////////////////////////////////

                                             daysCount =0;
                                             numOfDays =1;
                                             week = 1;
                                             temp=0;
                                             neutCount.clear();

                                             for(jneut=1;jneut<=dates.size();jneut++){
                                                 if(jneut<=(7*week)){
                                                    for(temp=0;temp<myListneutSum1.size();temp++){
                                                        if(dates.get(jneut-1).equals(myListneutSum1.get(temp))){
                                                            daysCount=daysCount+1;
                                                        }
                                                    }
                                                 }
                                                 else{

                                                    neutCount.add(daysCount);

                                         daysCount=0;
                                         if((jneut-1)==(7*week)){
                                            for(temp=0;temp<myListneutSum1.size();temp++){
                                                if(dates.get(jneut-1).equals(myListneutSum1.get(temp))){
                                                    daysCount=daysCount+1;
                                                }
                                            }
                                         }
                                            week++;

                                         }
                                     }

                                    neutCount.add(daysCount);

                                    %>
//
                            <% jvneg=0;
                               kvneg=1;
                                fvneg =0;
                                valvneg = "";
                                tempvalvneg ="";
                                splitValvneg = new String[3];
                                checkVneg =0;
                                countVneg=0;

                                 /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 vnegCount.clear();

                                 for(jvneg=1;jvneg<=dates.size();jvneg++){
                                     if(jvneg<=(7*week)){
                                        for(temp=0;temp<myListvnegSum1.size();temp++){
                                            if(dates.get(jvneg-1).equals(myListvnegSum1.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                       vnegCount.add(daysCount);

                             daysCount=0;
                             if((jvneg-1)==(7*week)){
                                for(temp=0;temp<myListvnegSum1.size();temp++){
                                    if(dates.get(jvneg-1).equals(myListvnegSum1.get(temp))){
                                        daysCount=daysCount+1;
                                    }
                                }
                             }
                                week++;

                             }
                         }

                            vnegCount.add(daysCount);
                            %>
//
                            <% jvpos=0;
                           kvpos=1;
                           fvpos =0;
                           valvpos = "";
                            tempvalvpos="";
                            splitValvpos = new String[3];
                           checkVpos = 0;
                           countVpos=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////

                           daysCount =0;
                           numOfDays =1;
                           week = 1;
                           temp=0;
                           vposCount.clear();

                            for(jvpos=1;jvpos<=dates.size();jvpos++){
                                if(jvpos<=(7*week)){
                                   for(temp=0;temp<myListvposSum1.size();temp++){
                                       if(dates.get(jvpos-1).equals(myListvposSum1.get(temp))){
                                           daysCount=daysCount+1;
                                       }
                                   }
                                }
                                else{

                                   vposCount.add(daysCount);

                               daysCount=0;
                               if((jvpos-1)==(7*week)){
                                  for(temp=0;temp<myListvposSum1.size();temp++){
                                      if(dates.get(jvpos-1).equals(myListvposSum1.get(temp))){
                                          daysCount=daysCount+1;
                                      }
                                  }
                               }
                                  week++;

                               }
                           }

                            vposCount.add(daysCount);
                       %>

//calcualting value
                            <%
                                    valposCount = posCount.size();
                                    valnegCount = negCount.size();
                                    valneutCount = neutCount.size();
                                    valvnegCount = vnegCount.size();
                                    valvposCount = vposCount.size();
                                    data.clear();
                                    data.add(valposCount);
                                    data.add(valnegCount);
                                    data.add(valneutCount);
                                    data.add(valvnegCount);
                                    data.add(valvposCount);
                                    Collections.sort(data);
                                    maxValue = data.get(4);

                                    for(int m=0;m<maxValue;m++){
                                        if(m<valposCount){
                                            posPresent = posCount.get(m);
                                        }else{
                                            posPresent = 0;
                                        }
                                        if(m<valnegCount){
                                            negPresent = negCount.get(m);
                                        }else{
                                            negPresent = 0;
                                        }
                                        if(m<valneutCount){
                                            neutPresent = neutCount.get(m);
                                        }else{
                                            neutPresent = 0;
                                        }
                                        if(m<valvnegCount){
                                            vnegPresent = vnegCount.get(m);
                                        }else{
                                            vnegPresent = 0;
                                        }
                                        if(m<valvposCount){
                                            vposPresent = vposCount.get(m);
                                        }else{
                                            vposPresent = 0;
                                        }
                                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                                        if(sum!=0){
                                        %>
                            <%=sop+0.1%>,

                            <%
                                }
                                else{%>
                            0.1,
                            <%}
                        }

                        %>

                        ]

                    },
                    <% }%>
                        <%}else {%>{
                        name: 'Sentiment',
                        type: 'line',
                        data:[0]

                    },{
                        name: 'NewsCount',
                        type: 'column',
                        yAxis: 1,
                        data:[0]

                    }

                    <% }%>

                ],
                xAxis: [
                    {title: {
                        text: 'Week',
                        style: {
                            color: '#853385'
                        }
                    },
                        categories: [
                            <%
                            if(myListSum!=null||myListnegSum!=null||myListneutSum!=null||myListvnegSum!=null||myListvposSum!=null){


                                int j=0;
                                int k=1;
                                double f =0;
                                String val = "";
                                String tempval="";
                                String[] splitVal = new String[3];
                                int checkPos=0;
                                int count=0;

                               /////////////////////////////////////weekly/////////////////////////////////////////////////
                                 int daysCount =0;
                                 int numOfDays =1;
                                 int week = 1;
                                 int temp=0;
                                 ArrayList<Integer> posCount = new ArrayList<Integer>();

                                 for(j=1;j<=dates.size();j++){
                                     if(j<=(7*week)){
                                        for(temp=0;temp<myListSum.size();temp++){
                                            if(dates.get(j-1).equals(myListSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        posCount.add(daysCount);

                                     daysCount=0;
                                     if((j-1)==(7*week)){
                                        for(temp=0;temp<myListSum.size();temp++){
                                            if(dates.get(j-1).equals(myListSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                        week++;

                                     }
                                 }

                                 posCount.add(daysCount);
                               %>
//
                            <% int jneg=0;
                                int kneg=1;
                                double fneg =0;
                                String valneg = "";
                                String tempvalneg="";
                                String[] splitValneg = new String[3];
                                boolean checkNeg = false;
                                int countNeg=0;

                                /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 ArrayList<Integer> negCount = new ArrayList<Integer>();

                                 for(jneg=1;jneg<=dates.size();jneg++){
                                     if(jneg<=(7*week)){
                                        for(temp=0;temp<myListnegSum.size();temp++){
                                            if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                        negCount.add(daysCount);

                                                         daysCount=0;
                                                         if((jneg-1)==(7*week)){
                                                            for(temp=0;temp<myListnegSum.size();temp++){
                                                                if(dates.get(jneg-1).equals(myListnegSum.get(temp))){
                                                                    daysCount=daysCount+1;
                                                                }
                                                            }
                                                         }
                                                            week++;

                                                         }
                                                     }

                                                     negCount.add(daysCount);
                                                     %>
//
                            <% int jneut=0;
                                            int kneut=1;
                                            double fneut =0;
                                            String valneut = "";
                                            String tempvalneut="";
                                            String[] splitValneut = new String[3];
                                            int checkNeut = 0;
                                            int countNeut=0;

                                            /////////////////////////////////////weekly/////////////////////////////////////////////////

                                             daysCount =0;
                                             numOfDays =1;
                                             week = 1;
                                             temp=0;
                                             ArrayList<Integer> neutCount = new ArrayList<Integer>();

                                             for(jneut=1;jneut<=dates.size();jneut++){
                                                 if(jneut<=(7*week)){
                                                    for(temp=0;temp<myListneutSum.size();temp++){
                                                        if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                            daysCount=daysCount+1;
                                                        }
                                                    }
                                                 }
                                                 else{

                                                    neutCount.add(daysCount);

                                         daysCount=0;
                                         if((jneut-1)==(7*week)){
                                            for(temp=0;temp<myListneutSum.size();temp++){
                                                if(dates.get(jneut-1).equals(myListneutSum.get(temp))){
                                                    daysCount=daysCount+1;
                                                }
                                            }
                                         }
                                            week++;

                                         }
                                     }

                                    neutCount.add(daysCount);

                                    %>
//
                            <% int jvneg=0;
                                int kvneg=1;
                                double fvneg =0;
                                String valvneg = "";
                                String tempvalvneg ="";
                                String[] splitValvneg = new String[3];
                                int checkVneg =0;
                                int countVneg=0;

                                 /////////////////////////////////////weekly/////////////////////////////////////////////////

                                 daysCount =0;
                                 numOfDays =1;
                                 week = 1;
                                 temp=0;
                                 ArrayList<Integer> vnegCount = new ArrayList<Integer>();

                                 for(jvneg=1;jvneg<=dates.size();jvneg++){
                                     if(jvneg<=(7*week)){
                                        for(temp=0;temp<myListvnegSum.size();temp++){
                                            if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                                daysCount=daysCount+1;
                                            }
                                        }
                                     }
                                     else{

                                       vnegCount.add(daysCount);

                             daysCount=0;
                             if((jvneg-1)==(7*week)){
                                for(temp=0;temp<myListvnegSum.size();temp++){
                                    if(dates.get(jvneg-1).equals(myListvnegSum.get(temp))){
                                        daysCount=daysCount+1;
                                    }
                                }
                             }
                                week++;

                             }
                         }

                            vnegCount.add(daysCount);
                            %>
//
                            <% int jvpos=0;
                           int kvpos=1;
                           double fvpos =0;
                           String valvpos = "";
                           String tempvalvpos="";
                           String[] splitValvpos = new String[3];
                           int checkVpos = 0;
                           int countVpos=0;

                           /////////////////////////////////////weekly/////////////////////////////////////////////////

                           daysCount =0;
                           numOfDays =1;
                           week = 1;
                           temp=0;
                           ArrayList<Integer> vposCount = new ArrayList<Integer>();

                            for(jvpos=1;jvpos<=dates.size();jvpos++){
                                if(jvpos<=(7*week)){
                                   for(temp=0;temp<myListvposSum.size();temp++){
                                       if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                           daysCount=daysCount+1;
                                       }
                                   }
                                }
                                else{

                                   vposCount.add(daysCount);

                               daysCount=0;
                               if((jvpos-1)==(7*week)){
                                  for(temp=0;temp<myListvposSum.size();temp++){
                                      if(dates.get(jvpos-1).equals(myListvposSum.get(temp))){
                                          daysCount=daysCount+1;
                                      }
                                  }
                               }
                                  week++;

                               }
                           }

                            vposCount.add(daysCount);
                       %>

//calcualting value
                            <%
                                    int valposCount = posCount.size();
                                    int valnegCount = negCount.size();
                                    int valneutCount = neutCount.size();
                                    int valvnegCount = vnegCount.size();
                                    int valvposCount = vposCount.size();
                                    java.util.List<Integer> data = new ArrayList<Integer>();
                                    data.add(valposCount);
                                    data.add(valnegCount);
                                    data.add(valneutCount);
                                    data.add(valvnegCount);
                                    data.add(valvposCount);
                                    Collections.sort(data);
                                    int maxValue = data.get(4);
                                    java.util.List<Integer> posTotalList = new ArrayList<Integer>();

                                    for(int m=0;m<maxValue;m++){
                                        if(m<valposCount){
                                            posPresent = posCount.get(m);
                                        }else{
                                            posPresent = 0;
                                        }
                                        if(m<valnegCount){
                                            negPresent = negCount.get(m);
                                        }else{
                                            negPresent = 0;
                                        }
                                        if(m<valneutCount){
                                            neutPresent = neutCount.get(m);
                                        }else{
                                            neutPresent = 0;
                                        }
                                        if(m<valvnegCount){
                                            vnegPresent = vnegCount.get(m);
                                        }else{
                                            vnegPresent = 0;
                                        }
                                        if(m<valvposCount){
                                            vposPresent = vposCount.get(m);
                                        }else{
                                            vposPresent = 0;
                                        }
                                        sop = (((0.5)*posPresent)+((-0.5)*negPresent)+((0)*neutPresent)+((1)*vposPresent)+((-1)*vnegPresent))/2;
                                        sum = posPresent+negPresent+neutPresent+vposPresent+vnegPresent;
                                        if(sum!=0){
                                        %>
                            '<%=m+1%>',
                            <%}
                            else{%>
                            '<%=m+1%>',
                            <%}

                            }%>

                            <%} else {%>
                            '1'
                            <%}%>
                        ]

                    }]

            }

    );<%}%>
});
</script>
<style>
    body {
        background: #efefee;
        cursor: auto;
    }
    a{
        color:#222;
    }
    a:hover, a:focus {
        color: #1B83BE;
    }
    a:visited {
        color: #1B83BE;
    }
    table tr th, table tr td {
        padding: 0.1625rem 1.625rem;
    }
    #progress {
        background: url("progress.gif") no-repeat scroll center center #FFF;
        z-index: 999;
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        display:none;
        opacity:0.5;
    }

</style>
<style>

    label {
        padding:0.4em 2em 0.4em 0;
    }
    .toggle-btn-grp {
        margin:3px 0;
    }
    .toggle-btn {
        text-align:center;
        margin:5px 2px;
        padding:0.4em 3em;
        color:#000;
        background-color:#FFF;
        border-radius:10px;
        display:inline-block;
        border:solid 1px #CCC;
        cursor:pointer;
    }

    .toggle-btn-grp.joint-toggle .toggle-btn {
        margin:5px 0;
        padding:0.4em 1em;
        border-radius:0;
        border-right-color:white;
    }
    .toggle-btn-grp.joint-toggle .toggle-btn:first-child {
        margin-left:2px;
        border-radius: 10px 0px 0px 10px;
    }
    .toggle-btn-grp.joint-toggle .toggle-btn:last-child {
        margin-right:2px;
        border-radius: 0px 10px 10px 0px;
        border-right:solid 1px #CCC;
    }


    .toggle-btn:hover {
        border:solid 1px #a0d5dc !important;
        background:#f1fdfe;
    }


    .toggle-btn.success {
        background:lightgreen;
        border:solid 1px green !important;
    }


    .visuallyhidden {
        border: 0;
        clip: rect(0 0 0 0);
        height: 1px;
        margin: -1px;
        overflow: hidden;
        padding: 0;
        position: absolute;
        width: 1px;
    }
    .visuallyhidden.focusable:active, .visuallyhidden.focusable:focus {
        clip: auto;
        height: auto;
        margin: 0;
        overflow: visible;
        position: static;
        width: auto;
    }

</style>

</head>
<body class="body" style="zoom:1" onload="load()">

<%--<div class="container" style="background-color:#007095">--%>
    <%--<div class="row" >--%>
        <%--<div class="large-12 columns">--%>
            <%--<div class="large-3 columns">--%>
                <%--<a href="http://www.coassets.com" >--%>
                    <%--<img src="CoassetsLogo.png" width="140">--%>
                <%--</a>--%>
            <%--</div>--%>
            <%--<div class="large-4 columns" style="float:inherit;">--%>
                <%--<h3 style="color:#FFFFFF">Analytics</h3>--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</div>--%>
<%--</div>--%>

<%--<div id="header-container" class="content-width" style="top:0px;">--%>
<%--<div id="logo-wrapper" style="position: static; padding-bottom: 17px; bottom: 0px;">--%>
<%--<div id="logo">--%>
<%--<a href="http://www.coassets.com" >--%>
<%--<img src="CoassetsLogo.png" width="140">--%>
<%--</a>--%>
<%--<p style="display: block;">--%>
<%--Matching Funders with Opportunities--%>
<%--</p>--%>
<%--</div>--%>

<%--</div>--%>
<%--<div style="display:inline-block;width:700px;">--%>
<%--<p style="color:#f5f5f5 ;align:center; padding:60px 0px 0px 80px; font-size: 35;"> News Analytics</p>--%>
<%--</div>--%>

<%--</div>--%>




<script src="<c:url value='/resources/js/highcharts.js' />"> </script>
<script src="<c:url value='/resources/js/exporting.js' />"> </script>
<script src="<c:url value='/resources/js/highcharts-more.js' />"> </script>




<%--<div class="home-slider-item" style="position: absolute; z-index: 1; width: 1903px; opacity: 1; background: none;">--%>
<%--<div class="backstretch" style="left: 0px; top: 0px; overflow: hidden; margin: 0px; padding: 0px; height: 624px; width: 1903px; z-index: -999998; position: absolute;"><img src="analytics 3.jpg" style="position: absolute; margin: 0px; padding: 0px; border: none; width: 1960px; height: 624px; max-width: none; z-index: -999999; left: -28.5px; top: 0px;"></div>--%>
<%--</div>--%>
<div id="progress"></div>
<div id="content-container" class="content-width">
    <div class="row">
        <div class="large-4 columns" style="width:70%; padding-top:0px;" >
            <%
                if(request.getAttribute("fromSearch")== null || request.getAttribute("fromSearch").equals("notpresent")){%>
            <div class="module" style="padding: 10px 10px 10px 10px">
                <%
                    if(noPos&&noNeg&&noNeut&&noVneg&&noVpos){
                %>
                <p>There is no News available for this period.</p>
                <%
                }
                else{

                    if(view!=null){
                        if(request.getAttribute("dateInvalidation")!=null){
                            if(view.get(0).equals("weekly")){
                %>
                <div id="container1" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
                <%}else if(view.get(0).equals("monthly")) {%>
                <div id="container2" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
                <%}
                else{%>
                <div id="container" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
                <%}
                }
                else{
                %><p>Please provide both the dates.</p><%}
            }
            else{%>
                <div id="container" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
                <p>Please provide the search criteria.</p>
                <%}}%>
            </div>

            <div class="module" style="padding: 10px 10px 10px 10px">
                <%
                    if(noPos&&noNeg&&noNeut&&noVneg&&noVpos){
                %>
                <p>There is no News available for this period.</p>
                <%
                }
                else{

                    if(view!=null){
                        if(request.getAttribute("dateInvalidation")!=null){
                %>
                <div id="container3" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
                <%
                }
                else{
                %><p>Please provide both the dates.</p><%}
            }
            else{%>
                <div id="container3" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
                <p>Please provide the search criteria.</p>
                <%}}%>
            </div>
            <%}
                if(request.getAttribute("fromSearch")!= null && request.getAttribute("fromSearch").equals("present")){
            %>
            <div class="module" style="padding: 10px 10px 10px 10px">
                <div id="container4" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>
            </div>
            <%}%>
        </div>

        <div class="large-4 columns" style="width:30%;padding-top:0px;">


            <%--<div class="module" style="padding: 10px 10px 10px 10px">--%>
            <%--<div>--%>
            <%--<form method="get" action="crawler" name="form2" onsubmit="return form2Validation()">--%>
            <%--<input type = "hidden" name = "store" value = "search">--%>
            <%--<input type = "hidden" name = "keyword">--%>
            <%--<input type = "hidden" name = "from">--%>
            <%--<input type = "hidden" name = "to">--%>
            <%--<input type = "hidden" name = "rad">--%>
            <%--<input type = "hidden" name = "dateInvalid">--%>
            <%--<p><b>Search - By keyword</b></p>--%>
            <%--Search: <br><br><input type="text" id="search"/>--%>
            <%--<div id ="errors"></div><br>--%>
            <%--<input type="submit" id="searchbtnsubmit" value="Search" size = "10"  class="button [radius round]" style ="padding-top: 0.3rem;padding-bottom: 0.45rem;" />--%>
            <%--</form>--%>
            <%--</div>--%>
            <%--</div>--%>

            <%String se = request.getParameter("extraSearch");
            %>

            <div class="module" style="padding: 10px 10px 10px 10px">
                <div>
                    <form method="get" action="crawler" name="form3" onsubmit="return form3Validation()" >
                        <input type = "hidden" name = "store">
                        <input type = "hidden" name = "keyword">
                        <input type = "hidden" name = "keyword1">
                        <input type = "hidden" name = "dateInvalid">
                        <input type="hidden" name="frame" value="framePage">
                        <p><b>Search - By keyword</b></p>
                        Search: <br><br><input type="text" id="search" name="search"/>
                        <div id="searchBox" ><i style="float:right;" onclick="extraSearch()" class="foundicon-plus"></i></div>

                        <br>
                        From: <br><br><input type="text" name="from" id="from">
                        To: <br><br><input type="text" name="to" id="to">
                        <div class="toggle-btn-grp joint-toggle">
                            <input type="radio" name="rad"  value="daily"/> Daily <br>
                            <input type="radio" name="rad"  value="weekly" checked="checked"/> Weekly<br>
                            <input type="radio" name="rad"  value="monthly"/> Monthly <br>
                        </div>
                        <input type="submit" id="searchbtnsubmitWithPeriod" value="Search" size = "10"  class="flat button" style ="padding-top: 0.3rem;padding-bottom: 0.45rem;" />
                    </form>
                </div>
            </div>



            <%--<div class="module" style="padding: 10px 10px 10px 10px">--%>
            <%--<div>--%>
            <%--<form method="get" action="crawler" name="form1" onsubmit="return checkDate()">--%>
            <%--<input type = "hidden" name = "dateInvalid" value = "">--%>
            <%--<input type = "hidden" name = "store" value = "date">--%>
            <%--<p><b>Search - All NEWS</b></p>--%>
            <%--From: <br><br><input type="date" name="from" id="from"/>--%>
            <%--To: <br><br><input type="date" name="to" id="to"/>--%>
            <%--<div class="toggle-btn-grp joint-toggle">--%>
            <%--<input type="radio" name="rad"  value="daily"/>Daily <br>--%>
            <%--<input type="radio" name="rad"  value="weekly" checked="checked"/>Weekly <br>--%>
            <%--<input type="radio" name="rad"  value="monthly"/>Monthly <br>--%>
            <%--</div>--%>
            <%--<div id ="errorForView"></div><br>--%>
            <%--<input type="submit" id="btnsubmit" value="Search" size = "10"  class="flat button" style ="padding-top: 0.3rem;padding-bottom: 0.45rem;" />--%>

            <%--</form>--%>

            <%--</div>--%>
            <%--</div>--%>
        </div>
    </div>
    <c:set var="positiveNews" scope="session" value="${requestScope.positiveNews}"/>
    <c:if test="${positiveNews != null}">
        <div class="large-4 columns" style="width:100%;" >
            <div class="module" style="padding: 10px 10px 10px 10px">
                <div id="report">
                </div>
            </div>
        </div>
    </c:if>
</div>

<div id="output"></div>




</body>
</html>
<script>
    $(document).ready(function() {
        console.log("here");
        $( "#from" ).datepicker({ dateFormat: "yy-mm-dd"

        });
        $( "#to" ).datepicker({ dateFormat: "yy-mm-dd"

        });
    });
</script>
<script>
//    $(":button").click(function() {
//        $("#overlay").show();
//    });
//    $(document).ready(function(){
//        ( "#from" ).datepicker({
//            showOn: "button",
//            buttonImage: "/resources/images/calendar.gif",
//            buttonImageOnly: true
//        });
//        $( "#to" ).datepicker();
//    });
$("#progress").click(function() {
    $(this).hide();
});
function extraSearch(){
    $.ajax({
        type: "post",
        url: "mainpageForCombined.jsp", //this is my servlet
        data: {
            extraSearch: "present"
        },
        success: function(){
            $('#searchBox').html('With: <br><br><input type="text" id="search1" name="search1"/>');
        }
    });
}
//    function checkDate(){
//        var enteredDate = document.getElementById("to").value;
//        var year = enteredDate.substring(0,4);
//        var month = enteredDate.substring(5,7);
//        var date = enteredDate.substring(8,10);
//        var myDate = new Date(year, month - 1, date);
//        var enteredDateFr = document.getElementById("from").value;
//        var yearFr = enteredDateFr.substring(0,4);
//        var monthFr = enteredDateFr.substring(5,7);
//        var dateFr = enteredDateFr.substring(8,10);
//        var myDateFr = new Date(yearFr, monthFr - 1, dateFr);
//        var today = new Date();
//        if(enteredDate=="" || enteredDateFr==""){
//            alert("Please fill both the dates");
//            document.form1.dateInvalid.value="notval";
//        }else{
//            if (myDate > today || myDateFr > today) {
//                alert("Entered date is greater than today's date ");
//                document.form1.dateInvalid.value="notval";
//            }
//            else{
//                document.form1.dateInvalid.value="val";
//            }}
//        document.form1.submit();
//    }
<%--function form2Validation(){--%>
<%--var searchword = document.getElementById("search").value;--%>
<%--String.prototype.ltrim = function() {--%>
<%--return this.replace(/^\s+/,"");--%>
<%--};--%>
<%--String.prototype.rtrim = function() {--%>
<%--return this.replace(/\s+$/,"");--%>
<%--};--%>
<%--searchword = searchword.ltrim();--%>
<%--searchword = searchword.rtrim();--%>
<%--if(searchword==""){--%>
<%--document.getElementById('errors').innerHTML="Please enter a valid search keyword.";--%>
<%--return false;--%>
<%--}--%>
<%--else{--%>
<%--document.form2.keyword.value=searchword;--%>
<%--<%--%>
<%--LocalDate today = new LocalDate();--%>
<%--LocalDate minusDate = today.minusMonths(2);--%>
<%--System.out.println(minusDate);--%>
<%--String from = minusDate.toString("yyyy-MM-dd");--%>
<%--System.out.println(from);--%>
<%--String to = today.toString("yyyy-MM-dd");--%>
<%--%>--%>
<%--document.form2.from.value="<%=from%>";--%>
<%--document.form2.to.value="<%=to%>";--%>
<%--document.form2.rad.value="weekly";--%>
<%--document.form2.dateInvalid.value="val";--%>
<%--}--%>
<%--document.form2.submit();--%>
<%--}--%>

function form3Validation(){
//        document.getElementById('progress').style.display = 'block';
    $("#progress").show();
    var searchword = document.getElementById("search").value;
    //var searchword1 = document.getElementById("search1").value;
//        alert(document.getElementById("search1").value);
    String.prototype.ltrim = function() {
        return this.replace(/^\s+/,"");
    };
    String.prototype.rtrim = function() {
        return this.replace(/\s+$/,"");
    };
    searchword = searchword.ltrim();
    searchword = searchword.rtrim();
//        searchword1 = searchword1.ltrim();
//        searchword1 = searchword1.rtrim();
    if(searchword==""){
        document.form3.store.value="withoutSearch";
        var enteredDate = document.getElementById("to").value;
        var year = enteredDate.substring(0,4);
        var month = enteredDate.substring(5,7);
        var date = enteredDate.substring(8,10);
        var myDate = new Date(year, month - 1, date);
        var enteredDateFr = document.getElementById("from").value;
        var yearFr = enteredDateFr.substring(0,4);
        var monthFr = enteredDateFr.substring(5,7);
        var dateFr = enteredDateFr.substring(8,10);
        var myDateFr = new Date(yearFr, monthFr - 1, dateFr);
        var today = new Date();
        if(enteredDate=="" || enteredDateFr==""){
            alert("Please fill both the dates");
            document.form3.dateInvalid.value="notval";
        }else{
            if (myDate > today || myDateFr > today) {
                alert("Entered date is greater than today's date ");
                document.form3.dateInvalid.value="notval";
            }
            else if(myDateFr>myDate){
                alert("From date cannnot be greater than To date");
                document.form3.dateInvalid.value="notval";
            }
            else{
                document.form3.dateInvalid.value="val";
            }}
        document.form3.submit();
    }
    else {
        document.form3.store.value="search";
        document.form3.keyword.value=searchword;
//            document.form3.keyword1.value=searchword1;
        if(document.getElementById("from").value!="" || document.getElementById("to").value!=""){
            var enteredDate1 = document.getElementById("to").value;
            var year1 = enteredDate1.substring(0,4);
            var month1 = enteredDate1.substring(5,7);
            var date1 = enteredDate1.substring(8,10);
            var myDate1 = new Date(year1, month1 - 1, date1);
            var enteredDateFr1 = document.getElementById("from").value;
            var yearFr1 = enteredDateFr1.substring(0,4);
            var monthFr1 = enteredDateFr1.substring(5,7);
            var dateFr1 = enteredDateFr1.substring(8,10);
            var myDateFr1 = new Date(yearFr1, monthFr1 - 1, dateFr1);
            var today1 = new Date();
            if(enteredDate1=="" || enteredDateFr1==""){
                alert("Please fill both the dates");
                document.form3.dateInvalid.value="notval";
            }else{
                if (myDate1 > today1 || myDateFr1 > today1) {
                    alert("Entered date is greater than today's date ");
                    document.form3.dateInvalid.value="notval";
                }
                else if(myDateFr1>myDate1){
                    alert("From date cannnot be greater than To date");
                    document.form3.dateInvalid.value="notval";
                }
                else{

                    document.form3.dateInvalid.value="val";
                }}
            document.form3.from.value = document.getElementById("from").value;
            document.form3.to.value = document.getElementById("to").value;
        }
        else {
            <%
            LocalDate today = new LocalDate();
            LocalDate minusDate = today.minusMonths(6);
            String from = minusDate.toString("yyyy-MM-dd");
            String to = today.toString("yyyy-MM-dd");
            %>
            document.form3.from.value = "<%=from%>";
            document.form3.to.value = "<%=to%>";
            document.form3.rad.value = "weekly";
            document.form3.dateInvalid.value = "val";
        }
        document.form3.submit();
    }
}

$(function(){
    $('input[name="rad"]').click(function(){
        var $radio = $(this);

        // if this was previously checked
        if ($radio.data('waschecked') == true)
        {
            $radio.prop('checked', false);
            $radio.data('waschecked', false);
        }
        else
            $radio.data('waschecked', true);

        // remove was checked from other radios
        $radio.siblings('input[name="rad"]').data('waschecked', false);
    });
});
//    $(".toggle-btn:not('.noscript') input[type=radio]").addClass("visuallyhidden");
//    $(".toggle-btn:not('.noscript') input[type=radio]").change(function() {
//        if( $(this).attr("name") ) {
//            $(this).parent().addClass("success").siblings().removeClass("success")
//        } else {
//            $(this).parent().toggleClass("success");
//        }
//    });

function load() {
    document.form3.searchWithPeriod.value = " <%=request.getParameter("keyword")%>";
}
</script>