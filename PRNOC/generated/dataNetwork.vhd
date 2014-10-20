-- VHDL for dataNetwork
-- Vignesh Prakasam

library	IEEE;
use		IEEE.std_logic_1164.all;

entity dataNetwork is
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
		CE_fsl_allRouter : in    std_logic_vector(31 downto 0);
		CE_fsl_Read : out std_logic;
		
		CDI_fsl_exist    : in std_logic;
		CDI_fsl_allRouter : in std_logic_vector(31 downto 0);
		CDI_fsl_Read : out std_logic;
		
		Programming_inProgress : out std_logic;
		
		CLK							: in	std_logic;
		RST							: in	std_logic
	);
end dataNetwork;

architecture structure of dataNetwork is
	component niSerializer is
		port
		(
			dataToSend            : in    std_logic_vector(31 downto 0);
			dataToSendNew        : in    std_logic;
			dataToSendNewAck    : out    std_logic;
			output                : out    std_logic;
			idle                : out    std_logic;
			CLK                    : in    std_logic;
			RST                    : in    std_logic
		);
	end component;

	component router_0_0 is
		port
		(
			InE			: in	std_logic_vector(7 downto 0);
			InW			: in	std_logic_vector(7 downto 0);
			InN			: in	std_logic_vector(7 downto 0);
			InS			: in	std_logic_vector(7 downto 0);
			InL			: in	std_logic_vector(7 downto 0);
			OutE		: out	std_logic_vector(7 downto 0);
			OutW		: out	std_logic_vector(7 downto 0);
			OutN		: out	std_logic_vector(7 downto 0);
			OutS		: out	std_logic_vector(7 downto 0);
			OutL		: out	std_logic_vector(7 downto 0);
			
			--CFGLUT5
			CE_00 : in    std_logic_vector(4 downto 0);
			CDI   : in std_logic;
			
			CLK			: in	std_logic;
			RST			: in	std_logic
		);
	end component;

	component router_0_1 is
		port
		(
			InE			: in	std_logic_vector(7 downto 0);
			InW			: in	std_logic_vector(7 downto 0);
			InN			: in	std_logic_vector(7 downto 0);
			InS			: in	std_logic_vector(7 downto 0);
			InL			: in	std_logic_vector(7 downto 0);
			OutE		: out	std_logic_vector(7 downto 0);
			OutW		: out	std_logic_vector(7 downto 0);
			OutN		: out	std_logic_vector(7 downto 0);
			OutS		: out	std_logic_vector(7 downto 0);
			OutL		: out	std_logic_vector(7 downto 0);
			
			--CFGLUT5
			CE_01 : in    std_logic_vector(4 downto 0);
			CDI   : in std_logic;
			
			CLK			: in	std_logic;
			RST			: in	std_logic
		);
	end component;

	component router_1_0 is
		port
		(
			InE			: in	std_logic_vector(7 downto 0);
			InW			: in	std_logic_vector(7 downto 0);
			InN			: in	std_logic_vector(7 downto 0);
			InS			: in	std_logic_vector(7 downto 0);
			InL			: in	std_logic_vector(7 downto 0);
			OutE		: out	std_logic_vector(7 downto 0);
			OutW		: out	std_logic_vector(7 downto 0);
			OutN		: out	std_logic_vector(7 downto 0);
			OutS		: out	std_logic_vector(7 downto 0);
			OutL		: out	std_logic_vector(7 downto 0);
			
			--CFGLUT5
			CE_10 : in    std_logic_vector(4 downto 0);
			CDI   : in std_logic;
			
			CLK			: in	std_logic;
			RST			: in	std_logic
		);
	end component;

	component router_1_1 is
		port
		(
			InE			: in	std_logic_vector(7 downto 0);
			InW			: in	std_logic_vector(7 downto 0);
			InN			: in	std_logic_vector(7 downto 0);
			InS			: in	std_logic_vector(7 downto 0);
			InL			: in	std_logic_vector(7 downto 0);
			OutE		: out	std_logic_vector(7 downto 0);
			OutW		: out	std_logic_vector(7 downto 0);
			OutN		: out	std_logic_vector(7 downto 0);
			OutS		: out	std_logic_vector(7 downto 0);
			OutL		: out	std_logic_vector(7 downto 0);
			
			--CFGLUT5
			CE_11 : in    std_logic_vector(4 downto 0);
			CDI   : in std_logic;
			
			CLK			: in	std_logic;
			RST			: in	std_logic
		);
	end component;

	signal namedSignal_Clk				: std_logic;
	signal namedSignal_Rst				: std_logic;

	signal namedSignal_router_0_0_InE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_0_InW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_0_InN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_0_InS			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_0_OutE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_0_OutW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_0_OutN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_0_OutS			: std_logic_vector(7 downto 0);
	
	signal namedSignal_router_0_1_InE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_1_InW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_1_InN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_1_InS			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_1_OutE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_1_OutW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_1_OutN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_0_1_OutS			: std_logic_vector(7 downto 0);
	
	signal namedSignal_router_1_0_InE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_0_InW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_0_InN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_0_InS			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_0_OutE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_0_OutW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_0_OutN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_0_OutS			: std_logic_vector(7 downto 0);
	
	signal namedSignal_router_1_1_InE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_1_InW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_1_InN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_1_InS			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_1_OutE			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_1_OutW			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_1_OutN			: std_logic_vector(7 downto 0);
	signal namedSignal_router_1_1_OutS			: std_logic_vector(7 downto 0);
	
	signal CE_allRouter                                : std_logic_vector (19 downto 0) := (others => '0');
	signal CE_allRouter_router                        : std_logic_vector (19 downto 0) := (others => '0');
	signal CDI_allRouter                                : std_logic := '0';

	signal Serializer_idle                            : std_logic;

	signal CE_fsl_read_prev                           : std_logic;
