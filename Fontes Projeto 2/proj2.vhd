----------------------------------------------------------------------------------
-- Engineer: Danilo Silveira Ramos / Andre de Souza da Costa
-- Create Date:    19:24:12 04/28/2025 
-- Module Name:    proj2 - Behavioral 
-- Project Name: Transmissor Serial
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity transmissor is
    port(
        clock   : in  std_logic;
        reset   : in  std_logic;
        send    : in  std_logic;
        palavra : in  std_logic_vector(7 downto 0);
        busy    : out std_logic;
        linha   : out std_logic
    );
end transmissor;

architecture Behavioral of transmissor is
    signal estado : std_logic_vector(1 downto 0) := "00";
    signal contador : integer range 0 to 7 := 0;
    signal registrador : std_logic_vector(7 downto 0) := (others => '0');
    signal carregar_registrador : std_logic := '0';
begin
    process(clock, reset)
    begin
        if reset = '1' then
            registrador <= (others => '0');
        elsif rising_edge(clock) then
            if carregar_registrador = '1' then
                registrador <= palavra;
            end if;
        end if;
    end process;
	 
    process(clock, reset)
    begin
        if reset = '1' then
            estado <= "00";
            contador <= 0;
            carregar_registrador <= '0';
        elsif rising_edge(clock) then
            carregar_registrador <= '0';
            case estado is
                when "00" =>
                    if send = '1' then
                        estado <= "01";
                        carregar_registrador <= '1';
                    end if;
                    when "01" =>
                    estado <= "10";
                    contador <= 0;
                    
                when "10" =>
                    if contador < 7 then
                        contador <= contador + 1;
                    else
                        estado <= "11";
                    end if;
						  
						   when "11" =>
                    if send = '0' then
                        estado <= "00";
                    end if;
                    
                when others =>
                    estado <= "00";
            end case;
        end if;
    end process;
	 
    linha <= '0' when estado = "01" or estado = "11" else
             registrador(7 - contador) when estado = "10" else
             '1';

    busy <= '0' when estado = "00" else '1';
end Behavioral;