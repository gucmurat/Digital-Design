-------------------------------------------------------
-- Design Name : Pi Approximation by random 8-bit LFSR
-- File Name   : lfsr_implement.vhd
-- Coder       : Murat Güç
-------------------------------------------------------
library ieee;
   use IEEE.NUMERIC_STD.ALL;
	use IEEE.STD_LOGIC_1164.ALL;

use ieee.math_real.uniform;
use ieee.math_real.floor;
use ieee.std_logic_unsigned.all;
use work.lfsr_pkg.all;                 --import LFSR package

entity lfsr_implement is
    port (
        clk    :in  std_logic;
        rst    :in  std_logic;
        outC   :out std_logic_vector(15 downto 0);  --out vector for counter
        lfsr1  :out std_logic_vector(7 downto 0);   --first random 8-bit vector for output to see in sim
		  lfsr2  :out std_logic_vector(7 downto 0);   --second random 8-bit vector for output to see in sim
		  pi     :out std_logic_vector(31 downto 0)   --last output-main purpose
    );
end entity;

architecture rtl of lfsr_implement is
    constant taps   :std_logic_vector (7 downto 0) := "10001110";
    signal   lfsr_a :std_logic_vector (7 downto 0);
    signal   lfsr_b :std_logic_vector (7 downto 0);
	 signal outC_reg : unsigned (15 downto 0);                       --intermediate vector - carrier
	 signal   pi_reg : unsigned (31 downto 0);                       --intermediate vector - carrier
	 signal    cons1 : unsigned (15 downto 0) := "0000000000000100"; --4 in 10's system to calculate ratio of areas which are square and quarter circle
	 signal    cons2 : unsigned (15 downto 0) := "0000000000000101"; --5 in 10's system to calculate pi within 5000 trial/dart 
begin
		
    process (clk, rst) 
		variable counter : INTEGER range 0 to 10000000;
		variable flag : STD_LOGIC := '0';
		variable A : unsigned (15 downto 0);                        --variables needed for calculation
		variable B : unsigned (15 downto 0);
		variable X : integer:=0;
		variable Y : integer:=0;
		variable D   : unsigned(15 DOWNTO 0) := "1111111000000001"; --the max boundary point 255*255 acc. to max random 8-bit multiplication
	 begin
        
		  if (rst = '1') then
           lfsr_a <=  (others=>'0');
           lfsr_b <=  (others=>'0');
			  counter:=0;
        elsif (rising_edge(clk)) then
				if(flag = '0') then
					if(counter<10000) then
						lfsr_a <= many_to_one_fb (lfsr_a, taps);  --generating number from LFSR package by functions
						lfsr_b <= one_to_many_fb (lfsr_b, taps);  
						X := to_integer(unsigned(lfsr_a));
						A := (to_unsigned(integer(X),16));
						Y := to_integer(unsigned(lfsr_b));
						B := (to_unsigned(integer(Y),16));
						if ((A*A)+(B*B) <= (D)) then               --checking whether (x,y) point is in circle or not
							counter := counter + 1;                 --then increment the counter	
						elsif(counter=10000) then          
							flag:='1';                              --flag is for stopping and starting the clk loop
					
						end if;
					end if;
				end if;
        end if;
	 outC_reg<= (to_unsigned(integer(counter),16));           --counter gets out from process
    end process;
	 
	 outC <= std_logic_vector(outC_reg);
	 lfsr1<= lfsr_a;                                          --assiging intermediate signal to output
	 lfsr2<= lfsr_b;
	 pi_reg <= outC_reg * cons1 / cons2;                      --calculation by unsigned vectors (3626*4/5=3060)"pi*1000
	 pi <= std_logic_vector(pi_reg);
	 
end architecture;