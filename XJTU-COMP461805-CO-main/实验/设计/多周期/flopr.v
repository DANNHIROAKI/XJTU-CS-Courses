//被实例化为指令寄存器，用于根据信号存储或者复位指令，还有输出指令

module flopr #(parameter WIDTH = 8)
              (clk, rst, d, q);
   input              clk;
   input              rst;
   input  [WIDTH-1:0] d;
   output [WIDTH-1:0] q;
   
   reg [WIDTH-1:0] q_r;
               
   always @(posedge clk or posedge rst) begin
      if ( rst ) 
         q_r <= 0;
      else 
         q_r <= d;
   end // end always
   
   assign q = q_r;
      
endmodule

