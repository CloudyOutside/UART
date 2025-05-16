----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2025 08:01:51 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
  Port (TXD, clk :in std_logic;
    btn : in std_logic_vector(1 downto 0);
    CTS, RTS, RXD : out std_logic);
end top;

architecture structural of top is
component uart port
(

    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx  : out std_logic
);
end component;

component clock_div port 
(
  CLK : in std_logic;
  OUTPUT : out std_logic
);
end component;
component debounce port (
  CLK: in std_logic;
  BTN: in std_logic;
  DBNC : out std_logic
);
end component;
component sender port
(
rst, clk, en, btn, ready : in std_logic;
 send : out std_logic;
 char : out std_logic_vector(7 downto 0)
 );
end component;

signal u1_out : std_logic;
signal u2_out : std_logic;
signal u3_out : std_logic;
signal u4char_out : std_logic_vector(7 downto 0);
signal u4send_out : std_logic;
signal u5ready_out : std_logic;
signal u5RXD_out : std_logic;
signal u5tx_out : std_logic;
begin
u1: debounce port map(
  CLK => clk,
  BTN => btn(0),
  DBNC => u1_out
);
u2: debounce port map(
  CLK => clk,
  BTN => btn(1),
  DBNC => u2_out
);
u3: clock_div port map(
  CLK => clk,
  OUTPUT => u3_out
);
u4: sender port map(
    rst => u1_out,
    clk => clk,
    en => u3_out,
    btn => u2_out,
    ready => u5ready_out,
    send => u4send_out,
    char => u4char_out
);
u5: uart port map(
    clk => clk,
    en => u3_out,
    send  => u4send_out,
    rx => txd,
    rst => u1_out,
    charSend => u4char_out,
    ready => u5ready_out,
    tx => RXD                
);
end structural;
