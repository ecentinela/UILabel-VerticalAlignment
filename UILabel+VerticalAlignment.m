#import "UILabel+VerticalAlignment.h"
#import <objc/runtime.h>

@implementation UILabel(VerticalAlignment)

-(UITextVerticalAlignment)textVerticalAlignment
{
    NSNumber *alignment = objc_getAssociatedObject(self, "UITextVerticalAlignment");

    if (alignment)
    {
        return [alignment intValue];
    }

    NSNumber *newAlignment = [NSNumber numberWithInt:1];
    objc_setAssociatedObject(self, "UITextVerticalAlignment", newAlignment, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return UITextVerticalAlignmentMiddle;
}

-(void)setTextVerticalAlignment:(UITextVerticalAlignment)textVerticalAlignment
{
    NSNumber *newAlignment = [NSNumber numberWithInt:textVerticalAlignment];
    objc_setAssociatedObject(self, "UITextVerticalAlignment", newAlignment, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self setNeedsDisplay];
}

-(CGRect)verticalAlignTextRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [self verticalAlignTextRectForBounds:bounds limitedToNumberOfLines:numberOfLines];

    switch ([self textVerticalAlignment])
    {
        case UITextVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;

        case UITextVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;

        case UITextVerticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
    }

    return textRect;
}

-(void)verticalAlignDrawTextInRect:(CGRect)rect
{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [self verticalAlignDrawTextInRect:actualRect];
}

+(void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(textRectForBounds:limitedToNumberOfLines:)), class_getInstanceMethod(self, @selector(verticalAlignTextRectForBounds:limitedToNumberOfLines:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(drawTextInRect:)), class_getInstanceMethod(self, @selector(verticalAlignDrawTextInRect:)));
}

@end
