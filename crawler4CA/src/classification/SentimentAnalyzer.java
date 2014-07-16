package classification;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import edu.stanford.nlp.ling.CoreAnnotations;
import edu.stanford.nlp.pipeline.Annotation;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;
import edu.stanford.nlp.sentiment.SentimentCoreAnnotations;
import edu.stanford.nlp.neural.rnn.RNNCoreAnnotations;
import edu.stanford.nlp.trees.Tree;
import edu.stanford.nlp.util.CoreMap;

public class SentimentAnalyzer {

    public String findSentiment(String line) {

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
        String postClassifiedVal = classifier(line,sentiValue);
        return postClassifiedVal;

    }

    private String toCss(int sentiment) {
        switch (sentiment) {
        case 0:
            return "very negative";
        case 1:
            return "negative";
        case 2:
            return "neutral";
        case 3:
            return "postive";
        case 4:
            return "very positive";
        default:
            return "";
        }
    }
    
    public String classifier(String line, String sentiment){
    	
		String[] positiveString = new String[] {"is up by","largest","largest ever","extended","expanded", "trusted","whopping", "donated","too good","better layout"};
		String[] neutralString = new String[] {",but",", but"};

		List positiveList = Arrays.asList(positiveString);
		List neutralList = Arrays.asList(neutralString);

		if(sentiment.equalsIgnoreCase("negative")){
			
			Iterator itn = neutralList.iterator();
			Iterator itp = positiveList.iterator();
			
			while(itn.hasNext()){
				
				if(line.contains((CharSequence) itn.next()) ){
					sentiment  = "neutral";
				}
				
			}
			
			while(itp.hasNext()){
				
				if(line.contains((CharSequence) itp.next()) ){
					sentiment  = "positive";
				}
				
			}
			
		}

		return sentiment;
    }
    
    public static String getSentimentValue(String news) {
        SentimentAnalyzer sentimentAnalyzer = new SentimentAnalyzer();
        String getSentiment = sentimentAnalyzer
                .findSentiment(news);
        if(getSentiment.equals("negative")){
        	news = news + " -- " + "<h3 class='negSentiment'>" +getSentiment + "</h3>";
        }
        else if(getSentiment.equals("neutral")){
        	news = news + " -- " + "<h3 class='neutSentiment'>" +getSentiment + "</h3>";
        }
        else if(getSentiment.equals("postive")){
        	news = news + " -- " + "<h3 class='posSentiment'>" +getSentiment + "</h3>";
        }
        else if(getSentiment.equals("very negative"))
        {
        	news = news + " -- " + "<h3 class='negSentiment'>" +getSentiment + "</h3>";
        }
        else
        {
        	news = news + " -- " + "<h3 class='posSentiment'>" +getSentiment + "</h3>";
        }
        
        System.out.println(getSentiment);
        return news;
    }

//    public static void main(String[] args) {
//        SentimentAnalyzer sentimentAnalyzer = new SentimentAnalyzer();
//        GetSentiment getSentiment = sentimentAnalyzer
//                .findSentiment("Foreign investors must now work harder for PR status");
//        System.out.println(getSentiment);
//    }
}
