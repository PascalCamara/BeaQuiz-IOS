//
//  JoinGame.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 30/11/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import "JoinGame.h"
#import "UIViewController+Path.h"
#import "GameWait.h"

@interface JoinGame ()
@property (weak, nonatomic) IBOutlet UITextField *labelCodeInvit;
- (void)userJoinGame:(NSString *)token code:(NSString *)code_invit;

@end

@implementation JoinGame
- (IBAction)joinGame:(id)sender {
    // label code invit
        // -> self
    
    // token user
    NSString * token = [[NSString alloc] initWithContentsOfFile:[self getPath:@"token"]];
    
    // request to join game
    [self userJoinGame:token code:self.labelCodeInvit.text];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userJoinGame:(NSString *)token code:(NSString *)code_invit {
    
    NSLog(@"iii token : %@", token);
    NSLog(@"iii code_invit : %@", code_invit);

    
    NSString * url = @"http://pascalcamara.fr/API/game/select";
    
    NSURL * toLoad = [NSURL URLWithString:url];
    
    NSString * parameters = [NSString stringWithFormat:@"token=%@&invit_code=%@",token, code_invit];
    
    NSLog(@"iii param : %@", parameters);
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
                
                // nsdata with string json
                NSData * dataJson = [stringData dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:dataJson options:0 error:nil];
                
                //write game_id
                NSString * game_id = [json objectForKey:@"id"];
                NSLog(@"iii game_id : %@", game_id);
                [game_id writeToFile:[self getPath:@"game_id"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                //write game_name
                NSString * game_name = [json objectForKey:@"name"];
                NSLog(@"iii game_name : %@", game_name);
                [game_name writeToFile:[self getPath:@"game_name"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                //write invit_code
                NSLog(@"iii invit_code : %@", code_invit);
                [code_invit writeToFile:[self getPath:@"invit_code"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                //switch to wait_page
                if (game_id != nil) {
                    
                    GameWait * gw = [self.storyboard instantiateViewControllerWithIdentifier:@"waitGame"];
                
                    gw.game_id = game_id;
                    gw.game_name = game_name;
                    gw.invit_code = code_invit;
                    gw.showLunchGameButton = NO;
                
                    [self.navigationController pushViewController:gw animated:YES];
                } 
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
