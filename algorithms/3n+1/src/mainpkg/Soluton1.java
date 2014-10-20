package mainpkg;

public class Soluton1 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Soluton1 s = new Soluton1();
		int[] x = {0,2};
		int[] y = {0,4};
		int k = 2;
		int area = s.minArea(x, y, k);
		System.out.println(area);
	}
	int minArea(int x[],int y[], int k){
		int area = 0 ;		
		int xval = 0;
		int xval2 = 0;
		int	yval = 0;
		int side =0;
		int areaComp = 1;
		int minA = 1;
		for(int i=1;i<=k;i++){
			xval = x[1];
			xval2 = x[0];			
			xval = xval+(i-4);
			xval2 = xval2+(i-4);
			
			yval = y[1];
			yval2 = y[0];
			yval = yval+(4-i);
			side = yval - xval;
			area = side*side;			
			if(area <= areaComp){
				minA = area;
			}
			else{
				areaComp = area;
			}		
		}								
		return minA;
	}

}
