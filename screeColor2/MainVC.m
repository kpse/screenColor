//
// Created by kpse on 8/28/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MainVC.h"


@implementation MainVC {
    NSArray *buttons;
    BOOL _didSet;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    buttons = @[[self addButton:[UIColor greenColor] withTag:100],
        [self addButton:[UIColor redColor] withTag:101],
        [self addButton:[UIColor whiteColor] withTag:102],
        [self addButton:[UIColor blackColor] withTag:103],
        [self addButton:[UIColor blueColor] withTag:104],
        [self addButton:[UIColor yellowColor] withTag:105]];
    [buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:btn];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
    }];

    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}


- (UIButton *)addButton:(UIColor *)color withTag:(int)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = color;
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.tag = tag;
    [button addTarget:self
               action:@selector(changeColor:)
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}


- (void)changeColor:(UIButton *)sender {
    self.view.backgroundColor = sender.backgroundColor;
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
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"shake..");
        [buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            btn.hidden = FALSE;
        }];
        // User was shaking the device. Post a notification named "shake."
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
}

- (void)updateViewConstraints {
    [self setUpAutoLayout];
    [super updateViewConstraints];
}

- (void)setUpAutoLayout {
    if (_didSet) {
        return;
    }
    _didSet = YES;


    [self layoutButton:100];
    [self layoutTopButton:[self.view viewWithTag:100]];

    [self layoutButton:101];
    [self layoutButton:102];
    [self layoutButton:103];
    [self layoutButton:104];

    [self layoutButton:105];
    [self layoutLastButton:[self.view viewWithTag:105]];

}

- (void)layoutLastButton:(UIView *)btn {
    NSDictionary *views =
        @{@"last" : btn};
    NSArray *layouts = @[@"|-[last(>=250)]-|", @"V:[last(>=40)]-|"];

    [layouts enumerateObjectsUsingBlock:^(NSString *layout, NSUInteger idx, BOOL *stop) {
        NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
        [self.view addConstraints:constraint];
    }];
}

- (void)layoutButton:(int)tag {
    UIView *buttonRef = [self.view viewWithTag:tag];

    UIView *upperButton = [self.view viewWithTag:tag - 1];
    if(upperButton) {
        [self layoutButton:buttonRef and:upperButton];
    }
}

- (void)layoutTopButton:(UIView *)btn {
    NSDictionary *views =
        @{@"btn" : btn};
    NSArray *layouts = @[@"|-[btn(>=250)]-|", @"V:|-15-[btn(>=40)]"];

    [layouts enumerateObjectsUsingBlock:^(NSString *layout, NSUInteger idx, BOOL *stop) {
        NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
        [self.view addConstraints:constraint];
    }];
    [self layoutButton:btn];
}

- (void)layoutButton:(UIView *)lowerBtn and:(UIView *)upperBtn {
    NSDictionary *views =
        @{@"lower" : lowerBtn, @"upper": upperBtn};
    NSArray *layouts = @[@"|-[upper(>=250)]-|", @"V:[upper(>=40)]-[lower(==upper)]"];

    [layouts enumerateObjectsUsingBlock:^(NSString *layout, NSUInteger idx, BOOL *stop) {
        NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
        [self.view addConstraints:constraint];
    }];

}
@end