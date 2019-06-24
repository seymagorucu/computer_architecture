library ieee;
 use ieee.std_logic_1164.all;
 use ieee.std_logic_unsigned.all; 
 use ieee.numeric_std.all;

ENTITY reg16 IS PORT( 
   d : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
   ld : IN STD_LOGIC; -- load/enable
   clr : IN STD_LOGIC; -- async. clear. 
   clk : IN STD_LOGIC; -- clock. 
    q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- output 
END reg16;

 ARCHITECTURE description OF reg16 IS
 BEGIN 
 process(clk, clr) 
 begin 
 if clr = '1' then 
    q <= x"0000"; 
 elsif rising_edge(clk) then 
 if ld = '1' then
 q <= d;
 end if; 
end if; 
end process; 
END description;

