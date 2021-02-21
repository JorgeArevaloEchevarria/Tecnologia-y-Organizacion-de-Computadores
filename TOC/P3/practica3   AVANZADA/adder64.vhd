library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder is
port (cin : in std_logic;
op1 : in std_logic_vector(63 downto 0);
op2 : in std_logic_vector(63 downto 0);
add : out std_logic_vector(63 downto 0);
cout: out std_logic);
end adder;

architecture Behavioral of adder is

signal c_i: std_logic_vector(4 downto 0);
signal p4, g4, c_out: std_logic_vector(3 downto 0);

component adder_2 is
port (cin : in std_logic;
op1 : in std_logic_vector(15 downto 0);
op2 : in std_logic_vector(15 downto 0);
add : out std_logic_vector(15 downto 0);
G_out2, P_out2 : out std_logic);
end component;


component uaa_3_1 is 
 port (cin: in std_logic;
		 G_in: in std_logic_vector(3 downto 0);
		 P_in: in std_logic_vector(3 downto 0);
		 Cout: out std_logic_vector(3 downto 0));
end component;

begin

c_i <= c_out & cin;
uaa3_1: uaa_3_1 port map(cin, g4, p4, c_out);
gen2: for i in 0 to 3 generate
f2: adder_2 port map(c_i(i), op1((i+15)+(15*i) downto i+(15*i)), op2((i+15)+(15*i) downto i+(15*i)), add((i+15)+(15*i) downto i+(15*i)), g4(i), p4(i));
end generate gen2;
cout <= c_i(4);

end Behavioral;