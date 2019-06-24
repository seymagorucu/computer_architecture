library ieee;
library work;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;
use work.uP.all;

entity testbench is -- no ports! 
end testbench;
architecture imp of testbench is
signal clk: std_logic; 
signal reset: std_logic; 
signal opfetch: std_logic;
signal addressbus, databus: std_logic_vector(15 downto 0);
signal wr,rd: std_logic;


begin 
 -- this is the minimum configuration
clock_gen: clk_gen port map(clk); 
reset_gen: rst_gen port map(reset);
processor: u311_1 port map(clk, reset, opfetch, '0', open, wr, rd, addressbus, databus);
prog_memory: rom1024 port map('0',opfetch,addressbus(9 downto 0),databus);
prog_RAM : ram1024 port map(reset,'0',wr,rd,addressbus(9 downto 0),databus);
end imp;
