library verilog;
use verilog.vl_types.all;
entity mux4_1_16bits is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        C               : in     vl_logic_vector(15 downto 0);
        D               : in     vl_logic_vector(15 downto 0);
        Control         : in     vl_logic_vector(1 downto 0);
        DataOut         : out    vl_logic_vector(15 downto 0)
    );
end mux4_1_16bits;
