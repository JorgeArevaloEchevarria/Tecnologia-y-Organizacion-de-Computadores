library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity adder_4bits_2 is
	port (cin : in std_logic;
			op1 : in std_logic_vector(3 downto 0);
			op2 : in std_logic_vector(3 downto 0);
			add : out std_logic_vector(3 downto 0);
			G_out,P_out : out std_logic);
end adder_4bits_2;

architecture Behavioral of adder_4bits_2 is

signal g2, p2: std_logic;
signal g, p: std_logic_vector(3 downto 0);
signal c: std_logic_vector(4 downto 0);
component uaa_1_1 is 
	port (cin: in std_logic;
			g, p : in std_logic_vector(3 downto 0);
			G_out, P_out: out std_logic);
end component;

component full_add_1 is
	port(c_i, x, y: in std_logic;
		s, g, p, cout : out std_logic);
end component;

begin
c(0) <= cin;
uaa1_1: uaa_1_1 port map(cin, g, p, g2, p2);

gen0: for i in 0 to 3 generate
f0: full_add_1 port map (c(i), op1(i), op2(i), add(i), g(i), p(i), c(i+1));
end generate gen0;

G_out <= g2;
P_out <= p2;

end Behavioral;