//
//  TransactionHistory.m
//  MoneroWallet
//
//  Created by Ugo on 2016/11/05.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import "TransactionHistory.hh"

#import "wallet/wallet2_api.h"
#import "TransactionInfo.hh"
#import "Wallet.hh"

@interface TransactionHistory() {
    Monero::TransactionHistory* m_transactionHistoryImpl;
}
@end


@implementation TransactionHistory

- (instancetype) initWithWallet: (Wallet*) wallet {
    self = [super init];
    
    if (self) {
        m_transactionHistoryImpl = ((Monero::Wallet*)[wallet internal])->history();
    }
    return self;
}

- (int) count {
    return m_transactionHistoryImpl->count();
}

- (NSArray*) getAll {
    NSMutableArray* res = [NSMutableArray new];

    std::vector<Monero::TransactionInfo *> a = m_transactionHistoryImpl->getAll();
    for(auto const& value: a) {
        [res addObject:[[TransactionInfo alloc] init: value]];
    }
    return [res copy];

}
- (void) refresh {
    m_transactionHistoryImpl->refresh();
}

@end



