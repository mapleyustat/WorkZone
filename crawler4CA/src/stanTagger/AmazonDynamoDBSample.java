package stanTagger;

/*
 * Copyright 2012-2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.*;
import com.amazonaws.services.dynamodbv2.util.Tables;
import com.amazonaws.services.simpledb.model.Attribute;
import org.apache.commons.lang.WordUtils;
import org.w3c.dom.Attr;

/**
 * This sample demonstrates how to perform a few simple operations with the
 * Amazon DynamoDB service.
 */
public class AmazonDynamoDBSample {

    /*
     * Before running the code:
     *      Fill in your AWS access credentials in the provided credentials
     *      file template, and be sure to move the file to the default location
     *      (~/.aws/credentials) where the sample code will load the
     *      credentials from.
     *      https://console.aws.amazon.com/iam/home?#security_credential
     *
     * WANRNING:
     *      To avoid accidental leakage of your credentials, DO NOT keep
     *      the credentials file in your source directory.
     */

    static AmazonDynamoDBClient dynamoDB;

    /**
     * The only information needed to create a client are security credentials
     * consisting of the AWS Access Key ID and Secret Access Key. All other
     * configuration, such as the service endpoints, are performed
     * automatically. Client parameters, such as proxies, can be specified in an
     * optional ClientConfiguration object when constructing a client.
     *
     * @see com.amazonaws.auth.BasicAWSCredentials
     * @see com.amazonaws.auth.profile.ProfilesConfigFile
     * @see com.amazonaws.ClientConfiguration
     */
    private static void init() throws Exception {
        /*
         * The ProfileCredentialsProvider will return your [default]
         * credential profile by reading from the credentials file located at
         * (~/.aws/credentials).
         */
        AWSCredentials credentials = null;
        try {
            credentials = new ProfileCredentialsProvider().getCredentials();
        } catch (Exception e) {
            throw new AmazonClientException(
                    "Cannot load the credentials from the credential profiles file. " +
                    "Please make sure that your credentials file is at the correct " +
                    "location (~/.aws/credentials), and is in valid format.",
                    e);
        }
        dynamoDB = new AmazonDynamoDBClient(credentials);
        Region usWest2 = Region.getRegion(Regions.US_WEST_2);
        dynamoDB.setRegion(usWest2);
    }
    
    public static void addItem(String tableName,String crawledNewsSentiTitle,String crawledNewsTitle,String crawledNewsSenti ,String crawledNews,String website,String date,String newsID) throws Exception{
    	
    	init();
    	Map<String, AttributeValue> item = newItem(newsID,date,crawledNewsSenti,crawledNews,crawledNewsSentiTitle, crawledNewsTitle,website);
        PutItemRequest putItemRequest = new PutItemRequest(tableName, item);
        PutItemResult putItemResult = dynamoDB.putItem(putItemRequest);
        System.out.println("Result: " + putItemResult);
        
    }

