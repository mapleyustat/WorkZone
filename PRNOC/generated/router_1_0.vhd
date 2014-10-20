-- VHDL for router
-- Vignesh Prakasam

library	IEEE;
use		IEEE.std_logic_1164.all;
use		IEEE.std_logic_ARITH.all;
use		ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;
entity router_1_0 is
	port
	(
		InE								: in	std_logic_vector(7 downto 0);
		InW								: in	std_logic_vector(7 downto 0);
		InN								: in	std_logic_vector(7 downto 0);
		InS								: in	std_logic_vector(7 downto 0);
		InL								: in	std_logic_vector(7 downto 0);
		OutE							: out	std_logic_vector(7 downto 0);
		OutW							: out	std_logic_vector(7 downto 0);
		OutN							: out	std_logic_vector(7 downto 0);
		OutS							: out	std_logic_vector(7 downto 0);
		OutL							: out	std_logic_vector(7 downto 0);
		
		--CFGLUT5
		CE_10 : in	std_logic_vector(4 downto 0);
		CDI:		in std_logic;

		CLK								: in	std_logic;
		RST								: in	std_logic
	);
end router_1_0;

architecture structure of router_1_0 is
		signal CDO_7 : std_logic;
		signal CDO_6 : std_logic;
		signal CDO_5 : std_logic;
		signal CDO_4 : std_logic;
		signal CDO_3 : std_logic;
		signal CDO_2 : std_logic;
		signal CDO_1 : std_logic;
		signal CDO_0 : std_logic;
