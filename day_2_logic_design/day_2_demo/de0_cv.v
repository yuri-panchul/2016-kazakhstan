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

    de0_cv_small_0 de0_cv_small_0
    (
         .CLOCK_50  ( CLOCK_50 ),
         .RESET_N   ( RESET_N  ),

         .KEY       ( KEY      ),
         .SW        ( SW       ),

         .LEDR      ( LEDR     ),

         .HEX0      ( HEX0     ),
         .HEX1      ( HEX1     ),
         .HEX2      ( HEX2     ),
         .HEX3      ( HEX3     ),
         .HEX4      ( HEX4     ),
         .HEX5      ( HEX5     )
    );

endmodule

//----------------------------------------------------------------------------

module de0_cv_small_0
(
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
    output  [ 6:0]  HEX5
);

    assign LEDR = SW;
    
    assign HEX0 = SW | KEY;
    assign HEX1 = SW | KEY;
    assign HEX2 = SW | KEY;
    assign HEX3 = SW | KEY;
    assign HEX4 = SW | KEY;
    assign HEX5 = SW | KEY;

/*
    seven_segment_display digit_5 ( IO_7_SegmentHEX [23:20] , HEX5 );
    seven_segment_display digit_4 ( IO_7_SegmentHEX [19:16] , HEX4 );
    seven_segment_display digit_3 ( IO_7_SegmentHEX [15:12] , HEX3 );
    seven_segment_display digit_2 ( IO_7_SegmentHEX [11: 8] , HEX2 );
    seven_segment_display digit_1 ( IO_7_SegmentHEX [ 7: 4] , HEX1 );
    seven_segment_display digit_0 ( IO_7_SegmentHEX [ 3: 0] , HEX0 );
*/

endmodule

