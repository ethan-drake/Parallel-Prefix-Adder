module adder (
	srca,
	srcb,
	cin,
	is_signed,
	result,
	cout,
	zero_f,
	ov_f
);
	parameter WIDTH = 4;
	input wire [WIDTH - 1:0] srca;
	input wire [WIDTH - 1:0] srcb;
	input wire cin;
	input wire is_signed;
	output wire [WIDTH - 1:0] result;
	output wire cout;
	output wire zero_f;
	output wire ov_f;
	localparam LEVELS = $clog2(WIDTH);
	wire [(LEVELS >= 0 ? ((LEVELS + 1) * WIDTH) - 1 : ((1 - LEVELS) * WIDTH) + ((LEVELS * WIDTH) - 1)):(LEVELS >= 0 ? 0 : LEVELS * WIDTH)] g;
	wire [(LEVELS >= 0 ? ((LEVELS + 1) * WIDTH) - 1 : ((1 - LEVELS) * WIDTH) + ((LEVELS * WIDTH) - 1)):(LEVELS >= 0 ? 0 : LEVELS * WIDTH)] p;
	wire [WIDTH:0] c;
	assign g[(LEVELS >= 0 ? 0 : LEVELS) * WIDTH] = (srca[0] & srcb[0]) | (p[(LEVELS >= 0 ? 0 : LEVELS) * WIDTH] & cin);
	assign g[((LEVELS >= 0 ? 0 : LEVELS) * WIDTH) + ((WIDTH - 1) >= 1 ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= 1 ? WIDTH - 1 : 3 - WIDTH)) - 1)-:((WIDTH - 1) >= 1 ? WIDTH - 1 : 3 - WIDTH)] = srca[WIDTH - 1:1] & srcb[WIDTH - 1:1];
	assign p[(LEVELS >= 0 ? 0 : LEVELS) * WIDTH+:WIDTH] = srca ^ srcb;
	assign c[0] = cin;
	genvar _gv_i_1;
	genvar _gv_j_1;
	generate
		for (_gv_i_1 = 1; _gv_i_1 <= LEVELS; _gv_i_1 = _gv_i_1 + 1) begin : level
			localparam i = _gv_i_1;
			localparam S = 1 << (i - 1);
			assign p[((LEVELS >= 0 ? i : LEVELS - i) * WIDTH) + ((WIDTH - 1) >= S ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)) - 1)-:((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)] = p[((LEVELS >= 0 ? i - 1 : LEVELS - (i - 1)) * WIDTH) + ((WIDTH - 1) >= S ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)) - 1)-:((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)] & p[((LEVELS >= 0 ? i - 1 : LEVELS - (i - 1)) * WIDTH) + (((WIDTH - 1) - S) >= 0 ? (WIDTH - 1) - S : (((WIDTH - 1) - S) + (((WIDTH - 1) - S) >= 0 ? ((WIDTH - 1) - S) + 1 : 1 - ((WIDTH - 1) - S))) - 1)-:(((WIDTH - 1) - S) >= 0 ? ((WIDTH - 1) - S) + 1 : 1 - ((WIDTH - 1) - S))];
			assign g[((LEVELS >= 0 ? i : LEVELS - i) * WIDTH) + ((WIDTH - 1) >= S ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)) - 1)-:((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)] = g[((LEVELS >= 0 ? i - 1 : LEVELS - (i - 1)) * WIDTH) + ((WIDTH - 1) >= S ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)) - 1)-:((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)] | (p[((LEVELS >= 0 ? i - 1 : LEVELS - (i - 1)) * WIDTH) + ((WIDTH - 1) >= S ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)) - 1)-:((WIDTH - 1) >= S ? ((WIDTH - 1) - S) + 1 : (S - (WIDTH - 1)) + 1)] & g[((LEVELS >= 0 ? i - 1 : LEVELS - (i - 1)) * WIDTH) + (((WIDTH - 1) - S) >= 0 ? (WIDTH - 1) - S : (((WIDTH - 1) - S) + (((WIDTH - 1) - S) >= 0 ? ((WIDTH - 1) - S) + 1 : 1 - ((WIDTH - 1) - S))) - 1)-:(((WIDTH - 1) - S) >= 0 ? ((WIDTH - 1) - S) + 1 : 1 - ((WIDTH - 1) - S))]);
			assign p[((LEVELS >= 0 ? i : LEVELS - i) * WIDTH) + (S - 1)-:S] = p[((LEVELS >= 0 ? i - 1 : LEVELS - (i - 1)) * WIDTH) + (S - 1)-:S];
			assign g[((LEVELS >= 0 ? i : LEVELS - i) * WIDTH) + (S - 1)-:S] = g[((LEVELS >= 0 ? i - 1 : LEVELS - (i - 1)) * WIDTH) + (S - 1)-:S];
		end
	endgenerate
	assign c[WIDTH:1] = g[((LEVELS >= 0 ? LEVELS : LEVELS - LEVELS) * WIDTH) + (WIDTH - 1)-:WIDTH];
	assign result[0] = p[(LEVELS >= 0 ? 0 : LEVELS) * WIDTH] ^ c[0];
	assign result[WIDTH - 1:1] = p[((LEVELS >= 0 ? 0 : LEVELS) * WIDTH) + ((WIDTH - 1) >= 1 ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= 1 ? WIDTH - 1 : 3 - WIDTH)) - 1)-:((WIDTH - 1) >= 1 ? WIDTH - 1 : 3 - WIDTH)] ^ g[((LEVELS >= 0 ? LEVELS : LEVELS - LEVELS) * WIDTH) + ((WIDTH - 2) >= 0 ? WIDTH - 2 : ((WIDTH - 2) + ((WIDTH - 2) >= 0 ? WIDTH - 1 : 3 - WIDTH)) - 1)-:((WIDTH - 2) >= 0 ? WIDTH - 1 : 3 - WIDTH)];
	assign cout = c[WIDTH];
	assign zero_f = result == 0;
	assign ov_f = (is_signed ? c[WIDTH - 1] ^ c[WIDTH] : c[WIDTH]);
endmodule
