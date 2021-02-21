----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:30 10/23/2014 
-- Design Name: 
-- Module Name:    reflejo - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reflejo is
	port(clk,rst, boton, switch: in std_logic;
	luces: out std_logic_vector(3 downto 0);
	cuenta: out std_logic_vector (2 downto 0));
	
end reflejo;

architecture Behavioral of reflejo is
	type ESTADOS is (espera,decide, ilumina, rapido, LED_rapido, medio, LED_medio, lento, LED_lento, error, LED_error);
	signal estado, estado_sig: ESTADOS;
	signal aux: std_logic_vector (2 downto 0);
	signal clk_1hz: std_logic;
	--descomentar para implementacion
	component divisor is
	port( rst,clk_entrada: in std_logic;
			clk_salida: out std_logic);
			end component;
	
	begin
	cuenta<=aux;
	--descomentar para implementacion
	nuevo_reloj:divisor port map(rst, clk, clk_1hz);
	
	--comentar para implementacion
	--clk_1h< <= clk;
	
sincrono: process (clk_1hz,rst,aux)

	begin
		if rst='1' then
			aux<= "000";
			estado <= espera;
		elsif clk_1hz 'event and clk_1hz ='1' then
				aux<= aux+1;
				estado <= estado_sig;
		
		end if;
	end process sincrono;
	
comb: process (estado, boton, switch,aux)
	begin
	 luces <= "0000";
	 estado_sig <= espera;
	 
		 case estado is
			when espera =>
				estado_sig <= decide;
				when decide =>
					if aux= "111" then
					 estado_sig <= ilumina;
					else estado_sig <= decide;
					end if;
			when ilumina =>
				estado_sig <= rapido;
				luces <="1000";
			when rapido => 
				if boton = '0' then
				 estado_sig <= LED_rapido;
				elsif boton= '1' then
					estado_sig <= medio;
				end if;
			when medio =>
				if boton = '0' then
				 estado_sig <= LED_medio;
				elsif boton = '1' then
				 estado_sig <= lento;
				 end if;
			when lento => 
				if boton = '0' then 
				 estado_sig <= LED_lento;
				elsif boton='1' then
				 estado_sig <= error;
				 end if;
			when error =>
				estado_sig <= LED_error;
			when LED_rapido =>
				
					if switch = '1' then
					estado_sig <= espera;
					luces<="0000";
					elsif switch= '0' then
					estado_sig<= estado;
					luces <= "0110";
					end if;
				 
			when LED_medio =>
				
					if switch ='1' then 
					estado_sig<= espera;
					luces<="0000";
					elsif switch='0' then 
					estado_sig<= estado;
					luces <="0101";
					end if;
					
			when LED_lento =>
				
					 if switch='1' then
					 estado_sig<= espera;
					 luces<="0000";
					 elsif switch='0' then
					 estado_sig<= estado;
					 luces <="0100";
					 end if;
					 
			when LED_error=>
					if switch='1' then
					estado_sig<= espera;
					luces<="0000";
					elsif switch ='0' then
					estado_sig<= estado;
					luces<="0011";
					end if;
					
			end case;
			end process comb;
			end Behavioral;
