//
//  BN256.m
//  mcl-framework
//
//  Created by bakhtiyor on 28/11/21.
//

#import "BN256.h"
#include "mcl/bn256.hpp"
#include <string>
#include <iostream>
#include <sstream>


#define REF_CLASS_EXTENSION(class_name, ref_class) \
@interface class_name() \
-(ref_class*)ref; \
@end \
\

#define REF_CLASS_BOILERPLATE(class_name, ref_class) \
\
- (instancetype)init { \
  self = [super init]; \
  if (self) { \
    ref = new ref_class(); \
  } \
  return self; \
} \
\
-(ref_class*)ref { \
  return ref; \
} \
\
- (NSString *)description { \
    std::stringstream ss; \
    ss << *ref; \
    return [NSString \
            stringWithCString:ss.str().c_str() \
            encoding:NSUTF8StringEncoding]; \
} \
-(void)setStr:(NSString*)str { \
    ref->setStr([str UTF8String]); \
} \
\
- (BOOL)isEqual:(id)other { \
    if (other == self) \
        return YES; \
    if (!other || ![other isKindOfClass:[self class]]) \
        return NO; \
    class_name *obj = (class_name*)other; \
    return *ref == *obj.ref; \
} \
\
-(void)dealloc { \
  delete ref; \
} \



REF_CLASS_EXTENSION(G1, mcl::bn256::G1)
REF_CLASS_EXTENSION(G2, mcl::bn256::G2)
REF_CLASS_EXTENSION(Fr, mcl::bn256::Fr)
REF_CLASS_EXTENSION(Fp, mcl::bn256::Fp)
REF_CLASS_EXTENSION(Fp2, mcl::bn256::Fp2)
REF_CLASS_EXTENSION(Fp12, mcl::bn256::Fp12)


// MARK: G1
@implementation G1 {
    mcl::bn256::G1* ref;
}
REF_CLASS_BOILERPLATE(G1, mcl::bn256::G1)

+(void)mul:(G1 *)x y:(G1 *)y z:(Fr *)z {
    mcl::bn256::G1::mul(*x.ref, *y.ref, *z.ref);
}

+(void)add:(G1*)r p:(G1*)p q:(G1*)q {
    mcl::bn256::G1::add(*r.ref, *p.ref, *q.ref);
}

-(void)normalize {
    ref->normalize();
}
@end

// MARK: G2
@implementation G2 {
    mcl::bn256::G2* ref;
}
REF_CLASS_BOILERPLATE(G2, mcl::bn256::G2)

+(void)mul:(G2 *)x y:(G2 *)y z:(Fr *)z {
    mcl::bn256::G2::mul(*x.ref, *y.ref, *z.ref);
}

-(void)normalize {
    ref->normalize();
}

@end

// MARK: Fr
@implementation Fr {
    mcl::bn256::Fr* ref;
}
REF_CLASS_BOILERPLATE(Fr, mcl::bn256::Fr)

-(void)setRand {
    ref->setRand();
}
@end

// MARK: Fp
@implementation Fp {
    mcl::bn256::Fp* ref;
}
REF_CLASS_BOILERPLATE(Fp, mcl::bn256::Fp)

-(void)setHashOf:(NSString *)hash {
    ref->setHashOf(std::string(hash.UTF8String));
}
@end

// MARK: Fp2
@implementation Fp2 {
    mcl::bn256::Fp2* ref;
}
REF_CLASS_BOILERPLATE(Fp2, mcl::bn256::Fp2)

-(instancetype)initWithInt:(NSInteger)a {
    self = [super init];
    if (self) {
      ref = new mcl::bn256::Fp2(a);
    }
    return self;
}
@end

// MARK: Fp6
@implementation Fp6 {
    mcl::bn256::Fp6* ref;
}
REF_CLASS_BOILERPLATE(Fp6, mcl::bn256::Fp6)
@end

// MARK: Fp12
@implementation Fp12 {
    mcl::bn256::Fp12* ref;
}
REF_CLASS_BOILERPLATE(Fp12, mcl::bn256::Fp12)
-(bool)isOne {
    return ref->isOne();
}
@end


// MARK: BN256
@implementation BN256

+(void)initPairing {
    mcl::bn256::initPairing();
}

+(void)pairingWith:(Fp12 *)f p:(G1 *)p q:(G2 *)q {
    mcl::bn256::pairing(*f.ref, *p.ref, *q.ref);
}

+(void)mapToG1:(G1 *)p fp:(Fp *)x {
    mcl::bn256::mapToG1(*p.ref, *x.ref);
}

+(void)mapToG2:(G2 *)p fp2:(Fp2 *)x {
    mcl::bn256::mapToG2(*p.ref, *x.ref);
}

+(void)precompute:(G2 *)x coeff:(Fp6 *)coeff {
    mcl::bn256::precomputeG2(coeff.ref, *x.ref);
}

+(void)precomputedMillerLoop2mixed:(Fp12*)f p1:(G1*)p1 q1:(G2*)q1 p2:(G1*)p2 coeff:(Fp6*)coeff {
    mcl::bn256::precomputedMillerLoop2mixed(*f.ref, *p1.ref, *q1.ref, *p2.ref, coeff.ref);
}

+(void)finalExp:(Fp12 *)x y:(Fp12 *)y {
    mcl::bn256::finalExp(*x.ref, *y.ref);
}


@end
