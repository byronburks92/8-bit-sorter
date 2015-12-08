-- Project EE4620
-- Created by: 
-- Byron Burkes
-- Vince Haenni
-- Theodore Hood
-- Alexander Kinkade


------------------------------------------------------------------------------
-- Input Clock   Input Freq (MHz)   Input Jitter (UI)
------------------------------------------------------------------------------
-- primary         200.000            0.010

library ieee,unisim;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity clk_synth is
port
 (-- Clock in ports
  CLK_IN1_P         : in     std_logic;
  CLK_IN1_N         : in     std_logic;
  -- Clock out ports
  CLK_OUT0          : out    std_logic;   -- 10 MHz
  -- Status and control signals
  LOCKED            : out    std_logic
 );
end clk_synth;

architecture xilinx of clk_synth is
  -- Input clock buffering / unused connectors
  signal clkin1      : std_logic;
  -- Output clock buffering / unused connectors
  signal clkfbout         : std_logic;
  signal clkfbout_buf     : std_logic;
  signal clkfboutb_unused : std_logic;
  signal clkout0          : std_logic;    -- 10 MHz
  signal clkout0b_unused  : std_logic;
  signal clkout1_unused   : std_logic; 
  signal clkout1b_unused  : std_logic;
  signal clkout2_unused   : std_logic;
  signal clkout2b_unused  : std_logic;
  signal clkout3_unused   : std_logic;
  signal clkout3b_unused  : std_logic;
  signal clkout4_unused   : std_logic;
  signal clkout5_unused   : std_logic;
  signal clkout6_unused   : std_logic;
  -- Dynamic programming unused signals
  signal do_unused        : std_logic_vector(15 downto 0);
  signal drdy_unused      : std_logic;
  -- Dynamic phase shift unused signals
  signal psdone_unused    : std_logic;
  -- Unused status signals
  signal clkfbstopped_unused : std_logic;
  signal clkinstopped_unused : std_logic;