begin

		--OutE
		CFGLUT5_inst_r10_OutE_7 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_7, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(7), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(7),
			I1 => InW(7),
			I2 => InN(7),
			I3 => InS(7),
			I4 => InL(7)
		);
		CFGLUT5_inst_r10_OutE_6 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_6, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(6), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(6),
			I1 => InW(6),
			I2 => InN(6),
			I3 => InS(6),
			I4 => InL(6)
		);
		CFGLUT5_inst_r10_OutE_5 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_5, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(5), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(5),
			I1 => InW(5),
			I2 => InN(5),
			I3 => InS(5),
			I4 => InL(5)
		);
		CFGLUT5_inst_r10_OutE_4 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_4, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(4), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(4),
			I1 => InW(4),
			I2 => InN(4),
			I3 => InS(4),
			I4 => InL(4)
		);
		CFGLUT5_inst_r10_OutE_3 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_3, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(3), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(3),
			I1 => InW(3),
			I2 => InN(3),
			I3 => InS(3),
			I4 => InL(3)
		);
		CFGLUT5_inst_r10_OutE_2 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_2, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(2), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(2),
			I1 => InW(2),
			I2 => InN(2),
			I3 => InS(2),
			I4 => InL(2)
		);
		CFGLUT5_inst_r10_OutE_1 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_1, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(1), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(1),
			I1 => InW(1),
			I2 => InN(1),
			I3 => InS(1),
			I4 => InL(1)
		);
		CFGLUT5_inst_r10_OutE_0 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_0, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutE(0), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(0), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(0),
			I1 => InW(0),
			I2 => InN(0),
			I3 => InS(0),
			I4 => InL(0)
		);

		--OutW
		CFGLUT5_inst_r10_OutW_7 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_7, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(7), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(7),
			I1 => InW(7),
			I2 => InN(7),
			I3 => InS(7),
			I4 => InL(7)
		);
		CFGLUT5_inst_r10_OutW_6 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_6, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(6), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(6),
			I1 => InW(6),
			I2 => InN(6),
			I3 => InS(6),
			I4 => InL(6)
		);
		CFGLUT5_inst_r10_OutW_5 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_5, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(5), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(5),
			I1 => InW(5),
			I2 => InN(5),
			I3 => InS(5),
			I4 => InL(5)
		);
		CFGLUT5_inst_r10_OutW_4 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_4, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(4), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(4),
			I1 => InW(4),
			I2 => InN(4),
			I3 => InS(4),
			I4 => InL(4)
		);
		CFGLUT5_inst_r10_OutW_3 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_3, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(3), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(3),
			I1 => InW(3),
			I2 => InN(3),
			I3 => InS(3),
			I4 => InL(3)
		);
		CFGLUT5_inst_r10_OutW_2 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_2, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(2), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(2),
			I1 => InW(2),
			I2 => InN(2),
			I3 => InS(2),
			I4 => InL(2)
		);
		CFGLUT5_inst_r10_OutW_1 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_1, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(1), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(1),
			I1 => InW(1),
			I2 => InN(1),
			I3 => InS(1),
			I4 => InL(1)
		);
		CFGLUT5_inst_r10_OutW_0 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_0, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutW(0), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(1), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(0),
			I1 => InW(0),
			I2 => InN(0),
			I3 => InS(0),
			I4 => InL(0)
		);

		--OutN
		CFGLUT5_inst_r10_OutN_7 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_7, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(7), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(7),
			I1 => InW(7),
			I2 => InN(7),
			I3 => InS(7),
			I4 => InL(7)
		);
		CFGLUT5_inst_r10_OutN_6 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_6, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(6), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(6),
			I1 => InW(6),
			I2 => InN(6),
			I3 => InS(6),
			I4 => InL(6)
		);
		CFGLUT5_inst_r10_OutN_5 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_5, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(5), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(5),
			I1 => InW(5),
			I2 => InN(5),
			I3 => InS(5),
			I4 => InL(5)
		);
		CFGLUT5_inst_r10_OutN_4 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_4, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(4), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(4),
			I1 => InW(4),
			I2 => InN(4),
			I3 => InS(4),
			I4 => InL(4)
		);
		CFGLUT5_inst_r10_OutN_3 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_3, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(3), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(3),
			I1 => InW(3),
			I2 => InN(3),
			I3 => InS(3),
			I4 => InL(3)
		);
		CFGLUT5_inst_r10_OutN_2 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_2, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(2), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(2),
			I1 => InW(2),
			I2 => InN(2),
			I3 => InS(2),
			I4 => InL(2)
		);
		CFGLUT5_inst_r10_OutN_1 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_1, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(1), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(1),
			I1 => InW(1),
			I2 => InN(1),
			I3 => InS(1),
			I4 => InL(1)
		);
		CFGLUT5_inst_r10_OutN_0 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_0, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutN(0), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(2), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(0),
			I1 => InW(0),
			I2 => InN(0),
			I3 => InS(0),
			I4 => InL(0)
		);

		--OutS
		CFGLUT5_inst_r10_OutS_7 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_7, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(7), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(7),
			I1 => InW(7),
			I2 => InN(7),
			I3 => InS(7),
			I4 => InL(7)
		);
		CFGLUT5_inst_r10_OutS_6 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_6, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(6), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(6),
			I1 => InW(6),
			I2 => InN(6),
			I3 => InS(6),
			I4 => InL(6)
		);
		CFGLUT5_inst_r10_OutS_5 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_5, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(5), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(5),
			I1 => InW(5),
			I2 => InN(5),
			I3 => InS(5),
			I4 => InL(5)
		);
		CFGLUT5_inst_r10_OutS_4 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_4, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(4), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(4),
			I1 => InW(4),
			I2 => InN(4),
			I3 => InS(4),
			I4 => InL(4)
		);
		CFGLUT5_inst_r10_OutS_3 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_3, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(3), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(3),
			I1 => InW(3),
			I2 => InN(3),
			I3 => InS(3),
			I4 => InL(3)
		);
		CFGLUT5_inst_r10_OutS_2 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_2, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(2), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(2),
			I1 => InW(2),
			I2 => InN(2),
			I3 => InS(2),
			I4 => InL(2)
		);
		CFGLUT5_inst_r10_OutS_1 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_1, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(1), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(1),
			I1 => InW(1),
			I2 => InN(1),
			I3 => InS(1),
			I4 => InL(1)
		);
		CFGLUT5_inst_r10_OutS_0 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_0, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutS(0), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(3), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(0),
			I1 => InW(0),
			I2 => InN(0),
			I3 => InS(0),
			I4 => InL(0)
		);

		--OutL
		CFGLUT5_inst_r10_OutL_7 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_7, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(7), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(7),
			I1 => InW(7),
			I2 => InN(7),
			I3 => InS(7),
			I4 => InL(7)
		);
		CFGLUT5_inst_r10_OutL_6 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_6, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(6), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(6),
			I1 => InW(6),
			I2 => InN(6),
			I3 => InS(6),
			I4 => InL(6)
		);
		CFGLUT5_inst_r10_OutL_5 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_5, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(5), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(5),
			I1 => InW(5),
			I2 => InN(5),
			I3 => InS(5),
			I4 => InL(5)
		);
		CFGLUT5_inst_r10_OutL_4 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_4, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(4), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(4),
			I1 => InW(4),
			I2 => InN(4),
			I3 => InS(4),
			I4 => InL(4)
		);
		CFGLUT5_inst_r10_OutL_3 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_3, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(3), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(3),
			I1 => InW(3),
			I2 => InN(3),
			I3 => InS(3),
			I4 => InL(3)
		);
		CFGLUT5_inst_r10_OutL_2 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_2, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(2), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(2),
			I1 => InW(2),
			I2 => InN(2),
			I3 => InS(2),
			I4 => InL(2)
		);
		CFGLUT5_inst_r10_OutL_1 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_1, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(1), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(1),
			I1 => InW(1),
			I2 => InN(1),
			I3 => InS(1),
			I4 => InL(1)
		);
		CFGLUT5_inst_r10_OutL_0 : CFGLUT5
		generic map (
			INIT => X'00000000')
		port map (
			CDO => CDO_0, -- Reconfiguration cascade output
			O5 => open, -- 4-LUT output
			O6 => OutL(0), -- 5-LUT output
			CDI => CDI, -- Reconfiguration data input
			CE => CE_10(4), -- Reconfiguration enable input
			CLK => CLK, -- Clock input
			I0 => InE(0),
			I1 => InW(0),
			I2 => InN(0),
			I3 => InS(0),
			I4 => InL(0)
		);
end structure;
