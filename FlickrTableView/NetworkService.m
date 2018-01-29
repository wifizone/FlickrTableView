//
//  NetworkService.m
//  FlickrTableView
//
//  Created by Антон Полуянов on 23/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkHelper.h"

@interface NetworkService()

@property(nonatomic,strong) NSData *resumeData;
@property(nonatomic,strong) NSURLSession *urlSession;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,strong) NSURLSessionConfiguration *sessionConfiguration;
@property(nonatomic,strong) NSMutableArray *flickrPhotosUrls;
@property(nonatomic,strong) NSDictionary *FlickrPhotosResult;

@end

@implementation NetworkService


-(void)startImageLoading:(NSString*)name
{
    [self findFlickrPhotoWithSearchString:name];
    
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
    NSData *dataWithImage = [NSData dataWithContentsOfURL:location];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        self.progressView.hidden = YES;
        //        self.cancelDownloadButton.hidden = YES;
        //        self.imageView.image = [UIImage imageWithData:data];
        [self.output loadingIsDoneWithDataRecieved:dataWithImage];
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

-(void)findFlickrPhotoWithSearchString:(NSString *)searchString
{
    NSString *urlString = [NetworkHelper urlForSearchString:searchString];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-ww-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session ;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"json received");
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.FlickrPhotosResult = [temp copy];
            
            [self parseJsonToUrls:self.FlickrPhotosResult];
            
            for (NSString *urlString in self.flickrPhotosUrls)
            {
                self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:nil];
                self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:urlString]];
                [self.downloadTask resume];
            }
        });
        
    }];
    
    [sessionDataTask resume];
}

- (void)parseJsonToUrls: (NSDictionary *)jsonPhotos
{
    NSDictionary *photosContainer = jsonPhotos[@"photos"];
    NSDictionary *receivedPhotos = photosContainer[@"photo"];
    self.flickrPhotosUrls = [NSMutableArray new];
    
    for (NSDictionary *photoInfo in receivedPhotos)
    {
        [self.flickrPhotosUrls addObject:[NetworkHelper urlForPictureWithFarm:photoInfo[@"farm"] andWithServer:photoInfo[@"server"] andWithPicture:photoInfo[@"id"] andWithSecret:photoInfo[@"secret"]]];
    }
}

@end

