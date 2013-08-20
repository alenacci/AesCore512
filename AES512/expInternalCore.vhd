----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    06:25:13 06/17/2009 
-- Design Name: 
-- Module Name:    expInternalCore - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Transformation of AES-Key Schedule algorithm are applicated here.
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

entity expInternalCore is
	PORT(
		clk:				in			std_logic;
		keyWordIn:		in			keyWordType;
		counter:			in			integer range 0 to 368;	
		keyWordOut:		out		keyWordType
	);
end expInternalCore;

architecture Behavioral of expInternalCore is

	component subWord is
		PORT(
			clk:				in			std_logic;
			keyWordIn:		in			keyWordType;
			keyWordOut:		out		keyWordType
		);
	end component;

	component rotWord is
		PORT(
			clk:				in			std_logic;
			keyWordIn:		in			keyWordType;
			keyWordOut:		out		keyWordType
		);
	end component;

	component rCon is
		PORT(
			clk:			in		std_logic;
			rConIndex:		in		integer range 0 to 16;
			outValue:	out	std_logic_vector(7 downto 0)
		);
	end component;
	
	signal 	subWord_keyWordIn:	keyWordType;
	signal	subWord_keyWordOut:	keyWordType;

	signal 	rotWord_keyWordIn:	keyWordType;
	signal	rotWord_keyWordOut:	keyWordType;
	
	signal	rCon_extractedValue:	std_logic_vector(7 downto 0);

	signal 	counterDiv64: integer range 0 to 16;				


begin

		
		counterDiv64 <= counter / 64;


		subWord_keyWordIn <= keyWordIn;
		rotWord_keyWordIn <= subWord_keyWordOut;
		
		subWord_instance	: subWord 	PORT MAP (clk, subWord_keyWordIn, subWord_keyWordOut);		
		rotWord_instance	:	rotWord 	PORT MAP (clk, rotWord_keyWordIn, rotWord_keyWordOut);

		
		rCon_istance		:	rCon		PORT MAP (clk, counterDiv64, rCon_extractedValue);
		
		
		keyWordOut(3) <= rotWord_keyWordOut(3);
		keyWordOut(2) <= rotWord_keyWordOut(2);
		keyWordOut(1) <= rotWord_keyWordOut(1);
		keyWordOut(0) <= rotWord_keyWordOut(0) xor rCon_extractedValue;
		
end Behavioral;

