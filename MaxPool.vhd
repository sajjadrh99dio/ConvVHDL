library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



entity MaxPool is			 
			 port (
						input0 			: in std_logic_vector (7 downto 0);
						input1			: in std_logic_vector (7 downto 0);
						input2 			: in std_logic_vector (7 downto 0);
						input3 			: in std_logic_vector (7 downto 0);
						output 			: out std_logic_vector (7 downto 0)

				   );
end MaxPool;

architecture Behavioral of MaxPool is


signal output_signal : std_logic_vector (7 downto 0):= (others=>'0');
signal temp1 : std_logic_vector (7 downto 0):= (others=>'0');
signal temp2 : std_logic_vector (7 downto 0):= (others=>'0');

begin

	process(input0,input1,input2,input3) is
		begin
			temp1<= (others=>'0');
			temp2<= (others=>'0');
			
			if (input0 >= input1) then
				temp1<=input0;
			else
				temp1<=input1;
			end if;
			
			if (input2 >= input3) then
				temp2<=input2;
			else
				temp2<=input3;
			end if;			

		end process;


	process(temp1,temp2) is
		begin
			output_signal<= (others=>'0');
			if (temp1>=temp2) then
				output_signal<=temp1;
			else
				output_signal<=temp2;
			end if;			

	end process;			
				
					
				
			
			
	output<=output_signal;
	
end Behavioral;









 