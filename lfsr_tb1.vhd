--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:15:29 01/09/2021
-- Design Name:   
-- Module Name:   D:/Others/projectCode1/lfsr_tb1.vhd
-- Project Name:  projectCode1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lfsr_implement
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
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_textio.all;
    use std.textio.all;

entity lfsr_tb1 is
end entity;
architecture test of lfsr_tb1 is

    signal clk    :std_logic := '0';
    signal rst    :std_logic := '1';
    signal outC   :std_logic_vector(15 downto 0);
	 signal lfsr1  :std_logic_vector(7 downto 0);
	 signal lfsr2  :std_logic_vector(7 downto 0);
	 signal pi     :std_logic_vector(31 downto 0);
	 
    component lfsr_implement is
    port (
        clk    :in  std_logic;
        rst    :in  std_logic;
        outC   :out std_logic_vector(15 downto 0);
		  lfsr1  :out std_logic_vector(7 downto 0);
		  lfsr2  :out std_logic_vector(7 downto 0);
		  pi     :out std_logic_vector(31 downto 0)
    );
    end component;
begin

    -- Generate clock
    clk <= not clk after 0.1 ns;
    rst <= '0' after 0 ns;

    Inst_lfsr : lfsr_implement
    port map (
        clk    => clk,   
        rst    => rst,
        outC => outC,
		  lfsr1 => lfsr1,
		  lfsr2 => lfsr2,
		  pi => pi
    );

    -- Display the time and result
    process (clk)
        variable wrbuf :line;
    begin
        if (clk = '1') then
            write(wrbuf, string'("Time: ")); write(wrbuf, now);
            write(wrbuf, string'("; lfsr_1: ")); write(wrbuf, conv_integer(lfsr1)); --print are of random numbers and the counter
				write(wrbuf, string'("; lfsr_2: ")); write(wrbuf, conv_integer(lfsr2));
				write(wrbuf, string'("; counter: ")); write(wrbuf, conv_integer(outC));
            writeline(output, wrbuf);
        end if;
    end process;

end architecture;