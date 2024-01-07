//    signal input hin[160];
//    signal input inp[512];
//    signal output out[160];

pragma circom 2.0.0;

// Added constants for rounds
function K_f(x) {
     var c[5] = [0x00000000, 
                0x5a827999, 
                0x6ed9eba1, 
                0x8f1bbcdc, 
                0xa953fd4e];
    return c[x];
}

// Added constants for parallel rounds
function KK_f(x) {
    var c[5] = [0x50a28be6, 
                0x5c4dd124, 
                0x6d703ef3, 
                0x7a6d76e9, 
                0x00000000];

   return c[x];
}

// Selection of the message word for rounds
function r_f(x){
    var c[80] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8,
                3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12,
                1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2,
                4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13];

    return c[x];
}

// Selection of the message word for parallel rounds
function rr_f(x){
    var c[80] = [5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12,
                6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2,
                15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13,
                8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14,
                12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11];

    return c[x];
}

// Amount of rotate left for rounds (ROL)
function s_f(x){
    var c[80] = [11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8,
                  7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12,
                 11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5,
                 11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12,
                 9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6];

    return c[x];
}

// Amount of rotate left for parallel rounds (ROL)
function ss_f(x){
    var c[80] = [8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6,
                 9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11,
                 9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5,
                 15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8,
                 8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11];

    return c[x];
}

function lrot(x, n) {
    return ((x << n) | (x >> (32-n))) & 0xFFFFFFFF;
}
function F_f(x,y,z) {
    return x ^ y ^z;
}

function G_f(x,y,z){
    return (x&y)|((0xFFFFFFFF ^x) & z);
}

function H_f(x,y,z){
    return (x|(0xFFFFFFFF ^y))^z;
}

function I_f(x,y,z){
    return (x&z)|(y&(0xFFFFFFFF ^z));
}

function J_f(x,y,z){
    return x^(y|(0xFFFFFFFF ^z));
}

function ripemd160compression(hin, inp) {
    var H[5];
    var a;
    var b;
    var c;
    var d;
    var e;
    var aa;
    var bb;
    var cc;
    var dd;
    var ee;
    var out[160];
    for (var i=0; i<5; i++) {
        H[i] = 0;
        for (var j=0; j<32; j++) {
            H[i] += hin[i*32+j] << j;
        }
    }

    a=H[0];
    b=H[1];
    c=H[2];
    d=H[3];
    e=H[4];
    aa=H[0];
    bb=H[1];
    cc=H[2];
    dd=H[3];
    ee=H[4];
    var w[16];
    var T;
    var TT;
    var mid;
    var midmid;
    var f;
    var ff;
    var k;
    var kk;
    var r;
    var rr;


    for (var i=0; i<16; i++) {
         w[i]=0;
        for (var j=0; j<32; j++) {
                w[i] +=  inp[i*32+31-j]<<j;
            }
        }

    for (var i = 0; i < 80; i++){
        if(i\16 == 0){
            f = F_f(b,c,d);
            ff = J_f(bb,cc,dd);
        }

        else if(i\16 == 1){
            f = G_f(b,c,d);
            ff = I_f(bb,cc,dd);
        }

        else if(i\16 == 2){
            f = H_f(b,c,d);
            ff = H_f(bb,cc,dd);
        }

        else if(i\16 == 3){
            f = I_f(b,c,d);
            ff = G_f(bb,cc,dd);
        }

        else if(i\16 == 4){
            f = J_f(b,c,d);
            ff = F_f(bb,cc,dd);
        }
        r = r_f(i);
        k = i\16;
        mid = (a + f + w[r] + K_f(k)) & 0xFFFFFFFF;
        T = (lrot(mid,s_f(i)) + e ) & 0xFFFFFFFF;
        a = e;
        e = d;
        d = lrot(c,10);
        c = b;
        b = T;

        rr = rr_f(i);
        midmid = (aa + ff + w[rr] + KK_f(k)) & 0xFFFFFFFF;
        TT = (lrot(midmid, ss_f(i)) + ee) & 0xFFFFFFFF;
        aa = ee;
        ee = dd;
        dd = lrot(cc,10);
        cc = bb;
        bb = TT;

    } 
    T = (H[1] + c + dd) & 0xFFFFFFFF;
    H[1] = (H[2] + d + ee) & 0xFFFFFFFF;
    H[2] = (H[3] + e + aa) & 0xFFFFFFFF;
    H[3] = (H[4] + a + bb) & 0xFFFFFFFF;
    H[4] = (H[0] + b + cc) & 0xFFFFFFFF;
    H[0] = T;

    for (var i=0; i<5; i++) {
        for (var j=0; j<32; j++) {
            out[i*32+31-j] = (H[i] >> j) & 1;
        }
    }
    return out;
    }
