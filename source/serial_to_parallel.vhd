library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_to_parallel is
    generic (PORT_NUM : integer
             );
    port(i_clk         : in  std_logic; -- main clock
         i_rst         : in  std_logic; -- reset pin
         i_serial_data : in  std_logic; -- serial data input
         i_enable      : in  std_logic; -- data enable signal (incoming)
         o_data_valid  : out std_logic; -- data valid signal (converting finished)
         o_parallel    : out std_logic_vector(PORT_NUM-1 downto 0) -- parallel data output
         ); 
end serial_to_parallel;

architecture behavioral of serial_to_parallel is
    
    signal data_trnsf : std_logic;
    signal temp_p_data : std_logic_vector(PORT_NUM-1 downto 0);
    
    begin

    o_data_valid <= data_trnsf;
    
    process(i_clk,i_rst)
    begin
        if (i_rst = '1') then
            data_trnsf <= '0';
            temp_p_data <= (others => '0');
            o_parallel <= (others => '0');
        elsif (i_clk'event AND i_clk = '1') then
            if (i_enable = '1') then
                -- just push the data here to output as long as the i_enable pin is 1
                temp_p_data <= temp_p_data(PORT_NUM-2 downto 0)&i_serial_data;
				data_trnsf <= '0';
			else
                -- push the data to parallel output only when i_enable turns to 0
                o_parallel <= temp_p_data;
				data_trnsf <= '1';
            end if;
        end if;
    end process;
end behavioral;