// Link Allocator
// Joseph Yang

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

#define DEBUG
//#define DEBUG_PROGRAMMING_FILE
#define DEBUG_MAPPING

#define CODE_FREE	"000"
#define CODE_EAST	"001"
#define CODE_WEST	"010"
#define CODE_NORTH	"011"
#define CODE_SOUTH	"100"
#define CODE_LOCAL	"101"

#define TRUE					1
#define FALSE					0

#define NUMBER_OF_INDEX_TO_TRY	1
#define REQUESTS_MAX			10

#define POSSIBLE_PATH_MAX		252
// Max array is 6by6, so max_path_length=10, so possible_path_max=10c5


#define ALLOCATION_HISTORY_MAX	7
#define FILENAME_CONNECTION_REQUIREMENTS			"ConnectionRequirements.txt"
#define FILENAME_CONNECTION_ALLOCATIONS				"ConnectionAllocation.txt"
#define FILENAME_CONNECTION_ALLOCATIONS_FOR_EXCEL	"ConnectionAllocationForExcel.txt"
#define FILENAME_PROGRAMMING_FILE					"generated/ProgrammingFile.txt"
#define FILENAME_PROGRAMMING_DATA_MICROBLAZE		"generated/SkeletonCodeForProgrammingCore.c"
#define FILENAME_CHANNEL_REPORT						"generated/ChannelReport.txt"

/* change to command line arguments
#define SEND_CHANNELS_MAX		1
#define RCV_CHANNELS_MAX		1
#define DATA_WIDTH				32
#define ROW_MAX					2
#define COL_MAX					2
#define WIRES_PER_PORT			8
*/
int SEND_CHANNELS_MAX;
int RCV_CHANNELS_MAX;
int DATA_WIDTH;
int ROW_MAX;
int COL_MAX;
int WIRES_PER_PORT;

//--v-- Custom Types Definition -----------------------------------------------
typedef struct {
	unsigned char port;
	int index;
} wire;

typedef struct {
	wire outNorth[20];
	wire outSouth[20];
	wire outEast[20];
	wire outWest[20];
	wire outLocal[20];
} router;

typedef struct {
	int srcR;
	int srcC;
	int destR;
	int destC;
	int srcIndex;
	int destIndex;
} t_requestPending;

typedef struct {
	unsigned char sendChannel[20][20+1];
	unsigned char rcvChannel[20][20+1];
} t_wiresAllocated;
//--^-- Custom Types Definition -----------------------------------------------

router NOC[10][10];

t_wiresAllocated wiresAllocated[10][10];

t_requestPending requestPending[REQUESTS_MAX*20];
unsigned char possiblePaths[10][10][POSSIBLE_PATH_MAX]
				[10-1+10-1+1];
				// MAX_PATH_LENGTH = ROW_MAX-1+COL_MAX-1
int possiblePathsIndexMax[10][10];

//--v-- Function Prototypes ---------------------------------------------------
unsigned int max(unsigned int a, unsigned int b);
int map(int reqPendingIndex, router newNOC[10][10],
			t_requestPending tempRequestPending[REQUESTS_MAX*20],
			int possiblePathIndex);
void loadPossiblePaths(void);
int loadConnectionRequirements(void);
void requestPendingCopy(t_requestPending dest[REQUESTS_MAX*20],
							t_requestPending src[REQUESTS_MAX*20]);

void generatePaoFile(void);
void generateMpdFile(void);
void generateVhdl(void);

void generateVhdlTop(void);
void fprintfTopComponentDeclarationNi(FILE *outFile);
void fprintfTopComponentDeclarationNoc(FILE *outFile);
void fprintfTopSignalsNi(FILE *outFile);
void fprintfTopSignalsNoc(FILE *outFile);
void fprintfTopComponentInstantiateNi(FILE *outFile, int r, int c);
void fprintfTopComponentInstantiateNoc(FILE *outFile);
void fprintfTopSignalAssignmentsNi(FILE *outFile);

void generateVhdlOutFsm(void);
void generateVhdlSendDataDistributor(void);
void generateVhdlInFsm(void);
void generateVhdlRcvDataCollector(void);
void generateVhdlSetupFsmNi(void);

void generateVhdlNi(void);
void fprintfNiEntityDeclaration(FILE *outFile);
void fprintfNiComponentDeclarationSendDataDistributor(FILE *outFile);
void fprintfNiComponentDeclarationRcvDataCollector(FILE *outFile);
void fprintfNiComponentDeclarationOutFsm(FILE *outFile);
void fprintfNiComponentDeclarationInFsm(FILE *outFile);
void fprintfNiComponentDeclarationSetupFsmNi(FILE *outFile);
void fprintfNiSignalsSend(FILE *outFile, int index);
void fprintfNiSignalsRcv(FILE *outFile, int index);
void fprintfNiSignalsSetupFsmNi(FILE *outFile);
void fprintfNiComponentInstantiateSend(FILE *outFile, int index);
void fprintfNiComponentInstantiateRcv(FILE *outFile, int index);
void fprintfNiComponentInstantiateOutFsm(FILE *outFile);
void fprintfNiComponentInstantiateInFsm(FILE *outFile);
void fprintfNiComponentInstantiateSetupFsmNi(FILE *outFile);
void fprintfNiSignalAssignmentsSetupFsmNi(FILE *outFile);
void fprintfNiSignalAssignmentsSend(FILE *outFile, int index);
void fprintfNiSignalAssignmentsRcv(FILE *outFile, int index);

void generateVhdlNoc(void);
void fprintfNocEntityDeclaration(FILE *outFile);
void fprintfNocComponentDeclarationDataNetwork(FILE *outFile);
void fprintfNocComponentDeclarationControlNetwork(FILE *outFile);
void fprintfNocSignals(FILE *outFile);
void fprintfNocComponentInstantiateDataNetwork(FILE *outFile);
void fprintfNocComponentInstantiateControlNetwork(FILE *outFile);

void generateVhdlControlNetwork(void);
void fprintfControlNetworkEntityDeclaration(FILE *outFile);
void fprintfControlNetworkComponentDeclarationSetupFsmRouter(FILE *outFile);
void fprintfControlNetworkSignalsSetupFsmRouter(FILE *outFile);
void fprintfControlNetworkComponentInstantiateSetupFsmRouter(FILE *outFile);
void fprintfControlNetworkSignalAssignments(FILE *outFile);

void generateVhdlDataNetwork(void);
void fprintfDataNetworkEntityDeclaration(FILE *outFile);
void fprintfDataNetworkComponentDeclarationRouter(FILE *outFile);
void fprintfDataNetworkSignalsRouter(FILE *outFile);
void fprintfDataNetworkComponentInstantiateRouter(FILE *outFile);
void fprintfDataNetworkSignalAssignments(FILE *outFile);

void generateVhdlRouter(void);
void generateVhdlNiSerializer(void);
void fprintfRouterEntityDeclaration(FILE *outFile,int r, int c);
void fprintfRouterSignals(FILE *outFile, int r, int c, unsigned char ch);
void fprintfRouterDirection(FILE *outFile, unsigned char ch);

void generateVhdlSetupFsmRouter(void);
void fprintfSetupFsmRouterEntityDeclaration(FILE *outFile);

void initializeWiresAllocated(void);
int assignChannel(int requestPendingIndexTotal);
void generateProgrammingFile(void);
void convertProgrammingFile(void);
int directionToNumber(unsigned char direction);

void printRouterStatus(router routerToPrint[10][10]);
void fprintRouterStatus(void);
void fprintRouterStatusForExcel(void);
void printAllocationHistory(wire allocationHistory[]);

int processRequirement(int reqPendingIndex, router tempNOC[10][10],
						t_requestPending oldRequestPending[REQUESTS_MAX*20],
						int possiblePathIndex);
int allocatePath(router router[10][10], int srcR, int srcC,
					int srcIndex, int destR, int destC, int *destIndex,
					int possiblePathIndex);
int indexUsed(router *router, unsigned char port, int index);
void deallocateLinks(router tempNOC[10][10], int srcR, int srcC, int destR, int destC,
						wire allocationHistory[]);
void deallocateLink(router *router, wire wire);
int allocateLink(unsigned char inputPort, int index, router *router,
					unsigned char reqDirection, wire *wire);
void routerCopy(router dest[10][10], router src[10][10]);
void initializeRouters(void);

void decToBin(int number, int bitLength, unsigned char str[]);
void binToHex(unsigned char binary[], unsigned char *left, unsigned char *right);
//--^-- Function Prototypes ---------------------------------------------------

//@@v@@ Main @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
int main(int argc, char *argv[]) {

	mkdir("generated");
	clock_t startTime, endTime;
	double timeTaken;
	int requestPendingIndexTotal;
	router tempNOC[10][10];
	t_requestPending tempRequestPending[REQUESTS_MAX*20];
	argc = 7;
	
	if (argc != 7) {
		printf("Usage: %s <send_channels_max> <rcv_channels_max> <data_width>", argv[0]);
		printf(" <row_max> <col_max> <wires_per_port>\n");
		return 1;
	}
	else {
		// argv[0] == name of program
		SEND_CHANNELS_MAX = 1;
		RCV_CHANNELS_MAX = 1;
		DATA_WIDTH = 32;
		ROW_MAX = 2;
		COL_MAX = 2;
		WIRES_PER_PORT = 8;

		if((SEND_CHANNELS_MAX < 1) || (SEND_CHANNELS_MAX > 15)) {
			printf("ERROR: SEND_CHANNELS_MAX out of range.\n");
			return 1;
		}
		if((RCV_CHANNELS_MAX < 1) || (RCV_CHANNELS_MAX > 15)) {
			printf("ERROR: RCV_CHANNELS_MAX out of range.\n");
			return 1;
		}
		if((ROW_MAX < 1) || (ROW_MAX > 6)) {
			printf("ERROR: ROW_MAX out of range.\n");
			return 1;
		}
		if((COL_MAX < 1) || (COL_MAX > 6)) {
			printf("ERROR: COL_MAX out of range.\n");
			return 1;
		}
		if((WIRES_PER_PORT < 1) || (WIRES_PER_PORT > 16)) {
			printf("ERROR: WIRES_PER_PORT out of range.\n");
			return 1;
		}
		
		loadPossiblePaths();
		
		initializeWiresAllocated();
		
		initializeRouters();
		
		routerCopy(tempNOC, NOC);
		
		requestPendingIndexTotal = loadConnectionRequirements();
		requestPendingCopy(tempRequestPending, requestPending);
		
		startTime = clock();
		if (map(requestPendingIndexTotal, tempNOC, tempRequestPending, 0)) {
			endTime = clock();
			printf("Status: Mapping phase done.\n");
			printf("\n");
			
			//printRouterStatus();
			//fprintRouterStatus();
			//fprintRouterStatusForExcel();
			
			if(assignChannel(requestPendingIndexTotal)) {	// ERROR
				printf("ERROR: Not enough channels.\n");
				printf("\n");
			}
			else {	// Success!!
				//generateProgrammingFile();
				//convertProgrammingFile();
				generatePaoFile();
				generateMpdFile();
				generateVhdl();
			}
		}
		else {
			endTime = clock();
			printf("ERROR: Not all connection requirements could be satisfied.\n");
		}
		printf("startTime=%f\n", (double)startTime);
		printf("endTime=%f\n", (double)endTime);
		timeTaken = ((double)(endTime-startTime)) / CLOCKS_PER_SEC;
		printf("Time Taken for mapping: %f ticks\n", timeTaken);
		
		return 0;
	}
}
//@@^@@ Main @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

//--v-- max -------------------------------------------------------------------
unsigned int max(unsigned int a, unsigned int b) {
	if(a > b)
		return a;
	else
		return b;
}
//--^-- max -------------------------------------------------------------------

//--v-- map -------------------------------------------------------------------
int map(int reqPendingIndex, router tempNOC[10][10],
			t_requestPending tempRequestPending[REQUESTS_MAX*20],
			int possiblePathIndex) {
	router oldNOC[10][10];
	t_requestPending oldRequestPending[REQUESTS_MAX*20];
	int rowsToTravel, colsToTravel;
	
//	printRouterStatus(tempNOC);
	
	#ifdef DEBUG_MAPPING
		printf("map(%d, %d)...\n", reqPendingIndex, possiblePathIndex);
	#endif
	
	rowsToTravel = abs(requestPending[reqPendingIndex].destR
						- requestPending[reqPendingIndex].srcR);
	colsToTravel = abs(requestPending[reqPendingIndex].destC
						- requestPending[reqPendingIndex].srcC);
						
	if(reqPendingIndex < 0) {
		routerCopy(NOC, tempNOC);	// NOC is assigned the successfully mapped configuration
		requestPendingCopy(requestPending, tempRequestPending);
		return 1;		// successfully map everything
	}
	else if(possiblePathIndex > possiblePathsIndexMax[rowsToTravel]
															[colsToTravel]) {
		return 0;	// mapping failed
	}
	else {
		routerCopy(oldNOC, tempNOC);
		requestPendingCopy(oldRequestPending, tempRequestPending);
		if(processRequirement(reqPendingIndex, tempNOC, tempRequestPending,
								possiblePathIndex)) {
			if(map(reqPendingIndex-1, tempNOC, tempRequestPending, 0)) {
				return 1;
			}
			else {
				return map(reqPendingIndex, oldNOC, oldRequestPending,
							possiblePathIndex+1);
			}
		}
		else {
			return map(reqPendingIndex, oldNOC, oldRequestPending,
							possiblePathIndex+1);
		}
	}
}
//--^-- map -------------------------------------------------------------------

//--v-- loadPossiblePaths -----------------------------------------------------
void loadPossiblePaths(void) {
	int r, c, i;
	unsigned char filename[41] = "PossiblePaths/PossiblePaths-r3-c3.txt";
	FILE *inFile;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			if(!((r == 0) && (c == 0))) {
				filename[15+14] = 0x30+r;
				filename[18+14] = 0x30+c;
		
				#ifdef DEBUG
					printf("Loading %s...", filename);
				#endif
				
				inFile = fopen(filename, "r");
				
				i = 0;
				while(fgets(possiblePaths[r][c][i++], 10, inFile));
				
				possiblePathsIndexMax[r][c] = i-2;
				
				fclose(inFile);
				
				#ifdef DEBUG
					printf("done!\n");
				#endif
			}
		}
	}
}
//--^-- loadPossiblePaths -----------------------------------------------------

//--v-- loadConnectionRequirements --------------------------------------------
int loadConnectionRequirements(void) {
	int i, requestPendingIndex = 0;
	int srcR, srcC, destR, destC, wiresNeeded;
	FILE *fileConnectionRequirements;
	
	fileConnectionRequirements = fopen(FILENAME_CONNECTION_REQUIREMENTS, "r");
	
	while(fscanf(fileConnectionRequirements,
					"%*10s%d %*13s%d %*15s%d %*18s%d %*12s%d",
					&srcR, &srcC, &destR, &destC, &wiresNeeded) > 0) {
		for(i = 0; i < wiresNeeded; i++) {
			requestPending[requestPendingIndex].srcR = srcR;
			requestPending[requestPendingIndex].srcC = srcC;
			requestPending[requestPendingIndex].destR = destR;
			requestPending[requestPendingIndex].destC = destC;
			
			requestPending[requestPendingIndex].srcIndex = WIRES_PER_PORT;
			requestPending[requestPendingIndex].destIndex = WIRES_PER_PORT;
			requestPendingIndex++;
		}
	}
	
	fclose(fileConnectionRequirements);
	
	return requestPendingIndex-1;
}
//--^-- loadConnectionRequirements --------------------------------------------

//--v-- requestPendingCopy ----------------------------------------------------
void requestPendingCopy(t_requestPending dest[REQUESTS_MAX*20],
						t_requestPending src[REQUESTS_MAX*20]) {
	int index;
	int total;
	
	total = REQUESTS_MAX*20;
	for(index = 0; index < total; index++) {
		dest[index].srcR = src[index].srcR;
		dest[index].srcC = src[index].srcC;
		dest[index].destR = src[index].destR;
		dest[index].destC = src[index].destC;
		dest[index].srcIndex = src[index].srcIndex;
		dest[index].destIndex = src[index].destIndex;
	}
}
//--^-- requestPendingCopy ----------------------------------------------------

//--v-- generatePaoFile -------------------------------------------------------
void generatePaoFile(void) {
	char filename[50] = "generated/top_2by2_1send_1rcv_v2_1_0.pao";
	FILE *outFile;
	int r,c;
	
	filename[14] = 0x30+ROW_MAX;
	filename[17] = 0x30+COL_MAX;
	filename[19] = 0x30+SEND_CHANNELS_MAX;
	filename[25] = 0x30+RCV_CHANNELS_MAX;
	
	#ifdef DEBUG
		printf("Generating %s...", filename);
	#endif
	
	outFile = fopen(filename, "w");
	
	for(r = 0; r < ROW_MAX; r++) {
			for(c = 0; c < COL_MAX; c++) {
				fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a router_%d_%d vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX,r,c);
			}
	}
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a niSerializer vhdl\n",
						ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a dataNetwork vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a inFsm vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a ni vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a noc vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a outFsm vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a rcvDataCollector vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a sendDataDistributor vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a setupFsmNi vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "lib top_%dby%d_%dsend_%drcv_v1_00_a top vhdl\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);

	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generatePaoFile -------------------------------------------------------

