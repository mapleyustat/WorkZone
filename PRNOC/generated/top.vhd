-- VHDL for top
-- Joseph Yang

library	IEEE;
use		IEEE.std_logic_1164.all;

entity top_2by2_1send_1rcv is
	port
	(
		setup_FSL_S_Data					: in	std_logic_vector(7 downto 0);
		setup_FSL_S_Exists				: in	std_logic;
		setup_FSL_S_Read				: out	std_logic;
		
		ni_0_0_debugProgrammingInProgress	: out	std_logic;
		ni_0_0_send1_FSL_S_Data		: in	std_logic_vector(31 downto 0);
		ni_0_0_send1_FSL_S_Exists	: in	std_logic;
		ni_0_0_send1_FSL_S_Read		: out	std_logic;
		ni_0_0_rcv1_FSL_M_Data		: out	std_logic_vector(31 downto 0);
		ni_0_0_rcv1_FSL_M_Write		: out	std_logic;
		ni_0_0_rcv1_FSL_M_Full		: in	std_logic;
		
		ni_0_1_debugProgrammingInProgress	: out	std_logic;
		ni_0_1_send1_FSL_S_Data		: in	std_logic_vector(31 downto 0);
		ni_0_1_send1_FSL_S_Exists	: in	std_logic;
		ni_0_1_send1_FSL_S_Read		: out	std_logic;
		ni_0_1_rcv1_FSL_M_Data		: out	std_logic_vector(31 downto 0);
		ni_0_1_rcv1_FSL_M_Write		: out	std_logic;
		ni_0_1_rcv1_FSL_M_Full		: in	std_logic;
		
		ni_1_0_debugProgrammingInProgress	: out	std_logic;
		ni_1_0_send1_FSL_S_Data		: in	std_logic_vector(31 downto 0);
		ni_1_0_send1_FSL_S_Exists	: in	std_logic;
		ni_1_0_send1_FSL_S_Read		: out	std_logic;
		ni_1_0_rcv1_FSL_M_Data		: out	std_logic_vector(31 downto 0);
		ni_1_0_rcv1_FSL_M_Write		: out	std_logic;
		ni_1_0_rcv1_FSL_M_Full		: in	std_logic;
		
		ni_1_1_debugProgrammingInProgress	: out	std_logic;
		ni_1_1_send1_FSL_S_Data		: in	std_logic_vector(31 downto 0);
		ni_1_1_send1_FSL_S_Exists	: in	std_logic;
		ni_1_1_send1_FSL_S_Read		: out	std_logic;
		ni_1_1_rcv1_FSL_M_Data		: out	std_logic_vector(31 downto 0);
		ni_1_1_rcv1_FSL_M_Write		: out	std_logic;
		ni_1_1_rcv1_FSL_M_Full		: in	std_logic;
		
		--CFGLUT5
		CE_fsl_exist: in std_logic;
		CE_fsl_allRouter : in	std_logic_vector(31 downto 0);
		CE_fsl_Read : out std_logic;

		CDI_fsl_exist	: in std_logic;
		CDI_fsl_allRouter : in std_logic_vector(31 downto 0);
		CDI_fsl_Read : out std_logic;

		CLK							: in	std_logic;
		RST							: in	std_logic
	);
end top_2by2_1send_1rcv;

