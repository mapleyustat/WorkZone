-- VHDL for ni
-- Vignesh Prakasam

library	IEEE;
use		IEEE.std_logic_1164.all;

entity ni is
	port
	(
		debugProgrammingInProgress	: out	std_logic;
		
		send1_FSL_S_Data	: in	std_logic_vector(31 downto 0);
		send1_FSL_S_Exists	: in	std_logic;
		send1_FSL_S_Read	: out	std_logic;

		rcv1_FSL_M_Data		: out	std_logic_vector(31 downto 0);
		rcv1_FSL_M_Write	: out	std_logic;
		rcv1_FSL_M_Full		: in	std_logic;
		
		output				: out	std_logic_vector(7 downto 0);
		input				: in	std_logic_vector(7 downto 0);
		
		setupIn				: in	std_logic_vector(7 downto 0);
		setupInNew			: in	std_logic;
		setupInNewAck		: out	std_logic;
		
		thisRow				: in	std_logic_vector(2 downto 0);
		thisCol				: in	std_logic_vector(2 downto 0);

		Programming_inProgress : in std_logic;

		
		CLK					: in	std_logic;
		RST					: in	std_logic
	);
end ni;

architecture structure of ni is
	component sendDataDistributor is
		port
		(
			FSL_S_Data				: in	std_logic_vector(31 downto 0);
			FSL_S_Exists			: in	std_logic;
			FSL_S_Read				: out	std_logic;
			
			out7FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out7FsmDataToSendNew	: out	std_logic;
			out7FsmDataToSendNewAck	: in	std_logic;
			out7FsmIdle				: in	std_logic;
			
			out6FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out6FsmDataToSendNew	: out	std_logic;
			out6FsmDataToSendNewAck	: in	std_logic;
			out6FsmIdle				: in	std_logic;
			
			out5FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out5FsmDataToSendNew	: out	std_logic;
			out5FsmDataToSendNewAck	: in	std_logic;
			out5FsmIdle				: in	std_logic;
			
			out4FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out4FsmDataToSendNew	: out	std_logic;
			out4FsmDataToSendNewAck	: in	std_logic;
			out4FsmIdle				: in	std_logic;
			
			out3FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out3FsmDataToSendNew	: out	std_logic;
			out3FsmDataToSendNewAck	: in	std_logic;
			out3FsmIdle				: in	std_logic;
			
			out2FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out2FsmDataToSendNew	: out	std_logic;
			out2FsmDataToSendNewAck	: in	std_logic;
			out2FsmIdle				: in	std_logic;
			
			out1FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out1FsmDataToSendNew	: out	std_logic;
			out1FsmDataToSendNewAck	: in	std_logic;
			out1FsmIdle				: in	std_logic;
			
			out0FsmDataToSend		: out	std_logic_vector(31 downto 0);
			out0FsmDataToSendNew	: out	std_logic;
			out0FsmDataToSendNewAck	: in	std_logic;
			out0FsmIdle				: in	std_logic;
			
			programmingInProgress	: in	std_logic;
			sendWiresAllocated		: in	std_logic_vector(7 downto 0);
			
			CLK						: in	std_logic;
			RST						: in	std_logic
		);
	end component;

	component rcvDataCollector is
		port
		(
			FSL_M_Data				: out	std_logic_vector(31 downto 0);
			FSL_M_Write				: out	std_logic;
			FSL_M_Full				: in	std_logic;
			
			in7FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in7FsmDataToRcvNew		: in	std_logic;
			in7FsmDataToRcvNewAck	: out	std_logic;
			
			in6FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in6FsmDataToRcvNew		: in	std_logic;
			in6FsmDataToRcvNewAck	: out	std_logic;
			
			in5FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in5FsmDataToRcvNew		: in	std_logic;
			in5FsmDataToRcvNewAck	: out	std_logic;
			
			in4FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in4FsmDataToRcvNew		: in	std_logic;
			in4FsmDataToRcvNewAck	: out	std_logic;
			
			in3FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in3FsmDataToRcvNew		: in	std_logic;
			in3FsmDataToRcvNewAck	: out	std_logic;
			
			in2FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in2FsmDataToRcvNew		: in	std_logic;
			in2FsmDataToRcvNewAck	: out	std_logic;
			
			in1FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in1FsmDataToRcvNew		: in	std_logic;
			in1FsmDataToRcvNewAck	: out	std_logic;
			
			in0FsmDataToRcv			: in	std_logic_vector(31 downto 0);
			in0FsmDataToRcvNew		: in	std_logic;
			in0FsmDataToRcvNewAck	: out	std_logic;
			
			programmingInProgress	: in	std_logic;
			rcvWiresAllocated		: in	std_logic_vector(7 downto 0);
			
			CLK						: in	std_logic;
			RST						: in	std_logic
		);
	end component;

	component outFsm is
		port
		(
			dataToSend			: in	std_logic_vector(31 downto 0);
			dataToSendNew		: in	std_logic;
			dataToSendNewAck	: out	std_logic;
			output				: out	std_logic;
			idle				: out	std_logic;
			
			CLK					: in	std_logic;
			RST					: in	std_logic
		);
	end component;

	component inFsm is
		port
		(
			dataToRcv			: out	std_logic_vector(31 downto 0);
			dataToRcvNew		: out	std_logic;
			dataToRcvNewAck		: in	std_logic;
			input				: in	std_logic;
			
			CLK					: in	std_logic;
			RST					: in	std_logic
		);
	end component;

	component setupFsmNi is
		port
		(
			programmingInProgress	: out	std_logic;
			
			setupIn					: in	std_logic_vector(7 downto 0);
			setupInNew				: in	std_logic;
			setupInNewAck			: out	std_logic;
			
			send1WiresAllocated		: out	std_logic_vector(7 downto 0);
			
			rcv1WiresAllocated		: out	std_logic_vector(7 downto 0);
			
			thisRow					: in	std_logic_vector(2 downto 0);
			thisCol					: in	std_logic_vector(2 downto 0);
			
			CLK						: in	std_logic;
			RST						: in	std_logic
		);
	end component;

	signal namedSignal_Clk				: std_logic;
	signal namedSignal_Rst				: std_logic;

	signal namedSignal_send1DataDistributor_FSL_S_Data				: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_FSL_S_Exists			: std_logic;
	signal namedSignal_send1DataDistributor_FSL_S_Read				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out7FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out7FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out7FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out7FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out6FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out6FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out6FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out6FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out5FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out5FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out5FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out5FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out4FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out4FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out4FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out4FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out3FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out3FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out3FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out3FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out2FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out2FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out2FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out2FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out1FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out1FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out1FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out1FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_Out0FsmDataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_send1DataDistributor_Out0FsmDataToSendNew	: std_logic;
	signal namedSignal_send1DataDistributor_Out0FsmDataToSendNewAck	: std_logic;
	signal namedSignal_send1DataDistributor_Out0FsmIdle				: std_logic;
	
	signal namedSignal_send1DataDistributor_programmingInProgress	: std_logic;
	signal namedSignal_send1DataDistributor_sendWiresAllocated		: std_logic_vector(7 downto 0);
	
	signal namedSignal_rcv1DataCollector_FSL_M_Data				: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_FSL_M_Write			: std_logic;
	signal namedSignal_rcv1DataCollector_FSL_M_Full				: std_logic;

	signal namedSignal_rcv1DataCollector_In7FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In7FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In7FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_In6FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In6FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In6FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_In5FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In5FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In5FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_In4FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In4FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In4FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_In3FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In3FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In3FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_In2FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In2FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In2FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_In1FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In1FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In1FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_In0FsmDataToRcv		: std_logic_vector(31 downto 0);
	signal namedSignal_rcv1DataCollector_In0FsmDataToRcvNew		: std_logic;
	signal namedSignal_rcv1DataCollector_In0FsmDataToRcvNewAck	: std_logic;
	
	signal namedSignal_rcv1DataCollector_programmingInProgress	: std_logic;
	signal namedSignal_rcv1DataCollector_rcvWiresAllocated		: std_logic_vector(7 downto 0);

	signal namedSignal_setupFsmNi_programmingInProgress	: std_logic;
	signal namedSignal_setupFsmNi_setupIn				: std_logic_vector(7 downto 0);
	signal namedSignal_setupFsmNi_setupInNew			: std_logic;
	signal namedSignal_setupFsmNi_setupInNewAck			: std_logic;
	
	signal namedSignal_setupFsmNi_send1WiresAllocated	: std_logic_vector(7 downto 0);
	
	signal namedSignal_setupFsmNi_rcv1WiresAllocated	: std_logic_vector(7 downto 0);
	
	signal namedSignal_setupFsmNi_thisRow				: std_logic_vector(2 downto 0);
	signal namedSignal_setupFsmNi_thisCol				: std_logic_vector(2 downto 0);
	
	signal namedSignal_out7Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out7Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out7Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out7Fsm_Output			: std_logic;
	signal namedSignal_out7Fsm_Idle				: std_logic;
	signal namedSignal_out6Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out6Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out6Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out6Fsm_Output			: std_logic;
	signal namedSignal_out6Fsm_Idle				: std_logic;
	signal namedSignal_out5Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out5Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out5Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out5Fsm_Output			: std_logic;
	signal namedSignal_out5Fsm_Idle				: std_logic;
	signal namedSignal_out4Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out4Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out4Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out4Fsm_Output			: std_logic;
	signal namedSignal_out4Fsm_Idle				: std_logic;
	signal namedSignal_out3Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out3Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out3Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out3Fsm_Output			: std_logic;
	signal namedSignal_out3Fsm_Idle				: std_logic;
	signal namedSignal_out2Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out2Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out2Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out2Fsm_Output			: std_logic;
	signal namedSignal_out2Fsm_Idle				: std_logic;
	signal namedSignal_out1Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out1Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out1Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out1Fsm_Output			: std_logic;
	signal namedSignal_out1Fsm_Idle				: std_logic;
	signal namedSignal_out0Fsm_DataToSend		: std_logic_vector(31 downto 0);
	signal namedSignal_out0Fsm_DataToSendNew	: std_logic;
	signal namedSignal_out0Fsm_DataToSendNewAck	: std_logic;
	signal namedSignal_out0Fsm_Output			: std_logic;
	signal namedSignal_out0Fsm_Idle				: std_logic;

	signal namedSignal_in7Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in7Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in7Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in7Fsm_Input				: std_logic;
	signal namedSignal_in6Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in6Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in6Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in6Fsm_Input				: std_logic;
	signal namedSignal_in5Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in5Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in5Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in5Fsm_Input				: std_logic;
	signal namedSignal_in4Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in4Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in4Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in4Fsm_Input				: std_logic;
	signal namedSignal_in3Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in3Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in3Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in3Fsm_Input				: std_logic;
	signal namedSignal_in2Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in2Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in2Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in2Fsm_Input				: std_logic;
	signal namedSignal_in1Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in1Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in1Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in1Fsm_Input				: std_logic;
	signal namedSignal_in0Fsm_DataToRcv			: std_logic_vector(31 downto 0);
	signal namedSignal_in0Fsm_DataToRcvNew		: std_logic;
	signal namedSignal_in0Fsm_DataToRcvNewAck	: std_logic;
	signal namedSignal_in0Fsm_Input				: std_logic;

