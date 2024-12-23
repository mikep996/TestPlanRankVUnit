// (c) Aldec, Inc.
// All rights reserved.
//
// Last modified: $Date: 2020-09-04 12:05:52 +0200 (Fri, 04 Sep 2020) $
// $Revision: 565775 $


//MIKe
module base64_enc (input clk, input reset, input integer fd_in, input integer fd_out, output bit complete);
	byte c;
	bit [7:0] c1;
	bit [7:0] c2;
	bit [7:0] c3;
	bit eof = 1'b1;			// end of file flag; 0-active
	bit [5:0] data;
	logic [6:0] data_enc;
	bit [1:0] send_cnt; 	// count sended bytes
	bit [1:0] frame_cnt;
	byte write_cnt; 		// count encoded bytes
	bit ack,start,en,enc;
	bit pad_done; 			// padding flag

	typedef enum bit [2:0] {idle, fetch1, fetch2, fetch3, encode, done, pad} T;
	T state;

	task save (input logic [6:0] in);
		if (write_cnt > 63) begin
			write_cnt=0;
			$fwrite(fd_out,"\n");
		end
		else
			write_cnt++;
		$fwrite(fd_out,"%s",in);
	endtask

	// Functional verification
	covergroup CG(string name) @(posedge clk);
		option.name = name;
		states : coverpoint state;
		transitions : coverpoint state {
			bins full = (fetch1 => fetch2 => fetch3 => encode);
			bins pad = (fetch1 => fetch2 => fetch3 => pad);
			bins end1 = (fetch1 => done);
			bins end2 = (pad => done);
			illegal_bins il1 = (fetch1 => encode);
			illegal_bins il2 = (fetch1 => pad);
			illegal_bins il3 = (encode => pad);
			illegal_bins il4 = (pad => encode);
		}
		option.per_instance=1;
	endgroup

	// FSM definition
	/*
		Aldec enum fsm_enc CURRENT = state
		Aldec enum fsm_enc STATES = idle, fetch1, fetch2, fetch3, encode, done, pad
		Aldec enum fsm_enc TRANS = fetch1 -> done,
			pad -> done,
			fetch1 -> fetch2,
			fetch2 -> fetch3,
			fetch3 -> encode,
			fetch3 -> pad,
			encode->fetch1
		Aldec enum fsm_enc SEQ = fetch1 -> fetch2 -> fetch3 -> encode,
			fetch1 -> fetch2 -> fetch3 -> pad
		Aldec enum fsm_enc ILLEGAL_TRANS = fetch1 -> encode,
			fetch1 -> pad,
			encode -> pad,
			pad -> encode
	*/

	CG cg = new("cg_i1");

	sequence seq1;
		@(posedge ack) (state == encode) || (state == pad);
	endsequence

	sequence seq2;
		@(posedge clk) state == pad;
	endsequence

	property prop1;
		@(posedge clk) disable iff (reset) not reset;
	endproperty

	property prop2;
    	@(posedge clk)  ((state==idle) && (reset==1'b1)) |=> (state==fetch1);
	endproperty

	rst : assert property (prop1);
	checkAck : cover property (seq1);
	checkPad : cover property (seq2);
	checkDone : cover property (@(posedge clk) state==done);

	fsmStart: assert property (prop2);
	startInFetch1 : assert property (@(posedge clk) (!((state == fetch1) && start)));
	startInFetch2 : assert property (@(posedge clk) (!((state == fetch2) && start)));
	startInFetch3 : assert property (@(posedge clk) (!((state == fetch3) && start)));


	encoder alphabet(.clk(clk),.reset(reset),.data_in(data),.start(start),.enc(enc|ack),.en(en),.data_out(data_enc));

	always @(posedge clk or negedge eof) begin // state machine
		if (!reset) begin
			state <= idle;
			start <= 1'b0;
		end
		else begin
			case (state)
				idle   : state <= fetch1;
				fetch1 : begin
							if (eof)
								state <= fetch2;
							else begin
								pad_done <= 1'b1;
								state <= done;
							end
						 end
				fetch2 : state <= fetch3;
				fetch3 : begin
						if (eof) begin
							state <= encode;
							start <= 1'b1;
						end
						else begin
							state <= pad;
							start <= 1'b1;
						end
					end
				encode : begin
						if (start)
							state <= encode;
						else
							state <= fetch1;
						if (ack)
							start <= 1'b0;
					end
				pad    : begin
						state <= (start)? pad : done;
						if (ack)
							start <= 1'b0;
					end
				done   : begin
						complete <= 1'b1;
					end
			endcase
		end
	end

	always @(posedge clk)
		if (state == fetch1 || state == fetch2 || state == fetch3)
			begin
				integer code;
				code = $fread(c,fd_in);
				eof = !(code == 0);
				if (eof) begin
					if (state == fetch1) begin
						c1 <= c;
						c2 <= '0;
						c3 <= '0;
					end
					if (state == fetch2)
						c2 <= c;
					if (state == fetch3)
						c3 <= c;
				end
			end

	always @(posedge clk)
		begin
			if (ack)
				ack <= !ack;
			if (start & (!ack)) begin
				case (send_cnt)
					0 : begin
							data <= c1[7:2];
							enc <= 1'b1;
						end
					1 : data <= {c1[1:0],c2[7:4]};
					2 : data <= {c2[3:0],c3[7:6]};
					3 : begin
							data <= c3[5:0];
							ack <= 1'b1;
							enc <= 1'b0;
						end
				endcase
				send_cnt++;
			end
		end

	always @(posedge clk)
			if (state == pad) begin
				if (en) begin
					case (frame_cnt)
						0 : save(data_enc);
						1 : save(data_enc);
						2 : if (c2 == '0)
								save("=");
							else
								save(data_enc);
						3 : save("=");
					endcase
					frame_cnt++;
				end
			end else if (en)
				save(data_enc);
endmodule
