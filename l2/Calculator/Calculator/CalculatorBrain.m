//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Shawn Lewis on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}
    
- (double)performOperation:(NSString* )operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (void)clear {
    self.programStack = nil;
}

- (id)program {
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    return [(NSMutableArray *) program description];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack 
                    withVars:(NSDictionary *)vars {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack withVars:vars]
                + [self popOperandOffStack:stack withVars:vars];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack withVars:vars];
            result = [self popOperandOffStack:stack withVars:vars] - subtrahend;
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack withVars:vars]
                * [self popOperandOffStack:stack withVars:vars];
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack withVars:vars];
            if (divisor)
                result = [self popOperandOffStack:stack withVars:vars] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack withVars:vars]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack withVars:vars]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack withVars:vars]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = M_PI;
        } else {
            // It's a variable
            NSNumber *val = [vars objectForKey:operation];
            if (val)
                result = [val doubleValue];
        }
    }

    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack withVars:[NSDictionary dictionary]];
}

@end
