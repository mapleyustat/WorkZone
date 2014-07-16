package stanTagger;

import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.amazonaws.services.simpledb.model.Attribute;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.LocalDate;
import org.w3c.dom.Attr;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Vignesh on 9/6/2014.
 */
public class CrawlingNewsFromDB {

    public static void main(String[] args) throws Exception {
        String table = "CA_NEWS_ARCH";
        String sentiment = "neutral";
        String keyword = "property";
        CrawlingNewsFromDB crawlingNewsFromDB = new CrawlingNewsFromDB();
//        crawlingNewsFromDB.getNewsOnSentiment(table,sentiment);
//        crawlingNewsFromDB.getTitleOnSentiment(table,sentiment);
//           crawlingNewsFromDB.getNewsWithKeyword(table,keyword);
        //  crawlingNewsFromDB.getAllNewsForSearch(table,keyword);
//        List<List<String>> totalList = new ArrayList<List<String>>();
//        totalList = crawlingNewsFromDB.fetchResultsBasedOnDate(table, "2013-04-16", "2014-06-19");
//        crawlingNewsFromDB.fetchResultsBasedOnDate(table, "2014-05-16", "2014-06-19");
//        fetchAll(table);
        List<List<String>> totalList = new ArrayList<List<String>>();
        totalList =  crawlingNewsFromDB.getAllNewsForDate(table, "2013-03-01", "2013-04-30");
    }

    public static void getNewsOnSentiment(String table, String sentiment) throws Exception {
        String text = "";
        AttributeValue news_text;
        List<String> newsList = new ArrayList<String>();
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        ScanResult result = fromDb.getNewsItem(table, sentiment);
        for (Map<String, AttributeValue> item : result.getItems()) {
            news_text = item.get("news_text");
            text = news_text.getS();
            System.out.println(text + "\n");
            newsList.add(text);
        }
        System.out.println(newsList);
    }

    public static void getTitleOnSentiment(String table, String sentiment) throws Exception {
        String text = "";
        AttributeValue title_text;
        List<String> titleList = new ArrayList<String>();
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        ScanResult result = fromDb.getNewsItem(table, sentiment);
        for (Map<String, AttributeValue> item : result.getItems()) {
            title_text = item.get("title_text");
            text = title_text.getS();
            System.out.println(text + "\n");
            titleList.add(text);
        }
        System.out.println(titleList);
    }

    public static void getNewsWithKeyword(String table, String keyword) throws Exception {
        String text = "";
        String sentiment = "";
        AttributeValue news_sentiment;
        AttributeValue news_text;
        List<String> posList = new ArrayList<String>();
        List<String> negList = new ArrayList<String>();
        List<String> neutList = new ArrayList<String>();
        List<String> vnegList = new ArrayList<String>();
        List<String> vposList = new ArrayList<String>();
        List<List<String>> totalList = new ArrayList<List<String>>();

        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        ScanResult result = fromDb.geAllItemsBySearch(table, keyword);
        for (Map<String, AttributeValue> item : result.getItems()) {
            news_sentiment = item.get("news_sentiment");
            sentiment = news_sentiment.getS();
            news_text = item.get("news_text");
            text = news_text.getS();
            if (sentiment.equals("positive")) {
                posList.add(text);
            } else if (sentiment.equals("negative")) {
                negList.add(text);
            } else if (sentiment.equals("neutral")) {
                neutList.add(text);
            } else if (sentiment.equals("very negative")) {
                vnegList.add(text);
            } else if (sentiment.equals("very positive")) {
                vposList.add(text);
            }
        }
        totalList.add(posList);
        totalList.add(negList);
        totalList.add(neutList);
        totalList.add(vposList);
        totalList.add(vnegList);
        System.out.println(totalList);
    }

