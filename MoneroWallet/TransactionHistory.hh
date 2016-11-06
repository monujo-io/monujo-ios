//
//  TransactionHistory.h
//  MoneroWallet
//
//  Created by Ugo on 2016/11/05.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Wallet.hh"



@interface TransactionHistory : NSObject

- (instancetype) initWithWallet: (Wallet*) wallet;
- (int) count;
- (NSArray*) getAll;
- (void) refresh;

@end