begin
	CE_store: process (CLK, RST)
	begin
	  if (RST = '0') then
		CE_allRouter <= (others => '0');
		CE_fsl_Read <= '0'; 
		Programming_inProgress <= '0';
	  elsif (CLK'event and CLK= '1') then
		CE_fsl_Read <= '0';
		if (CE_fsl_exist = '1') then
			CE_allRouter <= CE_fsl_allRouter(19 downto 0);
			Programming_inProgress <= CE_fsl_allRouter(20);
			CE_fsl_Read <= '1';
		end if;
	  end if;
	end process;

	CE_allRouter_router <= CE_allRouter when (Serializer_idle = '0') else (others => '0');

	CDI_Serializer : niSerializer
	port map
	(
		dataToSend            => CDI_fsl_allRouter,
		dataToSendNew        => CDI_fsl_exist,
		dataToSendNewAck    => CDI_fsl_Read,
		output                => CDI_allRouter,
		idle                    => Serializer_idle,
		CLK                     => namedSignal_Clk,
		RST                    => namedSignal_Rst
	 );

	U_router_0_0 : router_0_0
		port map
		(
			InE			=> namedSignal_router_0_0_InE,
			InW			=> namedSignal_router_0_0_InW,
			InN			=> namedSignal_router_0_0_InN,
			InS			=> namedSignal_router_0_0_InS,
			InL			=> router_0_0_InL,
			
			OutE		=> namedSignal_router_0_0_OutE,
			OutW		=> namedSignal_router_0_0_OutW,
			OutN		=> namedSignal_router_0_0_OutN,
			OutS		=> namedSignal_router_0_0_OutS,
			OutL		=> router_0_0_OutL,
			
			--CFGLUT5
			CE_00            => CE_allRouter_router(4 downto 0),
			CDI            => CDI_allRouter,
			
			CLK			=> namedSignal_Clk,
			RST			=> namedSignal_Rst
		);

	U_router_0_1 : router_0_1
		port map
		(
			InE			=> namedSignal_router_0_1_InE,
			InW			=> namedSignal_router_0_1_InW,
			InN			=> namedSignal_router_0_1_InN,
			InS			=> namedSignal_router_0_1_InS,
			InL			=> router_0_1_InL,
			
			OutE		=> namedSignal_router_0_1_OutE,
			OutW		=> namedSignal_router_0_1_OutW,
			OutN		=> namedSignal_router_0_1_OutN,
			OutS		=> namedSignal_router_0_1_OutS,
			OutL		=> router_0_1_OutL,
			
			--CFGLUT5
			CE_01            => CE_allRouter_router(9 downto 5),
			CDI            => CDI_allRouter,
			
			CLK			=> namedSignal_Clk,
			RST			=> namedSignal_Rst
		);

	U_router_1_0 : router_1_0
		port map
		(
			InE			=> namedSignal_router_1_0_InE,
			InW			=> namedSignal_router_1_0_InW,
			InN			=> namedSignal_router_1_0_InN,
			InS			=> namedSignal_router_1_0_InS,
			InL			=> router_1_0_InL,
			
			OutE		=> namedSignal_router_1_0_OutE,
			OutW		=> namedSignal_router_1_0_OutW,
			OutN		=> namedSignal_router_1_0_OutN,
			OutS		=> namedSignal_router_1_0_OutS,
			OutL		=> router_1_0_OutL,
			
			--CFGLUT5
			CE_10            => CE_allRouter_router(14 downto 10),
			CDI            => CDI_allRouter,
			
			CLK			=> namedSignal_Clk,
			RST			=> namedSignal_Rst
		);

	U_router_1_1 : router_1_1
		port map
		(
			InE			=> namedSignal_router_1_1_InE,
			InW			=> namedSignal_router_1_1_InW,
			InN			=> namedSignal_router_1_1_InN,
			InS			=> namedSignal_router_1_1_InS,
			InL			=> router_1_1_InL,
			
			OutE		=> namedSignal_router_1_1_OutE,
			OutW		=> namedSignal_router_1_1_OutW,
			OutN		=> namedSignal_router_1_1_OutN,
			OutS		=> namedSignal_router_1_1_OutS,
			OutL		=> router_1_1_OutL,
			
			--CFGLUT5
			CE_11            => CE_allRouter_router(19 downto 15),
			CDI            => CDI_allRouter,
			
			CLK			=> namedSignal_Clk,
			RST			=> namedSignal_Rst
		);

	-- Signal Assignments
	namedSignal_Clk	<= CLK;
	namedSignal_Rst	<= RST;

	namedSignal_router_0_0_InE	<= namedSignal_router_0_1_OutW;
	namedSignal_router_0_1_InE	<= "00000000";
	namedSignal_router_1_0_InE	<= namedSignal_router_1_1_OutW;
	namedSignal_router_1_1_InE	<= "00000000";
	namedSignal_router_0_0_InW	<= "00000000";
	namedSignal_router_0_1_InW	<= namedSignal_router_0_0_OutE;
	namedSignal_router_1_0_InW	<= "00000000";
	namedSignal_router_1_1_InW	<= namedSignal_router_1_0_OutE;
	namedSignal_router_0_0_InN	<= namedSignal_router_1_0_OutS;
	namedSignal_router_0_1_InN	<= namedSignal_router_1_1_OutS;
	namedSignal_router_1_0_InN	<= "00000000";
	namedSignal_router_1_1_InN	<= "00000000";
	namedSignal_router_0_0_InS	<= "00000000";
	namedSignal_router_0_1_InS	<= "00000000";
	namedSignal_router_1_0_InS	<= namedSignal_router_0_0_OutN;
	namedSignal_router_1_1_InS	<= namedSignal_router_0_1_OutN;

end structure;
