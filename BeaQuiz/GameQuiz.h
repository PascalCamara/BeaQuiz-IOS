//
//  GameQuiz.h
//  BeaQuiz
//
//  Created by Pascal CAMARA on 02/12/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameQuiz : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *operation;

@property (weak) NSString *  goodAnswer;
@property int difficulty;
@property int quizScore;

@property (weak, nonatomic) IBOutlet UIButton *choice1;
@property (weak, nonatomic) IBOutlet UIButton *choice2;
@property (weak, nonatomic) IBOutlet UIButton *choice3;
@property (weak, nonatomic) IBOutlet UIButton *choice4;

//@property (weak, nonatomic) IBOutlet UIButton *choice1;
//@property (weak, nonatomic) IBOutlet UIButton *choice2;
//@property (weak, nonatomic) IBOutlet UIButton *choice3;
//@property (weak, nonatomic) IBOutlet UIButton *choice4;
//@property (weak, nonatomic) IBOutlet UILabel *operation;

//@property (weak, nonatomic) IBOutlet UILabel *score;



@end
