library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
	use work.uP.all;

entity alu is port (
     S:                   in std_logic_vector(4 downto 0);
     A, B:                in std_logic_vector(15 downto 0);
     F:                   out std_logic_vector(15 downto 0);
     Cout: out std_logic;
     zeroo:               out std_logic
);
end alu;


architecture imp of alu is

signal X, Y, ShiftInput:   std_logic_vector(15 downto 0);
signal c0:                 std_logic;

begin      
    CarryExtender_ALU:          c0 <= (S(0) xor S(1)) and S(2);
    LogicExtender16_ALU:        LE16 port map(S(2 downto 0), A, B, X);
    ArithmeticExtender16_ALU:   AE16 port map(S(2 downto 0), A, B, Y);
    FA16_ALU:                   FA16 port map(X, Y, ShiftInput, c0, Cout);
    Shifter16_ALU:              shifter16 port map(S(4 downto 3), ShiftInput, F, zeroo);
end imp;







