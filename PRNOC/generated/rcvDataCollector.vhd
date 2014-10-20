-- VHDL for rcvDataCollector
-- Joseph Yang

library	IEEE;
use		IEEE.std_logic_1164.all;
use		IEEE.std_logic_ARITH.all;
use		ieee.std_logic_unsigned.all;

entity rcvDataCollector is
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
end rcvDataCollector;

architecture structure of rcvDataCollector is
	type t_state is (IN_7, IN_6, IN_5, IN_4, IN_3, IN_2, IN_1, IN_0);
	signal state				: t_state;
	
	signal tempReg				: std_logic_vector(31 downto 0);
	signal tempRegNew			: std_logic := '0';
begin
	process (CLK, RST)
	begin
		if (RST = '0') then
			FSL_M_Data				<= "00000000000000000000000000000000";
			FSL_M_Write				<= '0';
			in7FsmDataToRcvNewAck	<= '0';
			in6FsmDataToRcvNewAck	<= '0';
			in5FsmDataToRcvNewAck	<= '0';
			in4FsmDataToRcvNewAck	<= '0';
			in3FsmDataToRcvNewAck	<= '0';
			in2FsmDataToRcvNewAck	<= '0';
			in1FsmDataToRcvNewAck	<= '0';
			in0FsmDataToRcvNewAck	<= '0';
			state					<= IN_7;
		elsif (CLK'event and CLK = '1') then
			FSL_M_Write		<= '0';
			if (tempRegNew = '1') then
				if (FSL_M_Full = '0') then
					FSL_M_Data			<= tempReg;
					FSL_M_Write			<= '1';
					tempRegNew			<= '0';
				end if;
			end if;
			if (in7FsmDataToRcvNew = '0') then 
				in7FsmDataToRcvNewAck	<= '0';
			end if;
			if (in6FsmDataToRcvNew = '0') then 
				in6FsmDataToRcvNewAck	<= '0';
			end if;
			if (in5FsmDataToRcvNew = '0') then 
				in5FsmDataToRcvNewAck	<= '0';
			end if;
			if (in4FsmDataToRcvNew = '0') then 
				in4FsmDataToRcvNewAck	<= '0';
			end if;
			if (in3FsmDataToRcvNew = '0') then 
				in3FsmDataToRcvNewAck	<= '0';
			end if;
			if (in2FsmDataToRcvNew = '0') then 
				in2FsmDataToRcvNewAck	<= '0';
			end if;
			if (in1FsmDataToRcvNew = '0') then 
				in1FsmDataToRcvNewAck	<= '0';
			end if;
			if (in0FsmDataToRcvNew = '0') then 
				in0FsmDataToRcvNewAck	<= '0';
			end if;

			if (programmingInProgress = '0') then
				case state is
					when IN_7 =>
						state	<= IN_6;
						if (rcvWiresAllocated(7) = '1') then
							state	<= IN_7;
							if (tempRegNew = '0') then
								if (in7FsmDataToRcvNew = '1') then 
									tempReg					<= in7FsmDataToRcv;
									tempRegNew				<= '1';
									in7FsmDataToRcvNewAck	<= '1';
									state	<= IN_6;
								end if;
							end if;
						end if;
					
					when IN_6 =>
						state	<= IN_5;
						if (rcvWiresAllocated(6) = '1') then
							state	<= IN_6;
							if (tempRegNew = '0') then
								if (in6FsmDataToRcvNew = '1') then 
									tempReg					<= in6FsmDataToRcv;
									tempRegNew				<= '1';
									in6FsmDataToRcvNewAck	<= '1';
									state	<= IN_5;
								end if;
							end if;
						end if;
					
					when IN_5 =>
						state	<= IN_4;
						if (rcvWiresAllocated(5) = '1') then
							state	<= IN_5;
							if (tempRegNew = '0') then
								if (in5FsmDataToRcvNew = '1') then 
									tempReg					<= in5FsmDataToRcv;
									tempRegNew				<= '1';
									in5FsmDataToRcvNewAck	<= '1';
									state	<= IN_4;
								end if;
							end if;
						end if;
					
					when IN_4 =>
						state	<= IN_3;
						if (rcvWiresAllocated(4) = '1') then
							state	<= IN_4;
							if (tempRegNew = '0') then
								if (in4FsmDataToRcvNew = '1') then 
									tempReg					<= in4FsmDataToRcv;
									tempRegNew				<= '1';
									in4FsmDataToRcvNewAck	<= '1';
									state	<= IN_3;
								end if;
							end if;
						end if;
					
					when IN_3 =>
						state	<= IN_2;
						if (rcvWiresAllocated(3) = '1') then
							state	<= IN_3;
							if (tempRegNew = '0') then
								if (in3FsmDataToRcvNew = '1') then 
									tempReg					<= in3FsmDataToRcv;
									tempRegNew				<= '1';
									in3FsmDataToRcvNewAck	<= '1';
									state	<= IN_2;
								end if;
							end if;
						end if;
					
					when IN_2 =>
						state	<= IN_1;
						if (rcvWiresAllocated(2) = '1') then
							state	<= IN_2;
							if (tempRegNew = '0') then
								if (in2FsmDataToRcvNew = '1') then 
									tempReg					<= in2FsmDataToRcv;
									tempRegNew				<= '1';
									in2FsmDataToRcvNewAck	<= '1';
									state	<= IN_1;
								end if;
							end if;
						end if;
					
					when IN_1 =>
						state	<= IN_0;
						if (rcvWiresAllocated(1) = '1') then
							state	<= IN_1;
							if (tempRegNew = '0') then
								if (in1FsmDataToRcvNew = '1') then 
									tempReg					<= in1FsmDataToRcv;
									tempRegNew				<= '1';
									in1FsmDataToRcvNewAck	<= '1';
									state	<= IN_0;
								end if;
							end if;
						end if;
					
					when IN_0 =>
						state	<= IN_7;
						if (rcvWiresAllocated(0) = '1') then
							state	<= IN_0;
							if (tempRegNew = '0') then
								if (in0FsmDataToRcvNew = '1') then 
									tempReg					<= in0FsmDataToRcv;
									tempRegNew				<= '1';
									in0FsmDataToRcvNewAck	<= '1';
									state	<= IN_7;
								end if;
							end if;
						end if;
					
					when others =>
						null;
				end case;
			else	-- if (programmingInProgress = '1') then
				state	<= IN_7;
				if (in7FsmDataToRcvNew = '1') then
				in7FsmDataToRcvNewAck	<= '1';
			end if;
			if (in6FsmDataToRcvNew = '1') then
				in6FsmDataToRcvNewAck	<= '1';
			end if;
			if (in5FsmDataToRcvNew = '1') then
				in5FsmDataToRcvNewAck	<= '1';
			end if;
			if (in4FsmDataToRcvNew = '1') then
				in4FsmDataToRcvNewAck	<= '1';
			end if;
			if (in3FsmDataToRcvNew = '1') then
				in3FsmDataToRcvNewAck	<= '1';
			end if;
			if (in2FsmDataToRcvNew = '1') then
				in2FsmDataToRcvNewAck	<= '1';
			end if;
			if (in1FsmDataToRcvNew = '1') then 
				in1FsmDataToRcvNewAck	<= '1';
			end if;
			if (in0FsmDataToRcvNew = '1') then
				in0FsmDataToRcvNewAck	<= '1';
			end if;
			end if;
		end if;
	end process;
end structure;
