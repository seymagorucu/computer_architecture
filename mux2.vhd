
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mux2 is port(
    S:        in std_logic;
    x0, x1:   in std_logic_vector(15 downto 0);
    y:        out std_logic_vector(15 downto 0));
end mux2;


architecture imp of mux2 is
begin
      process(S, x0, x1)
      begin
        
        case S is
             when '0'       => y <= x0;
             when '1'      => y <= x1;
             when others     => y <= "XXXXXXXXXXXXXXXX";
        end case;
                             
      end process;
end imp;

