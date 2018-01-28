//
//  NetworkService.h
//  FlickrTableView
//
//  Created by Антон Полуянов on 23/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceProtocol.h"

@interface NetworkService : NSObject <NetworkServiceInputProtocol, NSURLSessionDownloadDelegate>

@property (nonatomic, weak) id<NetworkServiceOutputProtocol> output;  // << Делегат внешних событий

@end
