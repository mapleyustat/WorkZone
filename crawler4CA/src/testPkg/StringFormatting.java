package testPkg;

import java.io.*;

public class StringFormatting {

	public static void getPropertyPortalWatchNews(int fileNo) throws IOException {
		// TODO Auto-generated method stub
		File f = new File("crawledNews.txt");
		Boolean flag = false;
		if(f.exists()){
			f.delete();
			flag = true;
			System.out.println("flag : "+flag);
		}
		else{
			System.out.println("File not found to delete");
		}
		BufferedWriter bw = new BufferedWriter(new FileWriter("crawledNews.txt"));
		BufferedReader br = new BufferedReader(new FileReader ("jsonFile"+fileNo+".txt"));
		String oldTemp = "";
		String news = "";
		String s = "";
		String check = "";
		boolean inside = false;
		   while (br.ready()) {
			   check = br.readLine();
			   if(check.contains("                                                p :"))
			   {
				   oldTemp = check;
			   }
			   if(check.contains("                                                ["))
			   {
				   if(oldTemp.equals("                                                p :"))
				   	{
				   		inside = true;
				   	}   
				   oldTemp = "";
			   }			   
			   if(inside == true)
			   {
				   if(check.contains("                                                ]"))
				   {
					   if(news.contains("                                                            \", \"") || news.contains("                                                    }") || news.contains("                                                        \".\""))
					   {
						   //do nothing
					   }
					   else
					   {
                           if(news.contains("                                                    \"")){
                               news = news.replace("                                                    \"", "");
                               news = news.replace("\"", "");
                           }
                           news = news +"\n";
						   bw.write(news);
						   s += news + "\n";
						   inside = false;
					   }
				   }
				   news = check;
				   
			   }
			   //s += br.readLine() + "\n";
		   }
		bw.close();   
		br.close();
		System.out.println(s);
		//return s;

		File ftitle = new File("crawledNewsTitle.txt");
		Boolean flagTitle = false;
		if(ftitle.exists()){
			ftitle.delete();
			flagTitle = true;
			System.out.println("flag : "+flagTitle);
		}
		else{
			System.out.println("File not found to delete");
		}
		//Parsing JSON for title
		BufferedReader brtitle = new BufferedReader(new FileReader ("jsonFile"+fileNo+".txt"));
		BufferedWriter bwtitle = new BufferedWriter(new FileWriter("crawledNewsTitle.txt"));
		String line = "";
		String newsTitle = "";
		String dupline="";
		int count=0;
		boolean titleTag = false;
		boolean confirmInside = false;
		boolean nxtIsVal = false;
		while(brtitle.ready()){
			line = brtitle.readLine();
			if(titleTag==true){
				if(confirmInside == true){
					if(nxtIsVal==true){
						
						dupline = line;
						if(dupline.contains("                                                        \"")){
							dupline = dupline.replace("                                                        \"", "");
							dupline = dupline.replace("\"", "");
						}
                        dupline = dupline+"." +"\n";
						bwtitle.write(dupline);
						newsTitle += dupline+"\n";
						titleTag = false;
						nxtIsVal = false;
						confirmInside = false;
						count=0;
					}
					if(line.contains("                                                        #text :")){
						nxtIsVal = true;
					}
				}
				if(line.contains("                                                    a :") && count==2){
					confirmInside = true;
					count=0;
				}
				count++;
			}
			if(line.contains("                                                h3 :")){
				titleTag = true;
				count = 1;
			}
			
		}
		brtitle.close();
		bwtitle.close();
		System.out.println(newsTitle);
	}
    public static void getIPropertyNews(int fileNo) throws IOException {

        String[] fileName = {"newsLink2","newsTitle2","newsDate2"};
        for(int i=0;i<3;i++) {
            File f = new File(fileName[i]+".txt");
            Boolean flag = false;
            if (f.exists()) {
                f.delete();
                flag = true;
                System.out.println("flag : " + flag);
            } else {
                System.out.println("File not found to delete");
            }
        }
        BufferedWriter bwL = new BufferedWriter(new FileWriter("newsLink2.txt"));
        BufferedWriter bwT = new BufferedWriter(new FileWriter("newsTitle2.txt"));
        BufferedWriter bwD = new BufferedWriter(new FileWriter("newsDate2.txt"));
        BufferedReader br = new BufferedReader(new FileReader ("jsonFile"+fileNo+".txt"));
        String temp1 = "";
        String temp2 = "";
        String temp3 = "";
        String temp4= "";
        String temp5= "";
        String link = "";
        String title = "";
        String date = "";
        String check = "";
        int first = 1;
        boolean wantedText = false;
        boolean wantedTextTitle = false;
        boolean wantedTextDate = false;
        boolean inside=false;
        while (br.ready()) {
            check = br.readLine();
            if(inside){

                if(wantedText){
                    if(link.equals("")){
                        check = check.replace("                                                            \"","");
                        check = check.replace("\"", "");
                        bwL.write("http://iproperty.com.sg"+check);
                        link="not empty";
                    }
                    else{
                        check = check.replace("                                                            \"","");
                        check = check.replace("\"", "");
                        bwL.write("\n"+"http://iproperty.com.sg"+check);
                    }
                    wantedText = false;
                }
                if(wantedTextTitle){
                    if(title.equals("")) {
                        check =check.replaceFirst("                                                            ","");
                        check = check.replaceFirst("\"  ", "");
                        check = check.replaceFirst("\" ", "");
                        check = check.replaceFirst(" \"", "");
                        check = check.replaceFirst("  \"", "");
                        check = check.replace("\"", "");
                        check=check.replace(".",",");
                        bwT.write(check +".");
                        wantedTextTitle = false;
                        title = "not empty";
                    }
                    else {

                        check =check.replaceFirst("                                                            ","");
                        check = check.replaceFirst("\"  ", "");
                        check = check.replaceFirst("\" ", "");
                        check = check.replaceFirst(" \"", "");
                        check = check.replaceFirst("  \"", "");
                        check = check.replace("\"", "");
                        check=check.replace(".",",");
                        bwT.write("\n" + check +".");
                        wantedTextTitle = false;
                    }
                }
                if(wantedTextDate){
                    if(date.equals("")){
                        check = check.replace("                                                            \"","");
                        check = check.replace("\"", "");
                        bwD.write(check);
                        wantedTextDate=false;
                        date = "not empty";
                    }
                    else{
                        check = check.replace("                                                            \"","");
                        check = check.replace("\"", "");
                        bwD.write("\n"+check);
                        wantedTextDate=false;
                    }
                }
                if(check.contains("                                                            @href :")){
                    //val = check;
                    wantedText = true ;
                }
                if(check.contains("                                                            #text :")){
                    wantedTextTitle=true;
                }
                if(check.contains("                                                            i :")){
                    wantedTextDate = true;
                }


            }
            else {
                if(first==1){
                    if(check.contains("                                            div :")) {
                        temp1 = check;
                        first++;
                    }
                }
                else {
                    if(temp1.contains("                                            div :")){
                        if(check.equals("                                            [")){
                            temp2 = check;
                            temp1="";
                        }
                        else{
                            first=1;
                        }
                    }
                    else if(temp2.equals("                                            [")){
                        if(check.equals("                                                [")){
                            temp3 = check;
                            temp2="";
                        }
                        else{
                            first=1;
                        }
                    }
                    else if(temp3.equals("                                                [")){
                        if(check.contains("                                                    {")){
                            temp4 = check;
                            temp3="";
                        }
                        else{
                            first=1;
                        }
                    }
                    else if(temp4.contains("                                                    {")){
                        if(check.contains("                                                        a :")){
                            temp5 = check;
                            temp4="";
                        }
                        else{
                            first=1;
                        }
                    }
                    else if(temp5.equals("                                                        a :")){
                        inside =true;
                    }
                }
            }




            //s += br.readLine() + "\n";
        }
        bwL.close();
        bwT.close();
        bwD.close();
        br.close();
        //System.out.println(news);
        //return s;

//        File ftitle = new File("crawledNewsTitle.txt");
//        Boolean flagTitle = false;
//        if(ftitle.exists()){
//            ftitle.delete();
//            flagTitle = true;
//            System.out.println("flag : "+flagTitle);
//        }
//        else{
//            System.out.println("File not found to delete");
//        }
//        //Parsing JSON for title
//        BufferedReader brtitle = new BufferedReader(new FileReader ("jsonFile"+fileNo+".txt"));
//        BufferedWriter bwtitle = new BufferedWriter(new FileWriter("crawledNewsTitle.txt"));
//        String line = "";
//        String newsTitle = "";
//        String dupline="";
//        int count=0;
//        boolean titleTag = false;
//        boolean confirmInside = false;
//        boolean nxtIsVal = false;
//        while(brtitle.ready()){
//            line = brtitle.readLine();
//            if(titleTag==true){
//                if(confirmInside == true){
//                    if(nxtIsVal==true){
//
//                        dupline = line;
//                        if(dupline.contains("                                                        \"")){
//                            dupline = dupline.replace("                                                        \"", "");
//                            dupline = dupline.replace("\"", "");
//                        }
//                        dupline = dupline+"." +"\n";
//                        bwtitle.write(dupline);
//                        newsTitle += dupline+"\n";
//                        titleTag = false;
//                        nxtIsVal = false;
//                        confirmInside = false;
//                        count=0;
//                    }
//                    if(line.contains("                                                        #text :")){
//                        nxtIsVal = true;
//                    }
//                }
//                if(line.contains("                                                    a :") && count==2){
//                    confirmInside = true;
//                    count=0;
//                }
//                count++;
//            }
//            if(line.contains("                                                h3 :")){
//                titleTag = true;
//                count = 1;
//            }
//
//        }
//        brtitle.close();
//        bwtitle.close();
//        System.out.println(newsTitle);
    }
    public static void getpropertyGuruNews(int fileNo) throws IOException {
        String[] fileName = {"newsLink2","newsTitle2","newsDate2"};
        for(int i=0;i<3;i++) {
            File f = new File(fileName[i]+".txt");
            Boolean flag = false;
            if (f.exists()) {
                f.delete();
                flag = true;
                System.out.println("flag : " + flag);
            } else {
                System.out.println("File not found to delete");
            }
        }
        BufferedWriter bwL = new BufferedWriter(new FileWriter("newsLink2.txt"));
        BufferedWriter bwT = new BufferedWriter(new FileWriter("newsTitle2.txt"));
        BufferedWriter bwD = new BufferedWriter(new FileWriter("newsDate2.txt"));
        BufferedReader br = new BufferedReader(new FileReader ("jsonFile"+fileNo+".txt"));

        String currLine = "";
        String temp1 = "";
        int temp = 1;
        Boolean inside = true;
        Boolean nextLineIsLink= false;
        Boolean nextLineIsText= false;
        Boolean nextLineIsDate = false;

        while(br.ready()){
            currLine = br.readLine();
            if(inside){
                if(nextLineIsLink){
                    currLine = currLine.replace("                                    \"","");
                    currLine = currLine.replace("\"","");
                    bwL.write("http://www.propertyguru.com.sg"+currLine+"\n");
                    nextLineIsLink = false;
                }
                else if(nextLineIsText){
                    currLine = currLine.replace("                                    \"","");
                    currLine = currLine.replace("\"","");
                    bwT.write(currLine+"."+"\n");
                    nextLineIsText = false;
                }
                else if(nextLineIsDate){
                    currLine = currLine.replace(" - PropertyGuru.com.sg \t\"", "");
                    currLine = currLine.replace("\t","");
                    currLine = currLine.replace("\"", "");
                    bwD.write(currLine+"\n");
                    nextLineIsDate = false;
                }
                else if(currLine.equals("                                    @href :")){
                    nextLineIsLink = true;
                }
                else if(currLine.equals("                                    #text :")){
                    nextLineIsText = true;
                }
                else if(currLine.equals("\t")){
                    nextLineIsDate = true;
                }
            }
//            else {
//                if(currLine.equals("                                a :")){
//                    temp1 = currLine;
//                }
//                else if(currLine.equals("                                {")){
//                    if(temp1.equals("                                a :")){
//                        inside = true;
//                    }
//                }
//            }
        }
        br.close();
        bwD.close();
        bwL.close();
        bwT.close();
    }

