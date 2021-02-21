library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reflejo is
	port(clk,rst,boton, switch: in std_logic;
	luces: out std_logic_vector(3 downto 0));
	
end reflejo;

architecture Behavioral of reflejo is
	type ESTADOS is (espera, ilumina, rapido, LED_rapido, medio, LED_medio, lento, LED_lento, error, LED_error);
	signal estado, estado_sig: ESTADOS;
	
	begin
	
sincrono: process (clk,rst)
	begin
		if rst='1' then
			estado <= espera;
		elsif clk 'event and clk ='1' then
			estado <= estado_sig;
		end if;
	end process sincrono;
	
comb: process (estado, boton, switch)
	begin
	 luces <= "0000";
	 estado_sig <= espera;
	 
		 case estado is
			when espera =>
				estado_sig <= ilumina;
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
