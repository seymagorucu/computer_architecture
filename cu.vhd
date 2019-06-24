 -- controller.vhd: control unit 
library ieee; 
library work; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_textio.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_bit.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_signed.all; 
use IEEE.std_logic_unsigned.all; 
use IEEE.math_real.all; 
use IEEE.math_complex.all; 
use work.uP.all;

entity controller is port( 
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
end controller;

architecture imp of controller is
type state_type is ( 
	s_start, 
	s_fetch, 
	s_decode,
        s_decode2,
	s_mov, 
	s_add, 
	s_sub, 
	s_and, 
	s_or, 
	s_not, 
	s_inc, 
	s_dec, 
	s_sr, 
	s_sl, 
	s_rr, 
	s_jmp,
	s_jz, 
	s_jnz, 
	s_call, 
	--s_call2,
        s_ret, 
       -- s_ret2,
	s_nop, 
	s_halt, 
	s_push,
        s_push2, 
	s_pop,
        --s_pop2, 
	s_write, 
	s_read, 
	s_movi, 
	s_mov_sp_r,
        s_mov_r_sp,
        s_r_cycle1,
        s_r_cycle2,
        s_r_cycle3,
        s_w_cycle1,
        s_w_cycle2,
        s_w_cycle3,
        s_int_cycle1,
        s_int_cycle2,
        s_int_cycle3);

signal state: state_type :=s_start;
begin 
NEXT_STATE_LOGIC: process(clk, reset)
  variable int_occur: boolean := false; 
  begin  
     if(reset ='1') then 
        state <= s_start; 
     elsif(int = '1') then
           int_occur := true;
     elsif(clk'event and clk='1') then

        case state is
           when s_start => state <= s_fetch; 
           when s_fetch => state <= s_decode;
           when s_decode => state <= s_decode2;
           when s_decode2 => 
            
                case IR is
                   when "00000" => state <= s_mov;  
                   when "00001" => state <= s_add; 
                   when "00010" => state <= s_sub; 
                   when "00011" => state <= s_and; 
                   when "00100" => state <= s_or; 
                   when "00101" => state <= s_not; 
                   when "00110" => state <= s_inc; 
                   when "00111" => state <= s_dec; 
                   when "01000" => state <= s_sr; 
                   when "01001" => state <= s_sl; 
                   when "01010" => state <= s_rr; 
                   when "01011" => state <= s_jmp;
                   when "01100" => if(zero = '1') then state <= s_jmp;
                                   elsif(zero = '0') then state <= s_nop;
                                   end if;
                   when "01101" => if(zero = '0') then state <= s_jmp;
                                   elsif(zero = '1') then state <= s_nop;
                                   end if;
                   when "01110" => state <= s_call;
                   when "01111" => state <= s_ret;
                   when "10000" => state <= s_nop;
                   when "10001" => state <= s_halt;
                   when "10010" => state <= s_push;
                   when "10011" => state <= s_pop;
                   when "10100" => state <= s_write;
                   when "10101" => state <= s_read;
                   when "10110" => state <= s_movi;
                   when "10111" => state <= s_mov_sp_r; 
                   when "11000" => state <= s_mov_r_sp;
                   when others => state <= s_start;
               end case;

           when s_halt => state <= s_halt;
           when s_write => state <= s_w_cycle1;
           when s_read => state <= s_r_cycle1;
           when s_w_cycle1 => state <= s_w_cycle2;
           when s_r_cycle1 => state <= s_r_cycle2;
           when s_w_cycle2 => state <= s_w_cycle3;
           when s_r_cycle2 => state <= s_r_cycle3;
           when s_int_cycle1 => state <= s_int_cycle2;
           when s_int_cycle2 => state <= s_int_cycle3;

           when others =>
                           if(int_occur = true) then
                                state <= s_int_cycle1;
                                inta <= '1';
                                int_occur := false;

                           elsif(int_occur = false) then
                                state <= s_fetch;
                           end if;
        
       end case;
elsif(clk'event and clk='0') then
case state is

when s_push => state <= s_push2;
--when s_pop => state <= s_pop2;
--when s_call => state <= s_call2;
--when s_ret => state <= s_ret2;
when others =>  
end case;
 end if;
end process;
                  
OUTPUT_LOGIC: process(state) 
begin 
case state is 
   
  when s_start => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= 'Z'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "XX"; 
       Ssel <= "XX"; 
       Osel <= "XX"; 
       ALUsel <= "XXXXX"; 
       Rsel <= "XX"; 
       sub2 <= 'X'; 
       jmpMux <= 'X';
       we <= '0';  
       rbe <= '0'; 
       rae <= '0';

    when s_fetch => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '1'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '1';
       IRload <= '1';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "XXXXX"; 
       Rsel <= "XX"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';
when s_decode =>
 inta <= 'Z';
 WR <= 'Z';
 RD <= 'Z';
 opfetch <= '0';
 pcen <= '0';
 den <= '0';
 dir <= '0';
 aen <= '0';
 SPload <= '0';
 PCload <= '0';
 IRload <= '0';
 Psel <= "XX";
 Ssel <= "XX";
 Osel <= "XX";
 ALUsel <= "XXXXX";
 Rsel <= "XX";
 sub2 <= '0';
 jmpMux <= '0';
 we <= '0';
 rbe <= '0';
 rae <= '0';

 when s_decode2 =>
 inta <= 'Z';
 WR <= 'Z';
 RD <= 'Z';
 opfetch <= '0';
 pcen <= '0';
 den <= '0';
 dir <= '0';
 aen <= '0';
  case IR is
 when  "10011" => SPload <='1';
                    sub2<='1';
when others => SPload <='0';
               sub2<='X';
end case;
-- SPload <= '0';
 PCload <= '0';
 IRload <= '0';
 Psel <= "XX";
 Ssel <= "11";
 Osel <= "XX";
 ALUsel <= "XXXXX";
 Rsel <= "XX";
-- sub2 <= '0';
 jmpMux <= '0';
 we <= '0';
 rbe <= '0';
 rae <= '0';

   when s_mov => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00";
       Osel <= "00";  
       ALUsel <= "00000"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= 'X';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_add => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00100"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '1'; 
       rae <= '1'; 

  when s_sub => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00101"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '1'; 
       rae <= '1';

   when s_and => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00001"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '1'; 
       rae <= '1';

   when s_or => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00010"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '1'; 
       rae <= '1';

   when s_not => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00011"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_inc => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00110"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_dec => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00111"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_sr => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "10000"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_sl => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "01000"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_rr => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "11000"; 
       Rsel <= "00"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_jmp => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '1';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "XX"; 
       Osel <= "XX"; 
       ALUsel <= "00000"; 
       Rsel <= "XX"; 
       sub2 <= 'X'; 
       jmpMux <= '1';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

   when s_jz => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '1';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00000"; 
       Rsel <= "XX"; 
       sub2 <= 'X'; 
       jmpMux <= '1';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

   when s_jnz => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00000"; 
       Rsel <= "XX"; 
       sub2 <= 'X'; 
       jmpMux <= '1';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

   when s_call => 
       inta <= 'Z'; 
       WR <= '1'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '1';
       den <= '1'; 
       dir <= '1'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '1';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "01"; 
       ALUsel <= "00000"; 
       Rsel <= "XX"; 
       sub2 <= '0'; 
       jmpMux <= '1';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

--when s_call2 =>
 --inta <= 'Z'; 
-- WR <= '0'; 
-- RD <= '0';
-- opfetch <= '0'; 
-- pcen <= '0'; 
-- den <= '0'; 
--- dir <= 'X'; 
-- aen <= '0'; 
-- SPload <= '0';
-- PCload <= '1'; 
-- IRload <= '0'; 
-- Psel <= "11"; 
-- Osel <= "00"; 
-- Ssel <= "11";
-- ALUsel <= "00000"; 
-- Rsel <= "00"; 
--- sub2 <= '0'; 
-- jmpMux <= '1'; 
-- we <= '0'; 
-- rbe <= '0'; 
-- rae <= '0';

   when s_ret => 
       inta <= 'Z'; 
       WR <= '0'; 
       RD <= '1';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '1'; 
       PCload <= '1';
       IRload <= '0';
       Psel <= "10"; 
       Ssel <= "11"; 
       Osel <= "01"; 
       ALUsel <= "XXXXX"; 
       Rsel <= "XX"; 
       sub2 <= '0'; 
       jmpMux <= '0';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

--when s_ret2 => 
       --inta <= 'Z'; 
       --WR <= '0'; 
       --RD <= '0';
       --opfetch <= '0'; 
       ---pcen <= '0';
       --den <= '0'; 
       --dir <= '0'; 
       --aen <= '0'; 
       --SPload <= '1'; 
       --PCload <= '1';
       --IRload <= '0';
       ---Psel <= "10"; 
       --Ssel <= "11"; 
       --Osel <= "01"; 
       ---ALUsel <= "XXXXX"; 
       --Rsel <= "XX"; 
       --sub2 <= '0'; 
       --jmpMux <= '0';
       --we <= '0'; 
       --rbe <= '0'; 
       --rae <= '0';

   when s_nop => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00000"; 
       Rsel <= "XX"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

   when s_halt => 
       inta <= 'X'; 
       WR <= 'X'; 
       RD <= 'X';
       opfetch <= 'X'; 
       pcen <= 'X';
       den <= 'X'; 
       dir <= 'X'; 
       aen <= 'X'; 
       SPload <= 'X'; 
       PCload <= 'X';
       IRload <= 'X';
       Psel <= "XX"; 
       Ssel <= "XX"; 
       Osel <= "XX"; 
       ALUsel <= "XXXXX"; 
       Rsel <= "XX"; 
       sub2 <= 'X'; 
       jmpMux <= 'X';
       we <= 'X'; 
       rbe <= 'X'; 
       rae <= 'X';

   when s_push => 
       inta <= 'Z'; 
       WR <= '1'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "11"; 
       Osel <= "01"; 
       ALUsel <= "00000"; 
       Rsel <= "00"; -- IR 
       sub2 <= '0'; 
       jmpMux <= '0';
       we <= '0'; 
       rbe <= '1'; 
       rae <= '0';
 when s_push2 => 
       inta <= 'Z'; 
       WR <= '0'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= 'X'; 
       aen <= '0'; 
       SPload <= '1'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "11"; 
       Osel <= "00"; 
       ALUsel <= "00000"; 
       Rsel <= "00"; -- IR 
       sub2 <= '0'; 
       jmpMux <= '0';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';
 --when s_pop => 
       --inta <= 'Z'; 
       --WR <= '0'; 
       --RD <= '1';
       --opfetch <= '0'; 
       --pcen <= '0';
       --den <= '0'; 
       --dir <= '0'; 
       --aen <= '0'; 
       --SPload <= '0'; 
       --PCload <= '0';
       --IRload <= '0';
       --Psel <= "11"; 
       --Ssel <= "11"; 
       --Osel <= "01"; 
       --ALUsel <= "00000"; 
       --Rsel <= "XX"; 
       --sub2 <= '0'; 
       --jmpMux <= '0';
       --we <= '0'; 
       --rbe <= '0'; 
       --rae <= '0';
   when s_pop => 
       inta <= 'Z'; 
       WR <= '0'; 
       RD <= '1';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "11"; 
       Osel <= "01"; 
       ALUsel <= "00000"; 
       Rsel <= "11"; 
       sub2 <= '0'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '0';

   when s_write => 
       inta <= 'Z'; 
       WR <= '1'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= 'Z'; 
       jmpMux <= 'Z';
       we <= '0'; 
       rbe <= '1'; 
       rae <= '1';

   when s_read => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= '1';
       opfetch <= 'Z'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "00000"; 
       Rsel <= "11"; 
       sub2 <= 'X'; 
       jmpMux <= 'X';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';

   when s_movi => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "00"; 
       ALUsel <= "00000"; 
       Rsel <= "10"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '0';


   when s_mov_sp_r => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '1'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "10"; 
       Osel <= "ZZ"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '1';
   when s_mov_r_sp => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= 'Z';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '0'; 
       dir <= '0'; 
       aen <= '0'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "ZZ"; 
       Osel <= "ZZ"; 
       ALUsel <= "00000"; 
       Rsel <= "01"; 
       sub2 <= 'X'; 
       jmpMux <= '0';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '0';

    when s_r_cycle1 => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= '1';
       opfetch <= 'Z'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "00000"; 
       Rsel <= "11"; 
       sub2 <= 'X'; 
       jmpMux <= 'X';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';
    when s_r_cycle2 => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= '1';
       opfetch <= 'Z'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "00000"; 
       Rsel <= "11"; 
       sub2 <= 'X'; 
       jmpMux <= 'X';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';
   when s_r_cycle3 => 
       inta <= 'Z'; 
       WR <= 'Z'; 
       RD <= '1';
       opfetch <= 'Z'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "00000"; 
       Rsel <= "11"; 
       sub2 <= 'X'; 
       jmpMux <= 'X';
       we <= '1'; 
       rbe <= '0'; 
       rae <= '1';
    when s_w_cycle1 => 
       inta <= 'Z'; 
       WR <= '1'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= 'Z'; 
       jmpMux <= 'Z';
       we <= '0'; 
       rbe <= '1'; 
       rae <= '1';

   when s_w_cycle2 => 
       inta <= 'Z'; 
       WR <= '1'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= 'Z'; 
       jmpMux <= 'Z';
       we <= '0'; 
       rbe <= '1'; 
       rae <= '1';
    when s_w_cycle3 => 
       inta <= 'Z'; 
       WR <= '1'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '0';
       den <= '1'; 
       dir <= '1'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '0';
       IRload <= '0';
       Psel <= "11"; 
       Ssel <= "00"; 
       Osel <= "11"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= 'Z'; 
       jmpMux <= 'Z';
       we <= '0'; 
       rbe <= '1'; 
       rae <= '1';

    when s_int_cycle1 => 
       inta <= '1'; 
       WR <= '0'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '1';
       den <= '0'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '1';
       IRload <= '0';
       Psel <= "00"; 
       Ssel <= "11"; 
       Osel <= "01"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= '1'; 
       jmpMux <= 'Z';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';
  when s_int_cycle2 => 
       inta <= '1'; 
       WR <= '0'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '1';
       den <= '0'; 
       dir <= '0'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '1';
       IRload <= '0';
       Psel <= "00"; 
       Ssel <= "11"; 
       Osel <= "01"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= '1'; 
       jmpMux <= 'Z';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

    when s_int_cycle3 => 
       inta <= '1'; 
       WR <= '0'; 
       RD <= '0';
       opfetch <= '0'; 
       pcen <= '1';
       den <= '0'; 
       dir <= 'X'; 
       aen <= '1'; 
       SPload <= '0'; 
       PCload <= '1';
       IRload <= '0';
       Psel <= "00"; 
       Ssel <= "11"; 
       Osel <= "01"; 
       ALUsel <= "ZZZZZ"; 
       Rsel <= "ZZ"; 
       sub2 <= '0'; 
       jmpMux <= '1';
       we <= '0'; 
       rbe <= '0'; 
       rae <= '0';

--when s_pop2 =>
 --inta <= 'Z'; 
 --WR <= '0'; 
 --RD <= '0';
 --opfetch <= '0'; 
 --pcen <= '0'; 
 --den <= '0'; 
 --dir <= 'X'; 
 --aen <= '0'; 
 --SPload <= '0';
 --PCload <= '0'; 
 --IRload <= '0'; 
 --Psel <= "11"; 
 --Osel <= "00"; 
 --Ssel <= "11";
 --ALUsel <= "00000"; 
 --Rsel <= "00"; 
 --sub2 <= '0'; 
 --jmpMux <= '0'; 
 --we <= '0'; 
 --rbe <= '0'; 
 --rae <= '0';

--when s_push2 =>
 --inta <= 'Z'; 
 --WR <= '0'; 
 --RD <= '0';
 --opfetch <= '0'; 
 --pcen <= '0'; 
 --den <= '0'; 
 --dir <= 'X'; 
 --aen <= '0'; 
 ---SPload <= '0';
 --PCload <= '0'; 
 --IRload <= '0'; 
 --Psel <= "11"; 
 --Osel <= "00"; 
 --Ssel <= "11";
 ---ALUsel <= "00000"; 
 ---Rsel <= "00"; 
 --sub2 <= '0'; 
 --jmpMux <= '0'; 
 --we <= '0'; 
 --rbe <= '0'; 
 --rae <= '0';



    when others => inta <= 'X';
  end case;
 end process;
end imp;