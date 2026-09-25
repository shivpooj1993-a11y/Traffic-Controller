`timescale 1ns/1ps

module traffic_controller #(
    parameter GREEN_TIME  = 4,
    parameter YELLOW_TIME = 1,
    parameter ALL_RED_TIME = 1
)(
    input  wire       clk,
    input  wire       reset,

    input  wire [1:0] traffic_n,
    input  wire [1:0] traffic_s,
    input  wire [1:0] traffic_e,
    input  wire [1:0] traffic_w,

    output reg north_red,
    output reg north_yellow,
    output reg north_green,

    output reg south_red,
    output reg south_yellow,
    output reg south_green,

    output reg east_red,
    output reg east_yellow,
    output reg east_green,

    output reg west_red,
    output reg west_yellow,
    output reg west_green
);

    // State definitions
    localparam NS_GREEN  = 3'd0;
    localparam NS_YELLOW = 3'd1;
    localparam EW_GREEN  = 3'd2;
    localparam EW_YELLOW = 3'd3;
    localparam ALL_RED   = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    reg [31:0] timer;

    reg last_direction;

    // 0 = North/South
    // 1 = East/West

    reg [3:0] ns_traffic;
    reg [3:0] ew_traffic;

    // Calculate traffic demand
    always @(*) begin
        ns_traffic = traffic_n + traffic_s;
        ew_traffic = traffic_e + traffic_w;
    end

    // State register and timer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state          <= NS_GREEN;
            timer          <= 0;
            last_direction <= 0;
        end
        else begin

            if (timer < 32'hFFFFFFFF)
                timer <= timer + 1;

            case (state)

                NS_GREEN: begin
                    if (timer >= GREEN_TIME-1) begin
                        state <= NS_YELLOW;
                        timer <= 0;
                    end
                end

                NS_YELLOW: begin
                    if (timer >= YELLOW_TIME-1) begin
                        state <= ALL_RED;
                        timer <= 0;
                    end
                end

                EW_GREEN: begin
                    if (timer >= GREEN_TIME-1) begin
                        state <= EW_YELLOW;
                        timer <= 0;
                    end
                end

                EW_YELLOW: begin
                    if (timer >= YELLOW_TIME-1) begin
                        state <= ALL_RED;
                        timer <= 0;
                    end
                end

                ALL_RED: begin
                    if (timer >= ALL_RED_TIME-1) begin

                        // Select next direction based on traffic
                        if (ns_traffic > ew_traffic) begin
                            state <= NS_GREEN;
                            last_direction <= 0;
                        end
                        else if (ew_traffic > ns_traffic) begin
                            state <= EW_GREEN;
                            last_direction <= 1;
                        end
                        else begin
                            // Equal traffic:
                            // alternate direction
                            if (last_direction == 0) begin
                                state <= EW_GREEN;
                                last_direction <= 1;
                            end
                            else begin
                                state <= NS_GREEN;
                                last_direction <= 0;
                            end
                        end

                        timer <= 0;
                    end
                end

                default: begin
                    state <= NS_GREEN;
                    timer <= 0;
                end

            endcase
        end
    end

    // Output decoder
    always @(*) begin

        // Default: all red
        north_red    = 1;
        north_yellow = 0;
        north_green  = 0;

        south_red    = 1;
        south_yellow = 0;
        south_green  = 0;

        east_red     = 1;
        east_yellow  = 0;
        east_green   = 0;

        west_red     = 1;
        west_yellow  = 0;
        west_green   = 0;

        case (state)

            NS_GREEN: begin
                north_red   = 0;
                north_green = 1;

                south_red   = 0;
                south_green = 1;
            end

            NS_YELLOW: begin
                north_red    = 0;
                north_yellow = 1;

                south_red    = 0;
                south_yellow = 1;
            end

            EW_GREEN: begin
                east_red   = 0;
                east_green = 1;

                west_red   = 0;
                west_green = 1;
            end

            EW_YELLOW: begin
                east_red    = 0;
                east_yellow = 1;

                west_red    = 0;
                west_yellow = 1;
            end

            ALL_RED: begin
                // All signals remain red
            end

            default: begin
                // All signals remain red
            end

        endcase
    end

endmodule
