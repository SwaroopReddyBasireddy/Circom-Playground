pragma circom 2.0.0;

include "constants.circom";
include "t_F.circom";
include "t_G.circom";
include "t_H.circom";
include "t_I.circom";
include "t_J.circom";
include "../circomlib/circuits/binsum.circom";
include "ripemd160compression_function.circom";


template Ripemd160compression() {
    signal input hin[160];
    signal input inp[512];
    signal output out[160];
    signal a[81][32];
    signal b[81][32];
    signal c[81][32];
    signal d[81][32];
    signal e[81][32];
    signal aa[81][32];
    signal bb[81][32];
    signal cc[81][32];
    signal dd[81][32];
    signal ee[81][32];

    signal w[16][32];


    var outCalc[160] = ripemd160compression(hin, inp);
    var i;
    for (i=0; i<160; i++) out[i] <-- outCalc[i];

    component const_k[80];
    for (i=0; i<80; i++) const_k[i] = K(i\16);

    component const_kk[80];
    for (i=0; i<80; i++) const_kk[i] = KK(i\16);

    component t_f[16];
    for (i=0; i<16; i++) t_f[i] = T_F(s_f(i));

    component tt_j[16];
    for (i=0; i<16; i++) tt_j[i] = T_J(ss_f(i));

    component t_g[16];
    for (i=0; i<16; i++) t_g[i] = T_G(s_f(16*1 + i));

    component tt_i[16];
    for (i=0; i<16; i++) tt_i[i] = T_I(ss_f(16*1 + i));

    component t_h[16];
    for (i=0; i<16; i++) t_h[i] = T_H(s_f(16*2 + i));

    component tt_h[16];
    for (i=0; i<16; i++) tt_h[i] = T_H(ss_f(16*2 + i));

    component t_i[16];
    for (i=0; i<16; i++) t_i[i] = T_I(s_f(16*3 + i));

    component tt_g[16];
    for (i=0; i<16; i++) tt_g[i] = T_G(ss_f(16*3 + i));

    component t_j[16];
    for (i=0; i<16; i++) t_j[i] = T_J(s_f(16*4 + i));

    component tt_f[16];
    for (i=0; i<16; i++) tt_f[i] = T_F(ss_f(16*4 + i));

    
    component rol_c[80];
    for (i=0; i<80; i++) rol_c[i] = RotL(32, 10);

    component rol_cc[80];
    for (i=0; i<80; i++) rol_cc[i] = RotL(32, 10);

    component fsum[5];
    for (i=0; i<5; i++) fsum[i] = BinSum(32, 3);

    var m;
    var k;


    for (m=0; m<16; m++) {
        for (k=0; k<32; k++) {
            w[m][k] <== inp[m*32+31-k];
        }
    }

    for (k=0; k<32; k++ ) {
        a[0][k] <== hin[k];
        b[0][k] <== hin[32*1 + k];
        c[0][k] <== hin[32*2 + k];
        d[0][k] <== hin[32*3 + k];
        e[0][k] <== hin[32*4 + k];

        aa[0][k] <== hin[k];
        bb[0][k] <== hin[32*1 + k];
        cc[0][k] <== hin[32*2 + k];
        dd[0][k] <== hin[32*3 + k];
        ee[0][k] <== hin[32*4 + k];
    }

    // Rounds 1 to 16
    for (m = 0; m < 16; m++) {
        var r = r_f(m);
        var rr = rr_f(m);
        for (k=0; k<32; k++) {
            t_f[m%16].a[k] <== a[m][k];
            t_f[m%16].b[k] <== b[m][k];
            t_f[m%16].c[k] <== c[m][k];
            t_f[m%16].d[k] <== d[m][k];
            t_f[m%16].e[k] <== e[m][k];
            t_f[m%16].w[k] <== w[r][k];
            t_f[m%16].K[k] <== const_k[m].out[k];
            
            tt_j[m%16].a[k] <== aa[m][k];
            tt_j[m%16].b[k] <== bb[m][k];
            tt_j[m%16].c[k] <== cc[m][k];
            tt_j[m%16].d[k] <== dd[m][k];
            tt_j[m%16].e[k] <== ee[m][k];
            tt_j[m%16].w[k] <== w[rr][k];
            tt_j[m%16].K[k] <== const_kk[m].out[k];
         }

        for (k=0; k<32; k++) {
            rol_c[m].in[k] <== c[m][k];
            rol_cc[m].in[k] <== cc[m][k];
        }

        for (k=0; k<32; k++) {
            a[m+1][k] <== e[m][k];
            e[m+1][k] <== d[m][k];
            d[m+1][k] <== rol_c[m].out[k];
            c[m+1][k] <== b[m][k];
            b[m+1][k] <== t_f[m%16].out[k];

            aa[m+1][k] <== ee[m][k];
            ee[m+1][k] <== dd[m][k];
            dd[m+1][k] <== rol_cc[m].out[k];
            cc[m+1][k] <== bb[m][k];
            bb[m+1][k] <== tt_j[m%16].out[k];
        }
    }

    // Rounds 17 to 32
    for (m = 16; m < 32; m++) {
        var r = r_f(m);
        var rr = rr_f(m);
        for (k=0; k<32; k++) {
            t_g[m%16].a[k] <== a[m][k];
            t_g[m%16].b[k] <== b[m][k];
            t_g[m%16].c[k] <== c[m][k];
            t_g[m%16].d[k] <== d[m][k];
            t_g[m%16].e[k] <== e[m][k];
            t_g[m%16].w[k] <== w[r][k];
            t_g[m%16].K[k] <== const_k[m].out[k];
            
            tt_i[m%16].a[k] <== aa[m][k];
            tt_i[m%16].b[k] <== bb[m][k];
            tt_i[m%16].c[k] <== cc[m][k];
            tt_i[m%16].d[k] <== dd[m][k];
            tt_i[m%16].e[k] <== ee[m][k];
            tt_i[m%16].w[k] <== w[rr][k];
            tt_i[m%16].K[k] <== const_kk[m].out[k];
         }

        for (k=0; k<32; k++) {
            rol_c[m].in[k] <== c[m][k];
            rol_cc[m].in[k] <== cc[m][k];
        }

        for (k=0; k<32; k++) {
            a[m+1][k] <== e[m][k];
            e[m+1][k] <== d[m][k];
            d[m+1][k] <== rol_c[m].out[k];
            c[m+1][k] <== b[m][k];
            b[m+1][k] <== t_g[m%16].out[k];

            aa[m+1][k] <== ee[m][k];
            ee[m+1][k] <== dd[m][k];
            dd[m+1][k] <== rol_cc[m].out[k];
            cc[m+1][k] <== bb[m][k];
            bb[m+1][k] <== tt_i[m%16].out[k];
        }
    }

    // Rounds 33 to 48
    for (m = 32; m < 48; m++) {
        var r = r_f(m);
        var rr = rr_f(m);
        for (k=0; k<32; k++) {
            t_h[m%16].a[k] <== a[m][k];
            t_h[m%16].b[k] <== b[m][k];
            t_h[m%16].c[k] <== c[m][k];
            t_h[m%16].d[k] <== d[m][k];
            t_h[m%16].e[k] <== e[m][k];
            t_h[m%16].w[k] <== w[r][k];
            t_h[m%16].K[k] <== const_k[m].out[k];
            
            tt_h[m%16].a[k] <== aa[m][k];
            tt_h[m%16].b[k] <== bb[m][k];
            tt_h[m%16].c[k] <== cc[m][k];
            tt_h[m%16].d[k] <== dd[m][k];
            tt_h[m%16].e[k] <== ee[m][k];
            tt_h[m%16].w[k] <== w[rr][k];
            tt_h[m%16].K[k] <== const_kk[m].out[k];
         }

        for (k=0; k<32; k++) {
            rol_c[m].in[k] <== c[m][k];
            rol_cc[m].in[k] <== cc[m][k];
        }

        for (k=0; k<32; k++) {
            a[m+1][k] <== e[m][k];
            e[m+1][k] <== d[m][k];
            d[m+1][k] <== rol_c[m].out[k];
            c[m+1][k] <== b[m][k];
            b[m+1][k] <== t_h[m%16].out[k];

            aa[m+1][k] <== ee[m][k];
            ee[m+1][k] <== dd[m][k];
            dd[m+1][k] <== rol_cc[m].out[k];
            cc[m+1][k] <== bb[m][k];
            bb[m+1][k] <== tt_h[m%16].out[k];
        }
    }

    // Rounds 48 to 64
    for (m = 48; m < 64; m++) {
        var r = r_f(m);
        var rr = rr_f(m);
        for (k=0; k<32; k++) {
            t_i[m%16].a[k] <== a[m][k];
            t_i[m%16].b[k] <== b[m][k];
            t_i[m%16].c[k] <== c[m][k];
            t_i[m%16].d[k] <== d[m][k];
            t_i[m%16].e[k] <== e[m][k];
            t_i[m%16].w[k] <== w[r][k];
            t_i[m%16].K[k] <== const_k[m].out[k];
            
            tt_g[m%16].a[k] <== aa[m][k];
            tt_g[m%16].b[k] <== bb[m][k];
            tt_g[m%16].c[k] <== cc[m][k];
            tt_g[m%16].d[k] <== dd[m][k];
            tt_g[m%16].e[k] <== ee[m][k];
            tt_g[m%16].w[k] <== w[rr][k];
            tt_g[m%16].K[k] <== const_kk[m].out[k];
         }

        for (k=0; k<32; k++) {
            rol_c[m].in[k] <== c[m][k];
            rol_cc[m].in[k] <== cc[m][k];
        }

        for (k=0; k<32; k++) {
            a[m+1][k] <== e[m][k];
            e[m+1][k] <== d[m][k];
            d[m+1][k] <== rol_c[m].out[k];
            c[m+1][k] <== b[m][k];
            b[m+1][k] <== t_i[m%16].out[k];

            aa[m+1][k] <== ee[m][k];
            ee[m+1][k] <== dd[m][k];
            dd[m+1][k] <== rol_cc[m].out[k];
            cc[m+1][k] <== bb[m][k];
            bb[m+1][k] <== tt_g[m%16].out[k];
        }
    }

    // Rounds 65 to 80
    for (m = 64; m < 80; m++) {
        var r = r_f(m);
        var rr = rr_f(m);
        for (k=0; k<32; k++) {
            t_j[m%16].a[k] <== a[m][k];
            t_j[m%16].b[k] <== b[m][k];
            t_j[m%16].c[k] <== c[m][k];
            t_j[m%16].d[k] <== d[m][k];
            t_j[m%16].e[k] <== e[m][k];
            t_j[m%16].w[k] <== w[r][k];
            t_j[m%16].K[k] <== const_k[m].out[k];
            
            tt_f[m%16].a[k] <== aa[m][k];
            tt_f[m%16].b[k] <== bb[m][k];
            tt_f[m%16].c[k] <== cc[m][k];
            tt_f[m%16].d[k] <== dd[m][k];
            tt_f[m%16].e[k] <== ee[m][k];
            tt_f[m%16].w[k] <== w[rr][k];
            tt_f[m%16].K[k] <== const_kk[m].out[k];
         }

        for (k=0; k<32; k++) {
            rol_c[m].in[k] <== c[m][k];
            rol_cc[m].in[k] <== cc[m][k];
        }

        for (k=0; k<32; k++) {
            a[m+1][k] <== e[m][k];
            e[m+1][k] <== d[m][k];
            d[m+1][k] <== rol_c[m].out[k];
            c[m+1][k] <== b[m][k];
            b[m+1][k] <== t_j[m%16].out[k];

            aa[m+1][k] <== ee[m][k];
            ee[m+1][k] <== dd[m][k];
            dd[m+1][k] <== rol_cc[m].out[k];
            cc[m+1][k] <== bb[m][k];
            bb[m+1][k] <== tt_f[m%16].out[k];
        }
    }


        for (k=0; k<32; k++) {
            fsum[0].in[0][k] <== hin[32*1 + k];
            fsum[0].in[1][k] <== c[80][k];
            fsum[0].in[2][k] <== dd[80][k];

            fsum[1].in[0][k] <== hin[32*2 + k];
            fsum[1].in[1][k] <== d[80][k];
            fsum[1].in[2][k] <== ee[80][k];

            fsum[2].in[0][k] <== hin[32*3 + k];
            fsum[2].in[1][k] <== e[80][k];
            fsum[2].in[2][k] <== aa[80][k];

            fsum[3].in[0][k] <== hin[32*4 + k];
            fsum[3].in[1][k] <== a[80][k];
            fsum[3].in[2][k] <== bb[80][k];

            fsum[4].in[0][k] <== hin[32*0 + k];
            fsum[4].in[1][k] <== b[80][k];
            fsum[4].in[2][k] <== cc[80][k];
        }

        for (k=0; k<32; k++) {
        out[31-k]     === fsum[0].out[k];
        out[32+31-k]  === fsum[1].out[k];
        out[64+31-k]  === fsum[2].out[k];
        out[96+31-k]  === fsum[3].out[k];
        out[128+31-k] === fsum[4].out[k];
        }
    }