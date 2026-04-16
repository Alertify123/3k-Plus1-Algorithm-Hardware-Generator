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

architecture asm_arch of three_k_plus_one is

signal number_reg : unsigned(6 downto 0);
signal term       : unsigned(6 downto 0); 
signal length     : unsigned(6 downto 0);
signal done       : std_logic;

signal inc_number   : std_logic;
signal load_term    : std_logic;
signal shift_term   : std_logic;
signal do_mult      : std_logic; 
signal reset_length : std_logic;
signal inc_length   : std_logic;
signal load_done    : std_logic;

signal term_is_one  : std_logic;
signal term_is_even : std_logic;
signal length_ge_9  : std_logic;
   
type state_type is (RESET_STATE, TEST_STATE, INCREMENT, RELOAD_TERM, GENERATE_NEXT, DIVIDE, MULT_ADD, DONE_STATE);
signal state, next_state : state_type;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            number_reg <= to_unsigned(1, 7);
            term       <= to_unsigned(1, 7);
            length     <= to_unsigned(1, 7);
            done       <= '0';
            
        elsif rising_edge(clk) then
            if inc_number = '1' then 
            number_reg <= number_reg + 1; 
            
           end if;
            
            if load_term = '1'  then 
            term <= number_reg;
            elsif shift_term = '1' then 
            term <= shift_right(term, 1);
            elsif do_mult = '1' then 
            term <= resize((term * 3) + 1, 7);
            end if;

            if reset_length = '1' then 
            length <= to_unsigned(1, 7);
            elsif inc_length = '1' then 
            length <= length + 1;
            end if;

            if load_done = '1' then 
            done <= '1'; end if;
            
        end if;
    end process;

    
    term_is_one  <= '1' when (term = 1) else '0';
    term_is_even <= '1' when (term(0) = '0') else '0';
    length_ge_9  <= '1' when (length >= 9) else '0';

    
    process(clk, reset)
    begin
        if reset = '1' then
            state <= RESET_STATE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;
    

    process(state, term_is_one, term_is_even, length_ge_9)
    begin
        
        inc_number <= '0'; 
        load_term <= '0'; 
        shift_term <= '0'; 
        do_mult <= '0'; 
        reset_length <= '0'; 
        inc_length <= '0'; 
        load_done <= '0';
        next_state <= state;

        case state is
            when RESET_STATE =>
                next_state <= TEST_STATE;

            when TEST_STATE =>
                if term_is_one = '1' then
                    if length_ge_9 = '1' then
                        next_state <= DONE_STATE;
                    else
                        next_state <= INCREMENT;
                    end if;
                else
                    next_state <= GENERATE_NEXT;
                end if;

            when INCREMENT => inc_number <= '1';
                	      next_state <= RELOAD_TERM;

            when RELOAD_TERM => load_term <= '1';
                 		reset_length <= '1';
                		next_state <= TEST_STATE;

            when GENERATE_NEXT =>
                if term_is_even = '1' then 
                next_state <= DIVIDE;
                else next_state <= MULT_ADD; 
                end if;

            when DIVIDE => shift_term <= '1';
                	  inc_length <= '1';
                          next_state <= TEST_STATE;

            when MULT_ADD =>
                do_mult <= '1'; 
                inc_length <= '1';
                next_state <= TEST_STATE;

            when DONE_STATE =>
                load_done <= '1';
                next_state <= DONE_STATE;
        end case;
    end process;

    number_out <= number_reg;
    term_out   <= term;
    done_out   <= done;

end asm_arch;
