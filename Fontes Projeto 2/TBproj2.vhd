--------------------------------------------------------------------------------
-- Engineer: Danilo Silveira Ramos / Andre de Souza da Costa
--
-- Create Date:   19:41:10 04/28/2025
-- Module Name:   /home/ise/T1Proj2/TBproj2.vhd
-- Project Name:  TBproj2
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity transmissor_tb is
end transmissor_tb;

architecture Behavioral of transmissor_tb is
    signal clock, reset, send, busy, linha : std_logic;
    signal palavra : std_logic_vector(7 downto 0);
begin
    uut: entity work.transmissor
        port map (
            clock => clock,
            reset => reset,
            send => send,
            palavra => palavra,
            busy => busy,
            linha => linha
        );

    clock_process: process
    begin
	         clock <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
    end process;
	 
    stim_proc: process
    begin
        reset <= '1';
        send <= '0';
        palavra <= "11010001";
        wait for 30 ns;
        
        reset <= '0';
        wait for 20 ns;
        
        send <= '1';
        wait for 200 ns;
        
        send <= '0';
        palavra <= "00101100";
        wait for 100 ns;
		          send <= '1';
        wait;
    end process;
end Behavioral;