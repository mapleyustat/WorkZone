-- VHDL for sendDataDistributor
-- Joseph Yang

library	IEEE;
use		IEEE.std_logic_1164.all;
use		IEEE.std_logic_ARITH.all;
use		ieee.std_logic_unsigned.all;

entity sendDataDistributor is
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
end sendDataDistributor;

architecture structure of sendDataDistributor is
	type t_state is (OUT_7, OUT_6, OUT_5, OUT_4, OUT_3, OUT_2, OUT_1, OUT_0);
	signal state				: t_state;
	
	signal tempReg				: std_logic_vector(31 downto 0);
	signal tempRegNew			: std_logic := '0';
begin
	process (CLK, RST)
	begin
		if (RST = '0') then
			tempRegNew				<= '0';
			FSL_S_Read				<= '0';
			out7FsmDataToSend		<= "00000000000000000000000000000000";
			out7FsmDataToSendNew	<= '0';
			out6FsmDataToSend		<= "00000000000000000000000000000000";
			out6FsmDataToSendNew	<= '0';
			out5FsmDataToSend		<= "00000000000000000000000000000000";
			out5FsmDataToSendNew	<= '0';
			out4FsmDataToSend		<= "00000000000000000000000000000000";
			out4FsmDataToSendNew	<= '0';
			out3FsmDataToSend		<= "00000000000000000000000000000000";
			out3FsmDataToSendNew	<= '0';
			out2FsmDataToSend		<= "00000000000000000000000000000000";
			out2FsmDataToSendNew	<= '0';
			out1FsmDataToSend		<= "00000000000000000000000000000000";
			out1FsmDataToSendNew	<= '0';
			out0FsmDataToSend		<= "00000000000000000000000000000000";
			out0FsmDataToSendNew	<= '0';
			state					<= OUT_7;
		elsif (CLK'event and CLK = '1') then
			FSL_S_Read		<= '0';
			if (FSL_S_Exists = '1') then
				if (tempRegNew = '0') then
					tempReg			<= FSL_S_Data;
					tempRegNew		<= '1';
					FSL_S_Read		<= '1';
				end if;
			end if;

			if (out7FsmDataToSendNewAck = '1') then
				out7FsmDataToSendNew		<= '0';
			end if;
			if (out6FsmDataToSendNewAck = '1') then
				out6FsmDataToSendNew		<= '0';
			end if;
			if (out5FsmDataToSendNewAck = '1') then
				out5FsmDataToSendNew		<= '0';
			end if;
			if (out4FsmDataToSendNewAck = '1') then
				out4FsmDataToSendNew		<= '0';
			end if;
			if (out3FsmDataToSendNewAck = '1') then
				out3FsmDataToSendNew		<= '0';
			end if;
			if (out2FsmDataToSendNewAck = '1') then
				out2FsmDataToSendNew		<= '0';
			end if;
			if (out1FsmDataToSendNewAck = '1') then
				out1FsmDataToSendNew		<= '0';
			end if;
			if (out0FsmDataToSendNewAck = '1') then
				out0FsmDataToSendNew		<= '0';
			end if;

			if (programmingInProgress = '0') then
				case state is
					when OUT_7 =>
						state	<= OUT_6;
						if (sendWiresAllocated(7) = '1') then
							state	<= OUT_7;
							if (tempRegNew = '1') then
								if (out7FsmIdle = '1') then 
									out7FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out7FsmDataToSendNew	<= '1';
									state					<= OUT_6;
								end if;
							end if;
						end if;
					
					when OUT_6 =>
						state	<= OUT_5;
						if (sendWiresAllocated(6) = '1') then
							state	<= OUT_6;
							if (tempRegNew = '1') then
								if (out6FsmIdle = '1') then 
									out6FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out6FsmDataToSendNew	<= '1';
									state					<= OUT_5;
								end if;
							end if;
						end if;
					
					when OUT_5 =>
						state	<= OUT_4;
						if (sendWiresAllocated(5) = '1') then
							state	<= OUT_5;
							if (tempRegNew = '1') then
								if (out5FsmIdle = '1') then 
									out5FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out5FsmDataToSendNew	<= '1';
									state					<= OUT_4;
								end if;
							end if;
						end if;
					
					when OUT_4 =>
						state	<= OUT_3;
						if (sendWiresAllocated(4) = '1') then
							state	<= OUT_4;
							if (tempRegNew = '1') then
								if (out4FsmIdle = '1') then 
									out4FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out4FsmDataToSendNew	<= '1';
									state					<= OUT_3;
								end if;
							end if;
						end if;
					
					when OUT_3 =>
						state	<= OUT_2;
						if (sendWiresAllocated(3) = '1') then
							state	<= OUT_3;
							if (tempRegNew = '1') then
								if (out3FsmIdle = '1') then 
									out3FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out3FsmDataToSendNew	<= '1';
									state					<= OUT_2;
								end if;
							end if;
						end if;
					
					when OUT_2 =>
						state	<= OUT_1;
						if (sendWiresAllocated(2) = '1') then
							state	<= OUT_2;
							if (tempRegNew = '1') then
								if (out2FsmIdle = '1') then 
									out2FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out2FsmDataToSendNew	<= '1';
									state					<= OUT_1;
								end if;
							end if;
						end if;
					
					when OUT_1 =>
						state	<= OUT_0;
						if (sendWiresAllocated(1) = '1') then
							state	<= OUT_1;
							if (tempRegNew = '1') then
								if (out1FsmIdle = '1') then 
									out1FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out1FsmDataToSendNew	<= '1';
									state					<= OUT_0;
								end if;
							end if;
						end if;
					
					when OUT_0 =>
						state	<= OUT_7;
						if (sendWiresAllocated(0) = '1') then
							state	<= OUT_0;
							if (tempRegNew = '1') then
								if (out0FsmIdle = '1') then
									out0FsmDataToSend		<= tempReg;
									tempRegNew				<= '0';
									out0FsmDataToSendNew	<= '1';
									state					<= OUT_7;
								end if;
							end if;
						end if;
					
					when others =>
						null;
				end case;
			else	-- if (programmingInProgress = '1') then
				state	<= OUT_7;
			end if;
		end if;
	end process;
end structure;
