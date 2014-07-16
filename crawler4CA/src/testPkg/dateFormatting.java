package testPkg;

import org.joda.time.LocalDate;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Vignesh on 23/6/2014.
 */
public class dateFormatting {

    public static void formatDateToInsert() throws IOException, ParseException {
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
            System.out.println(formattedDateVal);

            newsDate.add(indexDate,formattedDateVal);
            indexDate++;
        }
        System.out.println(newsDate);
    }
    public static void main(String[] args) throws IOException, ParseException {
     formatDateToInsert();
    }
}
