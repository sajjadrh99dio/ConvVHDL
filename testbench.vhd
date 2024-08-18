library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY testbench IS
END ENTITY testbench;

ARCHITECTURE test OF testbench IS

	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL rst : STD_LOGIC:= '0';

	SIGNAL	data_in :  std_logic_vector (7 downto 0);
	SIGNAL	addr_wr :  std_logic_vector (3 downto 0);
	SIGNAL	Final_Result :  std_logic_vector (2 downto 0):=(others=>'0');
		
	SIGNAL write_enable,done,start :  std_logic:= '0';

	type image_type is array (0 to 15) of integer range 0 to 255;
	signal input_image : image_type := ((1,1,1,1,1,0,0,0,
													1,1,1,0,0,0,0,1));

BEGIN	

Pattern_det0 :  ENTITY WORK.Pattern_detector PORT MAP(clk,rst,start,data_in,addr_wr,write_enable,done,Final_Result);
------------------------------------------------------------------------------------


	clk <= NOT clk AFTER 1 NS WHEN NOW <= 200 NS  ELSE '0';
	--rst <= '0' AFTER 1 NS;
	--start<= '1','0' AFTER 2 NS;
	
	process
		begin
			wait for 50 ns;  -- Wait for 50 ns

			start <= '1';
			wait for 2 ns;   -- Wait for 2 ns

			start <= '0';
			    loop
				wait;
			end loop;
			-- Loop forever
			
	end process;
	
	
	
	
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
	--rst <= '1', '0' AFTER 2 NS;
	--write_enable<='1';
	

		

			
			
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