//--v-- generateMpdFile -------------------------------------------------------
void generateMpdFile(void) {
	char filename[50] = "generated/top_2by2_1send_1rcv_v2_1_0.mpd";
	FILE *outFile;
	int s, m, r, c;
	
	filename[14] = 0x30+ROW_MAX;
	filename[17] = 0x30+COL_MAX;
	filename[19] = 0x30+SEND_CHANNELS_MAX;
	filename[25] = 0x30+RCV_CHANNELS_MAX;
	
	#ifdef DEBUG
		printf("Generating %s...", filename);
	#endif
	
	outFile = fopen(filename, "w");
	
	fprintf(outFile, "BEGIN top_%dby%d_%dsend_%drcv\n",
					ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "\n");
	fprintf(outFile, "## Peripheral Options\n");
	fprintf(outFile, "OPTION IPTYPE = PERIPHERAL\n");
	fprintf(outFile, "OPTION IMP_NETLIST = TRUE\n");
	fprintf(outFile, "OPTION HDL = VHDL\n");
	fprintf(outFile, "OPTION ARCH_SUPPORT_MAP = (OTHERS=DEVELOPMENT)\n");
	fprintf(outFile, "OPTION IP_GROUP = MICROBLAZE:PPC:USER\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "## Bus Interfaces\n");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(s = 0; s < SEND_CHANNELS_MAX; s++) {
				fprintf(outFile, "BUS_INTERFACE BUS = SFSL%d%d%d, BUS_STD = FSL, BUS_TYPE = SLAVE\n", r, c, s);
			}
			for(m = 0; m < RCV_CHANNELS_MAX; m++) {
				fprintf(outFile, "BUS_INTERFACE BUS = MFSL%d%d%d, BUS_STD = FSL, BUS_TYPE = MASTER\n", r, c, m);
			}
		}
	}
	fprintf(outFile, "BUS_INTERFACE BUS = CFSL0, BUS_STD = FSL, BUS_TYPE = SLAVE\n");
	fprintf(outFile, "BUS_INTERFACE BUS = SFSL_CE, BUS_STD = FSL, BUS_TYPE = SLAVE\n");
	fprintf(outFile, "BUS_INTERFACE BUS = SFSL_CDI, BUS_STD = FSL, BUS_TYPE = SLAVE\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "## Generics for VHDL or Parameters for Verilog\n");
	fprintf(outFile, "PARAMETER C_FSL_DATA_SIZE = %d, DT = integer, RANGE = (%d)\n", DATA_WIDTH, DATA_WIDTH);
	fprintf(outFile, "PARAMETER C_CFSL_DATA_SIZE = 8, DT = integer, RANGE = (8)\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "## Ports\n");
	fprintf(outFile, "PORT setup_FSL_S_Data = FSL_S_Data, DIR = I, VEC = [C_CFSL_DATA_SIZE-1:0], BUS = CFSL0\n");
	fprintf(outFile, "PORT setup_FSL_S_Exists = FSL_S_Exists, DIR = I, BUS = CFSL0\n");
	fprintf(outFile, "PORT setup_FSL_S_Read = FSL_S_Read, DIR = O, BUS = CFSL0\n");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(s = 0; s < SEND_CHANNELS_MAX; s++) {
				fprintf(outFile, "PORT ni_%d_%d_send%d_FSL_S_Data = FSL_S_Data, DIR = I, VEC = [C_FSL_DATA_SIZE-1:0], BUS = SFSL%d%d%d\n", r, c, s+1, r, c, s);
				fprintf(outFile, "PORT ni_%d_%d_send%d_FSL_S_Exists = FSL_S_Exists, DIR = I, BUS = SFSL%d%d%d\n", r, c, s+1, r, c, s);
				fprintf(outFile, "PORT ni_%d_%d_send%d_FSL_S_Read = FSL_S_Read, DIR = O, BUS = SFSL%d%d%d\n", r, c, s+1, r, c, s);
			}
			for(m = 0; m < RCV_CHANNELS_MAX; m++) {
				fprintf(outFile, "PORT ni_%d_%d_rcv%d_FSL_M_Data = FSL_M_Data, DIR = O, VEC = [C_FSL_DATA_SIZE-1:0], BUS = MFSL%d%d%d\n", r, c, m+1, r, c, m);
				fprintf(outFile, "PORT ni_%d_%d_rcv%d_FSL_M_Write = FSL_M_Write, DIR = O, BUS = MFSL%d%d%d\n", r, c, m+1, r, c, m);
				fprintf(outFile, "PORT ni_%d_%d_rcv%d_FSL_M_Full = FSL_M_Full, DIR = I, BUS = MFSL%d%d%d\n", r, c, m+1, r, c, m);
			}
		}
	}
	
	fprintf(outFile, "PORT CLK = "", DIR = I\n");
	fprintf(outFile, "PORT RST = "", DIR = I\n");
	fprintf(outFile, "PORT CE_fsl_Read = FSL_S_Read, DIR = O, BUS = SFSL_CE\n");
	fprintf(outFile, "PORT CE_fsl_exist = FSL_S_Exists, DIR = I, BUS = SFSL_CE\n");
	fprintf(outFile, "PORT CE_fsl_allRouter = FSL_S_Data, DIR = I, VEC = [C_FSL_DATA_SIZE-1:0], BUS = SFSL_CE\n");
	fprintf(outFile, "PORT CDI_fsl_Read = FSL_S_Read, DIR = O, BUS = SFSL_CDI\n");
	fprintf(outFile, "PORT CDI_fsl_exist = FSL_S_Exists, DIR = I, BUS = SFSL_CDI\n");
	fprintf(outFile, "PORT CDI_fsl_allRouter = FSL_S_Data, DIR = I, VEC = [C_FSL_DATA_SIZE-1:0], BUS = SFSL_CDI\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "END\n");
	fprintf(outFile, "\n");

	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateMpdFile -------------------------------------------------------

//--v-- generateVhdl ----------------------------------------------------------
void generateVhdl(void) {

	generateVhdlRouter();
	generateVhdlNiSerializer();

	//generateVhdlSetupFsmRouter();

	generateVhdlNoc();
	//generateVhdlControlNetwork();
	generateVhdlDataNetwork();
	
	generateVhdlSendDataDistributor();
	generateVhdlOutFsm();
	generateVhdlRcvDataCollector();
	generateVhdlInFsm();
	generateVhdlSetupFsmNi();
	generateVhdlNi();
	
	generateVhdlTop();
}
//--^-- generateVhdl ----------------------------------------------------------

//--v-- generateVhdlTop -------------------------------------------------------
void generateVhdlTop(void) {
	int i, r, c;
	FILE *outFile;
	int numOfRouters = ROW_MAX*COL_MAX;
	int totalCEbits = numOfRouters*5;
	int bitsNeeded = 0;
	if(totalCEbits<=256 && totalCEbits>128){
		bitsNeeded = 256;
	}
	else if(totalCEbits<=128 && totalCEbits>64){
		bitsNeeded = 128;
	}
	else if(totalCEbits<=64 && totalCEbits>32){
		bitsNeeded = 64;
	}
	else if(totalCEbits<=32 && totalCEbits>16){
		bitsNeeded = 32;
	}
	else{
		bitsNeeded = 16;
	}
	
	#ifdef DEBUG
		printf("Generating top.vhd...");
	#endif
	
	outFile = fopen("generated/top.vhd", "w");
	
	fprintf(outFile, "-- VHDL for top\n");
	fprintf(outFile, "-- Joseph Yang\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "\n");
	
	fprintf(outFile, "entity top_%dby%d_%dsend_%drcv is\n",
				ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			if((r == 0) && (c == 0)) {
				fprintf(outFile, "		setup_FSL_S_Data					: in	std_logic_vector(7 downto 0);\n");
				fprintf(outFile, "		setup_FSL_S_Exists				: in	std_logic;\n");
				fprintf(outFile, "		setup_FSL_S_Read				: out	std_logic;\n");
				fprintf(outFile, "		\n");
			}
			fprintf(outFile, "		ni_%d_%d_debugProgrammingInProgress	: out	std_logic;\n", r, c);
			for(i = 0; i < SEND_CHANNELS_MAX; i++) {
				fprintf(outFile, "		ni_%d_%d_send%d_FSL_S_Data		: in	std_logic_vector(%d downto 0);\n", r, c, i+1, DATA_WIDTH-1);
				fprintf(outFile, "		ni_%d_%d_send%d_FSL_S_Exists	: in	std_logic;\n", r, c, i+1);
				fprintf(outFile, "		ni_%d_%d_send%d_FSL_S_Read		: out	std_logic;\n", r, c, i+1);
			}
			for(i = 0; i < RCV_CHANNELS_MAX; i++) {
				fprintf(outFile, "		ni_%d_%d_rcv%d_FSL_M_Data		: out	std_logic_vector(%d downto 0);\n", r, c, i+1, DATA_WIDTH-1);
				fprintf(outFile, "		ni_%d_%d_rcv%d_FSL_M_Write		: out	std_logic;\n", r, c, i+1);
				fprintf(outFile, "		ni_%d_%d_rcv%d_FSL_M_Full		: in	std_logic;\n", r, c, i+1);
			}                                    
			fprintf(outFile, "		\n");
		}
	}
	
	fprintf(outFile, "		--CFGLUT5\n");
	fprintf(outFile, "		CE_fsl_exist: in std_logic;\n");
	fprintf(outFile, "		CE_fsl_allRouter : in	std_logic_vector(%d downto 0);\n",bitsNeeded-1);
	fprintf(outFile, "		CE_fsl_Read : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		CDI_fsl_exist	: in std_logic;\n");
	fprintf(outFile, "		CDI_fsl_allRouter : in std_logic_vector(31 downto 0);\n");
	fprintf(outFile, "		CDI_fsl_Read : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		CLK							: in	std_logic;\n");
	fprintf(outFile, "		RST							: in	std_logic\n");
	
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end top_%dby%d_%dsend_%drcv;\n",
				ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	fprintf(outFile, "\n");
	
	fprintf(outFile, "architecture structure of top_%dby%d_%dsend_%drcv is\n",
				ROW_MAX, COL_MAX, SEND_CHANNELS_MAX, RCV_CHANNELS_MAX);
	
	fprintfTopComponentDeclarationNi(outFile);
	fprintfTopComponentDeclarationNoc(outFile);
	
	fprintf(outFile, "	signal Programming_inProgress : std_logic;\n");
	fprintf(outFile, "	signal namedSignal_Clk						: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_Rst						: std_logic;\n");
	fprintf(outFile, "\n");
	
	fprintfTopSignalsNi(outFile);
	fprintfTopSignalsNoc(outFile);

	fprintf(outFile, "	--CFGLUT5\n");
	fprintf(outFile, "	signal namedSignal_CE_fsl_exist: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_CE_fsl_allRouter : std_logic_vector(%d downto 0);\n",bitsNeeded-1);
	fprintf(outFile, "	signal namedSignal_CE_fsl_Read : std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "	signal namedSignal_CDI_fsl_exist	: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_CDI_fsl_allRouter : std_logic_vector(31 downto 0);\n");
	fprintf(outFile, "	signal namedSignal_CDI_fsl_Read : std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "begin\n");

	for(r = 0; r < ROW_MAX; r++)
		for(c = 0; c < COL_MAX; c++)
			fprintfTopComponentInstantiateNi(outFile, r, c);
	
	fprintfTopComponentInstantiateNoc(outFile);
	
	fprintf(outFile, "	-- Signal Assignments\n");
	fprintf(outFile, "	namedSignal_Clk						<= CLK;\n");
	fprintf(outFile, "	namedSignal_Rst						<= RST;\n");
	fprintf(outFile, "\n");
	
	fprintfTopSignalAssignmentsNi(outFile);
	
	fprintf(outFile, "	--CFGLUT5\n");
	fprintf(outFile, "	namedSignal_CE_fsl_exist 		<= CE_fsl_exist;\n");
	fprintf(outFile, "	namedSignal_CE_fsl_allRouter 	<= CE_fsl_allRouter;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	namedSignal_CDI_fsl_exist 		<= CDI_fsl_exist;\n");
	fprintf(outFile, "	namedSignal_CDI_fsl_allRouter 	<= CDI_fsl_allRouter;\n");
	fprintf(outFile, "	CDI_fsl_Read 					<= namedSignal_CDI_fsl_Read;\n");
	fprintf(outFile, "	\n");

	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlTop -------------------------------------------------------

//--v-- fprintfTopComponentDeclarationNi --------------------------------------
void fprintfTopComponentDeclarationNi(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	component ni is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			debugProgrammingInProgress	: out	std_logic;\n");
	fprintf(outFile, "			\n");
	for(i = 0; i < SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "			send%d_FSL_S_Data	: in	std_logic_vector(%d downto 0);\n", i+1, DATA_WIDTH-1);
		fprintf(outFile, "			send%d_FSL_S_Exists	: in	std_logic;\n", i+1);
		fprintf(outFile, "			send%d_FSL_S_Read	: out	std_logic;\n", i+1);
	}                     
	fprintf(outFile, "\n");
	for(i = 0; i < RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "			rcv%d_FSL_M_Data		: out	std_logic_vector(%d downto 0);\n", i+1, DATA_WIDTH-1);
		fprintf(outFile, "			rcv%d_FSL_M_Write	: out	std_logic;\n", i+1);
		fprintf(outFile, "			rcv%d_FSL_M_Full		: in	std_logic;\n", i+1);
	}                     
	fprintf(outFile, "			\n");
	fprintf(outFile, "			output				: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "			input				: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			setupIn				: in	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "			setupInNew			: in	std_logic;\n");
	fprintf(outFile, "			setupInNewAck		: out	std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			thisRow				: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "			thisCol				: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			Programming_inProgress : in std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK					: in	std_logic;\n");
	fprintf(outFile, "			RST					: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfTopComponentDeclarationNi --------------------------------------

//--v-- fprintfTopComponentDeclarationNoc -------------------------------------
void fprintfTopComponentDeclarationNoc(FILE *outFile) {
	int r, c;
	int numOfRouters = ROW_MAX*COL_MAX;
	int totalCEbits = numOfRouters*5;
	int bitsNeeded = 0;
	if(totalCEbits<=256 && totalCEbits>128){
		bitsNeeded = 256;
	}
	else if(totalCEbits<=128 && totalCEbits>64){
		bitsNeeded = 128;
	}
	else if(totalCEbits<=64 && totalCEbits>32){
		bitsNeeded = 64;
	}
	else if(totalCEbits<=32 && totalCEbits>16){
		bitsNeeded = 32;
	}
	else{
		bitsNeeded = 16;
	}
	
	fprintf(outFile, "	component Noc is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "			router_%d_%d_InL						: in	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "			router_%d_%d_OutL						: out	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "		\n");
		}
	}
	fprintf(outFile, "\n");
	fprintf(outFile, "			--CFGLUT5\n");
	fprintf(outFile, "			CE_fsl_exist: in std_logic;\n");
	fprintf(outFile, "			CE_fsl_allRouter : in	std_logic_vector(%d downto 0);\n",bitsNeeded-1);
	fprintf(outFile, "			CE_fsl_Read : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			CDI_fsl_exist	: in std_logic;\n");
	fprintf(outFile, "			CDI_fsl_allRouter : in std_logic_vector(31 downto 0);\n");
	fprintf(outFile, "			CDI_fsl_Read : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			Programming_inProgress : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			CLK							: in	std_logic;\n");
	fprintf(outFile, "			RST							: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfTopComponentDeclarationNoc -------------------------------------

//--v-- fprintfTopSignalsNi ---------------------------------------------------
void fprintfTopSignalsNi(FILE *outFile) {
	int i, r, c;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(i = 0; i < SEND_CHANNELS_MAX; i++) {
				fprintf(outFile, "	signal namedSignal_ni_%d_%d_send%d_FSL_S_Data		: std_logic_vector(%d downto 0);\n", r, c, i+1, DATA_WIDTH-1);
				fprintf(outFile, "	signal namedSignal_ni_%d_%d_send%d_FSL_S_Exists	: std_logic;\n", r, c, i+1);
				fprintf(outFile, "	signal namedSignal_ni_%d_%d_send%d_FSL_S_Read		: std_logic;\n", r, c, i+1);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < RCV_CHANNELS_MAX; i++) {
				fprintf(outFile, "	signal namedSignal_ni_%d_%d_rcv%d_FSL_M_Data		: std_logic_vector(%d downto 0);\n", r, c, i+1, DATA_WIDTH-1);
				fprintf(outFile, "	signal namedSignal_ni_%d_%d_rcv%d_FSL_M_Write		: std_logic;\n", r, c, i+1);
				fprintf(outFile, "	signal namedSignal_ni_%d_%d_rcv%d_FSL_M_Full		: std_logic;\n", r, c, i+1);
			}
			fprintf(outFile, "	\n");
			fprintf(outFile, "	signal namedSignal_ni_%d_%d_output				: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_ni_%d_%d_input					: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	\n");
			fprintf(outFile, "	signal namedSignal_ni_%d_%d_setupIn				: std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_ni_%d_%d_setupInNew			: std_logic;\n", r, c);
			fprintf(outFile, "	signal namedSignal_ni_%d_%d_setupInNewAck			: std_logic;\n", r, c);
			fprintf(outFile, "	\n");
			fprintf(outFile, "	signal namedSignal_ni_%d_%d_thisRow				: std_logic_vector(2 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_ni_%d_%d_thisCol				: std_logic_vector(2 downto 0);\n", r, c);
			fprintf(outFile, "	\n");
		}
	}
}
//--^-- fprintfTopSignalsNi ---------------------------------------------------

//--v-- fprintfTopSignalsNoc --------------------------------------------------
void fprintfTopSignalsNoc(FILE *outFile) {
	int r, c;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			if((r == 0) && (c == 0)) {
				fprintf(outFile, "	signal namedSignal_noc_setupFsmRouter_%d_%d_setupIn			: std_logic_vector(7 downto 0);\n", r, c);
				fprintf(outFile, "	signal namedSignal_noc_setupFsmRouter_%d_%d_setupInNew		: std_logic;\n", r, c);
				fprintf(outFile, "	signal namedSignal_noc_setupFsmRouter_%d_%d_setupInNewAck		: std_logic;\n", r, c);
			}                                         
			fprintf(outFile, "	signal namedSignal_noc_setupFsmRouter_%d_%d_setupOutL			: std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_noc_setupFsmRouter_%d_%d_setupOutLNew		: std_logic;\n", r, c);
			fprintf(outFile, "	signal namedSignal_noc_setupFsmRouter_%d_%d_setupOutLNewAck	: std_logic;\n", r, c);
			fprintf(outFile, "	signal namedSignal_noc_router_%d_%d_InL						: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_noc_router_%d_%d_OutL						: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	\n");                
		}
	}
}
//--^-- fprintfTopSignalsNoc --------------------------------------------------

//--^-- fprintfTopComponentInstantiateNi --------------------------------------
void fprintfTopComponentInstantiateNi(FILE *outFile, int r, int c) {
	int i;
	
	fprintf(outFile, "	U_ni_%d_%d : ni\n", r, c);
	fprintf(outFile, "		port map\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			debugProgrammingInProgress	=> ni_%d_%d_debugProgrammingInProgress,\n", r, c);
	fprintf(outFile, "			\n");
	for(i = 0; i < SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "			send%d_FSL_S_Data	=> namedSignal_ni_%d_%d_send%d_FSL_S_Data,\n", i+1, r, c, i+1);
		fprintf(outFile, "			send%d_FSL_S_Exists	=> namedSignal_ni_%d_%d_send%d_FSL_S_Exists,\n", i+1, r, c, i+1);
		fprintf(outFile, "			send%d_FSL_S_Read	=> namedSignal_ni_%d_%d_send%d_FSL_S_Read,\n", i+1, r, c, i+1);
	}                     
	fprintf(outFile, "\n");
	for(i = 0; i < RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "			rcv%d_FSL_M_Data		=> namedSignal_ni_%d_%d_rcv%d_FSL_M_Data,\n", i+1, r, c, i+1);
		fprintf(outFile, "			rcv%d_FSL_M_Write	=> namedSignal_ni_%d_%d_rcv%d_FSL_M_Write,\n", i+1, r, c, i+1);
		fprintf(outFile, "			rcv%d_FSL_M_Full		=> namedSignal_ni_%d_%d_rcv%d_FSL_M_Full,\n", i+1, r, c, i+1);
	}                     
	fprintf(outFile, "			\n");
	fprintf(outFile, "			output				=> namedSignal_ni_%d_%d_output,\n", r, c);
	fprintf(outFile, "			input				=> namedSignal_ni_%d_%d_input,\n", r, c);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			setupIn				=> namedSignal_ni_%d_%d_setupIn,\n", r, c);
	fprintf(outFile, "			setupInNew			=> namedSignal_ni_%d_%d_setupInNew,\n", r, c);
	fprintf(outFile, "			setupInNewAck		=> namedSignal_ni_%d_%d_setupInNewAck,\n", r, c);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			thisRow				=> namedSignal_ni_%d_%d_thisRow,\n", r, c);
	fprintf(outFile, "			thisCol				=> namedSignal_ni_%d_%d_thisCol,\n", r, c);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			Programming_inProgress => Programming_inProgress,\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK					=> namedSignal_Clk,\n");
	fprintf(outFile, "			RST					=> namedSignal_Rst\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	\n");
}
//--^-- fprintfTopComponentInstantiateNi --------------------------------------

//--v-- fprintfTopComponentInstantiateNoc -------------------------------------
void fprintfTopComponentInstantiateNoc(FILE *outFile) {
	int r, c;
	fprintf(outFile, "	U_noc : noc\n");
	fprintf(outFile, "		port map\n");
	fprintf(outFile, "		(\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "			router_%d_%d_InL							=> namedSignal_noc_router_%d_%d_InL,\n", r, c, r, c);
			fprintf(outFile, "			router_%d_%d_OutL							=> namedSignal_noc_router_%d_%d_OutL,\n", r, c, r, c);
			fprintf(outFile, "			\n");
		}
	}
	fprintf(outFile, "			--CFGLUT5\n");
	fprintf(outFile, "			CE_fsl_exist				=> CE_fsl_exist,\n");
	fprintf(outFile, "			CE_fsl_allRouter			=> CE_fsl_allRouter,\n");
	fprintf(outFile, "			CE_fsl_Read					=> CE_fsl_Read,\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			CDI_fsl_exist				=> namedSignal_CDI_fsl_exist,\n");
	fprintf(outFile, "			CDI_fsl_allRouter			=> namedSignal_CDI_fsl_allRouter,\n");
	fprintf(outFile, "			CDI_fsl_Read				=> namedSignal_CDI_fsl_Read,\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			Programming_inProgress      => Programming_inProgress,\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			CLK					=> namedSignal_Clk,\n");
	fprintf(outFile, "			RST					=> namedSignal_Rst\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfTopComponentInstantiateNoc -------------------------------------

//--v-- fprintfTopSignalAssignmentsNi -----------------------------------------
void fprintfTopSignalAssignmentsNi(FILE *outFile) {
	int i, r, c;
	unsigned char tempStr[WIRES_PER_PORT+1];
	
	fprintf(outFile, "	namedSignal_noc_setupFsmRouter_0_0_setupIn			<= setup_FSL_S_Data;\n");
	fprintf(outFile, "	namedSignal_noc_setupFsmRouter_0_0_setupInNew		<= setup_FSL_S_Exists;\n");
	fprintf(outFile, "	setup_FSL_S_Read							<= namedSignal_noc_setupFsmRouter_0_0_setupInNewAck;\n");
	fprintf(outFile, "	\n");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(i = 0; i < SEND_CHANNELS_MAX; i++) {
				fprintf(outFile, "	namedSignal_ni_%d_%d_send%d_FSL_S_Data			<= ni_%d_%d_send%d_FSL_S_Data;\n", r, c, i+1, r, c, i+1);
				fprintf(outFile, "	namedSignal_ni_%d_%d_send%d_FSL_S_Exists		<= ni_%d_%d_send%d_FSL_S_Exists;\n", r, c, i+1, r, c, i+1);
				fprintf(outFile, "	ni_%d_%d_send%d_FSL_S_Read						<= namedSignal_ni_%d_%d_send%d_FSL_S_Read;\n", r, c, i+1, r, c, i+1);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < RCV_CHANNELS_MAX; i++) {
				fprintf(outFile, "	ni_%d_%d_rcv%d_FSL_M_Data						<= namedSignal_ni_%d_%d_rcv%d_FSL_M_Data;\n", r, c, i+1, r, c, i+1);
				fprintf(outFile, "	ni_%d_%d_rcv%d_FSL_M_Write						<= namedSignal_ni_%d_%d_rcv%d_FSL_M_Write;\n", r, c, i+1, r, c, i+1);
				fprintf(outFile, "	namedSignal_ni_%d_%d_rcv%d_FSL_M_Full			<= ni_%d_%d_rcv%d_FSL_M_Full;\n", r, c, i+1, r, c, i+1);
			}
			fprintf(outFile, "	\n");
			fprintf(outFile, "	namedSignal_noc_router_%d_%d_InL				<= namedSignal_ni_%d_%d_output;\n", r, c, r, c);
			fprintf(outFile, "	namedSignal_ni_%d_%d_input					<= namedSignal_noc_router_%d_%d_OutL;\n", r, c, r, c);
			fprintf(outFile, "	\n");
			fprintf(outFile, "	namedSignal_ni_%d_%d_setupIn					<= namedSignal_noc_setupFsmRouter_%d_%d_setupOutL;\n", r, c, r, c);
			fprintf(outFile, "	namedSignal_ni_%d_%d_setupInNew				<= namedSignal_noc_setupFsmRouter_%d_%d_setupOutLNew;\n", r, c, r, c);
			fprintf(outFile, "	namedSignal_noc_setupFsmRouter_%d_%d_setupOutLNewAck	<= namedSignal_ni_%d_%d_setupInNewAck;\n", r, c, r, c);
			fprintf(outFile, "	\n");
			decToBin(r, 3, tempStr);
			fprintf(outFile, "	namedSignal_ni_%d_%d_thisRow				<= \"%s\";\n", r, c, tempStr);
			decToBin(c, 3, tempStr);
			fprintf(outFile, "	namedSignal_ni_%d_%d_thisCol				<= \"%s\";\n", r, c, tempStr);
			fprintf(outFile, "	\n");

		}
	}
}
//--^-- fprintfTopSignalAssignmentsNi -----------------------------------------

