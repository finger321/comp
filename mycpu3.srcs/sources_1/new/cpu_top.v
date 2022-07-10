// Add your code here, or replace this file
module cpu_top (
    input  wire clk_i,
    input  wire rst_i,
    input wire [23:0] switch, 
    output wire [7:0] led_en,
    output wire [23:0]led,
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o
);

wire pll_clk;
wire clk_lock;

cpuclk u_cpuclk (
    .clk_in1    (clk_i),
    .locked     (clk_lock),
    .clk_out1   (pll_clk)
);
wire rst_n = !rst_i;
//(*mark_debug="true"*)wire [31:0]trace_result;
wire [31:0]trace_result;
wire [31:0] inst;
wire [31:0] RD;
wire [31:0] pc;
wire [31:0] C;
wire [31:0] rD2;
wire WE;



CPU u_cpu(
    // input
    .clk(pll_clk),
    .rst_n(rst_n),
    .inst(inst),
    .RD(RD),
    // output 
    .pc(pc),
    .C(C),
    .rD2(rD2),
    .DRAM_WE(WE),
    .trace_result(trace_result)
);
//assign led=24'hffffff;
prgrom imem(
    .a (pc[15:2]),
    .spo (inst)
);
//wire [31:0] waddr_tmp = C - 16'h4000;
//dram dmem(
//    .clk(pll_clk),
//    .a  (waddr_tmp[15:2]),
//    .spo(RD),
//    .we (DRAM_WE),
//    .d  (rD2)
//);
wire [31:0] result;
BUS u_BUS(
  .clk(pll_clk),
  .rst(rst_i),
  .switch(switch),
  .addr(C),
  .din(rD2),
  .result(result),
  .wen(WE),
  .read_data(RD),
  .led(led)
);

RES_DISPLAY u_res_display(
    .clk(pll_clk),
    .rst(rst_i),
    .cal_result(result),
    .led_en(led_en),
    .led_ca(led_ca_o),
    .led_cb(led_cb_o),
    .led_cc(led_cc_o),
    .led_cd(led_cd_o),
    .led_ce(led_ce_o),
    .led_cf(led_cf_o),
    .led_cg(led_cg_o),
    .led_dp(led_dp_o)
);
endmodule
