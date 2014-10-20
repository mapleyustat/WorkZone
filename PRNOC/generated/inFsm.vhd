-- VHDL for inFsm
-- Joseph Yang

library	IEEE;
use		IEEE.std_logic_1164.all;
use		IEEE.std_logic_ARITH.all;
use		ieee.std_logic_unsigned.all;

entity inFsm is
	port
	(
		dataToRcv			: out	std_logic_vector(31 downto 0);
		dataToRcvNew		: out	std_logic;
		dataToRcvNewAck		: in	std_logic;
		input				: in	std_logic;
		
		CLK					: in	std_logic;
		RST					: in	std_logic
	);
end inFsm;

architecture structure of inFsm is
	type t_state is (IDLE, START_BIT, b31, b30, b29, b28, b27, b26, b25, b24, b23, b22, b21, b20, b19, b18, b17, b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0);
	signal state		: t_state;
	
	signal shiftReg		: std_logic_vector(31 downto 1);
begin
	process (CLK, RST)
	begin
		if (RST = '0') then
			dataToRcv		<= "00000000000000000000000000000000";
			dataToRcvNew	<= '0';
			state			<= IDLE;
		elsif (CLK'event and CLK = '1') then
			if (dataToRcvNewAck = '1') then
				dataToRcvNew		<= '0';
			end if;

			case state is
				when IDLE =>
					if (input = '1') then
						state			<= b31;
					end if;

				when START_BIT =>
					state			<= IDLE;

				when b31 =>
					shiftReg(31)		<= input;
					state			<= b30;

				when b30 =>
					shiftReg(30)		<= input;
					state			<= b29;

				when b29 =>
					shiftReg(29)		<= input;
					state			<= b28;

				when b28 =>
					shiftReg(28)		<= input;
					state			<= b27;

				when b27 =>
					shiftReg(27)		<= input;
					state			<= b26;

				when b26 =>
					shiftReg(26)		<= input;
					state			<= b25;

				when b25 =>
					shiftReg(25)		<= input;
					state			<= b24;

				when b24 =>
					shiftReg(24)		<= input;
					state			<= b23;

				when b23 =>
					shiftReg(23)		<= input;
					state			<= b22;

				when b22 =>
					shiftReg(22)		<= input;
					state			<= b21;

				when b21 =>
					shiftReg(21)		<= input;
					state			<= b20;

				when b20 =>
					shiftReg(20)		<= input;
					state			<= b19;

				when b19 =>
					shiftReg(19)		<= input;
					state			<= b18;

				when b18 =>
					shiftReg(18)		<= input;
					state			<= b17;

				when b17 =>
					shiftReg(17)		<= input;
					state			<= b16;

				when b16 =>
					shiftReg(16)		<= input;
					state			<= b15;

				when b15 =>
					shiftReg(15)		<= input;
					state			<= b14;

				when b14 =>
					shiftReg(14)		<= input;
					state			<= b13;

				when b13 =>
					shiftReg(13)		<= input;
					state			<= b12;

				when b12 =>
					shiftReg(12)		<= input;
					state			<= b11;

				when b11 =>
					shiftReg(11)		<= input;
					state			<= b10;

				when b10 =>
					shiftReg(10)		<= input;
					state			<= b9;

				when b9 =>
					shiftReg(9)		<= input;
					state			<= b8;

				when b8 =>
					shiftReg(8)		<= input;
					state			<= b7;

				when b7 =>
					shiftReg(7)		<= input;
					state			<= b6;

				when b6 =>
					shiftReg(6)		<= input;
					state			<= b5;

				when b5 =>
					shiftReg(5)		<= input;
					state			<= b4;

				when b4 =>
					shiftReg(4)		<= input;
					state			<= b3;

				when b3 =>
					shiftReg(3)		<= input;
					state			<= b2;

				when b2 =>
					shiftReg(2)		<= input;
					state			<= b1;

				when b1 =>
					shiftReg(1)		<= input;
					state			<= b0;

				when b0 =>
					state			<= IDLE;
					dataToRcv		<= shiftReg(31 downto 1) & input;
					dataToRcvNew	<= '1';

				when others =>
					null;
			end case;
		end if;
	end process;
end structure;