architecture structure of top_2by2_1send_1rcv is
	component ni is
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
	end component;

	component Noc is
		port
		(
			router_0_0_InL						: in	std_logic_vector(7 downto 0);
			router_0_0_OutL						: out	std_logic_vector(7 downto 0);
		
			router_0_1_InL						: in	std_logic_vector(7 downto 0);
			router_0_1_OutL						: out	std_logic_vector(7 downto 0);
		
			router_1_0_InL						: in	std_logic_vector(7 downto 0);
			router_1_0_OutL						: out	std_logic_vector(7 downto 0);
		
			router_1_1_InL						: in	std_logic_vector(7 downto 0);
			router_1_1_OutL						: out	std_logic_vector(7 downto 0);
		

			--CFGLUT5
			CE_fsl_exist: in std_logic;
			CE_fsl_allRouter : in	std_logic_vector(31 downto 0);
			CE_fsl_Read : out std_logic;

			CDI_fsl_exist	: in std_logic;
			CDI_fsl_allRouter : in std_logic_vector(31 downto 0);
			CDI_fsl_Read : out std_logic;

			Programming_inProgress : out std_logic;

			CLK							: in	std_logic;
			RST							: in	std_logic
		);
	end component;

	signal Programming_inProgress : std_logic;
	signal namedSignal_Clk						: std_logic;
	signal namedSignal_Rst						: std_logic;

	signal namedSignal_ni_0_0_send1_FSL_S_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_0_0_send1_FSL_S_Exists	: std_logic;
	signal namedSignal_ni_0_0_send1_FSL_S_Read		: std_logic;

	signal namedSignal_ni_0_0_rcv1_FSL_M_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_0_0_rcv1_FSL_M_Write		: std_logic;
	signal namedSignal_ni_0_0_rcv1_FSL_M_Full		: std_logic;
	
	signal namedSignal_ni_0_0_output				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_0_0_input					: std_logic_vector(7 downto 0);
	
	signal namedSignal_ni_0_0_setupIn				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_0_0_setupInNew			: std_logic;
	signal namedSignal_ni_0_0_setupInNewAck			: std_logic;
	
	signal namedSignal_ni_0_0_thisRow				: std_logic_vector(2 downto 0);
	signal namedSignal_ni_0_0_thisCol				: std_logic_vector(2 downto 0);
	
	signal namedSignal_ni_0_1_send1_FSL_S_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_0_1_send1_FSL_S_Exists	: std_logic;
	signal namedSignal_ni_0_1_send1_FSL_S_Read		: std_logic;

	signal namedSignal_ni_0_1_rcv1_FSL_M_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_0_1_rcv1_FSL_M_Write		: std_logic;
	signal namedSignal_ni_0_1_rcv1_FSL_M_Full		: std_logic;
	
	signal namedSignal_ni_0_1_output				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_0_1_input					: std_logic_vector(7 downto 0);
	
	signal namedSignal_ni_0_1_setupIn				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_0_1_setupInNew			: std_logic;
	signal namedSignal_ni_0_1_setupInNewAck			: std_logic;
	
	signal namedSignal_ni_0_1_thisRow				: std_logic_vector(2 downto 0);
	signal namedSignal_ni_0_1_thisCol				: std_logic_vector(2 downto 0);
	
	signal namedSignal_ni_1_0_send1_FSL_S_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_1_0_send1_FSL_S_Exists	: std_logic;
	signal namedSignal_ni_1_0_send1_FSL_S_Read		: std_logic;

	signal namedSignal_ni_1_0_rcv1_FSL_M_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_1_0_rcv1_FSL_M_Write		: std_logic;
	signal namedSignal_ni_1_0_rcv1_FSL_M_Full		: std_logic;
	
	signal namedSignal_ni_1_0_output				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_1_0_input					: std_logic_vector(7 downto 0);
	
	signal namedSignal_ni_1_0_setupIn				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_1_0_setupInNew			: std_logic;
	signal namedSignal_ni_1_0_setupInNewAck			: std_logic;
	
	signal namedSignal_ni_1_0_thisRow				: std_logic_vector(2 downto 0);
	signal namedSignal_ni_1_0_thisCol				: std_logic_vector(2 downto 0);
	
	signal namedSignal_ni_1_1_send1_FSL_S_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_1_1_send1_FSL_S_Exists	: std_logic;
	signal namedSignal_ni_1_1_send1_FSL_S_Read		: std_logic;

	signal namedSignal_ni_1_1_rcv1_FSL_M_Data		: std_logic_vector(31 downto 0);
	signal namedSignal_ni_1_1_rcv1_FSL_M_Write		: std_logic;
	signal namedSignal_ni_1_1_rcv1_FSL_M_Full		: std_logic;
	
	signal namedSignal_ni_1_1_output				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_1_1_input					: std_logic_vector(7 downto 0);
	
	signal namedSignal_ni_1_1_setupIn				: std_logic_vector(7 downto 0);
	signal namedSignal_ni_1_1_setupInNew			: std_logic;
	signal namedSignal_ni_1_1_setupInNewAck			: std_logic;
	
	signal namedSignal_ni_1_1_thisRow				: std_logic_vector(2 downto 0);
	signal namedSignal_ni_1_1_thisCol				: std_logic_vector(2 downto 0);
	
	signal namedSignal_noc_setupFsmRouter_0_0_setupIn			: std_logic_vector(7 downto 0);
	signal namedSignal_noc_setupFsmRouter_0_0_setupInNew		: std_logic;
	signal namedSignal_noc_setupFsmRouter_0_0_setupInNewAck		: std_logic;
	signal namedSignal_noc_setupFsmRouter_0_0_setupOutL			: std_logic_vector(7 downto 0);
	signal namedSignal_noc_setupFsmRouter_0_0_setupOutLNew		: std_logic;
	signal namedSignal_noc_setupFsmRouter_0_0_setupOutLNewAck	: std_logic;
	signal namedSignal_noc_router_0_0_InL						: std_logic_vector(7 downto 0);
	signal namedSignal_noc_router_0_0_OutL						: std_logic_vector(7 downto 0);
	
	signal namedSignal_noc_setupFsmRouter_0_1_setupOutL			: std_logic_vector(7 downto 0);
	signal namedSignal_noc_setupFsmRouter_0_1_setupOutLNew		: std_logic;
	signal namedSignal_noc_setupFsmRouter_0_1_setupOutLNewAck	: std_logic;
	signal namedSignal_noc_router_0_1_InL						: std_logic_vector(7 downto 0);
	signal namedSignal_noc_router_0_1_OutL						: std_logic_vector(7 downto 0);
	
	signal namedSignal_noc_setupFsmRouter_1_0_setupOutL			: std_logic_vector(7 downto 0);
	signal namedSignal_noc_setupFsmRouter_1_0_setupOutLNew		: std_logic;
	signal namedSignal_noc_setupFsmRouter_1_0_setupOutLNewAck	: std_logic;
	signal namedSignal_noc_router_1_0_InL						: std_logic_vector(7 downto 0);
	signal namedSignal_noc_router_1_0_OutL						: std_logic_vector(7 downto 0);
	
	signal namedSignal_noc_setupFsmRouter_1_1_setupOutL			: std_logic_vector(7 downto 0);
	signal namedSignal_noc_setupFsmRouter_1_1_setupOutLNew		: std_logic;
	signal namedSignal_noc_setupFsmRouter_1_1_setupOutLNewAck	: std_logic;
	signal namedSignal_noc_router_1_1_InL						: std_logic_vector(7 downto 0);
	signal namedSignal_noc_router_1_1_OutL						: std_logic_vector(7 downto 0);
	
	--CFGLUT5
	signal namedSignal_CE_fsl_exist: std_logic;
	signal namedSignal_CE_fsl_allRouter : std_logic_vector(31 downto 0);
	signal namedSignal_CE_fsl_Read : std_logic;

	signal namedSignal_CDI_fsl_exist	: std_logic;
	signal namedSignal_CDI_fsl_allRouter : std_logic_vector(31 downto 0);
	signal namedSignal_CDI_fsl_Read : std_logic;

