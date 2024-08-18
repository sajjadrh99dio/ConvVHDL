------------------------------- Pattern detector Top module --------------------------------------
--------------------------------- Prepared by Sajjad Roohi ---------------------------------------
------------------------------------- SN : 810101175 ---------------------------------------------
---------------------- Computer assignment 2 of VHDL course by Dr.Navabi -------------------------
---------------------------------- University of Tehran ------------------------------------------
--------------------------------------- April 2024 -----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mytypes_pkg.all;

entity Pattern_detector is
  port (
	clock 			: in std_logic;
	reset 			: in std_logic;
	start				: in std_logic;
	data_in			: in std_logic_vector(7 downto 0);
	addr_wr			: in std_logic_vector(3 downto 0);
	write_enable	: in std_logic;
	done				: out std_logic;
	Final_Result			: out std_logic_vector(2 downto 0)
    );
end Pattern_detector;



architecture description of Pattern_detector is

signal data_rd1,data_rd2,data_rd3 : std_logic_vector(7 downto 0);
signal addr_rd1,addr_rd2,addr_rd3 : std_logic_vector(3 downto 0);
signal read1,read2,read3 : std_logic;
signal output_conv1_0,output_conv1_1,output_conv1_2,output_conv1_3 : std_logic_vector(7 downto 0);
signal output_conv2_0,output_conv2_1,output_conv2_2,output_conv2_3 : std_logic_vector(7 downto 0);
signal output_conv3_0,output_conv3_1,output_conv3_2,output_conv3_3 : std_logic_vector(7 downto 0);
signal conv_done1,conv_done2,conv_done3 : std_logic;

signal relu1_out0,relu1_out1,relu1_out2,relu1_out3 : std_logic_vector(7 downto 0);
signal relu2_out0,relu2_out1,relu2_out2,relu2_out3 : std_logic_vector(7 downto 0);
signal relu3_out0,relu3_out1,relu3_out2,relu3_out3 : std_logic_vector(7 downto 0);

signal MaxPool1_out,MaxPool2_out,MaxPool3_out : std_logic_vector(7 downto 0);

signal result_out : std_logic_vector(2 downto 0);


