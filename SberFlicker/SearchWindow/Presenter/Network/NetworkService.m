//
//  NetworkService.m
//  SberFlicker
//
//  Created by Сергей Грызин on 19/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkHelper.h"
#import "PhotoJSONModel.h"

@implementation NetworkService

#pragma mark - Getting PhotoJSON

- (void)findPhotosBySearchString:(NSString *)searchString onPage:(NSInteger)page completion:(void (^)(PhotoJSONModel *))completion
{
    NSString *urlString = [NetworkHelper URLFromSearchString:searchString forPage:page];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            completion(nil);
        }
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSLog(@"%@", jsonDict);
        if ([jsonDict[@"stat"] isEqualToString:@"fail"])
        {
            completion(nil);
        }
        else
        {
            completion([self parseJSONFromDict:jsonDict[@"photos"]]);
        }
    }];
    
    [dataTask resume];
}

- (PhotoJSONModel *)parseJSONFromDict:(NSDictionary *)dict
{
    PhotoJSONModel *photoJSON = [PhotoJSONModel new];
    photoJSON.page = (NSInteger)dict[@"page"];
    photoJSON.pagesTotal = (NSInteger)dict[@"pages"];
    NSArray *array = dict[@"photo"];
    photoJSON.photos = [self parsePhotoJSONFromArray:array];
    
    return photoJSON;
}

- (NSArray<PhotoModel *> *)parsePhotoJSONFromArray:(NSArray *)array
{
    NSMutableArray<PhotoModel *> *photosArray = [NSMutableArray new];
    for (int i = 0; i < array.count; i++)
    {
        PhotoModel *photo = [PhotoModel new];
        photo.farm = (NSInteger)array[i][@"farm"];
        photo.ID = (NSInteger)array[i][@"id"];
        photo.secret = (NSInteger)array[i][@"secret"];
        photo.server = (NSInteger)array[i][@"server"];
        photo.title = array[i][@"title"];
        photo.pictureURL = array[i][@"url_h"];
        photo.thumbnailPictureURL = array[i][@"url_s"];
        
        
        [photosArray addObject:photo];
    }
    
    return photosArray;
}


#pragma mark - Getting image

- (void)getImageFromURL:(NSString *)picURL completion:(void (^)(UIImage *))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:picURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            completion(nil);
        }
        
        UIImage *image = [[UIImage alloc] initWithData:data];
        if (image)
        {
            completion(image);
        }
        else
        {
            completion(nil);
        }
        
    }];
    
    [dataTask resume];
}

@end
