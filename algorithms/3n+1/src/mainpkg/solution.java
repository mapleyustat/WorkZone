package mainpkg;

import java.util.ArrayList;
import java.util.List;

public class solution {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		solution s = new solution();
		s.countHoles(1980);		

	}
	
	static int countHoles(int num){		
		List holes1 = new ArrayList();
		holes1.add(0);
		holes1.add(4);
		holes1.add(6);
		holes1.add(9);
		List holes2 = new ArrayList();
		holes2.add(8);
		int count = 0;
		int c;
		while(num/10!=0){		
		  c = num%10;
		  num = num/10;		  		  
		  if(holes1.contains(c)){
			  count = count+1;			  			 
		  }
		  else if(holes2.contains(c)){
			  count = count+2;			  
		  }
		  else{
			  //do nothing
		  }		  
		}
		 if(holes1.contains(num)){
			count = count+1;
		  }
		  else if(holes2.contains(num)){
			  count = count+2;
		  }
		System.out.println(count);	
		return count;

	}

}
