//
//  PseudoController.m
//  BeaQuiz
//
//  Created by Pascal CAMARA on 29/11/2016.
//  Copyright © 2016 Pascal CAMARA. All rights reserved.
//

#import "PseudoController.h"
#import "UIViewController+Path.h"

@interface PseudoController ()

@property (weak, nonatomic) IBOutlet UITextField *pseudo;
@property (weak, nonatomic) IBOutlet UILabel *messagePseudo;

-(void)pseudoExist:(NSString *)pseudo;
-(void)createPlayer:(NSString *)pseudo;

@end

@implementation PseudoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.topItem.hidesBackButton = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testPseudo:(id)sender {
    [self pseudoExist:self.pseudo.text];
}

-(void)pseudoExist:(NSString *)pseudo {
    
    NSString * url = [NSString stringWithFormat:@"http://pascalcamara.fr/API/player/exist/%@", pseudo];
    
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
                      NSLog(@"eee %@ il exist", pseudo);
                      self.messagePseudo.text = [NSString stringWithFormat:@"%@ est déjà utilisé", pseudo];
                  });
              } else {
                  dispatch_async(dispatch_get_main_queue(),^{
                      NSLog(@"eee %@ il exist pas", pseudo);
                      [self.messagePseudo setTextColor:[UIColor colorWithRed:(38/255.f) green:(194/255.f) blue:(129/255.f) alpha:1]];
                      self.messagePseudo.text = [NSString stringWithFormat:@"%@ est valide, en cours de création", pseudo];
                      [self createPlayer:pseudo];
                     
                  });
              }
    }];
    
    [task resume];
}

-(void)createPlayer:(NSString *)pseudo{
    
    NSString * url = @"http://pascalcamara.fr/API/player/create";
    
    NSURL * toLoad = [NSURL URLWithString:url];
    
    NSString * parameters = [NSString stringWithFormat:@"pseudo=%@", pseudo];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:toLoad];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"iii data : %@", data);
        NSLog(@"iii response : %@", response);
        NSLog(@"iii error : %@", error);
        
        if (error == nil) {
            NSString * token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"iii token : %@", token);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // save token && pseudo
                [pseudo writeToFile:[self getPath:@"pseudo"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                [token writeToFile:[self getPath:@"token"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
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
