//
// Created by kpse on 8/28/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MainVC.h"


@implementation MainVC {
    NSArray *buttons;
}

- (void)loadView {
    [self setWantsFullScreenLayout:YES];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    buttons = @[[self addButton:[UIColor greenColor] atPosition:0],
        [self addButton:[UIColor redColor] atPosition:70],
        [self addButton:[UIColor whiteColor] atPosition:140],
        [self addButton:[UIColor blackColor] atPosition:210],
        [self addButton:[UIColor blueColor] atPosition:280],
        [self addButton:[UIColor yellowColor] atPosition:350]];
    [buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:btn];
    }];

}

- (UIButton *)addButton:(UIColor *)color atPosition:(int)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 100 + y, 300, 50);
    button.backgroundColor = color;
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1.0f;
    [button addTarget:self
               action:@selector(changeColor:)
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}


- (void)changeColor:(UIButton *)sender {
    self.view.superview.backgroundColor = sender.backgroundColor;
    [buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.hidden = TRUE;
    }];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"shake..");
        [buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            btn.hidden = FALSE;
        }];
        // User was shaking the device. Post a notification named "shake."
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
}

@end