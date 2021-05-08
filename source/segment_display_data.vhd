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
    alias seg1 : std_logic_vector(1 downto 0) is i_data(PORT_NUM-1 downto PORT_NUM-2);
    alias seg2 : std_logic_vector(3 downto 0) is i_data(PORT_NUM-3 downto PORT_NUM-6);
    alias seg3 : std_logic_vector(3 downto 0) is i_data(PORT_NUM-7 downto PORT_NUM-10);
    begin
    
    with seg1 select
        o_disp1 <= "1000000" when "00",
                   "1111001" when "01",
                   "0100100" when "10",
                   "0110000" when "11",
                   "1111111" when others;
        
                   
    with seg2 select
        o_disp2 <= "1000000" when "0000",
                   "1111001" when "0001",
                   "0100100" when "0010",
                   "0110000" when "0011",
                   "0011001" when "0100",
                   "0010010" when "0101",
                   "0000010" when "0110",
                   "1111000" when "0111",
                   "0000000" when "1000",
                   "0010000" when "1001",
                   "0001000" when "1010",
                   "0000011" when "1011",
                   "1000110" when "1100",
                   "0100001" when "1101",
                   "0000110" when "1110",
                   "0001110" when "1111",
                   "1111111" when others;
                   
    with seg3 select
        o_disp3 <= "1000000" when "0000",
                   "1111001" when "0001",
                   "0100100" when "0010",
                   "0110000" when "0011",
                   "0011001" when "0100",
                   "0010010" when "0101",
                   "0000010" when "0110",
                   "1111000" when "0111",
                   "0000000" when "1000",
                   "0010000" when "1001",
                   "0001000" when "1010",
                   "0000011" when "1011",
                   "1000110" when "1100",
                   "0100001" when "1101",
                   "0000110" when "1110",
                   "0001110" when "1111",
                   "1111111" when others;
        
end behavioral;
