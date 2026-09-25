`timescale 1ns/1ps

module traffic_controller_tb;

    reg clk;
    reg reset;

    reg [1:0] traffic_n;
    reg [1:0] traffic_s;
    reg [1:0] traffic_e;
    reg [1:0] traffic_w;

    wire north_red;
    wire north_yellow;
    wire north_green;

    wire south_red;
    wire south_yellow;
    wire south_green;

    wire east_red;
    wire east_yellow;
    wire east_green;

    wire west_red;
    wire west_yellow;
    wire west_green;

    // Instantiate DUT
    traffic_controller #(
        .GREEN_TIME(4),
        .YELLOW_TIME(1),
        .ALL_RED_TIME(1)
    ) dut (
        .clk(clk),
        .reset(reset),

        .traffic_n(traffic_n),
        .traffic_s(traffic_s),
        .traffic_e(traffic_e),
        .traffic_w(traffic_w),

        .north_red(north_red),
        .north_yellow(north_yellow),
        .north_green(north_green),

        .south_red(south_red),
        .south_yellow(south_yellow),
        .south_green(south_green),

        .east_red(east_red),
        .east_yellow(east_yellow),
        .east_green(east_green),

        .west_red(west_red),
        .west_yellow(west_yellow),
        .west_green(west_green)
    );

    // Clock generation
    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end

    // Display traffic light state
    task display_state;
        begin

            $display(
                "TIME=%0t | N=%b S=%b E=%b W=%b | ",

                $time,
                traffic_n,
                traffic_s,
                traffic_e,
                traffic_w
            );

            if (north_green)
                $display("TRAFFIC LIGHT: NORTH/SOUTH GREEN");

            else if (north_yellow)
                $display("TRAFFIC LIGHT: NORTH/SOUTH YELLOW");

            else if (east_green)
                $display("TRAFFIC LIGHT: EAST/WEST GREEN");

            else if (east_yellow)
                $display("TRAFFIC LIGHT: EAST/WEST YELLOW");

            else
                $display("TRAFFIC LIGHT: ALL RED");

        end
    endtask

    // Monitor state changes
    always @(posedge clk) begin
        display_state();
    end

    // Test sequence
    initial begin

        // Create waveform
        $dumpfile("traffic.vcd");
        $dumpvars(0, traffic_controller_tb);

        // Initial values
        reset    = 1;

        traffic_n = 2'b00;
        traffic_s = 2'b00;
        traffic_e = 2'b00;
        traffic_w = 2'b00;

        $display("---------------------------------------------");
        $display("SMART TRAFFIC MANAGEMENT SYSTEM");
        $display("---------------------------------------------");

        // Reset
        #12;

        reset = 0;

        // Test 1: High North traffic
        traffic_n = 2'b11;
        traffic_s = 2'b10;
        traffic_e = 2'b01;
        traffic_w = 2'b00;

        $display("\nTEST 1: HIGH NORTH-SOUTH TRAFFIC");

        #80;

        // Test 2: High East-West traffic
        traffic_n = 2'b00;
        traffic_s = 2'b01;
        traffic_e = 2'b11;
        traffic_w = 2'b10;

        $display("\nTEST 2: HIGH EAST-WEST TRAFFIC");

        #80;

        // Test 3: Equal traffic
        traffic_n = 2'b01;
        traffic_s = 2'b01;
        traffic_e = 2'b01;
        traffic_w = 2'b01;

        $display("\nTEST 3: EQUAL TRAFFIC");

        #80;

        // Test 4: Heavy East traffic
        traffic_n = 2'b00;
        traffic_s = 2'b00;
        traffic_e = 2'b11;
        traffic_w = 2'b00;

        $display("\nTEST 4: HEAVY EAST TRAFFIC");

        #80;

        // Test 5: Heavy South traffic
        traffic_n = 2'b00;
        traffic_s = 2'b11;
        traffic_e = 2'b00;
        traffic_w = 2'b00;

        $display("\nTEST 5: HEAVY SOUTH TRAFFIC");

        #80;

        $display("\n---------------------------------------------");
        $display("SIMULATION COMPLETED");
        $display("---------------------------------------------");

        $finish;

    end

endmodule