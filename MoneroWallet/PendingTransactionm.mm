//
//  PendingTransaction.m
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import "PendingTransaction.hh"
#import "wallet/wallet2_api.h"

@interface PendingTransaction(){
    Bitmonero::PendingTransaction* m_pendingTransaction;
}
@end


@implementation PendingTransaction

//Status status() const;

-(instancetype) init: (void *) internal {
    
    self = [super init];
    
    if (self) {
        m_pendingTransaction = (Bitmonero::PendingTransaction*) internal;
    }
    return self;
}

- (void*) internal {
    return m_pendingTransaction;
}

- (bool) commit {
    return m_pendingTransaction->commit();
}
- (NSString*) errorString {
    return [NSString stringWithUTF8String: m_pendingTransaction->errorString().c_str()];
}

- (uint64_t) amount {
    return m_pendingTransaction->amount();
}

- (uint64_t) fee {
    return m_pendingTransaction->fee();
}

- (uint64_t) dust {
    return m_pendingTransaction->dust();
}
@end
