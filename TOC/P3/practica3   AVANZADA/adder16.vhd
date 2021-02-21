library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_2 is
port (cin : in std_logic;
op1 : in std_logic_vector(15 downto 0);
op2 : in std_logic_vector(15 downto 0);
add : out std_logic_vector(15 downto 0);
G_out2, P_out2 : out std_logic);
end adder_2;

architecture Behavioral of adder_2 is

signal c_i: std_logic_vector(3 downto 0);
signal p3, g3: std_logic_vector(3 downto 0);
signal c_out: std_logic_vector(2 downto 0);
signal p4, g4: std_logic;

component adder_4bits_2 is
port (cin : in std_logic;
			op1 : in std_logic_vector(3 downto 0);
			op2 : in std_logic_vector(3 downto 0);
			add : out std_logic_vector(3 downto 0);
			G_out,P_out : out std_logic);
end component;

component uaa_2_1 is 
 port (cin: in std_logic;
		 g2: in std_logic_vector(3 downto 0);
		 p2: in std_logic_vector(3 downto 0);
		 c2: out std_logic_vector(2 downto 0);
		 G_out2: out std_logic;
		 P_out2: out std_logic);
end component;

begin

c_i <= c_out & cin;
uaa2_1: uaa_2_1 port map(cin, g3, p3, c_out, g4, p4);
gen1: for i in 0 to 3 generate
f1: adder_4bits_2 port map(c_i(i), op1((i+3)+(3*i) downto i+(3*i)), op2((i+3)+(3*i) downto i+(3*i)), add((i+3) + (3*i) downto i+(3*i)), g3(i), p3(i));
end generate gen1;

G_out2 <= g4;
P_out2 <= p4;

end Behavioral;

