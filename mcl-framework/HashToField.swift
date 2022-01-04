//
//  HashToField.swift
//  mcl-framework
//
//  Created by bakhtiyor on 02/01/22.
//

import Foundation
import CryptoKit
import BigNumber

let FIELD_ORDER = BInt("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47", radix: 16)!


public func HashToField(
    domain: Array<UInt8>,
    msg: Array<UInt8>,
    count: Int
) -> Array<BInt> {
    let u = 48
    let _msg = ExpandMsg(domain: domain, msg: msg, outLen: count * u)
    var els = Array<BInt>()
    for i in 1..<count {
        let el = BInt(bytes: Array<UInt8>(_msg[i*u..<(i+1)*u])) % FIELD_ORDER
        els.append(el)
    }
    return els
}


public func ExpandMsg(
    domain: Array<UInt8>,
    msg: Array<UInt8>,
    outLen: Int
) -> Array<UInt8> {
    var out = Array<UInt8>(repeating: 0, count: outLen)
    
    let len0 = 64 + msg.count + 2 + 1 + domain.count + 1
    var in0 = Array<UInt8>(repeating: 0, count: len0)
    
    // zero pad
    var off = 64
    //msg
    in0.setSubArray(elements: msg, at: off)
    off = off + msg.count
    // l_i_b_str
    in0.setSubArray(elements: [(UInt8(outLen) >> 8) & UInt8(0xff), UInt8(outLen) & UInt8(0xff)], at: off)
    off = off + 2
    // I2OSP(0, 1)
    in0.setSubArray(elements: [UInt8(0)], at: off)
    off = off + 1
    // DST_prime
    in0.setSubArray(elements: domain, at: off)
    off = off + domain.count
    in0.setSubArray(elements: [UInt8(domain.count)], at: off)
    
    let b0 = SHA256.hash(data: in0)
    
    let len1 = 32 + 1 + domain.count + 1
    var in1 = Array<UInt8>(repeating: 0, count: len1)
    
    //b0
    let b0array = Array<UInt8>(b0)
    in1.setSubArray(elements: b0array, at: 0)
    off = 32
    // I2OSP(1, 1)
    in1.setSubArray(elements: [UInt8(1)], at: off)
    off = off + 1
    // DST_Prime
    in1.setSubArray(elements: domain, at: off)
    off = off + domain.count
    in1.setSubArray(elements: [UInt8(domain.count)], at: off)
    
    let b1 = SHA256.hash(data: in1)
    
    let ell = floor(Double(outLen + 32 - 1) / 32.0)
    var bi = b1
    
    for i in 1..<Int(ell) {
        var ini = Array<UInt8>(repeating: 0, count: 32 + 1 + domain.count + 1)
        let nb0 = ZeroPad(input: b0array, size: 32)
        let nbi = ZeroPad(input: Array<UInt8>(bi), size: 32)
        var tmp = Array<UInt8>(repeating: 0, count: 32)
        for j in 0..<32 {
            tmp[j] = nb0[j] ^ nbi[j]
        }
        
        ini.setSubArray(elements: tmp, at: 0)
        var off = 32
        ini.setSubArray(elements: [UInt8(1 + i)], at: off)
        off = off + 1
        ini.setSubArray(elements: domain, at: off)
        off = off + domain.count
        ini.setSubArray(elements: [UInt8(domain.count)], at: off)
        
        out.setSubArray(elements: Array<UInt8>(bi), at: 32*(i-1))
        bi = SHA256.hash(data: ini)
    }
    
    out.setSubArray(elements: Array<UInt8>(bi), at: 32 * (Int(ell) - 1))
    return out
}

func ZeroPad(input: Array<UInt8>, size: Int) -> Array<UInt8> {
    var output = Array<UInt8>(repeating: 0, count: size)
    let offset = size - input.count
    output.replaceSubrange(offset..<size, with: input)
    return output
}

extension Array {
    mutating func setSubArray<C>(elements newElements: C, at position: Int) where C : Collection, Element == C.Element {
        self.replaceSubrange(position..<(position + newElements.count), with: newElements)
    }
}
