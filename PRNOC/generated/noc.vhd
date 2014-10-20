-- VHDL for NOC top level
-- Vignesh Prakasam

library	IEEE;
use		IEEE.std_logic_1164.all;

entity Noc is
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
end Noc;

architecture structure of Noc is
	component dataNetwork is
		port
		(
			router_0_0_InL				: in	std_logic_vector(7 downto 0);
			router_0_0_OutL				: out	std_logic_vector(7 downto 0);
			
			router_0_1_InL				: in	std_logic_vector(7 downto 0);
			router_0_1_OutL				: out	std_logic_vector(7 downto 0);
			
			router_1_0_InL				: in	std_logic_vector(7 downto 0);
			router_1_0_OutL				: out	std_logic_vector(7 downto 0);
			
			router_1_1_InL				: in	std_logic_vector(7 downto 0);
			router_1_1_OutL				: out	std_logic_vector(7 downto 0);
			
	
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
	
	signal namedSignal_Clk : std_logic;
	signal namedSignal_Rst : std_logic;
	
begin
	U_dataNetwork : dataNetwork
		port map
		(
			router_0_0_InL				=> router_0_0_InL,
			router_0_0_OutL				=> router_0_0_OutL,
			
			router_0_1_InL				=> router_0_1_InL,
			router_0_1_OutL				=> router_0_1_OutL,
			
			router_1_0_InL				=> router_1_0_InL,
			router_1_0_OutL				=> router_1_0_OutL,
			
			router_1_1_InL				=> router_1_1_InL,
			router_1_1_OutL				=> router_1_1_OutL,
			

			--CFGLUT5
			CE_fsl_exist				=> CE_fsl_exist,
			CE_fsl_allRouter			=> CE_fsl_allRouter,
			CE_fsl_Read					=> CE_fsl_Read,

			CDI_fsl_exist				=> CDI_fsl_exist,
			CDI_fsl_allRouter			=> CDI_fsl_allRouter,
			CDI_fsl_Read				=> CDI_fsl_Read,

			Programming_inProgress      => Programming_inProgress,

			CLK			=> namedSignal_Clk,
			RST			=> namedSignal_Rst
		);

	-- Signal Assignments
	namedSignal_Clk	<= CLK;
	namedSignal_Rst	<= RST;
	
end structure;
