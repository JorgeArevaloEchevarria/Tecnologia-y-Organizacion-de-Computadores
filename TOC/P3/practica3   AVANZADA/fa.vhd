library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity full_add_1 is
 port(c_i, x, y: in std_logic;
		s, g, p, cout : out std_logic);
end full_add_1;

architecture Behavioral of full_add_1 is

begin

s <= (x xor y) xor c_i;
g <= (x and y);
p <= (x xor y);
cout <= (x and y) or ((x xor y) and c_i);

end Behavioral;