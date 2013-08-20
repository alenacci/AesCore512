----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:16 06/04/2009 
-- Design Name: 
-- Module Name:    decypher - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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
--use work.round;
--use work.lastRound;
--use work.addRoundKey;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decypherOPT2_nopipe is
	PORT(
		clk:				in			std_logic;
		rst:				in			std_logic;
		expKeyReady:	in			std_logic;
		expKey:			in			ExpKeyType;
		enable:			in			std_logic;
		encInput:		in			stateMatrix;
		dataAvailable:	out		std_logic;
		encOutput:		out		stateMatrix
	);
end decypherOPT2_nopipe;

architecture Behavioral of decypherOPT2_nopipe is
	component inv_round is
		PORT(
			clk:			in		std_logic;
			rst:			in		std_logic;
			partialKey:	in		partialExpKeyType;
			enable:		in		std_logic;
			inState:		in		stateMatrix;
			ready:		out	std_logic;
			outState:	out	stateMatrix
		);
	end component;
	
	component inv_lastRound is
		PORT(
			clk:			in		std_logic;
			rst:			in		std_logic;
			partialKey:	in		partialExpKeyType;
			enable:		in		std_logic;
			inState:		in		stateMatrix;
			ready:		out		std_logic;
			outState:	out	stateMatrix
		);
	end component;
	
	component inv_addRoundKey is
		PORT(
			clk:			in		std_logic;
			partialKey:	in		partialExpKeyType;
			inState:		in		stateMatrix;
			outState:	out	stateMatrix
		);
	end component;
	
	signal 	partialKeyArray:			partialExpKeyArrayType;	
	signal	parExpKeyRegist:			partialExpKeyType;
	signal	parExpKeyRegist_next:	partialExpKeyType;
	signal	enableRegist:				std_logic;
	signal	enableRegist_next:		std_logic;
	signal	enableRegist2:				std_logic;
	signal	enableRegistLast:			std_logic;
	signal	enableRegistLast_next:	std_logic;	
	signal	regist:						stateMatrix;
	signal	regist2:						stateMatrix;
	signal	addRoundOutput:			stateMatrix;
	signal	counter:						counterType;
	signal	counter_next:				counterType;
	
	type STATE_TYPE is (RESET, ACTIVE, LASTRND);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;

begin

	process(expKey)
			variable		n:		integer range 0 to 22	:= 0;				
			variable		i:		integer range 0 to 15	:= 0;				
	begin	
		for n in 0 to 22 loop
				for i in 0 to 15 loop
					partialKeyArray(n)(i) <= expKey((n*16) + i);
				End loop;
		End loop;
	End process;	
		

	inv_firstAddRoundKey_instance:  inv_addRoundKey PORT MAP (clk, partialKeyArray(22), encInput, addRoundOutput);
	
	generalRound:  inv_round PORT MAP (clk, rst, parExpKeyRegist, enableRegist, regist, enableRegist2, regist2);

	inv_lastRound_instance:  inv_lastRound PORT MAP (clk, rst, partialKeyArray(0), enableRegistLast, regist, dataAvailable, encOutput);
		


	COMBIN: process(CURRENT_STATE, expKeyReady, enable, regist, regist2, enableRegist, enableRegist2)
	begin
		 case CURRENT_STATE is
			when RESET => 

					enableRegistLast_next <= '0';
					counter_next <= 21;
					--NEXT_STATE <= CHECK;
					
					if (expKeyReady='1') then
						if (enable = '1') then
							enableRegist_next <= '1';
							parExpKeyRegist_next <= partialKeyArray(21);
							NEXT_STATE <= ACTIVE;
						else
							NEXT_STATE <= RESET;
						End if;
					else
						NEXT_STATE <= RESET;
					End if;
										
					 
--			when CHECK =>
--					if (expKeyReady='1') then
--						if (enable = '1') then
--							enableRegist_next <= '1';
--							parExpKeyRegist_next <= partialKeyArray(21);
--							NEXT_STATE <= ACTIVE;
--						else
--							NEXT_STATE <= RESET;
--						End if;
--					else
--						NEXT_STATE <= RESET;
--					End if;
--					
			when ACTIVE =>							
					if (counter > 0) then
						
						if(counter = 21) then
							regist <= addRoundOutput;
						else
							regist <= regist2;
						End if;
						
						counter_next <= counter - 1;
						parExpKeyRegist_next <= partialKeyArray(counter - 1);
						enableRegist_next <= '1';
						NEXT_STATE <= ACTIVE ;
					else
						regist <= regist2;
						enableRegistLast <= '1';
						NEXT_STATE <= LASTRND;
					End if;
	
			when LASTRND =>	
					enableRegistLast <= '0';
					NEXT_STATE <= RESET;
					
					
		 end case;
	--end if;
	end process;
						

  SYNCH: process
  begin
	if clk'event and clk = '1' then
		if (rst='1') then
			CURRENT_STATE <= RESET;
		else			  
			 CURRENT_STATE <= NEXT_STATE;
			 counter <= counter_next;
			 parExpKeyRegist <= parExpKeyRegist_next;
			 enableRegist <= enableRegist_next;
		End if;
	End if;
  end process;
			  
									


end Behavioral;