    public static void dummy(String[] args) throws Exception {
        init();

        try {
            String tableName = "my-favorite-movies-table";

            // Create table if it does not exist yet
            if (Tables.doesTableExist(dynamoDB, tableName)) {
                System.out.println("Table " + tableName + " is already ACTIVE");
            } else {
                // Create a table with a primary hash key named 'name', which holds a string
                CreateTableRequest createTableRequest = new CreateTableRequest().withTableName(tableName)
                    .withKeySchema(new KeySchemaElement().withAttributeName("name").withKeyType(KeyType.HASH))
                    .withAttributeDefinitions(new AttributeDefinition().withAttributeName("name").withAttributeType(ScalarAttributeType.S))
                    .withProvisionedThroughput(new ProvisionedThroughput().withReadCapacityUnits(1L).withWriteCapacityUnits(1L));
                    TableDescription createdTableDescription = dynamoDB.createTable(createTableRequest).getTableDescription();
                System.out.println("Created Table: " + createdTableDescription);

                // Wait for it to become active
                System.out.println("Waiting for " + tableName + " to become ACTIVE...");
                Tables.waitForTableToBecomeActive(dynamoDB, tableName);
            }

            // Describe our new table
            DescribeTableRequest describeTableRequest = new DescribeTableRequest().withTableName(tableName);
            TableDescription tableDescription = dynamoDB.describeTable(describeTableRequest).getTable();
            System.out.println("Table Description: " + tableDescription);

//            // Add an item
//            Map<String, AttributeValue> item = newItem("Bill & Ted's Excellent Adventure", 1989, "****", "James", "Sara");
//            PutItemRequest putItemRequest = new PutItemRequest(tableName, item);
//            PutItemResult putItemResult = dynamoDB.putItem(putItemRequest);
//            System.out.println("Result: " + putItemResult);
//
//            // Add another item
//            item = newItem("Airplane", 1980, "*****", "James", "Billy Bob");
//            putItemRequest = new PutItemRequest(tableName, item);
//            putItemResult = dynamoDB.putItem(putItemRequest);
//            System.out.println("Result: " + putItemResult);

            // Scan items for movies with a year attribute greater than 1985
            HashMap<String, Condition> scanFilter = new HashMap<String, Condition>();
            Condition condition = new Condition()
                .withComparisonOperator(ComparisonOperator.GT.toString())
                .withAttributeValueList(new AttributeValue().withN("1985"));
            scanFilter.put("year", condition);
            ScanRequest scanRequest = new ScanRequest(tableName).withScanFilter(scanFilter);
            ScanResult scanResult = dynamoDB.scan(scanRequest);
            System.out.println("Result: " + scanResult);

        } catch (AmazonServiceException ase) {
            System.out.println("Caught an AmazonServiceException, which means your request made it "
                    + "to AWS, but was rejected with an error response for some reason.");
            System.out.println("Error Message:    " + ase.getMessage());
            System.out.println("HTTP Status Code: " + ase.getStatusCode());
            System.out.println("AWS Error Code:   " + ase.getErrorCode());
            System.out.println("Error Type:       " + ase.getErrorType());
            System.out.println("Request ID:       " + ase.getRequestId());
        } catch (AmazonClientException ace) {
            System.out.println("Caught an AmazonClientException, which means the client encountered "
                    + "a serious internal problem while trying to communicate with AWS, "
                    + "such as not being able to access the network.");
            System.out.println("Error Message: " + ace.getMessage());
        }
    }

    private static Map<String, AttributeValue> newItem(String NewsID, String date, String news_sentiment, String news_text, String title_sentiment, String title_text, String website) {
        Map<String, AttributeValue> item = new HashMap<String, AttributeValue>();
        item.put("NewsID", new AttributeValue(NewsID));
        item.put("date", new AttributeValue(date));
        item.put("news_sentiment", new AttributeValue(news_sentiment));
        item.put("news_text", new AttributeValue(news_text));
        item.put("title_sentiment", new AttributeValue(title_sentiment));
        item.put("title_text", new AttributeValue(title_text));
        item.put("website", new AttributeValue(website));

        return item;
    }

    public static ScanResult getNewsItem(String tableName, String sentiment) throws Exception{

        init();
        Condition scanFilterCondition = new Condition()
                .withComparisonOperator(ComparisonOperator.CONTAINS.toString())
                .withAttributeValueList(new AttributeValue().withS(sentiment));
        Map<String, Condition> conditions = new HashMap<String, Condition>();
        conditions.put("news_sentiment", scanFilterCondition);
        ScanRequest scanRequest = new ScanRequest().withTableName(tableName).withScanFilter(conditions);
        ScanResult result = dynamoDB.scan(scanRequest);
        return result;
    }

    public static ScanResult getTitleItem(String tableName, String sentiment) throws Exception{

        init();
        Condition scanFilterCondition = new Condition()
                .withComparisonOperator(ComparisonOperator.CONTAINS.toString())
                .withAttributeValueList(new AttributeValue().withS(sentiment));
        Map<String, Condition> conditions = new HashMap<String, Condition>();
        conditions.put("title_sentiment", scanFilterCondition);
        ScanRequest scanRequest = new ScanRequest().withTableName(tableName).withScanFilter(conditions);
        ScanResult result = dynamoDB.scan(scanRequest);
        return result;
    }

