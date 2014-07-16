package testPkg;


import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.io.IOUtils;

import sun.org.mozilla.javascript.internal.json.JsonParser;
import sun.org.mozilla.javascript.internal.json.JsonParser.ParseException;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;

 
public class GsonParsing {
	  
    public static void main(String[] args) throws MalformedURLException, IOException, ParseException {
//    	URL url = null;
//        InputStream inputStream = null;
//
//    try{
//        url = XMLtoJsonConverter.class.getClassLoader().getResource("convTest1.xml");
//        inputStream = url.openStream();
//        String json = IOUtils.toString(inputStream);
//
//        JsonParser parser = new JsonParser(null, null);
//        Gson gson = new GsonBuilder().setPrettyPrinting().create();
//
//        JsonElement el = (JsonElement) parser.parseValue(json);
//        String jsonString = gson.toJson(el); // done
//        System.out.println(jsonString);
//    }
//    catch(IOException e){}

        String date = now("dd-MM-yyyy");
        System.out.println(date);
    }
    public static String now(String dateFormat) {
        Calendar cal = Calendar.getInstance();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        return sdf.format(cal.getTime());

    }
}
