//
//  Wallet.h
//  MoneroWallet
//
//  Created by Ugo on 7/23/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionHistory.hh"

@protocol WalletDelegate;

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
- (bool) store;

- (bool) connectToDaemon;
- (void) setTrustedDaemon: (bool) arg;
- (UInt64) balance;
- (UInt64) unlockedBalance;
- (UInt64) blockChainHeight;
- (UInt64) daemonBlockChainHeight;
- (UInt64) daemonBlockChainTargetHeight;

- (NSString*) generatePaymentId;
- (NSString*) integratedAddressWithPaymentId: (NSString*) paymentId;

- (bool) refresh;
- (void) refreshAsync;


@property NSString *paymentId;
@property(readonly) TransactionHistory* history;
@property (nonatomic, weak) id<WalletDelegate> delegate;

@end

@protocol WalletDelegate<NSObject>

//@required

@optional
- (void) walletMoneySpent: (Wallet*) wallet
            transactionId: (NSString*) txId
                   amount: (uint64_t) amount;

- (void) walletMoneyReceived: (Wallet*) wallet
               transactionId: (NSString*) txId
                      amount: (uint64_t) amount;

- (void) walletNewBlock: (Wallet*) wallet
                 height:(uint64_t) height;

- (void) walletUpdated:(Wallet*) wallet;

// called when wallet refreshed by background thread or explicitly
- (void) walletRefreshed:(Wallet *) wallet;

@end

