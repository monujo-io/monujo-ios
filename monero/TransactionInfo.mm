//
//  TransactionInfo.m
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import "TransactionInfo.hh"

#import "wallet/wallet2_api.h"

@implementation Transfer

- (instancetype)initWithAmount:(uint64_t)amount andAddress:(NSString *)address {
    self = [super init];

    if (self) {
        _amount = amount;
        _address = address;
    }
    return self;
}

@end

@interface TransactionInfo() {
    Monero::TransactionInfo* m_transactionInfoImpl;
    NSArray* m_transfers;
}
@end

@implementation TransactionInfo

- (instancetype)init: (void *) internal {
    self = [super init];

    if (self) {
        m_transactionInfoImpl = (Monero::TransactionInfo*) internal;
        m_transfers = @[];
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

- (NSString*) hash {
    return [NSString stringWithUTF8String:m_transactionInfoImpl->hash().c_str()];
}

- (NSString*) paymentId {
    return [NSString stringWithUTF8String:m_transactionInfoImpl->paymentId().c_str()];
}

//- (uint64_t) confirmations {
//    return m_transactionInfoImpl->confirmations();
//}

- (NSArray *) transfers {

    if ([m_transfers count] > 0) {
        return m_transfers;
    }

    NSMutableArray* transfers = [NSMutableArray new];
    for(auto const& t: m_transactionInfoImpl->transfers()) {
        Transfer* transfer = [[Transfer alloc]initWithAmount:t.amount andAddress:[NSString stringWithUTF8String:t.address.c_str()]];
        [transfers addObject:transfer];
    }

    m_transfers = [transfers copy];
    return m_transfers;
}

@end

