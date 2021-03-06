----------------------------------------------------------------------------------
-- Company: Kikest S.L.
-- Engineer: Enrique Ballesteros Horcajo
-- 
-- Create Date: Top Secret
-- Module Name:    cam - circuito_cam
-- Project Name: 	practica6
-- Target Devices:	Spartan 3
------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
 
entity cam is
  port     (clk              : in   std_logic;
            read_enable      : in   std_logic;
            key	           : in   std_logic_vector(4 downto 0);
				error            : out  std_logic;
            data_out         : out  std_logic_vector(15 downto 0)       
           );
end cam;
 
 
architecture circuito_cam of cam is

component ram is
    port (clk : in std_logic;
          addr : in std_logic_vector(4 downto 0);
          do : out std_logic_vector(15 downto 0)
	);
end component ram;
	
type ram_array is array (0 to 31 ) of std_logic_vector(15 downto 0);
type key_array is array	(0 to 19 ) of std_logic_vector(4 downto 0);
signal keys	: key_array :=(	"00100","01000","10111","11100","01110","10100","11010",
										"01111","11110","11001","10110","00001","10001","10010",
										"10011","00101","11011","11000","10000","00111");
										--"00010","01100","01101","11111","00011","10101","11101",
										--"00110","01001","01010","01011");
										
--signal data : ram_array := (	X"CA54",X"1654",X"0123",X"F875",X"3864",X"8752",X"4563",
--							X"4875",X"6454",X"8755",X"5147",X"6CB8",X"25AB",X"A9C7",
--							X"6254",X"0321",X"8954",X"7654",X"9215",X"9AF6",X"FADB",
--							X"0FAA",X"A56B",X"BFD5",X"A67E",X"CA21",X"D654",X"45DA",
--							X"8A64",X"E254",X"A984",X"A6DF");

signal ram_out: std_logic_vector(15 downto 0);
signal dir_ram: std_logic_vector(4 downto 0);

begin
 
data_ram: ram port map(clk, dir_ram, ram_out);

combinacional: process(keys, key) 
begin
	dir_ram <= "00000";
	error <= '1';
	for i in 0 to 19 loop
	  if key = keys(conv_integer (i)) then
		 error <= '0';
		 dir_ram <= conv_std_logic_vector(i, 5);
		 exit;
	  end if;
	end loop;

end process combinacional; 

salida: process (read_enable, ram_out)
begin
	if read_enable = '1' then
		data_out <= ram_out;
	else data_out <= X"0000";
   end if;
end process;
 
end architecture;