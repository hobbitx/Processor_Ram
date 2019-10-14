library verilog;
use verilog.vl_types.all;
entity cache_way is
    port(
        dataIn          : in     vl_logic_vector(15 downto 0);
        index_cache     : in     vl_logic_vector(2 downto 0);
        tag_address     : in     vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        rw_v0           : in     vl_logic;
        data_v0         : out    vl_logic_vector(15 downto 0);
        hit_v0          : out    vl_logic
    );
end cache_way;
