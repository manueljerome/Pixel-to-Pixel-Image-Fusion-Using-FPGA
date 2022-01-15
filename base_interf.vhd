library ieee;
use ieee.std_logic_1164.all;

entity base_interf is
port(clk : in std_logic;
	w11 : out std_logic_vector(11 downto 0); 
	w12 : out std_logic_vector(11 downto 0);
	w13 : out std_logic_vector(11 downto 0);
	w21 : out std_logic_vector(11 downto 0);
	w22 : out std_logic_vector(11 downto 0);
	w23 : out std_logic_vector(11 downto 0);
	w31 : out std_logic_vector(11 downto 0);
	w32 : out std_logic_vector(11 downto 0);
	w33 : out std_logic_vector(11 downto 0);
	data_address : out std_logic_vector(15 downto 0));
end base_interf;

architecture behavior of base_interf is
signal data_address1: std_logic_vector(15 downto 0);
signal q_outt : std_logic_vector(11 downto 0);
signal s_Clk: std_logic;
signal data_address2: std_logic_vector(15 downto 0);
signal q_outt2: std_logic_vector(11 downto 0);
signal s_aclr: std_logic;
signal p11_3x3: std_logic_vector(11 downto 0);
signal p12_3x3: std_logic_vector(11 downto 0);
signal p13_3x3: std_logic_vector(11 downto 0);
signal p21_3x3: std_logic_vector(11 downto 0);
signal p22_3x3: std_logic_vector(11 downto 0);
signal p23_3x3: std_logic_vector(11 downto 0);
signal p31_3x3: std_logic_vector(11 downto 0);
signal p32_3x3: std_logic_vector(11 downto 0);
signal p33_3x3: std_logic_vector(11 downto 0);
signal q11_3x3: std_logic_vector(11 downto 0); 
signal q12_3x3: std_logic_vector(11 downto 0); 
signal q13_3x3: std_logic_vector(11 downto 0); 
signal q21_3x3: std_logic_vector(11 downto 0); 
signal q22_3x3: std_logic_vector(11 downto 0);
signal q23_3x3: std_logic_vector(11 downto 0); 
signal q31_3x3: std_logic_vector(11 downto 0);
signal q32_3x3: std_logic_vector(11 downto 0); 
signal q33_3x3: std_logic_vector(11 downto 0);  

signal pfused11: std_logic_vector(11 downto 0); 
signal pfused12: std_logic_vector(11 downto 0); 
signal pfused13: std_logic_vector(11 downto 0); 
signal pfused21: std_logic_vector(11 downto 0); 
signal pfused22: std_logic_vector(11 downto 0);
signal pfused23: std_logic_vector(11 downto 0); 
signal pfused31: std_logic_vector(11 downto 0);
signal pfused32: std_logic_vector(11 downto 0); 
signal pfused33: std_logic_vector(11 downto 0);   
begin
data_address<= data_address1;

	imtofifo: work.image1 port map(
											 address => data_address1,
											 q      => q_outt,
											 clock   => s_Clk );
	imtofifo1: work.image2 port map(
												 aclr    => s_aclr,
												 address => data_address2,
												 q      => q_outt2,
												 clock   => clk );
	
	
	dev: work.std_dev port map(      clk =>s_clk,
											   pix11 => q11_3x3,
												pix12 => q12_3x3,
											   pix13 => q13_3x3,
												pix21 => q21_3x3,
												pix22 => q22_3x3,
												pix23 => q23_3x3,
												pix31 => q31_3x3,
												pix32 => q32_3x3,
												pix33 => q33_3x3,
												pic11 => p11_3x3,
												pic12 => p12_3x3,
											   pic13 => p13_3x3,
												pic21 => p21_3x3,
												pic22 => p22_3x3,
												pic23 => p23_3x3,
												pic31 => p31_3x3,
												pic32 => p32_3x3,
												pic33 => p33_3x3,
												dev1  => pfused11,
												dev2  => pfused12,
												dev3  => pfused13,
												dev4  => pfused21,
												dev5  => pfused22,
												dev6  => pfused23,
												dev7  => pfused31,
												dev8  => pfused32,
												dev9  => pfused33);
												
		
												
	win:work.fifoa port map(		Clk => s_clk,
												RStn => s_aclr,
												D   => q_outt,
												w11 => p11_3x3,
												w12 => p12_3x3,
												w13 => p13_3x3,
												w21 => p21_3x3,
												w22 => p22_3x3,
												w23 => p23_3x3,
												w31 => p31_3x3,
												w32 => p32_3x3,
												w33 => p33_3x3);
												
	win2:work.fifoa port map(   Clk => s_clk,
												RStn => s_aclr,
												D    => q_outt2,
												w11  => q11_3x3,
												w12  => q12_3x3,
												w13  => q13_3x3,
												w21  => q21_3x3,
												w22  => q22_3x3,
												w23  => q23_3x3,
												w31  => q31_3x3,
												w32  => q32_3x3,
												w33  => q33_3x3);
												
	
				w11<=pfused11;
				w12<=pfused12;
				w13<=pfused13;
				w21<=pfused21;
				w22<=pfused22;
				w23<=pfused23;
				w31<=pfused31;
				w32<=pfused32;
				w33<=pfused33;
												
												
end behavior;