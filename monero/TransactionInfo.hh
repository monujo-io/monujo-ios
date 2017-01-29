//
//  TransactionInfo.h
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Transfer : NSObject

- (instancetype)initWithAmount: (uint64_t) amount
                    andAddress: (NSString *) address;

@property (readonly) uint64_t amount;
@property (readonly) NSString *address;

@end

@interface TransactionInfo : NSObject

- (instancetype)init: (void *) internal;

//! in/out
@property (readonly) int direction;

@property (readonly) bool pending;
@property (readonly) bool failed;
@property (readonly) uint64_t amount;
@property (readonly) uint64_t fee;
@property (readonly) uint64_t blockHeight;
@property (readonly) NSString *hash;
@property (readonly) NSDate *timestamp;
@property (readonly) NSString *paymentId;
//@property (readonly) uint64_t confirmations;
@property (readonly) NSArray *transfers;

@end