---------------------------------- component declaration ----------------------------------------
component Img_RAM IS PORT(
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
END component;
-------------------------------------------------------------------------------------------------
component Convolution is
			generic(
				DATA_WIDTH  	: integer :=8;
				KERNEL_WIDTH 	: integer :=3;
				IMAGE_WIDTH    : integer :=4;
				STRIDE 			: integer :=1;
				BIAS           : integer :=0;
				KERNEL_VALUES  : integer_matrix := ((1,1,1),(1,1,1),(1,1,1))
				);
			 
			 port (
						clk 			: in std_logic;
						rst			: in std_logic;
						conv_start	: in std_logic;
						conv_done	: out std_logic;
						output0		: out std_logic_vector(DATA_WIDTH-1 downto 0);
						output1		: out std_logic_vector(DATA_WIDTH-1 downto 0);
						output2		: out std_logic_vector(DATA_WIDTH-1 downto 0);
						output3		: out std_logic_vector(DATA_WIDTH-1 downto 0);
						read_img    : out std_logic;
						address     : out std_logic_vector(3 downto 0);
						input			: in std_logic_vector(DATA_WIDTH-1 downto 0)
				   );
end component;
-------------------------------------------------------------------------------------------------
component Relu is			 
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
end component;
-------------------------------------------------------------------------------------------------
component MaxPool is			 
			 port (
						input0 			: in std_logic_vector (7 downto 0);
						input1			: in std_logic_vector (7 downto 0);
						input2 			: in std_logic_vector (7 downto 0);
						input3 			: in std_logic_vector (7 downto 0);
						output 			: out std_logic_vector (7 downto 0)

				   );
end component;
-------------------------------------------------------------------------------------------------
component Result is			 
			 port (
						input0 			: in std_logic_vector (7 downto 0);
						input1			: in std_logic_vector (7 downto 0);
						input2 			: in std_logic_vector (7 downto 0);
						output 			: out std_logic_vector (2 downto 0)

				   );
end component;
-------------------------------------------------------------------------------------------------

begin

---------------------------------- Patten detector Portmap --------------------------------------
RAM1 : Img_RAM 
port map(
	clk => clock,
	rst => reset,

	data_in => data_in,
	addr_wr => addr_wr,
	write_enable => write_enable,
	
	data_rd1 => data_rd1,
	addr_rd1 => addr_rd1,
	read1    => read1,
	
	data_rd2 => data_rd2,
	addr_rd2 => addr_rd2,
	read2 => read2,
	
	data_rd3 => data_rd3,
	addr_rd3 => addr_rd3,
	read3  => read3

);

-------------------------------------------------------------------------------------------------

ConV1 : Convolution 
			generic map(
				DATA_WIDTH  	=>  8,
				KERNEL_WIDTH 	=>  3,
				IMAGE_WIDTH    =>  4,
				STRIDE 			=>  1,
				BIAS           =>  -1,
				KERNEL_VALUES  => ((0,1,0),(1,1,1),(0,1,0))
				)
			 
			 port map (
						clk 			=> clock ,
						rst			=> reset ,
						conv_start	=> start ,
						conv_done	=> conv_done1 ,
						output0		=> output_conv1_0 ,
						output1		=> output_conv1_1 ,
						output2		=> output_conv1_2 ,
						output3		=> output_conv1_3 ,
						read_img    =>  read1,
						address     =>  addr_rd1 ,
						input			=>  data_rd1
				   );

-------------------------------------------------------------------------------------------------

ConV2 : Convolution 
			generic map(
				DATA_WIDTH  	=>  8,
				KERNEL_WIDTH 	=>  3,
				IMAGE_WIDTH    =>  4,
				STRIDE 			=>  1,
				BIAS           =>  -2,
				KERNEL_VALUES  => ((1,1,1),(1,0,0),(1,1,1))
				)
			 
			 port map (
						clk 			=> clock ,
						rst			=> reset ,
						conv_start	=> start ,
						conv_done	=> conv_done2 ,
						output0		=> output_conv2_0 ,
						output1		=> output_conv2_1 ,
						output2		=> output_conv2_2 ,
						output3		=> output_conv2_3 ,
						read_img    =>  read2,
						address     =>  addr_rd2 ,
						input			=>  data_rd2
				   );

-------------------------------------------------------------------------------------------------

ConV3 : Convolution 
			generic map(
				DATA_WIDTH  	=>  8,
				KERNEL_WIDTH 	=>  3,
				IMAGE_WIDTH    =>  4,
				STRIDE 			=>  1,
				BIAS           =>  -2,
				KERNEL_VALUES  => ((1,1,1),(0,1,0),(0,1,0))
				)
			 
			 port map (
						clk 			=> clock ,
						rst			=> reset ,
						conv_start	=> start ,
						conv_done	=> conv_done3 ,
						output0		=> output_conv3_0 ,
						output1		=> output_conv3_1 ,
						output2		=> output_conv3_2 ,
						output3		=> output_conv3_3 ,
						read_img    =>  read3,
						address     =>  addr_rd3 ,
						input			=>  data_rd3
				   );

-------------------------------------------------------------------------------------------------
Relu1 : Relu 			 
			 port map(
						input0 			=> output_conv1_0,
						input1			=> output_conv1_1,
						input2 			=> output_conv1_2,
						input3 			=> output_conv1_3,
						
						output0 			=> relu1_out0,
						output1			=> relu1_out1,
						output2 			=> relu1_out2,
						output3 			=> relu1_out3
				   );
					
-------------------------------------------------------------------------------------------------

Relu2 : Relu 			 
			 port map(
						input0 			=> output_conv2_0,
						input1			=> output_conv2_1,
						input2 			=> output_conv2_2,
						input3 			=> output_conv2_3,
						
						output0 			=> relu2_out0,
						output1			=> relu2_out1,
						output2 			=> relu2_out2,
						output3 			=> relu2_out3
				   );
					
-------------------------------------------------------------------------------------------------					
					
Relu3 : Relu 			 
			 port map(
						input0 			=> output_conv3_0,
						input1			=> output_conv3_1,
						input2 			=> output_conv3_2,
						input3 			=> output_conv3_3,
						
						output0 			=> relu3_out0,
						output1			=> relu3_out1,
						output2 			=> relu3_out2,
						output3 			=> relu3_out3
				   );

-------------------------------------------------------------------------------------------------
MaxPool1 : MaxPool 			 
			  port map (
						input0 			=> relu1_out0,
						input1			=> relu1_out1,
						input2 			=> relu1_out2,
						input3 			=> relu1_out3,
						output 			=> MaxPool1_out

				   );
					
-------------------------------------------------------------------------------------------------
					
MaxPool2 : MaxPool 			 
			  port map (
						input0 			=> relu2_out0,
						input1			=> relu2_out1,
						input2 			=> relu2_out2,
						input3 			=> relu2_out3,
						output 			=> MaxPool2_out

				   );
					
-------------------------------------------------------------------------------------------------					
					
MaxPool3 : MaxPool 			 
			  port map (
						input0 			=> relu3_out0,
						input1			=> relu3_out1,
						input2 			=> relu3_out2,
						input3 			=> relu3_out3,
						output 			=> MaxPool3_out

				   );					
-------------------------------------------------------------------------------------------------					
Result1 : Result 			 
			 port map (
						input0 			=> MaxPool1_out,
						input1			=> MaxPool2_out,
						input2 			=> MaxPool3_out,
						output 			=> result_out

				   );
				
					
					
Final_Result <= result_out;
done <= conv_done1 and conv_done2 and conv_done3 ;					

end description;