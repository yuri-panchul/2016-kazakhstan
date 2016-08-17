module de0_cv
(
    input           CLOCK2_50,
    input           CLOCK3_50,
    inout           CLOCK4_50,
    input           CLOCK_50,
                   
    input           RESET_N,

    input   [ 3:0]  KEY,
    input   [ 9:0]  SW,

    output  [ 9:0]  LEDR,

    output  [ 6:0]  HEX0,
    output  [ 6:0]  HEX1,
    output  [ 6:0]  HEX2,
    output  [ 6:0]  HEX3,
    output  [ 6:0]  HEX4,
    output  [ 6:0]  HEX5,
                   
    output  [12:0]  DRAM_ADDR,
    output  [ 1:0]  DRAM_BA,
    output          DRAM_CAS_N,
    output          DRAM_CKE,
    output          DRAM_CLK,
    output          DRAM_CS_N,
    inout   [15:0]  DRAM_DQ,
    output          DRAM_LDQM,
    output          DRAM_RAS_N,
    output          DRAM_UDQM,
    output          DRAM_WE_N,
                   
    output  [ 3:0]  VGA_B,
    output  [ 3:0]  VGA_G,
    output          VGA_HS,
    output  [ 3:0]  VGA_R,
    output          VGA_VS,

    inout           PS2_CLK,
    inout           PS2_CLK2,
    inout           PS2_DAT,
    inout           PS2_DAT2,
                   
    output          SD_CLK,
    inout           SD_CMD,
    inout   [ 3:0]  SD_DATA,
                   
    inout   [35:0]  GPIO_0,
    inout   [35:0]  GPIO_1
);

    de0_cv_small de0_cv_small
    (
        .CLOCK_50 ( CLOCK_50 ),
        .RESET_N  ( RESET_N  ),

        .KEY      ( KEY      ),
        .SW       ( SW       ),

        .LEDR     ( LEDR     ),

        .HEX0     ( HEX0     ),
        .HEX1     ( HEX1     ),
        .HEX2     ( HEX2     ),
        .HEX3     ( HEX3     ),
        .HEX4     ( HEX4     ),
        .HEX5     ( HEX5     )
    );

endmodule

//----------------------------------------------------------------------------

module clock_divider_50_MHz_to_1_49_Hz
(
    input  clock_50_MHz,
    input  reset_n,
    output clock_1_49_Hz
);

    // 50 MHz / 2 ** 25 = 1.49 Hz

    reg [24:0] count;

    always @ (posedge clock_50_MHz)
    begin
        if (! reset_n)
            count <= 0;
        else
            count <= count + 1;
    end

    assign clock_1_49_Hz = count [24];

endmodule

//----------------------------------------------------------------------------

module counter_with_load
(
    input             clock,
    input             reset_n,

    input             load,
    input      [15:0] load_data,
    output reg [15:0] count
);

    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            count <= 0;
        else if (load)
            count <= load_data;
        else
            count <= count + 1;
    end

endmodule

//----------------------------------------------------------------------------

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

//----------------------------------------------------------------------------

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

//----------------------------------------------------------------------------

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

//----------------------------------------------------------------------------

module pattern_fsm_mealy
(
    input  clock,
    input  reset_n,
    input  a,
    output y
);

    parameter S0 = 1'b0, S1 = 1'b1;

    reg state, next_state;

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
                next_state = S0;
            else
                next_state = S1;

        default:

            next_state = S0;

        endcase

    // output logic

    assign y = (a & state == S1);

endmodule

//----------------------------------------------------------------------------

module de0_cv_small
(
    input          CLOCK_50,
    input          RESET_N,

    input   [3:0]  KEY,
    input   [9:0]  SW,

    output  [9:0]  LEDR,

    output  [6:0]  HEX0,
    output  [6:0]  HEX1,
    output  [6:0]  HEX2,
    output  [6:0]  HEX3,
    output  [6:0]  HEX4,
    output  [6:0]  HEX5
);

    wire clock_before_global, clock, shift_out, fsm_out;

    clock_divider_50_MHz_to_1_49_Hz clock_divider_50_MHz_to_1_49_Hz
    (
        .clock_50_MHz  ( CLOCK_50            ),
        .reset_n       ( RESET_N             ),
        .clock_1_49_Hz ( clock_before_global )
    );

    global global
    (
        .in  ( clock_before_global ),
        .out ( clock               )
    );

    //------------------------------------------------------------------------

    wire [15:0] count;

    counter_with_load counter_with_load
    (
        .clock      (   clock        ),
        .reset_n    (   RESET_N      ),

        .load       ( ~ KEY [2]      ),
        .load_data  (   { 6'b0, SW } ),
        .count      (   count        )
    );

    //------------------------------------------------------------------------

    single_digit_display digit_0
    (
        .digit          ( count [ 3: 0] ),
        .seven_segments ( HEX0          )
    );

    single_digit_display digit_1
    (
        .digit          ( count [ 7: 4] ),
        .seven_segments ( HEX1          )
    );

    single_digit_display digit_2
    (
        .digit          ( count [11: 8] ),
        .seven_segments ( HEX2          )
    );

    single_digit_display digit_3
    (
        .digit          ( count [15:12] ),
        .seven_segments ( HEX3          )
    );

    //------------------------------------------------------------------------

    shift_register_with_enable shift_register_with_enable
    (
        .clock   (   clock     ),
        .reset_n (   RESET_N   ),
        .in      ( ~ KEY [1]   ),
        .enable  (   KEY [0]   ),
        .out     (   shift_out ),
        .data    (   LEDR      )
    );           

    //------------------------------------------------------------------------

    wire moore_fsm_out, mealy_fsm_out;

    pattern_fsm_moore pattern_fsm_moore
    (
        .clock   ( clock         ),
        .reset_n ( RESET_N       ),
        .a       ( shift_out     ),
        .y       ( moore_fsm_out )
    );

    pattern_fsm_mealy pattern_fsm_mealy
    (
        .clock   ( clock         ),
        .reset_n ( RESET_N       ),
        .a       ( shift_out     ),
        .y       ( mealy_fsm_out )
    );

    assign HEX5 = moore_fsm_out ? 7'b1100011 : 7'b1111111;
    assign HEX4 = mealy_fsm_out ? 7'b1100011 : 7'b1111111;

endmodule