    public static List getAllNewsForSearch(String tableName, String keyword) throws Exception {
        AttributeValue news_text;
        String text = "";
        String sentiment = "";
        String caseText = "";
        AttributeValue news_sentiment;
        List<String> posList = new ArrayList<String>();
        List<String> negList = new ArrayList<String>();
        List<String> neutList = new ArrayList<String>();
        List<String> vnegList = new ArrayList<String>();
        List<String> vposList = new ArrayList<String>();
        List<List<String>> totalList = new ArrayList<List<String>>();
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        ScanResult result = fromDb.getAllItems(tableName);
        for (Map<String, AttributeValue> item : result.getItems()) {
            news_text = item.get("news_text");
            text = news_text.getS();
            caseText = text.toLowerCase();
            if (caseText.contains(keyword.toLowerCase())) {
                news_sentiment = item.get("news_sentiment");
                sentiment = news_sentiment.getS();
                if (sentiment.equals("positive")) {
                    posList.add(text);
                } else if (sentiment.equals("negative")) {
                    negList.add(text);
                } else if (sentiment.equals("neutral")) {
                    neutList.add(text);
                } else if (sentiment.equals("very negative")) {
                    vnegList.add(text);
                } else if (sentiment.equals("very positive")) {
                    vposList.add(text);
                }
            }
        }
        totalList.add(posList);
        totalList.add(negList);
        totalList.add(neutList);
        totalList.add(vposList);
        totalList.add(vnegList);
        System.out.println(totalList);

        return totalList;
    }

    public static List getAllNewsForDate(String tableName, String from, String to,String keyword) throws Exception {
        AttributeValue news_text;
        String text = "";
        String sentiment = "";
        String caseText = "";
        AttributeValue news_link;
        AttributeValue date;
        String dateVal = "";
        String newsLink = "";
        AttributeValue news_sentiment;
        AttributeValue news_source;
        String newsSource="";

        List<String> posNewsList = new ArrayList<String>();
        List<String> negNewsList = new ArrayList<String>();
        List<String> neutNewsList = new ArrayList<String>();
        List<String> vnegNewsList = new ArrayList<String>();
        List<String> vposNewsList = new ArrayList<String>();

        List<String> posTitleList = new ArrayList<String>();
        List<String> negTitleList = new ArrayList<String>();
        List<String> neutTitleList = new ArrayList<String>();
        List<String> vnegTitleList = new ArrayList<String>();
        List<String> vposTitleList = new ArrayList<String>();

        List<String> posDateList = new ArrayList<String>();
        List<String> negDateList = new ArrayList<String>();
        List<String> neutDateList = new ArrayList<String>();
        List<String> vnegDateList = new ArrayList<String>();
        List<String> vposDateList = new ArrayList<String>();

        List<String> posSourceList = new ArrayList<String>();
        List<String> negSourceList = new ArrayList<String>();
        List<String> neutSourceList = new ArrayList<String>();
        List<String> vnegSourceList = new ArrayList<String>();
        List<String> vposSourceList = new ArrayList<String>();

        List<String> dateList = new ArrayList<String>();

        LocalDate fromDate = new LocalDate();
        LocalDate toDate = new LocalDate();
        String dbDateString = "";
        //date formatting

//        LocalDate januaryFirst = LocalDate.parse("2014-01-01");
//        LocalDate januarySecond = date.plusDays(1);

        SimpleDateFormat formatToCompare = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat myFormat = new SimpleDateFormat("yyyy-MM-dd");


        fromDate = LocalDate.parse(from);
        toDate = LocalDate.parse(to);
        int days = Days.daysBetween(fromDate, toDate).getDays();
        days = days + 1;
        List<List<String>> totalList = new ArrayList<List<String>>();
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        ScanResult result = fromDb.getAllItems(tableName);
        for (int i = 1; i <= days; i++) {

            for (Map<String, AttributeValue> item : result.getItems()) {
//            //text
//            news_text = item.get("news_text");
//            text = news_text.getS();
//            //title
//            title_text = item.get("title_text");
//            title = news_text.getS();
                //date

                news_text = item.get("news_text");
                text = news_text.getS();
                caseText = text.toLowerCase();
                if (caseText.contains(keyword.toLowerCase())) {

                    date = item.get("news_date");
                    dateVal = date.getS();

                    String formattedDateVal = myFormat.format(formatToCompare.parse(dateVal));

                    LocalDate dbDate = LocalDate.parse(formattedDateVal);

                    if (dbDate.equals(fromDate)) {
                        news_sentiment = item.get("news_sentiment");
                        sentiment = news_sentiment.getS();

                        news_text = item.get("news_text");
                        text = news_text.getS();

                        news_link = item.get("news_link");
                        newsLink = news_link.getS();

                        dbDateString = dbDate.toString();

                        news_source = item.get("news_source");
                        newsSource = news_source.getS();
/////////////////////////////////////////////////////////////////////////////////////////////////
                        if (sentiment.equals("positive")) {

                            posNewsList.add(text);
                            posTitleList.add(newsLink);
                            posDateList.add(dbDateString);
                            posSourceList.add(newsSource);
                        } else if (sentiment.equals("negative")) {
                            negNewsList.add(text);
                            negTitleList.add(newsLink);
                            negDateList.add(dbDateString);
                            negSourceList.add(newsSource);
                        } else if (sentiment.equals("neutral")) {
                            neutNewsList.add(text);
                            neutTitleList.add(newsLink);
                            neutDateList.add(dbDateString);
                            neutSourceList.add(newsSource);
                        } else if (sentiment.equals("very negative")) {
                            vnegNewsList.add(text);
                            vnegTitleList.add(newsLink);
                            vnegDateList.add(dbDateString);
                            vnegSourceList.add(newsSource);
                        } else if (sentiment.equals("very positive")) {
                            vposNewsList.add(text);
                            vposTitleList.add(newsLink);
                            vposDateList.add(dbDateString);
                            vposSourceList.add(newsSource);
                        }
                    }


                }
            }
            dateList.add(fromDate.toString());
            fromDate = fromDate.plusDays(1);
        }
        totalList.add(posNewsList);
        totalList.add(negNewsList);
        totalList.add(neutNewsList);
        totalList.add(vnegNewsList);
        totalList.add(vposNewsList);

        totalList.add(posTitleList);
        totalList.add(negTitleList);
        totalList.add(neutTitleList);
        totalList.add(vnegTitleList);
        totalList.add(vposTitleList);

        totalList.add(posDateList);
        totalList.add(negDateList);
        totalList.add(neutDateList);
        totalList.add(vnegDateList);
        totalList.add(vposDateList);
        totalList.add(dateList);

        totalList.add(posSourceList);
        totalList.add(negSourceList);
        totalList.add(neutSourceList);
        totalList.add(vnegSourceList);
        totalList.add(vposSourceList);

        return totalList;
    }

