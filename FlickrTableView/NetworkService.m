//
//  NetworkService.m
//  FlickrTableView
//
//  Created by Антон Полуянов on 23/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import "NetworkService.h"

@interface NetworkService()

@property(nonatomic,strong) NSData *resumeData;
@property(nonatomic,strong) NSURLSession *urlSession;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,strong) NSURLSessionConfiguration *sessionConfiguration;

@end

@implementation NetworkService


-(void)startImageLoading:(NSString*)name
{
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:nil];
    NSString *key = @"fe3f851fb56c3916a4ef3aa6772c236b";
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=10&format=json&nojsoncallback=1", key, name];
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:urlString]];
    [self.downloadTask resume];
}
-(void)suspendNetworkLoading
{
    if (!self.downloadTask)
        return;
    self.resumeData = nil;
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (!resumeData)
        {
            return;
        }
        self.resumeData = resumeData;
        self.downloadTask = nil;
    }];
    ////#else
    //    [self.networkService suspendNetworkLoading];
    ////#endif
    //    self.resumeDownloadButton.hidden = NO;
    //    self.cancelDownloadButton.hidden = YES;
}

-(BOOL)resumeNetworkLoading
{
    if (!self.resumeData)
        return NO;
    self.downloadTask = [self.urlSession downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    self.resumeData = nil;
    
    //    self.resumeDownloadButton.hidden = YES;
    //    self.cancelDownloadButton.hidden = NO;
    return YES;
}

-(void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *dataWithJson = [NSData dataWithContentsOfURL:location];
    NSString *jsonData = [[NSString alloc] initWithData:dataWithJson encoding:NSUTF8StringEncoding];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        self.progressView.hidden = YES;
        //        self.cancelDownloadButton.hidden = YES;
        //        self.imageView.image = [UIImage imageWithData:data];
        [self.output loadingIsDoneWithDataRecieved:dataWithJson];
        
    });
}


//-(void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
//    NSLog(@"Download Progress - %f", progress);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //        self.progressView.progress = progress;
//        [self.output loadingContinuesWithProgress:progress];
//    });
//}
//

//-(void)findFlickrPhotoWithSearchString:(NSString *)searchString
//{
//    NSString *urlString = [NetworkHelper URLForSearchString:searchString];
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/x-ww-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setTimeoutInterval:15];
//}


@end

