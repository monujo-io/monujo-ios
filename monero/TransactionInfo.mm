//
//  TransactionInfo.m
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import "TransactionInfo.hh"

#import "wallet/wallet2_api.h"

@interface TransactionInfo() {
    Monero::TransactionInfo* m_transactionInfoImpl;
}
@end


@implementation TransactionInfo

- (instancetype)init: (void *) internal {
    self = [super init];
    
    if (self) {
        m_transactionInfoImpl = (Monero::TransactionInfo*) internal;
    }
    return self;
}

- (int) direction {
    return m_transactionInfoImpl->direction();
}

- (bool) pending {
    return m_transactionInfoImpl->isPending();
}

- (bool) failed{
    return m_transactionInfoImpl->isFailed();
    
}

- (uint64_t) amount {
    return m_transactionInfoImpl->amount();
    
}

- (uint64_t) fee {
    return m_transactionInfoImpl->fee();
}

- (uint64_t) blockHeight{
    return m_transactionInfoImpl->blockHeight();
    
}
//@property (readonly) NSString *hash;

- (NSDate *) timestamp {
    return [NSDate dateWithTimeIntervalSince1970:m_transactionInfoImpl->timestamp()];
}

- (NSString*) paymentId {
    return [NSString stringWithUTF8String:m_transactionInfoImpl->paymentId().c_str()];
}

- (NSArray *) transfers {
    return @[];
}

@end

