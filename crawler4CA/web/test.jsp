<%@ page import="com.amazonaws.services.dynamodbv2.model.AttributeValue" %>
<%@ page import="com.amazonaws.services.dynamodbv2.model.AttributeValueUpdate" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.amazonaws.services.dynamodbv2.model.UpdateItemRequest" %>
<%@ page import="com.amazonaws.services.dynamodbv2.model.UpdateItemResult" %>
<%@ page import="stanTagger.AmazonDynamoDBSample" %>
<%@ page import="com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient" %>
<%--
  Created by IntelliJ IDEA.
  User: Vignesh
  Date: 3/7/2014
  Time: 8:21 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <script src="<c:url value='/resources/js/jquery-1.9.1.min.js' />"> </script>
     <% String text = request.getParameter("input");
        String sentVal = request.getParameter("output");
        if(text!=null) {
            try {
                String message = AmazonDynamoDBSample.updateOpinion(text,sentVal);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>

    <script src="<c:url value='http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js' />"> </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $('.positive').on('change',function ()
            { alert(this);
                $.ajax({
                    type: "post",
                    url: "test.jsp", //this is my servlet
                    data: {
                        input: $('#id').val(),
                        output: $(this).val()
                    },
                    success: function(){
                        $('#output').html("Updated");
                    }
                });
            });

        });
    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
</head>
<body>
<div id ="report">
URL:<input id="id" type="text" name="" value="" size="80"/><br>
Sentiment:  <select id="op0" class="positive">
    <option value="0.5">Positive</option>
    <option value="1">Very Positive</option>
    <option value="0">Neutral</option>
    <option value="-0.5">Negative</option>
    <option value="1">Very Negative</option>
    </select>
            <br>
Sentiment:  <select id="op1" class="positive">
    <option value="0.5">Positive</option>
    <option value="1">Very Positive</option>
    <option value="0">Neutral</option>
    <option value="-0.5">Negative</option>
    <option value="1">Very Negative</option>
</select>
</div>
<div id="output"></div>

</body>
