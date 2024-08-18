library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



entity Result is			 
			 port (
						input0 			: in std_logic_vector (7 downto 0);
						input1			: in std_logic_vector (7 downto 0);
						input2 			: in std_logic_vector (7 downto 0);
						output 			: out std_logic_vector (2 downto 0)

				   );
end Result;

architecture Behavioral of Result is


signal output_signal_1 : std_logic_vector (1 downto 0):= (others=>'0');
signal output_signal_2 : std_logic:= '0';
signal output_signal_3 : std_logic_vector (2 downto 0):= (others=>'0');
signal temp1 : std_logic_vector (7 downto 0):= (others=>'0');


begin

	process(input0,input1) is
		begin
			temp1<= (others=>'0');
			output_signal_1<= (others=>'0');
			
			if (input0 >= input1) then
				temp1<=input0;
				output_signal_1<="01";
			else
				temp1<=input1;
				output_signal_1<="10";
			end if;

		end process;


	process(temp1,input2) is
		begin
			output_signal_2<= '0';
			if (temp1>=input2) then
				output_signal_2<='0';
			else
				output_signal_2<='1';
			end if;			

	end process;			
				
					
				
	with output_signal_2 select
			output_signal_3<= '0' & output_signal_1 when '0',
									"100" when others;
			
	output<= output_signal_3;
	
end Behavioral;









 