begin


  -- Input buffering
  --------------------------------------
  clkin1_buf : IBUFGDS
  port map
   (O  => clkin1,
    I  => CLK_IN1_P,
    IB => CLK_IN1_N);

  -- Output buffering
  -------------------------------------
  clkf_buf : BUFG
  port map
   (O => clkfbout_buf,
    I => clkfbout);


  clkout1_buf0 : BUFG
  port map
   (O   => CLK_OUT0,
    I   => clkout0);

   MMCM_ADV_inst : MMCM_ADV
   generic map (
      BANDWIDTH => "OPTIMIZED",      -- Jitter programming ("HIGH","LOW","OPTIMIZED")
      CLKFBOUT_MULT_F => 40.0,        -- Multiply value for all CLKOUT (5.0-64.0).
      CLKFBOUT_PHASE => 0.0,         -- Phase offset in degrees of CLKFB (0.00-360.00).
      -- CLKIN_PERIOD: Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      CLKIN1_PERIOD => 5.0,          -- 5 ns => 200 MHz
      CLKIN2_PERIOD => 0.0,
      CLKOUT0_DIVIDE_F => 80.0,       -- Divide amount for CLKOUT0 (1.000-128.000).
      -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for CLKOUT outputs (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      CLKOUT1_DUTY_CYCLE => 0.5,
      CLKOUT2_DUTY_CYCLE => 0.5,
      CLKOUT3_DUTY_CYCLE => 0.5,
      CLKOUT4_DUTY_CYCLE => 0.5,
      CLKOUT5_DUTY_CYCLE => 0.5,
      CLKOUT6_DUTY_CYCLE => 0.5,
      -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for CLKOUT outputs (-360.000-360.000).
      CLKOUT0_PHASE => 0.0,
      CLKOUT1_PHASE => 0.0,
      CLKOUT2_PHASE => 0.0,
      CLKOUT3_PHASE => 0.0,
      CLKOUT4_PHASE => 0.0,
      CLKOUT5_PHASE => 0.0,
      CLKOUT6_PHASE => 0.0,
      -- CLKOUT1_DIVIDE - CLKOUT6_DIVIDE: Divide amount for CLKOUT (1-128)
      CLKOUT1_DIVIDE => 1,
      CLKOUT2_DIVIDE => 1,
      CLKOUT3_DIVIDE => 1,
      CLKOUT4_DIVIDE => 1,
      CLKOUT5_DIVIDE => 1,
      CLKOUT6_DIVIDE => 1,
      CLKOUT4_CASCADE => FALSE,      -- Cascase CLKOUT4 counter with CLKOUT6 (TRUE/FALSE)
      CLOCK_HOLD => FALSE,           -- Hold VCO Frequency (TRUE/FALSE)
      COMPENSATION => "ZHOLD",       -- "ZHOLD", "INTERNAL", "EXTERNAL", "CASCADE" or "BUF_IN" 
      DIVCLK_DIVIDE => 10,            -- Master division value (1-80)
      -- REF_JITTER: Reference input jitter in UI (0.000-0.999).
      REF_JITTER1 => 0.010,   -- 0.0,
      REF_JITTER2 => 0.0,
      STARTUP_WAIT => FALSE,         -- Not supported. Must be set to FALSE.
      -- USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
      CLKFBOUT_USE_FINE_PS => FALSE,
      CLKOUT0_USE_FINE_PS => FALSE,
      CLKOUT1_USE_FINE_PS => FALSE,
      CLKOUT2_USE_FINE_PS => FALSE,
      CLKOUT3_USE_FINE_PS => FALSE,
      CLKOUT4_USE_FINE_PS => FALSE,
      CLKOUT5_USE_FINE_PS => FALSE,
      CLKOUT6_USE_FINE_PS => FALSE 
   )
   port map (
      -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
      CLKOUT0 => CLKOUT0,           -- 1-bit output: CLKOUT0 output      -- 10 MHz = 1000 * 40 /(5 * 10) / 80
      CLKOUT0B => CLKOUT0B_unused,         -- 1-bit output: Inverted CLKOUT0 output
      CLKOUT1 => CLKOUT1_unused,           -- 1-bit output: CLKOUT1 output      -- 160 MHz = 1000 * 40 /(5 * 10) / 5
      CLKOUT1B => CLKOUT1B_unused,         -- 1-bit output: Inverted CLKOUT1 output
      CLKOUT2 => CLKOUT2_unused,           -- 1-bit output: CLKOUT2 output
      CLKOUT2B => CLKOUT2B_unused,         -- 1-bit output: Inverted CLKOUT2 output
      CLKOUT3 => CLKOUT3_unused,           -- 1-bit output: CLKOUT3 output
      CLKOUT3B => CLKOUT3B_unused,         -- 1-bit output: Inverted CLKOUT3 output
      CLKOUT4 => CLKOUT4_unused,           -- 1-bit output: CLKOUT4 output
      CLKOUT5 => CLKOUT5_unused,           -- 1-bit output: CLKOUT5 output
      CLKOUT6 => CLKOUT6_unused,           -- 1-bit output: CLKOUT6 output
      -- DRP Ports: 16-bit (each) output: Dynamic reconfigration ports
      DO => DO_unused,                     -- 16-bit output: DRP data output
      DRDY => DRDY_unused,                 -- 1-bit output: DRP ready output
      -- Dynamic Phase Shift Ports: 1-bit (each) output: Ports used for dynamic phase shifting of the outputs
      PSDONE => PSDONE_unused,             -- 1-bit output: Phase shift done output
      -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
      CLKFBOUT => CLKFBOUT,         -- 1-bit output: Feedback clock output
      CLKFBOUTB => CLKFBOUTB_unused,       -- 1-bit output: Inverted CLKFBOUT
      -- Status Ports: 1-bit (each) output: MMCM status ports
      CLKFBSTOPPED => CLKFBSTOPPED_unused, -- 1-bit output: Feedback clock stopped output
      CLKINSTOPPED => CLKINSTOPPED_unused, -- 1-bit output: Input clock stopped output
      LOCKED => LOCKED,             -- 1-bit output: LOCK output
      -- Clock Inputs: 1-bit (each) input: Clock inputs
      CLKIN1 => CLKIN1,             -- 1-bit input: Primary clock input
      CLKIN2 => '0',             -- 1-bit input: Secondary clock input
      -- Control Ports: 1-bit (each) input: MMCM control ports
      CLKINSEL => '1', -- CLKINSEL,         -- 1-bit input: Clock select input
      PWRDWN => '0', -- PWRDWN,             -- 1-bit input: Power-down input
      RST => '0', -- RST,                   -- active high 1-bit input: Reset input
      -- DRP Ports: 7-bit (each) input: Dynamic reconfigration ports
      DADDR => (others => '0'), -- DADDR,               -- 7-bit input: DRP adrress input
      DCLK => '0', -- DCLK,                 -- 1-bit input: DRP clock input
      DEN => '0', -- DEN,                   -- 1-bit input: DRP enable input
      DI => (others => '0'), -- DI,                     -- 16-bit input: DRP data input
      DWE => '0', -- DWE,                   -- 1-bit input: DRP write enable input
      -- Dynamic Phase Shift Ports: 1-bit (each) input: Ports used for dynamic phase shifting of the outputs
      PSCLK => '0', -- PSCLK,               -- 1-bit input: Phase shift clock input
      PSEN => '0', -- PSEN,                 -- 1-bit input: Phase shift enable input
      PSINCDEC => '0', -- PSINCDEC,         -- 1-bit input: Phase shift increment/decrement input
      -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
      CLKFBIN => CLKFBOUT_BUF            -- 1-bit input: Feedback clock input
   );

end xilinx;



-- writes DATA value to ADDR LCD position
-----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

-----------------------------------------------------------------------------
entity disp_control is
generic (
  T_scale    : integer := 7);   -- increase if display not stable 
port (
  CLK        : in std_logic;    -- assumed to be 10 MHz
  R          : in std_logic; 
  DATA       : in std_logic_vector(7 downto 0);   
  ADDR       : in std_logic_vector(7 downto 0);   
  
  --lcd display port
  LCD_DB4_LS  :   out std_logic; 
  LCD_DB5_LS  :   out std_logic;
  LCD_DB6_LS  :   out std_logic;
  LCD_DB7_LS  :   out std_logic;
  LCD_E_LS    :   out std_logic;
  LCD_RS_LS   :   out std_logic;
  LCD_RW_LS   :   out std_logic);
end entity;

-----------------------------------------------------------------------------
architecture behav of disp_control is
----------------------------------------------------------------------------
-- Signal Declarations
----------------------------------------------------------------------------
  type state_type is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,
  S16,S17,S18,S19,S20,S21,S22,S23,S24,S25,S26,S27,S28,S29,S30,S31,S32,S33,S34,
  S35,S36,S37,S38,S39,S40,S41,S42,S43,S44,S45,S46,S47,S48,S49,S50,S51,S52);
  signal NS, CS: state_type;
  signal LCD_COUNT: std_logic_vector(19 downto 0); 
  signal C_LCD_DATA: std_logic_vector(3 downto 0);
  signal LCD_CLK_R:std_logic;
  signal ADDRR,DATAR: std_logic_vector(7 downto 0);

