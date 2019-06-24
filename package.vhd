library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;

package uP is

component clk_gen is port (
clk : out std_logic); 
end component;

component rst_gen is port (
reset : out std_logic); 
end component;

component ram1024 is port( 
rst: in std_logic; 
cs: in std_logic; --chip select 
wr: in std_logic; --write enable 
rd: in std_logic;--read enable 
addr: in std_logic_vector(9 downto 0); 
data: inout std_logic_vector(15 downto 0)); 
end component;

component u311_1 is port( 
clk: in std_logic; 
reset: in std_logic;
opfetch: out std_logic; 
INT: in std_logic; 
INTA: out std_logic; 
WR: out std_logic; 
RD: out std_logic; 
A: out std_logic_vector(15 downto 0); 
D: inout std_logic_vector(15 downto 0)); 
end component;

component rom1024 is port( 
cs : in std_logic; 
oe : in std_logic;
addr : in std_logic_vector (9 downto 0); 
data : out std_logic_vector (15 downto 0));
end component;

component buf2 is port( 
enable: in std_logic; 
direction: in std_logic; 
input : inout std_logic_vector(15 downto 0);
output : inout std_logic_vector(15 downto 0));
end component;
 
component buf is port(
enable: in std_logic;
input : in std_logic_vector (15 downto 0);
output: out std_logic_vector(15 downto 0));
end component;

component FA is port(
    carryIn: in std_logic;
    carryOut: out std_logic;
    x,y : in std_logic;
    s : out std_logic);
end component;
    
component FA16 is port( 
  A : in std_logic_vector(15 downto 0); 
  B : in std_logic_vector(15 downto 0); 
  F : out std_logic_vector(15 downto 0); 
  cIn: in std_logic ; 
  Cout:out std_logic);
end component;

component LE is port(
 S: in std_logic_vector(2 downto 0);
 a, b: in std_logic;
 x: out std_logic);
end component;

component LE16 is port(
 S: in std_logic_vector(2 downto 0);
 A, B: in std_logic_vector(15 downto 0);
 x: out std_logic_vector(15 downto 0));
end component;

component AE is port(
 S: in std_logic_vector(2 downto 0);
 a, b: in std_logic;
 x: out std_logic);
end component;

component AE16 is port(
 S: in std_logic_vector(2 downto 0);
 A, B: in std_logic_vector(15 downto 0);
 Y: out std_logic_vector(15 downto 0));
end component;

component shifter16 is port( 
 S: in std_logic_vector(1 downto 0); 
 A: in std_logic_vector(15 downto 0); 
 Y: out std_logic_vector(15 downto 0);  
 zero: out std_logic); 
end component;

component reg16 is port( 
 d  : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
 ld : IN STD_LOGIC; -- load/enable
 clr: IN STD_LOGIC; -- async. clear. 
 clk: IN STD_LOGIC; -- clock. 
 q  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- output 
end component;

component addsub16 is port(
  sub: in std_logic; 
  in1,in2: in std_logic_vector(15 downto 0); 
  output: out std_logic_vector(15 downto 0)); 
end component;

component mux is port(
    S:                in std_logic_vector(1 downto 0);
    x0, x1, x2, x3:   in std_logic;
    y:                out std_logic
);
end component;

component mux4 is port(
  S:                in std_logic_vector(1 downto 0);
  x0, x1, x2, x3:   in std_logic_vector(15 downto 0);
  y:                out std_logic_vector(15 downto 0));
end component;

component mux2 is port(
  S:        in std_logic;
  x0, x1:   in std_logic_vector(15 downto 0);
  y:        out std_logic_vector(15 downto 0));
end component;

component regfile is port( 
  clk: in std_logic; 
  reset: in std_logic; 
  we: in std_logic; 
  WA: in std_logic_vector(2 downto 0); 
  D: in std_logic_vector(15 downto 0); 
  rbe: in std_logic; 
  rae: in std_logic; 
  RAA: in std_logic_vector(2 downto 0);
  RBA: in std_logic_vector(2 downto 0); 
  portA: out std_logic_vector(15 downto 0); 
  portB: out std_logic_vector(15 downto 0)); 
end component;

component alu is port (
     S:                   in std_logic_vector(4 downto 0);
     A, B:                in std_logic_vector(15 downto 0);
     F:                   out std_logic_vector(15 downto 0);
     Cout: out std_logic;
     zeroo:               out std_logic);
end component;

component datapath is port(
  clk: in std_logic; 
  reset : in std_logic; 
  pcen, den, dir, aen: in std_logic; 
  SPload, PCload, IRload: in std_logic; 
  Psel, Ssel, Rsel, Osel : in std_logic_vector(1 downto 0); 
  sub2: in std_logic; 
  jmpMux : in std_logic; 
  IR : out std_logic_vector (4 downto 0); 
  zero: out std_logic; 
  ALUsel : in std_logic_vector (4 downto 0); 
  we, rae, rbe : in std_logic;
  Buf2_out: out std_logic_vector(15 downto 0);
  Buf3_out: inout std_logic_vector(15 downto 0));  
end component;

component controller is port( 
clk: in std_logic;
reset : in std_logic; 
pcen, den, dir, aen: out std_logic; 
SPload, PCload, IRload: out std_logic; 
Psel, Ssel, Rsel, Osel : out std_logic_vector(1 downto 0); 
sub2: out std_logic; 
jmpMux : out std_logic; 
opfetch : out std_logic; 
IR : in std_logic_vector (4 downto 0); 
zero: in std_logic; 
ALUsel : out std_logic_vector (4 downto 0); 
we, rae, rbe : out std_logic; 
int: in std_logic; 
inta, wr, rd: out std_logic); 
end component;
end uP;