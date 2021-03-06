//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Shawn Lewis on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize program = _program;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateProgram {
    self.program.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    NSLog(@"digit pressed = %@", digit);
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateProgram];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    [self updateProgram];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)dotPressed {
    BOOL containsDot =
        [[NSPredicate predicateWithFormat:@"SELF CONTAINS '.'"]
         evaluateWithObject:self.display.text];
    if (!containsDot) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed {
    [self.brain clear];
    [self updateProgram];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (void)viewDidUnload {
    [self setProgram:nil];
    [super viewDidUnload];
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
    [self updateProgram];
}

- (void)runTest:(NSDictionary *)vars {
    double result = [[self.brain class] runProgram:self.brain.program
                               usingVariableValues:vars];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)test1Pressed {
    [self runTest:[NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithDouble:5.3], @"a", nil]];
}

- (IBAction)test2Pressed:(UIButton *)sender {
    [self runTest:[NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithDouble:12.1], @"a",
                   [NSNumber numberWithDouble:5], @"b", nil]];
}

@end