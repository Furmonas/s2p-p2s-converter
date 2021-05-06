library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_multi_input is
    generic (INPUT_WIDTH  : integer; -- number of inputs
             COUNTER_SIZE : integer -- delay from debounce CLOCK Hz / 2^(COUNTER_SIZE) = X s
             );
    port (CLOCK_50 : in std_logic;
          input    : in std_logic_vector(INPUT_WIDTH-1 downto 0);
          output   : out std_logic_vector(INPUT_WIDTH-1 downto 0)
          );
end debounce_multi_input;

architecture behavioral of debounce_multi_input is
	signal ff1           : std_logic_vector (INPUT_WIDTH-1 downto 0);
	signal ff2           : std_logic_vector (INPUT_WIDTH-1 downto 0);
	signal clear_counter : std_logic_vector (INPUT_WIDTH-1 downto 0);
	signal counter       : unsigned (COUNTER_SIZE-1 downto 0) := (others => '0');
    -- this constant is only to check if the clear_counter bits are all 0's
    constant all_zeros   : std_logic_vector (INPUT_WIDTH-1 downto 0) := (others => '0');
begin
    -- detect oscillations at one of the inputs - clear counter as long as oscillations are active
	clear_counter <= ff1 XOR ff2;
process(CLOCK_50)
	begin
	if (CLOCK_50'event AND CLOCK_50 = '1') then
		ff1 <= input;
		ff2 <= ff1;
		if (clear_counter /= all_zeros) then
			counter <= (others => '0');
		elsif (counter(COUNTER_SIZE-1) = '0') then
			counter <= counter + 1;
		else
			output <= ff2;
		end if;
	end if;
end process;
end behavioral;
