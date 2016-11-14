//
//  Wallet.h
//  MoneroWallet
//
//  Created by Ugo on 7/23/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionHistory.hh"

extern int const DAEMON_BLOCKCHAIN_HEIGHT_CACHE_TTL_SECONDS;


@interface Wallet : NSObject

- (id)init: (void *) internal;

- (bool) initWalletWithDaemonAddress: (NSString*) daemonAddress
            andUpperTransactionLimit: (UInt64) upperTransactionLimit
                     andIsRecovering: (bool) isRecovering
                    andRestoreHeight: (UInt64) restoreHeigh;

- (void) initWalletAsyncWithDaemonAddress: (NSString*) daemonAddress
                 andUpperTransactionLimit: (UInt64) upperTransactionLimit
                          andIsRecovering: (bool) isRecovering
                         andRestoreHeight: (UInt64) restoreHeight;

- (void *) internal;

- (NSString*) getSeed;

- (NSString*) getSeedLanguage;

- (void) setSeedLanguage: (NSString*) lang;

- (bool) connected;

- (bool) synchronized;

- (NSString*) errorString;
- (bool) setPassword: (NSString*) password;
- (NSString*) address;
- (bool) store: (NSString*) path;

- (bool) connectToDaemon;
- (void) setTrustedDaemon: (bool) arg;
- (UInt64) balance;
- (UInt64) unlockedBalance;
- (UInt64) blockChainHeight;

- (NSString*) generatePaymentId;
- (NSString*) integratedAddressWithPaymentId: (NSString*) paymentId;


@property NSString *paymentId;
@property(readonly) TransactionHistory* history;


@end


