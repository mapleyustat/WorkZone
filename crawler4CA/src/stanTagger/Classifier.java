package stanTagger;

import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import edu.stanford.nlp.ling.CoreAnnotations;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.ling.HasWord;
import edu.stanford.nlp.ling.TaggedWord;
import edu.stanford.nlp.neural.rnn.RNNCoreAnnotations;
import edu.stanford.nlp.pipeline.Annotation;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;
import edu.stanford.nlp.process.CoreLabelTokenFactory;
import edu.stanford.nlp.process.DocumentPreprocessor;
import edu.stanford.nlp.process.PTBTokenizer;
import edu.stanford.nlp.process.TokenizerFactory;
import edu.stanford.nlp.sentiment.SentimentCoreAnnotations;
import edu.stanford.nlp.tagger.maxent.MaxentTagger;
import edu.stanford.nlp.trees.Tree;
import edu.stanford.nlp.util.CoreMap;
import org.apache.commons.lang.time.DateUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;
import java.text.SimpleDateFormat;

import java.io.*;
import java.util.*;

/**
 * Created by Vignesh on 7/6/2014.
 */
public class Classifier {
    private Classifier() {}

    public String newsID = "";
    public String website = "";
    public String title_sentiment = "";
    public String title_text = "";
    public String news_sentiment = "";
    public String news_text = "";
    public String date = "";



    public static Set<String> loadDictionary(String fileName) throws IOException {
        Set<String> words = new HashSet<String>();
        File file = new File(fileName+".txt");
        String line ="";
        BufferedReader br = new BufferedReader(new FileReader (file));
        while(br.ready()) {
            line = br.readLine();
            words.add(line);
        }
        br.close();
        return words;
    }

