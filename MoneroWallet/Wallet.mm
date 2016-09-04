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
#import <rpc/core_rpc_server_commands_defs.h>

using namespace cryptonote;
using namespace epee;


@interface Wallet() {
    NSString* _daemonAddress;

    @private
    std::unique_ptr<tools::wallet2> m_wallet;
    std::string m_daemon_address;
    net_utils::http::http_simple_client m_http_client;
    std::atomic<bool> m_in_manual_refresh;
}
@end

@implementation Wallet

- (id)initWithDaemonAddress: (NSString*) daemonAddress {
    self = [super init];
    
    if (self) {
        // initialize instance variables here
        _daemonAddress = daemonAddress;
        m_daemon_address = std::string([daemonAddress UTF8String]);
    }
    
    return self;
}

- (NSString*) openInFile:(NSString*) file
            withPassword:(NSString*) _password
              andTestNet:(bool) testnet
{
    std::string m_wallet_file = std::string([file UTF8String]);
    std::string password = std::string([_password UTF8String]);
    
    m_wallet.reset(new tools::wallet2(testnet));
    
    try
    {
        m_wallet->load(m_wallet_file, password);
        
        NSString* addr = [NSString stringWithUTF8String: m_wallet->get_account().get_public_address_str(m_wallet->testnet()).c_str()];
        
        NSLog(@"Opened %@ wallet at %@", m_wallet->watch_only() ? @"watch-only" : @"", addr);
        // If the wallet file is deprecated, we should ask for mnemonic language again and store
        // everything in the new format.
        // NOTE: this is_deprecated() refers to the wallet file format before becoming JSON. It does not refer to the "old english" seed words form of "deprecated" used elsewhere.
        if (m_wallet->is_deprecated())
        {
            if (m_wallet->is_deterministic())
            {
                NSLog(@"You had been using a deprecated version of the wallet. Please proceed to upgrade your wallet.");
                
                std::string mnemonic_language = get_mnemonic_language();
                if (mnemonic_language.empty())
                    return nil;
                m_wallet->set_seed_language(mnemonic_language);
                m_wallet->rewrite(m_wallet_file, password);
                
                // Display the seed
                std::string seed;
                m_wallet->get_seed(seed);
                return [NSString stringWithUTF8String: seed.c_str()];
            }
            else
            {
                NSLog(@"You had been using a deprecated version of the wallet. Your wallet file format is being upgraded now.");
                m_wallet->rewrite(m_wallet_file, password);
                return nil;
            }
        }
        return addr;
    }
    catch (const std::exception& e)
    {
        NSLog(@"ailed to load wallet: %s", e.what());

        // only suggest removing cache if the password was actually correct
        if (m_wallet->verify_password(password)) {
           NSLog(@"You may want to remove the file \"%s\" and try again", m_wallet_file.c_str());
        }
        return nil;
    }
}

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


- (bool) refreshWithStartHeight:(uint64_t) start_height
                            andReset:(bool) reset
{
    if (![self try_connect_to_daemon: false])
        return true;
    
    //LOCK_IDLE_SCOPE();
    
    if (reset)
        m_wallet->rescan_blockchain(false);
    
    NSLog(@"Starting refresh...");
    
    uint64_t fetched_blocks = 0;
    bool ok = false;
    std::ostringstream ss;
    try
    {
        m_in_manual_refresh.store(true, std::memory_order_relaxed);
        epee::misc_utils::auto_scope_leave_caller scope_exit_handler = epee::misc_utils::create_scope_leave_handler([&](){m_in_manual_refresh.store(false, std::memory_order_relaxed);});
        m_wallet->refresh(start_height, fetched_blocks);
        ok = true;
        // Clear line "Height xxx of xxx"
         NSLog(@"Refresh done, blocks received: %llu", fetched_blocks);
        [self show_balance_unlocked];
    }
    catch (const tools::error::daemon_busy&)
    {
        NSLog(@"daemon is busy. Please try again later.");
    }
    catch (const tools::error::no_connection_to_daemon&)
    {
         NSLog(@"no connection to daemon. Please make sure daemon is running.");
    }
    catch (const tools::error::wallet_rpc_error& e)
    {
        LOG_ERROR("RPC error: " << e.to_string());
        NSLog(@"RPC error: %s", e.what());
    }
    catch (const tools::error::refresh_error& e)
    {
        LOG_ERROR("refresh error: " << e.to_string());
        NSLog(@"refresh error: %s", e.what());
    }
    catch (const tools::error::wallet_internal_error& e)
    {
        LOG_ERROR("internal error: " << e.to_string());
        NSLog(@"internal error: %s", e.what());
    }
    catch (const std::exception& e)
    {
        LOG_ERROR("unexpected error: " << e.what());
        NSLog(@"unexpected error: %s", e.what());
    }
    catch (...)
    {
        LOG_ERROR("unknown error");
        NSLog(@"unknown error");
    }
    
    if (!ok)
    {
        NSLog(@"refresh failed: %s. Blocks received: %llu", ss.str().c_str(), fetched_blocks);
    }
    
    return true;
}



- (NSString*) show_balance_unlocked {
    NSString* res = [NSString stringWithFormat:@"Balance: %llu, unlocked balance: %llu", m_wallet->balance(), m_wallet->unlocked_balance()];
    NSLog(res);
    return res;
}


- (uint64_t) get_daemon_blockchain_height {
    COMMAND_RPC_GET_HEIGHT::request req;
    COMMAND_RPC_GET_HEIGHT::response res = boost::value_initialized<COMMAND_RPC_GET_HEIGHT::response>();
    bool r = net_utils::invoke_http_json_remote_command2(m_daemon_address + "/getheight", req, res, m_http_client);
    std::string err = interpret_rpc_response(r, res.status);
    return res.height;
}

//----------------------------------------------------------------------------------------------------
- (NSString*) show_blockchain_height {
    if (![self try_connect_to_daemon: false])
        return @"Could not connect to daemon";
    
    std::string err;
    uint64_t bc_height = self.get_daemon_blockchain_height;
    NSString* res;
    if (err.empty()) {
        res = [NSString stringWithFormat:@"bc_eight: %llu", bc_height];
    } else {
        res = [NSString stringWithFormat:@"failed to get blockchain height: %s", err.c_str()];
    }
    NSLog(res);
    return res;
}


- (bool) try_connect_to_daemon:(bool) silent {
//    bool same_version = false;
    if (!m_wallet->check_connection())
    {
        if (!silent)
            NSLog(@"wallet failed to connect to daemon: %@ . Daemon either is not started or wrong port was passed. Please make sure daemon is running or restart the wallet with the correct daemon address.", _daemonAddress);
        return false;
    }
//    if (!m_allow_mismatched_daemon_version && !same_version)
//    {
//        if (!silent)
//            fail_msg_writer() << tr("Daemon uses a different RPC version that the wallet: ") << m_daemon_address << ". " <<
//            tr("Either update one of them, or use --allow-mismatched-daemon-version.");
//        return false;
//    }
    return true;
}


std::string get_mnemonic_language() {
    std::vector<std::string> language_list;
    crypto::ElectrumWords::get_language_list(language_list);
    return language_list.front();
}

inline std::string interpret_rpc_response(bool ok, const std::string& status)
{
    std::string err;
    if (ok)
    {
        if (status == CORE_RPC_STATUS_BUSY)
        {
            err = std::string("daemon is busy. Please try again later.");
        }
        else if (status != CORE_RPC_STATUS_OK)
        {
            err = status;
        }
    }
    else
    {
        err = std::string("possibly lost connection to daemon");
    }
    return err;
}

@end
