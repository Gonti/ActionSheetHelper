#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCTAlertHelper : NSObject

- (id)initWithViewController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancel style:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message;
- (id)initWithViewController:(UIViewController *)controller array:(NSArray *)sortedTitles dictionary:(NSDictionary *)blocksAndTitles cancelButtonTitle:(NSString *)cancel style:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message;
- (void)presentAlert;
- (void)addTitle:(NSString *)title WithAction:(void (^)(UIAlertAction *action))blockAction;

@end
