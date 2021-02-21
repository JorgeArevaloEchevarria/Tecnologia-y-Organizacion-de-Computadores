----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:58:08 10/16/2014 
-- Design Name: 
-- Module Name:    apartadoC - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Contador is
port (rst, clk, CE: in std_logic;
		cuenta: out std_logic_vector (2 downto 0));
end Contador;

architecture Behavioral of Contador is

signal cuenta_interna: std_logic_vector(2 downto 0);

begin
cuenta <= cuenta_interna;
process (rst, CE, clk, cuenta_interna)
begin
	if rst = '1' then
		cuenta_interna <= "000";
	elsif clk'event and clk ='1' then
		if CE = '1' then
			cuenta_interna <= cuenta_interna + 1;
		end if;
	end if;
end process;
end Behavioral;