----------------------------------------------------------------------------  
begin  
----------------------------------------------------------------------------
-- LCD control
----------------------------------------------------------------------------
  LCD_DB4_LS  <= C_LCD_DATA(0);
  LCD_DB5_LS  <= C_LCD_DATA(1);
  LCD_DB6_LS  <= C_LCD_DATA(2);
  LCD_DB7_LS  <= C_LCD_DATA(3);  

  STATE_CONTROL: process(CLK,R)  -- clock and reset
  begin
    if CLK'event and CLK='1' then
      if R = '1' then
        CS <= S0
        -- pragma synthesis_off
        after 10 ps
        -- pragma synthesis_on
        ;
      else
        CS <= NS
        -- pragma synthesis_off
        after 10 ps
        -- pragma synthesis_on
        ;
      end if;
    end if;
  end process;

  LCD_CLK : process(CLK,LCD_CLK_R)
    variable one:std_logic_vector(19 downto 0):="00000000000000000001";
  begin
    one := "00000000000000000001";
    if CLK'event and CLK='1' then
      if LCD_CLK_R = '1' then
        LCD_COUNT <= (others => '0');		
      else
        LCD_COUNT <= LCD_COUNT + one;
      end if;
    end if;
  end process;

  RUN_LCD: process(CS,LCD_COUNT,ADDR,ADDRR,DATA,DATAR)
  begin
    case CS is
	 
       when S0 =>    -- reset state 
         LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
         NS <= S1;
			
       when S1 =>    -- wait more than 15 ms
         if LCD_COUNT(19) = '1' then              -- 26 ms > 15 ms
           NS <= S2;
           LCD_CLK_R <= '1';
         else
           NS <= S1; 
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
       when S2 =>    -- apply 0 0 0011 for at least 220 ns
         if LCD_COUNT(2*T_scale) = '1' then      -- 14 cycles > 12 cycles
           NS <= S3;
           LCD_CLK_R <= '1';
         else
           NS <= S2;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
			
       when S3 =>    -- wait more than 4.1 ms
         if LCD_COUNT(15) = '1' then             -- 6 ms > 4.1 ms
           NS <= S4;
           LCD_CLK_R <= '1';
         else
           NS <= S3;  
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
       when S4 =>     -- apply  0 0 011 for at least 220 ns
         if LCD_COUNT(2*T_scale) = '1' then      -- 14 cycles > 12 cycles
           NS <= S5;
           LCD_CLK_R <= '1';
         else
           NS <= S4;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
			
       when S5 =>      -- wait more than 100 us
         if LCD_COUNT(2*T_scale) = '1' then       -- 14 cycles => 102 us > 100 us
           NS <= S6;
           LCD_CLK_R <= '1';
         else
           NS <= S5;  
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
       when S6 =>     -- apply 0 0 0011
         if LCD_COUNT(2*T_scale) = '1' then       -- 16 cycles  > 12 cycles
           NS <= S7;
           LCD_CLK_R <= '1';
         else
           NS <= S6;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
			
       when S7 =>     -- wait for 40 us
         if LCD_COUNT(12) = '1' then      -- 8 => 51 us      > 40 us
           NS <= S8;
           LCD_CLK_R <= '1';
         else
           NS <= S7;  
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
       when S8 =>      -- 
         if LCD_COUNT(2*T_scale) = '1' then       -- 16 cycles  > 12 cycles
           NS <= S9;
           LCD_CLK_R <= '1';
         else
           NS <= S8;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0011";
           LCD_CLK_R <= '0';
         end if;
			
       when S9 =>      -- puts it in 4 bit mode  -- apply 0 0 0010   wait 12 cycles
         if LCD_COUNT(2*T_scale) = '1' then      -- 14 cycles > 40 us
           NS <= S10;
           LCD_CLK_R <= '1';
         else
           NS <= S9;  
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0010";
           LCD_CLK_R <= '0';
         end if;
       when S10 =>
         if LCD_COUNT(2*T_scale) = '1' then       -- 14 cycles => 800 ns 
           NS <= S11;
           LCD_CLK_R <= '1';
         else
           NS <= S10;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0010";
           LCD_CLK_R <= '0';
         end if;




       -- issue a function set command x28
       -- write x2C  -or- x28
       when S11 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S12;
           LCD_CLK_R <= '1';
         else
           NS <= S11;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0010";
           LCD_CLK_R <= '0';
         end if;
       when S12 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S13;
           LCD_CLK_R <= '1';
         else
           NS <= S12;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0010";
           LCD_CLK_R <= '0';
         end if;
       when S13 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S14;
           LCD_CLK_R <= '1';
         else
           NS <= S13;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0010";
           LCD_CLK_R <= '0';
         end if;
       when S14 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S15;
           LCD_CLK_R <= '1';
         else
           NS <= S14;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1000";
           LCD_CLK_R <= '0';
         end if;
       when S15 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S16;
           LCD_CLK_R <= '1';
         else
           NS <= S15;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1000";
           LCD_CLK_R <= '0';
         end if;
       when S16 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S17;
           LCD_CLK_R <= '1';
         else
           NS <= S16;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1000";
           LCD_CLK_R <= '0';
         end if;





       -- issue a display OFF command x08
       -- write x04
       when S17 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S18;
           LCD_CLK_R <= '1';
         else
           NS <= S17;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S18 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S19;
           LCD_CLK_R <= '1';
         else
           NS <= S18;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S19 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S20;
           LCD_CLK_R <= '1';
         else
           NS <= S19;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S20 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S21;
           LCD_CLK_R <= '1';
         else
           NS <= S20;
           --LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1100";
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1000";
           LCD_CLK_R <= '0';
         end if;
       when S21 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S22;
           LCD_CLK_R <= '1';
         else
           NS <= S21;
           --LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1100";
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1000";
           LCD_CLK_R <= '0';
         end if;
       when S22 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S23;
           LCD_CLK_R <= '1';
         else
           NS <= S22;
           --LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1100";
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1000";
           LCD_CLK_R <= '0';
         end if;





       -- issue a Clear Display 
       -- write x01       
       when S23 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S24;
           LCD_CLK_R <= '1';
         else
           NS <= S23;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S24 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S25;
           LCD_CLK_R <= '1';
         else
           NS <= S24;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S25 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S26;
           LCD_CLK_R <= '1';
         else
           NS <= S25;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S26 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S27;
           LCD_CLK_R <= '1';
         else
           NS <= S26;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0001";
           LCD_CLK_R <= '0';
         end if;
       when S27 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S28;
           LCD_CLK_R <= '1';
         else
           NS <= S27;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0001";
           LCD_CLK_R <= '0';
         end if;
       when S28 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S29;
           LCD_CLK_R <= '1';
         else
           NS <= S28;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0001";
           LCD_CLK_R <= '0';
         end if;




       -- issue a Entry Mode Set with Bit Shift Disabled x06 -or- x04
       when S29 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S30;
           LCD_CLK_R <= '1';
         else
           NS <= S29;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S30 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S31;
           LCD_CLK_R <= '1';
         else
           NS <= S30;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S31 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S32;
           LCD_CLK_R <= '1';
         else
           NS <= S31;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S32 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S33;
           LCD_CLK_R <= '1';
         else
           NS <= S32;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0110";
           LCD_CLK_R <= '0';
         end if;
       when S33 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S34;
           LCD_CLK_R <= '1';
         else
           NS <= S33;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0110";
           LCD_CLK_R <= '0';
         end if;
       when S34 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S35;
           LCD_CLK_R <= '1';
         else
           NS <= S34;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0110";
           LCD_CLK_R <= '0';
         end if;




       -- issue a DISPLAY ON   CURSOR OFF   BLINK ON  x0C
       when S35 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S36;
           LCD_CLK_R <= '1';
         else
           NS <= S35;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S36 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S37;
           LCD_CLK_R <= '1';
         else
           NS <= S36;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S37 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S38;
           LCD_CLK_R <= '1';
         else
           NS <= S37;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "0000";
           LCD_CLK_R <= '0';
         end if;
       when S38 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S39;
           LCD_CLK_R <= '1';
         else
           NS <= S38;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1100";
           LCD_CLK_R <= '0';
         end if;
       when S39 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S40;
           LCD_CLK_R <= '1';
         else
           NS <= S39;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1100";
           LCD_CLK_R <= '0';
         end if;
       when S40 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S41;
           LCD_CLK_R <= '1';
         else
           NS <= S40;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= "1100";
           LCD_CLK_R <= '0';
         end if;







       -- issue and ADDR and a WRITE to display command
       -- write DATA  to address ADDR on display   
		 
		 
		 
       -- issue a set DD RAM address   x1LSBs (for first row) -or- xCLSBs (for second Row)
       when S41 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S42;
           LCD_CLK_R <= '1';
         else
           NS <= S41;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= ADDRR(7 downto 4);
           LCD_CLK_R <= '0';
           DATAR <= DATA;
           ADDRR <= ADDR;
         end if;
       when S42 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S43;
           LCD_CLK_R <= '1';
         else
           NS <= S42;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= ADDRR(7 downto 4);
           LCD_CLK_R <= '0';
         end if;
       when S43 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S44;
           LCD_CLK_R <= '1';
         else
           NS <= S43;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= ADDRR(7 downto 4);
           LCD_CLK_R <= '0';
         end if;
       when S44 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S45;
           LCD_CLK_R <= '1';
         else
           NS <= S44;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= ADDRR(3 downto 0);
           LCD_CLK_R <= '0';
         end if;
       when S45 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S46;
           LCD_CLK_R <= '1';
         else
           NS <= S45;
           LCD_E_LS <= '1'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= ADDRR(3 downto 0);
           LCD_CLK_R <= '0';
         end if;
       when S46 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S47;
           LCD_CLK_R <= '1';
         else
           NS <= S46;
           LCD_E_LS <= '0'; LCD_RS_LS <= '0'; LCD_RW_LS <= '0'; C_LCD_DATA <= ADDRR(3 downto 0);
           LCD_CLK_R <= '0';
         end if;




       -- issue a write data command
       when S47 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S48;
           LCD_CLK_R <= '1';
         else
           NS <= S47;
           LCD_E_LS <= '0'; LCD_RS_LS <= '1'; LCD_RW_LS <= '0'; C_LCD_DATA <= DATAR(7 downto 4);
           LCD_CLK_R <= '0';
         end if;
       when S48 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S49;
           LCD_CLK_R <= '1';
         else
           NS <= S48;
           LCD_E_LS <= '1'; LCD_RS_LS <= '1'; LCD_RW_LS <= '0'; C_LCD_DATA <= DATAR(7 downto 4);
           LCD_CLK_R <= '0';
         end if;
       when S49 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S50;
           LCD_CLK_R <= '1';
         else
           NS <= S49;
           LCD_E_LS <= '0'; LCD_RS_LS <= '1'; LCD_RW_LS <= '0'; C_LCD_DATA <= DATAR(7 downto 4);
           LCD_CLK_R <= '0';
         end if;
       when S50 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S51;
           LCD_CLK_R <= '1';
         else
           NS <= S50;
           LCD_E_LS <= '0'; LCD_RS_LS <= '1'; LCD_RW_LS <= '0'; C_LCD_DATA <= DATAR(3 downto 0);
           LCD_CLK_R <= '0';
         end if;
       when S51 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S52;
           LCD_CLK_R <= '1';
         else
           NS <= S51;
           LCD_E_LS <= '1'; LCD_RS_LS <= '1'; LCD_RW_LS <= '0'; C_LCD_DATA <= DATAR(3 downto 0);
           LCD_CLK_R <= '0';
         end if;
       when S52 =>
         if LCD_COUNT(T_scale*2) = '1' then       -- 2 => 800 ns     > 40 ns
           NS <= S41;
           LCD_CLK_R <= '1';
         else
           NS <= S52;
           LCD_E_LS <= '0'; LCD_RS_LS <= '1'; LCD_RW_LS <= '0'; C_LCD_DATA <= DATAR(3 downto 0);
           LCD_CLK_R <= '0';
         end if;
    end case;
  end process;
