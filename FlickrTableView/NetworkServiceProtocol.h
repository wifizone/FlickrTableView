//
//  NetworkServiceProtocol.h
//  FlickrTableView
//
//  Created by Антон Полуянов on 23/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkServiceOutputProtocol <NSObject>
@optional

-(void)loadingContinuesWithProgress: (double)progress;
-(void)loadingIsDoneWithDataRecieved: (NSData *)dataRecieved;

@end

@protocol NetworkServiceInputProtocol <NSObject>
@optional

-(void)configureUrlSessionWithParams: (NSDictionary *)params;
-(void)startImageLoading: (NSString *)searchName;

//NEXT step

-(BOOL)resumeNetworkLoading;
-(void)suspendNetworkLoading;

-(void)findFlickrPhotoWithSearchString:(NSString *)searchString;



@end
