//
//  MagnifierView.m
//  SimplerMaskTest
//

#import "MagnifierView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MagnifierView

- (id)init{
	if (self = [super initWithFrame:CGRectMake(0, 0, 45, 45)]) {
		// make the circle-shape outline with a nice border.
		self.layer.borderColor = [[UIColor whiteColor] CGColor];
		self.layer.borderWidth = 1.5;
		self.layer.cornerRadius = 45/2;
		self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

@end
