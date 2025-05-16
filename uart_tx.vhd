----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2025 10:39:55 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
  Port (clk, en, rst, send : in std_logic;
  char : in std_logic_vector(7 downto 0);
  ready, tx : out std_logic
   );
end uart_tx;

architecture Behavioral of uart_tx is
    type state_type is (idle, start, data);
    signal state : state_type:=idle;
    
    signal counter : std_logic_vector(2 downto 0) := (others => '0');
    signal d: std_logic_vector(7 downto 0) := (others => '0');
begin
process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tx <= '1';
                ready <= '1';
                counter <= "000";
                state <= idle;
            elsif en = '1' then
                case state is
                    when idle =>
                        tx <= '1';
                        ready <= '1';                                                       
                        if send = '1' then 
                            d <= char;
                            state <= start;
                        end if;
                    when start =>
                            tx <= '0';
                            ready <= '0';
                            counter <= "000";   
                            state <= data;
                    when data =>
                        tx <= d(to_integer(unsigned(counter)));
                        if unsigned(counter) < 7 then
                            counter <= std_logic_vector(unsigned(counter) + 1);
                        else
                            state <= idle;
                        end if;
                    when others =>
                        state <= idle;
                end case;
            end if;
        end if;

    end process;

end Behavioral;
