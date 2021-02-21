library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rams is
	port (clk,wea: in std_logic;
	      addra: in std_logic_vector (6 downto 0);
		   dina: in std_logic_vector (3 downto 0);
			ena: in std_logic;
		   douta: out std_logic_vector (3 downto 0));
end rams;

architecture circuito  of rams is
    type ram_type is array (0 to 127) of std_logic_vector (3 downto 0);
    signal RAM : ram_type:= (X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",
	 X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",
	 X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",
	 X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",
	 X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",
	 X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",
	 X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",
	 X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0",X"0");

	begin
puerto: process (clk)
    begin
        if rising_edge(clk) then
            if wea = '1' then
               RAM(conv_integer(addra)) <= dina;
            end if;
            douta <= RAM(conv_integer(addra));
        end if;
    end process puerto;
end circuito;