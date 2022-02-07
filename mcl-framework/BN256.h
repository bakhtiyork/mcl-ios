//
//  BN256.h
//  mcl-framework
//
//  Created by bakhtiyor on 28/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Fr : NSObject
-(void)setRand;
-(void)setStr:(NSString*)str;
@end

@interface G1 : NSObject
+(void)mul:(G1*)x y:(G1*)y z:(Fr*)z;
+(void)add:(G1*)r p:(G1*)p q:(G1*)q;
-(void)setStr:(NSString*)str;
-(void)normalize;
@end

@interface G2 : NSObject
+(void)mul:(G2*)x y:(G2*)y z:(Fr*)z;
-(void)setStr:(NSString*)str;
-(void)normalize;
@end

@interface Fp : NSObject
-(void)setHashOf:(NSString*)hash;
-(void)setStr:(NSString*)str;
@end

@interface Fp2 : NSObject
-(instancetype)initWithInt:(NSInteger)a;
-(void)setStr:(NSString*)str;
@end

@interface Fp6 : NSObject
-(void)setStr:(NSString*)str;
@end

@interface Fp12 : NSObject
-(void)setStr:(NSString*)str;
-(bool)isOne;
@end

@interface BN256 : NSObject

+(void)initPairing;
+(void)pairingWith:(Fp12*)f p:(G1*)p q:(G2*)q;
+(void)mapToG1:(G1*)p fp:(Fp*)x;
+(void)mapToG2:(G2*)p fp2:(Fp2*)x;
+(void)precompute:(G2*)x coeff:(Fp6*)coeff;
//Fp12 f, G1 p1, G2 q1, G1 p2, Fp6 coeff
+(void)precomputedMillerLoop2mixed:(Fp12*)f p1:(G1*)p1 q1:(G2*)q1 p2:(G1*)p2 coeff:(Fp6*)coeff;
+(void)finalExp:(Fp12*)x y:(Fp12*)y;
@end

NS_ASSUME_NONNULL_END
