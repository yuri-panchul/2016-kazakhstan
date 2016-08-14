module pow_5_implementation_1
(
    input         clock,
    input         reset_n,
    input         run,
    input  [17:0] n,
    output        ready,
    output [17:0] n_pow_5
);

    reg [4:0] shift;

    always @(posedge clock or negedge reset_n)
        if (! reset_n)
            shift <= 0;
        else if (run)
            shift <= 5'b10000;
        else
            shift <= shift >> 1;

    assign ready = shift [0];

    reg [17:0] r_n, mul;

    always @(posedge clock)
        if (run)
        begin
            r_n <= n;
            mul <= n;
        end
        else
        begin
            mul <= mul * r_n;
        end

    assign n_pow_5 = mul;

endmodule

//--------------------------------------------------------------------

module pow_5_implementation_2
(
    input             clock,
    input      [17:0] n,
    output reg [17:0] n_pow_5
);

    reg [17:0] n_1, n_2, n_3;
    reg [17:0] n_pow_2, n_pow_3, n_pow_4;

    always @(posedge clock)
    begin
        n_1 <= n;
        n_2 <= n_1;
        n_3 <= n_2;

        n_pow_2 <= n * n;
        n_pow_3 <= n_pow_2 * n_1;
        n_pow_4 <= n_pow_3 * n_2;
        n_pow_5 <= n_pow_4 * n_3;
    end

endmodule

//--------------------------------------------------------------------

module pow_5_implementation_3
(
    input  [17:0] n,
    output [17:0] n_pow_5
);

    assign n_pow_5 = n * n * n * n * n;

endmodule
