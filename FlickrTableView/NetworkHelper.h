//
//  NetworkHelper.h
//  FlickrTableView
//
//  Created by Антон Полуянов on 29/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject

+ (NSString *)urlForSearchString: (NSString *)searchString;
+ (NSString *)urlForPictureWithFarm: (NSString *)farmID andWithServer: (NSString *)serverId andWithPicture: (NSString *)pictureId andWithSecret: (NSString *)secret;

@end
