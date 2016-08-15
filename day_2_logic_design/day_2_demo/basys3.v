// Checking if the board is alive

module basys3_1
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    assign led [ 0] = sw [ 0];
    assign led [ 1] = sw [ 1];
    assign led [ 2] = sw [ 2];
    assign led [ 3] = sw [ 3];
    assign led [ 4] = sw [ 4];
    assign led [ 5] = sw [ 5];
    assign led [ 6] = sw [ 6];
    assign led [ 7] = sw [ 7];
    assign led [ 8] = sw [ 8];
    assign led [ 9] = sw [ 9];
    assign led [10] = sw [10];
    assign led [11] = sw [11];
    assign led [12] = sw [12];
    assign led [13] = sw [13];
    assign led [14] = sw [14];
    assign led [15] = sw [15];

    assign seg = ~ { btnC, btnL, btnL, btnD, btnR, btnR, btnU };
    assign dp  = ~ ( btnC | btnU | btnL | btnR | btnD );
    assign an  = 4'b0;

endmodule

//--------------------------------------------------------------------

// Combinational building block: multiplexor

module mux_2_1
(
    input  [3:0] d0,
    input  [3:0] d1,
    input        sel,
    output [3:0] y
);

    assign y = sel ? d1 : d0;

endmodule

module mux_4_1_imp_1
(
    input  [3:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [3:0] y
);

    assign y = sel [1]
        ? (sel [0] ? d3 : d2)
        : (sel [0] ? d1 : d0);

endmodule

module mux_4_1_imp_2
(
    input      [3:0] d0, d1, d2, d3,
    input      [1:0] sel,
    output reg [3:0] y
);

    always @*
        case (sel)
        2'b00: y = d0;
        2'b01: y = d1;
        2'b10: y = d2;
        2'b11: y = d3;
        endcase

endmodule

module mux_4_1_imp_3
(
    input  [3:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [3:0] y
);

    wire [3:0] w01, w23;

    mux_2_1 i0 (.d0 ( d0  ), .d1 ( d1  ), .sel (sel [0]), .y ( w01 ));
    mux_2_1 i1 (.d0 ( d2  ), .d1 ( d3  ), .sel (sel [0]), .y ( w23 ));
    mux_2_1 i2 (.d0 ( w01 ), .d1 ( w23 ), .sel (sel [1]), .y ( y   ));

endmodule

module mux_4_1_bits_2
(
    input  [1:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [1:0] y
);

    assign y = sel [1]
        ? (sel [0] ? d3 : d2)
        : (sel [0] ? d1 : d0);

endmodule

module mux_4_1_imp_4
(
    input  [3:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [3:0] y
);

    mux_4_1_bits_2 high
    (
        .d0  ( d0 [3:2] ),
        .d1  ( d1 [3:2] ),
        .d2  ( d2 [3:2] ),
        .d3  ( d3 [3:2] ),
        .sel ( sel      ),
        .y   ( y  [3:2] )
    );

    mux_4_1_bits_2 low
    (
        .d0  ( d0 [1:0] ),
        .d1  ( d1 [1:0] ),
        .d2  ( d2 [1:0] ),
        .d3  ( d3 [1:0] ),
        .sel ( sel      ),
        .y   ( y  [1:0] )
    );

endmodule

module basys3_2
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    mux_4_1_imp_1
    (
        .d0  ( sw  [ 3: 0]    ),
        .d1  ( sw  [ 7: 4]    ),
        .d2  ( sw  [11: 8]    ),
        .d3  ( sw  [15:12]    ),
        .sel ( { btnC, btnR } ),
        .y   ( led [ 3: 0]    )
    ); 
        
    mux_4_1_imp_2
    (
        .d0  ( sw  [ 3: 0]    ),
        .d1  ( sw  [ 7: 4]    ),
        .d2  ( sw  [11: 8]    ),
        .d3  ( sw  [15:12]    ),
        .sel ( { btnC, btnR } ),
        .y   ( led [ 7: 4]    )
    ); 
        
    mux_4_1_imp_3
    (
        .d0  ( sw  [ 3: 0]    ),
        .d1  ( sw  [ 7: 4]    ),
        .d2  ( sw  [11: 8]    ),
        .d3  ( sw  [15:12]    ),
        .sel ( { btnC, btnR } ),
        .y   ( led [11: 8]    )
    ); 

    mux_4_1_imp_4
    (
        .d0  ( sw  [ 3: 0]    ),
        .d1  ( sw  [ 7: 4]    ),
        .d2  ( sw  [11: 8]    ),
        .d3  ( sw  [15:12]    ),
        .sel ( { btnC, btnR } ),
        .y   ( led [15:12]    )
    ); 

    assign seg = ~ 7'b0;
    assign dp  = 1'b1;
    assign an  = 4'b0;

endmodule

//--------------------------------------------------------------------

// Combinational building block: decoder

module decoder_3_8_imp_1
(
    input      [2:0] a,
    output reg [7:0] y
);

    always @*
    case (a)
    3'b000: y = 8'b00000001;
    3'b001: y = 8'b00000010;
    3'b010: y = 8'b00000100;
    3'b011: y = 8'b00001000;
    3'b100: y = 8'b00010000;
    3'b101: y = 8'b00100000;
    3'b110: y = 8'b01000000;
    3'b111: y = 8'b10000000;
    endcase

endmodule

module decoder_3_8_imp_2
(
    input      [2:0] a,
    output reg [7:0] y
);

    always @*
    begin
        y = 0;
        y [a] = 1;
    end

endmodule

module decoder_3_8_imp_3
(
    input  [2:0] a,
    output [7:0] y
);

    assign y = 1 << a;

endmodule

module basys3_3
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    decoder_3_8_imp_1 decoder_3_8_imp_1 (.a (sw [3:0]), .y (led [ 7:0]));
    decoder_3_8_imp_2 decoder_3_8_imp_3 (.a (sw [3:0]), .y (led [15:8]));

    assign seg = ~ 7'b0;
    assign dp  = 1'b1;
    assign an  = 4'b0;

endmodule

//--------------------------------------------------------------------

// Combinational building block: encoder

module priority_circuit_imp_1
(
    input      [3:0] a,
    output reg [3:0] y
);

    always @*
        if      (a[3]) y <= 4'b1000;
        else if (a[2]) y <= 4'b0100;
        else if (a[1]) y <= 4'b0010;
        else if (a[0]) y <= 4'b0001;
        else           y <= 4'b0000;

endmodule

module priority_circuit_imp_2
(
    input      [3:0] a,
    output reg [3:0] y
);

    always @*
        casex (a)
        4'b1???: y <= 4'b1000;
        4'b01??: y <= 4'b0100;
        4'b001?: y <= 4'b0010;
        4'b0001: y <= 4'b0001;
        default: y <= 4'b0000;
        endcase

endmodule

module priority_encoder_imp_1
(
    input      [3:0] a,
    output reg [1:0] y
);

    always @*
        if      (a[3]) y <= 3;
        else if (a[2]) y <= 2;
        else if (a[1]) y <= 1;
        else if (a[0]) y <= 0;
        else           y <= 0;

endmodule

module priority_encoder_imp_2
(
    input      [3:0] a,
    output reg [3:0] y
);

    always @*
        casex (a)
        4'b1???: y <= 3;
        4'b01??: y <= 2;
        4'b001?: y <= 1;
        4'b0001: y <= 0;
        default: y <= 0;
        endcase

endmodule

module parallel_encoder_imp_1
(
    input      [3:0] a,
    output reg [1:0] y
);

    always @*
        if      (a == 4'b1000) y <= 3;
        else if (a == 4'b0100) y <= 2;
        else if (a == 4'b0010) y <= 1;
        else if (a == 4'b0001) y <= 0;
        else                   y <= 0;

endmodule

module parallel_encoder_imp_2
(
    input      [3:0] a,
    output reg [3:0] y
);

    always @*
        casex (a)
        4'b1000: y <= 3;
        4'b0100: y <= 2;
        4'b0010: y <= 1;
        4'b0001: y <= 0;
        default: y <= 0;
        endcase

endmodule


module basys3  // _4
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    priority_circuit_imp_1 priority_circuit_imp_1
        (.a (sw [3:0]), .y (led [ 3: 0]));

    priority_circuit_imp_2 priority_circuit_imp_2
        (.a (sw [3:0]), .y (led [ 7: 4]));

    priority_encoder_imp_1 priority_encoder_imp_1
        (.a (sw [3:0]), .y (led [ 9: 8]));

    priority_encoder_imp_2 priority_encoder_imp_2
        (.a (sw [3:0]), .y (led [11:10]));

    parallel_encoder_imp_1 parallel_encoder_imp_1
        (.a (sw [3:0]), .y (led [13:12]));

    parallel_encoder_imp_2 parallel_encoder_imp_2
        (.a (sw [3:0]), .y (led [15:14]));

    assign seg = ~ 7'b0;
    assign dp  = 1'b1;
    assign an  = 4'b0;

endmodule

//--------------------------------------------------------------------

// Combinational building block: seven-segment driver

module single_digit_display
(
    input      [3:0] digit,
    input            single_digit,
    input            show_dot,

    output reg [6:0] seven_segments,
    output           dot,
    output     [3:0] anodes
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

    assign dot    = ~ show_dot;
    assign anodes = single_digit ? 4'b1110 : 4'b0000;

endmodule

//--------------------------------------------------------------------

module basys3_5
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    single_digit_display single_digit_display
    (
        .digit           ( sw [3:0] ),
        .single_digit    ( sw [15]  ),
        .show_dot        ( sw [14]  ),

        .seven_segments  ( seg      ),
        .dot             ( dp       ),
        .anodes          ( an       )
    );

endmodule

//--------------------------------------------------------------------

// Sequential building block: counter

module clock_divider_100_MHz_to_1_49_Hz
(
    input  clock_100_MHz,
    input  resetn,
    output clock_1_49_Hz
);

    // 100 MHz / 2 ** 26 = 1.49 Hz

    reg [25:0] counter;

    always @ (posedge clock_100_MHz)
    begin
        if (! resetn)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clock_1_49_Hz = counter [25];

endmodule


module counter
(
    input             clock,
    input             resetn,
    output reg [15:0] count
);

    always @ (posedge clock or negedge resetn)
    begin
        if (! resetn)
            count <= 0;
        else
            count <= count + 1;
    end

endmodule


module basys3_6
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    wire clock;
    wire resetn = ! btnU;

    clock_divider_100_MHz_to_1_49_Hz clock_divider
    (
        .clock_100_MHz (clk),
        .resetn        (resetn),
        .clock_1_49_Hz (clock)
    );

    counter counter
    (
        .clock  ( clock  ),
        .resetn ( resetn ),
        .count  ( led    )
    );

    assign seg = ~ 7'b0;
    assign dp  = 1'b0;
    assign an  = 4'b0;

endmodule

//--------------------------------------------------------------------

// Sequential building block: counter with load and better display

module counter_with_load
(
    input             clock,
    input             resetn,

    input             load,
    input      [15:0] load_data,
    output reg [15:0] count
);

    always @ (posedge clock or negedge resetn)
    begin
        if (! resetn)
            count <= 0;
        else if (load)
            count <= load_data;
        else
            count <= count + 1;
    end

endmodule

//--------------------------------------------------------------------

module clock_divider_100_MHz_to_95_4_Hz_and_1_53_KHz
(
    input  clock_100_MHz,
    input  resetn,
    output clock_95_4_Hz,
    output clock_1_53_KHz
);

    // 100 MHz / 2 ** 20 = 95.4 Hz
    // 100 MHz / 2 ** 16 = 1.53 KHz

    reg [29:0] counter;

    always @ (posedge clock_100_MHz)
    begin
        if (! resetn)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clock_95_4_Hz  = counter [19];
    assign clock_1_53_KHz = counter [15];

endmodule

//--------------------------------------------------------------------

module display
(
    input             clock,
    input             resetn,
    input      [15:0] number,

    output reg [ 6:0] seven_segments,
    output reg        dot,
    output reg [ 3:0] anodes
);

    function [6:0] bcd_to_seg (input [3:0] bcd);

        case (bcd)
        'h0: bcd_to_seg = 'b1000000;  // a b c d e f g
        'h1: bcd_to_seg = 'b1111001;
        'h2: bcd_to_seg = 'b0100100;  //   --a--
        'h3: bcd_to_seg = 'b0110000;  //  |     |
        'h4: bcd_to_seg = 'b0011001;  //  f     b
        'h5: bcd_to_seg = 'b0010010;  //  |     |
        'h6: bcd_to_seg = 'b0000010;  //   --g--
        'h7: bcd_to_seg = 'b1111000;  //  |     |
        'h8: bcd_to_seg = 'b0000000;  //  e     c
        'h9: bcd_to_seg = 'b0011000;  //  |     |
        'ha: bcd_to_seg = 'b0001000;  //   --d-- 
        'hb: bcd_to_seg = 'b0000011;
        'hc: bcd_to_seg = 'b1000110;
        'hd: bcd_to_seg = 'b0100001;
        'he: bcd_to_seg = 'b0000110;
        'hf: bcd_to_seg = 'b0001110;
        endcase

    endfunction

    reg [1:0] i;

    always @ (posedge clock or negedge resetn)
    begin
        if (! resetn)
        begin
            seven_segments <=   bcd_to_seg (0);
            dot            <= ~ 0;
            anodes         <= ~ 'b0001;

            i <= 0;
        end
        else
        begin
            seven_segments <=   bcd_to_seg (number [i * 4 +: 4]);
            dot            <= ~ 0;
            anodes         <= ~ (1 << i);

            i <= i + 1;
        end
    end

endmodule

//--------------------------------------------------------------------

module basys3_7
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    wire clock;
    wire resetn = ! btnU;

    wire clock;
    wire display_clock;

    clock_divider_100_MHz_to_95_4_Hz_and_1_53_KHz clock_divider
    (
        .clock_100_MHz  ( clk           ),
        .resetn         ( resetn        ),
        .clock_95_4_Hz  ( clock         ),
        .clock_1_53_KHz ( display_clock )
    );

    wire [15:0] count;

    counter_with_load counter_with_load
    (
        .clock      ( clock  ),
        .resetn     ( resetn ),
        .load       ( btnC   ),
        .load_data  ( sw     ),
        .count      ( count  )
    );

    assign led = count;

    display display
    (
        .clock          ( display_clock  ),
        .resetn         ( resetn         ),
        .number         ( count          ),

        .seven_segments ( seg            ),
        .dot            ( dp             ),
        .anodes         ( an             )
    );

endmodule

//--------------------------------------------------------------------

// Sequential building block: shift register

module shift_register
(
    input             clock,
    input             resetn,
    input             in,
    output            out,
    output reg [15:0] data
);

    always @ (posedge clock or negedge resetn)
    begin
        if (! resetn)
            data <= 16'hABCD;
        else
            data <= { in, data [15:1] };
            // data <= (data >> 1) | (in << 15);
    end
    
    assign out = data [0];

endmodule

module basys3_8
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    wire clock;
    wire resetn = ! btnU;

    clock_divider_100_MHz_to_1_49_Hz clock_divider
    (
        .clock_100_MHz (clk),
        .resetn        (resetn),
        .clock_1_49_Hz (clock)
    );

    wire out;

    shift_register shift_register
    (
        .clock      ( clock  ),
        .resetn     ( resetn ),
        .in         ( btnC   ),
        .out        ( out    ),
        .data       ( led    )
    );

    assign seg = out ? 7'b1111001 : 7'b1000000;
    assign dp  = 1'b1;
    assign an  = 4'b1110;

endmodule

//--------------------------------------------------------------------

// Sequential building block: shift register with enable

module shift_register_with_enable
(
    input             clock,
    input             resetn,
    input             in,
    input             enable,
    output            out,
    output reg [15:0] data
);

    always @ (posedge clock or negedge resetn)
    begin
        if (! resetn)
            data <= 16'hABCD;
        else if (enable)
            data <= { in, data [15:1] };
            // data <= (data >> 1) | (in << 15);
    end
    
    assign out = data [0];

endmodule

module basys3_9
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    wire clock;
    wire resetn = ! btnU;

    clock_divider_100_MHz_to_1_49_Hz clock_divider_100_MHz_to_1_49_Hz
    (
        .clock_100_MHz (clk),
        .resetn        (resetn),
        .clock_1_49_Hz (clock)
    );

    clock_divider_100_MHz_to_95_4_Hz_and_1_53_KHz clock_divider_100_MHz_to_95_4_Hz_and_1_53_KHz
    (
        .clock_100_MHz  ( clk           ),
        .resetn         ( resetn        ),
        .clock_95_4_Hz  (               ),
        .clock_1_53_KHz ( display_clock )
    );

    shift_register_with_enable shift_register_with_enable
    (
        .clock      (   clock  ),
        .resetn     (   resetn ),
        .in         (   btnC   ),
        .enable     ( ~ btnR   ),
        .out        (          ),
        .data       (   led    )
    );

    display display
    (
        .clock          ( display_clock  ),
        .resetn         ( resetn         ),
        .number         ( led            ),

        .seven_segments ( seg            ),
        .dot            ( dp             ),
        .anodes         ( an             )
    );

endmodule

//--------------------------------------------------------------------

// Smiling Snail FSM derived from David Harris & Sarah Harris

module pattern_fsm_moore
(
    input  clock,
    input  resetn,
    input  a,
    output y
);

    parameter [1:0] S0 = 0, S1 = 1, S2 = 2;

    reg [1:0] state, next_state;

    // state register

    always @ (posedge clock or negedge resetn)
        if (! resetn)
            state <= S0;
        else
            state <= next_state;

    // next state logic

    always @*
        case (state)

        S0:
            if (a)
                next_state <= S0;
            else
                next_state <= S1;

        S1:
            if (a)
                next_state <= S2;
            else
                next_state <= S1;

        S2:
            if (a)
                next_state <= S0;
            else
                next_state <= S1;

        default:

            next_state <= S0;

        endcase

    // output logic

    assign y = (state == S2);

endmodule

//--------------------------------------------------------------------

module pattern_fsm_mealy
(
    input  clock,
    input  resetn,
    input  a,
    output y
);

    parameter S0 = 0, S1 = 1;

    reg state, next_state;

    // state register

    always @ (posedge clock or negedge resetn)
        if (! resetn)
            state <= S0;
        else
            state <= next_state;

    // next state logic

    always @*
        case (state)

        S0:
            if (a)
                next_state <= S0;
            else
                next_state <= S1;

        S1:
            if (a)
                next_state <= S0;
            else
                next_state <= S1;

        default:

            next_state <= S0;

        endcase

    // output logic

    assign y = (a & state == S1);

endmodule

//--------------------------------------------------------------------

module basys3_10
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

    wire clock;
    wire resetn = ! btnU;

    clock_divider_100_MHz_to_1_49_Hz clock_divider
    (
        .clock_100_MHz (clk),
        .resetn        (resetn),
        .clock_1_49_Hz (clock)
    );

    wire [15:0] shift_data_out;

    shift_register shift_register
    (
        .clock      ( clock          ),
        .resetn     ( resetn         ),
        .in         ( btnC           ),
        .out        (                ),
        .data       ( shift_data_out )
    );

    wire fsm_in = shift_data_out [8];
    assign led = shift_data_out;

    wire moore_out;

    pattern_fsm_moore pattern_fsm_moore
    (
        .clock  ( clock     ),
        .resetn ( resetn    ),
        .a      ( fsm_in    ),
        .y      ( moore_out )
    );

    wire mealy_out;

    pattern_fsm_mealy pattern_fsm_mealy
    (
        .clock  ( clock     ),
        .resetn ( resetn    ),
        .a      ( fsm_in    ),
        .y      ( mealy_out )
    );

    assign seg [0] = ~  moore_out;
    assign seg [1] = ~  moore_out;
    assign seg [2] = ~  mealy_out;
    assign seg [3] = ~  mealy_out;
    assign seg [4] = ~  mealy_out;
    assign seg [5] = ~  moore_out;
    assign seg [6] = ~ (moore_out | mealy_out);

    assign dp  = 1'b1;
    assign an  = 4'b1110;

endmodule

// Ripple-carry adder

// TODO module basys3_11

// Carry-lookahead adder

// TODO module basys3_12

// Prefix adder

// TODO module basys3_13

// Serial adder

// TODO module basys3_14

// Combinational multiplier

// TODO module basys3_15

// Sequential multiplier

// TODO module basys3_16

// Pipelined multiplier

// TODO module basys3_17

// Shift-register-based stack

// TODO module basys3_18

// Memory + pointer based stack

// TODO module basys3_19

// 

// TODO module basys3_20

/*

// Checking if the board is alive
// Combinational building block: multiplexor
// Combinational building block: decoder
// Combinational building block: encoder
// Combinational building block: seven-segment driver
// Sequential building block: counter
// Sequential building block: counter with load
// Sequential building block: shift register
// Sequential building block: shift register with enable
// Moore and Mealy state machines
// Ripple-carry adder
// Carry-lookahead adder
// Prefix adder
// Serial adder
// Combinational multiplier
// Sequential multiplier
// Pipelined multiplier
// Shift-register-based stack
// Memory + pointer based stack

Extra:

// Unary logic operations
// Serial parity circuit
// Pipelined adder
// Memory macro
// PLL macro
// Parametrized modules
// Using Verilog generate

A subset of MIPS processor:

// Single-cycle
// Sequential-cycle
// Single-issue in-order pipeline with stalls
// Single-issue in-order pipeline with forwarding
// Multiple-issue in-order pipeline

Interfacing:

// SPI master writing to a peripheral
// SPI master reading from a peripheral
// Microcontroller SPI master + SPI slave in FPGA driving 7-segment LED
// SPI master in FPGA + microcontroller SPI master driving OLED display
// Asynchronous data synchronizer to interface MCU and FPGA via GPIO

*/