    public static void main(String[] args) throws Exception {

        //object
        Classifier obj = new Classifier();
//        obj.newsID="002";
//        obj.title_sentiment="positive";
//        obj.title_text="Best Solution Corp";
//        obj.website="propertyportalwatch";
//        obj.date = "05-06-2014";

        long positiveCount = 0;
        long negativeCount = 0;
        Set<String> positive = loadDictionary("positivewordsdictionary");
        Set<String> negative = loadDictionary("negativewordsdictionary");
        List<String> classification = new ArrayList<String>();
        List<String> classificationTitle = new ArrayList<String>();
        int i = 0;
        int j = 0;
        String line = "";
        String stanClassSentiment = "";
        String stanClassSentimentTitle ="";
        String tableName = "CA_NEWS";

        AmazonDynamoDBSample dyn = new AmazonDynamoDBSample();
        AttributeValue id;
        String idVal = "";
        int val = 0;
        /*Using AWS API
       * Fetching all the items and incrementing the newsID accordingly to avoid updating the same records.
       * */
        ScanResult result = dyn.getAllItems(tableName);
        val = result.getCount();
        System.out.println(val);

        int newsIdCounter = val+1;


        List<String> newsID = new ArrayList<String>();

        int k =0;



        /*crawledNews and its sentiment
        *
        * */
        int newsSentiCounter = 0;
        MaxentTagger tagger = new MaxentTagger("english-left3words-distsim.tagger");
        TokenizerFactory<CoreLabel> ptbTokenizerFactory = PTBTokenizer.factory(new CoreLabelTokenFactory(),
                "untokenizable=noneKeep");
        BufferedReader r = new BufferedReader(new InputStreamReader(new FileInputStream("crawledNews.txt"), "utf-8"));
        DocumentPreprocessor documentPreprocessor = new DocumentPreprocessor(r);
        documentPreprocessor.setTokenizerFactory(ptbTokenizerFactory);
        for (List<HasWord> sentence : documentPreprocessor) {
            List<TaggedWord> taggedSent = tagger.tagSentence(sentence);
            for (TaggedWord tw : taggedSent) {
               // if (tw.tag().startsWith("JJ")) {
                    if (positive.contains(tw.word().toLowerCase())) {
                        System.out.println("Found positive "+positiveCount+":"+tw.word());
                        positiveCount++;
                    }
                    if (negative.contains(tw.word().toLowerCase())) {
                        System.out.println("Found negative "+negativeCount+":"+tw.word());
                        negativeCount++;
                    }
               // }
            }


            if(positiveCount>negativeCount){
                classification.add(newsSentiCounter,"positive");
                positiveCount=0;
                negativeCount=0;
            }
            else if(negativeCount>positiveCount){
                classification.add(newsSentiCounter,"negative");
                positiveCount=0;
                negativeCount=0;
            }
            else{
                classification.add(newsSentiCounter,"neutral");
                positiveCount=0;
                negativeCount=0;
            }
            newsSentiCounter++;
        }
        r.close();
        System.out.println(classification);

        //Declaration
        List<String> crawledNews = new ArrayList<String>();
        List<String> crawledNewsSenti = new ArrayList<String>();
        int newsCounter = 0;
        // Stanford Sentiment Analyser:
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream("crawledNews.txt"), "utf-8"));
        while (br.ready()){
            newsID.add(newsCounter,String.valueOf(newsIdCounter));
            line = br.readLine();
            crawledNews.add(newsCounter,line);
            stanClassSentiment = findSentiment(line);
            if(stanClassSentiment.equals("negative")||stanClassSentiment.equals("very negative")){
                if(stanClassSentiment.equals(classification.get(j))){
                    //do nothing
                }
                else{
                    stanClassSentiment = classification.get(j);
                }
            }
            crawledNewsSenti.add(newsCounter,stanClassSentiment);
            newsCounter++;
            newsIdCounter++;
            j++;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /*crawledNewsTitle and its sentiment
        *
        * */

        positiveCount=0;
        negativeCount=0;
        int titleSentiCounter = 0;
        MaxentTagger taggerTitle = new MaxentTagger("english-left3words-distsim.tagger");
        TokenizerFactory<CoreLabel> ptbTokenizerFactoryTitle = PTBTokenizer.factory(new CoreLabelTokenFactory(),
                "untokenizable=noneKeep");
        BufferedReader rt = new BufferedReader(new InputStreamReader(new FileInputStream("crawledNewsTitle.txt"), "utf-8"));
        DocumentPreprocessor documentPreprocessorTitle = new DocumentPreprocessor(rt);
        documentPreprocessorTitle.setTokenizerFactory(ptbTokenizerFactoryTitle);
        for (List<HasWord> sentence : documentPreprocessorTitle) {
            List<TaggedWord> taggedSent = taggerTitle.tagSentence(sentence);
            for (TaggedWord tw : taggedSent) {
               // if (tw.tag().startsWith("JJ")) {
                    if (positive.contains(tw.word().toLowerCase())) {
                        System.out.println("Found positive "+positiveCount+":"+tw.word());
                        positiveCount++;
                    }
                    if (negative.contains(tw.word().toLowerCase())) {
                        System.out.println("Found negative "+negativeCount+":"+tw.word());
                        negativeCount++;
                    }
              //  }
            }


            if(positiveCount>negativeCount){
                classificationTitle.add(titleSentiCounter,"positive");
                positiveCount=0;
                negativeCount=0;
            }
            else if(negativeCount>positiveCount){
                classificationTitle.add(titleSentiCounter,"negative");
                positiveCount=0;
                negativeCount=0;
            }
            else{
                classificationTitle.add(titleSentiCounter,"neutral");
                positiveCount=0;
                negativeCount=0;
            }
            titleSentiCounter++;
        }
        rt.close();
        System.out.println(classificationTitle);

        //Declaration
        List<String> crawledNewsTitle = new ArrayList<String>();
        List<String> crawledNewsSentiTitle = new ArrayList<String>();
        int newsCounterTitle = 0;
        j=0;
        // Stanford Sentiment Analyser:
        BufferedReader brt = new BufferedReader(new InputStreamReader(new FileInputStream("crawledNewsTitle.txt"), "utf-8"));
        while (brt.ready()){
            line = brt.readLine();
            crawledNewsTitle.add(newsCounterTitle,line);
            stanClassSentimentTitle = findSentiment(line);
            if(stanClassSentimentTitle.equals("negative")||stanClassSentiment.equals("very negative")){
                if(stanClassSentimentTitle.equals(classificationTitle.get(j))){
                    //do nothing
                }
                else{
                    stanClassSentimentTitle = classificationTitle.get(j);
                }
            }
            crawledNewsSentiTitle.add(newsCounterTitle,stanClassSentimentTitle);
            newsCounterTitle++;
            j++;
        }

        System.out.println(crawledNews);
        System.out.println(crawledNewsSenti);
        System.out.println(crawledNewsTitle);
        System.out.println(crawledNewsSentiTitle);
        String website = "propertyportalwatch";
        String date = obj.now("dd-MM-yyyy");


       /*Using AWS API
       * Fetching all the items and incrementing the newsID accordingly to avoid updating the same records.
       * */


        /*creating news records in DYNAMO DB*/
//        for(k=0;k<newsCounter;k++) {
//            dyn.addItem(tableName, crawledNewsSentiTitle.get(k), crawledNewsTitle.get(k), crawledNewsSenti.get(k), crawledNews.get(k), website, date, newsID.get(k));
//        }
        //pw.println(res);
        System.out.println(" ALL NEWS WERE INSERTED");


    }

    public static String findSentiment(String line) {

        Properties props = new Properties();
        props.setProperty("annotators", "tokenize, ssplit, parse, sentiment");
        StanfordCoreNLP pipeline = new StanfordCoreNLP(props);
        int mainSentiment = 0;
        if (line != null && line.length() > 0) {
            int longest = 0;
            Annotation annotation = pipeline.process(line);
            for (CoreMap sentence : annotation.get(CoreAnnotations.SentencesAnnotation.class)) {
                Tree tree = sentence.get(SentimentCoreAnnotations.AnnotatedTree.class);
                int sentiment = RNNCoreAnnotations.getPredictedClass(tree);
                String partText = sentence.toString();
                if (partText.length() > longest) {
                    mainSentiment = sentiment;
                    longest = partText.length();
                }

            }
        }
        if (mainSentiment > 4 || mainSentiment < 0) {
            return null;
        }
        String sentiValue = toCss(mainSentiment);
        return sentiValue;

    }

    private static String toCss(int sentiment) {
        switch (sentiment) {
            case 0:
                return "very negative";
            case 1:
                return "negative";
            case 2:
                return "neutral";
            case 3:
                return "positive";
            case 4:
                return "very positive";
            default:
                return "";
        }
    }

    public static String now(String dateFormat) {
        Calendar cal = Calendar.getInstance();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
            return sdf.format(cal.getTime());

    }

}
