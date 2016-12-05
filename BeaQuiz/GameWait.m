//
//  GameWait.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 30/11/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import "GameWait.h"
#import "UIViewController+Path.h"
#import "ResultGame.h"

@interface GameWait ()
@property (weak, nonatomic) IBOutlet UILabel *labelGameName;
@property (weak, nonatomic) IBOutlet UILabel *labelCodeInvit;
@property (weak, nonatomic) IBOutlet UIButton *lunchBtn;

-(void)requestStartGame:(NSString * )game_id token:(NSString *)token;
-(void)getStateGameStarted;

@end

@implementation GameWait

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.showLunchGameButton) {
        self.lunchBtn.hidden = YES;
    }
    
    self.labelGameName.text = self.game_name;
    self.labelCodeInvit.text = self.invit_code;

}
- (IBAction)startGame:(id)sender {
   NSString * token = [[NSString alloc] initWithContentsOfFile:[self getPath:@"token"]];
    
    [self requestStartGame:self.game_id token:token];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestStartGame:(NSString * )game_id token:(NSString *)token{
    NSString * url = @"http://pascalcamara.fr/API/game/start";
    
    NSURL * toLoad = [NSURL URLWithString:url];
    
    NSString * parameters = [NSString stringWithFormat:@"token=%@&game_id=%@", token, game_id];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:toLoad];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"iii data : %@", data);
        NSLog(@"iii response : %@", response);
        NSLog(@"iii error : %@", error);
        
        if (error == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
                NSLog(@"iii String data : %@", stringData);
                if (stringData != @"0") {
                    // write team_id
                    [stringData writeToFile:[self getPath:@"team_id"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    NSLog(@"writing");
                    
                
                // switch to gamewait
                ResultGame * rg = [self.storyboard instantiateViewControllerWithIdentifier:@"gameResult"];
                
                    rg.team_id = stringData;
                    rg.game_name = self.game_name;
                    rg.invit_code = self.invit_code;
                    rg.game_id = self.game_id;
                    rg.gameOver = NO;
                    
                [self.navigationController pushViewController:rg animated:YES];
                }

                
            });
            
            
        }
    }];
    
    [task resume];

    
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (!self.showLunchGameButton) {
        NSLog(@"debug appear : %d", self.showLunchGameButton);
        [self getStateGameStarted];
        
    }
}

-(void)getStateGameStarted {
    ///game/is_started/ {game_id}/

    NSString * url = [NSString stringWithFormat:@"http://pascalcamara.fr/API/game/is_started/%@", self.game_id];
    
    NSLog(@"game id %@", self.game_id);
    
    NSURL * toLoad = [NSURL URLWithString:url];
    // je démare la session
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:toLoad completionHandler:
                                  ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      NSString * stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"dataaaaaaaaaaaa : %@", stringData);
                                      NSLog(@"resssssponnnssseeee : %@", response);
                                      NSLog(@"error : %@", error);
                                      
                                      if([stringData boolValue] == 1) {
                                          dispatch_async(dispatch_get_main_queue(),^{
                                              NSLog(@"partie  a commencé");
                                              ResultGame * rg = [self.storyboard instantiateViewControllerWithIdentifier:@"gameResult"];
                                              
                                              rg.team_id = stringData;
                                              rg.game_name = self.game_name;
                                              rg.invit_code = self.invit_code;
                                              rg.game_id = self.game_id;
                                              rg.gameOver = NO;

                                              
                                              [self.navigationController pushViewController:rg animated:YES];

                                            
                                          });
                                      } else {
                                          dispatch_async(dispatch_get_main_queue(),^{
                                              NSLog(@"partie  n'a pas commencé");
                                              [self getStateGameStarted];
                                              
                                          });
                                      }
                                  }];
    
    [task resume];

    
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
