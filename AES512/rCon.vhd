----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    06:16:21 06/17/2009 
-- Design Name: 
-- Module Name:    rCon - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: here extracting the corrent rcon value from rcon array declared into aPack
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

entity rCon is
	PORT(
		clk:				in		std_logic;
		rConIndex:		in		integer range 0 to 16;
		outValue:		out	std_logic_vector(7 downto 0)
	);
end rCon;

architecture Behavioral of rCon is
begin

	outValue <= rCon_array(rConIndex);

end Behavioral;

