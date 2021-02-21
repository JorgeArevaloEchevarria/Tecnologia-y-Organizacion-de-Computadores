LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY sim_bj IS
END sim_bj;
 
ARCHITECTURE behavior OF sim_bj IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT blackjack
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         inicio : IN  std_logic;
         jugar : IN  std_logic;
         plantarse : IN  std_logic;
         pierdo : OUT  std_logic;
         puntos : OUT  std_logic_vector(5 downto 0);
         carta : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal inicio : std_logic := '0';
   signal jugar : std_logic := '0';
   signal plantarse : std_logic := '0';

 	--Outputs
   signal pierdo : std_logic;
   signal puntos : std_logic_vector(5 downto 0);
   signal carta : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: blackjack PORT MAP (
          rst => rst,
          clk => clk,
          inicio => inicio,
          jugar => jugar,
          plantarse => plantarse,
          pierdo => pierdo,
          puntos => puntos,
          carta => carta
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst<='1';
		inicio<='0';
		jugar<='0';
		plantarse<='0';
      wait for clk_period;	
		rst<='0';
		inicio<='1';
      wait for clk_period;
		inicio<='0';
		jugar<='1';
      wait for clk_period;
		jugar<='0';
		wait for clk_period*8;
		jugar<='1';
		 wait for clk_period;
		jugar<='0';
		wait for clk_period*8;
		jugar<='1';
		wait for clk_period;
		jugar<='0';
		wait for clk_period*5;
		plantarse<='1';
		wait for clk_period;
		plantarse<='0';
      wait for clk_period*4;
		inicio<='1';
		wait for clk_period;
		inicio<='0';
		jugar<='1';
		wait for clk_period;
		jugar<='0';
      wait for clk_period*5;
		jugar<='1';
		wait for clk_period;
		jugar<='0';
		wait for clk_period*6;
		jugar<='1';
		wait for clk_period;
		jugar<='0';
      wait;
   end process;

END;