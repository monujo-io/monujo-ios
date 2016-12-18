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


class WalletListenerImpl : public Bitmonero::WalletListener
{
public:
    WalletListenerImpl(Wallet * w)
    : m_wallet(w)
    {

    }

    virtual void moneySpent(const std::string &txId, uint64_t amount)
    {
        if (m_wallet.delegate != nil && [m_wallet.delegate respondsToSelector: @selector(walletMoneySpent:transactionId:amount:)]) {
            [m_wallet.delegate walletMoneySpent: m_wallet
                                  transactionId: [NSString stringWithUTF8String:txId.c_str()]
                                         amount: amount];
        }
    }


    virtual void moneyReceived(const std::string &txId, uint64_t amount)
    {
        if (m_wallet.delegate != nil && [m_wallet.delegate respondsToSelector: @selector(walletMoneyReceived:transactionId:amount:)]) {

            [m_wallet.delegate walletMoneyReceived: m_wallet
                                     transactionId:[NSString stringWithUTF8String:txId.c_str()]
                                            amount: amount];
        }
    }

    virtual void newBlock(uint64_t height)
    {
        if (m_wallet.delegate != nil && [m_wallet.delegate respondsToSelector: @selector(walletNewBlock:height:)]) {

            [m_wallet.delegate walletNewBlock: m_wallet
                                       height: height];
        }
    }

    virtual void updated()
    {
        if (m_wallet.delegate != nil && [m_wallet.delegate respondsToSelector: @selector(walletUpdated:)]) {
            [m_wallet.delegate walletUpdated: m_wallet];
        }
    }

    // called when wallet refreshed by background thread or explicitly
    virtual void refreshed()
    {
        if (m_wallet.delegate != nil && [m_wallet.delegate respondsToSelector: @selector(walletRefreshed:)]) {
            [m_wallet.delegate walletRefreshed: m_wallet];
        }
    }

private:
    Wallet * m_wallet;
};


@interface Wallet() {
    Bitmonero::Wallet * m_walletImpl;
    UInt64 m_daemonBlockChainHeight;
    UInt64 m_daemonBlockChainTargetHeight;
    CFTimeInterval    m_daemonBlockChainHeightTtl;
    CFAbsoluteTime    m_daemonBlockChainHeightTime;

    CFTimeInterval    m_daemonBlockChainTargetHeightTtl;
    CFAbsoluteTime    m_daemonBlockChainTargetHeightTime;

    TransactionHistory * m_history;
}
@end

CFTimeInterval const DAEMON_BLOCKCHAIN_HEIGHT_CACHE_TTL_SECONDS = 10;
CFTimeInterval const DAEMON_BLOCKCHAIN_TARGET_HEIGHT_CACHE_TTL_SECONDS = 60;

@implementation Wallet

- (id)init: (void *) internal {

    self = [super init];

    if (self) {
        m_walletImpl = (Bitmonero::Wallet *) internal;
        m_daemonBlockChainHeight = 0;
        m_daemonBlockChainHeightTtl = DAEMON_BLOCKCHAIN_HEIGHT_CACHE_TTL_SECONDS;
        m_daemonBlockChainHeightTime = 0;
        m_daemonBlockChainTargetHeightTtl = DAEMON_BLOCKCHAIN_TARGET_HEIGHT_CACHE_TTL_SECONDS;
        m_daemonBlockChainTargetHeightTime = 0;

        m_history = [[TransactionHistory alloc] initWithWallet:self];

        //TODO Implement listener
        m_walletImpl->setListener(new WalletListenerImpl(self));
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

- (bool) store {
    return [self store:@""];
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

- (UInt64) daemonBlockChainHeight {
    // cache daemon blockchain height for some time (60 seconds by default)

    if (m_daemonBlockChainHeight == 0
        || CFAbsoluteTimeGetCurrent() - m_daemonBlockChainHeightTime > m_daemonBlockChainHeightTtl) {
        m_daemonBlockChainHeight = m_walletImpl->daemonBlockChainHeight();
        m_daemonBlockChainHeightTime = CFAbsoluteTimeGetCurrent();
    }
    return m_daemonBlockChainHeight;
}

- (UInt64) daemonBlockChainTargetHeight {
    // cache daemon blockchain height for some time (60 seconds by default)

    if (m_daemonBlockChainTargetHeight == 0
        || CFAbsoluteTimeGetCurrent() - m_daemonBlockChainTargetHeightTime > m_daemonBlockChainTargetHeightTtl) {
        m_daemonBlockChainTargetHeight = m_walletImpl->daemonBlockChainTargetHeight();
        m_daemonBlockChainTargetHeightTime = CFAbsoluteTimeGetCurrent();
    }
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

+ (NSString*) displayAmount: (UInt64) amount {
    return [NSString stringWithUTF8String: Bitmonero::Wallet::displayAmount(amount).c_str()];
}

+ (UInt64) amountFromString: (NSString*) amount
{
    return Bitmonero::Wallet::amountFromString(std::string([amount UTF8String]));
}

+ (UInt64) amountFromDouble: (double) amount
{
    return Bitmonero::Wallet::amountFromDouble(amount);
}


@end


