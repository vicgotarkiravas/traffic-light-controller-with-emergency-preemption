`timescale 1ns/1ps

module traffic_light_fsm (
    input  logic clk,
    input  logic rst_n,
    input  logic side_car,
    input  logic emergency,
    output logic [1:0] main_lights, // 2'b00: Red, 2'b01: Yellow, 2'b10: Green
    output logic [1:0] side_lights
);

    typedef enum logic [2:0] {
        S_MAIN_GREEN  = 3'd0,
        S_MAIN_YELLOW = 3'd1,
        S_ALL_RED1    = 3'd2,
        S_SIDE_GREEN  = 3'd3,
        S_SIDE_YELLOW = 3'd4,
        S_ALL_RED2    = 3'd5,
        S_EMERGENCY   = 3'd6
    } state_t;

    state_t state, next_state;
    logic [3:0] timer;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_MAIN_GREEN;
            timer <= '0;
        end else if (emergency) begin
            state <= S_EMERGENCY;
            timer <= '0;
        end else begin
            if (state != next_state) begin
                state <= next_state;
                timer <= '0;
            end else begin
                timer <= timer + 1'b1;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            S_MAIN_GREEN:  if (side_car && timer >= 4'd5) next_state = S_MAIN_YELLOW;
            S_MAIN_YELLOW: if (timer >= 4'd2) next_state = S_ALL_RED1;
            S_ALL_RED1:    if (timer >= 4'd1) next_state = S_SIDE_GREEN;
            S_SIDE_GREEN:  if (timer >= 4'd4 || !side_car) next_state = S_SIDE_YELLOW;
            S_SIDE_YELLOW: if (timer >= 4'd2) next_state = S_ALL_RED2;
            S_ALL_RED2:    if (timer >= 4'd1) next_state = S_MAIN_GREEN;
            S_EMERGENCY:   if (!emergency && timer >= 4'd3) next_state = S_MAIN_GREEN;
            default:       next_state = S_MAIN_GREEN;
        endcase
    end

    always_comb begin
        main_lights = 2'b00;
        side_lights = 2'b00;
        case (state)
            S_MAIN_GREEN:  begin main_lights = 2'b10; side_lights = 2'b00; end
            S_MAIN_YELLOW: begin main_lights = 2'b01; side_lights = 2'b00; end
            S_SIDE_GREEN:  begin main_lights = 2'b00; side_lights = 2'b10; end
            S_SIDE_YELLOW: begin main_lights = 2'b00; side_lights = 2'b01; end
            S_EMERGENCY:   begin main_lights = 2'b10; side_lights = 2'b00; end // Clear main path
            default:       begin main_lights = 2'b00; side_lights = 2'b00; end // All red
        endcase
    end

endmodule
