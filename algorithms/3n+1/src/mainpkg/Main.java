/**
 * 
 */
package mainpkg;

/**
 * @author Vignesh Prakasam
 *
 */
public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub		
		int n1=900;
		int n2 = 1000;
		int val = 0;
		int temp = 0;
		int count = 0;
		int checkVarNew = 0;
		int checkVarOld = 0;
		System.out.print(n1);
		for(;n1<=n2;n1++){			
			val = n1;
			count=0;
			//System.out.println("\n"+n1);
			while(val!=1){
				if(val%2 == 1){
					val = (val*3)+1;
				}
				else{
					val = val/2;
				}
				count++;				
				//System.out.println(val);
			}
			checkVarNew = count+1;
			if(checkVarNew>=checkVarOld){				
				checkVarOld = checkVarNew;
			}			
		}
		System.out.print(" "+n2+" "+ checkVarOld);
	}
}
