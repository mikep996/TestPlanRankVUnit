// (c) Aldec, Inc.
// All rights reserved.
//
// Last modified: $Date: 2015-02-26 08:24:56 +0100 (Thu, 26 Feb 2015) $
// $Revision: 357294 $
// VUnit modification: 2024-11-18 14:56 (Mon, 18 Nov 2024)

//`include "/home/mibar/.local/vunit_org/lib/python3.12/site-packages/vunit/verilog/vunit_pkg.sv"
//`include "/home/mibar/.local/vunit_org/lib/python3.12/site-packages/vunit/verilog/include/vunit_defines.svh"

`include "vunit_defines.svh"

module tb;

    parameter TEST = 0;
    bit clk;
    bit reset;
    integer fd_in;
    integer fd_out;
    logic done;
          
    `TEST_SUITE begin
        `TEST_SUITE_SETUP begin
            // Here you will typically place things that are common to
            // all tests, such as asserting the reset signal and starting
            // the clock(s).
            $display("Running test suite setup code");
        end
        `TEST_CASE("TEST_1") begin
            $display("Encryption Test 1");
            fd_in = $fopen("../../input/msg1.in", "r");
            fd_out = $fopen("../../output/msg1.out");
            test(fd_in, fd_out);
        end
        `TEST_CASE("TEST_2") begin
            $display("Encryption Test 2");
            fd_in = $fopen("../../input/msg2.in","r");
            fd_out = $fopen("../../output/msg2.out");
            test(fd_in, fd_out);
        end
        `TEST_CASE("TEST_3") begin
            $display("Encryption Test 3");
            fd_in = $fopen("../../input/msg3.in","r");
            fd_out = $fopen("../../output/msg3.out");
            test(fd_in, fd_out);
        end
        `TEST_CASE("TEST_4") begin
            $display("Encryption Test 4");
            fd_in = $fopen("../../input/msg4.in","r");
            fd_out = $fopen("../../output/msg4.out");
            test(fd_in, fd_out);
        end
        `TEST_CASE("TEST_5") begin
            $display("Encryption Test 5");
            fd_in = $fopen("../../input/msg5.in","r");
            fd_out = $fopen("../../output/msg5.out");
            test(fd_in, fd_out);
        end
        `TEST_CASE("TEST_6") begin
            $display("Encryption Test 6");
            fd_in = $fopen("../../input/msg6.in","r");
            fd_out = $fopen("../../output/msg6.out");
            test(fd_in, fd_out);
       end
        `TEST_CASE_CLEANUP begin
            $display("Cleaning up after a test case");
        end

        `TEST_SUITE_CLEANUP begin
            // This section will run last before the TEST_SUITE block
            // exits. In many cases this section will not be needed.
            $display("Cleaning up after running the complete test suite");
        end
    end

    base64_enc dut(.clk(clk),.reset(reset),.fd_in(fd_in),.fd_out(fd_out),.complete(done));

    // clock generator
    always
    	#25 clk = ~clk;

    task automatic test(fd_in, fd_out);
        #100 reset = 1'b1; // reset done
        fork
        	@(posedge done);
        	#100000;
        join_any
        if (done)
        	$info("Encryption done");
        else
        	$warning("Encryption failed - timeout");
        $fclose(fd_in);
        $fclose(fd_out);
		#10;
    endtask
   
endmodule








