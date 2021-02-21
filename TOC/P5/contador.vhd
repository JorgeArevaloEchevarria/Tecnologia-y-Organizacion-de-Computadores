library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
	port (clk, reset, count: in std_logic;
			output: out std_logic_vector (5 downto 0));
end contador;

architecture Behavioral of contador is

signal aux_output: std_logic_vector(5 downto 0);

begin

	output <= aux_output;
process(clk,reset,count)

begin

	if reset ='1' then
		aux_output <= (others => '0');
	elsif clk'event and clk = '1' and count = '1' then 
		if (aux_output < "110011") then
			aux_output <= aux_output + 1;
		else
			aux_output <= (others => '0');
		end if;
	end if; 
end process;
end Behavioral;