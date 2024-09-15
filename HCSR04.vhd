library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity HCSR04 is
    Port ( Trigger: out STD_LOGIC; --Pin Trigger del Sensor
           Echo : in STD_LOGIC;  --Pin de Echo del Sensor
           Distance : out STD_LOGIC_VECTOR (31 downto 0); --Valor de distancia calculada en cm, de 16b
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end HCSR04;

architecture Behavioral of HCSR04 is

--Constantes
constant CLK_FREQ          : integer := 100000000; -- 100 MHz(Frecuencia del Reloj)
constant MAX_ECHO_TIME     : integer := 2330000;    -- 23.3 ms (Máximo tiempo de eco)
constant TRIG_PULSE_WIDTH  : integer := 1000;      --  10 us (Duración del pulso del Trigger)
constant TRIG_WAIT_TIME  : integer := 5_000_000;   --  50 ms (Tiempo en IDLE)

--Contadores
signal trig_counter : integer := 0;
signal echo_counter  : integer := 0;

-- Señales internas
signal trig_reg      : STD_LOGIC := '0';
signal distance_reg  : unsigned(31 downto 0) := (others => '0');


--Maquina de estados
type state_type is (IDLE, TRIG, WAIT_ECHO_H, WAIT_ECHO_L, CALCULATE);
    signal state : state_type := IDLE;
begin

    process(clk,reset)
    begin
        if reset = '1' then
            state <= IDLE;
            echo_counter <= 0;
            trig_counter <= 0;
            trig_reg <= '0';
            distance_reg  <= (others => '0');
        elsif clk'event and clk = '1' then
            case state is
            when IDLE =>
                echo_counter <= 0;
                if trig_counter < TRIG_WAIT_TIME then 
                    trig_counter <= trig_counter + 1;
                else 
                    trig_counter <= 0;
                    state <= TRIG;
                end if;
            when TRIG =>
                trig_reg <= '1';
                if trig_counter < TRIG_PULSE_WIDTH then
                    trig_counter <= trig_counter + 1;
                else
                    trig_reg <= '0';
                    trig_counter <= 0;
                    state <= WAIT_ECHO_H;
                end if;  
            when WAIT_ECHO_H =>
                if echo = '1' then
                    state <= WAIT_ECHO_L;
                    echo_counter <= 0;
                elsif echo_counter > MAX_ECHO_TIME then
                    -- Timeout si no recibe eco
                    state <= IDLE;
                    echo_counter <= 0;
                else
                    echo_counter <= echo_counter + 1;
                end if;  
            when WAIT_ECHO_L =>
                if echo = '0' then
                    state <= CALCULATE;
                elsif echo_counter < MAX_ECHO_TIME then
                    echo_counter <= echo_counter + 1;
                else                        
                    state <= IDLE;
                    echo_counter <= 0;
                end if;
            when CALCULATE =>
                distance_reg <= to_unsigned(echo_counter * 171 / (1000000), 32);
                state <= IDLE;
           when others =>
                 state <= IDLE;        
            end case;
        end if;
    end process;
    Trigger <= trig_reg;
    Distance <= std_logic_vector(distance_reg);
end Behavioral;
