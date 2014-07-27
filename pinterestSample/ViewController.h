

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate>
{
    NSString *strAPIURL;
    NSString *strAPIHTTPMethod;
    NSString *strRequestBoundary;
    NSString *strRequestContentType;
    NSString *strToken;
    NSString *strCookie;
}


- (NSString *)strAPIURL;
- (void)setStrAPIURL:(NSString *)newValue;

- (NSString *)strAPIHTTPMethod;
- (void)setStrAPIHTTPMethod:(NSString *)newValue;

- (NSString *)strRequestBoundary;
- (void)setStrRequestBoundary:(NSString *)newValue;

- (NSString *)strRequestContentType;
- (void)setStrRequestContentType:(NSString *)newValue;

- (NSString *)strToken;
- (void)setStrToken:(NSString *)newValue;

- (NSString *)strCookie;
- (void)setStrCookie:(NSString *)newValue;

@end
