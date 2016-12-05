//
//  UIViewController+Path.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 03/12/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UIViewController+Path.h"

@implementation UIViewController (Path)

- (NSString *)getPath:(NSString *)p {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    
    NSString * pathToReturn = [NSString stringWithFormat:@"%@/%@", documentPath,p];
    NSLog(@"pathtreturn %@ ", pathToReturn);
    return pathToReturn;
    
}

@end
