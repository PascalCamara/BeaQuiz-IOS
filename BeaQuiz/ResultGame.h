//
//  ResultGame.h
//  BeaQuiz
//
//  Created by Pascal CAMARA on 01/12/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultGame : UIViewController <UITableViewDataSource>

@property NSString * team_id;
@property NSString * game_name;
@property NSString * invit_code;
@property NSString * game_id;

@property BOOL gameOver;

@end