    public static ScanResult geAllItemsBySearch(String tableName,String keyword) throws Exception {
        init();
        Condition scanFilterCondition = new Condition()
                .withComparisonOperator(ComparisonOperator.CONTAINS.toString())
                .withAttributeValueList(new AttributeValue());
        Map<String, Condition> conditions = new HashMap<String, Condition>();
        conditions.put("news_text", scanFilterCondition);
        ScanRequest scanRequest = new ScanRequest().withTableName(tableName).withScanFilter(conditions);
        ScanResult result = dynamoDB.scan(scanRequest);
        return result;
    }

    public static ScanResult getAllItems(String tableName) throws Exception {
        init();
//        ScanResult result=null;
        ScanRequest scanRequest = new ScanRequest().withTableName(tableName);
        ScanResult result = dynamoDB.scan(scanRequest);
        return result;
}

    public static ScanResult geAllItemsByDate(String tableName,String keyword) throws Exception {
        init();
        Condition scanFilterCondition = new Condition()
                .withComparisonOperator(ComparisonOperator.EQ.toString())
                .withAttributeValueList(new AttributeValue(keyword));
        Map<String, Condition> conditions = new HashMap<String, Condition>();
        conditions.put("news_date", scanFilterCondition);
        ScanRequest scanRequest = new ScanRequest().withTableName(tableName).withScanFilter(conditions);
        ScanResult result = dynamoDB.scan(scanRequest);
        System.out.println(result);
        return result;
    }


    public static QueryResult getAllItemsByQuery(String tableName,String i) throws Exception {
        init();
//        List<String> date = new ArrayList();
//        date.add("26-03-2013");
//        date.add("22-11-2013");
//        Condition scanFilterCondition = new Condition()
//                .withComparisonOperator(ComparisonOperator.EQ.toString())
//                .withAttributeValueList(new AttributeValue().withSS(date.get(0),date.get(1)));
//        Map<String, Condition> conditions = new HashMap<String, Condition>();
//        conditions.put("news_date", scanFilterCondition);
//        ScanRequest scanRequest = new ScanRequest().withTableName(tableName).withScanFilter(conditions);
//        ScanResult result = dynamoDB.scan(scanRequest);

        String date = "27-06-2013";
        Condition filterCondition = new Condition()
                .withComparisonOperator(ComparisonOperator.CONTAINS)
                .withAttributeValueList(new AttributeValue().withS(date));

        Map<String, Condition> keyConditions = new HashMap<String, Condition>();

            Condition hashKeyCondition = new Condition()
                    .withComparisonOperator(ComparisonOperator.EQ)
                    .withAttributeValueList(new AttributeValue().withN(i));
            keyConditions.put("news_id",hashKeyCondition);

        Map<String,Condition> queryFilter = new HashMap<String,Condition>();
        queryFilter.put("news_date", filterCondition);

        QueryRequest queryRequest = new QueryRequest()
                .withTableName(tableName)
                .withKeyConditions(keyConditions)
                .withQueryFilter(queryFilter);
        QueryResult result = dynamoDB.query(queryRequest);
        return result;
    }

    public static void deleteItems() throws Exception {
        init();
        String tableName="CA_NEWS";
        AttributeValue newsID ;
        AttributeValue date ;
        String dateToDelete ="12-06-2014";
        ScanResult result = getAllItems(tableName);
        for (Map<String, AttributeValue> item : result.getItems()) {
            newsID = item.get("NewsID");
            String iString = newsID.getS();
            date = item.get("date");
            String getdate = date.getS();
//            String iString = String.valueOf();
            if (getdate.equals(dateToDelete)) {
                HashMap<String, AttributeValue> key = new HashMap<String, AttributeValue>();
                key.put("NewsID", new AttributeValue().withS(iString));

                Map<String, ExpectedAttributeValue> expectedValues = new HashMap<String, ExpectedAttributeValue>();
                expectedValues.put("date",
                        new ExpectedAttributeValue()
                                .withComparisonOperator(ComparisonOperator.CONTAINS.toString())
                                .withAttributeValueList(new AttributeValue().withS(dateToDelete))
                );

                DeleteItemRequest deleteItemRequest = new DeleteItemRequest()
                        .withTableName(tableName)
                        .withKey(key)
                        .withExpected(expectedValues);

                dynamoDB.deleteItem(deleteItemRequest);
            }
        }
    }
///////////////////////////////IPROPERTY//////////////////////////////////////////////////////////////////////////////
    public static void getSpecificIndex() throws Exception {
        init();
        String sentiment = "14-06-2014";
        String tableName = "NEWS_ARCH";
        Condition scanFilterCondition = new Condition()
                .withComparisonOperator(ComparisonOperator.CONTAINS.toString())
                .withAttributeValueList(new AttributeValue().withS(sentiment));
        Map<String, Condition> conditions = new HashMap<String, Condition>();
        conditions.put("date", scanFilterCondition);
        ScanRequest scanRequest = new ScanRequest().withTableName(tableName).withScanFilter(conditions);
        ScanResult result = dynamoDB.scan(scanRequest);
        System.out.println(result);
    }

