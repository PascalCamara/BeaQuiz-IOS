//
//  MainGame.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 01/12/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import "MainGame.h"
#import "UIViewController+Path.h"
#import "GameQuiz.h"
#import "ResultGame.h"

@interface MainGame ()

@property (weak, nonatomic) IBOutlet UILabel *labelPseudo;
@property (weak, nonatomic) IBOutlet UILabel *labelGame;
-(void)setFarBackbground;
-(void)setNearBackground;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;


@property BOOL hasQuizAccess;

-(void)launchQuiz;

@property NSUUID *uuid;
@property CLBeaconRegion *region;

@property CLLocationManager * _locationManager;

@end

@implementation MainGame

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hasQuizAccess = YES;
    
    //set label game
    NSString * game_name = [[NSString alloc] initWithContentsOfFile:[self getPath:@"game_name"] usedEncoding:nil error:nil];

    self.labelGame.text = game_name;
    //set label pseudo
    NSString * pseudo = [[NSString alloc] initWithContentsOfFile:[self getPath:@"pseudo"] usedEncoding:nil error:nil];

    self.labelPseudo.text = pseudo;
    
    
    
    // set background for team
    
    
    //set background
    //[self setNearBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNearBackground {
    self.view.backgroundColor = [UIColor colorWithRed:(205/255.f) green:(95/255.f) blue:(95/255.f) alpha:1];
}

-(void)setFarBackbground {
    self.view.backgroundColor = [UIColor colorWithRed:(110/255.f) green:(160/255.f) blue:(245/255.f) alpha:1];
}


-(void)viewWillAppear:(BOOL)animated {
    self._locationManager = [[CLLocationManager alloc] init];
    self._locationManager.delegate = self;
    [self._locationManager requestWhenInUseAuthorization];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:@"F2A74FC4-7625-44DB-9B08-CB7E130B2029"];
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:[self.uuid UUIDString]];
    
    [self._locationManager startRangingBeaconsInRegion:self.region];
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    //checktime
    NSString * game_id = [[NSString alloc] initWithContentsOfFile:[self getPath:@"game_id"] encoding:NSUTF8StringEncoding error:nil];
    [self checkTime:game_id];
    
    NSLog(@"test location %@ region %@", beacons,region);
    NSLog(@"test location %@", beacons[0]);
    
    long beaconProxi = [[beacons[0] valueForKey:@"proximity"] integerValue];
    //NSLog(@"test location %ld",beaconProxi );
    
    
    if (beaconProxi == 2 ){
       // NSLog(@"EQUAL A 2 location %@", beacons[0]);
        NSLog(@"test location %@", [beacons[0] valueForKey:@"proximity"]);
        _hasQuizAccess = YES;
        [self setNearBackground];
    } else if (beaconProxi == 3){
        //NSLog(@"EQUAL A 3 location %@", beacons[0]);
        NSLog(@"test location %@", [beacons[0] valueForKey:@"proximity"]);
         [self setFarBackbground];
    } else if (beaconProxi == 1 && _hasQuizAccess){
        NSLog(@"switch to quiz");
        _hasQuizAccess = NO;
        [self launchQuiz];
    }

    
    
}

-(void)checkTime:(NSString *)game_id {
    NSString * url = [NSString stringWithFormat:@"http://pascalcamara.fr/API/game/check_time/%@", game_id];
    
    NSURL * toLoad = [NSURL URLWithString:url];
    // je démare la session
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:toLoad completionHandler:
                                  ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      NSString * stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"temps restant : %@", stringData);
                                      //NSLog(@"resssssponnnssseeee : %@", response);
                                      //NSLog(@"error : %@", error);
                                      
                                      if([stringData integerValue] <= 0) {
                                          dispatch_async(dispatch_get_main_queue(),^{
                                             self.progressBar.progress = 1 - ([stringData floatValue] /300);
                                              NSLog(@"game over");
                                              [self._locationManager stopUpdatingLocation];
                                              self._locationManager = nil;
                                              
                                              ResultGame * rg = [self.storyboard instantiateViewControllerWithIdentifier:@"gameResult"];
                                              rg.gameOver = YES;
                                              [self.navigationController pushViewController:rg animated:YES];
                                              
                                          });
                                      } else {
                                          dispatch_async(dispatch_get_main_queue(),^{
                                              
                                              NSLog(@"temps restant : %@", stringData);
                                              self.progressBar.progress = 1 - ([stringData floatValue] /300);
                                              
                                          });
                                      }
                                  }];
    
    [task resume];

}

-(void)launchQuiz {
    [self._locationManager stopUpdatingLocation];
    self._locationManager = nil;
    GameQuiz * gq = [self.storyboard instantiateViewControllerWithIdentifier:@"quizGame"];
    [self.navigationController pushViewController:gq animated:YES];
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
