-- VHDL for outFsm
-- Joseph Yang

library	IEEE;
use		IEEE.std_logic_1164.all;
use		IEEE.std_logic_ARITH.all;
use		ieee.std_logic_unsigned.all;

entity outFsm is
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
end outFsm;

architecture structure of outFsm is
	type t_state is (IDLE_STATE, START_BIT, b31, b30, b29, b28, b27, b26, b25, b24, b23, b22, b21, b20, b19, b18, b17, b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0);
	signal state		: t_state;
	
	signal shiftReg		: std_logic_vector(31 downto 0);
begin
	process (CLK, RST)
		variable currDataToSendNewAck		: std_logic := '0';
	begin
		if (RST = '0') then
			dataToSendNewAck	<= '0';
			output				<= '0';
			idle				<= '1';
			state				<= IDLE_STATE;
		elsif (CLK'event and CLK = '1') then
			if (dataToSendNew = '0') then
				currDataToSendNewAck	:= '0';
				dataToSendNewAck		<= '0';
			end if;

			case state is
				when IDLE_STATE =>
					idle	<= '1';
					output	<= '0';
					if ((dataToSendNew = '1') and (currDataToSendNewAck = '0'))then
						shiftReg				<= dataToSend;
						currDataToSendNewAck	:= '1';
						dataToSendNewAck		<= '1';
						idle					<= '0';
						state					<= START_BIT;
					end if;

				when START_BIT =>
					output	<= '1';
					state	<= b31;
				when b31 =>
					output	<= shiftReg(31);
					state	<= b30;

				when b30 =>
					output	<= shiftReg(30);
					state	<= b29;

				when b29 =>
					output	<= shiftReg(29);
					state	<= b28;

				when b28 =>
					output	<= shiftReg(28);
					state	<= b27;

				when b27 =>
					output	<= shiftReg(27);
					state	<= b26;

				when b26 =>
					output	<= shiftReg(26);
					state	<= b25;

				when b25 =>
					output	<= shiftReg(25);
					state	<= b24;

				when b24 =>
					output	<= shiftReg(24);
					state	<= b23;

				when b23 =>
					output	<= shiftReg(23);
					state	<= b22;

				when b22 =>
					output	<= shiftReg(22);
					state	<= b21;

				when b21 =>
					output	<= shiftReg(21);
					state	<= b20;

				when b20 =>
					output	<= shiftReg(20);
					state	<= b19;

				when b19 =>
					output	<= shiftReg(19);
					state	<= b18;

				when b18 =>
					output	<= shiftReg(18);
					state	<= b17;

				when b17 =>
					output	<= shiftReg(17);
					state	<= b16;

				when b16 =>
					output	<= shiftReg(16);
					state	<= b15;

				when b15 =>
					output	<= shiftReg(15);
					state	<= b14;

				when b14 =>
					output	<= shiftReg(14);
					state	<= b13;

				when b13 =>
					output	<= shiftReg(13);
					state	<= b12;

				when b12 =>
					output	<= shiftReg(12);
					state	<= b11;

				when b11 =>
					output	<= shiftReg(11);
					state	<= b10;

				when b10 =>
					output	<= shiftReg(10);
					state	<= b9;

				when b9 =>
					output	<= shiftReg(9);
					state	<= b8;

				when b8 =>
					output	<= shiftReg(8);
					state	<= b7;

				when b7 =>
					output	<= shiftReg(7);
					state	<= b6;

				when b6 =>
					output	<= shiftReg(6);
					state	<= b5;

				when b5 =>
					output	<= shiftReg(5);
					state	<= b4;

				when b4 =>
					output	<= shiftReg(4);
					state	<= b3;

				when b3 =>
					output	<= shiftReg(3);
					state	<= b2;

				when b2 =>
					output	<= shiftReg(2);
					state	<= b1;

				when b1 =>
					output	<= shiftReg(1);
					state	<= b0;

				when b0 =>
					output	<= shiftReg(0);
					state	<= IDLE_STATE;

				when others =>
					null;
			end case;
		end if;
	end process;
end structure;
