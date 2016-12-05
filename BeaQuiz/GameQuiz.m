//
//  GameQuiz.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 02/12/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import "GameQuiz.h"
#import "UIViewController+Path.h"
#import "MainGame.h"
@interface GameQuiz ()

-(void)getQuiz;
@property int comptedSecond;
@property (weak, nonatomic) IBOutlet UIProgressView *quizProgress;
@property NSTimer * t;
-(void)checkTime;



//@property NSString * questions;




@end

@implementation GameQuiz

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    
    
    // get quiz
    [self getQuiz];
    
    // start decompte
    _comptedSecond = 0;
    self.t = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTime:) userInfo:nil repeats:YES];
}
- (IBAction)validate1:(id)sender {
    NSString * actualValue = _choice1.titleLabel.text;
    
    if ([_goodAnswer isEqualToString:actualValue]) {
        _quizScore++;
        _difficulty++;
        [self writeScore];
    }
    
    _goodAnswer = [self generateQuiz];

}
- (IBAction)validate2:(id)sender {
    NSString * actualValue = _choice2.titleLabel.text;
    
    if ([_goodAnswer isEqualToString:actualValue]) {
        _quizScore++;
        _difficulty++;
        [self writeScore];
    }
    
    _goodAnswer = [self generateQuiz];

}
- (IBAction)validate3:(id)sender {
    NSString * actualValue = _choice3.titleLabel.text;
    
    if ([_goodAnswer isEqualToString:actualValue]) {
        _quizScore++;
        _difficulty++;
        [self writeScore];
    }
    
    _goodAnswer = [self generateQuiz];

}
- (IBAction)validate4:(id)sender {
    NSString * actualValue = _choice4.titleLabel.text;
    
    if ([_goodAnswer isEqualToString:actualValue]) {
        _quizScore++;
        _difficulty++;
        [self writeScore];
    }
    
    _goodAnswer = [self generateQuiz];

}

-(void)getQuiz {
    
    self.difficulty = 10;
    self.quizScore = 0;
    _goodAnswer = self.generateQuiz;
    [self writeScore];
    
    //NSString * url = @"http://pascalcamara.fr/API/quiz";
    
    //NSURL * toLoad = [NSURL URLWithString:url];
    // je démare la session
    //NSURLSession * session = [NSURLSession sharedSession];
    //NSURLSessionDataTask *task = [session dataTaskWithURL:toLoad completionHandler:
      //                            ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //                              NSString * stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          //                            NSLog(@"QUIZ GET DATA : %@", stringData);
            //                          NSLog(@"QUIZ GET RESPONSE  : %@", response);
              //                        NSLog(@"QUIZ GET ERROR : %@", error);
    
                //                      if(error == nil) {
                  //                        dispatch_async(dispatch_get_main_queue(),^{
                                              // start decompte
                    //                          _comptedSecond = 0;
                      //                        self.t = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTime:) userInfo:nil repeats:YES];
    
                        //                      self.questions = [data ]
                          //                });
                            //          } else {
                              //            dispatch_async(dispatch_get_main_queue(),^{
                                //             //
                                  //        });
                                    //  }
                                  //}];
    
//    [task resume];
    
    

}

- (void) writeScore{
    
    //NSString * actualScore = [NSString stringWithFormat:@"%s%i", "", self.quizScore];
    //self.score.text = actualScore;
    
}


