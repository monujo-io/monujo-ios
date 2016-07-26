//
//  Wallet.m
//  MoneroWallet
//
//  Created by Ugo on 7/23/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import "Wallet.h"
#import "wallet2.h"
#import <mnemonics/electrum-words.h>

@interface Wallet() {
    @private
    std::unique_ptr<tools::wallet2> m_wallet;
}
@end

@implementation Wallet

-(NSString*) generateInFile:(NSString*) file
          withPassword:(NSString*) _password
            andTestNet:(bool) testnet
{

    crypto::secret_key recovery_key;

    std::string mnemonic_language = get_mnemonic_language();
    if (mnemonic_language.empty()) {
            return nil;
    }
    
    std::string wallet_file = std::string([file UTF8String]);
    std::string password = std::string([_password UTF8String]);

    self->m_wallet.reset(new tools::wallet2(testnet));
    //self->m_wallet->callback(this);
    self->m_wallet->set_seed_language(mnemonic_language);
    
    crypto::secret_key recovery_val;
    try
    {
        recovery_val = m_wallet->generate(wallet_file, password, recovery_key, false, false);
        NSLog(@"Generated new wallet: %@", [NSString stringWithUTF8String:m_wallet->get_account().get_public_address_str(m_wallet->testnet()).c_str()]);
        NSLog(@"View key: %@", [NSString stringWithUTF8String:epee::string_tools::pod_to_hex(m_wallet->get_account().get_keys().m_view_secret_key).c_str()]);
    }
    catch (const std::exception& e)
    {
        NSLog(@"failed to generate new wallet: %@", [NSString stringWithUTF8String: e.what()]);
        return nil;
    }
    
    //m_wallet->init(m_daemon_address);
    
    // convert rng value to electrum-style word list
    std::string electrum_words;
    
    crypto::ElectrumWords::bytes_to_words(recovery_val, electrum_words, mnemonic_language);
    
    NSString* res = [@[@"**********************************************************************",
      @"Your wallet has been generated!",
      @"To start synchronizing with the daemon, use \"refresh\" command.",
      @"Use \"help\" command to see the list of available commands.",
      @"Always use \"exit\" command when closing simplewallet to save your",
      @"current session's state. Otherwise, you might need to synchronize",
      @"your wallet again (your wallet keys are NOT at risk in any case).",
      [NSString stringWithUTF8String: electrum_words.c_str()],
      @"**********************************************************************"
       ] componentsJoinedByString: @"\n"];
    NSLog(res);
    return res;
}

std::string get_mnemonic_language() {
    std::vector<std::string> language_list;
    crypto::ElectrumWords::get_language_list(language_list);
    return language_list.front();
}

@end
