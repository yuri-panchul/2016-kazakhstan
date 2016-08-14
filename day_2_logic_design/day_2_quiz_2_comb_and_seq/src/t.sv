module dut1                              
(                                        
    input              clk,              
    input        [7:0] d,                
    output logic [7:0] q                 
);                                       
    always @(posedge clk)                
        q <= d;                          
                                         
endmodule                                


module dut3                              
(                                        
    input              clk,              
    input        [7:0] d,                
    output logic [7:0] q                 
);                                       
    logic [7:0] r;                       
                                         
    always @(posedge clk)                
    begin                                
        r <= d;                          
        q <= r;                          
    end                                  
                                         
endmodule                                


module dut5                              
(                                        
    input              clk,              
    input        [7:0] d,                
    output logic [7:0] q                 
);                                       
    always @*                            
        q = d;                           
                                         
endmodule                                


module dut7                              
(                                        
    input              clk,              
    input        [7:0] d,                
    output logic [7:0] q                 
);                                       
    logic [7:0] r;                       
                                         
    always @(posedge clk)                
        r <= d;                          
                                         
    always @(posedge clk)                
        q <= r;                          
                                         
endmodule                                


module dut9                              
(                                        
    input              clk,              
    input        [7:0] d,                
    output logic [7:0] q                 
);                                       
    logic [7:0] r;                       
                                         
    always @*                            
        r = d;                           
                                         
    always @(posedge clk)                
        q <= r;                          
                                         
endmodule                                


module dut11                             
(                                           
    input              clk,                 
    input        [7:0] d,                   
    output logic [7:0] q                    
);                                          
    logic [7:0] r;                       
                                            
    assign r = d;                                  
                                            
    always @(posedge clk)                   
        q <= r;                             
                                            
endmodule                                   


module dut13                             
(                                        
    input              clk,              
    input        [7:0] d,                
    output logic [7:0] q                 
);                                       
    logic [7:0] r;                       
                                         
    assign r = d;                        
    assign q = r;                        
                                         
endmodule                                


module dut15  // _not_a_good_style            
(                                        
    input              clk,              
    input        [7:0] d,                
    output logic [7:0] q                 
);                                       
    logic [7:0] r;                       
                                         
    always @(posedge clk)                
    begin                                
        r = d;                           
        q <= r;                          
    end                                  
                                         
endmodule                                


module dut2                                                      
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
    always_ff @(posedge clk)    
        q <= d;                 
                                
endmodule                       
                                
                                
module dut4                     
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
    logic [7:0] r;              
                                
    always @(posedge clk)       
    begin                       
        q <= r;                 
        r <= d;                 
    end                         
                                
endmodule                       
                                
                                
module dut6                     
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
    always_comb                 
        q = d;                  
                                
endmodule                       
                                
                                
module dut8                     
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
    logic [7:0] r;              
                                
    always @(posedge clk)       
        q <= r;                 
                                
    always @(posedge clk)       
        r <= d;                 
                                
endmodule                       
                                
                                
module dut10                    
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
    logic [7:0] r;              
                                
    always @(posedge clk)       
        q <= r;                 
                                
    always @*                   
        r = d;                  
                                
endmodule                       
                                
                                
module dut12                    
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
                                
                                
    wire [7:0] r = d;           
                                
    always @(posedge clk)       
        q <= r;                 
                                
endmodule                       
                                
                                
module dut14                    
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
    logic [7:0] r;              
                                
    assign q = r;               
    assign r = d;               
                                
endmodule                       
                                
                                
module dut16  // _bad_style          
(                               
    input              clk,     
    input        [7:0] d,       
    output logic [7:0] q        
);                              
    logic [7:0] r;              
                                
    always @(posedge clk)       
    begin                       
        q <= r;                 
        r = d;                  
    end                         
                                
endmodule                       
                                