    public static List getAllNewsForDate(String tableName, String from, String to,String keyword ,String keyword2) throws Exception {
        AttributeValue news_text;
        String text = "";
        String sentiment = "";
        String caseText = "";
        AttributeValue news_link;
        AttributeValue date;
        String dateVal = "";
        String newsLink = "";
        AttributeValue news_sentiment;
        AttributeValue news_source;
        String newsSource="";

        List<String> posNewsList = new ArrayList<String>();
        List<String> negNewsList = new ArrayList<String>();
        List<String> neutNewsList = new ArrayList<String>();
        List<String> vnegNewsList = new ArrayList<String>();
        List<String> vposNewsList = new ArrayList<String>();

        List<String> posTitleList = new ArrayList<String>();
        List<String> negTitleList = new ArrayList<String>();
        List<String> neutTitleList = new ArrayList<String>();
        List<String> vnegTitleList = new ArrayList<String>();
        List<String> vposTitleList = new ArrayList<String>();

        List<String> posDateList = new ArrayList<String>();
        List<String> negDateList = new ArrayList<String>();
        List<String> neutDateList = new ArrayList<String>();
        List<String> vnegDateList = new ArrayList<String>();
        List<String> vposDateList = new ArrayList<String>();

        List<String> posSourceList = new ArrayList<String>();
        List<String> negSourceList = new ArrayList<String>();
        List<String> neutSourceList = new ArrayList<String>();
        List<String> vnegSourceList = new ArrayList<String>();
        List<String> vposSourceList = new ArrayList<String>();

        List<String> dateList = new ArrayList<String>();

        LocalDate fromDate = new LocalDate();
        LocalDate toDate = new LocalDate();
        String dbDateString = "";
        //date formatting

//        LocalDate januaryFirst = LocalDate.parse("2014-01-01");
//        LocalDate januarySecond = date.plusDays(1);

        SimpleDateFormat formatToCompare = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat myFormat = new SimpleDateFormat("yyyy-MM-dd");


        fromDate = LocalDate.parse(from);
        toDate = LocalDate.parse(to);
        int days = Days.daysBetween(fromDate, toDate).getDays();
        days = days + 1;
        List<List<String>> totalList = new ArrayList<List<String>>();
        List<List<String>> totalList2 = new ArrayList<List<String>>();
        List<List<List<String>>> wholeList = new ArrayList<List<List<String>>>();
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        ScanResult result = fromDb.getAllItems(tableName);
        for (int i = 1; i <= days; i++) {

            for (Map<String, AttributeValue> item : result.getItems()) {
//            //text
//            news_text = item.get("news_text");
//            text = news_text.getS();
//            //title
//            title_text = item.get("title_text");
//            title = news_text.getS();
                //date

                news_text = item.get("news_text");
                text = news_text.getS();
                caseText = text.toLowerCase();
                if (caseText.contains(keyword.toLowerCase())) {

                    date = item.get("news_date");
                    dateVal = date.getS();

                    String formattedDateVal = myFormat.format(formatToCompare.parse(dateVal));

                    LocalDate dbDate = LocalDate.parse(formattedDateVal);

                    if (dbDate.equals(fromDate)) {
                        news_sentiment = item.get("news_sentiment");
                        sentiment = news_sentiment.getS();

                        news_text = item.get("news_text");
                        text = news_text.getS();

                        news_link = item.get("news_link");
                        newsLink = news_link.getS();

                        dbDateString = dbDate.toString();

                        news_source = item.get("news_source");
                        newsSource = news_source.getS();
/////////////////////////////////////////////////////////////////////////////////////////////////
                        if (sentiment.equals("positive")) {

                            posNewsList.add(text);
                            posTitleList.add(newsLink);
                            posDateList.add(dbDateString);
                            posSourceList.add(newsSource);
                        } else if (sentiment.equals("negative")) {
                            negNewsList.add(text);
                            negTitleList.add(newsLink);
                            negDateList.add(dbDateString);
                            negSourceList.add(newsSource);
                        } else if (sentiment.equals("neutral")) {
                            neutNewsList.add(text);
                            neutTitleList.add(newsLink);
                            neutDateList.add(dbDateString);
                            neutSourceList.add(newsSource);
                        } else if (sentiment.equals("very negative")) {
                            vnegNewsList.add(text);
                            vnegTitleList.add(newsLink);
                            vnegDateList.add(dbDateString);
                            vnegSourceList.add(newsSource);
                        } else if (sentiment.equals("very positive")) {
                            vposNewsList.add(text);
                            vposTitleList.add(newsLink);
                            vposDateList.add(dbDateString);
                            vposSourceList.add(newsSource);
                        }
                    }


                }
            }
            dateList.add(fromDate.toString());
            fromDate = fromDate.plusDays(1);
        }
        totalList.add(posNewsList);
        totalList.add(negNewsList);
        totalList.add(neutNewsList);
        totalList.add(vnegNewsList);
        totalList.add(vposNewsList);

        totalList.add(posTitleList);
        totalList.add(negTitleList);
        totalList.add(neutTitleList);
        totalList.add(vnegTitleList);
        totalList.add(vposTitleList);

        totalList.add(posDateList);
        totalList.add(negDateList);
        totalList.add(neutDateList);
        totalList.add(vnegDateList);
        totalList.add(vposDateList);
        totalList.add(dateList);

        totalList.add(posSourceList);
        totalList.add(negSourceList);
        totalList.add(neutSourceList);
        totalList.add(vnegSourceList);
        totalList.add(vposSourceList);

        wholeList.add(0,totalList);

        /*
        * code for keyword 2
        * */
//        posNewsList.clear();
//        negNewsList.clear();
//        neutNewsList.clear();
//        vnegNewsList.clear();
//        vposNewsList.clear();
//
//        posTitleList.clear();
//        negTitleList.clear();
//        neutTitleList.clear();
//        vnegTitleList.clear();
//        vposTitleList.clear();
//
//        posDateList.clear();
//        negDateList.clear();
//        neutDateList.clear();
//        vnegDateList.clear();
//        vposDateList.clear();
//        dateList.clear();
//
//        posSourceList.clear();
//        negSourceList.clear();
//        neutSourceList.clear();
//        vnegSourceList.clear();
//        vposSourceList.clear();

        List<String> posNewsList2 = new ArrayList<String>();
        List<String> negNewsList2 = new ArrayList<String>();
        List<String> neutNewsList2 = new ArrayList<String>();
        List<String> vnegNewsList2 = new ArrayList<String>();
        List<String> vposNewsList2 = new ArrayList<String>();

        List<String> posTitleList2 = new ArrayList<String>();
        List<String> negTitleList2 = new ArrayList<String>();
        List<String> neutTitleList2 = new ArrayList<String>();
        List<String> vnegTitleList2 = new ArrayList<String>();
        List<String> vposTitleList2 = new ArrayList<String>();

        List<String> posDateList2 = new ArrayList<String>();
        List<String> negDateList2 = new ArrayList<String>();
        List<String> neutDateList2 = new ArrayList<String>();
        List<String> vnegDateList2 = new ArrayList<String>();
        List<String> vposDateList2 = new ArrayList<String>();

        List<String> posSourceList2 = new ArrayList<String>();
        List<String> negSourceList2 = new ArrayList<String>();
        List<String> neutSourceList2 = new ArrayList<String>();
        List<String> vnegSourceList2 = new ArrayList<String>();
        List<String> vposSourceList2 = new ArrayList<String>();

        List<String> dateList2 = new ArrayList<String>();

        fromDate = LocalDate.parse(from);
        toDate = LocalDate.parse(to);
        days = Days.daysBetween(fromDate, toDate).getDays();
        days = days + 1;

        for (int i = 1; i <= days; i++) {

            for (Map<String, AttributeValue> item : result.getItems()) {
//            //text
//            news_text = item.get("news_text");
//            text = news_text.getS();
//            //title
//            title_text = item.get("title_text");
//            title = news_text.getS();
                //date

                news_text = item.get("news_text");
                text = news_text.getS();
                caseText = text.toLowerCase();
                if (caseText.contains(keyword2.toLowerCase())) {

                    date = item.get("news_date");
                    dateVal = date.getS();

                    String formattedDateVal = myFormat.format(formatToCompare.parse(dateVal));

                    LocalDate dbDate = LocalDate.parse(formattedDateVal);

                    if (dbDate.equals(fromDate)) {
                        news_sentiment = item.get("news_sentiment");
                        sentiment = news_sentiment.getS();

                        news_text = item.get("news_text");
                        text = news_text.getS();

                        news_link = item.get("news_link");
                        newsLink = news_link.getS();

                        dbDateString = dbDate.toString();

                        news_source = item.get("news_source");
                        newsSource = news_source.getS();
/////////////////////////////////////////////////////////////////////////////////////////////////
                        if (sentiment.equals("positive")) {

                            posNewsList2.add(text);
                            posTitleList2.add(newsLink);
                            posDateList2.add(dbDateString);
                            posSourceList2.add(newsSource);
                        } else if (sentiment.equals("negative")) {
                            negNewsList2.add(text);
                            negTitleList2.add(newsLink);
                            negDateList2.add(dbDateString);
                            negSourceList2.add(newsSource);
                        } else if (sentiment.equals("neutral")) {
                            neutNewsList2.add(text);
                            neutTitleList2.add(newsLink);
                            neutDateList2.add(dbDateString);
                            neutSourceList2.add(newsSource);
                        } else if (sentiment.equals("very negative")) {
                            vnegNewsList2.add(text);
                            vnegTitleList2.add(newsLink);
                            vnegDateList2.add(dbDateString);
                            vnegSourceList2.add(newsSource);
                        } else if (sentiment.equals("very positive")) {
                            vposNewsList2.add(text);
                            vposTitleList2.add(newsLink);
                            vposDateList2.add(dbDateString);
                            vposSourceList2.add(newsSource);
                        }
                    }


                }
            }
            dateList2.add(fromDate.toString());
            fromDate = fromDate.plusDays(1);
        }
        totalList2.add(posNewsList2);
        totalList2.add(negNewsList2);
        totalList2.add(neutNewsList2);
        totalList2.add(vnegNewsList2);
        totalList2.add(vposNewsList2);

        totalList2.add(posTitleList2);
        totalList2.add(negTitleList2);
        totalList2.add(neutTitleList2);
        totalList2.add(vnegTitleList2);
        totalList2.add(vposTitleList2);

        totalList2.add(posDateList2);
        totalList2.add(negDateList2);
        totalList2.add(neutDateList2);
        totalList2.add(vnegDateList2);
        totalList2.add(vposDateList2);
        totalList2.add(dateList2);

        totalList2.add(posSourceList2);
        totalList2.add(negSourceList2);
        totalList2.add(neutSourceList2);
        totalList2.add(vnegSourceList2);
        totalList2.add(vposSourceList2);

        wholeList.add(1,totalList2);

        return wholeList;
    }

