library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (
        Trigger : out STD_LOGIC;
        Echo    : in STD_LOGIC;
        clk     : in STD_LOGIC;
        reset   : in STD_LOGIC;
        AN      : out STD_LOGIC_VECTOR (3 downto 0);
        display : out STD_LOGIC_VECTOR(6 downto 0)
    );
end top;

architecture Behavioral of top is
    -- Señales del sensor de distancia
    signal Distance        : STD_LOGIC_VECTOR(31 downto 0); -- Valor de distancia en cm
    signal distance_int    : integer; -- Valor de la distancia en entero

    -- Señales para los 4 dígitos del display
    signal digit_0, digit_1, digit_2, digit_3 : integer range 0 to 9;

    -- Declaración de componentes
    component Display_comp
    port(   
        digit_0 : in integer range 0 to 9;
        digit_1 : in integer range 0 to 9;
        digit_2 : in integer range 0 to 9;
        digit_3 : in integer range 0 to 9;
        clk : in std_logic;
        reset : in std_logic;
        display : out std_logic_vector(6 downto 0);
        AN: out std_logic_vector(3 downto 0));
    end component;

    component HCSR04
    port(   
        Trigger : out STD_LOGIC;
        Echo    : in STD_LOGIC;  
        Distance : out STD_LOGIC_VECTOR (31 downto 0);
        clk      : in STD_LOGIC;
        reset    : in STD_LOGIC);
    end component;
    
    component Distance_Calc 
    port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            digit_0 : out integer range 0 to 15;
            digit_1 : out integer range 0 to 15;
            digit_2 : out integer range 0 to 15;
            digit_3 : out integer range 0 to 15;
            distance_int : in integer);
    end component;

begin
    -- Instancia del módulo de ultrasonidos
    HCSR04_inst: HCSR04
    port map(
        Trigger => Trigger,
        Echo => Echo,
        Distance => Distance,
        clk => clk,
        reset => reset
    );
        
    -- Conversión del valor de distancia a entero
    distance_int <= to_integer(unsigned(Distance));

    -- Instancia del componente para el display de 7 segmentos
    Display_comp_inst: Display_comp
    port map(
        digit_0 => digit_0,
        digit_1 => digit_1,
        digit_2 => digit_2,
        digit_3 => digit_3,
        clk => clk,
        reset => reset,
        display => display,
        AN => AN
    );
    
    Distance_calc_inst: Distance_calc
    port map(
        digit_0 => digit_0,
        digit_1 => digit_1,
        digit_2 => digit_2,
        digit_3 => digit_3,
        clk => clk,
        reset => reset,
        Distance_int => Distance_int);

end Behavioral;
