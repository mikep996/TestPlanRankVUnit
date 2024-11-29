// (c) Aldec, Inc.
// All rights reserved.
//
// Last modified: $Date: 2015-02-26 08:24:56 +0100 (Thu, 26 Feb 2015) $
// $Revision: 357294 $

module encoder (input clk, input reset, input start, input enc, output reg en, input [5:0] data_in, output reg [6:0] data_out);

function reg [7:0] Base64_Alphabet (input [5:0] in);
	case (in)
	  0 : return "A";
	  1 : return "B";
	  2 : return "C";
	  3 : return "D";
	  4 : return "E";
	  5 : return "F";
	  6 : return "G";
	  7 : return "H";
	  8 : return "I";
	  9 : return "J";
	  10 : return "K";
	  11 : return "L";
	  12 : return "M";
	  13 : return "N";
	  14 : return "O";
	  15 : return "P";
	  16 : return "Q";
	  17 : return "R";
	  18 : return "S";
	  19 : return "T";
	  20 : return "U";
	  21 : return "V";
	  22 : return "W";
	  23 : return "X";
	  24 : return "Y";
	  25 : return "Z";
	  26 : return "a";
	  27 : return "b";
	  28 : return "c";
	  29 : return "d";
	  30 : return "e";
	  31 : return "f";
	  32 : return "g";
	  33 : return "h";
	  34 : return "i";
	  35 : return "j";
	  36 : return "k";
	  37 : return "l";
	  38 : return "m";
	  39 : return "n";
	  40 : return "o";
	  41 : return "p";
	  42 : return "q";
	  43 : return "r";
	  44 : return "s";
	  45 : return "t";
	  46 : return "u";
	  47 : return "v";
	  48 : return "w";
	  49 : return "x";
	  50 : return "y";
	  51 : return "z";
	  52 : return "0";
	  53 : return "1";
	  54 : return "2";
	  55 : return "3";
	  56 : return "4";
	  57 : return "5";
	  58 : return "6";
	  59 : return "7";
	  60 : return "8";
	  61 : return "9";
	  62 : return "+";   // -
	  63 : return "/";   // _
	endcase
endfunction

always @(posedge clk) begin
	en <= 1'b0;
	if (enc) begin
		data_out <=  Base64_Alphabet(data_in);
		en <= 1'b1;
	end
end
endmodule
