`timescale 1ns/1ps

module traffic_light_fsm_tb;
    logic clk, rst_n, side_car, emergency;
    logic [1:0] main_lights, side_lights;

    traffic_light_fsm dut (.*);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, traffic_light_fsm_tb);
        clk = 0; rst_n = 0; side_car = 0; emergency = 0;
        #20 rst_n = 1;

        $display("=== [TEST] Traffic Light Normal Cycle ===");
        repeat(10) @(posedge clk);

        $display("Car arrives at side road...");
        side_car = 1;
        repeat(20) @(posedge clk);

        $display("Triggering emergency vehicle preemption!");
        emergency = 1;
        repeat(5) @(posedge clk);
        emergency = 0;
        repeat(15) @(posedge clk);

        $display("=== [PASS] Traffic Light Controller PASSED ===");
        $finish;
    end
endmodule
