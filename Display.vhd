library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Display_comp is
    Port(
        clk : in std_logic;
        reset : in std_logic;
        digit_0 : in integer range 0 to 9;
        digit_1 : in integer range 0 to 9;
        digit_2 : in integer range 0 to 9;
        digit_3 : in integer range 0 to 9;
        AN : out std_logic_vector(3 downto 0);
        display : out std_logic_vector(6 downto 0));
end;

architecture Behavioral of Display_comp is

signal selected_counter : integer range 0 to 15;
signal counter4 : integer;
signal clk1ms : integer;
begin

    process(clk, reset) -- Contador T=1ms
    begin
        if reset = '1' then
            clk1ms <= 0; 
        elsif clk'event and clk = '1' then
            if clk1ms = 100000  then
                clk1ms <= 0;
            else
                clk1ms <= clk1ms + 1;
            end if;
        end if;
    end process;

    process(clk, reset) -- Contador de 0 a 3 de T=4ms
    begin
        if reset = '1' then
            counter4 <= 0; 
        elsif clk'event and clk = '1' then
            if clk1ms = 0 then
                if counter4 = 3 then
                    counter4 <= 0;
                else
                    counter4 <= counter4 + 1;
                end if;
            end if;
        end if;
    end process;
    
    process(clk, reset)
    begin
        if reset = '1' then
            selected_counter <= 0;
            AN <= "0000";
        elsif clk'event and clk = '1' then
            case counter4 is
                when 0 =>
                    selected_counter <= digit_0;
                    AN <= "1110";
                when 1 =>
                    selected_counter <= digit_1;
                    AN <= "1101";
                when 2 =>
                    selected_counter <= digit_2;
                    AN <= "1011";
                when 3 =>
                    selected_counter <= digit_3;
                    AN <= "0111";
                when others =>
                    selected_counter <= 0;
                    AN <= "0000";
            end case;
        end if;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            display <= "1111111";
        elsif clk'event and clk = '1' then 
            case selected_counter is
                when 0 =>
                    display <= "1000000";  -- Mostrar 0
                when 1 =>
                    display <= "1111001";  -- Mostrar 1
                when 2 =>
                    display <= "0100100";  -- Mostrar 2
                when 3 =>
                    display <= "0110000";  -- Mostrar 3
                when 4 =>
                    display <= "0011001";  -- Mostrar 4
                when 5 =>
                    display <= "0010010";  -- Mostrar 5 
                when 6 =>
                    display <= "0000010";  -- Mostrar 6
                when 7 =>
                    display <= "1111000";  -- Mostrar 7
                when 8 =>
                    display <= "0000000";  -- Mostrar 8
                when 9 =>
                    display <= "0010000";  -- Mostrar 9
                when others =>
                    display <= "1111111";  -- Apagar todos los segmentos
            end case;
        end if;
    end process;
    
end;