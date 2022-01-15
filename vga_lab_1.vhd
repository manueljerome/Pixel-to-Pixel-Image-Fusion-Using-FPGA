library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_lab_1 is
generic(image_Width  : INTEGER := 171; -- Width of image in memory
        image_Height : INTEGER := 233; -- Height of image in memory
        dataSize     : INTEGER := 11;  -- MSB of each row in memory
        addressSize  : integer := 15); -- MSB of addresses
port(clk50MHz  : in std_logic;
     chooseRes : in std_logic;
	  im_cent       : in std_logic;
	  sclr      : in std_logic;
     r         : out std_logic_vector(3 downto 0);
     g         : out std_logic_vector(3 downto 0);
     b         : out std_logic_vector(3 downto 0);
     hsync     : out std_logic;
     vsync     : out std_logic);
end entity vga_lab_1;

architecture display of vga_lab_1 is
	
	-- Parameters for a 640x480 display
	constant hfp480p  : integer   := 16;
	constant hsp480p  : integer   := 96;
	constant hbp480p  : integer   := 48;
	constant hva480p  : integer   := 640;
	constant vfp480p  : integer   := 10;
	constant vsp480p  : integer   := 2;
	constant vbp480p  : integer   := 33;
	constant vva480p  : integer   := 480;
	-- Parameters for a 1024x768 display
	constant hfp768p  : integer   := 24;
	constant hsp768p  : integer   := 136;
	constant hbp768p  : integer   := 160;
	constant hva768p  : integer   := 1024;
	constant vfp768p  : integer   := 3;
	constant vsp768p  : integer   := 6;
	constant vbp768p  : integer   := 29;
	constant vva768p  : integer   := 768;
	-- Signals that will hold the front port etc that we will actually use
	signal   hfp      : integer; -- horizontal front porch
	signal   hsp      : integer; -- horizontal sync pulse
	signal   hbp      : integer; -- horizontal back porch
	signal   hva      : integer; -- horizontal visible area
	signal   vfp      : integer; -- vertical front porch
	signal   vsp      : integer; -- vertical sync pulse
	signal   vbp      : integer; -- vertical back porch
	signal   vva      : integer; -- vertical visible area
	-- Signal to hold the clock we will use for the display
	signal   sync2_clk : std_logic := '0';
	--signal to receive fifo clock
	signal fifoclk : std_logic:= '0';
	-- Signals for each of the clocks available to us
	signal   clk25      : std_logic := '0';
	signal   clk65      : std_logic := '0';
	-- Signals to hold the present horizontal and vertical positions.
	signal   hposition  : integer   := 0;
	signal   vposition  : integer   := 0;
	--FIFO signals 
	signal ofifoa : std_logic_vector(dataSize downto 0)    := (others=>'0');
	signal clear : std_logic;
   signal wrreqa : std_logic:='1';
   signal rdreqa : std_logic:='0';
	
	-- Signals to hold the present memory address to be read and the data read
	signal data_address : std_logic_vector(addressSize downto 0) := (others=>'0');
	signal raw_data     : std_logic_vector(dataSize downto 0)    := (others=>'0');
	signal raw_data1    : std_logic_vector(dataSize downto 0)    := (others=>'0');
		signal raw_data2    : std_logic_vector(dataSize downto 0)    := (others=>'0');
			signal raw_data3    : std_logic_vector(dataSize downto 0)    := (others=>'0');
				signal raw_data4    : std_logic_vector(dataSize downto 0)    := (others=>'0');
					signal raw_data5    : std_logic_vector(dataSize downto 0)    := (others=>'0');
						signal raw_data6    : std_logic_vector(dataSize downto 0)    := (others=>'0');
							signal raw_data7    : std_logic_vector(dataSize downto 0)    := (others=>'0');
								signal raw_data8    : std_logic_vector(dataSize downto 0)    := (others=>'0');
									signal raw_data9    : std_logic_vector(dataSize downto 0)    := (others=>'0');
	

