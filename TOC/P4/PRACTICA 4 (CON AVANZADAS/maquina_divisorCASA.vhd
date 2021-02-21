library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity maquina_divisor is
	generic(n: integer:=6; m: integer:=3);
	port (clk, reset: in std_logic;
			inicio: in std_logic;
			divisor: in std_logic_vector (m-1 downto 0);
			dividendo: in std_logic_vector (n-1 downto 0);
			cociente: out std_logic_vector (n-1 downto 0);
			ready: out std_logic
			);
end maquina_divisor;

architecture Behavioral of maquina_divisor is
	
	type estados is (init, prepara, resta, espera1, divisible, nodivisible, desplaza, espera2);
	signal rk,aux_rk: natural range 0 to 5;
	signal estado_act, estado_sig: estados;
	signal rdsor: std_logic_vector (n downto 0);
	signal rdndo: std_logic_vector (n downto 0);
	signal rc: std_logic_vector (n-1 downto 0);
	signal aux_rdsor: std_logic_vector (n downto 0);
	signal aux_rdndo: std_logic_vector (n downto 0);
	signal aux_rc: std_logic_vector (n-1 downto 0);
	signal clk_1Hz,rst: std_logic;
	
	--Descomentar para implementacion
	component divisorImplementacion is
	port(rst,clk_entrada:in std_logic;
			clk_salida:out std_logic);
	 end component;
	
	begin
	
	--Descomentar para implementacion
	Nuevo_reloj: divisorImplementacion port map(rst,clk,clk_1Hz);
	
	--Comentar para implementacion
	--clk_1Hz <= clk;


sincrono: process(clk,reset)
	begin
	if reset='1' then
	estado_act<=init;
	elsif clk'event and clk='1' then
	estado_act<=estado_sig;
	end if;
	end process sincrono;

SYNC_REG: process (clk, reset, estado_act)
begin 
	cociente <= rc;
	if reset='1'then
		rdndo <= (others=>'0');
		rdsor <= (others=>'0');
		rc <= (others=>'0');
		rk <= 0;
	elsif clk'event and clk='1' then
		if estado_act = prepara then
			rdsor <= aux_rdsor;
			rdndo <= aux_rdndo;
			rc <= aux_rc;
			rk <= aux_rk;
		elsif estado_act = resta then
			rdndo <= aux_rdndo;
		elsif estado_act = divisible then
			rdndo <= aux_rdndo;
			rc <= aux_rc;
		elsif estado_act = nodivisible then
			rc <= aux_rc;
		elsif estado_act = desplaza then
			rdsor <= aux_rdsor;
			rk <= aux_rk;
		end if;
	end if;
end process SYNC_REG;

cambioestados: process (estado_act,inicio,rk)
begin 

case estado_act is

	when init =>
		if inicio = '0' then estado_sig <= init;
		else 
			estado_sig <= prepara;
		end if;
		
	when prepara =>
		estado_sig <= resta;
		
	when resta =>
		estado_sig <= espera1;

	when espera1 =>
		if rdndo(n) = '1' then estado_sig <= divisible;
		else	
			estado_sig <= nodivisible;
		end if;
		
	when divisible =>
		estado_sig <= desplaza;
		
	when nodivisible =>
		estado_sig <= desplaza;
		
	when desplaza =>
		estado_sig <= espera2;
		
	when espera2 =>
		if rk > 3 then estado_sig <= init;
		else
			estado_sig <= resta;
		end if;
		
end case;
end process cambioestados;

COMB: process (clk, reset, estado_act, rdndo, rdsor, rc, rk)
begin
ready <= '0';
		aux_rdndo <= '0'& dividendo;
		aux_rdsor (n downto n-m) <= '0' & divisor;
		aux_rdsor (n-m-1 downto 0) <= (others=>'0');
		aux_rc <= (others=>'0');
		aux_rk <= 0;

case estado_act is

	when init =>
		ready <= '1';
		
	when prepara =>
		--state idle
		
	when resta =>
		aux_rdndo <= rdndo - rdsor;
		
	when espera1 =>
		
	when divisible =>
		aux_rc <= rc(n-2 downto 0) & '0';
		aux_rdndo <= rdndo + rdsor;
			
	when nodivisible =>
		aux_rc <= rc(n-2 downto 0) & '1';
		
	when desplaza =>
		aux_rdsor <= '0' & rdsor(n downto 1);
		aux_rk <= rk+1;
		
	when espera2 =>
			
end case;
end process COMB;
end Behavioral;
