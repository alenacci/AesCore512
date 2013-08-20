----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    11:51:31 05/22/2009 
-- Design Name: 
-- Module Name:    subElement - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: subWord applies the substitution using sbox AES table to a single byte.
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aPack.ALL;

entity subElement is
	PORT(
		clk:			in		std_logic;
		inValue:		in		sboxElement_subType;
		outValue:	out	sboxElement_subType
	);
end subElement;

architecture Behavioral of subElement is
	signal sBoxIndex:	integer range 0 to 255;
	signal xIndex:		std_logic_vector(7 downto 0);
	signal yIndex:		std_logic_vector(7 downto 0);
	

	
begin
	
	xIndex <=  "0000" & inValue(3 downto 0);
	yIndex <= inValue(7 downto 4) & "0000";

	sBoxIndex <= to_integer (unsigned (xIndex + yIndex));
	
		
	outValue <= sbox(sBoxIndex);	

		


	
End Behavioral;

