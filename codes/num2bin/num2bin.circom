pragma circom  2.0.0;
include "../circomlib/circuits/bitify.circom";

// template num2Bits(n) {
//     signal input in;
//     signal output out[n];
//     component n2b = Num2Bits(n);
    
//     n2b.in <== in;
//     var i;

//     for(i = 0; i < n; i++){
//         out[i] <== n2b.out[i];
//     }
// }

// component main = num2Bits(32);

include "../circomlib/circuits/binsum.circom";

template A() {
    signal input a; //private
    signal input b;
    signal output out;

    var i;

    component n2ba = Num2Bits(32);
    component n2bb = Num2Bits(32);
    component sum = BinSum(32,2);
    component b2n = Bits2Num(32);

    n2ba.in <== a;
    n2bb.in <== b;

    for (i=0; i<32; i++) {
        sum.in[0][i] <== n2ba.out[i];
        sum.in[1][i] <== n2bb.out[i];
    }

    for (i=0; i<32; i++) {
        b2n.in[i] <== sum.out[i];
    }

    out <== b2n.out;
}

component main = A();
