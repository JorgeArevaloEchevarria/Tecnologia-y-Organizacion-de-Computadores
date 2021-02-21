----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:11 10/16/2014 
-- Design Name: 
-- Module Name:    reg_paralelo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
--arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
--any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_paralelo is
port ( rst, clk_100MHz, load: in std_logic;
			EP: in std_logic_vector (3 downto 0);
			SP: out std_logic_vector (3 downto 0));
end reg_paralelo;

architecture Behavioral of reg_paralelo is

-- añadir las señales necearias
signal clk_1Hz: std_logic;

-- Descomentar para la implementacion
component divisor is
port (rst, clk_entrada: in STD_LOGIC;
clk_salida: out std_logic);
end component;

begin
-- descomplementar para la imp
Nuevo_reloj: divisor port map (rst, clk_100MHz, clk_1Hz);
--comentar para la imp
--clk_1Hz <= clk_100MHz;

-- añadimos el resto del codigo del reg paralelo
process (rst, clk_1Hz)
begin
	if rst='1' then
		SP <= "0000";
	elsif clk_1Hz'event and clk_1Hz= '1' then
		if load= '1' then
		SP<=EP;
		end if;
end if;
end process;
end Behavioral;




