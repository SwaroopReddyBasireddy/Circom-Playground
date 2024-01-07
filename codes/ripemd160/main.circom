// pragma circom 2.0.0;

// include "ripemd160_2.circom";

// template Main() {
//     signal input a;
//     signal input b;
//     signal output out;

//     component ripemd160_2 = Ripemd160_2();

//     ripemd160_2.a <== a;
//     ripemd160_2.b <== a;
//     out <== ripemd160_2.out;
// }

// component main = Main();


pragma circom 2.0.0;

include "ripemd160.circom";
include "../circomlib/circuits/bitify.circom";

template Birthday(){
  component ripemd = Ripemd160(6);
  signal input date[6];
  ripemd.in <== date;

  signal date_out[160];
  signal output out;
  date_out <== ripemd.out;
  component bits2num = Bits2Num(160);
  bits2num.in <== date_out;
  out <== bits2num.out;
}

component main = Birthday();
