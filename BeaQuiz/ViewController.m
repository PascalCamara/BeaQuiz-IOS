//
//  ViewController.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 29/11/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import "ViewController.h"
#import "PseudoController.h"
#import "GameConfig.h"
#import "JoinGame.h"

#import "UIViewController+Path.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelPseudo;
@property NSFileManager * m;

@end

@implementation ViewController

//NSMutableArray *_rangedRegions;
//NSMutableDictionary *_beacons;

- (IBAction)joinGame:(id)sender {
    JoinGame * jg = [self.storyboard instantiateViewControllerWithIdentifier:@"gameJoin"];
    [self.navigationController pushViewController:jg animated:YES];
}

- (IBAction)clearCache:(id)sender {
    
    
    NSError * error = nil;
    
    [self.m removeItemAtPath:[self getPath:@"pseudo"] error:&error];
    NSError * error1 = nil;
    [self.m removeItemAtPath:[self getPath:@"token"] error:&error];
    NSLog(@"clear cache error : %@", error);
    NSLog(@"clear cache error1 : %@", error1);

}
- (IBAction)createGameConfig:(id)sender {
    GameConfig * gc = [self.storyboard instantiateViewControllerWithIdentifier:@"gameConfig"];
    [self.navigationController pushViewController:gc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.m = [NSFileManager defaultManager];
    NSLog(@"file manager %@", self.m);
    
    NSLog(@"test if path exist %d", [self.m fileExistsAtPath:[self getPath:@"pseudo"]]);
    
    // tester si l'user à un pseudo
    if ([self.m fileExistsAtPath:[self getPath:@"pseudo"]]) {
   // if (1+1) {
        // recupération du pseudo et token
        NSString * pseudo = [[NSString alloc] initWithContentsOfFile:[self getPath:@"pseudo"]];
        NSString * token = [[NSString alloc] initWithContentsOfFile:[self getPath:@"token"]];
        NSLog(@"ooo token %@", token);
        NSLog(@"ooo pseudo %@", pseudo);
        
        // verifier validié token
         //
       
        
        self.labelPseudo.text = pseudo;
        
    } else {
        // view pour creer un pseudo
        PseudoController * pc = [self.storyboard instantiateViewControllerWithIdentifier:@"pseudo"];
        [self.navigationController pushViewController:pc animated:YES];
    }
    

    
}

- (void)viewWillAppear:(BOOL)animated {
    self.m = [NSFileManager defaultManager];
    
    NSString * pseudo = [[NSString alloc] initWithContentsOfFile:[self getPath:@"pseudo"]];
        NSString * token = [[NSString alloc] initWithContentsOfFile:[self getPath:@"token"]];
    self.labelPseudo.text = pseudo;

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
