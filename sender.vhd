----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2025 06:51:48 PM
-- Design Name: 
-- Module Name: sender - Behavioral
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

entity sender is
 Port (rst, clk, en, btn, ready : in std_logic;
 send : out std_logic;
 char : out std_logic_vector(7 downto 0));
end sender;

architecture Behavioral of sender is
    type str is array (0 to 5) of std_logic_vector(7 downto 0);
    signal NETID : str := ("01100011", "01101010", "01101100", "00110010", "00110110", "00110011");
    signal i : std_logic_vector(2 downto 0) := (others => '0');
    type state_type is (idle, busyA, busyB, busyC);
    signal state : state_type:=idle;
    
begin
process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                i <= "000";
                send <= '0';
                char <= "00000000";
                state <= idle;
            elsif en = '1' then
                case state is
                    when idle =>
                        if ready = '1' and btn = '1' then
                        if unsigned(i) < 6 then
                            send <= '1';
                            char <= std_logic_vector(NETID(to_integer(unsigned(i))));
                            i <= std_logic_vector(unsigned(i) + 1);
                            state <= busyA;
                        else
                            i <= "000";
                        end if;
                        end if;
                    when busyA => 
                        state <= busyB;
                    when busyB =>
                        send <= '0';
                        state <= busyC;
                    when busyC =>
                        if ready = '1' and btn = '0' then
                            state <= idle;
                        end if;
                    when others =>
                        state <= idle;
                end case;
            end if;
        end if;

    end process;



end Behavioral;
