pragma circom 2.0.0;

include "../circomlib/circuits/binsum.circom";
include "rotate.circom";
include "non_linear_function.circom";
include "ripemd160compression_function.circom";


template TT(j) {
  //  signal input j;
  //  signal input s;
   // signal input r;
    signal input a[32];
    signal input b[32];
    signal input c[32];
    signal input d[32];
    signal input e[32];
    signal input w[32];
    signal input K[32];
    signal output out[32];

    var k;

    var s = ss_f(j);

    component f = NLF(79-j);
    component sum = BinSum(32, 4);
    component rotl_sum =  RotL(32, s);
    component sum_final = BinSum(32, 2);
    
    for(k = 0; k < 32; k++){
      //  f.j <== j;
        f.x[k] <== b[k];
        f.y[k] <== c[k];
        f.z[k] <== d[k];
    }
 
    for(k = 0; k < 32; k++){
        sum.in[0][k] <== a[k];
        sum.in[1][k] <== f.out[k];
        sum.in[2][k] <== w[k];
        sum.in[3][k] <== K[k];
    }

    for(var k = 0; k < 32; k++){
        rotl_sum.in[k] <== sum.out[k];
    }

    for(k = 0; k < 32; k++){
        sum_final.in[0][k] <== rotl_sum.out[k];
        sum_final.in[1][k] <== e[k];
    }

    for(k = 0; k < 32; k++){
        out[k] <== sum_final.out[k];
    }

}

