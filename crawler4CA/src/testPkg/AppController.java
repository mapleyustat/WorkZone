package testPkg;


import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import stanTagger.CrawlingNewsFromDB;
import test.java.edu.uci.ics.crawler4j.examples.basic.MyCrawler;

public class AppController extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String store = request.getParameter("store");
        String search1 = request.getParameter("search1");
        if(search1!=null && !search1.equals("")){
            store = "search1";
        }
		if(store.equals("store")){
		String urlToCrawl = request.getParameter("urlToCrawl");
		try {
			MyCrawler.myCrawler(urlToCrawl);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Converter.jsonConvWithFormatting(); 
		String crawlingDone = "done";
		
        request.setAttribute("crawlingDone",crawlingDone);
        request.getRequestDispatcher("/crawler.jsp").forward(request,response);

		}
		else if(store.equals("retrieve")){
			String news = request.getParameter("news");
            String tableName = "CA_NEWS";
            List<List<String>> totalList = new ArrayList<List<String>>();
            CrawlingNewsFromDB crawlingNewsFromDB = new CrawlingNewsFromDB();
            try {
                if(news.equals("")||news.equals(" ")||news.equals("  ")){
                    request.setAttribute("positiveNews", null);
                    request.setAttribute("negativeNews", null);
                    request.setAttribute("neutralNews", null);
                    request.setAttribute("vnegativeNews", null);
                    request.setAttribute("vpositiveNews", null);
                }
                else {
                    totalList = crawlingNewsFromDB.getAllNewsForSearch(tableName, news);
                    List<String> positiveNews = totalList.get(0);
                    int numPosNews = positiveNews.size();
                    if (!positiveNews.isEmpty()) {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", positiveNews);
                        request.setAttribute("numPosNews",numPosNews);
                    } else {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", null);
                        request.setAttribute("numPosNews",0);
                    }
                    List<String> negativeNews = totalList.get(1);
                    int numNegNews = negativeNews.size();
                    if (!negativeNews.isEmpty()) {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", negativeNews);
                        request.setAttribute("numNegNews",numNegNews);
                    } else {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", null);
                        request.setAttribute("numNegNews",0);
                    }
                    List<String> neutralNews = totalList.get(2);
                    int numNeutNews = neutralNews.size();
                    if (!neutralNews.isEmpty()) {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", neutralNews);
                        request.setAttribute("numNeutNews",numNeutNews);
                    } else {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", null);
                        request.setAttribute("numNeutNews",0);
                    }

                    List<String> vpositiveNews = totalList.get(3);
                    int numVposNews = vpositiveNews.size();
                    if(!vpositiveNews.isEmpty()){
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", vpositiveNews);
                        request.setAttribute("numVposNews",numVposNews);
                    }
                    else {
                        request.setAttribute("vpositiveNews", null);
                        request.setAttribute("numVposNews",0);
                    }

                    List<String> vnegativeNews = totalList.get(4);
                    int numVnegNews = vnegativeNews.size();
                    if(!vnegativeNews.isEmpty()){
                        request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", vnegativeNews);
                        request.setAttribute("numVnegNews",numVnegNews);
                    }
                    else {
                        request.setAttribute("vnegativeNews", null);
                        request.setAttribute("numVnegNews",0);
                    }



                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("value","Sorry! Results could not be retrieved at this time");
            }


            request.getRequestDispatcher("/landingPage.jsp").forward(request, response);
			
		}
        else if(store.equals("retrieve2")){

            String from = request.getParameter("from");
            String to = request.getParameter("to");
            String tableName = "CA_NEWS";
            List<List<String>> totalList = new ArrayList<List<String>>();
            CrawlingNewsFromDB crawlingNewsFromDB = new CrawlingNewsFromDB();
            ArrayList nval = new ArrayList();
            nval.add("NoValue");
            try {

                    totalList = crawlingNewsFromDB.getAllNewsForDate(tableName,from,to);
                    List<String> positiveNews = totalList.get(0);
                    List<String> positiveTitle = totalList.get(5);
                    List<String> positiveDate = totalList.get(10);
                    //int numPosNews = positiveNews.size();
                    if (!positiveNews.isEmpty()) {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", positiveNews);
                        request.setAttribute("positiveTitle",positiveTitle);
                        request.setAttribute("positiveDate",positiveDate);
                    //    request.setAttribute("numPosNews",numPosNews);
                    } else {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", nval);
                        request.setAttribute("positiveTitle",nval);
                        request.setAttribute("positiveDate",nval);
                    //    request.setAttribute("numPosNews",0);
                    }
                    List<String> negativeNews = totalList.get(1);
                    List<String> negativeTitle = totalList.get(6);
                    List<String> negativeDate = totalList.get(11);
                    //int numNegNews = negativeNews.size();
                    if (!negativeNews.isEmpty()) {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", negativeNews);
                        request.setAttribute("negativeTitle", negativeTitle);
                        request.setAttribute("negativeDate", negativeDate);
                    //    request.setAttribute("numNegNews",numNegNews);
                    } else {

                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews",nval );
                        request.setAttribute("negativeTitle", nval);
                        request.setAttribute("negativeDate", nval);
                     //   request.setAttribute("numNegNews",0);
                    }
                    List<String> neutralNews = totalList.get(2);
                    List<String> neutralTitle = totalList.get(7);
                    List<String> neutralDate = totalList.get(12);
                    //int numNeutNews = neutralNews.size();
                    if (!neutralNews.isEmpty()) {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", neutralNews);
                        request.setAttribute("neutralTitle", neutralTitle);
                        request.setAttribute("neutralDate", neutralDate);
                     //   request.setAttribute("numNeutNews",numNeutNews);
                    } else {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", nval);
                        request.setAttribute("neutralTitle", nval);
                        request.setAttribute("neutralDate", nval);
                     //   request.setAttribute("numNeutNews",0);
                    }


                    List<String> vnegativeNews = totalList.get(3);
                    List<String> vnegativeTitle = totalList.get(8);
                    List<String> vnegativeDate = totalList.get(13);
                   //  int numVnegNews = vnegativeNews.size();
                     if(!vnegativeNews.isEmpty()){
                     request.setAttribute("vnegative", "VERY NEGATIVE");
                     request.setAttribute("vnegativeNews", vnegativeNews);
                     request.setAttribute("vnegativeTitle", vnegativeTitle);
                     request.setAttribute("vnegativeDate", vnegativeDate);
                     //request.setAttribute("numVnegNews",numVnegNews);
                     }
                     else {
                         request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", nval);
                         request.setAttribute("vnegativeTitle", nval);
                         request.setAttribute("vnegativeDate", nval);
                    //    request.setAttribute("numVnegNews",0);
                     }


                    List<String> vpositiveNews = totalList.get(4);
                    List<String> vpositiveTitle = totalList.get(9);
                    List<String> vpositiveDate = totalList.get(14);
                    //int numVposNews = vpositiveNews.size();
                    if(!vpositiveNews.isEmpty()){
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", vpositiveNews);
                        request.setAttribute("vpositiveTitle", vpositiveTitle);
                        request.setAttribute("vpositiveDate", vpositiveDate);
                    //    request.setAttribute("numVposNews",numVposNews);
                    }
                    else {
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", nval);
                        request.setAttribute("vpositiveTitle", nval);
                        request.setAttribute("vpositiveDate", nval);
                    //    request.setAttribute("numVposNews",0);
                    }







            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("value","Sorry! Results could not be retrieved at this time");
            }


            request.getRequestDispatcher("/landingpage3.jsp").forward(request, response);

        }
        else if(store.equals("search")){
//            System.out.println("hereSearch");
            String from = request.getParameter("from");
            String to = request.getParameter("to");
            String keyword = request.getParameter("keyword");
            String tableName = "CA_NEWS_ARCH";
            List<List<String>> totalList = new ArrayList<List<String>>();
            CrawlingNewsFromDB crawlingNewsFromDB = new CrawlingNewsFromDB();
            ArrayList nval = new ArrayList();
            nval.add("NoValue");
            List<String> rad = new ArrayList<String>();
            rad.add(request.getParameter("rad"));
//            System.out.println("radddd:"+rad);
            if(rad.get(0) != null){
                if(rad.get(0).equals("daily")){
//                    System.out.println("radddd:"+rad);
                    request.setAttribute("view",rad);
                }
                else if(rad.get(0).equals("weekly")){
                    request.setAttribute("view",rad);
                }
                else if(rad.get(0).equals("monthly")){
                    request.setAttribute("view",rad);
                }

            }


            String dateInvalid = request.getParameter("dateInvalid");
//            System.out.println("dateInvalid:"+dateInvalid);
            if(dateInvalid.equals("val")) {

                try {

                    totalList = crawlingNewsFromDB.getAllNewsForDate(tableName, from,to,keyword);
                    List<String> positiveNews = totalList.get(0);
                    List<String> positiveTitle = totalList.get(5);
                    List<String> positiveDate = totalList.get(10);
                    List<String> positiveSource = totalList.get(16);
                    //int numPosNews = positiveNews.size();
                    if (!positiveNews.isEmpty()) {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", positiveNews);
                        request.setAttribute("positiveTitle", positiveTitle);
                        request.setAttribute("positiveDate", positiveDate);
                        request.setAttribute("positiveSource", positiveSource);
                        //    request.setAttribute("numPosNews",numPosNews);
                    } else {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", nval);
                        request.setAttribute("positiveTitle", nval);
                        request.setAttribute("positiveDate", nval);
                        request.setAttribute("positiveSource", nval);
                        //    request.setAttribute("numPosNews",0);
                    }
                    List<String> negativeNews = totalList.get(1);
                    List<String> negativeTitle = totalList.get(6);
                    List<String> negativeDate = totalList.get(11);
                    List<String> negativeSource = totalList.get(17);
                    //int numNegNews = negativeNews.size();
                    if (!negativeNews.isEmpty()) {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", negativeNews);
                        request.setAttribute("negativeTitle", negativeTitle);
                        request.setAttribute("negativeDate", negativeDate);
                        request.setAttribute("negativeSource", negativeSource);
                        //    request.setAttribute("numNegNews",numNegNews);
                    } else {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", nval);
                        request.setAttribute("negativeTitle", nval);
                        request.setAttribute("negativeDate", nval);
                        request.setAttribute("negativeSource", negativeSource);
                        //   request.setAttribute("numNegNews",0);
                    }
                    List<String> neutralNews = totalList.get(2);
                    List<String> neutralTitle = totalList.get(7);
                    List<String> neutralDate = totalList.get(12);
                    List<String> neutralSource = totalList.get(18);
                    //int numNeutNews = neutralNews.size();
                    if (!neutralNews.isEmpty()) {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", neutralNews);
                        request.setAttribute("neutralTitle", neutralTitle);
                        request.setAttribute("neutralDate", neutralDate);
                        request.setAttribute("neutralSource", neutralSource);
                        //   request.setAttribute("numNeutNews",numNeutNews);
                    } else {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", nval);
                        request.setAttribute("neutralTitle", nval);
                        request.setAttribute("neutralDate", nval);
                        request.setAttribute("neutralSource", nval);
                        //   request.setAttribute("numNeutNews",0);
                    }


                    List<String> vnegativeNews = totalList.get(3);
                    List<String> vnegativeTitle = totalList.get(8);
                    List<String> vnegativeDate = totalList.get(13);
                    List<String> vnegativeSource = totalList.get(19);
                    //  int numVnegNews = vnegativeNews.size();
                    if (!vnegativeNews.isEmpty()) {
                        request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", vnegativeNews);
                        request.setAttribute("vnegativeTitle", vnegativeTitle);
                        request.setAttribute("vnegativeDate", vnegativeDate);
                        request.setAttribute("vnegativeSource", vnegativeSource);
                        //request.setAttribute("numVnegNews",numVnegNews);
                    } else {
                        request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", nval);
                        request.setAttribute("vnegativeTitle", nval);
                        request.setAttribute("vnegativeDate", nval);
                        request.setAttribute("vnegativeSource", nval);
                        //    request.setAttribute("numVnegNews",0);
                    }


                    List<String> vpositiveNews = totalList.get(4);
                    List<String> vpositiveTitle = totalList.get(9);
                    List<String> vpositiveDate = totalList.get(14);
                    List<String> vpositiveSource = totalList.get(20);
                    //int numVposNews = vpositiveNews.size();
                    if (!vpositiveNews.isEmpty()) {
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", vpositiveNews);
                        request.setAttribute("vpositiveTitle", vpositiveTitle);
                        request.setAttribute("vpositiveDate", vpositiveDate);
                        request.setAttribute("vpositiveSource", vpositiveSource);
                        //    request.setAttribute("numVposNews",numVposNews);
                    } else {
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", nval);
                        request.setAttribute("vpositiveTitle", nval);
                        request.setAttribute("vpositiveDate", nval);
                        request.setAttribute("vpositiveSource", nval);
                        //    request.setAttribute("numVposNews",0);
                    }

                    List<String> dates = totalList.get(15);
                    request.setAttribute("dates",dates);
                    request.setAttribute("dateInvalidation",dates);
                    request.setAttribute("dropdown",dates);
                    request.setAttribute("fromSearch","notpresent");



                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("value", "Sorry! Results could not be retrieved at this time");
                }

            }
            else{
                request.setAttribute("dateInvalidation",null);
            }
            String frame = request.getParameter("frame");
//            System.out.println("frame: "+frame);
            if(frame!=null) {
                request.getRequestDispatcher("/mainpageForFrame.jsp").forward(request, response);
            }else{
                request.getRequestDispatcher("/mainpageForCombined.jsp").forward(request, response);
            }

        }
        else if(store.equals("search1")){
//            System.out.println("hereSearch1");
            String from = request.getParameter("from");
            String to = request.getParameter("to");
            String keyword = request.getParameter("keyword");
            String keyword2 = request.getParameter("search1");
            String tableName = "CA_NEWS_ARCH";
            List<List<String>> totalList = new ArrayList<List<String>>();
            List<List<String>> totalList2 = new ArrayList<List<String>>();
            List<List<List<String>>> wholeList = new ArrayList<List<List<String>>>();
            CrawlingNewsFromDB crawlingNewsFromDB = new CrawlingNewsFromDB();
            ArrayList nval = new ArrayList();
            nval.add("NoValue");
            List<String> rad = new ArrayList<String>();
            rad.add(request.getParameter("rad"));
//            System.out.println("radddd:"+rad);
            if(rad.get(0) != null){
                if(rad.get(0).equals("daily")){
//                    System.out.println("radddd:"+rad);
                    request.setAttribute("view",rad);
                }
                else if(rad.get(0).equals("weekly")){
                    request.setAttribute("view",rad);
                }
                else if(rad.get(0).equals("monthly")){
                    request.setAttribute("view",rad);
                }

            }


            String dateInvalid = request.getParameter("dateInvalid");
//            System.out.println("dateInvalid:"+dateInvalid);
            if(dateInvalid.equals("val")) {

                try {

                    wholeList = crawlingNewsFromDB.getAllNewsForDate(tableName, from,to,keyword,keyword2);
                    totalList = wholeList.get(0);
                    totalList2 = wholeList.get(1);
                    List<String> positiveNews = totalList.get(0);
                    List<String> positiveTitle = totalList.get(5);
                    List<String> positiveDate = totalList.get(10);
                    List<String> positiveSource = totalList.get(16);
                    //int numPosNews = positiveNews.size();
                    if (!positiveNews.isEmpty()) {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", positiveNews);
                        request.setAttribute("positiveTitle", positiveTitle);
                        request.setAttribute("positiveDate", positiveDate);
                        request.setAttribute("positiveSource", positiveSource);
                        //    request.setAttribute("numPosNews",numPosNews);
                    } else {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", nval);
                        request.setAttribute("positiveTitle", nval);
                        request.setAttribute("positiveDate", nval);
                        request.setAttribute("positiveSource", nval);
                        //    request.setAttribute("numPosNews",0);
                    }
                    List<String> negativeNews = totalList.get(1);
                    List<String> negativeTitle = totalList.get(6);
                    List<String> negativeDate = totalList.get(11);
                    List<String> negativeSource = totalList.get(17);
                    //int numNegNews = negativeNews.size();
                    if (!negativeNews.isEmpty()) {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", negativeNews);
                        request.setAttribute("negativeTitle", negativeTitle);
                        request.setAttribute("negativeDate", negativeDate);
                        request.setAttribute("negativeSource", negativeSource);
                        //    request.setAttribute("numNegNews",numNegNews);
                    } else {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", nval);
                        request.setAttribute("negativeTitle", nval);
                        request.setAttribute("negativeDate", nval);
                        request.setAttribute("negativeSource", negativeSource);
                        //   request.setAttribute("numNegNews",0);
                    }
                    List<String> neutralNews = totalList.get(2);
                    List<String> neutralTitle = totalList.get(7);
                    List<String> neutralDate = totalList.get(12);
                    List<String> neutralSource = totalList.get(18);
                    //int numNeutNews = neutralNews.size();
                    if (!neutralNews.isEmpty()) {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", neutralNews);
                        request.setAttribute("neutralTitle", neutralTitle);
                        request.setAttribute("neutralDate", neutralDate);
                        request.setAttribute("neutralSource", neutralSource);
                        //   request.setAttribute("numNeutNews",numNeutNews);
                    } else {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", nval);
                        request.setAttribute("neutralTitle", nval);
                        request.setAttribute("neutralDate", nval);
                        request.setAttribute("neutralSource", nval);
                        //   request.setAttribute("numNeutNews",0);
                    }


                    List<String> vnegativeNews = totalList.get(3);
                    List<String> vnegativeTitle = totalList.get(8);
                    List<String> vnegativeDate = totalList.get(13);
                    List<String> vnegativeSource = totalList.get(19);
                    //  int numVnegNews = vnegativeNews.size();
                    if (!vnegativeNews.isEmpty()) {
                        request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", vnegativeNews);
                        request.setAttribute("vnegativeTitle", vnegativeTitle);
                        request.setAttribute("vnegativeDate", vnegativeDate);
                        request.setAttribute("vnegativeSource", vnegativeSource);
                        //request.setAttribute("numVnegNews",numVnegNews);
                    } else {
                        request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", nval);
                        request.setAttribute("vnegativeTitle", nval);
                        request.setAttribute("vnegativeDate", nval);
                        request.setAttribute("vnegativeSource", nval);
                        //    request.setAttribute("numVnegNews",0);
                    }


                    List<String> vpositiveNews = totalList.get(4);
                    List<String> vpositiveTitle = totalList.get(9);
                    List<String> vpositiveDate = totalList.get(14);
                    List<String> vpositiveSource = totalList.get(20);
                    //int numVposNews = vpositiveNews.size();
                    if (!vpositiveNews.isEmpty()) {
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", vpositiveNews);
                        request.setAttribute("vpositiveTitle", vpositiveTitle);
                        request.setAttribute("vpositiveDate", vpositiveDate);
                        request.setAttribute("vpositiveSource", vpositiveSource);
                        //    request.setAttribute("numVposNews",numVposNews);
                    } else {
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", nval);
                        request.setAttribute("vpositiveTitle", nval);
                        request.setAttribute("vpositiveDate", nval);
                        request.setAttribute("vpositiveSource", nval);
                        //    request.setAttribute("numVposNews",0);
                    }

                    /*
                     *search for second keyword --this is not generalized for time being.  (Less time)
                     * More robust code has to implemented later
                     */
                    List<String> positiveNews2 = totalList2.get(0);
                    List<String> positiveTitle2 = totalList2.get(5);
                    List<String> positiveDate2 = totalList2.get(10);
                    List<String> positiveSource2 = totalList2.get(16);
                    //int numPosNews = positiveNews.size();
                    if (!positiveNews2.isEmpty()) {
                        request.setAttribute("positive2", "POSITIVE");
                        request.setAttribute("positiveNews2", positiveNews2);
                        request.setAttribute("positiveTitle2", positiveTitle2);
                        request.setAttribute("positiveDate2", positiveDate2);
                        request.setAttribute("positiveSource2", positiveSource2);
                        //    request.setAttribute("numPosNews",numPosNews);
                    } else {
                        request.setAttribute("positive2", "POSITIVE");
                        request.setAttribute("positiveNews2", nval);
                        request.setAttribute("positiveTitle2", nval);
                        request.setAttribute("positiveDate2", nval);
                        request.setAttribute("positiveSource2", nval);
                        //    request.setAttribute("numPosNews",0);
                    }
                    List<String> negativeNews2 = totalList2.get(1);
                    List<String> negativeTitle2 = totalList2.get(6);
                    List<String> negativeDate2 = totalList2.get(11);
                    List<String> negativeSource2 = totalList2.get(17);
                    //int numNegNews = negativeNews.size();
                    if (!negativeNews2.isEmpty()) {
                        request.setAttribute("negative2", "NEGATIVE");
                        request.setAttribute("negativeNews2", negativeNews2);
                        request.setAttribute("negativeTitle2", negativeTitle2);
                        request.setAttribute("negativeDate2", negativeDate2);
                        request.setAttribute("negativeSource2", negativeSource2);
                        //    request.setAttribute("numNegNews",numNegNews);
                    } else {
                        request.setAttribute("negative2", "NEGATIVE");
                        request.setAttribute("negativeNews2", nval);
                        request.setAttribute("negativeTitle2", nval);
                        request.setAttribute("negativeDate2", nval);
                        request.setAttribute("negativeSource2", nval);
                        //   request.setAttribute("numNegNews",0);
                    }
                    List<String> neutralNews2 = totalList2.get(2);
                    List<String> neutralTitle2 = totalList2.get(7);
                    List<String> neutralDate2 = totalList2.get(12);
                    List<String> neutralSource2 = totalList2.get(18);
                    //int numNeutNews = neutralNews.size();
                    if (!neutralNews2.isEmpty()) {
                        request.setAttribute("neutral2", "NEUTRAL");
                        request.setAttribute("neutralNews2", neutralNews2);
                        request.setAttribute("neutralTitle2", neutralTitle2);
                        request.setAttribute("neutralDate2", neutralDate2);
                        request.setAttribute("neutralSource2", neutralSource2);
                        //   request.setAttribute("numNeutNews",numNeutNews);
                    } else {
                        request.setAttribute("neutral2", "NEUTRAL");
                        request.setAttribute("neutralNews2", nval);
                        request.setAttribute("neutralTitle2", nval);
                        request.setAttribute("neutralDate2", nval);
                        request.setAttribute("neutralSource2", nval);
                        //   request.setAttribute("numNeutNews",0);
                    }


                    List<String> vnegativeNews2 = totalList2.get(3);
                    List<String> vnegativeTitle2 = totalList2.get(8);
                    List<String> vnegativeDate2 = totalList2.get(13);
                    List<String> vnegativeSource2 = totalList2.get(19);
                    //  int numVnegNews = vnegativeNews.size();
                    if (!vnegativeNews2.isEmpty()) {
                        request.setAttribute("vnegative2", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews2", vnegativeNews2);
                        request.setAttribute("vnegativeTitle2", vnegativeTitle2);
                        request.setAttribute("vnegativeDate2", vnegativeDate2);
                        request.setAttribute("vnegativeSource2", vnegativeSource2);
                        //request.setAttribute("numVnegNews",numVnegNews);
                    } else {
                        request.setAttribute("vnegative2", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews2", nval);
                        request.setAttribute("vnegativeTitle2", nval);
                        request.setAttribute("vnegativeDate2", nval);
                        request.setAttribute("vnegativeSource2", nval);
                        //    request.setAttribute("numVnegNews",0);
                    }


                    List<String> vpositiveNews2 = totalList2.get(4);
                    List<String> vpositiveTitle2 = totalList2.get(9);
                    List<String> vpositiveDate2 = totalList2.get(14);
                    List<String> vpositiveSource2 = totalList2.get(20);
                    //int numVposNews = vpositiveNews.size();
                    if (!vpositiveNews2.isEmpty()) {
                        request.setAttribute("vpositive2", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews2", vpositiveNews2);
                        request.setAttribute("vpositiveTitle2", vpositiveTitle2);
                        request.setAttribute("vpositiveDate2", vpositiveDate2);
                        request.setAttribute("vpositiveSource2", vpositiveSource2);
                        //    request.setAttribute("numVposNews",numVposNews);
                    } else {
                        request.setAttribute("vpositive2", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews2", nval);
                        request.setAttribute("vpositiveTitle2", nval);
                        request.setAttribute("vpositiveDate2", nval);
                        request.setAttribute("vpositiveSource2", nval);
                        //    request.setAttribute("numVposNews",0);
                    }

                    List<String> dates = totalList.get(15);
                    request.setAttribute("dates",dates);
                    request.setAttribute("dateInvalidation",dates);
                    request.setAttribute("dropdown",dates);
                    request.setAttribute("fromSearch","present");



                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("value", "Sorry! Results could not be retrieved at this time");
                }

            }
            else{
                request.setAttribute("dateInvalidation",null);
            }
            String frame = request.getParameter("frame");
//            System.out.println("frame: "+frame);
            if(frame!=null) {
                request.getRequestDispatcher("/mainpageForFrame.jsp").forward(request, response);
            }else{
                request.getRequestDispatcher("/mainpageForCombined.jsp").forward(request, response);
            }

        }
        else {

            String from = request.getParameter("from");
            String to = request.getParameter("to");
            String tableName = "CA_NEWS_ARCH";
            List<List<String>> totalList = new ArrayList<List<String>>();
            CrawlingNewsFromDB crawlingNewsFromDB = new CrawlingNewsFromDB();
            ArrayList nval = new ArrayList();
            nval.add("NoValue");
            List<String> rad = new ArrayList<String>();
            rad.add(request.getParameter("rad"));
//            System.out.println("radddd:"+rad);
            if(rad.get(0) != null){
              if(rad.get(0).equals("daily")){
//                  System.out.println("radddd:"+rad);
                  request.setAttribute("view",rad);
              }
              else if(rad.get(0).equals("weekly")){
                    request.setAttribute("view",rad);
              }
              else if(rad.get(0).equals("monthly")){
                  request.setAttribute("view",rad);
              }

            }


            String dateInvalid = request.getParameter("dateInvalid");
//            System.out.println("dateInvalid:"+dateInvalid);
            if(dateInvalid.equals("val")) {

                try {

                    totalList = crawlingNewsFromDB.getAllNewsForDate(tableName, from, to);
                    List<String> positiveNews = totalList.get(0);
                    List<String> positiveTitle = totalList.get(5);
                    List<String> positiveDate = totalList.get(10);
                    List<String> positiveSource = totalList.get(16);
                    List<String> positiveOpinion = totalList.get(21);
                    //int numPosNews = positiveNews.size();
                    if (!positiveNews.isEmpty()) {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", positiveNews);
                        request.setAttribute("positiveTitle", positiveTitle);
                        request.setAttribute("positiveDate", positiveDate);
                        request.setAttribute("positiveSource",positiveSource);
                        request.setAttribute("positiveOpinion",positiveOpinion);
                        //    request.setAttribute("numPosNews",numPosNews);
                    } else {
                        request.setAttribute("positive", "POSITIVE");
                        request.setAttribute("positiveNews", nval);
                        request.setAttribute("positiveTitle", nval);
                        request.setAttribute("positiveDate", nval);
                        request.setAttribute("positiveSource",nval);
                        request.setAttribute("positiveOpinion",nval);
                        //    request.setAttribute("numPosNews",0);
                    }
                    List<String> negativeNews = totalList.get(1);
                    List<String> negativeTitle = totalList.get(6);
                    List<String> negativeDate = totalList.get(11);
                    List<String> negativeSource = totalList.get(17);
                    List<String> negativeOpinion = totalList.get(22);
                    //int numNegNews = negativeNews.size();
                    if (!negativeNews.isEmpty()) {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", negativeNews);
                        request.setAttribute("negativeTitle", negativeTitle);
                        request.setAttribute("negativeDate", negativeDate);
                        request.setAttribute("negativeSource",negativeSource);
                        request.setAttribute("negativeOpinion",negativeOpinion);
                        //    request.setAttribute("numNegNews",numNegNews);
                    } else {
                        request.setAttribute("negative", "NEGATIVE");
                        request.setAttribute("negativeNews", nval);
                        request.setAttribute("negativeTitle", nval);
                        request.setAttribute("negativeDate", nval);
                        request.setAttribute("negativeSource",nval);
                        request.setAttribute("negativeOpinion",nval);
                        //   request.setAttribute("numNegNews",0);
                    }
                    List<String> neutralNews = totalList.get(2);
                    List<String> neutralTitle = totalList.get(7);
                    List<String> neutralDate = totalList.get(12);
                    List<String> neutralSource = totalList.get(18);
                    List<String> neutralOpinion = totalList.get(23);
                    //int numNeutNews = neutralNews.size();
                    if (!neutralNews.isEmpty()) {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", neutralNews);
                        request.setAttribute("neutralTitle", neutralTitle);
                        request.setAttribute("neutralDate", neutralDate);
                        request.setAttribute("neutralSource",neutralSource);
                        request.setAttribute("neutralOpinion",neutralOpinion);
                        //   request.setAttribute("numNeutNews",numNeutNews);
                    } else {
                        request.setAttribute("neutral", "NEUTRAL");
                        request.setAttribute("neutralNews", nval);
                        request.setAttribute("neutralTitle", nval);
                        request.setAttribute("neutralDate", nval);
                        request.setAttribute("neutralSource",nval);
                        request.setAttribute("neutralOpinion",nval);
                        //   request.setAttribute("numNeutNews",0);
                    }


                    List<String> vnegativeNews = totalList.get(3);
                    List<String> vnegativeTitle = totalList.get(8);
                    List<String> vnegativeDate = totalList.get(13);
                    List<String> vnegativeSource = totalList.get(19);
                    List<String> vnegativeOpinion = totalList.get(24);
                    //  int numVnegNews = vnegativeNews.size();
                    if (!vnegativeNews.isEmpty()) {
                        request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", vnegativeNews);
                        request.setAttribute("vnegativeTitle", vnegativeTitle);
                        request.setAttribute("vnegativeDate", vnegativeDate);
                        request.setAttribute("vnegativeSource",vnegativeSource);
                        request.setAttribute("vnegativeOpinion",vnegativeOpinion);
                        //request.setAttribute("numVnegNews",numVnegNews);
                    } else {
                        request.setAttribute("vnegative", "VERY NEGATIVE");
                        request.setAttribute("vnegativeNews", nval);
                        request.setAttribute("vnegativeTitle", nval);
                        request.setAttribute("vnegativeDate", nval);
                        request.setAttribute("vnegativeSource",nval);
                        request.setAttribute("vnegativeOpinion",nval);
                        //    request.setAttribute("numVnegNews",0);
                    }


                    List<String> vpositiveNews = totalList.get(4);
                    List<String> vpositiveTitle = totalList.get(9);
                    List<String> vpositiveDate = totalList.get(14);
                    List<String> vpositiveSource = totalList.get(20);
                    List<String> vpositiveOpinion = totalList.get(25);
                    //int numVposNews = vpositiveNews.size();
                    if (!vpositiveNews.isEmpty()) {
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", vpositiveNews);
                        request.setAttribute("vpositiveTitle", vpositiveTitle);
                        request.setAttribute("vpositiveDate", vpositiveDate);
                        request.setAttribute("vpositiveSource", vpositiveSource);
                        request.setAttribute("vpositiveOpinion", vpositiveOpinion);
                        //    request.setAttribute("numVposNews",numVposNews);
                    } else {
                        request.setAttribute("vpositive", "VERY POSITIVE");
                        request.setAttribute("vpositiveNews", nval);
                        request.setAttribute("vpositiveTitle", nval);
                        request.setAttribute("vpositiveDate", nval);
                        request.setAttribute("vpositiveSource", nval);
                        request.setAttribute("vpositiveOpinion", nval);
                        //    request.setAttribute("numVposNews",0);
                    }



                    List<String> dates = totalList.get(15);
                    request.setAttribute("dates",dates);
                    request.setAttribute("dateInvalidation",dates);


                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("value", "Sorry! Results could not be retrieved at this time");
                }

            }
            else{
                request.setAttribute("dateInvalidation",null);
            }
            String frame = request.getParameter("frame");
            if(frame!=null) {
                request.getRequestDispatcher("/mainpageForFrame.jsp").forward(request, response);
            }else{
                request.getRequestDispatcher("/mainpageForCombined.jsp").forward(request, response);
            }

        }
    }
	
	 // Redirect POST request to GET request.    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);
    }


}

   

   