    public static void propertyWire(int fileNo) throws IOException {
        String[] fileName = {"newsLink2","newsTitle2","newsDate2"};
        for(int i=0;i<3;i++) {
            File f = new File(fileName[i]+".txt");
            Boolean flag = false;
            if (f.exists()) {
                f.delete();
                flag = true;
                System.out.println("flag : " + flag);
            } else {
                System.out.println("File not found to delete");
            }
        }
        BufferedWriter bwL = new BufferedWriter(new FileWriter("newsLink2.txt"));
        BufferedWriter bwT = new BufferedWriter(new FileWriter("newsTitle2.txt"));
        BufferedWriter bwD = new BufferedWriter(new FileWriter("newsDate2.txt"));
        BufferedReader br = new BufferedReader(new FileReader ("jsonFile"+fileNo+".txt"));

        String currLine = "";
        String temp1 = "";
        int temp = 1;
        Boolean inside = true;
        Boolean nextLineIsLink= false;
        Boolean nextLineIsText= false;
        Boolean nextLineIsDate = false;

        while(br.ready()){
            currLine = br.readLine();
            if(currLine.equals("                                                                                        @href :")&&temp==1){
                nextLineIsLink = true;
            }
            else if(nextLineIsLink){
                bwL.write(currLine+"\n");
                nextLineIsLink=false;
            }
            else if(currLine.equals("                                                                                        #text :")&&temp==1){
                temp1=currLine;
            }
            else if(temp1.equals("                                                                                        \"")&&temp==1){
                nextLineIsText= true;
            }
            else if(nextLineIsText){
                bwT.write(currLine+"\n");
                nextLineIsText=false;
                temp=2;
            }
            else if(currLine.contains("\t\t\t\t\"")){
                bwD.write(currLine);
            }
            else{

            }

        }
        br.close();
        bwD.close();
        bwL.close();
        bwT.close();
    }

	public static void main(String[] args) throws IOException{
        getpropertyGuruNews(1);

	}
}