    public static void deleteSpecificIndex() throws Exception {
        init();
        String tableName = "CA_NEWS_ARCH";
        int news_id = 660;

        HashMap<String, AttributeValue> key = new HashMap<String, AttributeValue>();
        for(int val=1;val<=727;val++){
            key.put("news_id", new AttributeValue().withN(String.valueOf(news_id)));
            DeleteItemRequest deleteItemRequest = new DeleteItemRequest()
                    .withTableName(tableName)
                    .withKey(key);
            dynamoDB.deleteItem(deleteItemRequest);
            news_id++;
        }


//        Map<String, ExpectedAttributeValue> expectedValues = new HashMap<String, ExpectedAttributeValue>();
//        expectedValues.put("date",
//                new ExpectedAttributeValue()
//                        .withComparisonOperator(ComparisonOperator.CONTAINS.toString())
//                        .withAttributeValueList(new AttributeValue().withS(""))
//        );

    }

    private static Map<String, AttributeValue> newIpropertyItem(int news_id, String news_sentiment, String news_text, String crawled_date, String news_source, String news_date,String news_link,String opinion) {
        Map<String, AttributeValue> item = new HashMap<String, AttributeValue>();
        item.put("news_id", new AttributeValue().withN(String.valueOf(news_id)));
        item.put("news_sentiment", new AttributeValue(news_sentiment));
        item.put("news_text", new AttributeValue(news_text));
        item.put("crawled_date", new AttributeValue(crawled_date));
        item.put("news_source", new AttributeValue(news_source));
        item.put("news_date", new AttributeValue(news_date));
        item.put("news_link", new AttributeValue(news_link));
        item.put("opinion", new AttributeValue().withN(opinion));
        return item;
    }

    public static void addIPropertyItem(String tableName,int news_id,String news_sentiment,String news_text ,String crawled_date,String news_source,String news_date,String news_link,String sentVal) throws Exception{

        init();
        Map<String, AttributeValue> item = newIpropertyItem(news_id, news_sentiment, news_text, crawled_date, news_source, news_date, news_link,sentVal);
        PutItemRequest putItemRequest = new PutItemRequest(tableName, item);
        PutItemResult putItemResult = dynamoDB.putItem(putItemRequest);
        System.out.println("Result: " + putItemResult);

    }

    public static void addPropertyGuruItem(String tableName,int news_id,String news_sentiment,String news_text ,String crawled_date,String news_source,String news_date,String news_link,String sentVal) throws Exception{

        init();
        Map<String, AttributeValue> item = newIpropertyItem(news_id, news_sentiment, news_text, crawled_date, news_source, news_date, news_link,sentVal);
        PutItemRequest putItemRequest = new PutItemRequest(tableName, item);
        PutItemResult putItemResult = dynamoDB.putItem(putItemRequest);
        System.out.println("Result: " + putItemResult);

    }

