
-- ##################### AESCORE512 #####################
--	                   - core top file -

-- #######################################################
-- YOU CAN CONFIGURE AESCORE512 EDITING THIS FILE 
-- GO TO THE BOTTOM OF THIS FILE TO ENABLE/DISABLE PIPELINE
-- IF YOU NEED SOME INFORMATION CONTACT ME HERE: alenacci@gmail.com
-- #######################################################

-- WARNING: All data and signals types are defined into aPack.vhd file

----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    09:07:45 05/22/2009 
-- Design Name: 
-- Module Name:    aesCore - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: this is the main module of AES 512 enc/dec core
--		It is composed by 3 sub-core. encCore, decCore and keyExpansion.
--		There is also the logic that describe the 32bit-step reading of the key.
--		This core controls the actions of all 3 sub-modules.
--		Type declarating, important data structures and fucntions are into aPack file.
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

-- -------------------------------------
-- DATA TYPE INFORMATION:
--
-- 'stateMatrix' is a 4x4 matrix of std_logic_vector(7 downto 0)
--
-- -------------------------------------

-- #######################################################
--
--
-- #######################################################

entity aesCore is
	PORT(
		clk:					in			std_logic;
		rst:					in			std_logic;
		readKeyCmd:			in 		std_logic;
		partialKey:			in			partialKeyType;
		enableEnc:			in			std_logic;
		enableDec:			in			std_logic;
		encInput:			in			stateMatrix;
		decInput:			in			stateMatrix;
		encOutAvailable:	out		std_logic;
		decOutAvailable:	out		std_logic;
		encOutput:			out		stateMatrix;
		decOutput:			out		stateMatrix;
		ready:				out		std_logic;
		errorEnc:			out		std_logic;
		errorDec:			out		std_logic

	);
end aesCore;

architecture Behavioral of aesCore is


	component encypherOPT2 is
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
	end component;
	
	component decypherOPT2 is
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
	end component;


	component encypherOPT2_noPipe is
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
	end component;
	
	component decypherOPT2_noPipe is
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
	end component;
	
	
	component keyExpander is
	PORT(
			clk:				in			std_logic;
			rst:				in			std_logic;
			keyEnable:		in			std_logic;
			aesKey:			in			std_logic_vector(511 downto 0);		
			expKey:			out		expKeyType;
			expKeyReady:	out		std_logic
	);
	end component;

	signal key:					keyType;
	signal expKey:				expKeyType;
	signal keyReady:			std_logic := '0';
	signal expKeyReady: 		std_logic := '0';
	signal encOutEnable:		std_logic := '0';
	signal decOutEnable:		std_logic := '0';
	signal enableEnc_cmd:	std_logic := '0';
	signal enableDec_cmd:	std_logic := '0';
		
	type STATE_TYPE is (RESET, STANDBY, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, STARTEXPANSI0N, EXPANDING, KEYAVAILABLE);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;
	
