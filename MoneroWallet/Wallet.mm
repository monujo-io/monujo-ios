//
//  Wallet.m
//  MoneroWallet
//
//  Created by Ugo on 7/23/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import "Wallet.hh"
#import "PendingTransaction.hh"
#import "wallet/wallet2_api.h"


@interface Wallet() {
    Bitmonero::Wallet * m_walletImpl;
    UInt64 m_daemonBlockChainHeight;
    UInt64 m_daemonBlockChainTargetHeight;
    int    m_daemonBlockChainHeightTtl;
    TransactionHistory * m_history;
}
@end

int const DAEMON_BLOCKCHAIN_HEIGHT_CACHE_TTL_SECONDS = 60;

@implementation Wallet

- (id)init: (void *) internal {
    
    self = [super init];
    
    if (self) {
        m_walletImpl = (Bitmonero::Wallet *) internal;
        m_daemonBlockChainHeight = 0;
        m_daemonBlockChainHeightTtl = DAEMON_BLOCKCHAIN_HEIGHT_CACHE_TTL_SECONDS;
        
        m_history = [[TransactionHistory alloc] initWithWallet:self];
        
        //TODO Implement listener
        //m_walletImpl->setListener(new WalletListenerImpl(this));
        
    }
    return self;
}

- (void *) internal {
    return m_walletImpl;
}

- (void)dealloc {
    Bitmonero::WalletManagerFactory::getWalletManager()->closeWallet(m_walletImpl);
}

- (bool) initWalletWithDaemonAddress: (NSString*) daemonAddress
   andUpperTransactionLimit: (UInt64) upperTransactionLimit
            andIsRecovering: (bool) isRecovering
           andRestoreHeight: (UInt64) restoreHeight
{
   return m_walletImpl->init(std::string([daemonAddress UTF8String]), upperTransactionLimit);
}


- (void) initWalletAsyncWithDaemonAddress: (NSString*) daemonAddress
           andUpperTransactionLimit: (UInt64) upperTransactionLimit
                    andIsRecovering: (bool) isRecovering
                   andRestoreHeight: (UInt64) restoreHeight
{
    if (isRecovering){
        NSLog(@"RESTORING");
        m_walletImpl->setRecoveringFromSeed(true);
        m_walletImpl->setRefreshFromBlockHeight(restoreHeight);
    }
    m_walletImpl->initAsync(std::string([daemonAddress UTF8String]), upperTransactionLimit);
}



- (NSString*) getSeed {
    return [NSString stringWithUTF8String:m_walletImpl->seed().c_str()];
}

- (NSString*) getSeedLanguage {
    return [NSString stringWithUTF8String:m_walletImpl->getSeedLanguage().c_str()];
}

- (void) setSeedLanguage: (NSString*) lang {
    m_walletImpl->setSeedLanguage(std::string([lang UTF8String]));
}

//- (Wallet::Status) status {
//    return static_cast<Status>(m_walletImpl->status());
//}

- (bool) connected {
    return m_walletImpl->connected();
}

- (bool) synchronized {
    return m_walletImpl->synchronized();
}

- (NSString*) errorString {
    return [NSString stringWithUTF8String:m_walletImpl->errorString().c_str()];
}

- (bool) setPassword: (NSString*) password {
    return m_walletImpl->setPassword(std::string([password UTF8String]));
}

- (NSString*) address {
    return [NSString stringWithUTF8String:m_walletImpl->address().c_str()];
}

- (bool) store: (NSString*) path {
    return m_walletImpl->store(std::string([path UTF8String]));
}


- (bool) connectToDaemon {
    return m_walletImpl->connectToDaemon();
}

- (void) setTrustedDaemon: (bool) arg {
    m_walletImpl->setTrustedDaemon(arg);
}

- (UInt64) balance {
    return m_walletImpl->balance();
}

- (UInt64) unlockedBalance {
    return m_walletImpl->unlockedBalance();
}

- (UInt64) blockChainHeight {
    return m_walletImpl->blockChainHeight();
}

//- (UInt64) daemonBlockChainHeight {
//    // cache daemon blockchain height for some time (60 seconds by default)
//    
//    if (m_daemonBlockChainHeight == 0
//        || m_daemonBlockChainHeightTime.elapsed() / 1000 > m_daemonBlockChainHeightTtl) {
//        m_daemonBlockChainHeight = m_walletImpl->daemonBlockChainHeight();
//        m_daemonBlockChainHeightTime.restart();
//    }
//    return m_daemonBlockChainHeight;
//}

- (UInt64) daemonBlockChainTargetHeight {
    m_daemonBlockChainTargetHeight = m_walletImpl->daemonBlockChainTargetHeight();
    return m_daemonBlockChainTargetHeight;
}

- (bool) refresh {
    bool result = m_walletImpl->refresh();
    [m_history refresh];
//    if (result) {
//        [self updated];
//    }
    return result;
}

- (void) refreshAsync {
    m_walletImpl->refreshAsync();
}

- (void) setAutoRefreshInterval:(int) seconds {
    m_walletImpl->setAutoRefreshInterval(seconds);
}

- (int) autoRefreshInterval
{
    return m_walletImpl->autoRefreshInterval();
}

- (PendingTransaction*) createTransactionToAddress: (NSString*) dst_addr
                                     withPaymentId: (NSString*) payment_id
                                        andAmount: (UInt64) amount
                                    andMixinCount: (UInt32) mixin_count
                                       andPriority: (int) priority //PendingTransaction::Priority priority)
{
    Bitmonero::PendingTransaction * ptImpl = m_walletImpl->createTransaction(std::string([dst_addr UTF8String]),
                                                                             std::string([payment_id UTF8String]),
                                                                             amount,
                                                                             mixin_count,
                                                                             static_cast<Bitmonero::PendingTransaction::Priority>(priority));
    PendingTransaction * result =  [[PendingTransaction alloc] init: ptImpl];
    return result;
}

- (void) disposeTransaction: (PendingTransaction *) t {
    m_walletImpl->disposeTransaction((Bitmonero::PendingTransaction*)t.internal);
}

- (TransactionHistory*) history {
    return m_history;
}

- (NSString*) generatePaymentId
{
    return [NSString stringWithUTF8String:Bitmonero::Wallet::genPaymentId().c_str()];
}

- (NSString*) integratedAddressWithPaymentId: (NSString*) paymentId
{
    return [NSString stringWithUTF8String:m_walletImpl->integratedAddress(std::string([paymentId UTF8String])).c_str()];
}



@end


