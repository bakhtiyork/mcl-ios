//
//  MCLFrameworkTest.swift
//  mcl-frameworkTests
//
//  Created by bakhtiyor on 06/12/21.
//

import XCTest
import mcl_framework

func Hash(p: G1, m: String){
    let t = Fp()
    t.setHashOf(m)
    BN256.map(to: p, fp: t)
}

func KeyGen(s: Fr, pub: G2, Q: G2) {
    s.setRand()
    G2.mul(pub, y: Q, z: s)
}

func Sign(sign: G1, s: Fr, m: String) {
    let Hm = G1()
    Hash(p: Hm, m: m)
    G1.mul(sign, y: Hm, z: s)
}

func Verify(sign: G1, Q: G2, pub: G2, m: String) -> Bool {
    let e1 = Fp12()
    let e2 = Fp12()
    let Hm = G1()
    Hash(p: Hm, m: m)
    BN256.pairing(with: e1, p: sign, q: Q)
    BN256.pairing(with: e2, p: Hm, q: pub)
    return e1 == e2
}


class MCLFrameworkTest: XCTestCase {


    func testExample() throws {
        let m = "hello mcl"
        
        // setup parameter
        BN256.initPairing()
        let Q = G2()
        BN256.map(to: Q, fp2: Fp2(int: 1))
        
        // generate secret key and public key
        let s = Fr()
        let pub = G2()
        KeyGen(s: s, pub: pub, Q: Q)
        print("secret key: ", s)
        print("public key: ", pub)
        
        // sign
        let sign = G1()
        Sign(sign: sign, s: s, m: m)
        print("msg: ", m)
        print("sign: ", sign)
        
        // verify
        let ok = Verify(sign: sign, Q: Q, pub: pub, m: m)
        XCTAssertTrue(ok)
    }


}
