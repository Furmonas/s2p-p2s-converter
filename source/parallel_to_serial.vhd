library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity parallel_to_serial is
    generic (PORT_NUM : integer
             );
    port(i_clk      : in  std_logic; -- clock
         i_data     : in  std_logic_vector(PORT_NUM-1 downto 0); -- input data
         i_rst      : in  std_logic; -- reset
		 i_en       : in  std_logic; -- input enable - load input
		 o_transf   : out std_logic; -- data transfer in progress (1), done (0)
         o_data     : out std_logic -- serial data
          );
end parallel_to_serial;

architecture behavioral of parallel_to_serial is

    component debounce_multi_input is
        generic (INPUT_WIDTH  : integer;
                 COUNTER_SIZE : integer
                 );
        port (CLOCK_50 : in std_logic;
              input    : in std_logic_vector(INPUT_WIDTH-1 downto 0);
              output   : out std_logic_vector(INPUT_WIDTH-1 downto 0)
              );
    end component;

	signal i_data_dbc  : std_logic_vector(PORT_NUM-1 downto 0);

	signal ff : std_logic_vector(PORT_NUM-1 downto 0); -- register
	signal cnt : unsigned (PORT_NUM-1 downto 0) := (others => '0'); -- counter for data transfer
	signal transf_en : std_logic; -- transfer enable signal
    
    begin
                       
    DBC_MUL1: debounce_multi_input
		      generic map (INPUT_WIDTH => PORT_NUM,
                           COUNTER_SIZE => 17)
		      port map (CLOCK_50 => i_clk,
                        input => i_data,
                        output => i_data_dbc);
    -- output data that is obtained in the process
	o_transf <= transf_en;
    o_data <= ff(PORT_NUM-1);
    -- sensitivity list
    
    process(i_clk, i_rst)
    begin
        -- input reset signal highest prio
		if (i_rst = '1') then
            -- reset everything
			ff <= (others => '0');
			cnt <= (others => '0');
			transf_en <= '0';
        elsif (i_clk'event AND i_clk = '1') then
            -- wait for data synchronizatio signal - data enable
			if (i_en = '1') then
				transf_en <= '1';
				cnt <= (others => '0');
				ff <= i_data_dbc;
            -- wait for the data transfer p2s to finish - counter indicates this cycle
            -- it will continue as much clock cycles as the data line is
			elsif (cnt < PORT_NUM-1) then
				cnt <= cnt + 1;
				transf_en <= '1';
				ff <= ff(PORT_NUM-2 downto 0) & '0';
            -- after the clock ends 
			else
                -- finish off the transmission
				if (transf_en = '1') then
					ff <= ff(PORT_NUM-2 downto 0) & '0';
				end if;
                -- all data transfered - disable transfer signal
				transf_en <= '0';
            end if;
        end if;
    end process;
end behavioral;