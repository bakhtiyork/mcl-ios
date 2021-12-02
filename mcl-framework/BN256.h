//
//  BN256.h
//  mcl-framework
//
//  Created by bakhtiyor on 28/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Fr : NSObject
@end

@interface G1 : NSObject
+(void)mul:(G1*)x y:(G1*)y z:(Fr*)z;
@end

@interface G2 : NSObject
+(void)mul:(G2*)x y:(G2*)y z:(Fr*)z;;
@end

@interface Fp12 : NSObject
@end

@interface BN256 : NSObject

+(void)initPairing;
+(void)pairingWith:(Fp12*)f p:(G1*)p q:(G2*)q;

@end

NS_ASSUME_NONNULL_END