end behav;

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------

library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity COMP_2bit1 is
        port(A1,A0,B1,B0: in std_logic;
                Z: out std_logic);
end; 

architecture BEHAV of COMP_2bit1 is
-- checks if A1,A0 is equal to B1,B0

begin

Z <= (A1 xor B1) and (A0 xor B0);

end;


library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity COMP_2bit2 is
        port(A1,A0,B1,B0: in std_logic;
                Z: out std_logic);
end; 

architecture BEHAV of COMP_2bit2 is
-- checks if A1,A0 is greater than B1,B0

begin

Z <= (A1 and not(B1)) or (A0 and not(B1) and not(B0)) or (A1 and A0 and not(B0));

end;

library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity COMP_8bit is
        port(A7,A6,A5,A4,A3,A2,A1,A0,B7,B6,B5,B4,B3,B2,B1,B0: in std_logic;
                Z: out std_logic);
end; 

architecture BEHAV of COMP_8bit is

component COMP_2bit1
    port(A1,B1,A0,B0: in std_logic;
       Z: out std_logic);
end component;

component COMP_2bit1
    port(A1,B1,A0,B0: in std_logic;
       Z: out std_logic);
end component;
-- any internal signal declarations
signal Z0int,Z1int,Z2int,stop1:std_logic;

