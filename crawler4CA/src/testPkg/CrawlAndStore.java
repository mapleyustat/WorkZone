package testPkg;

import stanTagger.Classifier;
import test.java.edu.uci.ics.crawler4j.examples.basic.MyCrawler;

/**
 * Created by Vignesh on 11/6/2014.
 */
public class CrawlAndStore {
    public static void main(String[] args) throws Exception {
        String[] val = {};
        MyCrawler.myCrawler("http://www.propertyportalwatch.com/category/news/company-news/page/10/");
        Converter.main(val);
        Classifier.main(val);
        System.out.println("FINISHED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!DONE!!!!!!!!!!!");
    }
}
