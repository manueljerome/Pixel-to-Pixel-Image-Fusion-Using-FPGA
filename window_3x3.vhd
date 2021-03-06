library IEEE;
use IEEE.std_logic_1164.all;
entity window_3x3 is
generic (
vwidth: integer:=12
);
port (   Din : in std_logic_vector(vwidth -1 downto 0);
			Clk : in std_logic;
			RSTn : in std_logic;
			w11 : out std_logic_vector(vwidth -1 downto 0); 
			w12 : out std_logic_vector(vwidth -1 downto 0);
			w13 : out std_logic_vector(vwidth -1 downto 0);
			w21 : out std_logic_vector(vwidth -1 downto 0);
			w22 : out std_logic_vector(vwidth -1 downto 0);
			w23 : out std_logic_vector(vwidth -1 downto 0);
			w31 : out std_logic_vector(vwidth -1 downto 0);
			w32 : out std_logic_vector(vwidth -1 downto 0);
			w33 : out std_logic_vector(vwidth -1 downto 0);
			DV : out std_logic:='0'
);
end window_3x3;
architecture window_3x3 of window_3x3 is
component fifob
PORT
(
aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		almost_empty		: OUT STD_LOGIC ;
		almost_full		: OUT STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
);
END component fifob;
 
signal a11 : std_logic_vector(vwidth-1 downto 0); 
signal a12 : std_logic_vector(vwidth-1 downto 0);
signal a13 : std_logic_vector(vwidth-1 downto 0);
signal a21 : std_logic_vector(vwidth-1 downto 0);
signal a22 : std_logic_vector(vwidth-1 downto 0);
signal a23 : std_logic_vector(vwidth-1 downto 0);
signal a31 : std_logic_vector(vwidth-1 downto 0);
signal a32 : std_logic_vector(vwidth-1 downto 0);
signal a33 : std_logic_vector(vwidth-1 downto 0);
 
 --fifoa signals
signal clear : std_logic;
signal wrreqa : std_logic:='1';
signal rdreqa : std_logic:='0';
signal ofulla : std_logic;
signal oemptya : std_logic;
signal ofifoa : std_logic_vector(vwidth-1 downto 0);
signal ousedwa : std_logic_vector(15 downto 0);

--fifob signals
signal wrreqb : std_logic:='0';
signal rdreqb : std_logic:='0';
signal ofullb : std_logic;
signal oemptyb : std_logic;
signal ofifob : std_logic_vector(vwidth-1 downto 0);
signal ousedwb : std_logic_vector(15 downto 0);
signal dwrreqb: std_logic:='0';

-- signals for DV coordination
signal dddddddddDV: std_logic:='0';
signal ddddddddDV: std_logic;
signal dddddddDV: std_logic;
signal ddddddDV: std_logic;
signal dddddDV: std_logic;
signal ddddDV: std_logic;
signal dddDV: std_logic;
signal ddDV: std_logic;
signal dDV: std_logic;

		begin
		fifoc: fifob
		port map (
		data => a13,
		wrreq => wrreqa,
		rdreq => rdreqa,
		clock => Clk, 
		aclr => clear,
		q => ofifoa,
		full => ofulla,
		empty => oemptya,
		usedw => ousedwa
		);
		fifod: fifob 
		port map (
		data => a23,
		wrreq => wrreqb,
		rdreq => rdreqb,
		clock => Clk, 
		aclr => clear,
		q => ofifob,
		full => ofullb,
		empty => oemptyb,
		usedw => ousedwb
		);
						 
		clear <= not(RSTn);
		clock: process(Clk,RSTn)
		begin
		if RSTn = '0' then
		a11 <= (others=>'0');
		a12 <= (others=>'0');
		a13 <= (others=>'0');
		a21 <= (others=>'0');
		a22 <= (others=>'0');
		a23 <= (others=>'0');
		a31 <= (others=>'0');
		a32 <= (others=>'0');
		a33 <= (others=>'0');
		w11 <= (others=>'0');
		w12 <= (others=>'0');
		w13 <= (others=>'0');
		w21 <= (others=>'0');
		w22 <= (others=>'0');
		w23 <= (others=>'0');
		w31 <= (others=>'0');
		w32 <= (others=>'0');
		w33 <= (others=>'0'); 
		wrreqa <= '0';
		wrreqb <= '0'; 
		ddddddddDV <= '0';
		dddddddDV <= '0';
		ddddddDV <= '0';
		dddddDV <= '0';
		ddddDV <= '0';
		dddDV <= '0';
		ddDV <= '0';
		dDV <= '0';
		DV <= '0';
		elsif rising_edge(Clk) then
		a11 <= Din;
		a12 <= a11;
		a13 <= a12;
		a21 <= ofifoa;
		a22 <= a21;
		a23 <= a22;
		a31 <= ofifob;
		a32 <= a31;
		a33 <= a32;
		w11 <= a11;
		w12 <= a12;
		w13 <= a13;
		w21 <= a21;
		w22 <= a22;
		w23 <= a23;
		w31 <= a31;
		w32 <= a32;
		w33 <= a33;
		wrreqa <= '1';
		wrreqb <= dwrreqb;
		ddddddddDV <= dddddddddDV;
		dddddddDV <= ddddddddDV;
		ddddddDV <= dddddddDV;
		dddddDV <= ddddddDV;
		ddddDV <= dddddDV;
		dddDV <= ddddDV;
		ddDV <= dddDV;
		dDV <= ddDV;
		DV <= dDV;
		end if;
		end process;
		
		req: process(Clk)
		begin
		if rising_edge(Clk) then
		if ousedwa = "1111011" then
		rdreqa <= '1';
		dwrreqb <= '1';
		end if;
		if ousedwb = "1111011" then
		rdreqb <= '1';
		elsif ousedwb = "1111100" then
		dddddddddDV <= '1';
end if;
end if;
end process;
end window_3x3;
