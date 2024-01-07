pragma circom 2.0.0;

include "../circomlib/circuits/binsum.circom";
include "rotate.circom";
include "non_linear_function.circom"

template T_sum() {
    signal input j;
    signal input r;
    signal input a[32];
    signal input b[32];
    signal input c[32];
    signal input d[32];
    signal input e[32];
    signal input w[32];
    signal input K[32];
    signal output out[32];

    var k;

    component f = NLF();
    component sum = BinSum(32, 5);
    component rol =  RotL(32, r);
    
    for(k = 0; k < 32; k++){
        f.j <== j;
        f.x[k] <== b[k];
        f.y[k] <== c[k];
        f.z[k] <== d[k];
    }
 
    for(k = 0; k < 32; k++){
        sum.in[0][k] <== a[k];
        sum.in[1][k] <== f.out[k];
        sum.in[2][k] <== w[k];
        sum.in[3][k] <== K[32];
        sum.in[4][k] <== e[k];
    }

    for(k = 0; k < 32; k++){
        out[k] <== sum.out[k];
    }

}

