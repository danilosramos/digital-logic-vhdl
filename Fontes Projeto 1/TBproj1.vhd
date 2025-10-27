--------------------------------------------------------------------------------
-- Engineer: Danilo Silveira Ramos / Andre de Souza da Costa
--
-- Create Date:   17:55:03 04/28/2025
-- Design Name:   
-- Module Name:   /home/ise/TrabalhoT1/TBproj1.vhd
-- Project Name:  TrabalhoT1
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity prim_proc_tb is
end prim_proc_tb;

architecture behavior of prim_proc_tb is
    component prim_proc
        port( in1, in2, in3, in4 : in std_logic;
              ctrl : in std_logic_vector (1 downto 0);
              sai : out std_logic);
    end component;

    signal in1, in2, in3, in4 : std_logic := '0';
    signal ctrl : std_logic_vector(1 downto 0) := "00";
    signal sai : std_logic;
begin
    uut: prim_proc port map (
        in1 => in1,
        in2 => in2,
        in3 => in3,
        in4 => in4,
        ctrl => ctrl,
        sai => sai
    );

    stim_proc: process
    begin
-- Teste 1: Verifica todas as combinações de controle
	in1 <= '1'; in2 <= '0'; in3 <= '1'; in4 <= '0';
	ctrl <= "00"; wait for 10 ns;
	ctrl <= "01"; wait for 10 ns;
	ctrl <= "10"; wait for 10 ns;
	ctrl <= "11"; wait for 10 ns;
                -- Teste 2: Muda as entradas com controle fixo
	ctrl <= "01";
	in2 <= '1'; wait for 10 ns;
	in2 <= '0'; wait for 10 ns;
               -- Teste 3: Verifica transições
	in1 <= '0'; in3 <= '0'; in4 <= '1';
	ctrl <= "00"; wait for 5 ns;
	ctrl <= "11"; wait for 5 ns;
	ctrl <= "10"; wait for 5 ns;
	
	ctrl <= "11";  -- Seleciona in4
	in4 <= '1'; wait for 10 ns; 
	in4 <= '0'; wait for 10 ns;
	in1 <= '1'; wait for 10 ns;
                wait;
	end process;
end behavior;