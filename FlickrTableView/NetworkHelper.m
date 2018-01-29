//
//  NetworkHelper.m
//  FlickrTableView
//
//  Created by Антон Полуянов on 29/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (NSString *)urlForSearchString:(NSString *)searchString
{
    NSString *key = @"fe3f851fb56c3916a4ef3aa6772c236b";
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=25&format=json&nojsoncallback=1", key, searchString];
}

+ (NSString *)urlForPictureWithFarm:(NSString *)farmID andWithServer:(NSString *)serverId andWithPicture:(NSString *)pictureId andWithSecret:(NSString *)secret
{
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmID, serverId, pictureId, secret];
}

@end
