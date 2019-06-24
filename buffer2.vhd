library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity buf2 is port( 
enable: in std_logic; 
direction: in std_logic; 
input : inout std_logic_vector(15 downto 0);
output : inout std_logic_vector(15 downto 0));
--down_in : in std_logic_vector (15 downto 0); --RB
--data_out: in std_logic_vector(15 downto 0); --Buf3_out
--data_in: out std_logic_vector(15 downto 0);--Buf3_out
--down_out: out std_logic_vector (15 downto 0)); --RB
end buf2;

architecture imp of buf2 is
begin 
--Bproc:process(enable,direction,down_in,data_out) 
Bproc:process(enable,direction,input,output)
begin 
 if(enable= '1' and direction='1') then 
      --data_in <= down_in
        output <= input;
elsif(enable= '1' and direction='0') then 
     --  down_out <= data_out;
          input <= output;
 else  
    --  data_in <=(others=>'Z');
--      down_out <=(others=>'Z');
   input <=(others =>'Z'); output <= (others => 'Z');
  end if; 
end process; 
 end imp;





