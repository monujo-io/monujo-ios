//
//  Wallet.h
//  MoneroWallet
//
//  Created by Ugo on 7/23/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Wallet : NSObject

-(NSString*) generateInFile:(NSString*) file
          withPassword:(NSString*) password
            andTestNet:(bool) testnet;


@end
