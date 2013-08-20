----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    11:25:20 05/29/2009 
-- Design Name: 
-- Module Name:    addRoundKey - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aPack.ALL;

entity addRoundKey is
	PORT(
		clk:			in		std_logic;
		partialKey:	in		partialExpKeyType;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end addRoundKey;

architecture Behavioral of addRoundKey is

begin

	outState(0)(0) <= partialKey(0)  xor inState(0)(0);
	outState(1)(0) <= partialKey(1)  xor inState(1)(0);	
	outState(2)(0) <= partialKey(2)  xor inState(2)(0);
	outState(3)(0) <= partialKey(3)  xor inState(3)(0);

	outState(0)(1) <= partialKey(4)  xor inState(0)(1);
	outState(1)(1) <= partialKey(5)  xor inState(1)(1);
	outState(2)(1) <= partialKey(6)  xor inState(2)(1);
	outState(3)(1) <= partialKey(7)  xor inState(3)(1);
	
	outState(0)(2) <= partialKey(8)  xor inState(0)(2);
	outState(1)(2) <= partialKey(9)  xor inState(1)(2);
	outState(2)(2) <= partialKey(10) xor inState(2)(2);
	outState(3)(2) <= partialKey(11) xor inState(3)(2);

	outState(0)(3) <= partialKey(12) xor inState(0)(3);
	outState(1)(3) <= partialKey(13) xor inState(1)(3);
	outState(2)(3) <= partialKey(14) xor inState(2)(3);
	outState(3)(3) <= partialKey(15) xor inState(3)(3);
	
end Behavioral;