begin
	U_send1DataDistributor : sendDataDistributor
		port map
		(
			FSL_S_Data				=> namedSignal_send1DataDistributor_FSL_S_Data,
			FSL_S_Exists			=> namedSignal_send1DataDistributor_FSL_S_Exists,
			FSL_S_Read				=> namedSignal_send1DataDistributor_FSL_S_Read,
		
			out7FsmDataToSend		=> namedSignal_send1DataDistributor_Out7FsmDataToSend,
			out7FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out7FsmDataToSendNew,
			out7FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out7FsmDataToSendNewAck,
			out7FsmIdle				=> namedSignal_send1DataDistributor_Out7FsmIdle,
			out6FsmDataToSend		=> namedSignal_send1DataDistributor_Out6FsmDataToSend,
			out6FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out6FsmDataToSendNew,
			out6FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out6FsmDataToSendNewAck,
			out6FsmIdle				=> namedSignal_send1DataDistributor_Out6FsmIdle,
			out5FsmDataToSend		=> namedSignal_send1DataDistributor_Out5FsmDataToSend,
			out5FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out5FsmDataToSendNew,
			out5FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out5FsmDataToSendNewAck,
			out5FsmIdle				=> namedSignal_send1DataDistributor_Out5FsmIdle,
			out4FsmDataToSend		=> namedSignal_send1DataDistributor_Out4FsmDataToSend,
			out4FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out4FsmDataToSendNew,
			out4FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out4FsmDataToSendNewAck,
			out4FsmIdle				=> namedSignal_send1DataDistributor_Out4FsmIdle,
			out3FsmDataToSend		=> namedSignal_send1DataDistributor_Out3FsmDataToSend,
			out3FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out3FsmDataToSendNew,
			out3FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out3FsmDataToSendNewAck,
			out3FsmIdle				=> namedSignal_send1DataDistributor_Out3FsmIdle,
			out2FsmDataToSend		=> namedSignal_send1DataDistributor_Out2FsmDataToSend,
			out2FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out2FsmDataToSendNew,
			out2FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out2FsmDataToSendNewAck,
			out2FsmIdle				=> namedSignal_send1DataDistributor_Out2FsmIdle,
			out1FsmDataToSend		=> namedSignal_send1DataDistributor_Out1FsmDataToSend,
			out1FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out1FsmDataToSendNew,
			out1FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out1FsmDataToSendNewAck,
			out1FsmIdle				=> namedSignal_send1DataDistributor_Out1FsmIdle,
			out0FsmDataToSend		=> namedSignal_send1DataDistributor_Out0FsmDataToSend,
			out0FsmDataToSendNew	=> namedSignal_send1DataDistributor_Out0FsmDataToSendNew,
			out0FsmDataToSendNewAck	=> namedSignal_send1DataDistributor_Out0FsmDataToSendNewAck,
			out0FsmIdle				=> namedSignal_send1DataDistributor_Out0FsmIdle,
			
			programmingInProgress	=> Programming_inProgress,
			sendWiresAllocated		=> namedSignal_send1DataDistributor_sendWiresAllocated,
			
			CLK						=> namedSignal_Clk,
			RST						=> namedSignal_Rst
		);

	U_rcv1DataCollector : rcvDataCollector
		port map
		(
			FSL_M_Data				=> namedSignal_rcv1DataCollector_FSL_M_Data,
			FSL_M_Write				=> namedSignal_rcv1DataCollector_FSL_M_Write,
			FSL_M_Full				=> namedSignal_rcv1DataCollector_FSL_M_Full,
		
			in7FsmDataToRcv			=> namedSignal_rcv1DataCollector_In7FsmDataToRcv,
			in7FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In7FsmDataToRcvNew,
			in7FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In7FsmDataToRcvNewAck,
			in6FsmDataToRcv			=> namedSignal_rcv1DataCollector_In6FsmDataToRcv,
			in6FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In6FsmDataToRcvNew,
			in6FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In6FsmDataToRcvNewAck,
			in5FsmDataToRcv			=> namedSignal_rcv1DataCollector_In5FsmDataToRcv,
			in5FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In5FsmDataToRcvNew,
			in5FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In5FsmDataToRcvNewAck,
			in4FsmDataToRcv			=> namedSignal_rcv1DataCollector_In4FsmDataToRcv,
			in4FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In4FsmDataToRcvNew,
			in4FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In4FsmDataToRcvNewAck,
			in3FsmDataToRcv			=> namedSignal_rcv1DataCollector_In3FsmDataToRcv,
			in3FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In3FsmDataToRcvNew,
			in3FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In3FsmDataToRcvNewAck,
			in2FsmDataToRcv			=> namedSignal_rcv1DataCollector_In2FsmDataToRcv,
			in2FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In2FsmDataToRcvNew,
			in2FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In2FsmDataToRcvNewAck,
			in1FsmDataToRcv			=> namedSignal_rcv1DataCollector_In1FsmDataToRcv,
			in1FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In1FsmDataToRcvNew,
			in1FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In1FsmDataToRcvNewAck,
			in0FsmDataToRcv			=> namedSignal_rcv1DataCollector_In0FsmDataToRcv,
			in0FsmDataToRcvNew		=> namedSignal_rcv1DataCollector_In0FsmDataToRcvNew,
			in0FsmDataToRcvNewAck	=> namedSignal_rcv1DataCollector_In0FsmDataToRcvNewAck,
			
			programmingInProgress	=> Programming_inProgress,
			rcvWiresAllocated		=> namedSignal_rcv1DataCollector_rcvWiresAllocated,
			
			CLK						=> namedSignal_Clk,
			RST						=> namedSignal_Rst
		);

	U_out7Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out7Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out7Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out7Fsm_DataToSendNewAck,
			output				=> namedSignal_out7Fsm_Output,
			idle				=> namedSignal_out7Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_out6Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out6Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out6Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out6Fsm_DataToSendNewAck,
			output				=> namedSignal_out6Fsm_Output,
			idle				=> namedSignal_out6Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_out5Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out5Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out5Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out5Fsm_DataToSendNewAck,
			output				=> namedSignal_out5Fsm_Output,
			idle				=> namedSignal_out5Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_out4Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out4Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out4Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out4Fsm_DataToSendNewAck,
			output				=> namedSignal_out4Fsm_Output,
			idle				=> namedSignal_out4Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_out3Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out3Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out3Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out3Fsm_DataToSendNewAck,
			output				=> namedSignal_out3Fsm_Output,
			idle				=> namedSignal_out3Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_out2Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out2Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out2Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out2Fsm_DataToSendNewAck,
			output				=> namedSignal_out2Fsm_Output,
			idle				=> namedSignal_out2Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_out1Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out1Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out1Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out1Fsm_DataToSendNewAck,
			output				=> namedSignal_out1Fsm_Output,
			idle				=> namedSignal_out1Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_out0Fsm : outFsm
		port map
		(
			dataToSend			=> namedSignal_out0Fsm_DataToSend,
			dataToSendNew		=> namedSignal_out0Fsm_DataToSendNew,
			dataToSendNewAck	=> namedSignal_out0Fsm_DataToSendNewAck,
			output				=> namedSignal_out0Fsm_Output,
			idle				=> namedSignal_out0Fsm_Idle,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in7Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in7Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in7Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in7Fsm_DataToRcvNewAck,
			input				=> namedSignal_in7Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in6Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in6Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in6Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in6Fsm_DataToRcvNewAck,
			input				=> namedSignal_in6Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in5Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in5Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in5Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in5Fsm_DataToRcvNewAck,
			input				=> namedSignal_in5Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in4Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in4Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in4Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in4Fsm_DataToRcvNewAck,
			input				=> namedSignal_in4Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in3Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in3Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in3Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in3Fsm_DataToRcvNewAck,
			input				=> namedSignal_in3Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in2Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in2Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in2Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in2Fsm_DataToRcvNewAck,
			input				=> namedSignal_in2Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in1Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in1Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in1Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in1Fsm_DataToRcvNewAck,
			input				=> namedSignal_in1Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_in0Fsm : inFsm
		port map
		(
			dataToRcv			=> namedSignal_in0Fsm_DataToRcv,
			dataToRcvNew		=> namedSignal_in0Fsm_DataToRcvNew,
			dataToRcvNewAck		=> namedSignal_in0Fsm_DataToRcvNewAck,
			input				=> namedSignal_in0Fsm_Input,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_setupFsmNi : setupFsmNi
		port map
		(
			programmingInProgress	=> namedSignal_setupFsmNi_programmingInProgress,
			setupIn					=> namedSignal_setupFsmNi_setupIn,
			setupInNew				=> namedSignal_setupFsmNi_setupInNew,
			setupInNewAck			=> namedSignal_setupFsmNi_setupInNewAck,
			
			send1WiresAllocated		=> namedSignal_setupFsmNi_send1WiresAllocated,
			
			rcv1WiresAllocated		=> namedSignal_setupFsmNi_rcv1WiresAllocated,
			
			thisRow					=> namedSignal_setupFsmNi_thisRow,
			thisCol					=> namedSignal_setupFsmNi_thisCol,
			
			CLK						=> namedSignal_Clk,
			RST						=> namedSignal_Rst
		);
	
	-- Signal Assignments
	namedSignal_Clk						<= CLK;
	namedSignal_Rst						<= RST;

	debugProgrammingInProgress			<= namedSignal_setupFsmNi_programmingInProgress;
	
	namedSignal_setupFsmNi_setupIn		<= setupIn;
	namedSignal_setupFsmNi_setupInNew	<= setupInNew;
	setupInNewAck						<= namedSignal_setupFsmNi_setupInNewAck;
	
	namedSignal_setupFsmNi_thisRow		<= thisRow;
	namedSignal_setupFsmNi_thisCol		<= thisCol;
	
	namedSignal_send1DataDistributor_programmingInProgress	<= namedSignal_setupFsmNi_programmingInProgress;
	namedSignal_send1DataDistributor_sendWiresAllocated		<= namedSignal_setupFsmNi_send1WiresAllocated;
	
	namedSignal_rcv1DataCollector_programmingInProgress		<= namedSignal_setupFsmNi_programmingInProgress;
	namedSignal_rcv1DataCollector_rcvWiresAllocated			<= namedSignal_setupFsmNi_rcv1WiresAllocated;
	
	namedSignal_send1DataDistributor_FSL_S_Data				<= send1_FSL_S_Data;
	namedSignal_send1DataDistributor_FSL_S_Exists			<= send1_FSL_S_Exists;
	send1_FSL_S_Read										<= namedSignal_send1DataDistributor_FSL_S_Read;

	namedSignal_send1DataDistributor_Out7FsmDataToSendNewAck	<= namedSignal_out7Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out7FsmIdle				<= namedSignal_out7Fsm_Idle;
	namedSignal_send1DataDistributor_Out6FsmDataToSendNewAck	<= namedSignal_out6Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out6FsmIdle				<= namedSignal_out6Fsm_Idle;
	namedSignal_send1DataDistributor_Out5FsmDataToSendNewAck	<= namedSignal_out5Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out5FsmIdle				<= namedSignal_out5Fsm_Idle;
	namedSignal_send1DataDistributor_Out4FsmDataToSendNewAck	<= namedSignal_out4Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out4FsmIdle				<= namedSignal_out4Fsm_Idle;
	namedSignal_send1DataDistributor_Out3FsmDataToSendNewAck	<= namedSignal_out3Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out3FsmIdle				<= namedSignal_out3Fsm_Idle;
	namedSignal_send1DataDistributor_Out2FsmDataToSendNewAck	<= namedSignal_out2Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out2FsmIdle				<= namedSignal_out2Fsm_Idle;
	namedSignal_send1DataDistributor_Out1FsmDataToSendNewAck	<= namedSignal_out1Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out1FsmIdle				<= namedSignal_out1Fsm_Idle;
	namedSignal_send1DataDistributor_Out0FsmDataToSendNewAck	<= namedSignal_out0Fsm_DataToSendNewAck;
	namedSignal_send1DataDistributor_Out0FsmIdle				<= namedSignal_out0Fsm_Idle;

	rcv1_FSL_M_Data									<= namedSignal_rcv1DataCollector_FSL_M_Data;
	rcv1_FSL_M_Write								<= namedSignal_rcv1DataCollector_FSL_M_Write;
	namedSignal_rcv1DataCollector_FSL_M_Full			<= rcv1_FSL_M_Full;

	namedSignal_rcv1DataCollector_In7FsmDataToRcv		<= namedSignal_in7Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In7FsmDataToRcvNew	<= namedSignal_in7Fsm_DataToRcvNew;
	namedSignal_rcv1DataCollector_In6FsmDataToRcv		<= namedSignal_in6Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In6FsmDataToRcvNew	<= namedSignal_in6Fsm_DataToRcvNew;
	namedSignal_rcv1DataCollector_In5FsmDataToRcv		<= namedSignal_in5Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In5FsmDataToRcvNew	<= namedSignal_in5Fsm_DataToRcvNew;
	namedSignal_rcv1DataCollector_In4FsmDataToRcv		<= namedSignal_in4Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In4FsmDataToRcvNew	<= namedSignal_in4Fsm_DataToRcvNew;
	namedSignal_rcv1DataCollector_In3FsmDataToRcv		<= namedSignal_in3Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In3FsmDataToRcvNew	<= namedSignal_in3Fsm_DataToRcvNew;
	namedSignal_rcv1DataCollector_In2FsmDataToRcv		<= namedSignal_in2Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In2FsmDataToRcvNew	<= namedSignal_in2Fsm_DataToRcvNew;
	namedSignal_rcv1DataCollector_In1FsmDataToRcv		<= namedSignal_in1Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In1FsmDataToRcvNew	<= namedSignal_in1Fsm_DataToRcvNew;
	namedSignal_rcv1DataCollector_In0FsmDataToRcv		<= namedSignal_in0Fsm_DataToRcv;
	namedSignal_rcv1DataCollector_In0FsmDataToRcvNew	<= namedSignal_in0Fsm_DataToRcvNew;

	namedSignal_out7Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out7FsmDataToSend;

	namedSignal_out7Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out7FsmDataToSendNew;

	namedSignal_out6Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out6FsmDataToSend;

	namedSignal_out6Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out6FsmDataToSendNew;

	namedSignal_out5Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out5FsmDataToSend;

	namedSignal_out5Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out5FsmDataToSendNew;

	namedSignal_out4Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out4FsmDataToSend;

	namedSignal_out4Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out4FsmDataToSendNew;

	namedSignal_out3Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out3FsmDataToSend;

	namedSignal_out3Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out3FsmDataToSendNew;

	namedSignal_out2Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out2FsmDataToSend;

	namedSignal_out2Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out2FsmDataToSendNew;

	namedSignal_out1Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out1FsmDataToSend;

	namedSignal_out1Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out1FsmDataToSendNew;

	namedSignal_out0Fsm_DataToSend		<= namedSignal_send1DataDistributor_Out0FsmDataToSend;

	namedSignal_out0Fsm_DataToSendNew	<= namedSignal_send1DataDistributor_Out0FsmDataToSendNew;

	namedSignal_in7Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in7FsmDataToRcvNewAck;

	namedSignal_in6Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in6FsmDataToRcvNewAck;

	namedSignal_in5Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in5FsmDataToRcvNewAck;

	namedSignal_in4Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in4FsmDataToRcvNewAck;

	namedSignal_in3Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in3FsmDataToRcvNewAck;

	namedSignal_in2Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in2FsmDataToRcvNewAck;

	namedSignal_in1Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in1FsmDataToRcvNewAck;

	namedSignal_in0Fsm_DataToRcvNewAck		<= namedSignal_rcv1DataCollector_in0FsmDataToRcvNewAck;

	output	<= namedSignal_out7Fsm_Output
				& namedSignal_out6Fsm_Output
				& namedSignal_out5Fsm_Output
				& namedSignal_out4Fsm_Output
				& namedSignal_out3Fsm_Output
				& namedSignal_out2Fsm_Output
				& namedSignal_out1Fsm_Output
				& namedSignal_out0Fsm_Output;

	namedSignal_in7Fsm_Input		<= input(7);
	namedSignal_in6Fsm_Input		<= input(6);
	namedSignal_in5Fsm_Input		<= input(5);
	namedSignal_in4Fsm_Input		<= input(4);
	namedSignal_in3Fsm_Input		<= input(3);
	namedSignal_in2Fsm_Input		<= input(2);
	namedSignal_in1Fsm_Input		<= input(1);
	namedSignal_in0Fsm_Input		<= input(0);

end structure;
