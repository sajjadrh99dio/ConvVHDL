LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.Numeric_Std.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

ENTITY Img_RAM IS PORT(
	clk : in std_logic;
	rst : in std_logic;

	data_in : in std_logic_vector (7 downto 0);
	addr_wr : in std_logic_vector (3 downto 0);
	write_enable : in std_logic;
	
	data_rd1 : out std_logic_vector (7 downto 0);
	addr_rd1 : in std_logic_vector  (3 downto 0);
	read1    : in std_logic;
	
	data_rd2 : out std_logic_vector (7 downto 0);
	addr_rd2 : in std_logic_vector  (3 downto 0);
	read2    : in std_logic;
	
	data_rd3 : out std_logic_vector (7 downto 0);
	addr_rd3 : in std_logic_vector  (3 downto 0);
	read3    : in std_logic

);
END Img_RAM;


ARCHITECTURE behavioral OF Img_RAM IS


   TYPE ram_type IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL ram : ram_type;


begin



	process (clk,rst) IS
	begin
		if(rst ='1') then
			ram <= (others => ( others =>'0'));
		elsif(clk'EVENT and clk='1') then
			if(write_enable ='1') then
				ram(to_integer(unsigned(addr_wr))) <= data_in;
			end if;
		end if;
	end process;
	 
	 
	 
	 with read1 select
			data_rd1<=ram(to_integer(unsigned(addr_rd1)))   when '1',
						(others => 'U') when others;
						
						
	 with read2 select
			data_rd2<=ram(to_integer(unsigned(addr_rd2)))   when '1',
						(others => 'U') when others;
						
						
	 with read3 select
			data_rd3<=ram(to_integer(unsigned(addr_rd3)))   when '1',
						(others => 'U') when others;
																		
			


end behavioral;