begin
	U_ni_0_0 : ni
		port map
		(
			debugProgrammingInProgress	=> ni_0_0_debugProgrammingInProgress,
			
			send1_FSL_S_Data	=> namedSignal_ni_0_0_send1_FSL_S_Data,
			send1_FSL_S_Exists	=> namedSignal_ni_0_0_send1_FSL_S_Exists,
			send1_FSL_S_Read	=> namedSignal_ni_0_0_send1_FSL_S_Read,

			rcv1_FSL_M_Data		=> namedSignal_ni_0_0_rcv1_FSL_M_Data,
			rcv1_FSL_M_Write	=> namedSignal_ni_0_0_rcv1_FSL_M_Write,
			rcv1_FSL_M_Full		=> namedSignal_ni_0_0_rcv1_FSL_M_Full,
			
			output				=> namedSignal_ni_0_0_output,
			input				=> namedSignal_ni_0_0_input,
			
			setupIn				=> namedSignal_ni_0_0_setupIn,
			setupInNew			=> namedSignal_ni_0_0_setupInNew,
			setupInNewAck		=> namedSignal_ni_0_0_setupInNewAck,
			
			thisRow				=> namedSignal_ni_0_0_thisRow,
			thisCol				=> namedSignal_ni_0_0_thisCol,
			
			Programming_inProgress => Programming_inProgress,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_ni_0_1 : ni
		port map
		(
			debugProgrammingInProgress	=> ni_0_1_debugProgrammingInProgress,
			
			send1_FSL_S_Data	=> namedSignal_ni_0_1_send1_FSL_S_Data,
			send1_FSL_S_Exists	=> namedSignal_ni_0_1_send1_FSL_S_Exists,
			send1_FSL_S_Read	=> namedSignal_ni_0_1_send1_FSL_S_Read,

			rcv1_FSL_M_Data		=> namedSignal_ni_0_1_rcv1_FSL_M_Data,
			rcv1_FSL_M_Write	=> namedSignal_ni_0_1_rcv1_FSL_M_Write,
			rcv1_FSL_M_Full		=> namedSignal_ni_0_1_rcv1_FSL_M_Full,
			
			output				=> namedSignal_ni_0_1_output,
			input				=> namedSignal_ni_0_1_input,
			
			setupIn				=> namedSignal_ni_0_1_setupIn,
			setupInNew			=> namedSignal_ni_0_1_setupInNew,
			setupInNewAck		=> namedSignal_ni_0_1_setupInNewAck,
			
			thisRow				=> namedSignal_ni_0_1_thisRow,
			thisCol				=> namedSignal_ni_0_1_thisCol,
			
			Programming_inProgress => Programming_inProgress,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_ni_1_0 : ni
		port map
		(
			debugProgrammingInProgress	=> ni_1_0_debugProgrammingInProgress,
			
			send1_FSL_S_Data	=> namedSignal_ni_1_0_send1_FSL_S_Data,
			send1_FSL_S_Exists	=> namedSignal_ni_1_0_send1_FSL_S_Exists,
			send1_FSL_S_Read	=> namedSignal_ni_1_0_send1_FSL_S_Read,

			rcv1_FSL_M_Data		=> namedSignal_ni_1_0_rcv1_FSL_M_Data,
			rcv1_FSL_M_Write	=> namedSignal_ni_1_0_rcv1_FSL_M_Write,
			rcv1_FSL_M_Full		=> namedSignal_ni_1_0_rcv1_FSL_M_Full,
			
			output				=> namedSignal_ni_1_0_output,
			input				=> namedSignal_ni_1_0_input,
			
			setupIn				=> namedSignal_ni_1_0_setupIn,
			setupInNew			=> namedSignal_ni_1_0_setupInNew,
			setupInNewAck		=> namedSignal_ni_1_0_setupInNewAck,
			
			thisRow				=> namedSignal_ni_1_0_thisRow,
			thisCol				=> namedSignal_ni_1_0_thisCol,
			
			Programming_inProgress => Programming_inProgress,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_ni_1_1 : ni
		port map
		(
			debugProgrammingInProgress	=> ni_1_1_debugProgrammingInProgress,
			
			send1_FSL_S_Data	=> namedSignal_ni_1_1_send1_FSL_S_Data,
			send1_FSL_S_Exists	=> namedSignal_ni_1_1_send1_FSL_S_Exists,
			send1_FSL_S_Read	=> namedSignal_ni_1_1_send1_FSL_S_Read,

			rcv1_FSL_M_Data		=> namedSignal_ni_1_1_rcv1_FSL_M_Data,
			rcv1_FSL_M_Write	=> namedSignal_ni_1_1_rcv1_FSL_M_Write,
			rcv1_FSL_M_Full		=> namedSignal_ni_1_1_rcv1_FSL_M_Full,
			
			output				=> namedSignal_ni_1_1_output,
			input				=> namedSignal_ni_1_1_input,
			
			setupIn				=> namedSignal_ni_1_1_setupIn,
			setupInNew			=> namedSignal_ni_1_1_setupInNew,
			setupInNewAck		=> namedSignal_ni_1_1_setupInNewAck,
			
			thisRow				=> namedSignal_ni_1_1_thisRow,
			thisCol				=> namedSignal_ni_1_1_thisCol,
			
			Programming_inProgress => Programming_inProgress,
			
			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);
	
	U_noc : noc
		port map
		(
			router_0_0_InL							=> namedSignal_noc_router_0_0_InL,
			router_0_0_OutL							=> namedSignal_noc_router_0_0_OutL,
			
			router_0_1_InL							=> namedSignal_noc_router_0_1_InL,
			router_0_1_OutL							=> namedSignal_noc_router_0_1_OutL,
			
			router_1_0_InL							=> namedSignal_noc_router_1_0_InL,
			router_1_0_OutL							=> namedSignal_noc_router_1_0_OutL,
			
			router_1_1_InL							=> namedSignal_noc_router_1_1_InL,
			router_1_1_OutL							=> namedSignal_noc_router_1_1_OutL,
			
			--CFGLUT5
			CE_fsl_exist				=> CE_fsl_exist,
			CE_fsl_allRouter			=> CE_fsl_allRouter,
			CE_fsl_Read					=> CE_fsl_Read,

			CDI_fsl_exist				=> namedSignal_CDI_fsl_exist,
			CDI_fsl_allRouter			=> namedSignal_CDI_fsl_allRouter,
			CDI_fsl_Read				=> namedSignal_CDI_fsl_Read,

			Programming_inProgress      => Programming_inProgress,

			CLK					=> namedSignal_Clk,
			RST					=> namedSignal_Rst
		);

	-- Signal Assignments
	namedSignal_Clk						<= CLK;
	namedSignal_Rst						<= RST;

	namedSignal_noc_setupFsmRouter_0_0_setupIn			<= setup_FSL_S_Data;
	namedSignal_noc_setupFsmRouter_0_0_setupInNew		<= setup_FSL_S_Exists;
	setup_FSL_S_Read							<= namedSignal_noc_setupFsmRouter_0_0_setupInNewAck;
	
	namedSignal_ni_0_0_send1_FSL_S_Data			<= ni_0_0_send1_FSL_S_Data;
	namedSignal_ni_0_0_send1_FSL_S_Exists		<= ni_0_0_send1_FSL_S_Exists;
	ni_0_0_send1_FSL_S_Read						<= namedSignal_ni_0_0_send1_FSL_S_Read;

	ni_0_0_rcv1_FSL_M_Data						<= namedSignal_ni_0_0_rcv1_FSL_M_Data;
	ni_0_0_rcv1_FSL_M_Write						<= namedSignal_ni_0_0_rcv1_FSL_M_Write;
	namedSignal_ni_0_0_rcv1_FSL_M_Full			<= ni_0_0_rcv1_FSL_M_Full;
	
	namedSignal_noc_router_0_0_InL				<= namedSignal_ni_0_0_output;
	namedSignal_ni_0_0_input					<= namedSignal_noc_router_0_0_OutL;
	
	namedSignal_ni_0_0_setupIn					<= namedSignal_noc_setupFsmRouter_0_0_setupOutL;
	namedSignal_ni_0_0_setupInNew				<= namedSignal_noc_setupFsmRouter_0_0_setupOutLNew;
	namedSignal_noc_setupFsmRouter_0_0_setupOutLNewAck	<= namedSignal_ni_0_0_setupInNewAck;
	
	namedSignal_ni_0_0_thisRow				<= "000";
	namedSignal_ni_0_0_thisCol				<= "000";
	
	namedSignal_ni_0_1_send1_FSL_S_Data			<= ni_0_1_send1_FSL_S_Data;
	namedSignal_ni_0_1_send1_FSL_S_Exists		<= ni_0_1_send1_FSL_S_Exists;
	ni_0_1_send1_FSL_S_Read						<= namedSignal_ni_0_1_send1_FSL_S_Read;

	ni_0_1_rcv1_FSL_M_Data						<= namedSignal_ni_0_1_rcv1_FSL_M_Data;
	ni_0_1_rcv1_FSL_M_Write						<= namedSignal_ni_0_1_rcv1_FSL_M_Write;
	namedSignal_ni_0_1_rcv1_FSL_M_Full			<= ni_0_1_rcv1_FSL_M_Full;
	
	namedSignal_noc_router_0_1_InL				<= namedSignal_ni_0_1_output;
	namedSignal_ni_0_1_input					<= namedSignal_noc_router_0_1_OutL;
	
	namedSignal_ni_0_1_setupIn					<= namedSignal_noc_setupFsmRouter_0_1_setupOutL;
	namedSignal_ni_0_1_setupInNew				<= namedSignal_noc_setupFsmRouter_0_1_setupOutLNew;
	namedSignal_noc_setupFsmRouter_0_1_setupOutLNewAck	<= namedSignal_ni_0_1_setupInNewAck;
	
	namedSignal_ni_0_1_thisRow				<= "000";
	namedSignal_ni_0_1_thisCol				<= "001";
	
	namedSignal_ni_1_0_send1_FSL_S_Data			<= ni_1_0_send1_FSL_S_Data;
	namedSignal_ni_1_0_send1_FSL_S_Exists		<= ni_1_0_send1_FSL_S_Exists;
	ni_1_0_send1_FSL_S_Read						<= namedSignal_ni_1_0_send1_FSL_S_Read;

	ni_1_0_rcv1_FSL_M_Data						<= namedSignal_ni_1_0_rcv1_FSL_M_Data;
	ni_1_0_rcv1_FSL_M_Write						<= namedSignal_ni_1_0_rcv1_FSL_M_Write;
	namedSignal_ni_1_0_rcv1_FSL_M_Full			<= ni_1_0_rcv1_FSL_M_Full;
	
	namedSignal_noc_router_1_0_InL				<= namedSignal_ni_1_0_output;
	namedSignal_ni_1_0_input					<= namedSignal_noc_router_1_0_OutL;
	
	namedSignal_ni_1_0_setupIn					<= namedSignal_noc_setupFsmRouter_1_0_setupOutL;
	namedSignal_ni_1_0_setupInNew				<= namedSignal_noc_setupFsmRouter_1_0_setupOutLNew;
	namedSignal_noc_setupFsmRouter_1_0_setupOutLNewAck	<= namedSignal_ni_1_0_setupInNewAck;
	
	namedSignal_ni_1_0_thisRow				<= "001";
	namedSignal_ni_1_0_thisCol				<= "000";
	
	namedSignal_ni_1_1_send1_FSL_S_Data			<= ni_1_1_send1_FSL_S_Data;
	namedSignal_ni_1_1_send1_FSL_S_Exists		<= ni_1_1_send1_FSL_S_Exists;
	ni_1_1_send1_FSL_S_Read						<= namedSignal_ni_1_1_send1_FSL_S_Read;

	ni_1_1_rcv1_FSL_M_Data						<= namedSignal_ni_1_1_rcv1_FSL_M_Data;
	ni_1_1_rcv1_FSL_M_Write						<= namedSignal_ni_1_1_rcv1_FSL_M_Write;
	namedSignal_ni_1_1_rcv1_FSL_M_Full			<= ni_1_1_rcv1_FSL_M_Full;
	
	namedSignal_noc_router_1_1_InL				<= namedSignal_ni_1_1_output;
	namedSignal_ni_1_1_input					<= namedSignal_noc_router_1_1_OutL;
	
	namedSignal_ni_1_1_setupIn					<= namedSignal_noc_setupFsmRouter_1_1_setupOutL;
	namedSignal_ni_1_1_setupInNew				<= namedSignal_noc_setupFsmRouter_1_1_setupOutLNew;
	namedSignal_noc_setupFsmRouter_1_1_setupOutLNewAck	<= namedSignal_ni_1_1_setupInNewAck;
	
	namedSignal_ni_1_1_thisRow				<= "001";
	namedSignal_ni_1_1_thisCol				<= "001";
	
	--CFGLUT5
	namedSignal_CE_fsl_exist 		<= CE_fsl_exist;
	namedSignal_CE_fsl_allRouter 	<= CE_fsl_allRouter;
	
	namedSignal_CDI_fsl_exist 		<= CDI_fsl_exist;
	namedSignal_CDI_fsl_allRouter 	<= CDI_fsl_allRouter;
	CDI_fsl_Read 					<= namedSignal_CDI_fsl_Read;
	
end structure;
