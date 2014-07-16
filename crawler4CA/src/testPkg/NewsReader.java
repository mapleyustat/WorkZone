package testPkg;
import classification.GetSentiment;
import classification.SentimentAnalyzer;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


public class NewsReader extends SentimentAnalyzer {
	
	public static String readFile() throws IOException{
		
		String textRead,value = "";
		BufferedReader br = new BufferedReader (new FileReader("/Users/lelong/Documents/workspace/consolidatedCrawler/crawler4CA/crawledNews.txt"));
		 while (br.ready()) {
			 textRead =  br.readLine();
			 
			 value = value +"<br><br>"+ getSentimentValue(textRead);
		 }
		 br.close();
		 return value;
	}
	
	public static String findInfo(String keyword) throws IOException{
		
		String textRead,textReadLC,textReadUC = "";
		String value = "";
		BufferedReader br = new BufferedReader (new FileReader("/Users/lelong/Documents/workspace/consolidatedCrawler/crawler4CA/crawledNews.txt"));
		 while (br.ready()) {
			 textRead =  br.readLine();
			 textReadLC = textRead.toLowerCase();
			 textReadUC = textRead.toUpperCase();
			 if(textReadLC.contains(keyword)){
				 value = value +"<br><br>"+ getSentimentValue(textRead);
			 }
			 else if(textReadUC.contains(keyword)){
				 value = value +"<br><br>"+ getSentimentValue(textRead);
			 }
			 else if(textRead.contains(keyword)){
				 value = value +"<br><br>"+ getSentimentValue(textRead);
			 }
			 else{
				 //do nothing
			 }
		 }
		 br.close();
		 return value;
	}


}
