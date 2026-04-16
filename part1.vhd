library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity three_k_plus_one is
    port (
        reset      : in  std_logic;
        clk        : in  std_logic;
        number_out : out unsigned(6 downto 0);
        term_out   : out unsigned(6 downto 0);
        done_out   : out std_logic);
end three_k_plus_one;


architecture behavioral of three_k_plus_one is
    
    signal number : unsigned(6 downto 0);
    signal term   : unsigned(6 downto 0);
    signal length : unsigned(6 downto 0); 
    signal done   : std_logic;

    
    type state_type is (INIT, CHECK_TERM, CALC_NEXT, DONE_STATE);
    signal state : state_type;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            -- Initial values
            number <= to_unsigned(1, 7); 
            term   <= to_unsigned(1, 7);
            length <= to_unsigned(1, 7);
            done   <= '0';
            state  <= INIT;
        elsif rising_edge(clk) then
        
        if done = '0' then
                case state is
                    when INIT => number <= number + 1;
                        	term   <= number + 1;  
                        	length <= to_unsigned(1, 7);
                        	state  <= CHECK_TERM;

                    when CHECK_TERM =>
                        if term = 1 then
                        if length >= 9 then
               
                                state <= DONE_STATE;
                        else    
                                state <= INIT;
                                
                            end if;
                        else
                            state <= CALC_NEXT;
                        end if;
                        
                    when CALC_NEXT =>
                        length <= length + 1;
                        if term(0) = '0' then
                            term <= term / 2; 
                        else
                            term <= resize((term * 3) + 1, 7);
                        end if;
                        state <= CHECK_TERM;

                    when DONE_STATE =>
                        done <= '1'; 

                end case;
            	end if;
        	end if;
    end process;

    number_out <= number;
    term_out   <= term;
    done_out   <= done;

end behavioral;
