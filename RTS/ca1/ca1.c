#include <stdio.h>
#include "/home/vignesh/Documents/ca1/ca1fw.h"
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <sys/types.h>
#include <sys/timeb.h>
#include <sys/ipc.h>
#include <time.h>
#include <sys/timeb.h>
#include <string.h>
#include <signal.h>
#include <sys/time.h>
#include <errno.h>

//Frame Buffer
struct frameBuf {
 long int msgType;
 VPACKET packets[5];
 int msg_num;
};

//Display Buffer
struct DispBuf {
 long int msgType;
 FRAME fr;
};

//Queues
key_t key2;
key_t key1;

int to_decoder_que;
int dispQid;
int t = 1;

//Signal Handler
void sigintHandler(){		
	t = 0;
}

//Timer Handler
void sigtimerhandler(int param) {
	struct DispBuf frameToBeDisplayed;
	int disp = msgrcv(dispQid,&frameToBeDisplayed,(sizeof(struct DispBuf)-sizeof(long int)),3,IPC_NOWAIT);
	if(disp!=-1){
	displayFrame(frameToBeDisplayed.fr);} //displaying
}

//Decoding Thread
void *decoding_thread_mth(void *decoding_thread_mth)
{	
	struct frameBuf frameToBeDecoded;
	struct DispBuf frameSentToDisplay;	
	VPACKET tstpkt;
	int frID,i;
	while(t){
	int msgRcv = msgrcv(to_decoder_que,&frameToBeDecoded,(sizeof(struct frameBuf) - sizeof(long int)),2,IPC_NOWAIT);
	if(msgRcv != -1)
	{
		frameSentToDisplay.msgType = 3;
		frameSentToDisplay.fr = decodeFrame(frameToBeDecoded.packets);	//Decoding
		int Dispsnd = msgsnd(dispQid,&frameSentToDisplay,(sizeof(struct DispBuf)-sizeof(long int)),IPC_NOWAIT); //Displaying Queue
	}
	}
	
}

int main ()
{	
	VPACKET pkt;
	int oldFrameID = 1;

	//Signal Interupt Handler
	signal(SIGINT,sigintHandler);
	
	
	//Queues
	key2 = ftok("./ca1.c",2);
	to_decoder_que = msgget(key2,IPC_CREAT|0666);
	key1 = ftok("./ca1.c",3);
	dispQid = msgget(key1,IPC_CREAT|0666);
	
	struct frameBuf frameSentToDecoder;
	int result;
	int count = 0;
	selectChannel(1);

	//Timer Intialization
	struct itimerval it_val;
	it_val.it_value.tv_sec =     0; 
  	it_val.it_value.tv_usec =    42000;    
  	it_val.it_interval = it_val.it_value;
	
  	//Threading
	pthread_t decoding_thread;
	pthread_create(&decoding_thread,NULL,&decoding_thread_mth,NULL);
	
	//Time for Exit
	time_t initime,curtime;	
	initime=time(NULL);

	//setitimer
	if (setitimer(ITIMER_REAL, &it_val, NULL) == -1) {
    		printf("error calling setitimer()\n");
    		exit(1);
  	}		
	signal(SIGALRM, &sigtimerhandler);
	
	while(t){
	if(isVideoPacketAvailable()==1)
	{
		pkt = getVideoPacket();
		int newFrameID = getFrameID(pkt);
		frameSentToDecoder.msgType = 2;
		if( newFrameID == oldFrameID){
			frameSentToDecoder.packets[count] = pkt;
			count=count+1;
		}
		else{
		if(count >= 3){
		int msg = msgsnd(to_decoder_que,&frameSentToDecoder,(sizeof(struct frameBuf) - sizeof(long int)),IPC_NOWAIT);//decoding queue	
		}
		count = 0;		
		frameSentToDecoder.packets[count] = pkt;		
		}
		oldFrameID = newFrameID;	
	}
	
	curtime=time(NULL);
	if(difftime(curtime, initime) > 30)
	{
		t = 0;		
		break;
	}
	}
	pthread_join(decoding_thread,NULL);
	result = msgctl(to_decoder_que,IPC_RMID,NULL);
	result = msgctl(dispQid,IPC_RMID,NULL);
	printStats();	
}








