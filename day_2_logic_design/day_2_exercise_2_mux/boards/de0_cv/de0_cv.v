module mux_2_1
(
    input  [1:0] d0,
    input  [1:0] d1,
    input        sel,
    output [1:0] y
);

    assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------

module mux_4_1_imp_1
(
    input  [1:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [1:0] y
);

    assign y = sel [1]
        ? (sel [0] ? d3 : d2)
        : (sel [0] ? d1 : d0);

endmodule

//----------------------------------------------------------------------------

module mux_4_1_imp_2
(
    input      [1:0] d0, d1, d2, d3,
    input      [1:0] sel,
    output reg [1:0] y
);

    always @*
        case (sel)
        2'b00: y = d0;
        2'b01: y = d1;
        2'b10: y = d2;
        2'b11: y = d3;
        endcase

endmodule

//----------------------------------------------------------------------------

module mux_4_1_imp_3
(
    input  [1:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [1:0] y
);

    wire [1:0] w01, w23;

    mux_2_1 i0 (.d0 ( d0  ), .d1 ( d1  ), .sel (sel [0]), .y ( w01 ));
    mux_2_1 i1 (.d0 ( d2  ), .d1 ( d3  ), .sel (sel [0]), .y ( w23 ));
    mux_2_1 i2 (.d0 ( w01 ), .d1 ( w23 ), .sel (sel [1]), .y ( y   ));

endmodule

//----------------------------------------------------------------------------

module mux_4_1_bits_1
(
    input        d0, d1, d2, d3,
    input  [1:0] sel,
    output       y
);

    assign y = sel [1]
        ? (sel [0] ? d3 : d2)
        : (sel [0] ? d1 : d0);

endmodule

//----------------------------------------------------------------------------

module mux_4_1_imp_4
(
    input  [1:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [1:0] y
);

    mux_4_1_bits_1 high
    (
        .d0  ( d0 [1] ),
        .d1  ( d1 [1] ),
        .d2  ( d2 [1] ),
        .d3  ( d3 [1] ),
        .sel ( sel    ),
        .y   ( y  [1] )
    );

    mux_4_1_bits_1 low
    (
        .d0  ( d0 [0] ),
        .d1  ( d1 [0] ),
        .d2  ( d2 [0] ),
        .d3  ( d3 [0] ),
        .sel ( sel    ),
        .y   ( y  [0] )
    );

endmodule

//----------------------------------------------------------------------------

module de0_cv_small
(
    input  [3:0] KEY,
    input  [9:0] SW,
    output [9:0] LEDR
);
/*
    mux_4_1_imp_1
    (
        .d0  ( SW   [1:0] ),
        .d1  ( SW   [3:2] ),
        .d2  ( SW   [5:4] ),
        .d3  ( SW   [7:6] ),
        .sel ( KEY  [1:0] ),
        .y   ( LEDR [1:0] )
    ); 
*/
    mux_4_1_imp_2
    (
        .d0  ( SW   [1:0] ),
        .d1  ( SW   [3:2] ),
        .d2  ( SW   [5:4] ),
        .d3  ( SW   [7:6] ),
        .sel ( KEY  [1:0] ),
        .y   ( LEDR [3:2] )
    ); 
        
    mux_4_1_imp_3
    (
        .d0  ( SW   [1:0] ),
        .d1  ( SW   [3:2] ),
        .d2  ( SW   [5:4] ),
        .d3  ( SW   [7:6] ),
        .sel ( KEY  [1:0] ),
        .y   ( LEDR [5:4] )
    ); 

    mux_4_1_imp_4
    (
        .d0  ( SW   [1:0] ),
        .d1  ( SW   [3:2] ),
        .d2  ( SW   [5:4] ),
        .d3  ( SW   [7:6] ),
        .sel ( KEY  [1:0] ),
        .y   ( LEDR [7:6] )
    ); 
    */
endmodule

//----------------------------------------------------------------------------

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
         .KEY  ( KEY  ),
         .SW   ( SW   ),
         .LEDR ( LEDR )
    );

endmodule
