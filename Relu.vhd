library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



entity Relu is			 
			 port (
						input0 			: in std_logic_vector (7 downto 0);
						input1			: in std_logic_vector (7 downto 0);
						input2 			: in std_logic_vector (7 downto 0);
						input3 			: in std_logic_vector (7 downto 0);
						
						output0 			: out std_logic_vector (7 downto 0);
						output1			: out std_logic_vector (7 downto 0);
						output2 			: out std_logic_vector (7 downto 0);
						output3 			: out std_logic_vector (7 downto 0)
				   );
end Relu;

architecture Behavioral of Relu is


signal output0_signal : std_logic_vector (7 downto 0);
signal output1_signal : std_logic_vector (7 downto 0);
signal output2_signal : std_logic_vector (7 downto 0);
signal output3_signal : std_logic_vector (7 downto 0);

begin

	with input0(7) select 
		output0_signal <=
						input0 when '0',
						(others =>'0') when others;
		
	with input1(7) select 
		output1_signal <=
						input1 when '0',
						(others =>'0') when others;
	with input2(7) select 
		output2_signal <=
						input2 when '0',
						(others =>'0') when others;
	with input3(7) select 
		output3_signal <=
						input3 when '0',
						(others =>'0') when others;						


	output0<=output0_signal;
	output1<=output1_signal;
	output2<=output2_signal;
	output3<=output3_signal;
	
end Behavioral;









 