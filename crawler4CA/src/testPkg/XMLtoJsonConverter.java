package testPkg;

//import java.io.BufferedReader;
//import java.io.ByteArrayInputStream;
//import java.io.FileNotFoundException;
//import java.io.FileReader;
//import java.io.IOException;
//import java.io.InputStream;
//import java.net.URL;
//
//import net.sf.json.JSON;
//import net.sf.json.xml.XMLSerializer;
//
//import org.apache.commons.io.IOUtils;
//
//public class XMLtoJsonConverter {
////  private URL url = null;
//    private InputStream inp = null;   
//    
//    public void getXMLfromJson() throws FileNotFoundException {
//    	BufferedReader br = new BufferedReader(new FileReader("convTest.xml"));
//        try{
////            url = XMLtoJsonConverter.class.getClassLoader().getResource("D:/vignesh/vigneshCrawler/webCrawler2/crawler4CA/convTest.xml");
////            inputStream = url.openStream();
//        	
//        	
//        	
//            StringBuilder sb = new StringBuilder();
//            String line = br.readLine();
//
//            while (line != null) {
//                sb.append(line);
//                sb.append(System.lineSeparator());
//                line = br.readLine();
//            }
//            String everything = sb.toString();
//            inp = new ByteArrayInputStream(everything.getBytes());
//            
//            String xml = IOUtils.toString(inp);
//            JSON objJson = new XMLSerializer().read(xml);
//            br.close();
//            System.out.println("JSON data : " + objJson);
//        }catch(Exception e){
//            e.printStackTrace();
//        }finally{
//     try {		
//    	 		
//                if (inp != null) {
//                    inp.close();
//                }
//                //url = null;
//            } catch (IOException ex) {}
//        }
//    }
//    public static void main(String[] args) throws FileNotFoundException {
//        new XMLtoJsonConverter().getXMLfromJson();
//    }
//}


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import net.sf.json.xml.XMLSerializer;

import java.io.*;

import org.apache.commons.io.IOUtils;

public class XMLtoJsonConverter {
    private static URL url = null;
    private static InputStream inputStream = null;   
    public static void getXMLfromJson(int fileNo) throws IOException {
    	
    	
    	File f = new File("jsonFile"+fileNo+".txt");
		Boolean flag = false;
		if(f.exists()){
			f.delete();
			flag = true;
			System.out.println("flag : "+flag);
		}
		else{
			System.out.println("File not found to delete");
		}
		
    	String jsonString = "";
    	BufferedWriter bw = new BufferedWriter(new FileWriter("jsonFile"+fileNo+".txt"));
        try{
            //url = XMLtoJsonConverter.class.getClassLoader().getResource("convTest"+fileNo+".xml");
            //inputStream = url.openStream();
            inputStream = new FileInputStream("convTest"+fileNo+".xml");
            String xml = IOUtils.toString(inputStream);
            JSON objJson = new XMLSerializer().read(xml);
            System.out.println("JSON data : " + objJson);
            jsonString = JsonFormatter.format((JSONObject) objJson);
            //String jsonString = objJson.toString(4);
            bw.write(jsonString);
            bw.close();
            
            
        }catch(Exception e){
            e.printStackTrace();
        }finally{
     try {
                if (inputStream != null) {
                    inputStream.close();
                }
                url = null;
            } catch (IOException ex) {}
        }
    }
    public static void main(String[] args) throws IOException {
        new XMLtoJsonConverter().getXMLfromJson(1);
    }
}