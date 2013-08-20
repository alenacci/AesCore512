----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    15:31:09 06/12/2009 
-- Design Name: 
-- Module Name:    rotWord - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: here rotword aes transformation
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

entity rotWord is
	PORT(
		clk:				in			std_logic;
		keyWordIn:		in			keyWordType;
		keyWordOut:		out		keyWordType
	);
end rotWord;

architecture Behavioral of rotWord is
begin
	
	keyWordOut(0) <= keyWordIn(1);
	keyWordOut(1) <= keyWordIn(2);
	keyWordOut(2) <= keyWordIn(3);
	keyWordOut(3) <= keyWordIn(0);
	
end Behavioral;

