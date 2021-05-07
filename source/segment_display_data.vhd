library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity segment_display_data is
    generic (PORT_NUM    : integer;
             SEGMENT_NUM : integer
             );
    port (i_data  : in std_logic_vector(PORT_NUM-1 downto 0);
          o_disp1 : out std_logic_vector(SEGMENT_NUM-1 downto 0);
          o_disp2 : out std_logic_vector(SEGMENT_NUM-1 downto 0);
          o_disp3 : out std_logic_vector(SEGMENT_NUM-1 downto 0)
          );
end segment_display_data;

architecture behavioral of segment_display_data is
    alias seg1 : std_logic_vector(3 downto 0) is i_data(PORT_NUM-1 downto PORT_NUM-4);
    alias seg2 : std_logic_vector(3 downto 0) is i_data(PORT_NUM-5 downto PORT_NUM-8);
    alias seg3 : std_logic_vector(1 downto 0) is i_data(PORT_NUM-9 downto PORT_NUM-10);
    begin
    
    with seg1 select
        o_disp1 <= "0000000" when "0000",
                   "1111111" when others;
                   
    with seg2 select
        o_disp2 <= "0000000" when "0000",
                   "1111111" when others;
                   
    with seg3 select
        o_disp3 <= "0000000" when "00",
                   "1111111" when others;
        
end behavioral;
