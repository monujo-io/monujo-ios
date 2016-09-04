//
//  Wallet.h
//  MoneroWallet
//
//  Created by Ugo on 7/23/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Wallet : NSObject

- (id)initWithDaemonAddress: (NSString*) daemonAdress;

-(NSString*) generateInFile:(NSString*) file
          withPassword:(NSString*) password
            andTestNet:(bool) testnet;

- (NSString*) openInFile:(NSString*) file
            withPassword:(NSString*) _password
              andTestNet:(bool) testnet;

- (bool) refreshWithStartHeight:(uint64_t) start_height
                       andReset:(bool) reset;

- (NSString*) show_balance_unlocked;

@end