begin
 

process
stop1 <= '0';

if not(stop1)
    G1:COMP_2bit1 port map(A1=>A7,B1=>B7,A0=>A6,B0=>B6,Z=>Z0int);
    if Z0int = '0'
        G2:COMP_2bit2 port map(A1=>A7,B1=>B7,A0=>A6,B0=>B6,Z=>Z);
        stop1 <= '1';
    end if;
end if;

if not(stop1)
    G3:COMP_2bit1 port map(A1=>A5,B1=>B5,A0=>A4,B0=>B4,Z=>Z1int);
    if Z1int = '0'
        G4:COMP_2bit2 port map(A1=>A5,B1=>B5,A0=>A4,B0=>B4,Z=>Z);
        stop1 <= '1';
    end if;
end if;

if not(stop1)
    G5:COMP_2bit1 port map(A1=>A3,B1=>B3,A0=>A2,B0=>B2,Z=>Z2int);
    if Z2int = '0'
        G6:COMP_2bit2 port map(A1=>A3,B1=>B3,A0=>A2,B0=>B2,Z=>Z);
        stop1 <= '1';
    end if;
end if;

if not(stop1)
    G7:COMP_2bit2 port map(A1=>A1,B1=>B1,A0=>A0,B0=>B0,Z=>Z);
