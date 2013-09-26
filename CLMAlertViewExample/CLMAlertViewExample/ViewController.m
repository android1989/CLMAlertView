//
//  ViewController.m
//  CLMAlertViewExample
//
//  Created by Andrew Hulsizer on 9/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "ViewController.h"
#import "CLMAlertView.h"

@interface ViewController ()

@property (nonatomic, strong) CLMAlertView *alertView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.alertView = [[CLMAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occured" buttonTitles:@[@"OK",@"Cancel"] selectionBlock:^(CLMAlertView *alertView, NSInteger buttonIndex)
                      {
                          //Print the name of the button!
                          switch (buttonIndex) {
                              case 0:
                                  [alertView dismiss];
                                  break;
                                  
                              default:
                                  break;
                          }
                      }];
    
    [self.alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
