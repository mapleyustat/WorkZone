package stanTagger;

import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
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
import org.joda.time.Days;
import org.joda.time.LocalDate;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Vignesh on 20/6/2014.
 */
public class IPropertyClassifier {


    private IPropertyClassifier() {}

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
        BufferedReader br = new BufferedReader(new FileReader(file));
        while(br.ready()) {
            line = br.readLine();
            words.add(line);
        }
        br.close();
        return words;
    }

    public static void main(String[] args) throws Exception {

        //object
        IPropertyClassifier obj = new IPropertyClassifier();
//        obj.newsID="002";
//        obj.title_sentiment="positive";
//        obj.title_text="Best Solution Corp";
//        obj.website="propertyportalwatch";
//        obj.date = "05-06-2014";

        long positiveCount = 0;
        long negativeCount = 0;
        long verypositiveCount = 0;
        long verynegativeCount = 0;
        Set<String> positive = loadDictionary("positivewordsdictionary");
        Set<String> negative = loadDictionary("negativewordsdictionary");
        Set<String> verypositive = loadDictionary("verypositivewordsdictionary");
        Set<String> verynegative = loadDictionary("verynegativewordsdictionary");
        List<String> classification = new ArrayList<String>();
        List<String> classificationTitle = new ArrayList<String>();
        int i = 0;
        int j = 0;
        String line = "";
        String stanClassSentiment = "";
        String stanClassSentimentTitle ="";
        String tableName = "CA_NEWS_ARCH";

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

        int titleSentiCounter = 0;
        MaxentTagger taggerTitle = new MaxentTagger("english-left3words-distsim.tagger");
        TokenizerFactory<CoreLabel> ptbTokenizerFactoryTitle = PTBTokenizer.factory(new CoreLabelTokenFactory(),
                "untokenizable=noneKeep");
        BufferedReader rt = new BufferedReader(new InputStreamReader(new FileInputStream("newsTitle2.txt"), "utf-8"));
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
                if (verypositive.contains(tw.word().toLowerCase())) {
                    System.out.println("Found veryPositive "+verypositiveCount+":"+tw.word());
                    verypositiveCount++;
                }
                if (verynegative.contains(tw.word().toLowerCase())) {
                    System.out.println("Found veryNegative "+verynegativeCount+":"+tw.word());
                    verynegativeCount++;
                }
                //  }
            }

            /////////////////////////////////////////////////////
            if(positiveCount>negativeCount){
                if(positiveCount>verypositiveCount){
                    if(positiveCount>verynegativeCount){
                        classificationTitle.add(titleSentiCounter,"positive");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else if(verynegativeCount>positiveCount){
                        classificationTitle.add(titleSentiCounter,"very negative");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else {
                        classificationTitle.add(titleSentiCounter,"neutral");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                }
                else{
                    if(verypositiveCount>verynegativeCount){
                        classificationTitle.add(titleSentiCounter,"very positive");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else if(verynegativeCount>verypositiveCount){
                        classificationTitle.add(titleSentiCounter,"very negative");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else{
                        classificationTitle.add(titleSentiCounter,"neutral");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                }
            }
            else{
                if(negativeCount>verypositiveCount){
                    if(negativeCount>verynegativeCount){
                        classificationTitle.add(titleSentiCounter,"negative");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else if(verynegativeCount>negativeCount){
                        classificationTitle.add(titleSentiCounter,"very negative");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else{
                        classificationTitle.add(titleSentiCounter,"neutral");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                }
                else{
                    if(verypositiveCount>verynegativeCount){
                        classificationTitle.add(titleSentiCounter,"very positive");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else if(verynegativeCount>verypositiveCount){
                        classificationTitle.add(titleSentiCounter,"very negative");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                    else{
                        classificationTitle.add(titleSentiCounter,"neutral");
                        positiveCount=0;
                        negativeCount=0;
                        verypositiveCount=0;
                        verynegativeCount=0;
                    }
                }
            }

            //////////////////////////////////////////////////////

//
//            if(positiveCount>negativeCount){
//                classificationTitle.add(titleSentiCounter,"positive");
//                positiveCount=0;
//                negativeCount=0;
//            }
//            else if(negativeCount>positiveCount){
//                classificationTitle.add(titleSentiCounter,"negative");
//                positiveCount=0;
//                negativeCount=0;
//            }
//            else{
//                classificationTitle.add(titleSentiCounter,"neutral");
//                positiveCount=0;
//                negativeCount=0;
//            }
                   titleSentiCounter++;
        }
        rt.close();
        System.out.println(classificationTitle.size());


        //Declaration
        List<String> crawledNewsTitle = new ArrayList<String>();
        List<String> crawledNewsSentiTitle = new ArrayList<String>();
        int newsCounterTitle = 0;
        j=0;
        // Stanford Sentiment Analyser:

        /////Testing
        File f = new File("SentimentAnalysis2.txt");
        Boolean flag = false;
        if(f.exists()){
            f.delete();
            flag = true;
            System.out.println("flag : "+flag);
        }
        else{
            System.out.println("File not found to delete");
        }
        BufferedWriter bw = new BufferedWriter(new FileWriter("SentimentAnalysis2.txt",true));
        /////

        BufferedReader brt = new BufferedReader(new InputStreamReader(new FileInputStream("newsTitle2.txt"), "utf-8"));
        while (brt.ready()){
            line = brt.readLine();
            crawledNewsTitle.add(newsCounterTitle,line);
            stanClassSentimentTitle = findSentiment(line);
            ///////////////////////////////////////////////////////////////////////////
            if(stanClassSentimentTitle.equals("negative")){
                if(stanClassSentimentTitle.equals(classificationTitle.get(j))){
                    //do nothing
                }
                else{
                    stanClassSentimentTitle = classificationTitle.get(j);
                }
            }
            else if(stanClassSentimentTitle.equals("neutral")){
                if(stanClassSentimentTitle.equals(classificationTitle.get(j))){
                    //do nothing
                }
                else{
                    stanClassSentimentTitle = classificationTitle.get(j);
                }
            }
            else if(stanClassSentimentTitle.equals("very negative")){
                if(stanClassSentimentTitle.equals(classificationTitle.get(j))){
                    //do nothing
                }
                else{
                    stanClassSentimentTitle = classificationTitle.get(j);
                }
            }
            else if(stanClassSentimentTitle.equals("very positive")){
                if(stanClassSentimentTitle.equals(classificationTitle.get(j))){
                    //do nothing
                }
                else{
                    stanClassSentimentTitle = classificationTitle.get(j);
                }
            }
            else {
                if(stanClassSentimentTitle.equals(classificationTitle.get(j))){
                    //do nothing
                }
                else{
                    stanClassSentimentTitle = classificationTitle.get(j);
                }
            }


            /////////////////////////////////////////////////////////////////////////////
//            if(stanClassSentimentTitle.equals("negative")||stanClassSentiment.equals("very negative")){
//                if(stanClassSentimentTitle.equals(classificationTitle.get(j))){
//                    //do nothing
//                }
//                else{
//                    stanClassSentimentTitle = classificationTitle.get(j);
//                }
//            }
            crawledNewsSentiTitle.add(newsCounterTitle,stanClassSentimentTitle);
            newsCounterTitle++;
            j++;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        //System.out.println(crawledNewsTitle);
        System.out.println(crawledNewsSentiTitle);
        for(int vnum=0;vnum<crawledNewsTitle.size();vnum++){
            bw.write(crawledNewsTitle.get(vnum)+" ---> "+crawledNewsSentiTitle.get(vnum)+"\n");
        }
        bw.close();
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
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /*
        Iproperty news insertion starts here
         */
        BufferedReader brLink = new BufferedReader(new FileReader("newsLink2.txt"));
        BufferedReader brDate = new BufferedReader(new FileReader("newsDate2.txt"));
        List<String> newsLink = new ArrayList<String>();
        List<String> newsDate = new ArrayList<String>();
        int indexLink=0;
        int indexDate=0;
        int news_id=1;
        while(brLink.ready()){
            newsLink.add(indexLink,brLink.readLine());
            indexLink++;
        }
        while(brDate.ready()){
            String dateToBeFormatted = brDate.readLine();
            //date formatting

            SimpleDateFormat formatToCompare = new SimpleDateFormat("MMM dd, yyyy");
            SimpleDateFormat myFormat = new SimpleDateFormat("dd-MM-yyyy");

            String formattedDateVal = myFormat.format(formatToCompare.parse(dateToBeFormatted));

            newsDate.add(indexDate,formattedDateVal);
            indexDate++;
        }

//        for(k=0;k<newsCounterTitle;k++) {
//            dyn.addIPropertyItem(tableName,news_id ,crawledNewsSentiTitle.get(k),crawledNewsTitle.get(k) ,"23-06-2014","iproperty",newsDate.get(k),newsLink.get(k));
//            news_id++;
//        }
//        System.out.println(" ALL NEWS WERE INSERTED");
        System.out.println("Verification done");


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
