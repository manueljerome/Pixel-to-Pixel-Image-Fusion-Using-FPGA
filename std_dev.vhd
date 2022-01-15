library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 USE IEEE.STD_LOGIC_ARITH.ALL;
 

entity std_dev is
port( clk   : in  std_logic;
		pix11 : in  std_logic_vector(11 downto 0);
		pix12 : in  std_logic_vector(11 downto 0);
		pix13 : in  std_logic_vector(11 downto 0);
		pix21 : in  std_logic_vector(11 downto 0);
		pix22 : in  std_logic_vector(11 downto 0);
		pix23 : in  std_logic_vector(11 downto 0);
		pix31 : in  std_logic_vector(11 downto 0);
		pix32 : in  std_logic_vector(11 downto 0);
		pix33 : in  std_logic_vector(11 downto 0);
		pic11 : in  std_logic_vector(11 downto 0);
		pic12 : in  std_logic_vector(11 downto 0);
		pic13 : in  std_logic_vector(11 downto 0);
		pic21 : in  std_logic_vector(11 downto 0);
		pic22 : in  std_logic_vector(11 downto 0);
		pic23 : in  std_logic_vector(11 downto 0);
		pic31 : in  std_logic_vector(11 downto 0);
		pic32 : in  std_logic_vector(11 downto 0);
		pic33 : in  std_logic_vector(11 downto 0);
		
		dev1  : out std_logic_vector(11 downto 0);
		dev2  : out std_logic_vector(11 downto 0);
		dev3  : out std_logic_vector(11 downto 0);
		dev4  : out std_logic_vector(11 downto 0);
		dev5  : out std_logic_vector(11 downto 0);
		dev6  : out std_logic_vector(11 downto 0);
		dev7  : out std_logic_vector(11 downto 0);
		dev8  : out std_logic_vector(11 downto 0);
		dev9  : out std_logic_vector(11 downto 0)
);
end std_dev;

architecture behavior of std_dev is
component Divider_Circuit is

Port(
			Clk : in std_logic;
			Dividend : in std_logic_vector(11 downto 0);
			Divisor  : in std_logic_vector(3 downto 0);
			Remainder: out std_logic_vector(11 downto 0);
			Quotient : out std_logic_vector(11 downto 0));
END component Divider_Circuit;

signal sum  : std_logic_vector(11 downto 0);
signal sum2 : std_logic_vector(11 downto 0);
signal mean1: std_logic_vector(11 downto 0);
signal mean2: std_logic_vector(11 downto 0);
signal divisor: std_logic_vector(3 downto 0);
signal rem1   : std_logic_vector(11 downto 0);
signal rem2   : std_logic_vector(11 downto 0);
signal stddev : std_logic_vector(11 downto 0);
signal stddev2 : std_logic_vector(11 downto 0);
signal dev_out : std_logic_vector(11 downto 0);
begin
--	std_logic_vector(to_signed(to_integer(signed(X) / signed(Y)),32));
   divisor <= "1001";

	sum<= (pix11 + pix12 + pix13 + pix21 + pix22 + pix23 + pix31 + pix32 + pix33);
	sum2<= (pic11 + pic12 + pic13 + pic21 + pic22 + pic23 + pic31 + pic32 + pic33);
	
			
	div1: Divider_Circuit port map (Clk => clk,
											 Dividend=> sum,
											 Divisor=> divisor,
											 Remainder=> rem1,
											 Quotient => mean1);
											 
	div2: Divider_Circuit port map (Clk => clk,
											 Dividend=> sum2,
											 Divisor=> divisor,
											 Remainder=>rem2,
											 Quotient =>mean2);
											 
											 
	
	stddev <= (pix11-mean1)+(pix12-mean1)+ (pix13-mean1) + (pix21-mean1) + (pix22-mean1) + (pix23-mean1) + (pix31-mean1) + (pix32-mean1)+ (pix33-mean1);
	stddev2 <= (pic11-mean2)+(pic12-mean2)+ (pic13-mean2) + (pic21-mean2) + (pic22-mean2) + (pic23-mean2) + (pic31-mean2) + (pic32-mean2)+ (pic33-mean2);
	process(stddev2,stddev)
	begin 
	if  stddev2 > stddev then
			dev1 <= pic11;
			dev2 <= pic12;
			dev3 <= pic13;
			dev4 <= pic21;
			dev5 <= pic22;
			dev6 <= pic23;
			dev7 <= pic31;
			dev8 <= pic32;
			dev9 <= pic33;
		else
		   dev1 <= pix11;
			dev2 <= pix12;
			dev3 <= pix13;
			dev4 <= pix21;
			dev5 <= pix22;
			dev6 <= pix23;
			dev7 <= pix31;
			dev8 <= pix32;
			dev9 <= pix33;
			end if;
			end process;
end behavior;