pragma circom 2.0.0;
include "gates.circom";

template NLF(j,n) {
   // signal input j;
    signal input x[n];
    signal input y[n];
    signal input z[n];
    signal output out[n];

    component xor3 = XOR3(n);
    
    signal mid[n];

    signal or[n];
    component xor = XOR2(n);
        
    // component nlf1 = F(32);
    // component nlf2 = G(32);
    // component nlf3 = H(32);
    // component nlf4 = I(32);
    // component nlf5 = J(32);

    if(j\16 == 0){
    for(var k = 0; k < n; k++){
        xor3.a[k] <== x[k];
        xor3.b[k] <== y[k];
        xor3.c[k] <== z[k];
        }

    for(var k = 0; k < n; k++){
        out[k] <== xor3.out[k];
        }
    }

    else if(j\16 == 1){
        for(var k = 0; k < n; k++){
            mid[k] <== (1 - x[k]) * z[k];
            out[k] <== x[k]*y[k] + mid[k];
        }    
    }

    else if(j\16 == 2){
        for(var k = 0; k < n; k++){
            or[k] <== 1 - y[k] + x[k] * y[k];
        }

        for(var k = 0; k < n; k++){
            xor.a[k] <==  or[k];
            xor.b[k] <== z[k];
        }

        for(var k = 0; k < n; k++){
            out[k] <== xor.out[k];
        }    
    }

    else if(j\16 == 3){
        for(var k = 0; k < n; k++){
            mid[k] <== (1 - z[k])*y[k];
            out[k] <== x[k]*z[k] + mid[k];
        }    
    }

    else if(j\16 == 4){
        for(var k = 0; k < n; k++){
            or[k] <== 1 - z[k] + y[k] * z[k];
        }

        for(var k = 0; k < n; k++){
            xor.a[k] <== x[k];
            xor.b[k] <== or[k];
        }

        for(var k = 0; k < n; k++){
            out[k] <== xor.out[k];
        }
    }
}