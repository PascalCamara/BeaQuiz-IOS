//
//  ResultGame.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 01/12/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import "ResultGame.h"
#import "UIViewController+Path.h"
#import "MainGame.h"

@interface ResultGame ()

@property (weak, nonatomic) IBOutlet UITableView *listGameResult;
@property NSArray * players;

-(void)getResultGame:(NSString *)token with:(NSString * )game_id;




@end

@implementation ResultGame

NSMutableDictionary *_beacons;
NSMutableArray *_rangedRegions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * token = [[NSString alloc] initWithContentsOfFile:[self getPath:@"token"]];
    NSString * game_id = [[NSString alloc] initWithContentsOfFile:[self getPath:@"game_id"]];
    
    // get final result
    
    [self getResultGame:token with:game_id];
    [self.listGameResult setDataSource:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getResultGame:(NSString *)token with:(NSString * )game_id {
    NSString * url = @"http://pascalcamara.fr/API/game/result";
    
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
                
                
                self.players = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                [self.listGameResult reloadData];
                
            });
            
            
        }
    }];
    
    [task resume];

}
- (IBAction)goGame:(id)sender {
    MainGame * mg = [self.storyboard instantiateViewControllerWithIdentifier:@"gameMain"];
    [self.navigationController pushViewController:mg animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.players.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString * player = [self.players[indexPath.row] objectForKey:@"pseudo"];
    NSString * score = [self.players[indexPath.row] objectForKey:@"score"];
    
    NSString * equipe = @"Bleu";
    if ([[self.players[indexPath.row] objectForKey:@"team_order"] isEqual: @"0"]) {
        equipe = @"Rouge";
        if (_gameOver) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ equipe : %@, Score : %@", player, equipe, score];
            cell.textLabel.textColor = [UIColor colorWithRed:(200/225.f) green:(80/255.f) blue:(80/225.f) alpha:1];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ equipe : %@", player, equipe];
            cell.textLabel.textColor = [UIColor colorWithRed:(200/225.f) green:(80/255.f) blue:(80/225.f) alpha:1];
        }
        

    } else {
        if (_gameOver) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ equipe : %@, Score : %@", player, equipe, score];
            cell.textLabel.textColor = [UIColor colorWithRed:(100/225.f) green:(160/255.f) blue:(230/225.f) alpha:1];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ equipe : %@", player, equipe];
            cell.textLabel.textColor = [UIColor colorWithRed:(100/225.f) green:(160/255.f) blue:(230/225.f) alpha:1];
        }
        
    }
    
    
    
    return cell;
}

@end
