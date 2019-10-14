library verilog;
use verilog.vl_types.all;
entity mem_block is
    generic(
        ADDrBits        : integer := 5;
        WIDTH           : integer := 16;
        DEPTH           : integer := 32
    );
    port(
        addr            : in     vl_logic_vector;
        Clock           : in     vl_logic;
        data            : in     vl_logic_vector;
        wr_en           : in     vl_logic;
        q               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDrBits : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
end mem_block;
