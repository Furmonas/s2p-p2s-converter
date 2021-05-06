library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity segment_display_data is
    generic (PORT_NUM : integer;
             SEG_USED : integer);
    port (i_clk  : in std_logic;
          i_rst  : in std_logic;
          i_data : in std_logic_vector(PORT_NUM-1 downto 0);
          o_disp : out std_logic_vector((SEG_USED*2)-1 downto 0)
          );
end segment_display_data;

architecture behavioral of segment_display_data is
    component debounce is
        generic (COUNTER_SIZE : integer -- delay from debounce CLOCK Hz / 2^(COUNTER_SIZE) = X s
                 );
        port (CLOCK_50 : in std_logic;
              input    : in std_logic;
              output   : out std_logic
              );
    end component;

    begin
    
    process (i_clk, i_rst)
    begin
        if (i_rst = '1') then
        
        elsif (rising_edge(i_clk)) then
        
        end if;
    end process;
end behavioral;
