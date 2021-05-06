library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    generic (COUNTER_SIZE : integer -- delay from debounce CLOCK Hz / 2^(COUNTER_SIZE) = X s
             );
    port (CLOCK_50 : in std_logic;
          input    : in std_logic;
          output   : out std_logic
          );
end debounce;

architecture behavioral of debounce is
	signal ff            : std_logic_vector (1 downto 0);
	signal clear_counter : std_logic;
	signal counter       : unsigned (COUNTER_SIZE-1 downto 0) := (others => '0');
begin
	clear_counter <= ff(0) XOR ff(1);
process(CLOCK_50)
	begin
	if (CLOCK_50'event AND CLOCK_50 = '1') then
		ff(0) <= input;
		ff(1) <= ff(0);
		if (clear_counter = '1') then
			counter <= (others => '0');
		elsif (counter(COUNTER_SIZE-1) = '0') then
			counter <= counter + 1;
		else
			output <= ff(1);
		end if;
	end if;
end process;
end behavioral;