    public static List getAllNewsForDate(String tableName, String from, String to) throws Exception {
        AttributeValue news_text;
        String text = "";
        String sentiment = "";
        String caseText = "";
        AttributeValue news_link;
        AttributeValue date;
        String dateVal = "";
        String newsLink = "";
        AttributeValue news_sentiment;
        AttributeValue news_source;
        String newsSource="";
        AttributeValue news_opinion;
        String newsOpinion = "";

        List<String> posNewsList = new ArrayList<String>();
        List<String> negNewsList = new ArrayList<String>();
        List<String> neutNewsList = new ArrayList<String>();
        List<String> vnegNewsList = new ArrayList<String>();
        List<String> vposNewsList = new ArrayList<String>();

        List<String> posTitleList = new ArrayList<String>();
        List<String> negTitleList = new ArrayList<String>();
        List<String> neutTitleList = new ArrayList<String>();
        List<String> vnegTitleList = new ArrayList<String>();
        List<String> vposTitleList = new ArrayList<String>();

        List<String> posDateList = new ArrayList<String>();
        List<String> negDateList = new ArrayList<String>();
        List<String> neutDateList = new ArrayList<String>();
        List<String> vnegDateList = new ArrayList<String>();
        List<String> vposDateList = new ArrayList<String>();

        List<String> posSourceList = new ArrayList<String>();
        List<String> negSourceList = new ArrayList<String>();
        List<String> neutSourceList = new ArrayList<String>();
        List<String> vnegSourceList = new ArrayList<String>();
        List<String> vposSourceList = new ArrayList<String>();

        List<String> posOpinionList = new ArrayList<String>();
        List<String> negOpinionList = new ArrayList<String>();
        List<String> neutOpinionList = new ArrayList<String>();
        List<String> vnegOpinionList = new ArrayList<String>();
        List<String> vposOpinionList = new ArrayList<String>();

        List<String> dateList = new ArrayList<String>();

        LocalDate fromDate = new LocalDate();
        LocalDate toDate = new LocalDate();
        String dbDateString = "";
        //date formatting

//        LocalDate januaryFirst = LocalDate.parse("2014-01-01");
//        LocalDate januarySecond = date.plusDays(1);

        SimpleDateFormat formatToCompare = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat myFormat = new SimpleDateFormat("yyyy-MM-dd");


        fromDate = LocalDate.parse(from);
        toDate = LocalDate.parse(to);
        int days = Days.daysBetween(fromDate, toDate).getDays();
        days = days + 1;
        List<List<String>> totalList = new ArrayList<List<String>>();
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        ScanResult result = fromDb.getAllItems(tableName);
        for (int i = 1; i <= days; i++) {

            for (Map<String, AttributeValue> item : result.getItems()) {
//            //text
//            news_text = item.get("news_text");
//            text = news_text.getS();
//            //title
//            title_text = item.get("title_text");
//            title = news_text.getS();
                //date
                date = item.get("news_date");
                dateVal = date.getS();

                String formattedDateVal = myFormat.format(formatToCompare.parse(dateVal));

                LocalDate dbDate = LocalDate.parse(formattedDateVal);

                if (dbDate.equals(fromDate)) {
                    news_sentiment = item.get("news_sentiment");
                    sentiment = news_sentiment.getS();

                    news_text = item.get("news_text");
                    text = news_text.getS();

                    news_link = item.get("news_link");
                    newsLink = news_link.getS();

                    dbDateString = dbDate.toString();

                    news_source = item.get("news_source");
                    newsSource = news_source.getS();

                    news_opinion = item.get("opinion");
                    newsOpinion = news_opinion.getS();
/////////////////////////////////////////////////////////////////////////////////////////////////
                    if (sentiment.equals("positive")) {
                        posNewsList.add(text);
                        posTitleList.add(newsLink);
                        posDateList.add(dbDateString);
                        posSourceList.add(newsSource);
                        posOpinionList.add(newsOpinion);
                    } else if (sentiment.equals("negative")) {
                        negNewsList.add(text);
                        negTitleList.add(newsLink);
                        negDateList.add(dbDateString);
                        negSourceList.add(newsSource);
                        negOpinionList.add(newsOpinion);
                    } else if (sentiment.equals("neutral")) {
                        neutNewsList.add(text);
                        neutTitleList.add(newsLink);
                        neutDateList.add(dbDateString);
                        neutSourceList.add(newsSource);
                        neutOpinionList.add(newsOpinion);
                    } else if (sentiment.equals("very negative")) {
                        vnegNewsList.add(text);
                        vnegTitleList.add(newsLink);
                        vnegDateList.add(dbDateString);
                        vnegSourceList.add(newsSource);
                        vnegOpinionList.add(newsOpinion);
                    } else if (sentiment.equals("very positive")) {
                        vposNewsList.add(text);
                        vposTitleList.add(newsLink);
                        vposDateList.add(dbDateString);
                        vposSourceList.add(newsSource);
                        vposOpinionList.add(newsOpinion);
                    }
                }


            }
            dateList.add(fromDate.toString());
            fromDate = fromDate.plusDays(1);
        }
        totalList.add(posNewsList);
        totalList.add(negNewsList);
        totalList.add(neutNewsList);
        totalList.add(vnegNewsList);
        totalList.add(vposNewsList);

        totalList.add(posTitleList);
        totalList.add(negTitleList);
        totalList.add(neutTitleList);
        totalList.add(vnegTitleList);
        totalList.add(vposTitleList);

        totalList.add(posDateList);
        totalList.add(negDateList);
        totalList.add(neutDateList);
        totalList.add(vnegDateList);
        totalList.add(vposDateList);

        totalList.add(dateList);

        totalList.add(posSourceList);
        totalList.add(negSourceList);
        totalList.add(neutSourceList);
        totalList.add(vnegSourceList);
        totalList.add(vposSourceList);

        totalList.add(posOpinionList);
        totalList.add(negOpinionList);
        totalList.add(neutOpinionList);
        totalList.add(vnegOpinionList);
        totalList.add(vposOpinionList);

        return totalList;
    }

