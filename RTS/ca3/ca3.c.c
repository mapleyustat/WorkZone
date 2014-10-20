#include <stdio.h>
#include "ca3fw.h"
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

//Framebuffer
VPACKET packetBuff[1000];

//Packet Buffer
VPACKET packets[5];

//DisplayBuffer
FRAME preBuff[1000];

FRAME frame;
int t = 1;

int main ()
{	
	VPACKET pkt;
	int oldFrameID = 1;
	int count = 0;
	int c=0;
	int frmNo=0;
	int dispFrmNo=0;
	int strtPtr=0;
	int step=1;
	int endPtr=0;
	int i;
	int initial = 1;
	
	struct timeval pre, cur;
	time_t initTime, curTime;
	
	selectChannel(1);

	time_t initime,curtime;	
	initime=time(NULL);
	int framePresent=0;
	int strtFrmNo =0;
	int init = 0;
	
	while(t){
		if(isVideoPacketAvailable()==1)
		{
			pkt = getVideoPacket();
			int newFrameID = getFrameID(pkt);
			if( newFrameID == oldFrameID)
			{		
				packets[count] = pkt;
				count=count+1;
			}
			else
			{		
				if(count >=3) 
				{						
					for(c=0;c<4;c++)
					{
						packetBuff[endPtr++]=packets[c];
						endPtr %= 1000;
						if(endPtr >= 1000)
						{
							endPtr = 0;
						}
					}
				framePresent++;	
				}
				count = 0;
				packets[count] = pkt;
				
			}			
			oldFrameID = newFrameID;
		}
	
		//Decoding the frame
		if(framePresent>0)
		{
			if(step==4)
			{
					frame = decodeFrame(&packetBuff[strtPtr],step);
					preBuff[frmNo++]=frame;
					strtFrmNo++;
					frmNo %= 1000;
					step=1;		
					framePresent--;
					strtPtr += 4;
					strtPtr %= 1000;
			}
			else 
			{
					decodeFrame(&packetBuff[strtPtr],step++);
					
			}
			
				
		}
		
		//Displaying the frame 
		if(strtFrmNo>42)
		{	
			gettimeofday(&cur, NULL);
			if(initial > 0) 
			{
					displayFrame(preBuff[dispFrmNo++]);
					gettimeofday(&pre, NULL);
					initial=0;
			}
			else
			{
				double interval = ((cur.tv_sec-pre.tv_sec)*1000000 + cur.tv_usec-pre.tv_usec)/1000.0;
				if(interval >= 41.666) 
				{ 	
						displayFrame(preBuff[dispFrmNo++]);
						gettimeofday(&pre, NULL);
						dispFrmNo %= 1000;
				
				}
			}	
			
		}
		
		//exit loop at 30 s
		curtime=time(NULL);
		if(difftime(curtime, initime) > 30)
		{
			t = 0;		
			break;
		}
	}
	printStats();	
}








