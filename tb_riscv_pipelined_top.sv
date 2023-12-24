//test bench for top file of riscv

module tb_riscv_pipelined_top();
   parameter DW                  = 32;
   parameter REG_SIZE            = 32;
   parameter NO_OF_REGS_REG_FILE = 32;
   parameter MEM_SIZE_IN_KB      = 1;
   parameter ADDENT = 4;
   parameter ADDRW               = 12;
   parameter NO_OF_SEGS          = 8;

   logic clk_i;
   logic rst_i;
   logic t_intr;   //timer interrupt
   logic e_intr;   //external interrupt
   
   logic [NO_OF_SEGS-1:0] anode;
   logic [6:0]            display;


riscv_pipelined_top #(
   .DW                 (DW                 ),
   .REG_SIZE           (REG_SIZE           ),
   .NO_OF_REGS_REG_FILE(NO_OF_REGS_REG_FILE),
   .MEM_SIZE_IN_KB     (MEM_SIZE_IN_KB     ),
   .ADDENT             (ADDENT             ),
   .ADDRW              (ADDRW              ),
   .NO_OF_SEGS         (NO_OF_SEGS         )

)i_riscv_pipelined_top(
   .clk_fpga(clk_i  ),
   .rst_i   (rst_i  ),
   .t_intr  (t_intr ),
   .e_intr  (e_intr ),
   .anode   (anode  ),
   .display (display)
);

   initial begin
      clk_i = 0;
      forever begin
         #5; clk_i = ~clk_i;
      end
   end

   initial begin
      fork
         reset();
      join
   end

   task reset();
                        rst_i <=    0;
      @(posedge clk_i); rst_i <= #1 1;   
                    #7; rst_i <= #1 0;
   endtask

   initial begin
      repeat(100) begin
         $display("PC = %3d, Instr = %8h, forward_a = %0b, forward_b = %0b, reg_write = %0b", i_riscv_pipelined_top.pc_d, i_riscv_pipelined_top.instr_d, i_riscv_pipelined_top.forward_a, i_riscv_pipelined_top.forward_b, i_riscv_pipelined_top.reg_write_m);
         $display("Stall_FD = %0b, Stall_MW = %0b", i_riscv_pipelined_top.stall_fd, i_riscv_pipelined_top.stall_mw);
         $display("inst: %8h, asm: %s\n\n", i_riscv_pipelined_top.instr_d, print(i_riscv_pipelined_top.instr_d));
         @(posedge clk_i);
      end
   end

   initial begin
      e_intr = 0;
      t_intr = 0;
      repeat(20) @(posedge clk_i); 
      t_intr = 1; //1
      
      repeat(2) @(posedge clk_i);
      t_intr = 0;
      repeat(15) @(posedge clk_i);
      e_intr = 0; //1
      @(posedge clk_i);
      e_intr = 0;

      #30;
      $finish;
   end

   function string print(logic [DW-1:0] inst);
      string as;
      case(inst)
         32'h00400193: as = "addi x3, x0, 4";
         32'h0801c463: as = "blt x3, x0, 136";
         32'h00000033: as = "add x0, x0, x0";
         32'h06018e63: as = "beq x3, x0, 124";
         32'h00200093: as = "addi x1, x0, 2";
         32'h06118e63: as = "beq x3, x1, two";
         32'h00300233: as = "add x4, x0, x3";
         32'h00300133: as = "add x2, x0, x3";
         32'h00128293: as = "addi x5, x5, 1";
         32'hfff10113: as = "addi x2, x2, -1";
         32'h004001b3: as = "add x3, x0, x4";
         32'h0280006f: as = "j multiply";
         32'hfe1116e3: as = "bne x2, x1, find";
         32'h0480006f: as = "j stop";
         32'h00320233: as = "add x4, x4, x3";
         32'h002003b3: as = "add x7, x0, x2";
         32'hfff38393: as = "addi x7, x7, -1";
         32'hfe539ce3: as = "bne x7, x5, multiply1";
         32'hfcdff06f: as = "j done";
         32'h00100213: as = "addi x4, x0, 1";

      endcase
      print = as;
   endfunction
endmodule
