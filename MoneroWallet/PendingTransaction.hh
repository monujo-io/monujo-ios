//
//  PendingTransaction.h
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingTransaction : NSObject


-(instancetype) init: (void *) internal;

//Status status() const;

- (bool) commit;
- (NSString*) errorString;

@property (readonly) uint64_t amount;
@property (readonly) uint64_t fee;
@property (readonly) uint64_t dust;
@property (readonly) void *internal;


@end
