//
//  WalletManager.m
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import "WalletManager.hh"

#import "wallet/wallet2_api.h"

@interface WalletManager() {
    Bitmonero::WalletManager* m_walletManagerImpl;
}

@end

@implementation WalletManager

+ (WalletManager* ) getInstance {
    return [[WalletManager alloc] initWithWalletManager: Bitmonero::WalletManagerFactory::getWalletManager()];
}

- (instancetype)initWithWalletManager: (Bitmonero::WalletManager*) walletManagerImpl {
    self = [super init];
    
    if (self) {
        m_walletManagerImpl = walletManagerImpl;
    }
    return self;
}

- (Wallet *) createWalletWithPath: (NSString *) path
                      andPassword: (NSString *) password
                      andLanguage: (NSString *) language
                        inTestNet: (bool) testnet {
    
    return [[Wallet alloc] init: m_walletManagerImpl->createWallet(std::string([path UTF8String]), std::string([password UTF8String]), std::string([language UTF8String]), testnet)];
}

- (Wallet *) openWalletWithPath: (NSString *) path
                    andPassword: (NSString *) password
                      inTestNet: (bool) testnet {
    return [[Wallet alloc] init: m_walletManagerImpl->openWallet(std::string([path UTF8String]), std::string([password UTF8String]), testnet)];
}

- (Wallet *) recoveryWalletWithPath: (NSString *) path
                            andMemo: (NSString *) memo
                   andRestoreHeight: (uint64_t) restoreHeight
                          inTestNet: (bool) testnet {
    return [[Wallet alloc] init: m_walletManagerImpl->recoveryWallet(std::string([path UTF8String]), std::string([memo UTF8String]), testnet, restoreHeight)];
    
}

- (bool) closeWallet: (Wallet *) wallet {
    return m_walletManagerImpl->closeWallet((Bitmonero::Wallet*)[wallet internal]);
}

- (bool) walletExistsInPath: (NSString *) path {
    return m_walletManagerImpl->walletExists(std::string([path UTF8String]));
    
}

- (NSArray*) findWalletsInPath: (NSString *) path {
    NSMutableArray* res = [NSMutableArray new];
    std::vector<std::string> a = m_walletManagerImpl->findWallets(std::string([path UTF8String]));
    for(auto const& value: a) {
        [res addObject:[NSString stringWithUTF8String: value.c_str()]];
    }
    return [res copy];
}

- (NSString*) errorString {
    return [NSString stringWithUTF8String: m_walletManagerImpl-> errorString().c_str()];
}

- (void) setDaemonHost: (NSString *)hostname {
    m_walletManagerImpl->walletExists(std::string([hostname UTF8String]));
}

@end

