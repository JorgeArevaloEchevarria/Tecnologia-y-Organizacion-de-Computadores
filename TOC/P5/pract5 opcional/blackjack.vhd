library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity blackjack is
	port (rst, clk, inicio, jugar, plantarse: in std_logic;
		Pierdo: out std_logic;
		Puntos: out std_logic_vector(5 downto 0);
		carta: out std_logic_vector (6 downto 0));	
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

type estados is (init, inicializa_puntos, pido_carta, guardo_carta, espera1, as1, final, actualizo_puntos, espera2, pierdo_partida, espera3);
signal estado_act	, estado_sig : estados;
signal do_ram :std_logic_vector(3 downto 0);
signal Rdir, aux_Rdir, Rpuntos, aux_Rpuntos, counter_out :std_logic_vector(5 downto 0);
signal we_ram, load, clk_1Hz, jugar_aux, plantarse_aux, as, aux_as: std_logic;

begin
CONTA: contador port map (clk_1Hz, rst, '1', counter_out);
RAM: rams generic map(6,4) port map (clk_1Hz, we_ram, Rdir , "0000", do_ram);

clk_1Hz <= clk;
Puntos <= Rpuntos;
carta <= "000" & do_ram;

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
	
	if rst = '1' then
		Rpuntos <= (others =>'0');
		Rdir <= (others =>'0');
		as<='0';
	elsif clk_1Hz'event and clk_1Hz ='1' then
		if estado_act = inicializa_puntos then
			Rpuntos <= aux_Rpuntos;
		elsif estado_act = as1 then
			Rpuntos <= aux_Rpuntos;
			as<=aux_as;
		elsif estado_act = actualizo_puntos then
			Rpuntos <= aux_Rpuntos;
		elsif estado_act = final then
			Rpuntos <= aux_Rpuntos;
			as <= aux_as;
		elsif estado_act = pido_carta then
			Rdir <= aux_Rdir;
		end if;
	end if;
end process SYNC_REG;

cambio_estados: process(estado_act, inicio, Rdir, Rpuntos, jugar , plantarse, as)
	begin
	case estado_act is
		when init =>
			if inicio = '1' then
				estado_sig <= inicializa_puntos;
			else
				estado_sig <= init;
			end if;
			
		when inicializa_puntos =>
			if jugar = '1'  then
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
			elsif do_ram = "0001" and as = '0' then
				estado_sig <= as1;
			else
				estado_sig <= actualizo_puntos;
			end if;
		when as1 =>
			estado_sig <= actualizo_puntos;
			
		when actualizo_puntos =>
				estado_sig <= espera2;
		when espera2 =>
			if Rpuntos > 21  then
				if as = '0' then 
					estado_sig <= pierdo_partida;
				else 
					estado_sig <= final;
				end if;
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
			if plantarse = '1'  then
				estado_sig <= init;
			else
				if jugar = '1'  then
					estado_sig <= pido_carta;
				elsif jugar = '0' then
					estado_sig <= espera3;
				end if;
			end if;
		when final =>
			estado_sig <= espera2;
					
	end case;
end process cambio_estados;

COMB: process(clk_1Hz, rst, estado_act, Rdir, Rpuntos)
	begin
		load <= '0';
		we_ram <= '0';
		Pierdo <= '0';
		aux_Rpuntos <= (others=>'0');
		aux_Rdir <= (others=>'0');
		aux_as <= '0';
		
	case estado_act is
		when init =>
			
		when inicializa_puntos =>
						
		when pido_carta =>
			aux_Rdir <=	counter_out;	
		when guardo_carta =>
			
		when espera1 =>
		
		when as1 =>
			aux_Rpuntos <= Rpuntos + "1010";
			aux_as <= '1';
		when actualizo_puntos =>
			we_ram <= '1';
			aux_Rpuntos <= Rpuntos + do_ram;
				
		when espera2 =>
	
		when pierdo_partida => 
			Pierdo <= '1';
			
		when espera3 =>
		
		when final =>
			aux_Rpuntos <= Rpuntos - "1010";
			aux_as <= '0';
			
	end case;				
end process COMB;
end Behavioral;