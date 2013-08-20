----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    08:32:08 05/29/2009 
-- Design Name: 
-- Module Name:    mixColumn - Behavioral 
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


entity mixColumn is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end mixColumn;

architecture Behavioral of mixColumn is

	component mixSingleColumn is
		PORT(
			clk:			in		std_logic;
			inValue:		in		stateRow;			-- 'stateRow' type doesn't represent a row but a column
			outValue:	out	stateRow				-- 'stateRow' type doesn't represent a row but a column
		);
	end component;



	signal c0_0, c1_0, c2_0, c3_0:	std_logic_vector(7 downto 0); 
	signal c0_1, c1_1, c2_1, c3_1:	std_logic_vector(7 downto 0); 
	signal c0_2, c1_2, c2_2, c3_2:	std_logic_vector(7 downto 0); 
	signal c0_3, c1_3, c2_3, c3_3:	std_logic_vector(7 downto 0); 
	
begin

		-- COLUMN 0
		
      c0_0 <= inState(0)(0);
      c0_1 <= inState(1)(0);
      c0_2 <= inState(2)(0);
      c0_3 <= inState(3)(0);

		outState(0)(0) <= aesMul2(c0_0) xor aesMul3(c0_1) xor c0_2 xor c0_3;
      outState(1)(0) <= c0_0 xor aesMul2(c0_1)  xor aesMul3(c0_2) xor c0_3;
		outState(2)(0) <= c0_0 xor c0_1 xor aesMul2(c0_2) xor aesMul3(c0_3);
      outState(3)(0) <= aesMul3(c0_0) xor c0_1 xor c0_2 xor aesMul2(c0_3);


		-- COLUMN 1
		
      c1_0 <= inState(0)(1);
      c1_1 <= inState(1)(1);
      c1_2 <= inState(2)(1);
      c1_3 <= inState(3)(1);

		outState(0)(1) <= aesMul2(c1_0) xor aesMul3(c1_1) xor c1_2 xor c1_3;
      outState(1)(1) <= c1_0 xor aesMul2(c1_1)  xor aesMul3(c1_2) xor c1_3;
		outState(2)(1) <= c1_0 xor c1_1 xor aesMul2(c1_2) xor aesMul3(c1_3);
      outState(3)(1) <= aesMul3(c1_0) xor c1_1 xor c1_2 xor aesMul2(c1_3);
		-- COLUMN 2
		
      c2_0 <= inState(0)(2);
      c2_1 <= inState(1)(2);
      c2_2 <= inState(2)(2);
      c2_3 <= inState(3)(2);

		outState(0)(2) <= aesMul2(c2_0) xor aesMul3(c2_1) xor c2_2 xor c2_3;
      outState(1)(2) <= c2_0 xor aesMul2(c2_1)  xor aesMul3(c2_2) xor c2_3;
		outState(2)(2) <= c2_0 xor c2_1 xor aesMul2(c2_2) xor aesMul3(c2_3);
      outState(3)(2) <= aesMul3(c2_0) xor c2_1 xor c2_2 xor aesMul2(c2_3);

   


		-- COLUMN 3
		
      c3_0 <= inState(0)(3);
      c3_1 <= inState(1)(3);
      c3_2 <= inState(2)(3);
      c3_3 <= inState(3)(3);

		outState(0)(3) <= aesMul2(c3_0) xor aesMul3(c3_1) xor c3_2 xor c3_3;
      outState(1)(3) <= c3_0 xor aesMul2(c3_1)  xor aesMul3(c3_2) xor c3_3;
		outState(2)(3) <= c3_0 xor c3_1 xor aesMul2(c3_2) xor aesMul3(c3_3);
      outState(3)(3) <= aesMul3(c3_0) xor c3_1 xor c3_2 xor aesMul2(c3_3);	



	
end Behavioral;