begin

			ready <= expKeyReady;

			----------------------------------------------
			-- 	HERE DESIGN OF KEY SERIAL READING (32 bit step)
			----------------------------------------------			
			
			  COMBIN: process(CURRENT_STATE, readKeyCmd, encOutEnable, expKeyReady, keyReady)
			  begin
					 case CURRENT_STATE is
					   when RESET =>								
								keyReady <= '0';
								NEXT_STATE <= STANDBY;
						
						-- WAITING FOR READ-KEY COMMAND
						when STANDBY =>							
								if (readKeyCmd='1') then
									NEXT_STATE <= S0;
								else
									NEXT_STATE <= STANDBY;
								End if;
								
			-- ===================================================================
			--		WE HAVE 15 DIFFERENT STATE TO READ THE ENTIRE 512bit KEY
			--		WHEN THE 512bit KEY IS COMPLETE, THE EXPANSION STARTS AUTOMATICALLY
							
						when S15 =>
							  key(31 downto 0) <= partialKey;
							  NEXT_STATE <= STARTEXPANSI0N;
				
						when S14 =>
							  key(63 downto 32) <= partialKey;
								NEXT_STATE <= S15;
				
						when S13 =>
								key(95 downto 64) <= partialKey;
								NEXT_STATE <= S14;
				
						when S12 =>
								key(127 downto 96) <= partialKey;
								NEXT_STATE <= S13;
				
						when S11 =>
								key(159 downto 128) <= partialKey;
								NEXT_STATE <= S12;
				
						when S10 =>
								key(191 downto 160) <= partialKey;
								NEXT_STATE <= S11; 
				
						when S9 =>
								key(223 downto 192) <= partialKey;
								NEXT_STATE <= S10; 
				
						when S8 =>
								key(255 downto 224) <= partialKey;
								NEXT_STATE <= S9; 
				
						when S7 =>
								key(287 downto 256) <= partialKey;
								NEXT_STATE <= S8; 
				
						when S6 =>
								key(319 downto 288) <= partialKey;
								NEXT_STATE <= S7; 
				
						when S5 =>
								key(351 downto 320) <= partialKey;
								NEXT_STATE <= S6; 
				
						when S4 =>
								key(383 downto 352) <= partialKey;
								NEXT_STATE <= S5; 
				
						when S3 =>
								key(415 downto 384) <= partialKey;
								NEXT_STATE <= S4; 
				
						when S2 =>
								key(447 downto 416) <= partialKey;
								NEXT_STATE <= S3; 
				
						when S1 =>
								key(479 downto 448) <= partialKey;
								NEXT_STATE <= S2; 
				
						when S0 =>
								key(511 downto 480) <= partialKey;
								NEXT_STATE <= S1; 
	
			------------------------- End reading key: step of 32bit 	-----------------------------------
			--			STARTING KEY EXPANSION
			
						when STARTEXPANSI0N =>
								keyReady <= '1';	
								NEXT_STATE <= EXPANDING;
								
						when EXPANDING =>
								if (expKeyReady = '1') then
									NEXT_STATE <= KEYAVAILABLE;
								else
									NEXT_STATE <= EXPANDING;
								End if;
						
						when KEYAVAILABLE =>
								NEXT_STATE <= KEYAVAILABLE;
								
					 end case;
				--end if;
			  end process;
			 
			  -- This process controls the "COMBIN" process 
			  SYNCH: process
			  begin
				if (clk'event and clk = '1') then 
					if (rst='1') then
						CURRENT_STATE <= RESET;
					else	  
						 CURRENT_STATE <= NEXT_STATE;
					End if;
				End if;
			  end process;
			  
			  
			  -- "encController" process controls the encryption core
			  encController: process(keyReady, enableEnc)
			  begin
					if (expKeyReady = '1') then
						if (enableEnc = '1') then
							enableEnc_cmd <= '1';
						else
							enableEnc_cmd <= '0';
						End if;
					else
						if (enableEnc = '1') then
							errorEnc <= '1';
						else
							errorEnc <= '0';
						End if;					
					End if;
			  end process;

			  -- "decController" process controls the decryption core
			  decController: process(keyReady, enableDec)
			  begin
					if (expKeyReady = '1') then
						if (enableDec = '1') then
							enableDec_cmd <= '1';
						else
							enableDec_cmd <= '0';
						End if;
					else
						if (enableDec = '1') then
							errorDec <= '1';
						else
							errorDec <= '0';
						End if;					
					End if;
			  end process;
			  			  
			  

			----------------------------------------------
			-- 	MAPPING KEY EXPANSION
			----------------------------------------------
			
			-- You can avoid keyExpander mapping if you provide the entire expanded key to encCore and decCore using 'expKey' array.
			-- If you don't want to use keyExpander sub-core remember to set 'expKeyReady' signal to 1.
			keyExpansion:  keyExpander PORT MAP (clk, rst, keyReady, key, expKey, expKeyReady);			
			--expKeyReady <= '1';
			
			----------------------------------------------
			-- 	MAPPING CYPHER AND DECYPHER
			----------------------------------------------
			
			-- Using cypher e decypher with pipeline (use this core on streaming elaboration to maximize performances) 
			
			-- WITH PIPELINE
			encCore:  encypherOPT2 PORT MAP (clk, rst, expKeyReady, expKey, enableEnc_cmd, encInput, encOutAvailable, encOutput);
			decCore:  decypherOPT2  PORT MAP (clk, rst, expKeyReady, expKey, enableDec_cmd, decInput, decOutAvailable, decOutput);

			
			-- Uncomment these lines to use cypher e decypher without pipeline (low area) 

			-- WITHOUT PIPELINE
			--encCore:  encypherOPT2_noPipe PORT MAP (clk, rst, expKeyReady, expKey, enableEnc_cmd, encInput, encOutAvailable, encOutput);
			--decCore: decypherOPT2_noPipe  PORT MAP (clk, rst, expKeyReady, expKey, enableDec_cmd, decInput, decOutAvailable, decOutput);
			
			
				
end Behavioral;

