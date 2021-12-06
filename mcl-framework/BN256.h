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
@end

@interface G1 : NSObject
+(void)mul:(G1*)x y:(G1*)y z:(Fr*)z;
@end

@interface G2 : NSObject
+(void)mul:(G2*)x y:(G2*)y z:(Fr*)z;;
@end

@interface Fp : NSObject
-(void)setHashOf:(NSString*)hash;
@end

@interface Fp2 : NSObject
-(instancetype)initWithInt:(NSInteger)a;
@end

@interface Fp12 : NSObject

@end

@interface BN256 : NSObject

+(void)initPairing;
+(void)pairingWith:(Fp12*)f p:(G1*)p q:(G2*)q;
+(void)mapToG1:(G1*)p fp:(Fp*)x;
+(void)mapToG2:(G2*)p fp2:(Fp2*)x;

@end

NS_ASSUME_NONNULL_END
