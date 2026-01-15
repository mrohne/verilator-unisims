module ODDR #(
    parameter DDR_CLK_EDGE = "OPPOSITE_EDGE",
    parameter INIT = 1'b0,
    parameter SRTYPE = "SYNC"
)(
    output logic Q,
    input  logic C,
    input  logic CE,
    input  logic D1,
    input  logic D2,
    input  logic R,
    input  logic S
);

    logic d1_reg, d2_reg;

    // Capture D1 on rising edge, D2 on falling edge (simplified)
    always_ff @(posedge C) begin
        if (R)          d1_reg <= 1'b0;
        else if (S)     d1_reg <= 1'b1;
        else if (CE)    d1_reg <= D1;
    end

    always_ff @(negedge C) begin
        if (R)          d2_reg <= 1'b0;
        else if (S)     d2_reg <= 1'b1;
        else if (CE)    d2_reg <= D2;
    end

    // The output muxes between the two captured values based on clock state
    assign Q = C ? d1_reg : d2_reg;

endmodule // ODDR

