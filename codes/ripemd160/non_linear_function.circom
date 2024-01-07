pragma circom 2.0.0;

include "F.circom";
include "G.circom";
include "H.circom";
include "I.circom";
include "J.circom";

template NLF(j) {
   // signal input j;
    signal input x[32];
    signal input y[32];
    signal input z[32];
    signal output out[32];

    component nlf1 = F(32);
    component nlf2 = G(32);
    component nlf3 = H(32);
    component nlf4 = I(32);
    component nlf5 = J(32);



    if(j\16 == 0){
        
        for(var k = 0; k < 32; k++){
            nlf1.x[k] <== x[k];
            nlf1.y[k] <== y[k];
            nlf1.z[k] <== z[k];
        }

        for(var k = 0; k < 32; k++){
            out[k] <== nlf1.out[k];
        }
    }

    else if(j\16 == 1){

        for(var k = 0; k < 32; k++){
            nlf2.x[k] <== x[k];
            nlf2.y[k] <== y[k];
            nlf2.z[k] <== z[k];
        }

        for(var k = 0; k < 32; k++){
            out[k] <== nlf2.out[k];
        }
    }

    else if(j\16 == 2){

        for(var k = 0; k < 32; k++){
            nlf3.x[k] <== x[k];
            nlf3.y[k] <== y[k];
            nlf3.z[k] <== z[k];
        }

        for(var k = 0; k < 32; k++){
            out[k] <== nlf3.out[k];
        }
    }

    else if(j\16 == 3){
        for(var k = 0; k < 32; k++){
            nlf4.x[k] <== x[k];
            nlf4.y[k] <== y[k];
            nlf4.z[k] <== z[k];
        }

        for(var k = 0; k < 32; k++){
            out[k] <== nlf4.out[k];
        }    
    }

    else if(j\16 == 4){
        for(var k = 0; k < 32; k++){
            nlf5.x[k] <== x[k];
            nlf5.y[k] <== y[k];
            nlf5.z[k] <== z[k];
        }

        for(var k = 0; k < 32; k++){
            out[k] <== nlf5.out[k];
        }
    }
}