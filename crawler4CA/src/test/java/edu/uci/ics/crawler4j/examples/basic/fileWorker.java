package test.java.edu.uci.ics.crawler4j.examples.basic;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class fileWorker extends HttpServlet	 {
	
//public static void main(String[] args) throws Exception{
//	try {
//	BufferedReader br = new BufferedReader(new FileReader("sample.txt"));
//        StringBuilder sb = new StringBuilder();
//        String line = br.readLine();
//
//        while (line != null) {
//            sb.append(line);
//            sb.append(System.lineSeparator());
//            line = br.readLine();
//        }
//        String everything = sb.toString();
//        System.out.println("Everything :" + everything);
//    }
//	catch (IOException e){
//		
//	}
//}

public static String crawler() throws Exception{
	 String everything = null;
	 String start = "";
	try {
	BufferedReader br = new BufferedReader(new FileReader("sample.txt"));
        StringBuilder sb = new StringBuilder();
        String line = br.readLine();

        while (line != null) {
            sb.append(line);
            sb.append(System.lineSeparator());
            line = br.readLine();
        }
        everything = sb.toString();
        System.out.println("Everything :" + everything);
       
        if(everything.contains("GHC Building Construction Pte Ltd"))
		{
			String[] splitText = everything.split("New Property Launch >");
			start = splitText[1];
		}
    }
	catch (IOException e){
		
	}
	return start;
}

public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException 
        {
			
				String username = request.getParameter("name");
				String outputData = "";
				try {
					outputData = crawler();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				request.setAttribute("outputData",outputData);
		        request.getRequestDispatcher("/crawler.jsp").forward(request,response);
        }

//Redirect POST request to GET request.    @Override
public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
    doGet(request, response);
}

}


