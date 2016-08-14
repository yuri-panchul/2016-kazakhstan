module testbench;

    reg         clock;
    reg         reset_n;
    reg         run;
    reg  [17:0] n;
    wire        ready;

    wire [17:0] n_pow_5_implementation_1;
    wire [17:0] n_pow_5_implementation_2;
    wire [17:0] n_pow_5_implementation_3;

    initial
    begin
        clock = 1;

        forever # 50 clock = ! clock;
    end

    initial
    begin
        repeat (2) @(posedge clock);
        reset_n <= 0;
        repeat (2) @(posedge clock);
        reset_n <= 1;
    end

    pow_5_implementation_1 pow_5_implementation_1
        (clock, n, n_pow_5_implementation_1);

    pow_5_implementation_2 pow_5_implementation_2
        (clock, reset_n, run, n, ready, n_pow_5_implementation_2);

    pow_5_implementation_3 pow_5_implementation_3
        (n, n_pow_5_implementation_3);

    integer i;

    initial
    begin
        #0
        $dumpvars;

        $monitor ("clock %b reset_n %b n %d comb %d seq %d run %b ready %b pipe %d",
            clock,
            reset_n,
            n,
            n_pow_5_implementation_1,
            n_pow_5_implementation_2,
            run,
            ready,
            n_pow_5_implementation_3);

        @(posedge reset_n);
        @(posedge clock);

        for (i = 0; i < 50; i = i + 1)
        begin
            n   <= i & 7;
            run <= (i == 0 || ready);

            @(posedge clock);
        end

        $finish;
    end

endmodule
