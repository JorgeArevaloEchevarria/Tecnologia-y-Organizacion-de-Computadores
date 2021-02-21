library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
	port (clk, reset, ce: in std_logic;
			din: in std_logic_vector (6 downto 0);
			dout: out std_logic_vector (6 downto 0));
end contador;

architecture Behavioral of contador is

signal aux_dout: std_logic_vector(6 downto 0);

begin

	dout <= aux_dout;
process(clk,reset,ce)

begin
	if reset ='1' then
		aux_dout <= (others => '0');
	elsif clk'event and clk = '1' and ce = '1' then 
		if (aux_dout < "1111111") then
			aux_dout <= aux_dout + 1;
		else
			aux_dout <= (others => '0');
		end if;
	end if; 
end process;
end Behavioral;