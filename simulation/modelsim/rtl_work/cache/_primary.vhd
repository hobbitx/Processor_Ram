library verilog;
use verilog.vl_types.all;
entity cache is
    generic(
        NBits           : integer := 8
    );
    port(
        dataIn          : in     vl_logic_vector;
        Address         : in     vl_logic_vector(4 downto 0);
        clk             : in     vl_logic;
        rw              : in     vl_logic;
        hit             : out    vl_logic;
        dataOut         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NBits : constant is 1;
end cache;
