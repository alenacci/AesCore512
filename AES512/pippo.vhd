
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:23:58 09/10/2009
-- Design Name:   aesCore
-- Module Name:   C:/Tesi/aesCore_fpga_v10/aesCore_fpga_v10/pippo.vhd
-- Project Name:  aesCore_fpga_v10
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: aesCore
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY pippo_vhd IS
END pippo_vhd;

ARCHITECTURE behavior OF pippo_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT aesCore
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		readKeyCmd : IN std_logic;
		partialKey : IN std_logic_vector(31 downto 0);
		enableEnc : IN std_logic;
		enableDec : IN std_logic;
		encInput : IN std_logic_vector(0 to 3);
		decInput : IN std_logic_vector(0 to 3);          
		encOutAvailable : OUT std_logic;
		decOutAvailable : OUT std_logic;
		encOutput : OUT std_logic_vector(0 to 3);
		decOutput : OUT std_logic_vector(0 to 3);
		ready : OUT std_logic;
		errorEnc : OUT std_logic;
		errorDec : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL rst :  std_logic := '0';
	SIGNAL readKeyCmd :  std_logic := '0';
	SIGNAL enableEnc :  std_logic := '0';
	SIGNAL enableDec :  std_logic := '0';
	SIGNAL partialKey :  std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL encInput :  std_logic_vector(0 to 3) := (others=>'0');
	SIGNAL decInput :  std_logic_vector(0 to 3) := (others=>'0');

	--Outputs
	SIGNAL encOutAvailable :  std_logic;
	SIGNAL decOutAvailable :  std_logic;
	SIGNAL encOutput :  std_logic_vector(0 to 3);
	SIGNAL decOutput :  std_logic_vector(0 to 3);
	SIGNAL ready :  std_logic;
	SIGNAL errorEnc :  std_logic;
	SIGNAL errorDec :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: aesCore PORT MAP(
		clk => clk,
		rst => rst,
		readKeyCmd => readKeyCmd,
		partialKey => partialKey,
		enableEnc => enableEnc,
		enableDec => enableDec,
		encInput => encInput,
		decInput => decInput,
		encOutAvailable => encOutAvailable,
		decOutAvailable => decOutAvailable,
		encOutput => encOutput,
		decOutput => decOutput,
		ready => ready,
		errorEnc => errorEnc,
		errorDec => errorDec
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
