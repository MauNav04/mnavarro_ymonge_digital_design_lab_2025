module bin2gray_tb();
  logic a,b,c,d;            // bin
  logic w,x,y,z;          //gray

  bin2gray dut(.a(a), .b(b), .c(c), .d(d), .w(w), .x(x), .y(y), .z(z));

  initial begin
    $display(" t   |  bin   ->  gray");
    // 0000
    a=0; b=0; c=0; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 0001
    a=0; b=0; c=0; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 0010
    a=0; b=0; c=1; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 0011
    a=0; b=0; c=1; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 0100
    a=0; b=1; c=0; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 0101
    a=0; b=1; c=0; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 0110
    a=0; b=1; c=1; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 0111
    a=0; b=1; c=1; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1000
    a=1; b=0; c=0; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1001
    a=1; b=0; c=0; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1010
    a=1; b=0; c=1; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1011
    a=1; b=0; c=1; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1100
    a=1; b=1; c=0; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1101
    a=1; b=1; c=0; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1110
    a=1; b=1; c=1; d=0; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);
    // 1111
    a=1; b=1; c=1; d=1; #10;  $display("%4t |  %b%b%b%b  ->  %b%b%b%b", $time,a,b,c,d,w,x,y,z);

    $finish;
  end
endmodule