----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    07:32:40 06/20/2009 
-- Design Name: 
-- Module Name:    keyExpansionUnit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: This module can elaborate a single word of the key.
--					Operating are described using a FSA.
--					The core expIntercolCore mapped here modifies data of state matrix if it is necessary
--
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

entity keyExpansionUnit is
	PORT(
		clk:					in		std_logic;
		rst:					in		std_logic;
		enableIn:			in		std_logic;
		counterIn:			in		counterType;
		wordIn:				in		keyWordType;
		wordIn_toXor:		in		keyWordType;
		enableOut:			out	std_logic := '0';
		wordOut:				out	keyWordType;
		counterOut:			out	counterType
	);
end keyExpansionUnit;

architecture Behavioral of keyExpansionUnit is
	component expInternalCore is
		PORT(
			clk:				in			std_logic;
			keyWordIn:		in			keyWordType;
			counter:			in			integer range 0 to 367;
			keyWordOut:		out		keyWordType
		);
	end component;

	type STATE_TYPE is (STANDBY, RESET, CHECKSTATUS, ACTIVE, ENDED, ENDED2);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;
	
	signal	internalCoreOut:	keyWordType;
begin

	expInternalCore_instance:  expInternalCore PORT MAP (clk, wordIn, counterIn, internalCoreOut);		

	COMBIN: process(CURRENT_STATE)
	begin

		 case CURRENT_STATE is		
			when CHECKSTATUS =>				
				  if (enableIn = '1') then
						NEXT_STATE <= ACTIVE;
				  else 
						NEXT_STATE <= STANDBY;
				  End if;
				  
			when STANDBY =>
					NEXT_STATE <= CHECKSTATUS;
					
			when RESET =>
					--wordOut <= NULL;
					enableOut <= '0';
					NEXT_STATE <= STANDBY;
			
			when ACTIVE =>
				if ((counterIn mod 64) = 0) then
					wordOut(0) <= wordIn_toXor(0) xor internalCoreOut(0);					
					wordOut(1) <= wordIn_toXor(1) xor internalCoreOut(1);					
					wordOut(2) <= wordIn_toXor(2) xor internalCoreOut(2);					
					wordOut(3) <= wordIn_toXor(3) xor internalCoreOut(3);								
				else
					wordOut(0) <= wordIn_toXor(0) xor wordIn(0);					
					wordOut(1) <= wordIn_toXor(1) xor wordIn(1);					
					wordOut(2) <= wordIn_toXor(2) xor wordIn(2);					
					wordOut(3) <= wordIn_toXor(3) xor wordIn(3);		
				End if;
				counterOut <= counterIn + 4;
				NEXT_STATE <= ENDED;		

			when ENDED =>	
				enableOut <= '1';			
				NEXT_STATE <= ENDED2;

			when ENDED2 =>	
				NEXT_STATE <= RESET;
				
		 end case;
   end process;

 -- Process to hold synchronous elements (flip-flops)
	  SYNCH: process
	  begin
	  if clk'event and clk = '1' then
			if (rst='1') then
				CURRENT_STATE <= RESET;
			else			  
				 CURRENT_STATE <= NEXT_STATE;
			End if;
	  End if;
	  end process;
			  
end Behavioral;

