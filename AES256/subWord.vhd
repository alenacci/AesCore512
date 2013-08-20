----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    16:49:24 06/12/2009 
-- Design Name: 
-- Module Name:    subWord - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: subWord applies the substitution using sbox AES table to an entire word.
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

entity subWord is
	PORT(
		clk:				in			std_logic;
		keyWordIn:		in			keyWordType;
		keyWordOut:		out		keyWordType
		--outVector:		out	std_logic_vector(31 downto 0);		
	);
end subWord;

architecture Behavioral of subWord is

	component subElement is
		PORT(
			clk:			in		std_logic;
			inValue:		in		keyElement;
			outValue:	out	keyElement
		);
	end component;

begin

	word0:	subElement	PORT MAP  (clk, keyWordIn(0), keyWordOut(0));
	word1:	subElement	PORT MAP	 (clk, keyWordIn(1), keyWordOut(1));
	word2:	subElement	PORT MAP  (clk, keyWordIn(2), keyWordOut(2));
	word3:	subElement	PORT MAP  (clk, keyWordIn(3), keyWordOut(3));
	
end Behavioral;

