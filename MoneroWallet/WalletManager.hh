//
//  WalletManager.h
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.hh"

@interface WalletManager : NSObject

+ (WalletManager* ) getInstance;

- (Wallet *) createWalletWithPath: (NSString *)path
andPassword: (NSString *) password
andLanguage: (NSString *) language
inTestNet: (bool) testnet;

- (Wallet *) openWalletWithPath: (NSString *)path
andPassword: (NSString *) password
inTestNet: (bool) testnet;

- (Wallet *) recoveryWalletWithPath: (NSString *)path
andMemo: (NSString *) password
andRestoreHeight: (int64_t) restoreHeight
inTestNet: (bool) testnet;

- (bool) closeWallet: (Wallet *) wallet;

- (bool) walletExistsInPath: (NSString *)path;

- (NSArray*) findWalletsInPath: (NSString *)path;

- (NSString*) errorString;

- (void) setDaemonHost: (NSString *)hostname;

@end
