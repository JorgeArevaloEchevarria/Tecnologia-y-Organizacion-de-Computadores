----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:53:44 01/13/2015 
-- Design Name: 
-- Module Name:    asm - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity asm is
port (clk: in std_logic;
	rst: in std_logic;
	ini: in std_logic;
	clave: in std_logic_vector (3 downto 0);
	dir: out std_logic_vector (6 downto 0);
	fin, error: out std_logic );
end asm;

architecture Behavioral of asm is

component rams 
	port (clk,wea: in std_logic;
	      addra: in std_logic_vector (6 downto 0);
		   dina: in std_logic_vector (3 downto 0);
			ena: in std_logic;
		   douta: out std_logic_vector (3 downto 0));
end component rams;

component cont 
	port (clk, reset, ce: in std_logic;
			din: in std_logic_vector (6 downto 0);
			dout: out std_logic_vector (6 downto 0));
end component cont;

type estados is (init, dar_clave, espera1, sumar_i, ver_dir, ver_error, espera2);
signal estado_act, estado_sig : estados;
signal i,j: std_logic_vector (6 downto 0);
signal aux_clave: std_logic_vector (3 downto 0);
signal ce_aux: std_logic;
signal clk_1Hz: std_logic;
signal din_aux,aux_dir: std_logic_vector (6 downto 0);
signal counter_out: std_logic_vector(6 downto 0);

begin
CONTADOR: cont port map (clk_1Hz, rst, ce_aux, din_aux, counter_out);
--RAM: rams port map (clk_1Hz, we_ram, counter_out, aux_clave, en_ram, dout_ram);

sincrono: process(clk_1Hz, rst)
	begin
	if rst='1' then
		estado_act <= init;
	elsif clk_1Hz'event and clk_1Hz = '1' then
		estado_act <= estado_sig;
	end if;
end process sincrono;

cambio_estados: process(estado_act,ini,aux_clave,i,j)
	begin
	
		case estado_act is
			when init =>
				if ini = '0' then
					estado_sig <= init;
				else
					estado_sig <= dar_clave;
				end if;
			
			when dar_clave =>
					estado_sig <= espera1;
		
			when espera1 =>
					if i<j then
						if aux_clave = mem(i) then
							estado_sig <= ver_dir;
						else
							estado_sig <= sumar_i;
						end if;
					else	
						estado_sig <= ver_error;
					end if;	
			
			when ver_error =>	
					estado_sig <= espera2;
					
			when ver_dir =>
					estado_sig <= espera2;
					
			when espera2 =>
					 if ini = '1' then	
						estado_sig <= dar_clave;
					 else
						estado_sig <= espera2;	
					 end if;	
			
			when sumar_i =>
					estado_sig <= espera1;
		end case;
end process cambio_estados;		

COMB: process(rst,clk_1Hz,clave,j,i)
	begin
	
	error <= '0';
	fin <= '0';
	
	
	case  estado_act is
	
		when init =>
			j <= "0000000";
	
		when dar_clave =>
			i<= "0000000";
			aux_dir <= "0000000";
			
		when espera1 =>
				--state en blancaso
				
		when sumar_i =>
				i <= i+1;
		
		when ver_error =>
				error <= '1';
				fin <= '1';
				j<= j+1;
				mem(i) <= aux_clave;
				
		when ver_dir =>
				aux_dir <= i;
				fin <= '1';
				
		when espera2 =>
				--state en blanquito
	
	end case;

end process COMB;	
end Behavioral;