end if;

end process;
end behav;

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;

type std_logic_2d is array (0 to 9) of std_logic_vector(7 downto 0);

entity SORTER_8bit is
        generic(N:integer:=10);
        generic(Ng:integer:=7);
        port(   X: in std_logic_2d(0 to N-1);
                Gaps: in integer(0 to Ng-1);
                Y: out std_logic_2d(0 to N-1));
end;

architecture BEHAV of SORTER_8bit is



component COMP_8bit
    port(A7,A6,A5,A4,A3,A2,A1,A0,B7,B6,B5,B4,B3,B2,B1,B0: in std_logic;
                Z: out std_logic);
end component;

signal A,B:std_logic_vector(7 downto 0);
signal Z:std_logic;

begin

  -- instantiation area
process

-- gaps = calc_gaps(N, 1.3, extra1=1)

-- num_4luts = 0

-- for k1 in range(len(gaps)):
    -- gapk = gaps[k1]
    -- for k2 in range(N - gapk):
        -- z1, n4 = comp8bit(X[k2 + gapk], X[k2])
        -- if z1 == '1':
            -- temp = X[k2]
            -- X[k2] = X[k2 + gapk]
            -- X[k2 + gapk] = temp
        -- else:
            -- pass
            
Y <= X;

for k1 in 0 to Ng-1 loop
    for k2 in 0 to N-Gaps(k1)-1 loop
        A <= Y(k2 + Gaps(k1));
        B <= Y(k2);
        G1:COMP_8bit port map(A7=>A(7),A6=>A(6),A5=>A(5),A4=>A(4),A3=>A(3),A2=>A(2),A1=>A(1),A0=>A(0),B7=>B(7),B6=>B(6),B5=>B(5),B4=>B(4),B3=>B(3),B2=>B(2),B1=>B(1),B0=>B(0),Z=>Z);
        if Z = '1'
            Y(k2) <= A;
            Y(k2 + Gaps(k1)) <= B;
        end if;
    end loop;
end loop;

end process;
end behav;


------------------------------------------------------------------------------
-- PB_N   => Displays next value
-- PB_S   => Displays first value in list
-- DIP1   => Sorts list
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
-- use unisim.vcomponents.all;

type std_logic_2d is array (0 to 9) of std_logic_vector(7 downto 0);

entity SORTER is
    generic(N:integer:=10);
    generic(Ng:integer:=7);
