library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity Divider_Circuit is
	Port(
			Clk : in std_logic;
			Dividend : in std_logic_vector(11 downto 0);
			Divisor  : in std_logic_vector(3 downto 0);
			Remainder: out std_logic_vector(11 downto 0);
			Quotient : out std_logic_vector(11 downto 0));
end Divider_Circuit;

Architecture Behavior of Divider_Circuit is
signal s_visor: std_logic_vector(3 downto 0);
signal s_vidend : std_logic_vector(11 downto 0);
signal s_remainder: std_logic_vector(11 downto 0);
signal s_clk      : std_logic;
signal count      : std_logic_vector(11 downto 0);
signal inc        : std_logic_vector(11 downto 0);
begin
s_visor<= Divisor;
s_vidend<= Dividend;
 s_clk <= Clk;
		divide: process(s_visor,s_vidend)
		begin
		
			If  s_clk'event and s_clk = '1' then
				if s_vidend < s_visor then
					count <= "000000000000";
					inc   <= "000000000001";
					s_remainder <= "000000000000";
				elsif s_vidend > s_visor then 
					if	(s_vidend > s_visor) then 
					s_remainder <= std_logic_vector(unsigned(s_vidend(11 downto 0)) - unsigned( s_visor(3 downto 0)));
					count <= std_logic_vector(unsigned(count) + unsigned(inc));
					end if;
					Quotient <= count;
					Remainder<=s_vidend; 
				end if;
			end if;
				
		end process;
end Behavior;