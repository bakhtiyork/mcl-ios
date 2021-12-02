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

#define REF_CLASS_BOILERPLATE(ref_class) \
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
    ss << &ref; \
    return [NSString \
            stringWithCString:ss.str().c_str() \
            encoding:NSUTF8StringEncoding]; \
} \
\
-(void)dealloc { \
  delete ref; \
} \



REF_CLASS_EXTENSION(G1, mcl::bn256::G1)
REF_CLASS_EXTENSION(G2, mcl::bn256::G2)
REF_CLASS_EXTENSION(Fr, mcl::bn256::Fr)
REF_CLASS_EXTENSION(Fp12, mcl::bn256::Fp12)


// MARK: G1
@implementation G1 {
    mcl::bn256::G1* ref;
}
REF_CLASS_BOILERPLATE(mcl::bn256::G1)

+(void)mul:(G1 *)x y:(G1 *)y z:(Fr *)z {
    mcl::bn256::G1::mul(*x.ref, *y.ref, *z.ref);
}
@end

// MARK: G2
@implementation G2 {
    mcl::bn256::G2* ref;
}
REF_CLASS_BOILERPLATE(mcl::bn256::G2)

+(void)mul:(G2 *)x y:(G2 *)y z:(Fr *)z {
    mcl::bn256::G2::mul(*x.ref, *y.ref, *z.ref);
}
@end

// MARK: Fr
@implementation Fr {
    mcl::bn256::Fr* ref;
}
REF_CLASS_BOILERPLATE(mcl::bn256::Fr)

@end

// MARK: Fp12
@implementation Fp12 {
    mcl::bn256::Fp12* ref;
}
REF_CLASS_BOILERPLATE(mcl::bn256::Fp12)

@end


// MARK: BN256
@implementation BN256

+(void)initPairing {
    mcl::bn256::initPairing();
}

+(void)pairingWith:(Fp12 *)f p:(G1 *)p q:(G2 *)q {
    mcl::bn256::pairing(*f.ref, *p.ref, *q.ref);
}

@end
