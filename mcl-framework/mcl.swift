//
//  mcl.swift
//  mcl-framework
//
//  Created by bakhtiyor on 05/02/22.
//

import Foundation
import CryptoKit
import BigNumber

public typealias SecretKey = Fr
public typealias Domain = [UInt8]

public func GetPubKey(secret: SecretKey) -> G2 {
    let pubkey = G2()
    let g2 = G2()
    g2.setStr("1 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa 0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b")
    G2.mul(pubkey, y: g2, z: secret)
    pubkey.normalize()
    return pubkey
}

public func NewKeyPair() -> (G2, Fr) {
    let secret = Fr()
    secret.setRand()
    let pubkey = GetPubKey(secret: secret)
    return (pubkey, secret)
}

public func VerifyRaw(signature: G1, pubkey: G2, message: G1) -> Bool {
    let negG2 = Fp6()
    BN256.precompute(negativeG2(), coeff: negG2)
    let fp12 = Fp12()
    BN256.precomputedMillerLoop2mixed(fp12, p1: message, q1: pubkey, p2: signature, coeff: negG2)
    let result = Fp12()
    BN256.finalExp(result, y: fp12)
    return result.isOne()
}

public func Sign(message: String, secret: SecretKey, domain: Domain) -> (G1, G1) {
    let messagePoint = HashToPoint(message: message, domain: domain)
    let signature = G1()
    G1.mul(signature, y: messagePoint, z: secret)
    signature.normalize()
    return (signature, messagePoint)
}

public func HashToPoint(message: String, domain: Domain) -> G1 {
    let array = HashToField(domain: domain, msg: Array(message.utf8), count: 2)
    let e0 = array[0]
    let e1 = array[1]
    let p0 = MapToPoint(e0: e0)
    let p1 = MapToPoint(e0: e1)
    let p = G1()
    G1.add(p, p: p0, q: p1)
    p.normalize()
    return p
}

public func MapToPoint(e0: BInt) -> G1 {
    let e1 = Fp()
    e1.setStr((e0 % FIELD_ORDER).description)
    let g1 = G1()
    BN256.map(to: g1, fp: e1)
    return g1
}

func negativeG2() -> G2 {
    let g2 = G2()
    g2.setStr("1 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2 0x1d9befcd05a5323e6da4d435f3b617cdb3af83285c2df711ef39c01571827f9d 0x275dc4a288d1afb3cbb1ac09187524c7db36395df7be3b99e673b13a075a65ec")
    return g2
}
