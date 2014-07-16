package test.java.edu.uci.ics.crawler4j.examples.basic;

public class MyCrawler {
	
public static void myCrawler(String urlToCrawl) throws Exception{

		String[] pass = {"D:/vignesh/vigneshCrawler/crawledData","1"};
		BasicCrawlController.passParameters(pass,urlToCrawl);
	}

    public static void main(String[] args) throws Exception{

        String[] pass = {"D:/vignesh/vigneshCrawler/crawledData","1"};
        BasicCrawlController.passParameters(pass,"http://www.propertywire.com/news/");
        System.out.println("over");
    }

}