//--v-- generateVhdlOutFsm ----------------------------------------------------
void generateVhdlOutFsm(void) {
	int i;
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating outFsm.vhd...");
	#endif
	
	outFile = fopen("generated/outFsm.vhd", "w");
	
	fprintf(outFile, "-- VHDL for outFsm\n");
	fprintf(outFile, "-- Joseph Yang\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
	fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "entity outFsm is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		dataToSend			: in	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "		dataToSendNew		: in	std_logic;\n");
	fprintf(outFile, "		dataToSendNewAck	: out	std_logic;\n");
	fprintf(outFile, "		output				: out	std_logic;\n");
	fprintf(outFile, "		idle				: out	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK					: in	std_logic;\n");
	fprintf(outFile, "		RST					: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end outFsm;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "architecture structure of outFsm is\n");
	fprintf(outFile, "	type t_state is (IDLE_STATE, START_BIT");
	for(i = DATA_WIDTH-1; i >= 0; i--) {
		fprintf(outFile, ", b%d", i);
	}
	fprintf(outFile, ");\n");

	fprintf(outFile, "	signal state		: t_state;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal shiftReg		: std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "begin\n");
	fprintf(outFile, "	process (CLK, RST)\n");
	fprintf(outFile, "		variable currDataToSendNewAck		: std_logic := '0';\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "		if (RST = '0') then\n");
	fprintf(outFile, "			dataToSendNewAck	<= '0';\n");
	fprintf(outFile, "			output				<= '0';\n");
	fprintf(outFile, "			idle				<= '1';\n");
	fprintf(outFile, "			state				<= IDLE_STATE;\n");
	fprintf(outFile, "		elsif (CLK'event and CLK = '1') then\n");
	fprintf(outFile, "			if (dataToSendNew = '0') then\n");
	fprintf(outFile, "				currDataToSendNewAck	:= '0';\n");
	fprintf(outFile, "				dataToSendNewAck		<= '0';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			case state is\n");
	fprintf(outFile, "				when IDLE_STATE =>\n");
	fprintf(outFile, "					idle	<= '1';\n");
	fprintf(outFile, "					output	<= '0';\n");
	fprintf(outFile, "					if ((dataToSendNew = '1') and (currDataToSendNewAck = '0'))then\n");
	fprintf(outFile, "						shiftReg				<= dataToSend;\n");
	fprintf(outFile, "						currDataToSendNewAck	:= '1';\n");
	fprintf(outFile, "						dataToSendNewAck		<= '1';\n");
	fprintf(outFile, "						idle					<= '0';\n");
	fprintf(outFile, "						state					<= START_BIT;\n");
	fprintf(outFile, "					end if;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "				when START_BIT =>\n");
	fprintf(outFile, "					output	<= '1';\n");
	fprintf(outFile, "					state	<= b%d;\n", DATA_WIDTH-1);

	for(i = DATA_WIDTH-1; i > 0; i--) {
		fprintf(outFile, "				when b%d =>\n", i);
		fprintf(outFile, "					output	<= shiftReg(%d);\n", i);
		fprintf(outFile, "					state	<= b%d;\n", i-1);
		fprintf(outFile, "\n");
	}

	fprintf(outFile, "				when b0 =>\n");
	fprintf(outFile, "					output	<= shiftReg(0);\n");
	fprintf(outFile, "					state	<= IDLE_STATE;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "				when others =>\n");
	fprintf(outFile, "					null;\n");
	fprintf(outFile, "			end case;\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlOutFsm ----------------------------------------------------

//--v-- generateVhdlSendDataDistributor ---------------------------------------
void generateVhdlSendDataDistributor(void) {
	int i;
	unsigned char tempStr[DATA_WIDTH+1];
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating sendDataDistributor.vhd...");
	#endif
	
	outFile = fopen("generated/sendDataDistributor.vhd", "w");
	
	fprintf(outFile, "-- VHDL for sendDataDistributor\n");
	fprintf(outFile, "-- Joseph Yang\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
	fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "entity sendDataDistributor is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		FSL_S_Data				: in	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "		FSL_S_Exists			: in	std_logic;\n");
	fprintf(outFile, "		FSL_S_Read				: out	std_logic;\n");
	fprintf(outFile, "		\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "		out%dFsmDataToSend		: out	std_logic_vector(%d downto 0);\n", i, DATA_WIDTH-1);
		fprintf(outFile, "		out%dFsmDataToSendNew	: out	std_logic;\n", i);
		fprintf(outFile, "		out%dFsmDataToSendNewAck	: in	std_logic;\n", i);
		fprintf(outFile, "		out%dFsmIdle				: in	std_logic;\n", i);
		fprintf(outFile, "		\n");
	}
	
	fprintf(outFile, "		programmingInProgress	: in	std_logic;\n");
	fprintf(outFile, "		sendWiresAllocated		: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK						: in	std_logic;\n");
	fprintf(outFile, "		RST						: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "end sendDataDistributor;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "architecture structure of sendDataDistributor is\n");
	fprintf(outFile, "	type t_state is (");
	
	for(i = WIRES_PER_PORT-1; i > 0; i--) {
		fprintf(outFile, "OUT_%d, ", i);
	}
	
	fprintf(outFile, "OUT_0);\n");
	
	fprintf(outFile, "	signal state				: t_state;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal tempReg				: std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "	signal tempRegNew			: std_logic := '0';\n");
	fprintf(outFile, "begin\n");
	fprintf(outFile, "	process (CLK, RST)\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "		if (RST = '0') then\n");
	fprintf(outFile, "			tempRegNew				<= '0';\n");
	fprintf(outFile, "			FSL_S_Read				<= '0';\n");
	decToBin(0, DATA_WIDTH, tempStr);
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			out%dFsmDataToSend		<= \"%s\";\n", i, tempStr);
		fprintf(outFile, "			out%dFsmDataToSendNew	<= '0';\n", i);
	}
	
	fprintf(outFile, "			state					<= OUT_%d;\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		elsif (CLK'event and CLK = '1') then\n");
	fprintf(outFile, "			FSL_S_Read		<= '0';\n");
	fprintf(outFile, "			if (FSL_S_Exists = '1') then\n");
	fprintf(outFile, "				if (tempRegNew = '0') then\n");
	fprintf(outFile, "					tempReg			<= FSL_S_Data;\n");
	fprintf(outFile, "					tempRegNew		<= '1';\n");
	fprintf(outFile, "					FSL_S_Read		<= '1';\n");
	fprintf(outFile, "				end if;\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "\n");
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			if (out%dFsmDataToSendNewAck = '1') then\n", i);
		fprintf(outFile, "				out%dFsmDataToSendNew		<= '0';\n", i);
		fprintf(outFile, "			end if;\n");
	}
	fprintf(outFile, "\n");
	fprintf(outFile, "			if (programmingInProgress = '0') then\n");
	fprintf(outFile, "				case state is\n");
	
	for(i = WIRES_PER_PORT-1; i > 0; i--) {
		fprintf(outFile, "					when OUT_%d =>\n", i);
		fprintf(outFile, "						state	<= OUT_%d;\n", i-1);
		fprintf(outFile, "						if (sendWiresAllocated(%d) = '1') then\n", i);
		fprintf(outFile, "							state	<= OUT_%d;\n", i);
		fprintf(outFile, "							if (tempRegNew = '1') then\n");
		fprintf(outFile, "								if (out%dFsmIdle = '1') then \n", i);
		fprintf(outFile, "									out%dFsmDataToSend		<= tempReg;\n", i);
		fprintf(outFile, "									tempRegNew				<= '0';\n");
		fprintf(outFile, "									out%dFsmDataToSendNew	<= '1';\n", i);
		fprintf(outFile, "									state					<= OUT_%d;\n", i-1);
		fprintf(outFile, "								end if;\n");
		fprintf(outFile, "							end if;\n");
		fprintf(outFile, "						end if;\n");
		fprintf(outFile, "					\n");
	}
	
	fprintf(outFile, "					when OUT_0 =>\n");
	fprintf(outFile, "						state	<= OUT_%d;\n", WIRES_PER_PORT-1);
	fprintf(outFile, "						if (sendWiresAllocated(0) = '1') then\n");
	fprintf(outFile, "							state	<= OUT_%d;\n", 0);
	fprintf(outFile, "							if (tempRegNew = '1') then\n");
	fprintf(outFile, "								if (out0FsmIdle = '1') then\n"); 
	fprintf(outFile, "									out0FsmDataToSend		<= tempReg;\n");
	fprintf(outFile, "									tempRegNew				<= '0';\n");
	fprintf(outFile, "									out0FsmDataToSendNew	<= '1';\n");
	fprintf(outFile, "									state					<= OUT_%d;\n", WIRES_PER_PORT-1);
	fprintf(outFile, "								end if;\n");
	fprintf(outFile, "							end if;\n");
	fprintf(outFile, "						end if;\n");
	fprintf(outFile, "					\n");

	fprintf(outFile, "					when others =>\n");
	fprintf(outFile, "						null;\n");
	fprintf(outFile, "				end case;\n");
	fprintf(outFile, "			else	-- if (programmingInProgress = '1') then\n");
	fprintf(outFile, "				state	<= OUT_%d;\n", WIRES_PER_PORT-1);
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlSendDataDistributor ---------------------------------------

//--v-- generateVhdlInFsm -----------------------------------------------------
void generateVhdlInFsm(void) {
	int i;
	unsigned char tempStr[DATA_WIDTH+1];
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating inFsm.vhd...");
	#endif
	
	outFile = fopen("generated/inFsm.vhd", "w");
	
	fprintf(outFile, "-- VHDL for inFsm\n");
	fprintf(outFile, "-- Joseph Yang\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
	fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "entity inFsm is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	
	fprintf(outFile, "		dataToRcv			: out	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "		dataToRcvNew		: out	std_logic;\n");
	fprintf(outFile, "		dataToRcvNewAck		: in	std_logic;\n");
	fprintf(outFile, "		input				: in	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK					: in	std_logic;\n");
	fprintf(outFile, "		RST					: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end inFsm;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "architecture structure of inFsm is\n");
	fprintf(outFile, "	type t_state is (IDLE, START_BIT");
	for(i = DATA_WIDTH-1; i >= 0; i--) {
		fprintf(outFile, ", b%d", i);
	}
	fprintf(outFile, ");\n");

	fprintf(outFile, "	signal state		: t_state;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal shiftReg		: std_logic_vector(%d downto 1);\n", DATA_WIDTH-1);
	fprintf(outFile, "begin\n");
	fprintf(outFile, "	process (CLK, RST)\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "		if (RST = '0') then\n");
	decToBin(0, DATA_WIDTH, tempStr);
	fprintf(outFile, "			dataToRcv		<= \"%s\";\n", tempStr);
	fprintf(outFile, "			dataToRcvNew	<= '0';\n");
	fprintf(outFile, "			state			<= IDLE;\n");
	fprintf(outFile, "		elsif (CLK'event and CLK = '1') then\n");
	fprintf(outFile, "			if (dataToRcvNewAck = '1') then\n");
	fprintf(outFile, "				dataToRcvNew		<= '0';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			case state is\n");
	fprintf(outFile, "				when IDLE =>\n");
	fprintf(outFile, "					if (input = '1') then\n");
	fprintf(outFile, "						state			<= b%d;\n", DATA_WIDTH-1);
	fprintf(outFile, "					end if;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "				when START_BIT =>\n");
	fprintf(outFile, "					state			<= IDLE;\n");
	fprintf(outFile, "\n");

	for(i = DATA_WIDTH-1; i > 0; i--) {
		fprintf(outFile, "				when b%d =>\n", i);
		fprintf(outFile, "					shiftReg(%d)		<= input;\n", i);
		fprintf(outFile, "					state			<= b%d;\n", i-1);
		fprintf(outFile, "\n");
	}

	fprintf(outFile, "				when b0 =>\n");
	fprintf(outFile, "					state			<= IDLE;\n");
	fprintf(outFile, "					dataToRcv		<= shiftReg(%d downto 1) & input;\n", DATA_WIDTH-1);
	fprintf(outFile, "					dataToRcvNew	<= '1';\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "				when others =>\n");
	fprintf(outFile, "					null;\n");
	fprintf(outFile, "			end case;\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlInFsm -----------------------------------------------------

//--v-- generateVhdlRcvDataCollector ------------------------------------------
void generateVhdlRcvDataCollector(void) {
	int i;
	unsigned char tempStr[DATA_WIDTH+1];
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating rcvDataCollector.vhd...");
	#endif
	
	outFile = fopen("generated/rcvDataCollector.vhd", "w");
	
	fprintf(outFile, "-- VHDL for rcvDataCollector\n");
	fprintf(outFile, "-- Joseph Yang\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
	fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "entity rcvDataCollector is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	
	fprintf(outFile, "		FSL_M_Data				: out	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "		FSL_M_Write				: out	std_logic;\n");
	fprintf(outFile, "		FSL_M_Full				: in	std_logic;\n");
	fprintf(outFile, "		\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "		in%dFsmDataToRcv			: in	std_logic_vector(%d downto 0);\n", i, DATA_WIDTH-1);
		fprintf(outFile, "		in%dFsmDataToRcvNew		: in	std_logic;\n", i);
		fprintf(outFile, "		in%dFsmDataToRcvNewAck	: out	std_logic;\n", i);
		fprintf(outFile, "		\n");
	}
	
	fprintf(outFile, "		programmingInProgress	: in	std_logic;\n");
	fprintf(outFile, "		rcvWiresAllocated		: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK						: in	std_logic;\n");
	fprintf(outFile, "		RST						: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "end rcvDataCollector;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "architecture structure of rcvDataCollector is\n");
	fprintf(outFile, "	type t_state is (");
	
	for(i = WIRES_PER_PORT-1; i > 0; i--) {
		fprintf(outFile, "IN_%d, ", i);
	}
	
	fprintf(outFile, "IN_0);\n");
	
	fprintf(outFile, "	signal state				: t_state;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal tempReg				: std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "	signal tempRegNew			: std_logic := '0';\n");
	fprintf(outFile, "begin\n");
	fprintf(outFile, "	process (CLK, RST)\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "		if (RST = '0') then\n");
	decToBin(0, DATA_WIDTH, tempStr);
	fprintf(outFile, "			FSL_M_Data				<= \"%s\";\n", tempStr);
	fprintf(outFile, "			FSL_M_Write				<= '0';\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			in%dFsmDataToRcvNewAck	<= '0';\n", i);
	}
	
	fprintf(outFile, "			state					<= IN_%d;\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		elsif (CLK'event and CLK = '1') then\n");
	fprintf(outFile, "			FSL_M_Write		<= '0';\n");
	fprintf(outFile, "			if (tempRegNew = '1') then\n");
	fprintf(outFile, "				if (FSL_M_Full = '0') then\n");
	fprintf(outFile, "					FSL_M_Data			<= tempReg;\n");
	fprintf(outFile, "					FSL_M_Write			<= '1';\n");
	fprintf(outFile, "					tempRegNew			<= '0';\n");
	fprintf(outFile, "				end if;\n");
	fprintf(outFile, "			end if;\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			if (in%dFsmDataToRcvNew = '0') then \n", i);
		fprintf(outFile, "				in%dFsmDataToRcvNewAck	<= '0';\n", i);
		fprintf(outFile, "			end if;\n");
	}
	
	fprintf(outFile, "\n");
	fprintf(outFile, "			if (programmingInProgress = '0') then\n");
	fprintf(outFile, "				case state is\n");
	
	for(i = WIRES_PER_PORT-1; i > 0; i--) {
		fprintf(outFile, "					when IN_%d =>\n", i);
		fprintf(outFile, "						state	<= IN_%d;\n", i-1);
		fprintf(outFile, "						if (rcvWiresAllocated(%d) = '1') then\n", i);
		fprintf(outFile, "							state	<= IN_%d;\n", i);
		fprintf(outFile, "							if (tempRegNew = '0') then\n");
		fprintf(outFile, "								if (in%dFsmDataToRcvNew = '1') then \n", i);
		fprintf(outFile, "									tempReg					<= in%dFsmDataToRcv;\n", i);
		fprintf(outFile, "									tempRegNew				<= '1';\n");
		fprintf(outFile, "									in%dFsmDataToRcvNewAck	<= '1';\n", i);
		fprintf(outFile, "									state	<= IN_%d;\n", i-1);
		fprintf(outFile, "								end if;\n");
		fprintf(outFile, "							end if;\n");
		fprintf(outFile, "						end if;\n");
		fprintf(outFile, "					\n");
	}
	
	fprintf(outFile, "					when IN_0 =>\n");
	fprintf(outFile, "						state	<= IN_%d;\n", WIRES_PER_PORT-1);
	fprintf(outFile, "						if (rcvWiresAllocated(0) = '1') then\n");
	fprintf(outFile, "							state	<= IN_%d;\n", 0);
	fprintf(outFile, "							if (tempRegNew = '0') then\n");
	fprintf(outFile, "								if (in0FsmDataToRcvNew = '1') then \n");
	fprintf(outFile, "									tempReg					<= in0FsmDataToRcv;\n");
	fprintf(outFile, "									tempRegNew				<= '1';\n");
	fprintf(outFile, "									in0FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "									state	<= IN_%d;\n", WIRES_PER_PORT-1);
	fprintf(outFile, "								end if;\n");
	fprintf(outFile, "							end if;\n");
	fprintf(outFile, "						end if;\n");
	fprintf(outFile, "					\n");

	fprintf(outFile, "					when others =>\n");
	fprintf(outFile, "						null;\n");
	fprintf(outFile, "				end case;\n");
	fprintf(outFile, "			else	-- if (programmingInProgress = '1') then\n");
	fprintf(outFile, "				state	<= IN_7;\n");
	fprintf(outFile, "				if (in7FsmDataToRcvNew = '1') then\n");
	fprintf(outFile, "				in7FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			if (in6FsmDataToRcvNew = '1') then\n");
	fprintf(outFile, "				in6FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			if (in5FsmDataToRcvNew = '1') then\n");
	fprintf(outFile, "				in5FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			if (in4FsmDataToRcvNew = '1') then\n");
	fprintf(outFile, "				in4FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			if (in3FsmDataToRcvNew = '1') then\n");
	fprintf(outFile, "				in3FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			if (in2FsmDataToRcvNew = '1') then\n");
	fprintf(outFile, "				in2FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			if (in1FsmDataToRcvNew = '1') then \n");
	fprintf(outFile, "				in1FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			if (in0FsmDataToRcvNew = '1') then\n");
	fprintf(outFile, "				in0FsmDataToRcvNewAck	<= '1';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlRcvDataCollector ------------------------------------------

//--v-- generateVhdlSetupFsmNi ------------------------------------------------
void generateVhdlSetupFsmNi(void) {
	int i, j;
	unsigned char tempStr[WIRES_PER_PORT+1];
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating setupFsmNi.vhd...");
	#endif
	
	outFile = fopen("generated/setupFsmNi.vhd", "w");
	
	fprintf(outFile, "-- VHDL for setupFsmNi\n");
	fprintf(outFile, "-- Vignesh Prakasam\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
	fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "entity setupFsmNi is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		programmingInProgress	: out	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		setupIn					: in	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "		setupInNew				: in	std_logic;\n");
	fprintf(outFile, "		setupInNewAck			: out	std_logic;\n");
	fprintf(outFile, "		\n");
	for(i = 1; i <= SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "		send%dWiresAllocated		: out	std_logic_vector(%d downto 0);\n", i, WIRES_PER_PORT-1);
	}
	fprintf(outFile, "		\n");
	for(i = 1; i <= RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "		rcv%dWiresAllocated		: out	std_logic_vector(%d downto 0);\n", i, WIRES_PER_PORT-1);
	}
	fprintf(outFile, "		\n");
	fprintf(outFile, "		thisRow					: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "		thisCol					: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK						: in	std_logic;\n");
	fprintf(outFile, "		RST						: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end setupFsmNi;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "architecture structure of setupFsmNi is\n");
	fprintf(outFile, "	type t_state is (IDLE, PROCESS_NI_BODY_1, PROCESS_NI_BODY_2, PROCESS_NI_BODY_3);\n");
	fprintf(outFile, "	signal state		: t_state;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal index		: std_logic_vector(3 downto 0);\n");
	fprintf(outFile, "	signal sendOrRcv	: std_logic;	-- '1' = send, '0' = rcv\n");
	fprintf(outFile, "begin\n");
	fprintf(outFile, "	process (CLK, RST)\n");
	fprintf(outFile, "		variable currSetupInNewAck	: std_logic;\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "		if (RST = '0') then\n");
	fprintf(outFile, "			programmingInProgress	<= '0';\n");
	fprintf(outFile, "			state					<= IDLE;\n");
	fprintf(outFile, "			index					<= \"0000\";\n");
	fprintf(outFile, "			sendOrRcv				<= '1';\n");
	fprintf(outFile, "			currSetupInNewAck		:= '0';\n");
	fprintf(outFile, "			setupInNewAck			<= '0';\n");
	fprintf(outFile, "			\n");
	decToBin(1, WIRES_PER_PORT, tempStr);
	for(i = 1; i <= SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "			send%dWiresAllocated		<= \"%s\";\n", i, tempStr);
	}
	fprintf(outFile, "			\n");
	for(i = 1; i <= RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "			rcv%dWiresAllocated		<= \"%s\";\n", i, tempStr);
	}
	fprintf(outFile, "		elsif (CLK'event and CLK = '1') then\n");
	fprintf(outFile, "			if ((setupInNew = '1') and (currSetupInNewAck = '0')) then\n");
	fprintf(outFile, "				case state is\n");
	fprintf(outFile, "					when IDLE =>\n");
	fprintf(outFile, "						currSetupInNewAck	:= '1';\n");
	fprintf(outFile, "						setupInNewAck		<= '1';\n");
	fprintf(outFile, "						if (setupIn(7 downto 0) = '1' & thisRow & thisCol & '1') then\n");
	fprintf(outFile, "							state				<= PROCESS_NI_BODY_1;\n");
	fprintf(outFile, "						elsif (setupIn(7 downto 1) = \"1111111\") then\n");
	fprintf(outFile, "							programmingInProgress	<= setupIn(0);\n");
	fprintf(outFile, "						end if;\n");
	fprintf(outFile, "					\n");
	fprintf(outFile, "					when PROCESS_NI_BODY_1 =>\n");
	fprintf(outFile, "						sendOrRcv		<= setupIn(6);\n");
	fprintf(outFile, "						index			<= setupIn(5 downto 2);\n");
	
	fprintf(outFile, "						case setupIn(5 downto 2) is\n");
	for(i = 0; i <= max(SEND_CHANNELS_MAX, RCV_CHANNELS_MAX); i++) {
		decToBin(i, 4, tempStr);
		fprintf(outFile, "							when \"%s\" =>\n", tempStr);
		fprintf(outFile, "								currSetupInNewAck	:= '1';\n");
		fprintf(outFile, "								setupInNewAck		<= '1';\n");
		if(i == 0) {
			fprintf(outFile, "								state				<= IDLE;\n");
		}
		else {
			fprintf(outFile, "								if (sendOrRcv = '1') then\n");
			for(j = 0; j < 2; j++) {
				if(15-j < WIRES_PER_PORT) {
					fprintf(outFile, "									send%dWiresAllocated(%d)	<= setupIn(%d);\n", i, 15-j, 1-j);
				}
			}
			fprintf(outFile, "								else\n");
			for(j = 0; j < 2; j++) {
				if(15-j < WIRES_PER_PORT) {
					fprintf(outFile, "									rcv%dWiresAllocated(%d)	<= setupIn(%d);\n", i, 15-j, 1-j);
				}
			}
			fprintf(outFile, "								end if;\n");
			fprintf(outFile, "								state				<= PROCESS_NI_BODY_2;\n");
		}
	}
	fprintf(outFile, "							when others =>\n");
	fprintf(outFile, "								null;\n");
	fprintf(outFile, "						end case;\n");
	fprintf(outFile, "					when PROCESS_NI_BODY_2 =>\n");
	fprintf(outFile, "						case index is\n");
	for(i = 1; i <= max(SEND_CHANNELS_MAX, RCV_CHANNELS_MAX); i++) {
		decToBin(i, 4, tempStr);
		fprintf(outFile, "							when \"%s\" =>\n", tempStr);
		fprintf(outFile, "								currSetupInNewAck	:= '1';\n");
		fprintf(outFile, "								setupInNewAck		<= '1';\n");
		fprintf(outFile, "								if (sendOrRcv = '1') then\n");
		for(j = 0; j < 7; j++) {
			if(13-j < WIRES_PER_PORT) {
				fprintf(outFile, "									send%dWiresAllocated(%d)	<= setupIn(%d);\n", i, 13-j, 6-j);
			}
		}
		fprintf(outFile, "								else\n");
		for(j = 0; j < 7; j++) {
			if(13-j < WIRES_PER_PORT) {
				fprintf(outFile, "									rcv%dWiresAllocated(%d)	<= setupIn(%d);\n", i, 13-j, 6-j);
			}
		}
		fprintf(outFile, "								end if;\n");
	}
	fprintf(outFile, "							when others =>\n");
	fprintf(outFile, "								null;\n");
	fprintf(outFile, "						end case;\n");
	fprintf(outFile, "						state	<= PROCESS_NI_BODY_3;\n");
	fprintf(outFile, "					when PROCESS_NI_BODY_3 =>\n");
	fprintf(outFile, "						case index is\n");
	for(i = 1; i <= max(SEND_CHANNELS_MAX, RCV_CHANNELS_MAX); i++) {
		decToBin(i, 4, tempStr);
		fprintf(outFile, "							when \"%s\" =>\n", tempStr);
		fprintf(outFile, "								currSetupInNewAck	:= '1';\n");
		fprintf(outFile, "								setupInNewAck		<= '1';\n");
		fprintf(outFile, "								if (sendOrRcv = '1') then\n");
		for(j = 0; j < 7; j++) {
			if(6-j < WIRES_PER_PORT) {
				fprintf(outFile, "									send%dWiresAllocated(%d)	<= setupIn(%d);\n", i, 6-j, 6-j);
			}
		}
		fprintf(outFile, "								else\n");
		for(j = 0; j < 7; j++) {
			if(6-j < WIRES_PER_PORT) {
				fprintf(outFile, "									rcv%dWiresAllocated(%d)	<= setupIn(%d);\n", i, 6-j, 6-j);
			}
		}
		fprintf(outFile, "								end if;\n");
	}
	fprintf(outFile, "							when others =>\n");
	fprintf(outFile, "								null;\n");
	fprintf(outFile, "						end case;\n");
	fprintf(outFile, "						state	<= PROCESS_NI_BODY_1;\n");
	fprintf(outFile, "				end case;\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			if (setupInNew = '0') then\n");
	fprintf(outFile, "				currSetupInNewAck	:= '0';\n");
	fprintf(outFile, "				setupInNewAck		<= '0';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlSetupFsmNi ------------------------------------------------

//--v-- generateVhdlNi --------------------------------------------------------
void generateVhdlNi(void) {
	int i, j;
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating ni.vhd...");
	#endif
	
	outFile = fopen("generated/ni.vhd", "w");
	
	fprintf(outFile, "-- VHDL for ni\n");
	fprintf(outFile, "-- Vignesh Prakasam\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "\n");
	fprintfNiEntityDeclaration(outFile);
	
	fprintf(outFile, "architecture structure of ni is\n");
	
	fprintfNiComponentDeclarationSendDataDistributor(outFile);
	fprintfNiComponentDeclarationRcvDataCollector(outFile);
	fprintfNiComponentDeclarationOutFsm(outFile);
	fprintfNiComponentDeclarationInFsm(outFile);
	fprintfNiComponentDeclarationSetupFsmNi(outFile);
	
	fprintf(outFile, "	signal namedSignal_Clk				: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_Rst				: std_logic;\n");
	fprintf(outFile, "\n");
	
	for(i = 0; i < SEND_CHANNELS_MAX; i++) {
		fprintfNiSignalsSend(outFile, i+1);
	}
	for(i = 0; i < RCV_CHANNELS_MAX; i++) {
		fprintfNiSignalsRcv(outFile, i+1);
	}
	
	fprintfNiSignalsSetupFsmNi(outFile);
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	signal namedSignal_out%dFsm_DataToSend		: std_logic_vector(%d downto 0);\n", i, DATA_WIDTH-1);
		fprintf(outFile, "	signal namedSignal_out%dFsm_DataToSendNew	: std_logic;\n", i);
		fprintf(outFile, "	signal namedSignal_out%dFsm_DataToSendNewAck	: std_logic;\n", i);
		fprintf(outFile, "	signal namedSignal_out%dFsm_Output			: std_logic;\n", i);
		fprintf(outFile, "	signal namedSignal_out%dFsm_Idle				: std_logic;\n", i);
	}
	fprintf(outFile, "\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	signal namedSignal_in%dFsm_DataToRcv			: std_logic_vector(%d downto 0);\n", i, DATA_WIDTH-1);
		fprintf(outFile, "	signal namedSignal_in%dFsm_DataToRcvNew		: std_logic;\n", i);
		fprintf(outFile, "	signal namedSignal_in%dFsm_DataToRcvNewAck	: std_logic;\n", i);
		fprintf(outFile, "	signal namedSignal_in%dFsm_Input				: std_logic;\n", i);
	}
	fprintf(outFile, "\n");
	
	fprintf(outFile, "begin\n");
	
	for(i = 0; i < SEND_CHANNELS_MAX; i++) {
		fprintfNiComponentInstantiateSend(outFile, i+1);
	}
	for(i = 0; i < RCV_CHANNELS_MAX; i++) {
		fprintfNiComponentInstantiateRcv(outFile, i+1);
	}
	
	fprintfNiComponentInstantiateOutFsm(outFile);
	fprintfNiComponentInstantiateInFsm(outFile);
	
	fprintfNiComponentInstantiateSetupFsmNi(outFile);
	
	fprintf(outFile, "	-- Signal Assignments\n");
	fprintf(outFile, "	namedSignal_Clk						<= CLK;\n");
	fprintf(outFile, "	namedSignal_Rst						<= RST;\n");
	fprintf(outFile, "\n");
	
	fprintfNiSignalAssignmentsSetupFsmNi(outFile);
	
	for(i = 0; i < SEND_CHANNELS_MAX; i++) {
		fprintfNiSignalAssignmentsSend(outFile, i+1);
	}
	for(i = 0; i < RCV_CHANNELS_MAX; i++) {
		fprintfNiSignalAssignmentsRcv(outFile, i+1);
	}
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	namedSignal_out%dFsm_DataToSend		<= namedSignal_send1DataDistributor_Out%dFsmDataToSend", i, i);
		for(j = 2; j <= SEND_CHANNELS_MAX; j++) {
			fprintf(outFile, "\n											or namedSignal_send%dDataDistributor_Out%dFsmDataToSend", j, i);
		}
		fprintf(outFile, ";\n");
		fprintf(outFile, "\n");
		
		fprintf(outFile, "	namedSignal_out%dFsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out%dFsmDataToSendNew", i, i);
		for(j = 2; j <= SEND_CHANNELS_MAX; j++) {
			fprintf(outFile, "\n											or namedSignal_send%dDataDistributor_Out%dFsmDataToSendNew", j, i);
		}
		fprintf(outFile, ";\n");
		fprintf(outFile, "\n");
		
	}
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	namedSignal_in%dFsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in%dFsmDataToRcvNewAck", i, i);
		for(j = 2; j <= SEND_CHANNELS_MAX; j++) {
			fprintf(outFile, "\n											or namedSignal_rcv%dDataCollector_in%dFsmDataToRcvNewAck", j, i);
		}
		fprintf(outFile, ";\n");
		fprintf(outFile, "\n");
	}
	
	fprintf(outFile, "	output	<= namedSignal_out%dFsm_Output", WIRES_PER_PORT-1);
	for(i = WIRES_PER_PORT-2; i >= 0; i--) {
		fprintf(outFile, "\n				& namedSignal_out%dFsm_Output", i);
	}
		fprintf(outFile, ";\n");
		fprintf(outFile, "\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	namedSignal_in%dFsm_Input		<= input(%d);\n", i, i);
	}
	fprintf(outFile, "\n");
	
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlNi --------------------------------------------------------

//--v-- fprintfNiEntityDeclaration --------------------------------------------
void fprintfNiEntityDeclaration(FILE *outFile) {
	int i;
	
	fprintf(outFile, "entity ni is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		debugProgrammingInProgress	: out	std_logic;\n");
	fprintf(outFile, "		\n");
	for(i = 0; i < SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "		send%d_FSL_S_Data	: in	std_logic_vector(%d downto 0);\n", i+1, DATA_WIDTH-1);
		fprintf(outFile, "		send%d_FSL_S_Exists	: in	std_logic;\n", i+1);
		fprintf(outFile, "		send%d_FSL_S_Read	: out	std_logic;\n", i+1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "		rcv%d_FSL_M_Data		: out	std_logic_vector(%d downto 0);\n", i+1, DATA_WIDTH-1);
		fprintf(outFile, "		rcv%d_FSL_M_Write	: out	std_logic;\n", i+1);
		fprintf(outFile, "		rcv%d_FSL_M_Full		: in	std_logic;\n", i+1);
	}
	fprintf(outFile, "		\n");
	fprintf(outFile, "		output				: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		input				: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		\n");
	fprintf(outFile, "		setupIn				: in	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "		setupInNew			: in	std_logic;\n");
	fprintf(outFile, "		setupInNewAck		: out	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		thisRow				: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "		thisCol				: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		Programming_inProgress : in std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK					: in	std_logic;\n");
	fprintf(outFile, "		RST					: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end ni;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiEntityDeclaration --------------------------------------------

//--v-- fprintfNiComponentDeclarationSendDataDistributor ----------------------
void fprintfNiComponentDeclarationSendDataDistributor(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	component sendDataDistributor is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	
	fprintf(outFile, "			FSL_S_Data				: in	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "			FSL_S_Exists			: in	std_logic;\n");
	fprintf(outFile, "			FSL_S_Read				: out	std_logic;\n");
	fprintf(outFile, "			\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			out%dFsmDataToSend		: out	std_logic_vector(%d downto 0);\n", i, DATA_WIDTH-1);
		fprintf(outFile, "			out%dFsmDataToSendNew	: out	std_logic;\n", i);
		fprintf(outFile, "			out%dFsmDataToSendNewAck	: in	std_logic;\n", i);
		fprintf(outFile, "			out%dFsmIdle				: in	std_logic;\n", i);
		fprintf(outFile, "			\n");
	}
	
	fprintf(outFile, "			programmingInProgress	: in	std_logic;\n");
	fprintf(outFile, "			sendWiresAllocated		: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK						: in	std_logic;\n");
	fprintf(outFile, "			RST						: in	std_logic\n");
	
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiComponentDeclarationSendDataDistributor ----------------------

//--v-- fprintfNiComponentDeclarationRcvDataCollector -------------------------
void fprintfNiComponentDeclarationRcvDataCollector(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	component rcvDataCollector is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	
	fprintf(outFile, "			FSL_M_Data				: out	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "			FSL_M_Write				: out	std_logic;\n");
	fprintf(outFile, "			FSL_M_Full				: in	std_logic;\n");
	fprintf(outFile, "			\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			in%dFsmDataToRcv			: in	std_logic_vector(%d downto 0);\n", i, DATA_WIDTH-1);
		fprintf(outFile, "			in%dFsmDataToRcvNew		: in	std_logic;\n", i);
		fprintf(outFile, "			in%dFsmDataToRcvNewAck	: out	std_logic;\n", i);
		fprintf(outFile, "			\n");
	}
	
	fprintf(outFile, "			programmingInProgress	: in	std_logic;\n");
	fprintf(outFile, "			rcvWiresAllocated		: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK						: in	std_logic;\n");
	fprintf(outFile, "			RST						: in	std_logic\n");
	
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiComponentDeclarationRcvDataCollector -------------------------

//--v-- fprintfNiComponentDeclarationOutFsm -----------------------------------
void fprintfNiComponentDeclarationOutFsm(FILE *outFile) {
	fprintf(outFile, "	component outFsm is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			dataToSend			: in	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "			dataToSendNew		: in	std_logic;\n");
	fprintf(outFile, "			dataToSendNewAck	: out	std_logic;\n");
	fprintf(outFile, "			output				: out	std_logic;\n");
	fprintf(outFile, "			idle				: out	std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK					: in	std_logic;\n");
	fprintf(outFile, "			RST					: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiComponentDeclarationOutFsm -----------------------------------

//--v-- fprintfNiComponentDeclarationInFsm ------------------------------------
void fprintfNiComponentDeclarationInFsm(FILE *outFile) {
	fprintf(outFile, "	component inFsm is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			dataToRcv			: out	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "			dataToRcvNew		: out	std_logic;\n");
	fprintf(outFile, "			dataToRcvNewAck		: in	std_logic;\n");
	fprintf(outFile, "			input				: in	std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK					: in	std_logic;\n");
	fprintf(outFile, "			RST					: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiComponentDeclarationInFsm ------------------------------------

//--v-- fprintfNiComponentDeclarationSetupFsmNi -------------------------------
void fprintfNiComponentDeclarationSetupFsmNi(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	component setupFsmNi is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			programmingInProgress	: out	std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			setupIn					: in	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "			setupInNew				: in	std_logic;\n");
	fprintf(outFile, "			setupInNewAck			: out	std_logic;\n");
	fprintf(outFile, "			\n");
	for(i = 1; i <= SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "			send%dWiresAllocated		: out	std_logic_vector(%d downto 0);\n", i, WIRES_PER_PORT-1);
	}
	fprintf(outFile, "			\n");
	for(i = 1; i <= RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "			rcv%dWiresAllocated		: out	std_logic_vector(%d downto 0);\n", i, WIRES_PER_PORT-1);
	}
	fprintf(outFile, "			\n");
	fprintf(outFile, "			thisRow					: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "			thisCol					: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "			\n");                             
	fprintf(outFile, "			CLK						: in	std_logic;\n");
	fprintf(outFile, "			RST						: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiComponentDeclarationSetupFsmNi -------------------------------

//--v-- fprintfNiSignalsSend --------------------------------------------------
void fprintfNiSignalsSend(FILE *outFile, int index) {
	int i;
	
	fprintf(outFile, "	signal namedSignal_send%dDataDistributor_FSL_S_Data				: std_logic_vector(%d downto 0);\n", index, DATA_WIDTH-1);
	fprintf(outFile, "	signal namedSignal_send%dDataDistributor_FSL_S_Exists			: std_logic;\n", index);
	fprintf(outFile, "	signal namedSignal_send%dDataDistributor_FSL_S_Read				: std_logic;\n", index);
	fprintf(outFile, "	\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	signal namedSignal_send%dDataDistributor_Out%dFsmDataToSend		: std_logic_vector(%d downto 0);\n", index, i, DATA_WIDTH-1);
		fprintf(outFile, "	signal namedSignal_send%dDataDistributor_Out%dFsmDataToSendNew	: std_logic;\n", index, i);
		fprintf(outFile, "	signal namedSignal_send%dDataDistributor_Out%dFsmDataToSendNewAck	: std_logic;\n", index, i);
		fprintf(outFile, "	signal namedSignal_send%dDataDistributor_Out%dFsmIdle				: std_logic;\n", index, i);
		fprintf(outFile, "	\n");
	}
	fprintf(outFile, "	signal namedSignal_send%dDataDistributor_programmingInProgress	: std_logic;\n", index);
	fprintf(outFile, "	signal namedSignal_send%dDataDistributor_sendWiresAllocated		: std_logic_vector(%d downto 0);\n", index, WIRES_PER_PORT-1);
	fprintf(outFile, "	\n");
}
//--^-- fprintfNiSignalsSend --------------------------------------------------

//--v-- fprintfNiSignalsRcv ---------------------------------------------------
void fprintfNiSignalsRcv(FILE *outFile, int index) {
	int i;
	
	fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_FSL_M_Data				: std_logic_vector(%d downto 0);\n", index, DATA_WIDTH-1);
	fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_FSL_M_Write			: std_logic;\n", index);
	fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_FSL_M_Full				: std_logic;\n", index);
	fprintf(outFile, "\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_In%dFsmDataToRcv		: std_logic_vector(%d downto 0);\n", index, i, DATA_WIDTH-1);
		fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_In%dFsmDataToRcvNew		: std_logic;\n", index, i);
		fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_In%dFsmDataToRcvNewAck	: std_logic;\n", index, i);
		fprintf(outFile, "	\n");
	}
	fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_programmingInProgress	: std_logic;\n", index);
	fprintf(outFile, "	signal namedSignal_rcv%dDataCollector_rcvWiresAllocated		: std_logic_vector(%d downto 0);\n", index, WIRES_PER_PORT-1);
	fprintf(outFile, "\n");
}
//--^-- fprintfNiSignalsRcv ---------------------------------------------------

//--v-- fprintfNiSignalsSetupFsmNi --------------------------------------------
void fprintfNiSignalsSetupFsmNi(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	signal namedSignal_setupFsmNi_programmingInProgress	: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_setupFsmNi_setupIn				: std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "	signal namedSignal_setupFsmNi_setupInNew			: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_setupFsmNi_setupInNewAck			: std_logic;\n");
	fprintf(outFile, "	\n");
	for(i = 1; i <= SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "	signal namedSignal_setupFsmNi_send%dWiresAllocated	: std_logic_vector(%d downto 0);\n", i, WIRES_PER_PORT-1);
	}
	fprintf(outFile, "	\n");
	for(i = 1; i <= RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "	signal namedSignal_setupFsmNi_rcv%dWiresAllocated	: std_logic_vector(%d downto 0);\n", i, WIRES_PER_PORT-1);
	}
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal namedSignal_setupFsmNi_thisRow				: std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "	signal namedSignal_setupFsmNi_thisCol				: std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "	\n");                                                    
}
//--^-- fprintfNiSignalsSetupFsmNi --------------------------------------------

//--v-- fprintfNiComponentInstantiateSend -------------------------------------
void fprintfNiComponentInstantiateSend(FILE *outFile, int index) {
	int i;
	
	fprintf(outFile, "	U_send%dDataDistributor : sendDataDistributor\n", index);
	fprintf(outFile, "		port map\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			FSL_S_Data				=> namedSignal_send%dDataDistributor_FSL_S_Data,\n", index);
	fprintf(outFile, "			FSL_S_Exists			=> namedSignal_send%dDataDistributor_FSL_S_Exists,\n", index);
	fprintf(outFile, "			FSL_S_Read				=> namedSignal_send%dDataDistributor_FSL_S_Read,\n", index);
	fprintf(outFile, "		\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			out%dFsmDataToSend		=> namedSignal_send%dDataDistributor_Out%dFsmDataToSend,\n", i, index, i);
		fprintf(outFile, "			out%dFsmDataToSendNew	=> namedSignal_send%dDataDistributor_Out%dFsmDataToSendNew,\n", i, index, i);
		fprintf(outFile, "			out%dFsmDataToSendNewAck	=> namedSignal_send%dDataDistributor_Out%dFsmDataToSendNewAck,\n", i, index, i);
		fprintf(outFile, "			out%dFsmIdle				=> namedSignal_send%dDataDistributor_Out%dFsmIdle,\n", i, index, i);
	}
	fprintf(outFile, "			\n");
	fprintf(outFile, "			programmingInProgress	=> Programming_inProgress,\n");
	fprintf(outFile, "			sendWiresAllocated		=> namedSignal_send%dDataDistributor_sendWiresAllocated,\n", index);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK						=> namedSignal_Clk,\n");
	fprintf(outFile, "			RST						=> namedSignal_Rst\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiComponentInstantiateSend -------------------------------------

//--v-- fprintfNiComponentInstantiateRcv --------------------------------------
void fprintfNiComponentInstantiateRcv(FILE *outFile, int index) {
	int i;
	
	fprintf(outFile, "	U_rcv%dDataCollector : rcvDataCollector\n", index);
	fprintf(outFile, "		port map\n");
	fprintf(outFile, "		(\n");
	
	fprintf(outFile, "			FSL_M_Data				=> namedSignal_rcv%dDataCollector_FSL_M_Data,\n", index);
	fprintf(outFile, "			FSL_M_Write				=> namedSignal_rcv%dDataCollector_FSL_M_Write,\n", index);
	fprintf(outFile, "			FSL_M_Full				=> namedSignal_rcv%dDataCollector_FSL_M_Full,\n", index);
	fprintf(outFile, "		\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "			in%dFsmDataToRcv			=> namedSignal_rcv%dDataCollector_In%dFsmDataToRcv,\n", i, index, i);
		fprintf(outFile, "			in%dFsmDataToRcvNew		=> namedSignal_rcv%dDataCollector_In%dFsmDataToRcvNew,\n", i, index, i);
		fprintf(outFile, "			in%dFsmDataToRcvNewAck	=> namedSignal_rcv%dDataCollector_In%dFsmDataToRcvNewAck,\n", i, index, i);
	}
	fprintf(outFile, "			\n");
	fprintf(outFile, "			programmingInProgress	=> Programming_inProgress,\n");
	fprintf(outFile, "			rcvWiresAllocated		=> namedSignal_rcv%dDataCollector_rcvWiresAllocated,\n", index);
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK						=> namedSignal_Clk,\n");
	fprintf(outFile, "			RST						=> namedSignal_Rst\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNiComponentInstantiateRcv --------------------------------------

//--v-- fprintfNiComponentInstantiateOutFsm -----------------------------------
void fprintfNiComponentInstantiateOutFsm(FILE *outFile) {
	int i;
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	U_out%dFsm : outFsm\n", i);
		fprintf(outFile, "		port map\n");
		fprintf(outFile, "		(\n");
		fprintf(outFile, "			dataToSend			=> namedSignal_out%dFsm_DataToSend,\n", i);
		fprintf(outFile, "			dataToSendNew		=> namedSignal_out%dFsm_DataToSendNew,\n", i);
		fprintf(outFile, "			dataToSendNewAck	=> namedSignal_out%dFsm_DataToSendNewAck,\n", i);
		fprintf(outFile, "			output				=> namedSignal_out%dFsm_Output,\n", i);
		fprintf(outFile, "			idle				=> namedSignal_out%dFsm_Idle,\n", i);
		fprintf(outFile, "			\n");
		fprintf(outFile, "			CLK					=> namedSignal_Clk,\n");
		fprintf(outFile, "			RST					=> namedSignal_Rst\n");
		fprintf(outFile, "		);\n");
		fprintf(outFile, "	\n");
	}
}
//--^-- fprintfNiComponentInstantiateOutFsm -----------------------------------

//--v-- fprintfNiComponentInstantiateInFsm ------------------------------------
void fprintfNiComponentInstantiateInFsm(FILE *outFile) {
	int i;
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	U_in%dFsm : inFsm\n", i);
		fprintf(outFile, "		port map\n");
		fprintf(outFile, "		(\n");
		fprintf(outFile, "			dataToRcv			=> namedSignal_in%dFsm_DataToRcv,\n", i);
		fprintf(outFile, "			dataToRcvNew		=> namedSignal_in%dFsm_DataToRcvNew,\n", i);
		fprintf(outFile, "			dataToRcvNewAck		=> namedSignal_in%dFsm_DataToRcvNewAck,\n", i);
		fprintf(outFile, "			input				=> namedSignal_in%dFsm_Input,\n", i);
		fprintf(outFile, "			\n");
		fprintf(outFile, "			CLK					=> namedSignal_Clk,\n");
		fprintf(outFile, "			RST					=> namedSignal_Rst\n");
		fprintf(outFile, "		);\n");
		fprintf(outFile, "	\n");
	}
}
//--^-- fprintfNiComponentInstantiateInFsm ------------------------------------

//--v-- fprintfNiComponentInstantiateSetupFsmNi -------------------------------
void fprintfNiComponentInstantiateSetupFsmNi(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	U_setupFsmNi : setupFsmNi\n");
	fprintf(outFile, "		port map\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			programmingInProgress	=> namedSignal_setupFsmNi_programmingInProgress,\n");
	fprintf(outFile, "			setupIn					=> namedSignal_setupFsmNi_setupIn,\n");
	fprintf(outFile, "			setupInNew				=> namedSignal_setupFsmNi_setupInNew,\n");
	fprintf(outFile, "			setupInNewAck			=> namedSignal_setupFsmNi_setupInNewAck,\n");
	fprintf(outFile, "			\n");
	for(i = 1; i <= SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "			send%dWiresAllocated		=> namedSignal_setupFsmNi_send%dWiresAllocated,\n", i, i);
	}
	fprintf(outFile, "			\n");
	for(i = 1; i <= RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "			rcv%dWiresAllocated		=> namedSignal_setupFsmNi_rcv%dWiresAllocated,\n", i, i);
	}
	fprintf(outFile, "			\n");
	fprintf(outFile, "			thisRow					=> namedSignal_setupFsmNi_thisRow,\n");
	fprintf(outFile, "			thisCol					=> namedSignal_setupFsmNi_thisCol,\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			CLK						=> namedSignal_Clk,\n");
	fprintf(outFile, "			RST						=> namedSignal_Rst\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	\n");
}
//--^-- fprintfNiComponentInstantiateSetupFsmNi -------------------------------

//--v-- fprintfNiSignalAssignmentsSetupFsmNi ----------------------------------
void fprintfNiSignalAssignmentsSetupFsmNi(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	debugProgrammingInProgress			<= namedSignal_setupFsmNi_programmingInProgress;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	namedSignal_setupFsmNi_setupIn		<= setupIn;\n");
	fprintf(outFile, "	namedSignal_setupFsmNi_setupInNew	<= setupInNew;\n");
	fprintf(outFile, "	setupInNewAck						<= namedSignal_setupFsmNi_setupInNewAck;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	namedSignal_setupFsmNi_thisRow		<= thisRow;\n");
	fprintf(outFile, "	namedSignal_setupFsmNi_thisCol		<= thisCol;\n");
	fprintf(outFile, "	\n");
	for(i = 1; i <= SEND_CHANNELS_MAX; i++) {
		fprintf(outFile, "	namedSignal_send%dDataDistributor_programmingInProgress	<= namedSignal_setupFsmNi_programmingInProgress;\n", i);
		fprintf(outFile, "	namedSignal_send%dDataDistributor_sendWiresAllocated		<= namedSignal_setupFsmNi_send%dWiresAllocated;\n", i, i);
	}
	fprintf(outFile, "	\n");
	for(i = 1; i <= RCV_CHANNELS_MAX; i++) {
		fprintf(outFile, "	namedSignal_rcv%dDataCollector_programmingInProgress		<= namedSignal_setupFsmNi_programmingInProgress;\n", i);
		fprintf(outFile, "	namedSignal_rcv%dDataCollector_rcvWiresAllocated			<= namedSignal_setupFsmNi_rcv%dWiresAllocated;\n", i, i);
	}
	fprintf(outFile, "	\n");
}
//--^-- fprintfNiSignalAssignmentsSetupFsmNi ----------------------------------

//--v-- fprintfNiSignalAssignmentsSend ----------------------------------------
void fprintfNiSignalAssignmentsSend(FILE *outFile, int index) {
	int i;
	
	fprintf(outFile, "	namedSignal_send%dDataDistributor_FSL_S_Data				<= send%d_FSL_S_Data;\n", index, index);
	fprintf(outFile, "	namedSignal_send%dDataDistributor_FSL_S_Exists			<= send%d_FSL_S_Exists;\n", index, index);
	fprintf(outFile, "	send%d_FSL_S_Read										<= namedSignal_send%dDataDistributor_FSL_S_Read;\n", index, index);
	fprintf(outFile, "\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	namedSignal_send%dDataDistributor_Out%dFsmDataToSendNewAck	<= namedSignal_out%dFsm_DataToSendNewAck;\n", index, i, i);
		fprintf(outFile, "	namedSignal_send%dDataDistributor_Out%dFsmIdle				<= namedSignal_out%dFsm_Idle;\n", index, i, i);
	}
	fprintf(outFile, "\n");
}
//--^-- fprintfNiSignalAssignmentsSend ----------------------------------------

//--v-- fprintfNiSignalAssignmentsRcv -----------------------------------------
void fprintfNiSignalAssignmentsRcv(FILE *outFile, int index) {
	int i;
	
	fprintf(outFile, "	rcv%d_FSL_M_Data									<= namedSignal_rcv%dDataCollector_FSL_M_Data;\n", index, index);
	fprintf(outFile, "	rcv%d_FSL_M_Write								<= namedSignal_rcv%dDataCollector_FSL_M_Write;\n", index, index);
	fprintf(outFile, "	namedSignal_rcv%dDataCollector_FSL_M_Full			<= rcv%d_FSL_M_Full;\n", index, index);
	fprintf(outFile, "\n");
	
	for(i = WIRES_PER_PORT-1; i >= 0; i--) {
		fprintf(outFile, "	namedSignal_rcv%dDataCollector_In%dFsmDataToRcv		<= namedSignal_in%dFsm_DataToRcv;\n", index, i, i);
		fprintf(outFile, "	namedSignal_rcv%dDataCollector_In%dFsmDataToRcvNew	<= namedSignal_in%dFsm_DataToRcvNew;\n", index, i, i);
	}
	fprintf(outFile, "\n");
}
//--^-- fprintfNiSignalAssignmentsRcv -----------------------------------------

//--v-- generateVhdlNoc ----------------------------------------------------
void generateVhdlNoc(void) {
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating noc.vhd...");
	#endif
	
	outFile = fopen("generated/noc.vhd", "w");
	
	fprintf(outFile, "-- VHDL for NOC top level\n");
	fprintf(outFile, "-- Vignesh Prakasam\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "\n");
	fprintfNocEntityDeclaration(outFile);
	
	fprintf(outFile, "architecture structure of Noc is\n");

	fprintfNocComponentDeclarationDataNetwork(outFile);
	//fprintfNocComponentDeclarationControlNetwork(outFile);
	
	//fprintfNocSignals(outFile);
	
	fprintf(outFile, "begin\n");
	
	fprintfNocComponentInstantiateDataNetwork(outFile);
	//fprintfNocComponentInstantiateControlNetwork(outFile);

	fprintf(outFile, "	-- Signal Assignments\n");
	fprintf(outFile, "	namedSignal_Clk	<= CLK;\n");
	fprintf(outFile, "	namedSignal_Rst	<= RST;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlNoc ----------------------------------------------------

//--v-- fprintfNocEntityDeclaration -------------------------------------------
void fprintfNocEntityDeclaration(FILE *outFile) {
	int r, c;
	int numOfRouters = ROW_MAX*COL_MAX;
	int totalCEbits = numOfRouters*5;
	int bitsNeeded = 0;
	if(totalCEbits<=256 && totalCEbits>128){
		bitsNeeded = 256;
	}
	else if(totalCEbits<=128 && totalCEbits>64){
		bitsNeeded = 128;
	}
	else if(totalCEbits<=64 && totalCEbits>32){
		bitsNeeded = 64;
	}
	else if(totalCEbits<=32 && totalCEbits>16){
		bitsNeeded = 32;
	}
	else{
		bitsNeeded = 16;
	}
	
	fprintf(outFile, "entity Noc is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "		router_%d_%d_InL						: in	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "		router_%d_%d_OutL						: out	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "		\n");
		}
	}
	fprintf(outFile, "		--CFGLUT5\n");
	fprintf(outFile, "		CE_fsl_exist: in std_logic;\n");
	fprintf(outFile, "		CE_fsl_allRouter : in	std_logic_vector(%d downto 0);\n",bitsNeeded-1);
	fprintf(outFile, "		CE_fsl_Read : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		CDI_fsl_exist	: in std_logic;\n");
	fprintf(outFile, "		CDI_fsl_allRouter : in std_logic_vector(31 downto 0);\n");
	fprintf(outFile, "		CDI_fsl_Read : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		Programming_inProgress : out std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		CLK							: in	std_logic;\n");
	fprintf(outFile, "		RST							: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end Noc;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNocEntityDeclaration -------------------------------------------

//--v-- fprintfNocComponentDeclarationDataNetwork -----------------------------
void fprintfNocComponentDeclarationDataNetwork(FILE *outFile) {
	int i, r, c;
	int numOfRouters = ROW_MAX*COL_MAX;
	int totalCEbits = numOfRouters*5;
	int bitsNeeded = 0;
	if(totalCEbits<=256 && totalCEbits>128){
		bitsNeeded = 256;
	}
	else if(totalCEbits<=128 && totalCEbits>64){
		bitsNeeded = 128;
	}
	else if(totalCEbits<=64 && totalCEbits>32){
		bitsNeeded = 64;
	}
	else if(totalCEbits<=32 && totalCEbits>16){
		bitsNeeded = 32;
	}
	else{
		bitsNeeded = 16;
	}

	fprintf(outFile, "	component dataNetwork is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "			router_%d_%d_InL				: in	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "			router_%d_%d_OutL				: out	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "			\n");
		}
	}
	fprintf(outFile, "	\n");
	fprintf(outFile, "			--CFGLUT5\n");
	fprintf(outFile, "			CE_fsl_exist: in std_logic;\n");
	fprintf(outFile, "			CE_fsl_allRouter : in	std_logic_vector(%d downto 0);\n",bitsNeeded-1);
	fprintf(outFile, "			CE_fsl_Read : out std_logic;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "			CDI_fsl_exist	: in std_logic;\n");
	fprintf(outFile, "			CDI_fsl_allRouter : in std_logic_vector(31 downto 0);\n");
	fprintf(outFile, "			CDI_fsl_Read : out std_logic;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "			Programming_inProgress : out std_logic;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "			CLK							: in	std_logic;\n");
	fprintf(outFile, "			RST							: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal namedSignal_Clk : std_logic;\n");
	fprintf(outFile, "	signal namedSignal_Rst : std_logic;\n");
	fprintf(outFile, "	\n");

}
//--^-- fprintfNocComponentDeclarationDataNetwork -----------------------------

//--v-- fprintfNocComponentDeclarationControlNetwork --------------------------
void fprintfNocComponentDeclarationControlNetwork(FILE *outFile) {
	int i, r, c;
	
	fprintf(outFile, "	component controlNetwork is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			if((r == 0) && (c == 0)) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_setupIn			: in	std_logic_vector(7 downto 0);\n", r, c);
				fprintf(outFile, "			setupFsmRouter_%d_%d_setupInNew		: in	std_logic;\n", r, c);
				fprintf(outFile, "			setupFsmRouter_%d_%d_setupInNewAck	: out	std_logic;\n", r, c);
			}
			fprintf(outFile, "			setupFsmRouter_%d_%d_setupOutL		: out	std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "			setupFsmRouter_%d_%d_setupOutLNew		: out	std_logic;\n", r, c);
			fprintf(outFile, "			setupFsmRouter_%d_%d_setupOutLNewAck	: in	std_logic;\n", r, c);
			fprintf(outFile, "			\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutE_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutE_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutW_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutW_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutN_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutN_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutS_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutS_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutL_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutL_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "			\n");
		}
	}
	fprintf(outFile, "			CLK							: in	std_logic;\n");
	fprintf(outFile, "			RST							: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "	\n");
}
//--^-- fprintfNocComponentDeclarationControlNetwork --------------------------

//--v-- fprintfNocSignals -----------------------------------------------------
void fprintfNocSignals(FILE *outFile) {
	int i, r, c;
	
	fprintf(outFile, "	signal namedSignal_Clk				: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_Rst				: std_logic;\n");
	fprintf(outFile, "\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutE_%d_AllocatedInput			: std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutE_%d_AllocatedInputIndex	: std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutW_%d_AllocatedInput			: std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutW_%d_AllocatedInputIndex	: std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutN_%d_AllocatedInput			: std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutN_%d_AllocatedInputIndex	: std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutS_%d_AllocatedInput			: std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutS_%d_AllocatedInputIndex	: std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutL_%d_AllocatedInput			: std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_OutL_%d_AllocatedInputIndex	: std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}
			fprintf(outFile, "\n");
		}
	}
}
//--^-- fprintfNocSignals -----------------------------------------------------

//--v-- fprintfNocComponentInstantiateDataNetwork -----------------------------
void fprintfNocComponentInstantiateDataNetwork(FILE *outFile) {
	int i, r, c;

	fprintf(outFile, "	U_dataNetwork : dataNetwork\n");
	fprintf(outFile, "		port map\n");
	fprintf(outFile, "		(\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "			router_%d_%d_InL				=> router_%d_%d_InL,\n", r, c, r, c);
			fprintf(outFile, "			router_%d_%d_OutL				=> router_%d_%d_OutL,\n", r, c, r, c);
			fprintf(outFile, "			\n");
		}
	}
	fprintf(outFile, "\n");
	fprintf(outFile, "			--CFGLUT5\n");
	fprintf(outFile, "			CE_fsl_exist				=> CE_fsl_exist,\n");
	fprintf(outFile, "			CE_fsl_allRouter			=> CE_fsl_allRouter,\n");
	fprintf(outFile, "			CE_fsl_Read					=> CE_fsl_Read,\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			CDI_fsl_exist				=> CDI_fsl_exist,\n");
	fprintf(outFile, "			CDI_fsl_allRouter			=> CDI_fsl_allRouter,\n");
	fprintf(outFile, "			CDI_fsl_Read				=> CDI_fsl_Read,\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			Programming_inProgress      => Programming_inProgress,\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			CLK			=> namedSignal_Clk,\n");
	fprintf(outFile, "			RST			=> namedSignal_Rst\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNocComponentInstantiateDataNetwork -----------------------------

//--v-- fprintfNocComponentInstantiateControlNetwork --------------------------
void fprintfNocComponentInstantiateControlNetwork(FILE *outFile) {
	int i, r, c;
	
	fprintf(outFile, "	U_controlNetwork : controlNetwork\n");
	fprintf(outFile, "		port map\n");
	fprintf(outFile, "		(\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			if((r == 0) && (c == 0)) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_setupIn			=> setupFsmRouter_%d_%d_setupIn,\n", r, c, r, c);
				fprintf(outFile, "			setupFsmRouter_%d_%d_setupInNew		=> setupFsmRouter_%d_%d_setupInNew,\n", r, c, r, c);
				fprintf(outFile, "			setupFsmRouter_%d_%d_setupInNewAck	=> setupFsmRouter_%d_%d_setupInNewAck,\n", r, c, r, c);
				fprintf(outFile, "			\n");
			}
			
			fprintf(outFile, "			setupFsmRouter_%d_%d_setupOutL		=> setupFsmRouter_%d_%d_setupOutL,\n", r, c, r, c);
			fprintf(outFile, "			setupFsmRouter_%d_%d_setupOutLNew		=> setupFsmRouter_%d_%d_setupOutLNew,\n", r, c, r, c);
			fprintf(outFile, "			setupFsmRouter_%d_%d_setupOutLNewAck	=> setupFsmRouter_%d_%d_setupOutLNewAck,\n", r, c, r, c);
			fprintf(outFile, "			\n");
			
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutE_%d_AllocatedInput			=> namedSignal_setupFsmRouter_%d_%d_OutE_%d_AllocatedInput,\n", r, c, i, r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutE_%d_AllocatedInputIndex		=> namedSignal_setupFsmRouter_%d_%d_OutE_%d_AllocatedInputIndex,\n", r, c, i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutW_%d_AllocatedInput			=> namedSignal_setupFsmRouter_%d_%d_OutW_%d_AllocatedInput,\n", r, c, i, r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutW_%d_AllocatedInputIndex		=> namedSignal_setupFsmRouter_%d_%d_OutW_%d_AllocatedInputIndex,\n", r, c, i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutN_%d_AllocatedInput			=> namedSignal_setupFsmRouter_%d_%d_OutN_%d_AllocatedInput,\n", r, c, i, r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutN_%d_AllocatedInputIndex		=> namedSignal_setupFsmRouter_%d_%d_OutN_%d_AllocatedInputIndex,\n", r, c, i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutS_%d_AllocatedInput			=> namedSignal_setupFsmRouter_%d_%d_OutS_%d_AllocatedInput,\n", r, c, i, r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutS_%d_AllocatedInputIndex		=> namedSignal_setupFsmRouter_%d_%d_OutS_%d_AllocatedInputIndex,\n", r, c, i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutL_%d_AllocatedInput			=> namedSignal_setupFsmRouter_%d_%d_OutL_%d_AllocatedInput,\n", r, c, i, r, c, i);
				fprintf(outFile, "			setupFsmRouter_%d_%d_OutL_%d_AllocatedInputIndex		=> namedSignal_setupFsmRouter_%d_%d_OutL_%d_AllocatedInputIndex,\n", r, c, i, r, c, i);
			}
			fprintf(outFile, "			\n");
		}
	}
	fprintf(outFile, "			CLK				=> namedSignal_Clk,\n");
	fprintf(outFile, "			RST				=> namedSignal_Rst\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfNocComponentInstantiateControlNetwork --------------------------

//--v-- generateVhdlControlNetwork --------------------------------------------
void generateVhdlControlNetwork(void) {
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating controlNetwork.vhd...");
	#endif
	
	outFile = fopen("generated/controlNetwork.vhd", "w");
	
	fprintf(outFile, "-- VHDL for controlNetwork\n");
	fprintf(outFile, "-- Joseph Yang\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "\n");
	fprintfControlNetworkEntityDeclaration(outFile);
	
	fprintf(outFile, "architecture structure of controlNetwork is\n");

	fprintfControlNetworkComponentDeclarationSetupFsmRouter(outFile);
	
	fprintf(outFile, "	signal namedSignal_Clk				: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_Rst				: std_logic;\n");
	fprintf(outFile, "\n");
	fprintfControlNetworkSignalsSetupFsmRouter(outFile);
	
	fprintf(outFile, "begin\n");
	
	fprintfControlNetworkComponentInstantiateSetupFsmRouter(outFile);
	
	fprintfControlNetworkSignalAssignments(outFile);
	
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlControlNetwork --------------------------------------------

//--v-- fprintfControlNetworkEntityDeclaration --------------------------------
void fprintfControlNetworkEntityDeclaration(FILE *outFile) {
	int i, r, c;
	
	fprintf(outFile, "entity controlNetwork is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			if((r == 0) && (c == 0)) {
				fprintf(outFile, "		setupFsmRouter_%d_%d_setupIn			: in	std_logic_vector(7 downto 0);\n", r, c);
				fprintf(outFile, "		setupFsmRouter_%d_%d_setupInNew		: in	std_logic;\n", r, c);
				fprintf(outFile, "		setupFsmRouter_%d_%d_setupInNewAck	: out	std_logic;\n", r, c);
			}
			fprintf(outFile, "		setupFsmRouter_%d_%d_setupOutL		: out	std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "		setupFsmRouter_%d_%d_setupOutLNew		: out	std_logic;\n", r, c);
			fprintf(outFile, "		setupFsmRouter_%d_%d_setupOutLNewAck	: in	std_logic;\n", r, c);
			fprintf(outFile, "		\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutE_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutE_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutW_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutW_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutN_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutN_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutS_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutS_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutL_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", r, c, i);
				fprintf(outFile, "		setupFsmRouter_%d_%d_OutL_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", r, c, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
			}                        
			fprintf(outFile, "		\n");
		}
	}
	fprintf(outFile, "		CLK							: in	std_logic;\n");
	fprintf(outFile, "		RST							: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end controlNetwork;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfControlNetworkEntityDeclaration --------------------------------

//--v-- fprintfControlNetworkComponentDeclarationSetupFsmRouter -------------------------
void fprintfControlNetworkComponentDeclarationSetupFsmRouter(FILE *outFile) {
	int i;
	
	fprintf(outFile, "	component setupFsmRouter is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			setupIn			: in	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "			setupInNew		: in	std_logic;\n");
	fprintf(outFile, "			setupInNewAck	: out	std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			setupOutN		: out	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "			setupOutNNew	: out	std_logic;\n");
	fprintf(outFile, "			setupOutNNewAck	: in	std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			setupOutE		: out	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "			setupOutENew	: out	std_logic;\n");
	fprintf(outFile, "			setupOutENewAck	: in	std_logic;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			setupOutL		: out	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "			setupOutLNew	: out	std_logic;\n");
	fprintf(outFile, "			setupOutLNewAck	: in	std_logic;\n");
	fprintf(outFile, "			\n");
	
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutE_%d_AllocatedInput			: out std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "			OutE_%d_AllocatedInputIndex		: out std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutW_%d_AllocatedInput			: out std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "			OutW_%d_AllocatedInputIndex		: out std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutN_%d_AllocatedInput			: out std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "			OutN_%d_AllocatedInputIndex		: out std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutS_%d_AllocatedInput			: out std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "			OutS_%d_AllocatedInputIndex		: out std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutL_%d_AllocatedInput			: out std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "			OutL_%d_AllocatedInputIndex		: out std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	
	fprintf(outFile, "			\n");
	fprintf(outFile, "			thisRow			: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "			thisCol			: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "			\n");                         
	fprintf(outFile, "			CLK				: in	std_logic;\n");
	fprintf(outFile, "			RST				: in	std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfControlNetworkComponentDeclarationSetupFsmRouter ---------------

//--v-- fprintfControlNetworkSignalsSetupFsmRouter ----------------------------
void fprintfControlNetworkSignalsSetupFsmRouter(FILE *outFile) {
	int r, c;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupIn			: std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupInNew		: std_logic;\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupInNewAck		: std_logic;\n", r, c);
			fprintf(outFile, "	\n");
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutN			: std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutNNew		: std_logic;\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutNNewAck	: std_logic;\n", r, c);
			fprintf(outFile, "	\n");
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutE			: std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutENew		: std_logic;\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutENewAck	: std_logic;\n", r, c);
			fprintf(outFile, "	\n");
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutL			: std_logic_vector(7 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutLNew		: std_logic;\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_setupOutLNewAck	: std_logic;\n", r, c);
			fprintf(outFile, "	\n");
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_thisRow			: std_logic_vector(2 downto 0);\n", r, c);
			fprintf(outFile, "	signal namedSignal_setupFsmRouter_%d_%d_thisCol			: std_logic_vector(2 downto 0);\n", r, c);
			fprintf(outFile, "	\n");
		}
	}
}
//--^-- fprintfControlNetworkSignalsSetupFsmRouter ----------------------------

//--v-- fprintfControlNetworkComponentInstantiateSetupFsmRouter ---------------
void fprintfControlNetworkComponentInstantiateSetupFsmRouter(FILE *outFile) {
	int i, r, c;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "	U_setupFsmRouter_%d_%d : setupFsmRouter\n", r, c);
			fprintf(outFile, "		port map\n");
			fprintf(outFile, "		(\n");
			fprintf(outFile, "			setupIn			=> namedSignal_setupFsmRouter_%d_%d_setupIn,\n", r, c);
			fprintf(outFile, "			setupInNew		=> namedSignal_setupFsmRouter_%d_%d_setupInNew,\n", r, c);
			fprintf(outFile, "			setupInNewAck	=> namedSignal_setupFsmRouter_%d_%d_setupInNewAck,\n", r, c);
			fprintf(outFile, "			\n");
			fprintf(outFile, "			setupOutN		=> namedSignal_setupFsmRouter_%d_%d_setupOutN,\n", r, c);
			fprintf(outFile, "			setupOutNNew	=> namedSignal_setupFsmRouter_%d_%d_setupOutNNew,\n", r, c);
			fprintf(outFile, "			setupOutNNewAck	=> namedSignal_setupFsmRouter_%d_%d_setupOutNNewAck,\n", r, c);
			fprintf(outFile, "			\n");
			fprintf(outFile, "			setupOutE		=> namedSignal_setupFsmRouter_%d_%d_setupOutE,\n", r, c);
			fprintf(outFile, "			setupOutENew	=> namedSignal_setupFsmRouter_%d_%d_setupOutENew,\n", r, c);
			fprintf(outFile, "			setupOutENewAck	=> namedSignal_setupFsmRouter_%d_%d_setupOutENewAck,\n", r, c);
			fprintf(outFile, "			\n");
			fprintf(outFile, "			setupOutL		=> namedSignal_setupFsmRouter_%d_%d_setupOutL,\n", r, c);
			fprintf(outFile, "			setupOutLNew	=> namedSignal_setupFsmRouter_%d_%d_setupOutLNew,\n", r, c);
			fprintf(outFile, "			setupOutLNewAck	=> namedSignal_setupFsmRouter_%d_%d_setupOutLNewAck,\n", r, c);
			fprintf(outFile, "			\n");
			
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			OutE_%d_AllocatedInput			=> setupFsmRouter_%d_%d_OutE_%d_AllocatedInput,\n", i, r, c, i);
				fprintf(outFile, "			OutE_%d_AllocatedInputIndex		=> setupFsmRouter_%d_%d_OutE_%d_AllocatedInputIndex,\n", i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			OutW_%d_AllocatedInput			=> setupFsmRouter_%d_%d_OutW_%d_AllocatedInput,\n", i, r, c, i);
				fprintf(outFile, "			OutW_%d_AllocatedInputIndex		=> setupFsmRouter_%d_%d_OutW_%d_AllocatedInputIndex,\n", i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			OutN_%d_AllocatedInput			=> setupFsmRouter_%d_%d_OutN_%d_AllocatedInput,\n", i, r, c, i);
				fprintf(outFile, "			OutN_%d_AllocatedInputIndex		=> setupFsmRouter_%d_%d_OutN_%d_AllocatedInputIndex,\n", i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			OutS_%d_AllocatedInput			=> setupFsmRouter_%d_%d_OutS_%d_AllocatedInput,\n", i, r, c, i);
				fprintf(outFile, "			OutS_%d_AllocatedInputIndex		=> setupFsmRouter_%d_%d_OutS_%d_AllocatedInputIndex,\n", i, r, c, i);
			}
			fprintf(outFile, "\n");
			for(i = 0; i < WIRES_PER_PORT; i++) {
				fprintf(outFile, "			OutL_%d_AllocatedInput			=> setupFsmRouter_%d_%d_OutL_%d_AllocatedInput,\n", i, r, c, i);
				fprintf(outFile, "			OutL_%d_AllocatedInputIndex		=> setupFsmRouter_%d_%d_OutL_%d_AllocatedInputIndex,\n", i, r, c, i);
			}
			fprintf(outFile, "			\n");
			fprintf(outFile, "			thisRow			=> namedSignal_setupFsmRouter_%d_%d_thisRow,\n", r, c);
			fprintf(outFile, "			thisCol			=> namedSignal_setupFsmRouter_%d_%d_thisCol,\n", r, c);
			fprintf(outFile, "			\n");
			fprintf(outFile, "			CLK				=> namedSignal_Clk,\n");
			fprintf(outFile, "			RST				=> namedSignal_Rst\n");
			fprintf(outFile, "		);\n");
			fprintf(outFile, "\n");
		}
	}
}                   
//--^-- fprintfControlNetworkComponentInstantiateSetupFsmRouter ---------------

//--v-- fprintfControlNetworkSignalAssignments --------------------------------
void fprintfControlNetworkSignalAssignments(FILE *outFile) {
	int r, c;
	unsigned char tempStr[WIRES_PER_PORT+1];
/* unused signals
namedSignal_node_0_0_OutW
namedSignal_node_0_0_OutS
namedSignal_node_0_1_OutS
namedSignal_node_0_2_OutS
namedSignal_node_0_3_OutE
namedSignal_node_0_3_OutS
namedSignal_node_1_0_OutW
namedSignal_node_1_3_OutE
namedSignal_node_2_0_OutW
namedSignal_node_2_3_OutE
namedSignal_node_3_0_OutW
namedSignal_node_3_0_OutN
namedSignal_node_3_1_OutN
namedSignal_node_3_2_OutN
namedSignal_node_3_3_OutE
namedSignal_node_3_3_OutN
*/

	decToBin(0, WIRES_PER_PORT, tempStr);
	
	fprintf(outFile, "	-- Signal Assignments\n");
	
	fprintf(outFile, "	namedSignal_Clk	<= CLK;\n");
	fprintf(outFile, "	namedSignal_Rst	<= RST;\n");
	fprintf(outFile, "\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			if((r == 0) && (c == 0)) {
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupIn			<= setupFsmRouter_%d_%d_setupIn;\n", r, c, r, c);
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupInNew			<= setupFsmRouter_%d_%d_setupInNew;\n", r, c, r, c);
				fprintf(outFile, "	setupFsmRouter_%d_%d_setupInNewAck					<= namedSignal_setupFsmRouter_%d_%d_setupInNewAck;\n", r, c, r, c);
			}
			else if((r != 0) && (c == 0)) {
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupIn			<= namedSignal_setupFsmRouter_%d_%d_setupOutN;\n", r, c, r-1, c);
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupInNew			<= namedSignal_setupFsmRouter_%d_%d_setupOutNNew;\n", r, c, r-1, c);
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupOutNNewAck	<= namedSignal_setupFsmRouter_%d_%d_setupInNewAck;\n", r-1, c, r, c);
			}
			else {
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupIn			<= namedSignal_setupFsmRouter_%d_%d_setupOutE;\n", r, c, r, c-1);
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupInNew			<= namedSignal_setupFsmRouter_%d_%d_setupOutENew;\n", r, c, r, c-1);
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupOutENewAck	<= namedSignal_setupFsmRouter_%d_%d_setupInNewAck;\n", r, c-1, r, c);
			}
			
			if((c != 0) || (r == ROW_MAX-1)) {
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupOutNNewAck	<= namedSignal_setupFsmRouter_%d_%d_setupOutNNew;\n", r, c, r, c);
			}
			if(c == COL_MAX-1) {
				fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupOutENewAck	<= namedSignal_setupFsmRouter_%d_%d_setupOutENew;\n", r, c, r, c);
			}
			fprintf(outFile, "	setupFsmRouter_%d_%d_setupOutL						<= namedSignal_setupFsmRouter_%d_%d_setupOutL;\n", r, c, r, c);
			fprintf(outFile, "	setupFsmRouter_%d_%d_setupOutLNew					<= namedSignal_setupFsmRouter_%d_%d_setupOutLNew;\n", r, c, r, c);
			fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_setupOutLNewAck	<= setupFsmRouter_%d_%d_setupOutLNewAck;\n", r, c, r, c);
			decToBin(r, 3, tempStr);
			fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_thisRow			<= \"%s\";\n", r, c, tempStr);
			decToBin(c, 3, tempStr);
			fprintf(outFile, "	namedSignal_setupFsmRouter_%d_%d_thisCol			<= \"%s\";\n", r, c, tempStr);
			fprintf(outFile, "	\n");
		}
	}
	
	fprintf(outFile, "\n");
}
//--^-- fprintfControlNetworkSignalAssignments --------------------------------

//--v-- generateVhdlDataNetwork -----------------------------------------------
void generateVhdlDataNetwork(void) {
	FILE *outFile;
	int numOfRouters = ROW_MAX*COL_MAX;
	int totalCEbits = numOfRouters*5;
	
	#ifdef DEBUG
		printf("Generating dataNetwork.vhd...");
	#endif
	
	outFile = fopen("generated/dataNetwork.vhd", "w");
	
	fprintf(outFile, "-- VHDL for dataNetwork\n");
	fprintf(outFile, "-- Vignesh Prakasam\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "\n");
	fprintfDataNetworkEntityDeclaration(outFile);
	
	fprintf(outFile, "architecture structure of dataNetwork is\n");

	fprintfDataNetworkComponentDeclarationRouter(outFile);
	
	fprintf(outFile, "	signal namedSignal_Clk				: std_logic;\n");
	fprintf(outFile, "	signal namedSignal_Rst				: std_logic;\n");
	fprintf(outFile, "\n");
	fprintfDataNetworkSignalsRouter(outFile);
	
	fprintf(outFile, "	signal CE_allRouter                                : std_logic_vector (%d downto 0) := (others => '0');\n",totalCEbits-1);
	fprintf(outFile, "	signal CE_allRouter_router                        : std_logic_vector (%d downto 0) := (others => '0');\n",totalCEbits-1);
	fprintf(outFile, "	signal CDI_allRouter                                : std_logic := '0';\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "	signal Serializer_idle                            : std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "	signal CE_fsl_read_prev                           : std_logic;\n");

	fprintf(outFile, "begin\n");
	
	fprintfDataNetworkComponentInstantiateRouter(outFile);
	
	fprintfDataNetworkSignalAssignments(outFile);
	
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlDataNetwork -----------------------------------------------

//--v-- fprintfDataNetworkEntityDeclaration -----------------------------------
void fprintfDataNetworkEntityDeclaration(FILE *outFile) {
	int i, r, c;
	int numOfRouters = ROW_MAX*COL_MAX;
	int totalCEbits = numOfRouters*5;
	int bitsNeeded = 0;
	if(totalCEbits<=256 && totalCEbits>128){
		bitsNeeded = 256;
	}
	else if(totalCEbits<=128 && totalCEbits>64){
		bitsNeeded = 128;
	}
	else if(totalCEbits<=64 && totalCEbits>32){
		bitsNeeded = 64;
	}
	else if(totalCEbits<=32 && totalCEbits>16){
		bitsNeeded = 32;
	}
	else{
		bitsNeeded = 16;
	}

	fprintf(outFile, "entity dataNetwork is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "		router_%d_%d_InL				: in	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "		router_%d_%d_OutL				: out	std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "		\n");
		}
	}
	fprintf(outFile, "		--CFGLUT5\n");
	fprintf(outFile, "		CE_fsl_exist: in std_logic;\n");
	fprintf(outFile, "		CE_fsl_allRouter : in    std_logic_vector(%d downto 0);\n",bitsNeeded-1);
	fprintf(outFile, "		CE_fsl_Read : out std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CDI_fsl_exist    : in std_logic;\n");
	fprintf(outFile, "		CDI_fsl_allRouter : in std_logic_vector(31 downto 0);\n");
	fprintf(outFile, "		CDI_fsl_Read : out std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		Programming_inProgress : out std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK							: in	std_logic;\n");
	fprintf(outFile, "		RST							: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end dataNetwork;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfDataNetworkEntityDeclaration -----------------------------------

//--v-- fprintfDataNetworkComponentDeclarationRouter --------------------------
void fprintfDataNetworkComponentDeclarationRouter(FILE *outFile) {
	int i,r,c;

	fprintf(outFile, "	component niSerializer is\n");
	fprintf(outFile, "		port\n");
	fprintf(outFile, "		(\n");
	fprintf(outFile, "			dataToSend            : in    std_logic_vector(31 downto 0);\n");
	fprintf(outFile, "			dataToSendNew        : in    std_logic;\n");
	fprintf(outFile, "			dataToSendNewAck    : out    std_logic;\n");
	fprintf(outFile, "			output                : out    std_logic;\n");
	fprintf(outFile, "			idle                : out    std_logic;\n");
	fprintf(outFile, "			CLK                    : in    std_logic;\n");
	fprintf(outFile, "			RST                    : in    std_logic\n");
	fprintf(outFile, "		);\n");
	fprintf(outFile, "	end component;\n");
	fprintf(outFile, "\n");

	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "	component router_%d_%d is\n",r,c);
			fprintf(outFile, "		port\n");
			fprintf(outFile, "		(\n");

			fprintf(outFile, "			InE			: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			InW			: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			InN			: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			InS			: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			InL			: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			OutE		: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			OutW		: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			OutN		: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			OutS		: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			OutL		: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
			fprintf(outFile, "			\n");
			fprintf(outFile, "			--CFGLUT5\n");
			fprintf(outFile, "			CE_%d%d : in    std_logic_vector(4 downto 0);\n",r,c);
			fprintf(outFile, "			CDI   : in std_logic;\n");
			fprintf(outFile, "			\n");
			fprintf(outFile, "			CLK			: in	std_logic;\n");
			fprintf(outFile, "			RST			: in	std_logic\n");
			fprintf(outFile, "		);\n");
			fprintf(outFile, "	end component;\n");
			fprintf(outFile, "\n");
		}
	}

}
//--^-- fprintfDataNetworkComponentDeclarationRouter --------------------------

//--v-- fprintfDataNetworkSignalsRouter ---------------------------------------
void fprintfDataNetworkSignalsRouter(FILE *outFile) {
	int r, c;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "	signal namedSignal_router_%d_%d_InE			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_router_%d_%d_InW			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_router_%d_%d_InN			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_router_%d_%d_InS			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_router_%d_%d_OutE			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_router_%d_%d_OutW			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_router_%d_%d_OutN			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	signal namedSignal_router_%d_%d_OutS			: std_logic_vector(%d downto 0);\n", r, c, WIRES_PER_PORT-1);
			fprintf(outFile, "	\n");
		}
	}
}
//--^-- fprintfDataNetworkSignalsRouter ---------------------------------------

//--v-- fprintfDataNetworkComponentInstantiateRouter --------------------------
void fprintfDataNetworkComponentInstantiateRouter(FILE *outFile) {
	int i, r, c;
	int numOfRouters = ROW_MAX*COL_MAX;
	int totalCEbits = numOfRouters*5;

	int LSBce = 0;
	int MSBce = 0;
	
	fprintf(outFile, "	CE_store: process (CLK, RST)\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "	  if (RST = '0') then\n");
	fprintf(outFile, "		CE_allRouter <= (others => '0');\n");
	fprintf(outFile, "		CE_fsl_Read <= '0'; \n");
	fprintf(outFile, "		Programming_inProgress <= '0';\n");
	fprintf(outFile, "	  elsif (CLK'event and CLK= '1') then\n");
	fprintf(outFile, "		CE_fsl_Read <= '0';\n");
	fprintf(outFile, "		if (CE_fsl_exist = '1') then\n");
	fprintf(outFile, "			CE_allRouter <= CE_fsl_allRouter(%d downto 0);\n",totalCEbits-1);
	fprintf(outFile, "			Programming_inProgress <= CE_fsl_allRouter(%d);\n",totalCEbits);
	fprintf(outFile, "			CE_fsl_Read <= '1';\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	  end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "	CE_allRouter_router <= CE_allRouter when (Serializer_idle = '0') else (others => '0');\n");
	fprintf(outFile, "\n");

	fprintf(outFile, "	CDI_Serializer : niSerializer\n");
	fprintf(outFile, "	port map\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		dataToSend            => CDI_fsl_allRouter,\n");
	fprintf(outFile, "		dataToSendNew        => CDI_fsl_exist,\n");
	fprintf(outFile, "		dataToSendNewAck    => CDI_fsl_Read,\n");
	fprintf(outFile, "		output                => CDI_allRouter,\n");
	fprintf(outFile, "		idle                    => Serializer_idle,\n");
	fprintf(outFile, "		CLK                     => namedSignal_Clk,\n");
	fprintf(outFile, "		RST                    => namedSignal_Rst\n");
	fprintf(outFile, "	 );\n");

	fprintf(outFile, "\n");

	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			MSBce=LSBce+4;
			fprintf(outFile, "	U_router_%d_%d : router_%d_%d\n", r, c, r, c);
			fprintf(outFile, "		port map\n");
			fprintf(outFile, "		(\n");
			fprintf(outFile, "			InE			=> namedSignal_router_%d_%d_InE,\n", r, c);
			fprintf(outFile, "			InW			=> namedSignal_router_%d_%d_InW,\n", r, c);
			fprintf(outFile, "			InN			=> namedSignal_router_%d_%d_InN,\n", r, c);
			fprintf(outFile, "			InS			=> namedSignal_router_%d_%d_InS,\n", r, c);
			fprintf(outFile, "			InL			=> router_%d_%d_InL,\n", r, c);
			fprintf(outFile, "			\n");
			fprintf(outFile, "			OutE		=> namedSignal_router_%d_%d_OutE,\n", r, c);
			fprintf(outFile, "			OutW		=> namedSignal_router_%d_%d_OutW,\n", r, c);
			fprintf(outFile, "			OutN		=> namedSignal_router_%d_%d_OutN,\n", r, c);
			fprintf(outFile, "			OutS		=> namedSignal_router_%d_%d_OutS,\n", r, c);
			fprintf(outFile, "			OutL		=> router_%d_%d_OutL,\n", r, c);
			fprintf(outFile, "			\n");
			fprintf(outFile, "			--CFGLUT5\n");
			fprintf(outFile, "			CE_%d%d            => CE_allRouter_router(%d downto %d),\n",r,c,MSBce,LSBce);
			fprintf(outFile, "			CDI            => CDI_allRouter,\n");
			fprintf(outFile, "			\n");
			fprintf(outFile, "			CLK			=> namedSignal_Clk,\n");
			fprintf(outFile, "			RST			=> namedSignal_Rst\n");
			fprintf(outFile, "		);\n");
			fprintf(outFile, "\n");
			LSBce=MSBce+1;
		}
	}
}
//--^-- fprintfDataNetworkComponentInstantiateRouter --------------------------

//--v-- fprintfDataNetworkSignalAssignments -----------------------------------
void fprintfDataNetworkSignalAssignments(FILE *outFile) {
	int r, c;
	unsigned char tempStr[WIRES_PER_PORT+1];
/* unused signals
namedSignal_node_0_0_OutW
namedSignal_node_0_0_OutS
namedSignal_node_0_1_OutS
namedSignal_node_0_2_OutS
namedSignal_node_0_3_OutE
namedSignal_node_0_3_OutS
namedSignal_node_1_0_OutW
namedSignal_node_1_3_OutE
namedSignal_node_2_0_OutW
namedSignal_node_2_3_OutE
namedSignal_node_3_0_OutW
namedSignal_node_3_0_OutN
namedSignal_node_3_1_OutN
namedSignal_node_3_2_OutN
namedSignal_node_3_3_OutE
namedSignal_node_3_3_OutN
*/

	decToBin(0, WIRES_PER_PORT, tempStr);
	
	fprintf(outFile, "	-- Signal Assignments\n");
	
	fprintf(outFile, "	namedSignal_Clk	<= CLK;\n");
	fprintf(outFile, "	namedSignal_Rst	<= RST;\n");
	fprintf(outFile, "\n");
	
	decToBin(0, WIRES_PER_PORT, tempStr);
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX-1; c++) {
			fprintf(outFile, "	namedSignal_router_%d_%d_InE	<= namedSignal_router_%d_%d_OutW;\n", r, c, r, c+1);
		}
		fprintf(outFile, "	namedSignal_router_%d_%d_InE	<= \"%s\";\n", r, COL_MAX-1, tempStr);
	}

	for(r = 0; r < ROW_MAX; r++) {
		fprintf(outFile, "	namedSignal_router_%d_%d_InW	<= \"%s\";\n", r, 0, tempStr);
		for(c = 1; c < COL_MAX; c++) {
			fprintf(outFile, "	namedSignal_router_%d_%d_InW	<= namedSignal_router_%d_%d_OutE;\n", r, c, r, c-1);
		}
	}

	for(r = 0; r < ROW_MAX-1; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "	namedSignal_router_%d_%d_InN	<= namedSignal_router_%d_%d_OutS;\n", r, c, r+1, c);
		}
	}
	for(c = 0; c < COL_MAX; c++) {
		fprintf(outFile, "	namedSignal_router_%d_%d_InN	<= \"%s\";\n", ROW_MAX-1, c, tempStr);
	}
	
	for(c = 0; c < COL_MAX; c++) {
		fprintf(outFile, "	namedSignal_router_%d_%d_InS	<= \"%s\";\n", 0, c, tempStr);
	}
	for(r = 1; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "	namedSignal_router_%d_%d_InS	<= namedSignal_router_%d_%d_OutN;\n", r, c, r-1, c);
		}
	}
	
	fprintf(outFile, "\n");
}
//--^-- fprintfDataNetworkSignalAssignments -----------------------------------

//--v-- generateVhdlRouter ----------------------------------------------------
void generateVhdlRouter(void) {
	unsigned char tempStr[WIRES_PER_PORT+1];
	int r,c,i;
	char buffer[32];
	FILE *outFile;
	for(r=0;r<ROW_MAX;r++){
		for(c=0;c<COL_MAX;c++){
			#ifdef DEBUG
				printf("Generating router_%d_%d.vhd...",r,c);
			#endif
			sprintf(buffer, "generated/router_%d_%d.vhd",r,c);
			outFile = fopen(buffer, "w");
			//outFile = fopen("generated/router_0_0.vhd", "w");

			fprintf(outFile, "-- VHDL for router\n");
			fprintf(outFile, "-- Vignesh Prakasam\n\n");
			fprintf(outFile, "library	IEEE;\n");
			fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
			fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
			fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
			fprintf(outFile, "\n");
			fprintf(outFile, "Library UNISIM;\n");
			fprintf(outFile, "use UNISIM.vcomponents.all;\n");

			fprintfRouterEntityDeclaration(outFile,r,c);

			fprintf(outFile, "architecture structure of router_%d_%d is\n",r,c);

			fprintf(outFile, "		signal CDO_7 : std_logic;\n");//have to verify
			fprintf(outFile, "		signal CDO_6 : std_logic;\n");
			fprintf(outFile, "		signal CDO_5 : std_logic;\n");
			fprintf(outFile, "		signal CDO_4 : std_logic;\n");
			fprintf(outFile, "		signal CDO_3 : std_logic;\n");
			fprintf(outFile, "		signal CDO_2 : std_logic;\n");
			fprintf(outFile, "		signal CDO_1 : std_logic;\n");
			fprintf(outFile, "		signal CDO_0 : std_logic;\n");

			fprintf(outFile, "begin\n");
			fprintf(outFile, "\n");
			fprintf(outFile, "		--OutE\n");
			for(i= WIRES_PER_PORT-1;i>=0;i--){
				fprintf(outFile, "		CFGLUT5_inst_r%d%d_OutE_%d : CFGLUT5\n",r,c,i);//start editing here
				fprintf(outFile, "		generic map (\n");
				fprintf(outFile, "			INIT => X'00000000')\n");
				fprintf(outFile, "		port map (\n");
				fprintf(outFile, "			CDO => CDO_%d, -- Reconfiguration cascade output\n",i);
				fprintf(outFile, "			O5 => open, -- 4-LUT output\n");
				fprintf(outFile, "			O6 => OutE(%d), -- 5-LUT output\n",i);
				fprintf(outFile, "			CDI => CDI, -- Reconfiguration data input\n");
				fprintf(outFile, "			CE => CE_%d%d(0), -- Reconfiguration enable input\n",r,c);
				fprintf(outFile, "			CLK => CLK, -- Clock input\n");
				fprintf(outFile, "			I0 => InE(%d),\n",i);
				fprintf(outFile, "			I1 => InW(%d),\n",i);
				fprintf(outFile, "			I2 => InN(%d),\n",i);
				fprintf(outFile, "			I3 => InS(%d),\n",i);
				fprintf(outFile, "			I4 => InL(%d)\n",i);
				fprintf(outFile, "		);\n");
			}
			fprintf(outFile, "\n");
			fprintf(outFile, "		--OutW\n");
			for(i= WIRES_PER_PORT-1;i>=0;i--){
				fprintf(outFile, "		CFGLUT5_inst_r%d%d_OutW_%d : CFGLUT5\n",r,c,i);//start editing here
				fprintf(outFile, "		generic map (\n");
				fprintf(outFile, "			INIT => X'00000000')\n");
				fprintf(outFile, "		port map (\n");
				fprintf(outFile, "			CDO => CDO_%d, -- Reconfiguration cascade output\n",i);
				fprintf(outFile, "			O5 => open, -- 4-LUT output\n");
				fprintf(outFile, "			O6 => OutW(%d), -- 5-LUT output\n",i);
				fprintf(outFile, "			CDI => CDI, -- Reconfiguration data input\n");
				fprintf(outFile, "			CE => CE_%d%d(1), -- Reconfiguration enable input\n",r,c);
				fprintf(outFile, "			CLK => CLK, -- Clock input\n");
				fprintf(outFile, "			I0 => InE(%d),\n",i);
				fprintf(outFile, "			I1 => InW(%d),\n",i);
				fprintf(outFile, "			I2 => InN(%d),\n",i);
				fprintf(outFile, "			I3 => InS(%d),\n",i);
				fprintf(outFile, "			I4 => InL(%d)\n",i);
				fprintf(outFile, "		);\n");
			}
			fprintf(outFile, "\n");
			fprintf(outFile, "		--OutN\n");
			for(i= WIRES_PER_PORT-1;i>=0;i--){
				fprintf(outFile, "		CFGLUT5_inst_r%d%d_OutN_%d : CFGLUT5\n",r,c,i);//start editing here
				fprintf(outFile, "		generic map (\n");
				fprintf(outFile, "			INIT => X'00000000')\n");
				fprintf(outFile, "		port map (\n");
				fprintf(outFile, "			CDO => CDO_%d, -- Reconfiguration cascade output\n",i);
				fprintf(outFile, "			O5 => open, -- 4-LUT output\n");
				fprintf(outFile, "			O6 => OutN(%d), -- 5-LUT output\n",i);
				fprintf(outFile, "			CDI => CDI, -- Reconfiguration data input\n");
				fprintf(outFile, "			CE => CE_%d%d(2), -- Reconfiguration enable input\n",r,c);
				fprintf(outFile, "			CLK => CLK, -- Clock input\n");
				fprintf(outFile, "			I0 => InE(%d),\n",i);
				fprintf(outFile, "			I1 => InW(%d),\n",i);
				fprintf(outFile, "			I2 => InN(%d),\n",i);
				fprintf(outFile, "			I3 => InS(%d),\n",i);
				fprintf(outFile, "			I4 => InL(%d)\n",i);
				fprintf(outFile, "		);\n");
			}
			fprintf(outFile, "\n");
			fprintf(outFile, "		--OutS\n");
			for(i= WIRES_PER_PORT-1;i>=0;i--){
				fprintf(outFile, "		CFGLUT5_inst_r%d%d_OutS_%d : CFGLUT5\n",r,c,i);//start editing here
				fprintf(outFile, "		generic map (\n");
				fprintf(outFile, "			INIT => X'00000000')\n");
				fprintf(outFile, "		port map (\n");
				fprintf(outFile, "			CDO => CDO_%d, -- Reconfiguration cascade output\n",i);
				fprintf(outFile, "			O5 => open, -- 4-LUT output\n");
				fprintf(outFile, "			O6 => OutS(%d), -- 5-LUT output\n",i);
				fprintf(outFile, "			CDI => CDI, -- Reconfiguration data input\n");
				fprintf(outFile, "			CE => CE_%d%d(3), -- Reconfiguration enable input\n",r,c);
				fprintf(outFile, "			CLK => CLK, -- Clock input\n");
				fprintf(outFile, "			I0 => InE(%d),\n",i);
				fprintf(outFile, "			I1 => InW(%d),\n",i);
				fprintf(outFile, "			I2 => InN(%d),\n",i);
				fprintf(outFile, "			I3 => InS(%d),\n",i);
				fprintf(outFile, "			I4 => InL(%d)\n",i);
				fprintf(outFile, "		);\n");
			}
			fprintf(outFile, "\n");
			fprintf(outFile, "		--OutL\n");
			for(i= WIRES_PER_PORT-1;i>=0;i--){
				fprintf(outFile, "		CFGLUT5_inst_r%d%d_OutL_%d : CFGLUT5\n",r,c,i);//start editing here
				fprintf(outFile, "		generic map (\n");
				fprintf(outFile, "			INIT => X'00000000')\n");
				fprintf(outFile, "		port map (\n");
				fprintf(outFile, "			CDO => CDO_%d, -- Reconfiguration cascade output\n",i);
				fprintf(outFile, "			O5 => open, -- 4-LUT output\n");
				fprintf(outFile, "			O6 => OutL(%d), -- 5-LUT output\n",i);
				fprintf(outFile, "			CDI => CDI, -- Reconfiguration data input\n");
				fprintf(outFile, "			CE => CE_%d%d(4), -- Reconfiguration enable input\n",r,c);
				fprintf(outFile, "			CLK => CLK, -- Clock input\n");
				fprintf(outFile, "			I0 => InE(%d),\n",i);
				fprintf(outFile, "			I1 => InW(%d),\n",i);
				fprintf(outFile, "			I2 => InN(%d),\n",i);
				fprintf(outFile, "			I3 => InS(%d),\n",i);
				fprintf(outFile, "			I4 => InL(%d)\n",i);
				fprintf(outFile, "		);\n");
			}

			fprintf(outFile, "end structure;\n");

			fclose(outFile);
	
		}
	}
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlRouter ----------------------------------------------------

//--v-- fprintfRouterEntityDeclaration ----------------------------------------
void fprintfRouterEntityDeclaration(FILE *outFile,int r,int c) {

	fprintf(outFile, "entity router_%d_%d is\n",r,c);
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		InE								: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		InW								: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		InN								: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		InS								: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		InL								: in	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		OutE							: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		OutW							: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		OutN							: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		OutS							: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		OutL							: out	std_logic_vector(%d downto 0);\n", WIRES_PER_PORT-1);
	fprintf(outFile, "		\n");
	fprintf(outFile, "		--CFGLUT5\n");
	fprintf(outFile, "		CE_%d%d : in	std_logic_vector(4 downto 0);\n",r,c);
	fprintf(outFile, "		CDI:		in std_logic;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "		CLK								: in	std_logic;\n");
	fprintf(outFile, "		RST								: in	std_logic\n");
	fprintf(outFile, "	);\n");     
	fprintf(outFile, "end router_%d_%d;\n",r,c);
	fprintf(outFile, "\n");
}
//--^-- fprintfRouterEntityDeclaration ----------------------------------------

//--v-- fprintfRouterSignals --------------------------------------------------
void fprintfRouterSignals(FILE *outFile, int r, int c, unsigned char ch) {
	int i;
	unsigned char allocatedInputPort, allocatedInputIndexBinary[10];
	
	for(i = 0; i < WIRES_PER_PORT; i++) {
		switch(ch) {
			case 'E':
						allocatedInputPort = NOC[r][c].outEast[i].port;
						decToBin(NOC[r][c].outEast[i].index,
									(int)ceil(log(WIRES_PER_PORT)/log(2)),
									allocatedInputIndexBinary);
						break;
			case 'W':
						allocatedInputPort = NOC[r][c].outWest[i].port;
						decToBin(NOC[r][c].outWest[i].index,
									(int)ceil(log(WIRES_PER_PORT)/log(2)),
									allocatedInputIndexBinary);
						break;
			case 'N':
						allocatedInputPort = NOC[r][c].outNorth[i].port;
						decToBin(NOC[r][c].outNorth[i].index,
									(int)ceil(log(WIRES_PER_PORT)/log(2)),
									allocatedInputIndexBinary);
						break;
			case 'S':
						allocatedInputPort = NOC[r][c].outSouth[i].port;
						decToBin(NOC[r][c].outSouth[i].index,
									(int)ceil(log(WIRES_PER_PORT)/log(2)),
									allocatedInputIndexBinary);
						break;
			case 'L':
						allocatedInputPort = NOC[r][c].outLocal[i].port;
						decToBin(NOC[r][c].outLocal[i].index,
									(int)ceil(log(WIRES_PER_PORT)/log(2)),
									allocatedInputIndexBinary);
						break;
		}
		fprintf(outFile, "	signal Out%c_%d_AllocatedInput		: t_ports := %c;\n", ch, i, allocatedInputPort);
		fprintf(outFile, "	signal Out%c_%d_AllocatedInputIndex	: std_logic_vector(%d downto 0) := \"%s\";\n", ch, i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1, allocatedInputIndexBinary);
	}
	fprintf(outFile, "\n");
}
//--^-- fprintfRouterSignals --------------------------------------------------

//--v-- fprintfRouterDirection ------------------------------------------------
void fprintfRouterDirection(FILE *outFile, unsigned char ch) {
	int i, j;
	unsigned char tempStr[10];
	int variableLen = (int)ceil(log(WIRES_PER_PORT)/log(2));
	
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			case Out%c_%d_AllocatedInput is\n", ch, i);
		fprintf(outFile, "				when \"%s\" =>	-- EAST\n", CODE_EAST);
		fprintf(outFile, "					case Out%c_%d_AllocatedInputIndex is\n", ch, i);
		for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
			decToBin((i+j)%WIRES_PER_PORT, variableLen, tempStr);
			fprintf(outFile, "						when \"%s\" =>\n", tempStr);
			fprintf(outFile, "							Out%c(%d)		<= InE(%d);\n", ch, i, (i+j)%WIRES_PER_PORT);
		}
		fprintf(outFile, "						when others =>\n");
		fprintf(outFile, "							Out%c(%d)		<= '0';\n", ch, i);
		fprintf(outFile, "					end case;\n");
		
		fprintf(outFile, "				when \"%s\" =>	-- WEST\n", CODE_WEST);
		fprintf(outFile, "					case Out%c_%d_AllocatedInputIndex is\n", ch, i);
		for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
			decToBin((i+j)%WIRES_PER_PORT, variableLen, tempStr);
			fprintf(outFile, "						when \"%s\" =>\n", tempStr);
			fprintf(outFile, "							Out%c(%d)		<= InW(%d);\n", ch, i, (i+j)%WIRES_PER_PORT);
		}
		fprintf(outFile, "						when others =>\n");
		fprintf(outFile, "							Out%c(%d)		<= '0';\n", ch, i);
		fprintf(outFile, "					end case;\n");
		
		fprintf(outFile, "				when \"%s\" =>	-- NORTH\n", CODE_NORTH);
		fprintf(outFile, "					case Out%c_%d_AllocatedInputIndex is\n", ch, i);
		for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
			decToBin((i+j)%WIRES_PER_PORT, variableLen, tempStr);
			fprintf(outFile, "						when \"%s\" =>\n", tempStr);
			fprintf(outFile, "							Out%c(%d)		<= InN(%d);\n", ch, i, (i+j)%WIRES_PER_PORT);
		}
		fprintf(outFile, "						when others =>\n");
		fprintf(outFile, "							Out%c(%d)		<= '0';\n", ch, i);
		fprintf(outFile, "					end case;\n");
		
		fprintf(outFile, "				when \"%s\" =>	-- SOUTH\n", CODE_SOUTH);
		fprintf(outFile, "					case Out%c_%d_AllocatedInputIndex is\n", ch, i);
		for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
			decToBin((i+j)%WIRES_PER_PORT, variableLen, tempStr);
			fprintf(outFile, "						when \"%s\" =>\n", tempStr);
			fprintf(outFile, "							Out%c(%d)		<= InS(%d);\n", ch, i, (i+j)%WIRES_PER_PORT);
		}
		fprintf(outFile, "						when others =>\n");
		fprintf(outFile, "							Out%c(%d)		<= '0';\n", ch, i);
		fprintf(outFile, "					end case;\n");
		
		fprintf(outFile, "				when \"%s\" =>	-- LOCAL\n", CODE_LOCAL);
		fprintf(outFile, "					case Out%c_%d_AllocatedInputIndex is\n", ch, i);
		for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
			decToBin((i+j)%WIRES_PER_PORT, variableLen, tempStr);
			fprintf(outFile, "						when \"%s\" =>\n", tempStr);
			fprintf(outFile, "							Out%c(%d)		<= InL(%d);\n", ch, i, (i+j)%WIRES_PER_PORT);
		}
		fprintf(outFile, "						when others =>\n");
		fprintf(outFile, "							Out%c(%d)		<= '0';\n", ch, i);
		fprintf(outFile, "					end case;\n");
		
		fprintf(outFile, "				when others =>\n");
		fprintf(outFile, "					Out%c(%d)		<= '0';\n", ch, i);
		fprintf(outFile, "			end case;\n");
		fprintf(outFile, "\n");
	}
}
//--^-- fprintfRouterDirection ------------------------------------------------

//--v-- generateVhdlSetupFsmRouter --------------------------------------------
void generateVhdlSetupFsmRouter(void) {
	int i, j;
	unsigned char tempStr[WIRES_PER_PORT+5];
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating setupFsmRouter.vhd...");
	#endif
	
	outFile = fopen("generated/setupFsmRouter.vhd", "w");
	
	fprintf(outFile, "-- VHDL for setupFsmRouter\n");
	fprintf(outFile, "-- Joseph Yang\n\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
	fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
	fprintf(outFile, "\n");
	fprintfSetupFsmRouterEntityDeclaration(outFile);
	
	fprintf(outFile, "architecture structure of setupFsmRouter is\n");
	
	fprintf(outFile, "	type t_state is (IDLE, PROCESS_ROUTER_BODY_1, PROCESS_ROUTER_BODY_2);\n");
	fprintf(outFile, "	signal state		: t_state;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	type t_allocatedOut is (North, East, Local);\n");
	fprintf(outFile, "	signal allocatedOut	: t_allocatedOut;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal directionToProgram	: std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "	signal indexToProgram		: std_logic_vector(3 downto 0);\n");
	fprintf(outFile, "	signal currSetupInNewAck	: std_logic;\n");
	fprintf(outFile, "begin\n");
	fprintf(outFile, "	process (CLK, RST)\n");
	fprintf(outFile, "		variable currSetupOutNNew	: std_logic;\n");
	fprintf(outFile, "		variable currSetupOutENew	: std_logic;\n");
	fprintf(outFile, "		variable currSetupOutLNew	: std_logic;\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "		if (RST = '0') then\n");
	fprintf(outFile, "			allocatedOut				<= Local;	-- on reset value\n");
	fprintf(outFile, "			currSetupInNewAck			<= '0';\n");
	fprintf(outFile, "			setupInNewAck				<= '0';\n");
	fprintf(outFile, "			setupOutN					<= \"00000000\";\n");
	fprintf(outFile, "			currSetupOutNNew			:= '0';\n");
	fprintf(outFile, "			setupOutNNew				<= '0';\n");
	fprintf(outFile, "			setupOutE					<= \"00000000\";\n");
	fprintf(outFile, "			currSetupOutENew			:= '0';\n");
	fprintf(outFile, "			setupOutENew				<= '0';\n");
	fprintf(outFile, "			setupOutL					<= \"00000000\";\n");
	fprintf(outFile, "			currSetupOutLNew			:= '0';\n");
	fprintf(outFile, "			setupOutLNew				<= '0';\n");
	fprintf(outFile, "			state						<= IDLE;\n");
	fprintf(outFile, "			\n");
	decToBin(0, (int)ceil(log(WIRES_PER_PORT)/log(2)), tempStr);
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutE_%d_AllocatedInput		<= \"000\";\n", i);
		fprintf(outFile, "			OutE_%d_AllocatedInputIndex	<= \"%s\";\n", i, tempStr);
	}                     
	fprintf(outFile, "			\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutW_%d_AllocatedInput		<= \"000\";\n", i);
		fprintf(outFile, "			OutW_%d_AllocatedInputIndex	<= \"%s\";\n", i, tempStr);
	}                     
	fprintf(outFile, "			\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutN_%d_AllocatedInput		<= \"000\";\n", i);
		fprintf(outFile, "			OutN_%d_AllocatedInputIndex	<= \"%s\";\n", i, tempStr);
	}                     
	fprintf(outFile, "			\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutS_%d_AllocatedInput		<= \"000\";\n", i);
		fprintf(outFile, "			OutS_%d_AllocatedInputIndex	<= \"%s\";\n", i, tempStr);
	}                     
	fprintf(outFile, "			\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "			OutL_%d_AllocatedInput		<= \"000\";\n", i);
		fprintf(outFile, "			OutL_%d_AllocatedInputIndex	<= \"%s\";\n", i, tempStr);
	}
	fprintf(outFile, "		elsif (CLK'event and CLK = '1') then\n");
	fprintf(outFile, "			if ((setupInNew = '1') and (currSetupInNewAck = '0')) then\n");
	fprintf(outFile, "				case state is\n");
	fprintf(outFile, "					when IDLE =>\n");
	fprintf(outFile, "						if (setupIn(7) = '1') then	-- header flit\n");
	fprintf(outFile, "							if (setupIn(6 downto 0) = thisRow & thisCol & '0') then	-- router at this address\n");
	fprintf(outFile, "								currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "								setupInNewAck		<= '1';\n");
	fprintf(outFile, "								state				<= PROCESS_ROUTER_BODY_1;\n");
	fprintf(outFile, "							elsif (setupIn(6 downto 0) = thisRow & thisCol & '1') then	-- NI at this address\n");
	fprintf(outFile, "								if (currSetupOutLNew = '0' and setupOutLNewAck = '0') then\n");
	fprintf(outFile, "									currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "									setupInNewAck		<= '1';\n");
	fprintf(outFile, "									setupOutL			<= setupIn;\n");
	fprintf(outFile, "									currSetupOutLNew	:= '1';\n");
	fprintf(outFile, "									setupOutLNew		<= '1';\n");
	fprintf(outFile, "									allocatedOut		<= Local;\n");
	fprintf(outFile, "								end if;\n");
	fprintf(outFile, "							elsif (setupIn(6 downto 1) = \"111111\") then	-- broadcast, forward to north and east and local\n");
	fprintf(outFile, "								if ((currSetupOutENew = '0' and setupOutENewAck = '0')\n");
	fprintf(outFile, "									and (currSetupOutNNew = '0' and setupOutNNewAck = '0')\n");
	fprintf(outFile, "									and (currSetupOutLNew = '0' and setupOutLNewAck = '0')) then\n");
	fprintf(outFile, "									currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "									setupInNewAck		<= '1';\n");
	fprintf(outFile, "									setupOutE			<= setupIn;\n");
	fprintf(outFile, "									currSetupOutENew	:= '1';\n");
	fprintf(outFile, "									setupOutENew		<= '1';\n");
	fprintf(outFile, "									setupOutN			<= setupIn;\n");
	fprintf(outFile, "									currSetupOutNNew	:= '1';\n");
	fprintf(outFile, "									setupOutNNew		<= '1';\n");
	fprintf(outFile, "									setupOutL			<= setupIn;\n");
	fprintf(outFile, "									currSetupOutLNew	:= '1';\n");
	fprintf(outFile, "									setupOutLNew		<= '1';\n");
	fprintf(outFile, "								end if;\n");
	fprintf(outFile, "							elsif (setupIn(6 downto 4) = thisRow) then	-- forward data East\n");
	fprintf(outFile, "								if (currSetupOutENew = '0' and setupOutENewAck = '0') then\n");
	fprintf(outFile, "									currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "									setupInNewAck		<= '1';\n");
	fprintf(outFile, "									setupOutE			<= setupIn;\n");
	fprintf(outFile, "									currSetupOutENew	:= '1';\n");
	fprintf(outFile, "									setupOutENew		<= '1';\n");
	fprintf(outFile, "									allocatedOut		<= East;\n");
	fprintf(outFile, "								end if;\n");
	fprintf(outFile, "							else	-- forward data North\n");
	fprintf(outFile, "								if (currSetupOutNNew = '0' and setupOutNNewAck = '0') then\n");
	fprintf(outFile, "									currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "									setupInNewAck		<= '1';\n");
	fprintf(outFile, "									setupOutN			<= setupIn;\n");
	fprintf(outFile, "									currSetupOutNNew	:= '1';\n");
	fprintf(outFile, "									setupOutNNew		<= '1';\n");
	fprintf(outFile, "									allocatedOut		<= North;\n");
	fprintf(outFile, "								end if;\n");

	fprintf(outFile, "							end if;\n");
	fprintf(outFile, "						else	-- body flit, just forward based on value of allocatedOut\n");
	fprintf(outFile, "							case allocatedOut is\n");
	fprintf(outFile, "								when North =>\n");
	fprintf(outFile, "									if (currSetupOutNNew = '0' and setupOutNNewAck = '0') then\n");
	fprintf(outFile, "										currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "										setupInNewAck		<= '1';\n");
	fprintf(outFile, "										setupOutN			<= setupIn;\n");
	fprintf(outFile, "										currSetupOutNNew	:= '1';\n");
	fprintf(outFile, "										setupOutNNew		<= '1';\n");
	fprintf(outFile, "									end if;\n");
	fprintf(outFile, "								when East =>\n");
	fprintf(outFile, "									if (currSetupOutENew = '0' and setupOutENewAck = '0') then\n");
	fprintf(outFile, "										currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "										setupInNewAck		<= '1';\n");
	fprintf(outFile, "										setupOutE			<= setupIn;\n");
	fprintf(outFile, "										currSetupOutENew	:= '1';\n");
	fprintf(outFile, "										setupOutENew		<= '1';\n");
	fprintf(outFile, "									end if;\n");
	fprintf(outFile, "								when Local =>\n");
	fprintf(outFile, "									if (currSetupOutLNew = '0' and setupOutLNewAck = '0') then\n");
	fprintf(outFile, "										currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "										setupInNewAck		<= '1';\n");
	fprintf(outFile, "										setupOutL			<= setupIn;\n");
	fprintf(outFile, "										currSetupOutLNew	:= '1';\n");
	fprintf(outFile, "										setupOutLNew		<= '1';\n");
	fprintf(outFile, "									end if;\n");
	fprintf(outFile, "								when others =>\n");
	fprintf(outFile, "									null;\n");
	fprintf(outFile, "							end case;\n");
	fprintf(outFile, "						end if;\n");
	fprintf(outFile, "						\n");
	fprintf(outFile, "					when PROCESS_ROUTER_BODY_1 =>\n");
	fprintf(outFile, "						currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "						setupInNewAck		<= '1';\n");
	fprintf(outFile, "						if (setupIn(6 downto 4) = \"111\") then\n");
	fprintf(outFile, "							state	<= IDLE;\n");
	fprintf(outFile, "						else\n");
	fprintf(outFile, "							directionToProgram	<= setupIn(6 downto 4);\n");
	fprintf(outFile, "							indexToProgram		<= setupIn(3 downto 0);\n");
	fprintf(outFile, "							state				<= PROCESS_ROUTER_BODY_2;\n");
	fprintf(outFile, "						end if;\n");
	fprintf(outFile, "					when PROCESS_ROUTER_BODY_2 =>\n");
	fprintf(outFile, "						currSetupInNewAck	<= '1';\n");
	fprintf(outFile, "						setupInNewAck		<= '1';\n");
	fprintf(outFile, "							case directionToProgram is\n");
	for(i = 1; i <= 5; i++) {
		decToBin(i, 3, tempStr);
		fprintf(outFile, "								when \"%s\" =>\n", tempStr);
		
		fprintf(outFile, "									case indexToProgram is\n");
		for(j = 0; j < WIRES_PER_PORT; j++) {
			decToBin(j, 4, tempStr);
			fprintf(outFile, "										when \"%s\" =>\n", tempStr);
			switch(i) {
				case 1:
						fprintf(outFile, "											OutE_%d_AllocatedInput		<= setupIn(6 downto 4);\n", j);
						fprintf(outFile, "											OutE_%d_AllocatedInputIndex	<= setupIn(%d downto 0);\n", j, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
						break;
				case 2:
						fprintf(outFile, "											OutW_%d_AllocatedInput		<= setupIn(6 downto 4);\n", j);
						fprintf(outFile, "											OutW_%d_AllocatedInputIndex	<= setupIn(%d downto 0);\n", j, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
						break;                           
				case 3:
						fprintf(outFile, "											OutN_%d_AllocatedInput		<= setupIn(6 downto 4);\n", j);
						fprintf(outFile, "											OutN_%d_AllocatedInputIndex	<= setupIn(%d downto 0);\n", j, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
						break;                           
				case 4:
						fprintf(outFile, "											OutS_%d_AllocatedInput		<= setupIn(6 downto 4);\n", j);
						fprintf(outFile, "											OutS_%d_AllocatedInputIndex	<= setupIn(%d downto 0);\n", j, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
						break;                           
				case 5:
						fprintf(outFile, "											OutL_%d_AllocatedInput		<= setupIn(6 downto 4);\n", j);
						fprintf(outFile, "											OutL_%d_AllocatedInputIndex	<= setupIn(%d downto 0);\n", j, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
						break;                           
			}
		}
		fprintf(outFile, "										when others =>\n");
		fprintf(outFile, "											null;\n");
		fprintf(outFile, "									end case;\n");
		
	}
	fprintf(outFile, "								when others =>\n");
	fprintf(outFile, "									null;\n");
	fprintf(outFile, "							end case;\n");
	fprintf(outFile, "							state	<= PROCESS_ROUTER_BODY_1;\n");
	fprintf(outFile, "				end case;\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			if (currSetupInNewAck = '1') then\n");
	fprintf(outFile, "				currSetupInNewAck	<= '0';\n");
	fprintf(outFile, "				setupInNewAck		<= '0';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			if (setupOutNNewAck = '1') then\n");
	fprintf(outFile, "				currSetupOutNNew	:= '0';\n");
	fprintf(outFile, "				setupOutNNew		<= '0';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			if (setupOutENewAck = '1') then\n");
	fprintf(outFile, "				currSetupOutENew	:= '0';\n");
	fprintf(outFile, "				setupOutENew		<= '0';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "			\n");
	fprintf(outFile, "			if (setupOutLNewAck = '1') then\n");
	fprintf(outFile, "				currSetupOutLNew	:= '0';\n");
	fprintf(outFile, "				setupOutLNew		<= '0';\n");
	fprintf(outFile, "			end if;\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "end structure;\n");
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlSetupFsmRouter --------------------------------------------

//--v-- fprintfSetupFsmRouterEntityDeclaration --------------------------------
void fprintfSetupFsmRouterEntityDeclaration(FILE *outFile) {
	int i;
	
	fprintf(outFile, "entity setupFsmRouter is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		setupIn						: in	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "		setupInNew					: in	std_logic;\n");
	fprintf(outFile, "		setupInNewAck				: out	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		setupOutN					: out	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "		setupOutNNew				: out	std_logic;\n");
	fprintf(outFile, "		setupOutNNewAck				: in	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		setupOutE					: out	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "		setupOutENew				: out	std_logic;\n");
	fprintf(outFile, "		setupOutENewAck				: in	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		setupOutL					: out	std_logic_vector(7 downto 0);\n");
	fprintf(outFile, "		setupOutLNew				: out	std_logic;\n");
	fprintf(outFile, "		setupOutLNewAck				: in	std_logic;\n");
	fprintf(outFile, "		\n");
	
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "		OutE_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "		OutE_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "		OutW_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "		OutW_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "		OutN_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "		OutN_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "		OutS_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "		OutS_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "\n");
	for(i = 0; i < WIRES_PER_PORT; i++) {
		fprintf(outFile, "		OutL_%d_AllocatedInput		: out	std_logic_vector(2 downto 0);\n", i);
		fprintf(outFile, "		OutL_%d_AllocatedInputIndex	: out	std_logic_vector(%d downto 0);\n", i, (int)ceil(log(WIRES_PER_PORT)/log(2))-1);
	}
	fprintf(outFile, "		\n");
	fprintf(outFile, "		thisRow						: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "		thisCol						: in	std_logic_vector(2 downto 0);\n");
	fprintf(outFile, "		\n");       
	fprintf(outFile, "		CLK							: in	std_logic;\n");
	fprintf(outFile, "		RST							: in	std_logic\n");
	fprintf(outFile, "	);\n");         
	fprintf(outFile, "end setupFsmRouter;\n");
	fprintf(outFile, "\n");
}
//--^-- fprintfSetupFsmRouterEntityDeclaration --------------------------------

//--v-- initializeWiresAllocated ----------------------------------------------
void initializeWiresAllocated(void) {
	int r, c, i;
	unsigned char tempStr[WIRES_PER_PORT+1];
	
	decToBin(0, WIRES_PER_PORT, tempStr);
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(i = 0; i < SEND_CHANNELS_MAX; i++) {
				strcpy(wiresAllocated[r][c].sendChannel[i], tempStr);
				strcpy(wiresAllocated[r][c].rcvChannel[i], tempStr);
			}
		}
	}
}
//--^-- initializeWiresAllocated ----------------------------------------------

//--v-- assignChannel ---------------------------------------------------------
int assignChannel(int requestPendingIndexTotal) {
	int i, j, k;
	int srcR, srcC, destR, destC;
	int previous_srcR, previous_srcC, previous_destR, previous_destC;
	int srcIndex, destIndex;
	int newFlag, doneFlag;
	unsigned char tempStr[WIRES_PER_PORT+1];
	
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating %s...\n", FILENAME_CHANNEL_REPORT);
	#endif
	
	outFile = fopen(FILENAME_CHANNEL_REPORT, "w");
	
	previous_srcR = 0;
	previous_srcC = 0;
	previous_destR = 0;
	previous_destC = 0;
	
	newFlag = 1;
	doneFlag = 0;
	
	for(i = 0; i <= requestPendingIndexTotal; i++) {
		srcR = requestPending[i].srcR;
		srcC = requestPending[i].srcC;
		destR = requestPending[i].destR;
		destC = requestPending[i].destC;
		srcIndex = requestPending[i].srcIndex;
		destIndex = requestPending[i].destIndex;
		
		if(previous_srcR == srcR && previous_srcC == srcC &&
			previous_destR == destR && previous_destC == destC) {
			newFlag = 0;
		}
		else {
			newFlag = 1;
		}
		
		if(newFlag) {
			decToBin(0, WIRES_PER_PORT, tempStr);
			doneFlag = 0;
			for(j = 0; !doneFlag && j < SEND_CHANNELS_MAX; ) {
				for(k = 0; !doneFlag && k < RCV_CHANNELS_MAX; ) {
					if(!strcmp(wiresAllocated[srcR][srcC].sendChannel[j], tempStr) &&
						!strcmp(wiresAllocated[destR][destC].rcvChannel[k], tempStr)) {
						
						wiresAllocated[srcR][srcC].sendChannel[j][WIRES_PER_PORT-1-srcIndex] = '1';
						wiresAllocated[destR][destC].rcvChannel[k][WIRES_PER_PORT-1-destIndex] = '1';
						
						printf("%d %d %d %d sendChannel=%d rcvChannel=%d\n",
									srcR, srcC, destR, destC, j, k);
						fprintf(outFile, "%d %d %d %d sendChannel=%d rcvChannel=%d\n",
									srcR, srcC, destR, destC, j, k);
						
						doneFlag = 1;
					}
					if(!doneFlag) {
						k++;
					}
				}
				if(!doneFlag) {
					j++;
				}
			}
			if(doneFlag == 0) {
				fclose(outFile);
				return 1;	// ERROR: Not enough channels
			}
		}
		else {
			wiresAllocated[srcR][srcC].sendChannel[j][WIRES_PER_PORT-1-srcIndex] = '1';
			wiresAllocated[destR][destC].rcvChannel[k][WIRES_PER_PORT-1-destIndex] = '1';
		}
		
		previous_srcR = srcR;
		previous_srcC = srcC;
		previous_destR = destR;
		previous_destC = destC;
	}
	
	fclose(outFile);
	
	#ifdef DEBUG
		printf("Generating %s...done!\n", FILENAME_CHANNEL_REPORT);
	#endif
	
	return 0;	// Success!!
}
//--^-- assignChannel ---------------------------------------------------------

//--v-- generateProgrammingFile -----------------------------------------------
void generateProgrammingFile(void) {
	int r, c, i, j;
	unsigned char tempStr1[10];
	unsigned char tempStr2[10];
	unsigned char tempStr16send[16] = "0000000000000000";
	unsigned char tempStr16rcv[16] = "0000000000000000";
	unsigned char tempWiresAllocated[WIRES_PER_PORT+1];
	
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating %s...", FILENAME_PROGRAMMING_FILE);
	#endif
	
	outFile = fopen(FILENAME_PROGRAMMING_FILE, "w");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
		
			//--v-- Program Routers ---------------------------------------------------
			#ifdef DEBUG_PROGRAMMING_FILE
				fprintf(outFile, "Programming Router %d%d\n", r, c);
			#endif
			
			// Header Flit
			decToBin(r, 3, tempStr1);
			decToBin(c, 3, tempStr2);
			fprintf(outFile, "1%s%s0\n", tempStr1, tempStr2);
			
			// Router Body Flit
			for(i = 0; i < WIRES_PER_PORT; i++) {
				decToBin(i, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", CODE_EAST, tempStr2);
				decToBin(directionToNumber(NOC[r][c].outEast[i].port), 3, tempStr1);
				decToBin(NOC[r][c].outEast[i].index, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", tempStr1, tempStr2);
				
				decToBin(i, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", CODE_WEST, tempStr2);
				decToBin(directionToNumber(NOC[r][c].outWest[i].port), 3, tempStr1);
				decToBin(NOC[r][c].outWest[i].index, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", tempStr1, tempStr2);
				
				decToBin(i, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", CODE_NORTH, tempStr2);
				decToBin(directionToNumber(NOC[r][c].outNorth[i].port), 3, tempStr1);
				decToBin(NOC[r][c].outNorth[i].index, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", tempStr1, tempStr2);
				
				decToBin(i, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", CODE_SOUTH, tempStr2);
				decToBin(directionToNumber(NOC[r][c].outSouth[i].port), 3, tempStr1);
				decToBin(NOC[r][c].outSouth[i].index, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", tempStr1, tempStr2);
				
				decToBin(i, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", CODE_LOCAL, tempStr2);
				decToBin(directionToNumber(NOC[r][c].outLocal[i].port), 3, tempStr1);
				decToBin(NOC[r][c].outLocal[i].index, 4, tempStr2);
				fprintf(outFile, "0%s%s\n", tempStr1, tempStr2);
			}
			
			fprintf(outFile, "01110000\n");		// Done!
			//--^-- Program Routers ---------------------------------------------------
			
			//--v-- Program Nis ---------------------------------------------------
			#ifdef DEBUG_PROGRAMMING_FILE
				fprintf(outFile, "Programming Ni %d%d\n", r, c);
			#endif
			for(i = 0; i < 16; i++) {
				tempStr16send[i] = '0';
				tempStr16rcv[i] = '0';
			}
			
			// Header Flit
			decToBin(r, 3, tempStr1);
			decToBin(c, 3, tempStr2);
			fprintf(outFile, "1%s%s1\n", tempStr1, tempStr2);
			
			// Ni Body Flit (send channels)
			for(i = 0; i < SEND_CHANNELS_MAX; i++) {
				strcpy(tempWiresAllocated, wiresAllocated[r][c].sendChannel[i]);
				for(j = 0; j < WIRES_PER_PORT; j++) {
					tempStr16send[15-j] = tempWiresAllocated[WIRES_PER_PORT-1-j];
				}
				
				// Ni Body flit 1
				fprintf(outFile, "0");	//bit 7
				fprintf(outFile, "1");	//bit 6 - send
				decToBin(i+1, 4, tempStr1);
				fprintf(outFile, "%s", tempStr1);	//bit [5..2] - Channel To Program
				
				for(j = 0; j < 2; j++) {	// bit [1..0]
					fprintf(outFile, "%c", tempStr16send[j]);
				}
				fprintf(outFile, "\n");
				
				// Body flit 2
				fprintf(outFile, "0");
				for(j = 0; j < 7; j++) {
					fprintf(outFile, "%c", tempStr16send[2+j]);
				}
				fprintf(outFile, "\n");
				
				// Body flit 3
				fprintf(outFile, "0");
				for(j = 0; j < 7; j++) {
					fprintf(outFile, "%c", tempStr16send[9+j]);
				}
				fprintf(outFile, "\n");
			}
			
			// Ni Body Flit (rcv channels)
			for(i = 0; i < RCV_CHANNELS_MAX; i++) {
				strcpy(tempWiresAllocated, wiresAllocated[r][c].rcvChannel[i]);
				for(j = 0; j < WIRES_PER_PORT; j++) {
					tempStr16rcv[15-j] = tempWiresAllocated[WIRES_PER_PORT-1-j];
				}
				
				// Ni Body flit 1
				fprintf(outFile, "0");	//bit 7
				fprintf(outFile, "0");	//bit 6 - rcv
				decToBin(i+1, 4, tempStr1);
				fprintf(outFile, "%s", tempStr1);	//bit [5..2] - Channel To Program
				
				for(j = 0; j < 2; j++) {	// bit [1..0]
					fprintf(outFile, "%c", tempStr16rcv[j]);
				}
				fprintf(outFile, "\n");
				
				// Body flit 2
				fprintf(outFile, "0");
				for(j = 0; j < 7; j++) {
					fprintf(outFile, "%c", tempStr16rcv[2+j]);
				}
				fprintf(outFile, "\n");
				
				// Body flit 3
				fprintf(outFile, "0");
				for(j = 0; j < 7; j++) {
					fprintf(outFile, "%c", tempStr16rcv[9+j]);
				}
				fprintf(outFile, "\n");
			}
			
			fprintf(outFile, "00000000");	// DONE!!
			fprintf(outFile, "\n");
			//--^-- Program Nis ---------------------------------------------------
		}
	}
	fprintf(outFile, "11111110");	// to set programmingInProgress to '0'
			fprintf(outFile, "\n");
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateProgrammingFile -----------------------------------------------

//--v-- convertProgrammingFile ------------------------------------------------
void convertProgrammingFile(void) {
	unsigned char input[10];
	unsigned int count = 0;
	unsigned char left, right;
	FILE *inFile;
	FILE *outFile;
	
	#ifdef DEBUG
		printf("Generating %s...", FILENAME_PROGRAMMING_DATA_MICROBLAZE);
	#endif
	
	inFile = fopen(FILENAME_PROGRAMMING_FILE, "r");
	outFile = fopen(FILENAME_PROGRAMMING_DATA_MICROBLAZE, "w");
	
	while(fgets(input, 8, inFile)) {
		count++;
	}
	count = (count+1)/2;
	
	fseek(inFile, 0L, SEEK_SET);
	
	fprintf(outFile, "#include \"xparameters.h\"\n");
	fprintf(outFile, "#include \"xutil.h\"\n");
	fprintf(outFile, "#include \"mb_interface.h\"\n");
	fprintf(outFile, "#include <stdio.h>\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "#define fsl_control_noc_0_out 1\n");
	fprintf(outFile, "#define fsl_noc_0_0_in 0\n");
	fprintf(outFile, "#define fsl_0_noc_0_out 0\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "#define PROGRAMMING_DATA_TOTAL %d\n", count);
	fprintf(outFile, "unsigned char programming_data[PROGRAMMING_DATA_TOTAL] = {\n");
	while(fgets(input, 10, inFile)) {
		binToHex(input, &left, &right);
		fprintf(outFile, "								0x%c%c,\n", left, right);
	}
	fprintf(outFile, "							};\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "void sendProgrammingData(void) {\n");
	fprintf(outFile, "	int i;\n");
	fprintf(outFile, "	unsigned char msg_in;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	for(i = 0; i < PROGRAMMING_DATA_TOTAL; i++) {\n");
	fprintf(outFile, "		msg_in = programming_data[i];\n");
	fprintf(outFile, "		bwrite_into_fsl(msg_in << 24, fsl_control_noc_0_out);\n");
	fprintf(outFile, "	}\n");
	fprintf(outFile, "}\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "main() {\n");
	fprintf(outFile, "	xil_printf(\"Systems up and running\");\n");
	fprintf(outFile, "	sendProgrammingData();\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	// Add your own codes here\n");
	fprintf(outFile, "}\n");
	
	fclose(inFile);
	fclose(outFile);
	
	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- convertProgrammingFile ------------------------------------------------

//--v-- directionToNumber -----------------------------------------------------
int directionToNumber(unsigned char direction) {
	switch(direction) {
		case 'E':
					return 1;
					break;
		case 'W':
					return 2;
					break;
		case 'N':
					return 3;
					break;
		case 'S':
					return 4;
					break;
		case 'L':
					return 5;
					break;
	}
	return 0;
}
//--^-- directionToNumber -----------------------------------------------------

//--v-- printRouterStatus -----------------------------------------------------
void printRouterStatus(router routerToPrint[10][10]) {
	int r, c, i;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			printf("\n\nRouter %d%d outNorth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%c", routerToPrint[r][c].outNorth[i].port);
			}
			printf("\nRouter %d%d outNorth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%d", routerToPrint[r][c].outNorth[i].index);
			}

			printf("\nRouter %d%d outSouth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%c", routerToPrint[r][c].outSouth[i].port);
			}
			printf("\nRouter %d%d outSouth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%d", routerToPrint[r][c].outSouth[i].index);
			}

			printf("\nRouter %d%d outEast=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%c", routerToPrint[r][c].outEast[i].port);
			}
			printf("\nRouter %d%d outEast=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%d", routerToPrint[r][c].outEast[i].index);
			}

			printf("\nRouter %d%d outWest=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%c", routerToPrint[r][c].outWest[i].port);
			}
			printf("\nRouter %d%d outWest=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%d", routerToPrint[r][c].outWest[i].index);
			}

			printf("\nRouter %d%d outLocal=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%c", routerToPrint[r][c].outLocal[i].port);
			}
			printf("\nRouter %d%d outLocal=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				printf("%d", routerToPrint[r][c].outLocal[i].index);
			}
		}
	}
	printf("\n\n");
}
//--^-- printRouterStatus -----------------------------------------------------

//--v-- fprintRouterStatus ----------------------------------------------------
void fprintRouterStatus(void) {
	int r, c, i;
	FILE *outFile;
	
	outFile = fopen(FILENAME_CONNECTION_ALLOCATIONS, "w");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "Router %d%d outNorth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%c", NOC[r][c].outNorth[i].port);
			}
			fprintf(outFile, "\nRouter %d%d outNorth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%d", NOC[r][c].outNorth[i].index);
			}

			fprintf(outFile, "\nRouter %d%d outSouth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%c", NOC[r][c].outSouth[i].port);
			}
			fprintf(outFile, "\nRouter %d%d outSouth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%d", NOC[r][c].outSouth[i].index);
			}

			fprintf(outFile, "\nRouter %d%d outEast=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%c", NOC[r][c].outEast[i].port);
			}
			fprintf(outFile, "\nRouter %d%d outEast=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%d", NOC[r][c].outEast[i].index);
			}

			fprintf(outFile, "\nRouter %d%d outWest=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%c", NOC[r][c].outWest[i].port);
			}
			fprintf(outFile, "\nRouter %d%d outWest=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%d", NOC[r][c].outWest[i].index);
			}

			fprintf(outFile, "\nRouter %d%d outLocal=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%c", NOC[r][c].outLocal[i].port);
			}
			fprintf(outFile, "\nRouter %d%d outLocal=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "%d", NOC[r][c].outLocal[i].index);
			}
			fprintf(outFile, "\n\n");
		}
	}
	fclose(outFile);
}
//--^-- fprintRouterStatus ----------------------------------------------------

//--v-- fprintRouterStatusForExcel --------------------------------------------
void fprintRouterStatusForExcel(void) {
	int r, c, i;
	FILE *outFile;
	
	outFile = fopen(FILENAME_CONNECTION_ALLOCATIONS_FOR_EXCEL, "w");
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			fprintf(outFile, "Router\t%d%d\toutNorth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%c", NOC[r][c].outNorth[i].port);
			}
			fprintf(outFile, "\nRouter\t%d%d\toutNorth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%d", NOC[r][c].outNorth[i].index);
			}

			fprintf(outFile, "\nRouter\t%d%d\toutSouth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%c", NOC[r][c].outSouth[i].port);
			}
			fprintf(outFile, "\nRouter\t%d%d\toutSouth=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%d", NOC[r][c].outSouth[i].index);
			}

			fprintf(outFile, "\nRouter\t%d%d\toutEast=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%c", NOC[r][c].outEast[i].port);
			}
			fprintf(outFile, "\nRouter\t%d%d\toutEast=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%d", NOC[r][c].outEast[i].index);
			}

			fprintf(outFile, "\nRouter\t%d%d\toutWest=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%c", NOC[r][c].outWest[i].port);
			}
			fprintf(outFile, "\nRouter\t%d%d\toutWest=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%d", NOC[r][c].outWest[i].index);
			}

			fprintf(outFile, "\nRouter\t%d%d\toutLocal=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%c", NOC[r][c].outLocal[i].port);
			}
			fprintf(outFile, "\nRouter\t%d%d\toutLocal=", r, c);
			for(i = WIRES_PER_PORT-1; i >= 0; i--) {
				fprintf(outFile, "\t%d", NOC[r][c].outLocal[i].index);
			}
			fprintf(outFile, "\n\n");
		}
	}
	fclose(outFile);
}
//--^-- fprintRouterStatusForExcel --------------------------------------------

//--v-- printAllocationHistory ------------------------------------------------
void printAllocationHistory(wire allocationHistory[]) {
	int i;
	
	for(i = 0; i < ALLOCATION_HISTORY_MAX; i++) {
		printf("allocationHistory[%d].port = %c\n", i, allocationHistory[i].port);
	}
}
//--^-- printAllocationHistory ------------------------------------------------

//--v-- processRequirement ----------------------------------------------------
int processRequirement(int reqPendingIndex, router tempNOC[10][10],
						t_requestPending oldRequestPending[REQUESTS_MAX*20],
						int possiblePathIndex) {
	int srcR, srcC, destR, destC, srcIndex, destIndex;
	int successFlag;

	srcR = requestPending[reqPendingIndex].srcR;
	srcC = requestPending[reqPendingIndex].srcC;
	destR = requestPending[reqPendingIndex].destR;
	destC = requestPending[reqPendingIndex].destC;
	
	srcIndex = WIRES_PER_PORT - 1;
	while(1) {
		if(srcIndex < 0) {
			return 0;
		}
		
		successFlag = allocatePath(tempNOC, srcR, srcC, srcIndex, destR, destC,
									&destIndex, possiblePathIndex);
		if(successFlag) {
			#ifdef DEBUG_MAPPING
		//	printf("src=%d%d:%d, dest=%d%d:%d, successFlag = %d\n", srcR, srcC, srcIndex,
		//			destR, destC, destIndex, successFlag);
			#endif
			oldRequestPending[reqPendingIndex].srcIndex = srcIndex;
			oldRequestPending[reqPendingIndex].destIndex = destIndex;
			return 1;
		}
		else {
			#ifdef DEBUG_MAPPING
		//	printf("src=%d%d:%d, dest=%d%d, successFlag = %d\n", srcR, srcC, srcIndex,
		//			destR, destC, successFlag);
			#endif
		}

		srcIndex--;
	}
}
//--^-- processRequirement ----------------------------------------------------

//--v-- allocatePath ----------------------------------------------------------
int allocatePath(router tempNOC[10][10], int srcR, int srcC,
				int srcIndex, int destR, int destC, int *destIndex,
				int possiblePathIndex) {
	int rowsToTravel, colsToTravel;
	int flag;
	int distTravelled;
	int currR, currC;
	unsigned char fromPort;
	int fromIndex;
	int destDirNPossible;
	int destDirSPossible;
	int destDirEPossible;
	int destDirWPossible;
	int allocationHistoryIndex = 0;
	wire allocationHistory[ALLOCATION_HISTORY_MAX];
	wire dummyWire;
	unsigned char possiblePath[10];
	
	rowsToTravel = abs(destR - srcR);
	colsToTravel = abs(destC - srcC);
	
	strcpy(possiblePath, possiblePaths[rowsToTravel][colsToTravel][possiblePathIndex]);
	//printf("possiblePath = %s\n", possiblePath);
	
	currR = srcR;
	currC = srcC;
	distTravelled = 0;
	
	while((currR != destR) || (currC != destC)) {
		flag = 0;
		
		destDirNPossible = 0;
		destDirSPossible = 0;
		destDirEPossible = 0;
		destDirWPossible = 0;
		
		if(possiblePath[distTravelled] == '1') {	// Go North/South
			if(destR > srcR) {
				destDirNPossible = 1;
				destDirSPossible = 0;
			}
			if(destR < srcR) {
				destDirNPossible = 0;
				destDirSPossible = 1;
			}
		}
		
		else if(possiblePath[distTravelled] == '0') {	// Go East/West
			if(destC > srcC) {
				destDirEPossible = 1;
				destDirWPossible = 0;
			}
			if(destC < srcC) {
				destDirEPossible = 0;
				destDirWPossible = 1;
			}
		}
		
//		printf("%d%d%d%d\n", destDirNPossible, destDirSPossible, destDirEPossible, destDirWPossible);
		
		if(currR == srcR && currC == srcC) {
			fromPort = 'L';
			fromIndex = srcIndex;
			if(indexUsed(&tempNOC[currR][currC], fromPort, fromIndex) == 1) {
				return 0;
			}
		}
		
		if(!flag && destDirNPossible) {
			//printf("Trying N @ router %d%d\n", currR, currC);
			if(allocateLink(fromPort, fromIndex, &tempNOC[currR][currC], 'N',
							&allocationHistory[allocationHistoryIndex])) {
				fromIndex = allocationHistory[allocationHistoryIndex].index;
				allocationHistoryIndex++;
				fromPort = 'S';
				currR++;
				flag = 1;
				distTravelled++;
			}
		}
		if(!flag && destDirSPossible) {
			//printf("Trying S @ router %d%d\n", currR, currC);
			if(allocateLink(fromPort, fromIndex, &tempNOC[currR][currC], 'S',
							&allocationHistory[allocationHistoryIndex])) {
				fromIndex = allocationHistory[allocationHistoryIndex].index;
				allocationHistoryIndex++;
				fromPort = 'N';
				currR--;
				flag = 1;
				distTravelled++;
			}
		}
		if(!flag && destDirEPossible) {
			//printf("Trying E @ router %d%d\n", currR, currC);
			if(allocateLink(fromPort, fromIndex, &tempNOC[currR][currC], 'E',
							&allocationHistory[allocationHistoryIndex])) {
				fromIndex = allocationHistory[allocationHistoryIndex].index;
				allocationHistoryIndex++;
				fromPort = 'W';
				currC++;
				flag = 1;
				distTravelled++;
			}
		}
		if(!flag && destDirWPossible) {
			//printf("Trying W @ router %d%d\n", currR, currC);
			if(allocateLink(fromPort, fromIndex, &tempNOC[currR][currC], 'W',
							&allocationHistory[allocationHistoryIndex])) {
				fromIndex = allocationHistory[allocationHistoryIndex].index;
				allocationHistoryIndex++;
				fromPort = 'E';
				currC--;
				flag = 1;
				distTravelled++;
			}
		}
		if(!flag) {
//			printAllocationHistory(allocationHistory);
			deallocateLinks(tempNOC, srcR, srcC, currR, currC, allocationHistory);
			
			return 0;
		}
	}

	if(allocateLink(fromPort, fromIndex, &tempNOC[currR][currC], 'L', &dummyWire)) {
		*destIndex = dummyWire.index;
		return 1;
	}
	else {
		deallocateLinks(tempNOC, srcR, srcC, currR, currC, allocationHistory);
		return 0;
	}
}
//--^-- allocatePath ----------------------------------------------------------

//--v-- indexUsed -------------------------------------------------------------
int indexUsed(router *router, unsigned char port, int index) {
	int r, c, i;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(i = 0; i < WIRES_PER_PORT; i++) {
				if((router->outNorth[i].port == port)
					&& (router->outNorth[i].index == index)) {
					return 1;
				}
				if((router->outSouth[i].port == port)
					&& (router->outSouth[i].index == index)) {
					return 1;
				}
				if((router->outEast[i].port == port)
					&& (router->outEast[i].index == index)) {
					return 1;
				}
				if((router->outWest[i].port == port)
					&& (router->outWest[i].index == index)) {
					return 1;
				}
				if((router->outLocal[i].port == port)
					&& (router->outLocal[i].index == index)) {
					return 1;
				}
			}
		}
	}
	return 0;
}
//--^-- indexUsed -------------------------------------------------------------

//--v-- deallocateLinks -------------------------------------------------------
void deallocateLinks(router tempNOC[10][10], int srcR, int srcC, int destR, int destC,
						wire allocationHistory[]) {
	int i = 0;
	int currR, currC;
	
	currR = srcR;
	currC = srcC;
	
	while((currR != destR) || (currC != destC)) {
		deallocateLink(&tempNOC[currR][currC], allocationHistory[i]);
		switch(allocationHistory[i].port) {
			case 'N':
						currR++;
						break;
			case 'S':
						currR--;
						break;
			case 'E':
						currC++;
						break;
			case 'W':
						currC--;
						break;
		}
		i++;
	}
}
//--^-- deallocateLinks -------------------------------------------------------

//--v-- deallocateLink --------------------------------------------------------
void deallocateLink(router *router, wire wire) {
	switch(wire.port) {
		case 'N':
					router->outNorth[wire.index].port = 'F';
					break;
		case 'S':
					router->outSouth[wire.index].port = 'F';
					break;
		case 'E':
					router->outEast[wire.index].port = 'F';
					break;
		case 'W':
					router->outWest[wire.index].port = 'F';
					break;
	}
}
//--^-- deallocateLink --------------------------------------------------------

//--v-- allocateLink ----------------------------------------------------------
int allocateLink(unsigned char inputPort, int index, router *router,
					unsigned char reqDirection, wire *wire) {
	int i, j;
	
	switch(reqDirection) {
		case 'N':
					for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
						i = (index+j)%WIRES_PER_PORT;
				//		printf("router->outNorth[%d].port=%c\n", i, router->outNorth[i].port);
						if(router->outNorth[i].port == 'F') {
							router->outNorth[i].port = inputPort;
							router->outNorth[i].index = index;
							wire->port = 'N';
							wire->index = i;
							
				//			printf("Allocated outNorth[%d] to %c %d\n", i, inputPort, index);
							
							return 1;
						}
					}
					break;
		case 'S':
					for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
						i = (index+j)%WIRES_PER_PORT;
						if(router->outSouth[i].port == 'F') {
							router->outSouth[i].port = inputPort;
							router->outSouth[i].index = index;
							wire->port = 'S';
							wire->index = i;
							
				//			printf("Allocated outSouth[%d] to %c %d\n", i, inputPort, index);
							
							return 1;
						}
					}
					break;
		case 'E':
					for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
						i = (index+j)%WIRES_PER_PORT;
						if(router->outEast[i].port == 'F') {
							router->outEast[i].port = inputPort;
							router->outEast[i].index = index;
							wire->port = 'E';
							wire->index = i;
							
				//			printf("Allocated outEast[%d] to %c %d\n", i, inputPort, index);
							
							return 1;
						}
					}
					break;
		case 'W':
					for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
						i = (index+j)%WIRES_PER_PORT;
						if(router->outWest[i].port == 'F') {
							router->outWest[i].port = inputPort;
							router->outWest[i].index = index;
							wire->port = 'W';
							wire->index = i;
							
				//			printf("Allocated outWest[%d] to %c %d\n", i, inputPort, index);
							
							return 1;
						}
					}
					break;
		case 'L':
					for(j = 0; j < NUMBER_OF_INDEX_TO_TRY; j++) {
						i = (index+j)%WIRES_PER_PORT;
						if(router->outLocal[i].port == 'F') {
							router->outLocal[i].port = inputPort;
							router->outLocal[i].index = index;
							wire->port = 'L';
							wire->index = i;
							
				//			printf("Allocated outLocal[%d] to %c %d\n", i, inputPort, index);
							
							return 1;
						}
					}
					break;
		default:
					break;
	}
	
	return 0;
}
//--^-- allocateLink ----------------------------------------------------------

//--v-- routerCopy ------------------------------------------------------------
void routerCopy(router dest[10][10], router src[10][10]) {
	int r, c, i;
	
	for(r = 0; r < 10; r++) {
		for(c = 0; c < 10; c++) {
			for(i = 0; i < WIRES_PER_PORT; i++) {
				dest[r][c].outNorth[i].port = src[r][c].outNorth[i].port;
				dest[r][c].outNorth[i].index = src[r][c].outNorth[i].index;
				dest[r][c].outSouth[i].port = src[r][c].outSouth[i].port;
				dest[r][c].outSouth[i].index = src[r][c].outSouth[i].index;
				dest[r][c].outEast[i].port = src[r][c].outEast[i].port;
				dest[r][c].outEast[i].index = src[r][c].outEast[i].index;
				dest[r][c].outWest[i].port = src[r][c].outWest[i].port;
				dest[r][c].outWest[i].index = src[r][c].outWest[i].index;
				dest[r][c].outLocal[i].port = src[r][c].outLocal[i].port;
				dest[r][c].outLocal[i].index = src[r][c].outLocal[i].index ;
			}
		}
	}
}
//--^-- routerCopy ------------------------------------------------------------

//--v-- initializeRouters -----------------------------------------------------
void initializeRouters(void) {
	int r, c, i;
	
	for(r = 0; r < ROW_MAX; r++) {
		for(c = 0; c < COL_MAX; c++) {
			for(i = 0; i < WIRES_PER_PORT; i++) {
				NOC[r][c].outNorth[i].port = 'F';
				NOC[r][c].outNorth[i].index = 0;
				NOC[r][c].outSouth[i].port = 'F';
				NOC[r][c].outSouth[i].index = 0;
				NOC[r][c].outEast[i].port = 'F';
				NOC[r][c].outEast[i].index = 0;
				NOC[r][c].outWest[i].port = 'F';
				NOC[r][c].outWest[i].index = 0;
				NOC[r][c].outLocal[i].port = 'F';
				NOC[r][c].outLocal[i].index = 0;
			}
		}
	}
}
//--^-- initializeRouters -----------------------------------------------------

//--v-- decToBin --------------------------------------------------------------
void decToBin(int number, int bitLength, unsigned char str[]) {
	int i, x, y;
	x = y = 0;

	for(i= 0, y = bitLength - 1; y >= 0; y--) {
		x = number / (1 << y);
		number = number - x * (1 << y);
		str[i++] = 0x30+x;
	}
	str[i] = '\0';
}
//--^-- decToBin --------------------------------------------------------------

//--v-- binToHex --------------------------------------------------------------
void binToHex(unsigned char binary[], unsigned char *left, unsigned char *right) {
	int i;

	i = binary[3]-0x30 + 2*(binary[2]-0x30) + 4*(binary[1]-0x30) + 8*(binary[0]-0x30);
	switch(i) {
		case 0:		*left = '0';
					break;
		case 1:		*left = '1';
					break;
		case 2:		*left = '2';
					break;
		case 3:		*left = '3';
					break;
		case 4:		*left = '4';
					break;
		case 5:		*left = '5';
					break;
		case 6:		*left = '6';
					break;
		case 7:		*left = '7';
					break;
		case 8:		*left = '8';
					break;
		case 9:		*left = '9';
					break;
		case 10:	*left = 'A';
					break;
		case 11:	*left = 'B';
					break;
		case 12:	*left = 'C';
					break;
		case 13:	*left = 'D';
					break;
		case 14:	*left = 'E';
					break;
		case 15:	*left = 'F';
					break;
		default:
					break;
	}
	
	i = binary[7]-0x30 + 2*(binary[6]-0x30) + 4*(binary[5]-0x30) + 8*(binary[4]-0x30);
	switch(i) {
		case 0:		*right = '0';
					break;
		case 1:		*right = '1';
					break;
		case 2:		*right = '2';
					break;
		case 3:		*right = '3';
					break;
		case 4:		*right = '4';
					break;
		case 5:		*right = '5';
					break;
		case 6:		*right = '6';
					break;
		case 7:		*right = '7';
					break;
		case 8:		*right = '8';
					break;
		case 9:		*right = '9';
					break;
		case 10:	*right = 'A';
					break;
		case 11:	*right = 'B';
					break;
		case 12:	*right = 'C';
					break;
		case 13:	*right = 'D';
					break;
		case 14:	*right = 'E';
					break;
		case 15:	*right = 'F';
					break;
		default:
					break;
	}
}
//--^-- binToHex --------------------------------------------------------------
//--v-- generateVhdlNiSerializer ----------------------------------------------------
void generateVhdlNiSerializer(void) {
	int i;
	FILE *outFile;

	#ifdef DEBUG
		printf("Generating niSerializer.vhd...");
	#endif

	outFile = fopen("generated/niSerializer.vhd", "w");

	fprintf(outFile, "-- VHDL for outFsm\n");
	fprintf(outFile, "-- Joseph Yang\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "library	IEEE;\n");
	fprintf(outFile, "use		IEEE.std_logic_1164.all;\n");
	fprintf(outFile, "use		IEEE.std_logic_ARITH.all;\n");
	fprintf(outFile, "use		ieee.std_logic_unsigned.all;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "entity niSerializer is\n");
	fprintf(outFile, "	port\n");
	fprintf(outFile, "	(\n");
	fprintf(outFile, "		dataToSend			: in	std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "		dataToSendNew		: in	std_logic;\n");
	fprintf(outFile, "		dataToSendNewAck	: out	std_logic;\n");
	fprintf(outFile, "		output				: out	std_logic;\n");
	fprintf(outFile, "		idle				: out	std_logic;\n");
	fprintf(outFile, "		\n");
	fprintf(outFile, "		CLK					: in	std_logic;\n");
	fprintf(outFile, "		RST					: in	std_logic\n");
	fprintf(outFile, "	);\n");
	fprintf(outFile, "end niSerializer;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "architecture structure of niSerializer is\n");
	fprintf(outFile, "	type t_state is (IDLE_STATE, wait1, wait2");
	for(i = DATA_WIDTH-1; i >= 0; i--) {
		fprintf(outFile, ", b%d", i);
	}
	fprintf(outFile, ");\n");

	fprintf(outFile, "	signal state		: t_state;\n");
	fprintf(outFile, "	\n");
	fprintf(outFile, "	signal shiftReg		: std_logic_vector(%d downto 0);\n", DATA_WIDTH-1);
	fprintf(outFile, "begin\n");
	fprintf(outFile, "	process (CLK, RST)\n");
	fprintf(outFile, "	begin\n");
	fprintf(outFile, "		if (RST = '0') then\n");
	fprintf(outFile, "			dataToSendNewAck	<= '0';\n");
	fprintf(outFile, "			output				<= '0';\n");
	fprintf(outFile, "			idle				<= '1';\n");
	fprintf(outFile, "			state				<= IDLE_STATE;\n");
	fprintf(outFile, "		elsif (CLK'event and CLK = '1') then\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "			case state is\n");
	fprintf(outFile, "				when IDLE_STATE =>\n");
	fprintf(outFile, "					idle	<= '1';\n");
	fprintf(outFile, "					output	<= '0';\n");
	fprintf(outFile, "					if ((dataToSendNew = '1')) then\n");
	fprintf(outFile, "						shiftReg				<= dataToSend;\n");
	fprintf(outFile, "						dataToSendNewAck		<= '1';\n");
	fprintf(outFile, "						state					<= b31;\n");
	fprintf(outFile, "						idle					<= '0';\n");

	fprintf(outFile, "					end if;\n");
	fprintf(outFile, "\n");

	for(i = DATA_WIDTH-1; i > 0; i--) {
		fprintf(outFile, "				when b%d =>\n", i);
		fprintf(outFile, "					output	<= shiftReg(%d);\n", i);
		fprintf(outFile, "					state	<= b%d;\n", i-1);
		if(i==31){
			fprintf(outFile, "					dataToSendNewAck        <= '0';\n");
		}
		fprintf(outFile, "\n");
	}

	fprintf(outFile, "				when b0 =>\n");
	fprintf(outFile, "					output	<= shiftReg(0);\n");
	fprintf(outFile, "					state	<= IDLE_STATE;\n");
	fprintf(outFile, "\n");
	fprintf(outFile, "				when others =>\n");
	fprintf(outFile, "					null;\n");
	fprintf(outFile, "			end case;\n");
	fprintf(outFile, "		end if;\n");
	fprintf(outFile, "	end process;\n");
	fprintf(outFile, "end structure;\n");

	fclose(outFile);

	#ifdef DEBUG
		printf("done!\n");
	#endif
}
//--^-- generateVhdlNiSerializer ----------------------------------------------------
