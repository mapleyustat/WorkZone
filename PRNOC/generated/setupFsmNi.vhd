-- VHDL for setupFsmNi
-- Vignesh Prakasam

library	IEEE;
use		IEEE.std_logic_1164.all;
use		IEEE.std_logic_ARITH.all;
use		ieee.std_logic_unsigned.all;

entity setupFsmNi is
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
end setupFsmNi;

architecture structure of setupFsmNi is
	type t_state is (IDLE, PROCESS_NI_BODY_1, PROCESS_NI_BODY_2, PROCESS_NI_BODY_3);
	signal state		: t_state;
	
	signal index		: std_logic_vector(3 downto 0);
	signal sendOrRcv	: std_logic;	-- '1' = send, '0' = rcv
begin
	process (CLK, RST)
		variable currSetupInNewAck	: std_logic;
	begin
		if (RST = '0') then
			programmingInProgress	<= '0';
			state					<= IDLE;
			index					<= "0000";
			sendOrRcv				<= '1';
			currSetupInNewAck		:= '0';
			setupInNewAck			<= '0';
			
			send1WiresAllocated		<= "00000001";
			
			rcv1WiresAllocated		<= "00000001";
		elsif (CLK'event and CLK = '1') then
			if ((setupInNew = '1') and (currSetupInNewAck = '0')) then
				case state is
					when IDLE =>
						currSetupInNewAck	:= '1';
						setupInNewAck		<= '1';
						if (setupIn(7 downto 0) = '1' & thisRow & thisCol & '1') then
							state				<= PROCESS_NI_BODY_1;
						elsif (setupIn(7 downto 1) = "1111111") then
							programmingInProgress	<= setupIn(0);
						end if;
					
					when PROCESS_NI_BODY_1 =>
						sendOrRcv		<= setupIn(6);
						index			<= setupIn(5 downto 2);
						case setupIn(5 downto 2) is
							when "0000" =>
								currSetupInNewAck	:= '1';
								setupInNewAck		<= '1';
								state				<= IDLE;
							when "0001" =>
								currSetupInNewAck	:= '1';
								setupInNewAck		<= '1';
								if (sendOrRcv = '1') then
								else
								end if;
								state				<= PROCESS_NI_BODY_2;
							when others =>
								null;
						end case;
					when PROCESS_NI_BODY_2 =>
						case index is
							when "0001" =>
								currSetupInNewAck	:= '1';
								setupInNewAck		<= '1';
								if (sendOrRcv = '1') then
									send1WiresAllocated(7)	<= setupIn(0);
								else
									rcv1WiresAllocated(7)	<= setupIn(0);
								end if;
							when others =>
								null;
						end case;
						state	<= PROCESS_NI_BODY_3;
					when PROCESS_NI_BODY_3 =>
						case index is
							when "0001" =>
								currSetupInNewAck	:= '1';
								setupInNewAck		<= '1';
								if (sendOrRcv = '1') then
									send1WiresAllocated(6)	<= setupIn(6);
									send1WiresAllocated(5)	<= setupIn(5);
									send1WiresAllocated(4)	<= setupIn(4);
									send1WiresAllocated(3)	<= setupIn(3);
									send1WiresAllocated(2)	<= setupIn(2);
									send1WiresAllocated(1)	<= setupIn(1);
									send1WiresAllocated(0)	<= setupIn(0);
								else
									rcv1WiresAllocated(6)	<= setupIn(6);
									rcv1WiresAllocated(5)	<= setupIn(5);
									rcv1WiresAllocated(4)	<= setupIn(4);
									rcv1WiresAllocated(3)	<= setupIn(3);
									rcv1WiresAllocated(2)	<= setupIn(2);
									rcv1WiresAllocated(1)	<= setupIn(1);
									rcv1WiresAllocated(0)	<= setupIn(0);
								end if;
							when others =>
								null;
						end case;
						state	<= PROCESS_NI_BODY_1;
				end case;
			end if;
			
			if (setupInNew = '0') then
				currSetupInNewAck	:= '0';
				setupInNewAck		<= '0';
			end if;
		end if;
	end process;
end structure;
