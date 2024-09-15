library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Distance_Calc is
    Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            digit_0 : out integer range 0 to 9;
            digit_1 : out integer range 0 to 9;
            digit_2 : out integer range 0 to 9;
            digit_3 : out integer range 0 to 9;
            distance_int : in integer);
end Distance_Calc;

architecture Behavioral of Distance_Calc is

begin
    process(clk,reset)
        begin
            if reset = '1' then
                digit_0 <= 0;
                digit_1 <= 0;
                digit_2 <= 0;
                digit_3 <= 0;
            elsif clk'event and clk = '1' then
                digit_0 <= distance_int mod 10;           -- Unidades
                digit_1 <= (distance_int / 10) mod 10;    -- Decenas
                digit_2 <= (distance_int / 100) mod 10;   -- Centenas
                digit_3 <= (distance_int / 1000) mod 10;  -- Millares
        end if;
    end process;

end Behavioral;
