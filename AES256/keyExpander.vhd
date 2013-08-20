----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    15:01:05 06/04/2009 
-- Design Name: 
-- Module Name:    keyExpander - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: here is implemeted the AES key schedule (expansion).
--		Key expasion is made using the keyExpasionUnit module.
--		We have a FSA that control input and output data from this module.
--		This module can execute all operating needed to expand key.
--		Output data are stored into expKey array.
--		At the end of all operation expKeyReady flag is set to '1'.
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aPack.ALL;


entity keyExpander is
	PORT(
		clk:				in			std_logic;
		rst:				in			std_logic;
		keyEnable:		in			std_logic;
		aesKey:			in			std_logic_vector(511 downto 0);		
		expKey:			out		expKeyType;
		expKeyReady:	out		std_logic
	);
end keyExpander;

architecture Behavioral of keyExpander is

	component keyExpansionUnit is
		PORT(
			clk:					in		std_logic;
			rst:					in		std_logic;
			enableIn:			in		std_logic;
			counterIn:			in		counterType;
			wordIn:				in		keyWordType;
			wordIn_toXor:		in		keyWordType;
			enableOut:			out	std_logic;
			wordOut:				out	keyWordType;
			counterOut:			out	counterType
		);
	end component;
	

	signal		counter:			integer range 0 to 367	:= 64;		
	signal 		expKey_temp:	expKeyType;
	signal		cur_expkey:		expKeyType;
	signal		inTemp:			keyWordType;
	signal		inTemp_toXor:	keyWordType;
	signal		outTemp:			keyWordType;

	type STATE_TYPE is (RESET, CHECKSTATE, AESCOPIER, LOADING, ELABORATING, SAVING, STANDBY, PRELOAD, READY, STOPPED);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;
	
	
	signal unitEnabler, unitReady:		std_logic;
	signal unitCounterTemp, unitCounterIn, unitCounterOut : counterType;
	signal n:	integer range 0 to 59 := 16;
	signal regist,next_reg:expKeyType;

begin


	-- Copying the 512bit original key into the expKey
	xLoop:		for i in 0 to 31 generate
			yLoop:		for j in 0 to 7 generate
								expKey_temp(i)(7-j) <= aesKey(255-((i*8) + j));
							End generate;
						End generate;
					
	-- mappig  keyExpansionUnit core
	keyExpansionUnit_instance: keyExpansionUnit PORT MAP(clk, '0', unitEnabler, unitCounterIn, inTemp, inTemp_toXor, unitReady, outTemp, unitCounterOut);							



	-- desing of FSA that manage the input and output data and operations of keyExpansionUnit
	COMBIN: process(CURRENT_STATE)
		begin
			case CURRENT_STATE is
			
				when CHECKSTATE =>
						if (keyEnable = '1') then
							NEXT_STATE <= AESCOPIER;
						else
							NEXT_STATE <= RESET;						
						End if;
						
				when RESET =>
						unitEnabler <= '0';
						n <= 16;
						unitCounterTemp <= 64;
						NEXT_STATE <= CHECKSTATE;
						
				when AESCOPIER =>
						next_reg<=expKey_Temp;
						NEXT_STATE <= LOADING;

				when LOADING =>
						
						inTemp(3) <= regist((n*4)-1);
						inTemp(2) <= regist((n*4)-2);
						inTemp(1) <= regist((n*4)-3);
						inTemp(0) <= regist((n*4)-4);
						
						inTemp_toXor(3) <= regist((n*4)-13);
						inTemp_toXor(2) <= regist((n*4)-14);
						inTemp_toXor(1) <= regist((n*4)-15);
						inTemp_toXor(0) <= regist((n*4)-16);						
						
						
						unitCounterIn <= unitCounterTemp;
							
						NEXT_STATE <= ELABORATING;	
			
				when ELABORATING =>
						unitEnabler <= '1';
						NEXT_STATE <= SAVING;	
				
				when SAVING =>
						if (unitReady='0') then
							NEXT_STATE <= STANDBY;					
						else

							next_reg(n*4) 		<= outTemp(0);
							next_reg((n*4)+1) <= outTemp(1);
							next_reg((n*4)+2) <= outTemp(2);
							next_reg((n*4)+3) <= outTemp(3);
							
							unitCounterTemp <= unitCounterOut;
							
							if (n=59) then
								NEXT_STATE <= READY;
							else
								NEXT_STATE <= PRELOAD;							
							End if;
						End if;

				when STANDBY =>
						NEXT_STATE <= SAVING;
						
				when PRELOAD =>
							unitEnabler <= '0';
							n <= n+1;
							NEXT_STATE <= LOADING;
							
				when READY =>
							expKey <= regist;
							expKeyReady <= '1';
							NEXT_STATE <= STOPPED;
							
				when STOPPED =>
							NEXT_STATE <= STOPPED;
			end case;
		End process;

							
	 -- Process to hold synchronous elements
		SYNCH: process
		begin
		if clk'event and clk = '1' then
			if (rst='1') then
				CURRENT_STATE <= RESET;
			else			  
				 regist <= next_reg;
				 CURRENT_STATE <= NEXT_STATE;
			End if;
		End if;
		end process;




end Behavioral;