port(
--clk input
  SYSCLK_P        : in     std_logic;                 -- 200 MHz sys clock
  SYSCLK_N        : in     std_logic;                 -- 200 MHz sys clock
    
  --dip switch inputs
  GPIO_DIP_SW     : in    std_logic_vector(8 downto 1);  -- 8 downto 1
    
  --led outputs   
  GPIO_LED        :   out std_logic_vector(7 downto 0);   
  GPIO_LED_N      :   out std_logic;                   
  GPIO_LED_S      :   out std_logic;
  
  --lcd display port
  LCD_DB4_LS  :   out std_logic; 
  LCD_DB5_LS  :   out std_logic;
  LCD_DB6_LS  :   out std_logic;
  LCD_DB7_LS  :   out std_logic;
  LCD_E_LS    :   out std_logic;
  LCD_RS_LS   :   out std_logic;
  LCD_RW_LS   :   out std_logic;
    
  --pushbutton
  GPIO_SW_N : in std_logic;  --high when pressed  
  GPIO_SW_S : in std_logic;  --high when pressed
end;

 
architecture structural of SORTER is

component clk_synth
 port (
  -- Clock in ports
  CLK_IN1_P         : in     std_logic;  -- 200 MHz
  CLK_IN1_N         : in     std_logic;  -- 200 MHz
  -- Clock out ports
  CLK_OUT0          : out    std_logic;  -- 10 MHz
  -- Status and control signals
  LOCKED            : out    std_logic); -- led 7
end component;
component disp_control 
 port (
  CLK        : in std_logic;
  R          : in std_logic;
  DATA       : in std_logic_vector(7 downto 0);
  ADDR       : in std_logic_vector(7 downto 0);
  --lcd display port
  LCD_DB4_LS  :   out std_logic;
  LCD_DB5_LS  :   out std_logic;
  LCD_DB6_LS  :   out std_logic;
  LCD_DB7_LS  :   out std_logic;
  LCD_E_LS    :   out std_logic;
  LCD_RS_LS   :   out std_logic;
  LCD_RW_LS   :   out std_logic);
end component;
component SORTER_8bit
port(   
    X   : in std_logic_2d;
    Gaps: in integer(0 to Ng-1);
    Y   : out std_logic_2d);
end component;

   
----------------------------------------------------------------------------
-- Signal Declarations
----------------------------------------------------------------------------
  signal INDX                    : std_logic_vector(3 downto 0);
  signal INDX_COUNT              : std_logic_vector(19 downto 0);
  signal CLK                     : std_logic;   -- 10 MHz signals
  signal MMCM_LOCKED             : std_logic;   
  signal L_DATA,L_ADDR           : std_logic_vector(7 downto 0);
  signal NEXT_E,RESET_D         : std_logic;

  -- debounced push button pulse signals
  signal PB_EVENT_N,PB_EVENT_S    : std_logic;        -- PB pulse
  signal PB_DELAY_N,PB_DELAY_S   : std_logic_vector(11 downto 0);

  -- sorting data
  signal DATA       : std_logic_vector(3 downto 0);
  signal ADDR       : std_logic_vector(3 downto 0);
  
  -- unsorted list
  signal X : std_logic_2d;
  signal G : integer(0 to Ng-1);
  
  -- sorted list
  signal Y : std_logic_2d;
  
  -- current item
  
  signal CI : std_logic_vector(7 downto 0);

  type state_type is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9);
  signal NS, CS: state_type;

  NEXT_E <= PB_EVENT_N;
  RESET_D <= PB_EVENT_S;
  
  -- **initialize unsorted list X and gaps G**
  
  X(0) <= "11011110";
  X(1) <= "11101000";
  X(2) <= "11011101";
  X(3) <= "11001100";
  X(4) <= "10101000";
  X(5) <= "01000100";
  X(6) <= "01010110";
  X(7) <= "10101111";
  X(8) <= "00110101";
  X(9) <= "11110110";
  
  G(0) <= 9;
  G(1) <= 6;
  G(2) <= 4;
  G(3) <= 3;
  G(4) <= 2;
  G(5) <= 1;
  G(6) <= 1;

----------------------------------------------------------------------------
-- Component Instantiations
----------------------------------------------------------------------------
comp_SORTER_8bit : SORTER_8bit
port map(X=>X;
        Gaps=>G;
        Y=>Y);

comp_clk : clk_synth
 port map(
  CLK_IN1_P => SYSCLK_P,  -- 200 MHz 
  CLK_IN1_N => SYSCLK_N,  -- 200 MHz
  CLK_OUT0 => CLK,        --  10 MHz
  LOCKED => MMCM_LOCKED); 