- (NSString *)generateQuiz{
    
    int max = arc4random_uniform(self.difficulty);
    int value1= arc4random_uniform(max)+1 ;
    int value2= arc4random_uniform(max)+1 ;
    int randomize1 = arc4random_uniform(max)+1;
    int randomize2 = arc4random_uniform(max)+1;
    int randomize3 = arc4random_uniform(max)+1;
    int symbol = arc4random_uniform(3);
    int symbolRand1 = arc4random_uniform(3);
    int symbolRand2 = arc4random_uniform(3);
    int symbolRand3 = arc4random_uniform(3);
    
    NSArray *symbolArray = @[@"+", @"-", @"*"];
    // NSString *v3a = [NSString stringWithFormat:@"%s%@", "", symbolArray[symbol]];
    
    NSString *chainResult = [NSString stringWithFormat:@"%i%@%i", value1, symbolArray[symbol], value2];
    
    self.operation.text = chainResult;
    
    int r1 = [self calculate:symbolArray[symbol] andValue1:value1 andValue2:value2];
    
    int r2 = [self calculate:symbolArray[symbolRand3] andValue1:r1 andValue2:randomize1];
    
    int r3 = [self calculate:symbolArray[symbolRand2] andValue1:r2 andValue2:randomize3];
    
    int r4 = [self calculate:symbolArray[symbolRand1] andValue1:r3 andValue2:randomize2];
    
    if (r2 == r3 || r2 == r4 || r2 == r1) {
        r2++;
    }
    
    if (r3 == r2 || r3 == r4 || r3 == r1) {
        r3++;
    }
    
    if (r4 == r2 || r4 == r3 || r4 == r1) {
        r4++;
    }
    
    NSString * re1 = [NSString stringWithFormat:@"%s%i", "", r1];
    NSString * re2 = [NSString stringWithFormat:@"%s%i", "", r2];
    NSString * re3 = [NSString stringWithFormat:@"%s%i", "", r3];
    NSString * re4 = [NSString stringWithFormat:@"%s%i", "", r4];
    
    NSArray * resultArray = [NSArray arrayWithObjects:re1, re2, re3, re4, nil];
    
    NSArray * trueArray = [self randomize:resultArray];
    
    [_choice1 setTitle:trueArray[0] forState:UIControlStateNormal];
    
    [_choice2 setTitle:trueArray[1] forState:UIControlStateNormal];
    
    [_choice3 setTitle:trueArray[2] forState:UIControlStateNormal];
    
    [_choice4 setTitle:trueArray[3] forState:UIControlStateNormal];
    
    return re1;
}


-(void)checkTime:(NSTimer*)timer {
    _comptedSecond++;
    float seconds = (float)_comptedSecond;
    float divided = 20.0;
    float progress = seconds / divided;
    // mise a jour du progress
    self.quizProgress.progress = progress;
    
    if (_comptedSecond >= 20) {
        [self.t invalidate];
        NSLog(@"result final %d", _quizScore);
        
        // send to api
        NSString * token = [[NSString alloc] initWithContentsOfFile:[self getPath:@"token"] encoding:NSUTF8StringEncoding error:nil];
        
        NSString * game_id = [[NSString alloc] initWithContentsOfFile:[self getPath:@"game_id"] encoding:NSUTF8StringEncoding error:nil];
        
        [self sendResult:_quizScore token:token gameId:game_id];
        
        // switch to maingame
        MainGame * mg = [self.storyboard instantiateViewControllerWithIdentifier:@"gameMain"];
        [self.navigationController pushViewController:mg animated:YES];
    }
    NSLog(@"compted second %d", _comptedSecond);
    NSLog(@"compted progress %f", progress);
    
    
}

-(void)sendResult:(int)result token:(NSString * )token gameId:(NSString *)game_id {
    NSString * url = @"http://pascalcamara.fr/API/quiz/submit";
    
    NSURL * toLoad = [NSURL URLWithString:url];
    
    NSString * parameters = [NSString stringWithFormat:@"game_id=%@&token=%@&score=%d", game_id, token, result];
    
    
    NSLog(@"param %@", parameters);
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:toLoad];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"sending data : %@", data);
        NSLog(@"sending response : %@", response);
        NSLog(@"sending error : %@", error);
        
        //
    }];
    
    [task resume];

}

- (int)calculate:(NSString *)operator andValue1:(int)value1 andValue2:(int)value2{
    int result = 0;
    int operatorSign = 0;
    
    if ([operator isEqualToString: @"+"]) {
        operatorSign = 1;
    } else if ([operator isEqualToString: @"-"]) {
        operatorSign = 2;
    }else if ([operator isEqualToString: @"*"]) {
        operatorSign = 3;
    }
    
    switch (operatorSign) {
        case 1:
            result = value1 + value2;
            break;
            
        case 2:
            result = value1 - value2;
            break;
            
        case 3:
            result = value1 * value2;
            break;
    }
    
    return result;
}

- (NSArray *)randomize:(NSArray *) a{
    int t1 = arc4random() %4;
    int t2 = arc4random() %3;
    t2 = t2+1;
    t2 = (t2+t1) %4;
    int t3 = 0;
    if (abs(t2-t1 > 1)) {
        t3 = (MIN(t1, t2)+1) %4;
    }else{
        t3 = (MAX(t1, t2)+1) %4;
    }
    int t4 = (6-(t1+t2+t3)) %4;
    
    return @[a[t1], a[t2], a[t3], a[t4]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