    public static void fetchAll(String tableName) throws Exception {
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        DateTime now = DateTime.now();
        ScanResult result = fromDb.getAllItems(tableName);
        DateTime after = DateTime.now();
        long diff = after.getMillis()-now.getMillis();
        System.out.println(diff);
    }

    public static void fetchResultsBasedOnDate(String tableName, String from, String to) throws Exception {

        LocalDate fromDate = new LocalDate();
        LocalDate toDate = new LocalDate();
        SimpleDateFormat formatToCompare = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat myFormat = new SimpleDateFormat("dd-MM-yyyy");
        String formattedFromDate = myFormat.format(formatToCompare.parse(from));
        String formattedToDate = myFormat.format(formatToCompare.parse(to));
        fromDate = LocalDate.parse(from);
        toDate = LocalDate.parse(to);
        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
        while(!fromDate.isEqual(toDate)){
            ScanResult result = fromDb.geAllItemsByDate(tableName,formattedFromDate);
            System.out.println(result);
            fromDate = fromDate.plusDays(1);
            formattedFromDate = fromDate.toString();
            formattedFromDate = myFormat.format(formatToCompare.parse(formattedFromDate));
        }



        //       LocalDate dbDate = LocalDate.parse(formattedDateVal);


//
//        AmazonDynamoDBSample fromDb = new AmazonDynamoDBSample();
//        ScanResult result = fromDb.geAllItemsByDate(tableName,date);
//
//            AttributeValue news_text;
//            String text ="";
//            String sentiment = "";
//            String caseText = "";
//            AttributeValue news_link;
//            AttributeValue date;
//            String dateVal = "";
//            String newsLink = "";
//            AttributeValue news_sentiment;
//
//            List<String> posNewsList = new ArrayList<String>();
//            List<String> negNewsList = new ArrayList<String>();
//            List<String> neutNewsList = new ArrayList<String>();
//            List<String> vnegNewsList = new ArrayList<String>();
//            List<String> vposNewsList = new ArrayList<String>();
//
//            List<String> posTitleList = new ArrayList<String>();
//            List<String> negTitleList = new ArrayList<String>();
//            List<String> neutTitleList = new ArrayList<String>();
//            List<String> vnegTitleList = new ArrayList<String>();
//            List<String> vposTitleList = new ArrayList<String>();
//
//            List<String> posDateList = new ArrayList<String>();
//            List<String> negDateList = new ArrayList<String>();
//            List<String> neutDateList = new ArrayList<String>();
//            List<String> vnegDateList = new ArrayList<String>();
//            List<String> vposDateList = new ArrayList<String>();
//
//            LocalDate fromDate = new LocalDate();
//            LocalDate toDate = new LocalDate();
//            String dbDateString ="";
//            //date formatting
//
////        LocalDate januaryFirst = LocalDate.parse("2014-01-01");
////        LocalDate januarySecond = date.plusDays(1);
//
//            SimpleDateFormat formatToCompare = new SimpleDateFormat("dd-MM-yyyy");
//            SimpleDateFormat myFormat = new SimpleDateFormat("yyyy-MM-dd");
//
//
//            System.out.println(from);
//            fromDate = LocalDate.parse(from);
//            System.out.println(from);
//            toDate = LocalDate.parse(to);
//            int days = Days.daysBetween(fromDate, toDate).getDays();
//            days=days+1;
//            List<List<String>> totalList = new ArrayList<List<String>>();
//
//            for(int i=1;i<=days;i++) {
//
//                for (Map<String, AttributeValue> item : result.getItems()) {
////            //text
////            news_text = item.get("news_text");
////            text = news_text.getS();
////            //title
////            title_text = item.get("title_text");
////            title = news_text.getS();
//                    //date
//                    date = item.get("news_date");
//                    dateVal = date.getS();
//
//                    String formattedDateVal = myFormat.format(formatToCompare.parse(dateVal));
//
//                    LocalDate dbDate = LocalDate.parse(formattedDateVal);
//
//                    if (dbDate.equals(fromDate)) {
//                        news_sentiment = item.get("news_sentiment");
//                        sentiment = news_sentiment.getS();
//
//                        news_text = item.get("news_text");
//                        text = news_text.getS();
//
//                        news_link = item.get("news_link");
//                        newsLink = news_link.getS();
//
//                        dbDateString = dbDate.toString();
///////////////////////////////////////////////////////////////////////////////////////////////////
//                        if(sentiment.equals("positive")){
//
//                            posNewsList.add(text);
//                            posTitleList.add(newsLink);
//                            posDateList.add(dbDateString);
//                        }
//                        else if(sentiment.equals("negative")){
//                            negNewsList.add(text);
//                            negTitleList.add(newsLink);
//                            negDateList.add(dbDateString);
//                        }
//                        else if(sentiment.equals("neutral")){
//                            neutNewsList.add(text);
//                            neutTitleList.add(newsLink);
//                            neutDateList.add(dbDateString);
//                        }
//                        else if(sentiment.equals("very negative")){
//                            vnegNewsList.add(text);
//                            vnegTitleList.add(newsLink);
//                            vnegDateList.add(dbDateString);
//                        }
//                        else if(sentiment.equals("very positive")){
//                            vposNewsList.add(text);
//                            vposTitleList.add(newsLink);
//                            vposDateList.add(dbDateString);
//                        }
//                        System.out.println(sentiment);
//                    }
//
//
//
//                }
//                fromDate = fromDate.plusDays(1);
//            }
//            totalList.add(posNewsList);
//            totalList.add(negNewsList);
//            totalList.add(neutNewsList);
//            totalList.add(vnegNewsList);
//            totalList.add(vposNewsList);
//
//            totalList.add(posTitleList);
//            totalList.add(negTitleList);
//            totalList.add(neutTitleList);
//            totalList.add(vnegTitleList);
//            totalList.add(vposTitleList);
//
//            System.out.println(dbDateString);
//            System.out.println(posDateList);
//            totalList.add(posDateList);
//            totalList.add(negDateList);
//            totalList.add(neutDateList);
//            totalList.add(vnegDateList);
//            totalList.add(vposDateList);
//            System.out.println(totalList);
//
//            return totalList;

    }


}