    public static String updateOpinion(String text, String sentVal) throws Exception {
        init();
        String tableName = "CA_NEWS_ARCH";
        String id = "";
        AttributeValue news_id;

        /*Scanning code
            Vignesh
        * */
        Condition scanFilterCondition = new Condition()
                .withComparisonOperator(ComparisonOperator.EQ.toString())
                .withAttributeValueList(new AttributeValue().withS(text));
        Map<String, Condition> conditions = new HashMap<String, Condition>();
        conditions.put("news_link", scanFilterCondition);

        ScanRequest scanRequest = new ScanRequest()
                .withTableName(tableName)
                .withScanFilter(conditions);

        ScanResult result = dynamoDB.scan(scanRequest);
        for (Map<String, AttributeValue> item : result.getItems()) {
            news_id = item.get("news_id");
            id = news_id.getN();
        }
        System.out.println("idid:"+id);
        /* Updation Code
            Vignesh
        * */
        HashMap<String, AttributeValue> key = new HashMap<String, AttributeValue> ();
        key.put("news_id", new AttributeValue().withN(id));

        Map<String, AttributeValueUpdate> updateItems = new HashMap<String, AttributeValueUpdate>();
        AttributeValueUpdate attributeValueUpdateSent;
        AttributeValueUpdate attributeValueUpdate = new AttributeValueUpdate()
                //.withAction("ADD")
                .withValue(new AttributeValue().withN(sentVal));

        updateItems.put("opinion",attributeValueUpdate);
        if(sentVal.equals("0"))
        {
            attributeValueUpdateSent= new AttributeValueUpdate()
                    .withValue(new AttributeValue().withS("neutral"));
        }
        else if(sentVal.equals("1")){
            attributeValueUpdateSent= new AttributeValueUpdate()
                    .withValue(new AttributeValue().withS("very positive"));
        }
        else if(sentVal.equals("0.5")){
            attributeValueUpdateSent= new AttributeValueUpdate()
                    .withValue(new AttributeValue().withS("positive"));
        }
        else if(sentVal.equals("-0.5")){
            attributeValueUpdateSent= new AttributeValueUpdate()
                    .withValue(new AttributeValue().withS("negative"));
        }
        else{
            attributeValueUpdateSent= new AttributeValueUpdate()
                    .withValue(new AttributeValue().withS("very negative"));
        }
        updateItems.put("news_sentiment",attributeValueUpdateSent);

        UpdateItemRequest updateItemRequest = new UpdateItemRequest()
                .withTableName(tableName)
                .withKey(key)
                .withAttributeUpdates(updateItems);

        UpdateItemResult updateItemResult = dynamoDB.updateItem(updateItemRequest);
        System.out.println(updateItemResult);
        return "Updated";
    }

    public static void scriptToUpdateOpinion() throws Exception {
        init();
        String tableName = "CA_NEWS_ARCH";
        AttributeValue news_sentiment;
        String sentiment = "";
        AttributeValue news_id;
        String newsid = "";
        double score = 0;
        String scoreVal = "";

        ScanRequest scanRequest = new ScanRequest().withTableName(tableName);
        ScanResult result = dynamoDB.scan(scanRequest);
        for (Map<String, AttributeValue> item : result.getItems()) {
            news_sentiment = item.get("news_sentiment");
            sentiment = news_sentiment.getS();
            if(sentiment.equals("very negative")){
                score = -1;
            }
            else if(sentiment.equals("negative")){
                score = -0.5;
            }
            else if(sentiment.equals("neutral")){
                score = 0;
            }
            else if(sentiment.equals("positive")){
                score = 0.5;
            }
            else if(sentiment.equals("very positive")){
                score = 1;
            }
            scoreVal = String.valueOf(score);
            news_id = item.get("news_id");
            newsid = news_id.getN();
            HashMap<String, AttributeValue> key = new HashMap<String, AttributeValue> ();
            key.put("news_id", new AttributeValue().withN(newsid));

            Map<String, AttributeValueUpdate> updateItems = new HashMap<String, AttributeValueUpdate>();
            AttributeValueUpdate attributeValueUpdate = new AttributeValueUpdate()
                    .withAction("ADD")
                    .withValue(new AttributeValue().withN(scoreVal));

            updateItems.put("opinion",attributeValueUpdate);

            UpdateItemRequest updateItemRequest = new UpdateItemRequest()
                    .withTableName(tableName)
                    .withKey(key)
                    .withAttributeUpdates(updateItems);

            UpdateItemResult updateItemResult = dynamoDB.updateItem(updateItemRequest);
            System.out.println(updateItemResult);
        }
        System.out.println("done");
    }

    public static void main(String[] args) throws Exception {

        //ScanResult result = geAllItemsByDate("CA_NEWS_ARCH","20-03-2013");
        //updateOpinion("7");
//        scriptToUpdateOpinion();
        deleteSpecificIndex();
        System.out.println("got");
    }

}
