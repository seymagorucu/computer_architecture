library ieee;
library work; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; 
use work.uP.all; 
use work.opcodes.all;

entity rom1024 is port( 
cs : in std_logic; 
oe : in std_logic;
addr : in std_logic_vector (9 downto 0); 
data : out std_logic_vector (15 downto 0));
end rom1024;

architecture imp of rom1024 is 
subtype cell is std_logic_vector(15 downto 0);
type rom_type is array(0 to 3) of cell;

-- Our program stored in the memory 
constant ROM : rom_type :=( 

movi&A&"00000001",
movi&C&"00000111",
push&"000000"&A&"00",
push&"000000"&C&"00",
--push&"000000"&C&"00",
--call&"00000000010",
--movi&F&"00000011",
pop&D&"00000000",
pop&E&"00000000",
--wrt&"000"&B&A&"00",
--movi&B&"00000011",
--inc&B&B&"00000", 
--ret&"00000000000",
--dec&C&C&"00000", 
--add&A&A&A&"00",
nop&"00000000000"
--ret&"00000000000"
--mov&C&D&"00000", 
--inc&B&B&"00000", 
--jmp&"10000000111",
--inc&B&B&"00000", 
--ret&"00000000000"
); 
begin 
process(cs,oe, addr) 
begin 
if (cs='0' and oe='1') then 
 data <= ROM(conv_integer(addr)); 
else data <= (others=>'Z');
end if; 
end process; 
end imp;