begin
	sync2_clk<= clk25   when (chooseRes = '0') else clk65;
	hfp      <= hfp480p when (chooseRes = '0') else hfp768p;
	hsp      <= hsp480p when (chooseRes = '0') else hsp768p;
	hbp      <= hbp480p when (chooseRes = '0') else hbp768p;
	hva      <= hva480p when (chooseRes = '0') else hva768p;
	vfp      <= vfp480p when (chooseRes = '0') else vfp768p;
	vsp      <= vsp480p when (chooseRes = '0') else vsp768p;
	vbp      <= vbp480p when (chooseRes = '0') else vbp768p;
	vva      <= vva480p when (chooseRes = '0') else vva768p;
	
	disp_clk: work.sync_clk2 port map(inclk0 => clk50MHz,
                                    c0     => clk25,
                                    c1     => clk65);
	disp1: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w11          => raw_data1);
	disp2: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w12          => raw_data2);
	disp3: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w13          => raw_data3);
	disp4: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w21          => raw_data4);
	disp5: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w22          => raw_data5);
	disp6: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w23          => raw_data6);
	disp7: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w31          => raw_data7);
	disp8: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w32          => raw_data8);
												
	disp9: work.base_interf port map(
												data_address => data_address,
												clk        => sync2_clk,
												w33         => raw_data9);

		
		
	process(sync2_clk,hfp,hsp,hbp,hva,vva,vfp,vsp,vbp)
	variable hcentre            : integer := hfp + hsp + hbp + (hva/2);
	variable vcentre            : integer := vfp + vsp + vbp + (vva/2);
	variable image_hstart       : integer := hcentre      - image_Width/2;
	variable image_hstop        : integer := image_hstart + image_Width;
	variable image_vstart       : integer := 100;--point to edit for centralization
	variable image_vstop        : integer := image_vstart + image_Height;--here as well for lab_1
	variable image_pixel_col    : integer := 0;
	variable image_pixel_row    : integer := 0;
	variable image_pixel_number : integer := 0;
	variable mem_Address        : unsigned(addressSize downto 0) := (others=>'0');
	variable i                  : integer range 0 to 8;
	variable compare            : integer := 8;

	begin
		if rising_edge(sync2_clk) then
			if sync2_clk <= clk25 then 
				if im_cent = '1' then
					image_vstart := 250;
					else
					image_vstart :=100;
					end if;
				elsif sync2_clk <= clk65 then
				    if im_cent = '1' then
					image_vstart := 90;
					else
					image_vstart :=10;
					end if;

				
					
			end if;
			
			i := 0;
			while i < compare loop
			if i = 0 then
			raw_data <= raw_data1;
			elsif i = 1 then
			raw_data <= raw_data2;
			elsif i =2 then
			raw_data <= raw_data3;
			elsif i =3 then
			raw_data <= raw_data4;
			elsif i =4 then
			raw_data <= raw_data5;
			elsif i =5 then
			raw_data <= raw_data6;
			elsif i =6 then
			raw_data <= raw_data7;
			elsif i =7 then
			raw_data <= raw_data8;
			elsif i =8 then
			raw_data <= raw_data9;
			end if;
			
			i := i+1;
			end loop;
			
			
			-- Always increment the horizontal position counter with each active clock pulse
			hposition <= hposition + 1;
			
			-- When horizontal position counter gets to the last pixel in a row, go back
			-- to zero and increment the vertical counter (i.e. go to start of next line)
			if hposition >= (hfp+hsp+hbp+hva) then
				hposition <= 0;
				-- when vertical position counter gets to the end of rows, go back to the
				-- start of the first row
				if vposition >= (vfp+vsp+vbp+vva) then
					vposition <= 0;
				else
					vposition <= vposition + 1;
				end if;
			end if;
			
			
			-- Generate horizontal synch pulse whenever the hposition is between the front
			-- porch and the back porch
			if (hposition >= hfp) and (hposition < (hfp+hsp)) then
				hsync <= '0';
			else
				hsync <= '1';
			end if;

			-- Generate vertical synch pulse whenever the vposition is between the front
			-- porch and the back porch
			if (vposition >= vfp) and (vposition < (vfp+vsp)) then
				vsync <= '0';
			else
				vsync <= '1';
			end if;
			
			
			
			
			-- Now to put things up on the display
			-- Where do we want to put things?
			-- Let's put the image in our memory in the centre of the screen starting
			-- from the 100th row. We first determine the bounds in which the image will be
			-- displayed and then tell it what memory address to read from in order to 
			-- display the contents of the memory onto the display.
			-- The central pixel of the visible area is 
			if ((hposition >= image_hstart and hposition <= image_hstop) and (vposition >= image_vstart and vposition <= image_vstop)) then
				image_pixel_col := hposition - image_hstart;--for lab3 edit this part to specify the location of the square
				image_pixel_row := vposition - image_vstart;
				image_pixel_number := image_pixel_col + image_pixel_row*image_Width;
				mem_Address  := to_unsigned(image_pixel_number, mem_Address'length);
				data_address <= std_logic_vector(mem_Address);
				r <= raw_data(11 downto 8);
				g <= raw_data(7 downto 4);
				b <= raw_data(3 downto 0);
			else
			   r <= x"2";
		      g <= x"2";
		      b <= x"2";--duplicate and edit this for lab3 to get the colors for the square
			end if;
		end if;
	end process;

end architecture display;
