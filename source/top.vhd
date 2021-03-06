library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
    generic (INPUT_PORTS : integer := 10; -- 10 ports (10 bits [0..9])
             SEGMENT_NUM : integer := 7
             );
    port(i_clk      : in  std_logic;
         i_parallel : in  std_logic_vector(INPUT_PORTS-1 downto 0);
         i_rst      : in  std_logic;
         i_serial   : in  std_logic; -- serial input connected externally to o_serial (for simultation purpose)
         o_serial   : out std_logic; -- serial output connected externally to i_serial (for simulation purpose)
         -- o_parallel : out std_logic_vector(INPUT_PORTS-1 downto 0);
         o_segment1 : out std_logic_vector(SEGMENT_NUM-1 downto 0);
         o_segment2 : out std_logic_vector(SEGMENT_NUM-1 downto 0);
         o_segment3 : out std_logic_vector(SEGMENT_NUM-1 downto 0)
         );
    end top;

architecture behavioral of top is
    component debounce is
        generic (COUNTER_SIZE : integer -- delay from debounce CLOCK Hz / 2^(COUNTER_SIZE) = X s
                 );
        port (CLOCK_50 : in std_logic;
              input    : in std_logic;
              output   : out std_logic
              );
    end component;

    component parallel_to_serial is
        generic (PORT_NUM : integer
             );
        port(i_clk      : in  std_logic; -- clock
             i_data     : in  std_logic_vector(PORT_NUM-1 downto 0); -- input data
             i_rst      : in  std_logic; -- reset
             i_en       : in  std_logic; -- input enable - load input
             o_transf   : out std_logic; -- data transfer in progress (1), done (0)
             o_data     : out std_logic -- serial data
              );
    end component;

    component serial_to_parallel is
        generic (PORT_NUM : integer
                 );
        port(i_clk         : in  std_logic; -- main clock
             i_rst         : in  std_logic; -- reset pin
             i_serial_data : in  std_logic; -- serial data input
             i_enable      : in  std_logic; -- data enable signal (incoming)
             o_data_valid  : out std_logic; -- data valid signal (converting finished)
             o_parallel    : out std_logic_vector(PORT_NUM-1 downto 0) -- parallel data output
             ); 
    end component;

    component segment_display_data is
        generic (PORT_NUM    : integer;
                 SEGMENT_NUM : integer
                 );
        port (i_data  : in std_logic_vector(PORT_NUM-1 downto 0);
              o_disp1 : out std_logic_vector(SEGMENT_NUM-1 downto 0);
              o_disp2 : out std_logic_vector(SEGMENT_NUM-1 downto 0);
              o_disp3 : out std_logic_vector(SEGMENT_NUM-1 downto 0)
              );
    end component;

    signal enable      : std_logic;
    signal transfer    : std_logic;
    signal out_serial  : std_logic;
    signal rst_dbc     : std_logic;
    signal rst_ndbc    : std_logic;

    signal data_parallel : std_logic_vector(INPUT_PORTS-1 downto 0);

    begin

    rst_ndbc <= NOT i_rst;

    DBC: debounce
         generic map (17)
         port map (CLOCK_50 => i_Clk,
                   input => rst_ndbc,
                   output => rst_dbc);

    U3: parallel_to_serial
        generic map (PORT_NUM => INPUT_PORTS)
        port map (i_clk => i_Clk,
                  i_data => i_parallel,
                  i_rst => rst_dbc,
                  i_en => enable,
                  o_transf => transfer,
                  o_data => o_serial);
                  
                  
    U4: serial_to_parallel
        generic map (PORT_NUM => INPUT_PORTS)
        port map (i_clk => i_Clk,
                  i_rst => rst_dbc,
                  i_serial_data => i_serial,
                  i_enable => transfer,
                  o_data_valid => enable,
                  o_parallel => data_parallel);
                  
    S1: segment_display_data
        generic map (PORT_NUM => INPUT_PORTS,
                     SEGMENT_NUM => SEGMENT_NUM)
        port map (i_data => data_parallel,
                  o_disp1 => o_segment1,
                  o_disp2 => o_segment2,
                  o_disp3 => o_segment3);

end behavioral;