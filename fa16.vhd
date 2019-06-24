library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
 library work;
        use work.uP.all;
 entity FA16 is port( 
  A : in std_logic_vector(15 downto 0); 
  B : in std_logic_vector(15 downto 0); 
  F : out std_logic_vector(15 downto 0); 
  cIn: in std_logic ; 
  Cout:out std_logic);
end FA16;
architecture imp of FA16 is 
 signal C: std_logic_vector(15 downto 1); 
 begin 
  U0: FA port map(cIn, C(1), A(0), B(0), F(0)); 
  U1_14: for I in 1 to 14 generate 
  begin 
   U: FA port map(C(I), C(I+1), A(I), B(I), F(I)); 
 end generate U1_14; 
 U15: FA port map(C(15),Cout,A(15),B(15),F(15)); 
  
 end imp;