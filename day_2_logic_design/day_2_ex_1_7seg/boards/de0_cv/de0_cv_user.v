module clock_divider_50_MHz_to_1_49_Hz
(
    input  clock_50_MHz,
    input  reset_n,
    output clock_1_49_Hz
);

    // 50 MHz / 2 ** 25 = 1.49 Hz

    reg [24:0] counter;

    always @ (posedge clock_50_MHz)
    begin
        if (! reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clock_1_49_Hz = counter [24];

endmodule

//--------------------------------------------------------------------

module shift_register_with_enable
(
    input            clock,
    input            reset_n,
    input            in,
    input            enable,
    output           out,
    output reg [9:0] data
);

    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            data <= 10'b10_0000_0000;
        else if (enable)
            data <= { in, data [9:1] };
    end
    
    assign out = data [0];

endmodule

//--------------------------------------------------------------------

module single_digit_display
(
    input      [3:0] digit,
    output reg [6:0] seven_segments
);

    always @*
        case (digit)
        'h0: seven_segments = 'b1000000;  // a b c d e f g
        'h1: seven_segments = 'b1111001;
        'h2: seven_segments = 'b0100100;  //   --a--
        'h3: seven_segments = 'b0110000;  //  |     |
        'h4: seven_segments = 'b0011001;  //  f     b
        'h5: seven_segments = 'b0010010;  //  |     |
        'h6: seven_segments = 'b0000010;  //   --g--
        'h7: seven_segments = 'b1111000;  //  |     |
        'h8: seven_segments = 'b0000000;  //  e     c
        'h9: seven_segments = 'b0011000;  //  |     |
        'ha: seven_segments = 'b0001000;  //   --d-- 
        'hb: seven_segments = 'b0000011;
        'hc: seven_segments = 'b1000110;
        'hd: seven_segments = 'b0100001;
        'he: seven_segments = 'b0000110;
        'hf: seven_segments = 'b0001110;
        endcase

endmodule

//--------------------------------------------------------------------

// Smiling Snail FSM derived from David Harris & Sarah Harris

module pattern_fsm_moore
(
    input  clock,
    input  reset_n,
    input  a,
    output y
);

    parameter [1:0] S0 = 0, S1 = 1, S2 = 2;

    reg [1:0] state, next_state;

    // state register

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            state <= S0;
        else
            state <= next_state;

    // next state logic

    always @*
        case (state)

        S0:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        S1:
            if (a)
                next_state = S2;
            else
                next_state = S1;

        S2:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        default:

            next_state = S0;

        endcase

    // output logic

    assign y = (state == S2);

endmodule


//--------------------------------------------------------------------

module de0_cv_user
(
    input        CLOCK_50,
    input        RESET_N,
    input  [3:0] KEY,
    input  [9:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
);
                 
    wire clock, shift_out, fsm_out;

    clock_divider_50_MHz_to_1_49_Hz clock_divider_50_MHz_to_1_49_Hz
    (
        .clock_50_MHz  ( CLOCK_50 ),
        .reset_n       ( RESET_N  ),
        .clock_1_49_Hz ( clock    )
    );

    shift_register_with_enable shift_register_with_enable
    (
        .clock   (   clock     ),
        .reset_n (   RESET_N   ),
        .in      ( ~ KEY [1]   ),
        .enable  (   KEY [0]   ),
        .out     (   shift_out ),
        .data    (   LEDR      )
    );           

    single_digit_display digit_0
    (
        .digit          ( LEDR [3:0] ),
        .seven_segments ( HEX0 )
    );

    single_digit_display digit_1
    (
        .digit          ( LEDR [7:4] ),
        .seven_segments ( HEX1 )
    );

    single_digit_display digit_2
    (
        .digit          ( { 2'b0 , LEDR [9:8] } ),
        .seven_segments ( HEX2 )
    );

    pattern_fsm_moore pattern_fsm_moore
    (
        .clock   ( clock     ),
        .reset_n ( RESET_N   ),
        .a       ( shift_out ),
        .y       ( fsm_out   )
    );

    assign HEX3 = 7'h7f;
    assign HEX4 = 7'h7f;
    assign HEX5 = fsm_out ? 7'h40 : 7'h7f;

endmodule
