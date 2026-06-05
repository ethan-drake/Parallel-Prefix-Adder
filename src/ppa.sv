// Code your design here
module adder #(parameter WIDTH=4) (
  	input logic [WIDTH-1:0] srca,
    input logic [WIDTH-1:0] srcb,
    input logic cin,
    input logic is_signed,
    output logic [WIDTH-1:0] result,
    output logic cout,
    output logic zero_f,
    output logic ov_f
);
  localparam LEVELS = $clog2(WIDTH);
  logic [LEVELS:0][WIDTH-1:0] g, p;
  logic [WIDTH:0] c;
  assign g[0] = srca & srcb;          
  assign p[0] = srca ^ srcb;          
  // generate
  // propagate
  assign c[0] = cin;
  
  genvar i,j;
  generate
    for (i=1; i < WIDTH; i++) begin: level
    	//association
      //for (j=1; j < WIDTH; j++) begin: pg_node
        //p[i][j]= p[i-1][j] & p[i-1][j-(1<<(i-1))];
        //g[i][j]= g[i-1][j] | (p[i-1][j] &  g[i-1][j-(1<<(i-1))]) ;
          assign p[i]= p[i-1] & (p[i-1]<<(1<<(i-1)));
		  assign g[i]= g[i-1] | (p[i-1] & (g[i-1]<<(1<<(i-1))));
      //end
    end
  endgenerate
  

  
  assign result  = p ^ c[WIDTH-1:0];
  assign cout = c[WIDTH];

  assign zero_f = (result==0);
  assign ov_f = is_signed ? ((c[WIDTH-1]) ^ (c[WIDTH])) : c[WIDTH];
  
endmodule
