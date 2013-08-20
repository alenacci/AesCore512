----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:16 06/04/2009 
-- Design Name: 
-- Module Name:    encypher - Behavioral 
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

entity encypherOPT2 is
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
end encypherOPT2;

architecture Behavioral of encypherOPT2 is
	component round is
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
	
	component lastRound is
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
	
	component addRoundKey is
		PORT(
			clk:			in		std_logic;
			partialKey:	in		partialExpKeyType;
			inState:		in		stateMatrix;
			outState:	out	stateMatrix
		);
	end component;
	
	signal 	partialKeyArray:			partialExpKeyArrayType;	
	signal	enablerArray:				std_logic_vector(22 downto 0);
	signal	enablerArray_next:		std_logic_vector(22 downto 0);
	signal	regist_next:				arrStateMatrix_type;
	signal	regist:						arrStateMatrix_type;
	signal 	encOutput_next:			stateMatrix;
	signal	dataAvailable_next:		std_logic;
	
	type STATE_TYPE is (CHECK, RESET, ACTIVE);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;

begin

	--k(0) <= expKey(15 downto 0);
	

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
		

	firstAddRoundKey_instance:  addRoundKey PORT MAP (clk, partialKeyArray(0), encInput, regist_next(0));
	
	roundManager:		FOR j IN 0 to 20 GENERATE
								generalRound:  round PORT MAP (clk, rst, partialKeyArray(j+1), enablerArray(j), regist(j), enablerArray_next(j+1) ,regist_next(j+1));
							END GENERATE;

	lastRound_instance:  lastRound PORT MAP (clk, rst, partialKeyArray(22), enablerArray(21), regist(21), enablerArray_next(22), regist_next(22));



	COMBIN: process(CURRENT_STATE, expKeyReady, enable, enablerArray, regist)
	begin
	--if (enabled='1') then
		 case CURRENT_STATE is
			when RESET => 
					dataAvailable_next <= '0';
					enablerArray_next(0) <= '0';
					NEXT_STATE <= CHECK;
					 
			when CHECK =>
					if (expKeyReady='1') then
						if (enable = '1') then
							enablerArray_next(0) <= '1';
							NEXT_STATE <= ACTIVE;
						else
							NEXT_STATE <= RESET;
						End if;
					else
						NEXT_STATE <= RESET;
					End if;
								
			when ACTIVE =>
					dataAvailable_next <= enablerArray(22);
					encOutput_next <= regist(22);				
					enablerArray_next(0) <= enable;	
					
					NEXT_STATE <= ACTIVE;
					
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
			 regist <= regist_next;
			 dataAvailable <= dataAvailable_next;
			 enablerArray <= enablerArray_next;
			 encOutput <= encOutput_next;
		End if;
	End if;
  end process;
			  
									
--	process(clk,expKeyReady)
--	begin
--		--if (clk'event and clk = '1' and expKeyReady='1') then
--		if (clk'event and clk = '1') then
--			encOutput <= inASM(22);
--		End if;
--	end process;


end Behavioral;

