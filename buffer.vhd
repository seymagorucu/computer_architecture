library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity buf is port(
enable: in std_logic;
input : in std_logic_vector (15 downto 0);
output: out std_logic_vector(15 downto 0));

end buf;

architecture imp of buf is
    begin 
        process(enable,input)
begin
   if(enable ='1') then
		output<= input;
   else
       output<= (others => 'Z');
   end if;

end process;
end imp;