comp_disp : disp_control 
 port map (CLK=>CLK,R=>RESET_D,DATA=>L_DATA,ADDR=>L_ADDR,
  LCD_DB4_LS=>LCD_DB4_LS,LCD_DB5_LS=>LCD_DB5_LS,LCD_DB6_LS=>LCD_DB6_LS,LCD_DB7_LS=>LCD_DB7_LS,
  LCD_E_LS=>LCD_E_LS,LCD_RS_LS=>LCD_RS_LS,LCD_RW_LS=>LCD_RW_LS);
  
----------------------------------------------------------------------------
-- dip switch assignments
----------------------------------------------------------------------------
  DATA(0) <= GPIO_DIP_SW(1);

----------------------------------------------------------------------------
-- led assignments 
----------------------------------------------------------------------------
  GPIO_LED(0) <= DATA(0);
  GPIO_LED_N <= GPIO_SW_N;
  GPIO_LED_S <= GPIO_SW_S;

----------------------------------------------------------------------------
-- debounced push buttons   
----------------------------------------------------------------------------
  dff_pb: process (CLK)                                                     
  begin                                                                         
    if(CLK'event and CLK = '1') then
      PB_DELAY_N(0) <= GPIO_SW_N;  -- input from board push button
      PB_DELAY_S(0) <= GPIO_SW_S;  -- input from board push button
      for I in 1 to 11 loop
        PB_DELAY_N(I) <= PB_DELAY_N(I-1);
        PB_DELAY_S(I) <= PB_DELAY_S(I-1); 
      end loop;
    end if;
  end process dff_pb;
  -- may need to add or delete delays depending on the board you are using ...
  PB_EVENT_N <= PB_DELAY_N(0) and PB_DELAY_N(1) and PB_DELAY_N(2) and PB_DELAY_N(3) and
		PB_DELAY_N(4) and PB_DELAY_N(5) and PB_DELAY_N(6) and PB_DELAY_N(7) and
		PB_DELAY_N(8) and PB_DELAY_N(9) and PB_DELAY_N(10) and
		not(PB_DELAY_N(11));
  PB_EVENT_S <= PB_DELAY_S(0) and PB_DELAY_S(1) and PB_DELAY_S(2) and PB_DELAY_S(3) and
		PB_DELAY_S(4) and PB_DELAY_S(5) and PB_DELAY_S(6) and PB_DELAY_S(7) and
		PB_DELAY_S(8) and PB_DELAY_S(9) and PB_DELAY_S(10) and
		not(PB_DELAY_S(11));
  
  

----------------------------------------------------------------------------
-- LCD DATA and ADDR
----------------------------------------------------------------------------
STATE_CONTROL: process(CLK,R)  -- clock and reset
  begin
    if CLK'event and CLK='1' then
      if R = '1' then
        CS <= S0
        -- pragma synthesis_off
        after 10 ps
        -- pragma synthesis_on
        ;
      else
        CS <= NS
        -- pragma synthesis_off
        after 10 ps
        -- pragma synthesis_on
        ;
      end if;
    end if;
  end process;
  
  
  RUN_DATA_ADDR: process(CLK,RESET_D,INDX)
  begin
    ONE := "00000000000000000001";
    L_ADDR(7 downto 4) <= "1000" ;
    if CLK'event and CLK = '1' then
      case CS is
        when S0 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(0);
          else
            -- sorted
            CI <= Y(0);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S1;
          else
            NS <= S0;
          end if;
        when S1 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(1);
          else
            -- sorted
            CI <= Y(1);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S2;
          else
            NS <= S1;
          end if;
        when S2 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(2);
          else
            -- sorted
            CI <= Y(2);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S3;
          else
            NS <= S2;
          end if;
        when S3 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(3);
          else
            -- sorted
            CI <= Y(3);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S4;
          else
            NS <= S3;
          end if;
        when S4 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(4);
          else
            -- sorted
            CI <= Y(4);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S5;
          else
            NS <= S4;
          end if;
        when S5 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(5);
          else
            -- sorted
            CI <= Y(5);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S6;
          else
            NS <= S5;
          end if;
        when S6 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(6);
          else
            -- sorted
            CI <= Y(6);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S7;
          else
            NS <= S6;
          end if;
        when S7 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(7);
          else
            -- sorted
            CI <= Y(7);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S8;
          else
            NS <= S7;
          end if;
        when S8 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(8);
          else
            -- sorted
            CI <= Y(8);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S9;
          else
            NS <= S8;
          end if;
        when S9 =>
          if DATA(0) = '0' then
            -- unsorted
            CI <= X(9);
          else
            -- sorted
            CI <= Y(9);
          end if;
          LDATA(7 downto 0) <= CI;
          L_ADDR(7 downto 0) <= "00010000";
          if RESET_D = '1' then
            NS <= S0;
          elsif NEXT_E = '1' then
            NS <= S0;
          else
            NS <= S9;
          end if;
     end case;
   end if;
  end process;
end;
