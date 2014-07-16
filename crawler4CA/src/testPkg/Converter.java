package testPkg;

import java.io.IOException;

public class Converter {

	public static void jsonConvWithFormatting() throws IOException {
		// TODO Auto-generated method stub
		int[] fileNo = {1};
		for(int i = 0; i < fileNo.length; i++ )
		{
		XMLtoJsonConverter.getXMLfromJson(fileNo[i]);
		StringFormatting.getPropertyPortalWatchNews(fileNo[i]);
		}
	}

    public static void main(String[] args) throws IOException {
        // TODO Auto-generated method stub
        int[] fileNo = {1};
        for(int i = 0; i < fileNo.length; i++ )
        {
            XMLtoJsonConverter.getXMLfromJson(fileNo[i]);
            StringFormatting.getPropertyPortalWatchNews(fileNo[i]);
        }
    }

}
