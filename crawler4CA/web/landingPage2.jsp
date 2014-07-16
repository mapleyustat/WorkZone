<%--
  Created by IntelliJ IDEA.
  User: Vignesh
  Date: 17/6/2014
  Time: 9:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Highcharts Example</title>

    <script src="<c:url value='http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js' />"> </script>

    <script type="text/javascript">
        $(function () {
            $('#container').highcharts({
                chart: {
                    type: 'scatter',
                    zoomType: 'xy',
                    options3d: {
                        enabled: true,
                        alpha: 10,
                        beta: 25,
                        depth: 70
                    }
                },
                title: {
                    text: 'News Sentiment Analyzer'
                },
                subtitle: {
                    text: 'Sentiment Analyzer'
                },
                xAxis: {
                    title: {
                        enabled: true,
                        text: 'Date'
                    },
                    type: 'datetime',
                    startOnTick: true,
                    endOnTick: true,
                    showLastLabel: true,
                    dateTimeLabelFormats: {
                        day: '%e,%b %Y'
                    }
                },
                yAxis: {
                    title: {
                        text: 'Sentiment'
                    }
                },
                legend: {
                    layout: 'vertical',
                    align: 'left',
                    verticalAlign: 'top',
                    x: 100,
                    y: 70,
                    floating: true,
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
                    borderWidth: 1
                },
                plotOptions: {
                    scatter: {
                        marker: {
                            radius: 5,
                            states: {
                                hover: {
                                    enabled: true,
                                    lineColor: 'rgb(100,100,100)'
                                }
                            }
                        },
                        states: {
                            hover: {
                                marker: {
                                    enabled: false
                                }
                            }
                        },
                        tooltip: {
                            headerFormat: '<b>Sentiment : </b>{series.name} <br>',
                            pointFormat: '<b>{point.x}</b>'
                        }
                    }
                },
                series: [{
                    name: 'Positive',
                    pointStart: Date.UTC(2010, 0, 1),
                    pointInterval: 24 * 3600 * 1000, // one day
                    color: 'rgba(223, 83, 83, .5)',
                    data: [
                        [Date.UTC(2010, 5, 24,1), 1],
                        [Date.UTC(2010, 5, 24), 1],
                        [Date.UTC(2010, 3, 1), 1]
                    ]

                },
                 {
                        name: 'Negative',
                        color: '#66FF66',
                        data: [
                            [Date.UTC(2010, 1, 1), 0],
                            [Date.UTC(2010, 2, 1), 0],
                            [Date.UTC(2010, 3, 1), 0]
                        ]

                 }]
            });
        });
    </script>
</head>
<body>

<script src="<c:url value='/resources/js/highcharts.js' />"> </script>
<script src="<c:url value='/resources/js/exporting.js' />"> </script>

<div id="container" style="min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto"></div>

</body>
</html>
