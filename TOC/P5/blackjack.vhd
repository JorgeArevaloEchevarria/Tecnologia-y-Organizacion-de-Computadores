library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity blackjack is
	port (rst, clk, inicio, jugar, plantarse: in std_logic;
		Pierdo: out std_logic;
		Puntos: out std_logic_vector(5 downto 0);
		carta: out std_logic_vector (6 downto 0);
		control: out std_logic_vector (2 downto 0)); -- esto solo para imple
		
end blackjack;

architecture Behavioral of blackjack is

component rams 
generic (M: natural:=6; N: natural:=4);
port (clk: in std_logic; 
			we: in std_logic; 
			addr: in std_logic_vector(M-1 downto 0);
			di: in std_logic_vector(N-1 downto 0);
			do: out std_logic_vector(N-1 downto 0));
end component rams;

component contador
	port (clk, reset, count: in std_logic;
			output: out std_logic_vector (5 downto 0));
end component contador;

component conv_7seg
	port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
          display : out  STD_LOGIC_VECTOR (6 downto 0));
end component conv_7seg;

--Impelemacion
component divisor is
port (rst, clk_entrada: in STD_LOGIC;
clk_salida: out STD_LOGIC);
end component;

type estados is (init, inicializa_puntos, pido_carta, guardo_carta, espera1, actualizo_puntos, espera2, pierdo_partida, espera3);
signal estado_act	, estado_sig : estados;
signal do_ram :std_logic_vector(3 downto 0);
signal Rdir, aux_Rdir, Rpuntos, aux_Rpuntos, counter_out :std_logic_vector(5 downto 0);
signal clk_1Hz, rst_aux: std_logic;
signal we_ram, load, jugar_aux, plantarse_aux: std_logic;

begin
CONTA: contador port map (clk_1Hz, rst, '1', counter_out);
RAM: rams generic map(6,4) port map (clk_1Hz, we_ram, Rdir , "0000", do_ram);
--Implementacion
CONVER: conv_7seg port map (do_ram, carta);
Nuevo_reloj: divisor port map (rst, clk, clk_1Hz);
--Simulacion
--clk_1Hz <= clk;

sincrono: process(clk_1Hz, rst)
	begin
	if rst='1' then
		estado_act <= init;
	elsif clk_1Hz'event and clk_1Hz = '1' then
		estado_act <= estado_sig;
	end if;
end process sincrono;
	
SYNC_REG: process (clk_1Hz, rst, estado_act)
	begin
	
	Puntos <= Rpuntos;
	--Simulacion
	--carta <= "000" & do_ram;
	if rst = '1' then
		Rpuntos <= (others =>'0');
		Rdir <= (others =>'0');
	elsif clk_1Hz'event and clk_1Hz ='1' then
		if estado_act = inicializa_puntos then
			Rpuntos <= aux_Rpuntos;
		elsif estado_act = actualizo_puntos then
			Rpuntos <= aux_Rpuntos;
		elsif estado_act = pido_carta then
			Rdir <= aux_Rdir;
		end if;
	end if;
end process SYNC_REG;

cambio_estados: process(estado_act, inicio, Rdir, Rpuntos, jugar_aux , plantarse_aux)
	begin
	
	case estado_act is
		when init =>
			if inicio = '1' then
				estado_sig <= inicializa_puntos;
			else
				estado_sig <= init;
			end if;
			
		when inicializa_puntos =>
			if jugar_aux = '1'  then
				estado_sig <= pido_carta;
			else
				estado_sig <= inicializa_puntos;
			end if;
			
		when pido_carta =>
				estado_sig <= guardo_carta;
				
		when guardo_carta =>
				estado_sig <= espera1;
				
		when espera1 =>
			if do_ram = "0000" then
				estado_sig <= pido_carta;
			else
				estado_sig <= actualizo_puntos;
			end if;
			
		when actualizo_puntos =>
				estado_sig <= espera2;
				
		when espera2 =>
			if Rpuntos > 21  then
				estado_sig <= pierdo_partida;
			else 
				estado_sig <= espera3;
			end if;
			
		when pierdo_partida => 
				if inicio = '1' then
					estado_sig <= init;
				else 
					estado_sig <= pierdo_partida;
				end if;
				
		when espera3 =>
			if plantarse_aux = '1'  then
				estado_sig <= init;
			else
				if jugar_aux = '1'  then
					estado_sig <= pido_carta;
				elsif jugar_aux = '0' then
					estado_sig <= espera3;
				end if;
			end if;
				
					
	end case;
end process cambio_estados;

COMB: process(clk_1Hz, rst, estado_act, Rdir, Rpuntos)
	begin
		--Implementacion
		jugar_aux <= not(jugar);
		plantarse_aux <= not(plantarse);
		--Simulacion
		--jugar_aux <= jugar;
		--plantarse_aux <= plantarse;
		
		we_ram <= '0';
		Pierdo <= '0';
		aux_Rpuntos <= (others=>'0');
		aux_Rdir <= (others=>'0');
		control <= "000"; -- solo para imple
	
	case estado_act is
		when init =>
			
			
		when inicializa_puntos =>
			
			
		when pido_carta =>
			aux_Rdir <=	counter_out;	
		when guardo_carta =>
			
		when espera1 =>
			
			
		when actualizo_puntos =>
				we_ram <= '1';
				aux_Rpuntos <= Rpuntos + do_ram;
		when espera2 =>
		
			
		when pierdo_partida => 
				Pierdo <= '1';	
		when espera3 =>
		
	end case;				
end process COMB;
end Behavioral;