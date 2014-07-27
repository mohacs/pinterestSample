

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *aWebView;
@property (weak, nonatomic) IBOutlet UIButton *buttonClickToUpload;
@property (weak, nonatomic) IBOutlet UITextField *textBoardName;
@property (weak, nonatomic) IBOutlet UITextField *textBoardID;
@property (weak, nonatomic) IBOutlet UIButton *buttonBoardList;

@end

@implementation ViewController
@synthesize aWebView, textBoardID, textBoardName, buttonClickToUpload, buttonBoardList;

-(IBAction)logOut:(id)sender
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies)
    {
        [cookieStorage deleteCookie:each];
    }
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs removeObjectForKey:@"pinsitelogin"];
    [defs synchronize];
    
}


- (IBAction)getBoardList:(id)sender {
    [self getBoardList];
}

-(void)getBoardList
{
            [buttonClickToUpload setEnabled:true];
        
        NSString *requestURL = @"http://www.pinterest.com/resource/NoopResource/get/?data=%7B%22o%70tions%22%3A%7B%7D%2C%22%6Dodule%22%3A%7B%22n%61%6De%22%3A%22PinCre%61te%22%2C%22o%70tions%22%3A%7B%22%61ction%22%3A%22u%70lo%61d%22%2C%22%6Dethod%22%3A%22u%70lo%61ded%22%2C%22tr%61ns%70%61rent_%6Dod%61l%22%3Af%61lse%2C%22show_%70review%22%3Af%61lse%2C%22f%61st_re%70in%22%3Af%61lse%7D%2C%22%61%70%70end%22%3Af%61lse%2C%22errorStr%61tegy%22%3A0%7D%2C%22context%22%3A%7B%22%61%70%70_version%22%3A%22b19d970%22%7D%7D";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];

    [self setCookieAndToken];
    
    [request addValue:@"http://www.pinterest.com" forHTTPHeaderField:@"Origin"];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    [request addValue:@"en-US,en;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    
    [request addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    [request addValue:@"http://www.pinterest.com" forHTTPHeaderField:@"Referer"];
    
    [request addValue:strToken forHTTPHeaderField:@"X-CSRFToken"];
    
    [request addValue:strCookie forHTTPHeaderField:@"Cookie"];
    [request setHTTPMethod:@"GET"];
    
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *rspreportStatus, NSData *datareportStatus, NSError *e)
         {
             if (e == nil)
             {
                 NSDictionary * dicti = [NSJSONSerialization JSONObjectWithData:datareportStatus options:kNilOptions error:nil];
                 
                 if ([[[[dicti objectForKey:@"module"] objectForKey:@"tree"] objectForKey:@"children"] count] <= 0 )
                 {
                     [self logOut:nil];
                 }
                 
                 for (NSDictionary *tDicti in [[[[[dicti objectForKey:@"module"] objectForKey:@"tree"] objectForKey:@"children"] objectAtIndex:0] objectForKey:@"children"]) {
                     
                     if ([tDicti objectForKey:@"data"] != nil) {
                         
                         if ([[tDicti objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                             
                             
                             NSArray *aArray = [NSArray arrayWithArray:
                                                
                                                [[[[[[[dicti objectForKey:@"module"] objectForKey:@"tree"]
                                                     objectForKey:@"children"] objectAtIndex:0]
                                                   objectForKey:@"children"] objectAtIndex:2]
                                                 objectForKey:@"data"]];
                             
                             NSMutableArray *tempList = [[NSMutableArray alloc] init];
                             
                             for (NSDictionary *aTempuriDic in aArray)
                             {
                                 NSMutableDictionary *tempDEtails = [[NSMutableDictionary alloc] init];
                                 [tempDEtails setObject:[aTempuriDic objectForKey:@"name"] forKey:@"board_name"];
                                 [tempDEtails setObject:[aTempuriDic objectForKey:@"id"] forKey:@"board_id"];
                                 
                                 [tempList addObject:tempDEtails];
                                 
                             }
                             [textBoardName setText:[[tempList objectAtIndex:0] objectForKey:@"board_name"]];
                             [textBoardID setText:[[tempList objectAtIndex:0] objectForKey:@"board_id"]];
                         }
                     }
                 }
             }
             else
             {
                 // throw warning
             }
         }];
        
    
}


- (void)pinImage:(NSString *)imageURL {
    
    NSString *postBody;
    postBody = [NSString stringWithFormat:
              @"{\"options\":{\"board_id\":\"%@\",\"description\":\"%@\",\"link\":\"%@\",\"image_url\":\"%@\",\"method\":\"uploaded\"},\"context\":{\"app_version\":\"%@\",\"https_exp\":false}}",
              textBoardID.text,
              @"COMMENT",
              @"http://apple.com",
              imageURL,
              @"947a189"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.pinterest.com/resource/PinResource/create/"]];

    [self setCookieAndToken];
    
    [request addValue:@"http://www.pinterest.com" forHTTPHeaderField:@"Origin"];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    [request addValue:@"en-US,en;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    
    [request addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    [request addValue:@"http://www.pinterest.com" forHTTPHeaderField:@"Referer"];
    
    [request addValue:strToken forHTTPHeaderField:@"X-CSRFToken"];
    
    [request addValue:strCookie forHTTPHeaderField:@"Cookie"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *requestBody = [NSMutableData data];
    
    [requestBody appendData:[[NSString stringWithFormat:@"source_url=%@", @"/"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[[NSString stringWithFormat:@"&data=%@", postBody] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[[NSString stringWithFormat:@"&module_path=%@", @"PinUploader(show_title=true, shrinkToFit=true)#Modal(module=PinCreate())"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:requestBody];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *rspreportStatus, NSData *datareportStatus, NSError *e)
     {
         if (e == nil)
         {
             NSLog(@"IMAGE PINNED");
             // Image Registered to board
         }
         else
         {
             // Throw Warning
         }
     }];
}


-(IBAction)uploadImage:(id)sender {
    
    UIImage *sampleImage = [UIImage imageNamed:@"sample.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(sampleImage, 1);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.pinterest.com/upload-image/?img=%@", @"sample.jpg"]]];  /////////////////  FILE NAME HERE
    
    [self setCookieAndToken];
    
    NSString *bndry = [self rndStr];
    NSString *contentType = [[NSString alloc] initWithString:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", bndry]];
    
    [request addValue:@"http://www.pinterest.com" forHTTPHeaderField:@"Origin"];
    
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    [request addValue:@"en-US,en;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    
    [request addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    [request addValue:@"sample.jpg"  forHTTPHeaderField:@"X-File-Name"]; /////////////////  FILE NAME HERE
    
    [request addValue:@"http://www.pinterest.com" forHTTPHeaderField:@"Referer"];
    
    [request addValue:strToken forHTTPHeaderField:@"X-CSRFToken"];
    
    [request addValue:strCookie forHTTPHeaderField:@"Cookie"];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *requestBody = [NSMutableData data];
    
    [requestBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", bndry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"img\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n", @"sample.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:imageData];  // IMAGE AS DATA
    
    [requestBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", bndry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:requestBody];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *rspreportStatus, NSData *datareportStatus, NSError *e)
     {
         if (e == nil)
         {
             NSDictionary * dicti = [NSJSONSerialization JSONObjectWithData:datareportStatus options:kNilOptions error:nil];
             
             if ([dicti objectForKey:@"image_url"] != nil)
             {
                 [self pinImage:[[dicti objectForKey:@"image_url"] stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"]];
             }
         }
         else
         {
             // throw WARNING UPLOAD FAIL
         }
     }];
}



-(void)setCookieAndToken {
    [self setStrCookie:[[NSUserDefaults standardUserDefaults] objectForKey:@"pinsitelogin"]];
//    [self setStrCookie:[strCookie stringByReplacingOccurrencesOfString:@"_track_cm=1;" withString:@"_track_cm=1; fba=True; logged_out=True; prompt_views=1;"]];
    [self setStrToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"csrftoken"]];
}

-(NSString *)rndStr
{
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDString = CFUUIDCreateString(kCFAllocatorDefault,UUID);
    NSString *aNSString = (__bridge NSString *)UUIDString;
    CFRelease(UUID);
    CFRelease(UUIDString);
    return aNSString;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURL *loginURL = [NSURL URLWithString:@"https://www.pinterest.com/login/"];
    
    if (!webView.isLoading) {
        NSLog(@"COMPLETED");
        
        if (![webView.request.mainDocumentURL.absoluteString isEqualToString:loginURL.absoluteString]) {
            NSLog(@"REDIRECTING");
            [webView setHidden:true];
            
            NSMutableString *cookieBuilder = [[NSMutableString alloc] init];
            
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [cookieJar cookies])
            {
                
                if ([cookie.domain hasSuffix:@".pinterest.com"])
                {
                    if ([cookie.name isEqualToString:@"c_dpr"])
                    {
                        [cookieBuilder appendString:@" c_dpr="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                    }
                    if ([cookie.name isEqualToString:@"__utma"])
                    {
                        [cookieBuilder appendString:@" __utma="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                    }
                    if ([cookie.name isEqualToString:@"__utmb"])
                    {
                        [cookieBuilder appendString:@" __utmb="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                    }
                    if ([cookie.name isEqualToString:@"__utmc"])
                    {
                        [cookieBuilder appendString:@" __utmc="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                    }
                    if ([cookie.name isEqualToString:@"__utmz"])
                    {
                        [cookieBuilder appendString:@" __utmz="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                    }
                    if ([cookie.name isEqualToString:@"_pinterest_d_sess"])
                    {
                        [cookieBuilder appendString:@" _pinterest_d_sess="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                    }
                    if ([cookie.name isEqualToString:@"_pinterest_sess"])
                    {
                        [cookieBuilder appendString:@" _pinterest_sess="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                    }
                    if ([cookie.name isEqualToString:@"csrftoken"]) {
                        [cookieBuilder appendString:@" csrftoken="];
                        [cookieBuilder appendString:cookie.value];
                        [cookieBuilder appendString:@";"];
                        [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"csrftoken"];
                    }
                }
            }
            NSString *cookieString = [cookieBuilder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [[NSUserDefaults standardUserDefaults] setObject:cookieString forKey:@"pinsitelogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [buttonBoardList setEnabled:true];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [aWebView setDelegate:(id)self];
    [aWebView setScalesPageToFit:true];
    [self.view addSubview:aWebView];
    [aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.pinterest.com/login/"]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)strAPIURL {
    return strAPIURL;
}

- (void)setStrAPIURL:(NSString *)newValue {
    strAPIURL = newValue;
}

- (NSString *)strAPIHTTPMethod {
    return strAPIHTTPMethod;
}

- (void)setStrAPIHTTPMethod:(NSString *)newValue {
    strAPIHTTPMethod = newValue;
}

- (NSString *)strRequestBoundary {
    return strRequestBoundary;
}

- (void)setStrRequestBoundary:(NSString *)newValue {
    strRequestBoundary = newValue;
}

- (NSString *)strRequestContentType {
    return strRequestContentType;
}

- (void)setStrRequestContentType:(NSString *)newValue {
    strRequestContentType = newValue;
}

- (NSString *)strToken {
    return strToken;
}

- (void)setStrToken:(NSString *)newValue {
    strToken = newValue;
}

- (NSString *)strCookie {
    return strCookie;
}

- (void)setStrCookie:(NSString *)newValue {
    strCookie = newValue;
}


@end
