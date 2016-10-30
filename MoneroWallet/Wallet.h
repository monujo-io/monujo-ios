//
//  Wallet.h
//  MoneroWallet
//
//  Created by Ugo on 7/23/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

#import <Foundation/Foundation.h>


extern int const DAEMON_BLOCKCHAIN_HEIGHT_CACHE_TTL_SECONDS;


@interface Wallet : NSObject

@property NSString *paymentId;

@end
