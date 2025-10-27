----------------------------------------------------------------------------------
-- Engineer: Danilo Silveira Ramos / Andre de Souza da Costa
-- 
-- Create Date:    13:47:46 05/08/2025 
-- Project Name: Cronometro Decrescente
-- Target Devices: Nexys 2
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cron_decr is
	 generic ( CLOCK_FREQ : integer := 50_000_000 ); -- Clock de 50MHz
    port ( clk	  : in STD_LOGIC;
			  reset : in  STD_LOGIC;
           carga : in  STD_LOGIC;
           conta : in  STD_LOGIC;
           chaves : in  STD_LOGIC_VECTOR (7 downto 0);
			  an     : out STD_LOGIC_VECTOR(3 downto 0);
			  seg    : out STD_LOGIC_VECTOR(7 downto 0);
			  leds   : out STD_LOGIC_VECTOR(7 downto 0)
			  );
end cron_decr;

architecture cron_dec of cron_decr is

	 signal clk_counter : integer range 0 to CLOCK_FREQ-1 := 0;
    signal clk_1sec     : STD_LOGIC := '0';
	 
	 type states is (REP, LOAD, COUNT);
    signal EA, PE : states;
	 
	 signal mins : integer range 0 to 99 := 0;
    signal secs : integer range 0 to 99 := 0;
	 
	 type ROM is array (0 to 99) of std_logic_vector (7 downto 0);
 constant conv_to_BCD : ROM:=(
					 "00000000", "00000001", "00000010", "00000011", "00000100", 
                "00000101", "00000110", "00000111", "00001000", "00001001",
					 "00010000", "00010001", "00010010", "00010011", "00010100", 
                "00010101", "00010110", "00010111", "00011000", "00011001",  
                "00100000", "00100001", "00100010", "00100011", "00100100",
					 "00100101", "00100110", "00100111", "00101000", "00101001",  
                "00110000", "00110001", "00110010", "00110011", "00110100", 
                "00110101", "00110110", "00110111", "00111000", "00111001",  
                "01000000", "01000001", "01000010", "01000011", "01000100", 
					 "01000101", "01000110", "01000111", "01001000", "01001001",  
                "01010000", "01010001", "01010010", "01010011", "01010100", 
                "01010101", "01010110", "01010111", "01011000", "01011001",
                "01100000", "01100001", "01100010", "01100011", "01100100", 
                "01100101", "01100110", "01100111", "01101000", "01101001",
					 "01110000", "01110001", "01110010", "01110011", "01110100", 
                "01110101", "01110110", "01110111", "01111000", "01111001",
                "10000000", "10000001", "10000010", "10000011", "10000100", 
                "10000101", "10000110", "10000111", "10001000", "10001001",
                "10010000", "10010001", "10010010", "10010011", "10010100", 
                "10010101", "10010110", "10010111", "10011000", "10011001");
					 
	 signal bcd_mins : std_logic_vector(7 downto 0);
    signal bcd_secs : std_logic_vector(7 downto 0);
    signal display_counter : std_logic_vector(15 downto 0) := (others => '0');
    signal digit_select : std_logic_vector(1 downto 0);
    signal digit_value : std_logic_vector(3 downto 0);

begin
      -- Divisor de clock: 50MHz para 1Hz
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                clk_counter <= 0;
                clk_1sec <= '0';
            else
					if clk_counter = CLOCK_FREQ/2-1 then
                    clk_counter <= 0;
                    clk_1sec <= not clk_1sec;
                else
                    clk_counter <= clk_counter + 1;
                end if;
            end if;
        end if;
    end process;
	 
	 -- Processo único para máquina de estados e contagem
	 process(clk_1sec, reset)
    begin
        if reset = '1' then
            EA <= REP;
            mins <= 0;
            secs <= 0;
        elsif rising_edge(clk_1sec) then
            EA <= PE;
				
				-- Lógica de contagem decrescente
            if EA = COUNT then
                if secs > 0 then
                    secs <= secs - 1;
                else
                    if mins > 0 then
                        mins <= mins - 1;
                        secs <= 59;
                    end if;
                end if;
            end if;
				
				 -- Lógica de carregamento
            if EA = LOAD then
                if (CONV_INTEGER(chaves)) > 99 then
						mins <= 99;
				    else
					 mins <= CONV_INTEGER(chaves);
					 end if;
                secs <= 0;
            end if;
        end if;
    end process;
	 
	 
	 -- Lógica combinacional do próximo estado
    process(EA, carga, conta, mins, secs)
    begin
        case EA is
            when REP =>
                leds <= "00000001";
                if carga = '1' then
                    PE <= LOAD;
                else
                    PE <= REP;
                end if;
					 
					 when LOAD =>
                leds <= "00000010";
                if conta = '1' then
                    PE <= COUNT;
                else
                    PE <= LOAD;
                end if;
					 
					 when COUNT =>
                leds <= "00000100";
                if (mins = 0 and secs = 0) then
                    PE <= REP;
                else
                    PE <= COUNT;
                end if;
        end case;
    end process;
	 
	 bcd_mins <= conv_to_BCD(mins);
    bcd_secs <= conv_to_BCD(secs);
	 
	  process(clk)
    begin
        if rising_edge(clk) then
            display_counter <= display_counter + 1;
        end if;
    end process;
	 
	 digit_select <= display_counter(15 downto 14);
	 
	 process(digit_select, bcd_mins, bcd_secs)
    begin
	     case digit_select is
            when "00" =>   -- Minutos (dezena)
                digit_value <= bcd_mins(7 downto 4);
                an <= "0111";
            when "01" =>   -- Minutos (unidade)
                digit_value <= bcd_mins(3 downto 0);
                an <= "1011";
					 seg(7) <= '0'; -- Decimal
            when "10" =>   -- Segundos (dezena)
                digit_value <= bcd_secs(7 downto 4);
                an <= "1101";
            when others => -- Segundos (unidade)
                digit_value <= bcd_secs(3 downto 0);
                an <= "1110";
        end case;
    end process;
	 
	 process(digit_value)
    begin
        case digit_value is
            when "0000" => seg(6 downto 0) <= "1000000"; -- 0
            when "0001" => seg(6 downto 0) <= "1111001"; -- 1
            when "0010" => seg(6 downto 0) <= "0100100"; -- 2
				when "0011" => seg(6 downto 0) <= "0110000"; -- 3
            when "0100" => seg(6 downto 0) <= "0011001"; -- 4
            when "0101" => seg(6 downto 0) <= "0010010"; -- 5
            when "0110" => seg(6 downto 0) <= "0000010"; -- 6
            when "0111" => seg(6 downto 0) <= "1111000"; -- 7
            when "1000" => seg(6 downto 0) <= "0000000"; -- 8
            when "1001" => seg(6 downto 0) <= "0010000"; -- 9
            when others => seg(6 downto 0) <= "1111111"; -- Apagado
				end case;
    end process;
    
end cron_dec;

