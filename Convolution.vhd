-- package declaration
package mytypes_pkg is

     type integer_matrix is array (0 to 2,0 to 2) of integer ;

end package mytypes_pkg;

-- entity "uses" the package   




library ieee;
use work.mytypes_pkg.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity Convolution is
			generic(
				DATA_WIDTH  	: integer :=8;
				KERNEL_WIDTH 	: integer :=3;
				IMAGE_WIDTH    : integer :=4;
				STRIDE 			: integer :=1;
				BIAS           : integer :=0;
				KERNEL_VALUES  : integer_matrix := ((1,1,1),(1,1,1),(1,1,1)) -- Default Kernel Value
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
end Convolution;

architecture Behavioral of Convolution is
	-- KERNEL MATRIX
	--type kernel_type is array(0 to KERNEL_WIDTH-1, 0 to KERNEL_WIDTH-1) of integer;
	signal kernel : integer_matrix := KERNEL_VALUES;
	--signal bias   : integer := BIAS;
	-- IMAGE LOADING ARRAY
	type image_type is array (0 to IMAGE_WIDTH -1 , 0 to IMAGE_WIDTH-1) of std_logic_vector ((DATA_WIDTH-1) downto 0);
	signal input_image : image_type := (others => (others => (others => '0')));
	
	type conved_image_type is array (0 to (((IMAGE_WIDTH-KERNEL_WIDTH)/STRIDE)+1)-1,
												0 to (((IMAGE_WIDTH-KERNEL_WIDTH)/STRIDE)+1)-1) of std_logic_vector((DATA_WIDTH-1) downto 0);
	signal output_image : conved_image_type := (others => (others => (others => '0')));
	
	
	TYPE State_type IS (IDLE,INITIALIZE,IMAGE_ACQUISITION,CONVOLUTION_CAL);
	signal state : state_type;
	

	signal address_signal : std_logic_vector (3 downto 0);
	signal address_generation,Image_ACQUISITION_done,conv_cal_start,conv_cal_done : std_logic :='0';

	signal img_ACQUISITION_init,conv_init : std_logic :='0';
	signal read_img_signal : std_logic :='0';
	--signal index_i_conv_debug,index_j_conv_debug,output_position_i_debug,output_position_j_debug,temp_conv_value_debug : std_logic_vector ( 7 downto 0) :=(others =>'0');
------------------------------------------------------------------------------	
	begin

	
	State_CONTROL : process (clk, rst) is
							begin
							
								if(rst='1') then
							
									--input_image <= (others => (others =>(others => '0')));
									--address_variable<=(others =>'0');
									img_ACQUISITION_init<='0';
									conv_init<='0';
									address_generation <='0';
									conv_cal_start<='0';
									state<= IDLE;
									
								else
		
									
									if (clk'EVENT and clk='1') then
										img_ACQUISITION_init<='0';
										conv_init<='0';
										address_generation <='0';
										conv_cal_start<='0';
										
										case state is
										
										when IDLE =>
											if(conv_start='1') then
												state <= INITIALIZE;
											else
												state<=IDLE;
											end if;
										
									when INITIALIZE =>
											img_ACQUISITION_init<='1';
											conv_init<='1';
											address_generation <='0';
											conv_cal_start<='0';
											
											if(conv_start='0') then
												state <= IMAGE_ACQUISITION;
											else 
												state <= INITIALIZE;
											end if;
										
										
									when IMAGE_ACQUISITION => 
										address_generation <='1';
										if( Image_ACQUISITION_done = '1') then
											state <= CONVOLUTION_CAL;
											address_generation <='0';
										else 
											state <= IMAGE_ACQUISITION;
										end if;
									
									
									when CONVOLUTION_CAL =>	
										conv_cal_start <='1';
										if(conv_cal_done='1') then
											state <= IDLE;
											conv_cal_start <='0';
										else 
											state <= CONVOLUTION_CAL;
										end if;
									end case;
								end if;
						end if;

		
		
		end process State_CONTROL;
		
		img_ACQUISITION : process (clk, rst) is
							variable address_counter_i : integer :=0;
							variable address_counter_j : integer :=0;
								begin
									if(rst = '1') then
										input_image <= (others => (others =>(others => '0')));
										Image_ACQUISITION_done<='0';
										address_signal<= (others =>'0');
										read_img_signal<='0';
										address_counter_i := 0;
										address_counter_j :=0;
									else
										if (clk'EVENT and clk='1') then
											Image_ACQUISITION_done<='0';
											read_img_signal<='0';
											if(img_ACQUISITION_init = '1') then
													input_image <=  (others => (others =>(others => '0')));
													Image_ACQUISITION_done<='0';
													address_signal<= (others =>'0');
													--read_img_signal<='0';
													address_counter_j :=0;
													address_counter_i := 0;
													read_img_signal<='1';
											elsif (address_generation ='1') then
													read_img_signal<='1';
--													address_signal <= std_logic_vector(to_unsigned((address_counter_i+address_counter_j*
--																													IMAGE_WIDTH), address_signal'length));
													input_image(address_counter_j,address_counter_i)<= input;
													address_counter_i:= address_counter_i+1;
													address_signal <= std_logic_vector(to_unsigned((address_counter_i+address_counter_j*
																													IMAGE_WIDTH), address_signal'length));													
													if(address_counter_i = (IMAGE_WIDTH)) then
														if(address_counter_j =(IMAGE_WIDTH-1)) then
															Image_ACQUISITION_done<='1';
															address_counter_i :=0;
															address_counter_j :=0;
														else
															address_counter_i :=0;
															address_counter_j	:= address_counter_j+1;
														end if;
													end if;

											end if;
										end if;
								end if;
		end process img_ACQUISITION;
						
						
		conv_calculation : process (clk, rst) is
							variable index_i_conv : integer :=0;
							variable index_j_conv : integer :=0;
							variable output_position_i : integer :=0;
							variable output_position_j : integer :=0;
							variable temp_conv_value : integer :=0;
								begin
									if(rst = '1') then
										output_image <= (others => (others => (others => '0')));
										conv_cal_done<='0';
										index_i_conv := 0;
										index_j_conv :=0;
										output_position_i :=0;
										output_position_j :=0;
										temp_conv_value :=0;
									else
										if (clk'EVENT and clk='1') then
											conv_cal_done<='0';
											if(conv_init ='1') then
												output_image <= (others => (others => (others => '0')));
												conv_cal_done<='0';
												index_i_conv := 0;
												index_j_conv :=0;
												output_position_i :=0;
												output_position_j :=0;												
												temp_conv_value :=0;
												
											elsif(conv_cal_start='1') then
												--temp_conv_value :=0;
												temp_conv_value := temp_conv_value +
																		 to_integer(signed(input_image(index_j_conv + output_position_j,index_i_conv + output_position_i))) 
																		 * kernel(index_j_conv,index_i_conv);-- + BIAS;
													--temp_conv_value_debug<=std_logic_vector(to_unsigned(temp_conv_value, temp_conv_value_debug'length));
													
												   index_i_conv := index_i_conv+1;
													--index_i_conv_debug<=std_logic_vector(to_unsigned(index_j_conv, index_j_conv_debug'length));
													if(index_i_conv = (KERNEL_WIDTH)) then
														if(index_j_conv =(KERNEL_WIDTH-1)) then
															temp_conv_value := temp_conv_value + BIAS;
															output_image(output_position_j,output_position_i)
																				<= std_logic_vector(to_signed(temp_conv_value, input'length));
															temp_conv_value :=0;
															output_position_i := output_position_i+1;
															--output_position_i_debug<=std_logic_vector(to_unsigned(output_position_i, output_position_i_debug'length));
															index_i_conv := 0;
															index_j_conv :=0;
															if(output_position_i = ((IMAGE_WIDTH-KERNEL_WIDTH)/STRIDE)+1) then
																if(output_position_j = (((IMAGE_WIDTH-KERNEL_WIDTH)/STRIDE)+1)-1) then
																	conv_cal_done<='1';
																	output_position_i :=0;
																	output_position_j :=0;
																else
																	output_position_i :=0;
																	
																	output_position_j:= output_position_j+1;
																	--output_position_j_debug<=std_logic_vector(to_unsigned(output_position_j, output_position_j_debug'length));
																end if;
															end if;
														else
															index_i_conv := 0;
															index_j_conv := index_j_conv +1;
															--index_j_conv_debug<=std_logic_vector(to_unsigned(index_j_conv, index_j_conv_debug'length));
														end if;
													end if;
								end if;
							end if;
						end if;
						
					end process conv_calculation;											
																	
												

		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

			read_img <= read_img_signal;
			address  <= address_signal;
			conv_done<=conv_cal_done;
			
			output0<=output_image(0,0);
			output1<=output_image(0,1);
			output2<=output_image(1,0);
			output3<=output_image(1,1);
			
end  Behavioral;	