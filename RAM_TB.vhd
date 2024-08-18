library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY RAM_TB IS
END ENTITY RAM_TB;

ARCHITECTURE test OF RAM_TB IS

	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL rst : STD_LOGIC:= '0';

	SIGNAL	data_in :  std_logic_vector (7 downto 0);--:=(others=>'0');
	SIGNAL	addr_wr :  std_logic_vector (3 downto 0);--:=(others=>'0');
	SIGNAL write_enable :  std_logic:= '0';
	
	SIGNAL data_rd1 :  std_logic_vector (7 downto 0);--:=(others=>'0');
	SIGNAL addr_rd1 :  std_logic_vector  (3 downto 0);--:=(others=>'0');
	SIGNAL read1    :  std_logic:= '0';
	
	SIGNAL data_rd2 :  std_logic_vector (7 downto 0);--:=(others=>'0');
	SIGNAL addr_rd2 :  std_logic_vector  (3 downto 0);--:=(others=>'0');
	SIGNAL read2    :  std_logic:= '0';
	
	SIGNAL data_rd3 :  std_logic_vector (7 downto 0);--:=(others=>'0');
	SIGNAL addr_rd3 :  std_logic_vector  (3 downto 0);--:=(others=>'0');
	SIGNAL read3    :  std_logic:= '0';
	type image_type is array (0 to 15) of integer range 0 to 255;
	signal input_image : image_type := ((0,1,2,3,4,5,6,7,8,
													9,10,11,12,13,14,15));

BEGIN	
	clk <= NOT clk AFTER 1 NS WHEN NOW <= 300 NS ELSE '0';
	--rst <= '1', '0' AFTER 2 NS;
	--write_enable<='1';
	

		
			RAM :  ENTITY WORK.Img_RAM
										  
         PORT MAP(clk,rst,data_in,addr_wr,write_enable,data_rd1,addr_rd1,read1,data_rd2,addr_rd2,read2,data_rd3,addr_rd3,read3);
	process(clk) is 
	variable index : integer := 0;
	begin
		if (clk'EVENT and clk='1') then
					if(index <= 15) then
					 write_enable<='1';
                addr_wr <= std_logic_vector(to_signed(index, addr_wr'length));
                data_in <= std_logic_vector(to_signed(input_image(index), data_in'length));
					 index :=index +1;
					else
						write_enable<='0';
					end if;
 
    end if;
  end process;
		
END ARCHITECTURE test;	

