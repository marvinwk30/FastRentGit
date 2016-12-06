//
//  MyImagePool.m
//  iAnimalizeFinal
//
//  Created by Emmanuel Ruiz on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FRImagePool.h"

@interface FRImagePool ()

@property (nonatomic, strong) NSMutableDictionary *imagesCache;

@end

@implementation FRImagePool

+ (instancetype)sharedInstance
{
    static FRImagePool *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    _imagesCache = [NSMutableDictionary dictionary];
    
    return self;
}

- (UIImage*)getImageAndSave:(NSString *) aUrlImage
{
	//Load default promotion image
	@try {
	
        defaultImage = nil;

		//Check that no image is provided
		if ( aUrlImage == nil || [aUrlImage isEqualToString:@""])
			return defaultImage;
		
		// get image filename
		NSArray *_arrSplitUrlImg = [aUrlImage componentsSeparatedByString:@"/"];
		NSString *_fileName = (NSString*)[_arrSplitUrlImg objectAtIndex:[_arrSplitUrlImg count] -1 ];
		
		UIImage *_cachedImage = nil;
		
		//let's try to find image inside App Documents Directory
		NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *_documentsDirectory = [_paths objectAtIndex:0];
        
		NSString *_imagePath =  [_documentsDirectory stringByAppendingPathComponent: _fileName];
		_cachedImage = [UIImage imageWithContentsOfFile:_imagePath];
		
		//let's load the image from URL and save inside App Documents Directory
		if ( _cachedImage == nil )
		{	
			NSData *_data = nil;
            NSURL *_url = [NSURL  URLWithString:[aUrlImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"Init download image %@", _url);
			_data = [NSData dataWithContentsOfURL:_url];
            
			//No download --> use default image
			if (_data == nil /*|| [data length] == 4005*/)
			{
				_cachedImage = defaultImage;
			}
			else //Download succefull --> save a local copy
			{
				_cachedImage = [[UIImage alloc] initWithData:_data];
                
                //save image with fileName inside bundle
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *extension = [_fileName pathExtension];
                if ([[extension uppercaseString] isEqualToString:@"PNG"])
                    [UIImagePNGRepresentation(_cachedImage) writeToFile: [_documentsDirectory stringByAppendingPathComponent:_fileName]
                                                            atomically:YES];
                else if ([[extension uppercaseString] isEqualToString:@"JPG"])
                    [UIImageJPEGRepresentation(_cachedImage, 1.0) writeToFile: [_documentsDirectory stringByAppendingPathComponent:_fileName]
                                                                  atomically:YES];
                }
			
		}	
		
		return _cachedImage;
	}
	@catch (NSException *_exception) {
		NSLog(@"Error: %@", [_exception reason]);
        return nil;
	}
}

- (UIImage*)getImageAndSave:(NSString *) aUrlImage  imageName:(NSString*) aImageName;
{
    //Load default promotion image
    @try {
        
        defaultImage = nil;
        
        //Check that no image is provided
        if ( aUrlImage == nil || [aUrlImage isEqualToString:@""])
            return defaultImage;
        
        // get image filename
//        NSArray *_arrSplitUrlImg = [aUrlImage componentsSeparatedByString:@"/"];
//        NSString *_fileName = (NSString*)[_arrSplitUrlImg objectAtIndex:[_arrSplitUrlImg count] -1 ];
        
        UIImage *_cachedImage = nil;
        
        //let's try to find image inside App Documents Directory
        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *_documentsDirectory = [_paths objectAtIndex:0];
        
        NSString *_imagePath =  [_documentsDirectory stringByAppendingPathComponent:aImageName];
        _cachedImage = [UIImage imageWithContentsOfFile:_imagePath];
        
        //let's load the image from URL and save inside App Documents Directory
        if ( _cachedImage == nil )
        {
            NSData *_data = nil;
            NSURL *_url = [NSURL  URLWithString:[aUrlImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"Init download image %@", _url);
            _data = [NSData dataWithContentsOfURL:_url];
            
            //No download --> use default image
            if (_data == nil /*|| [data length] == 4005*/)
            {
                _cachedImage = defaultImage;
            }
            else //Download succefull --> save a local copy
            {
                
                NSLog(@"Download image %@ finish OK", _url);
                _cachedImage = [[UIImage alloc] initWithData:_data];
                
                //save image with fileName inside bundle
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *extension = [aImageName pathExtension];
                if ([[extension uppercaseString] isEqualToString:@"PNG"])
                    [UIImagePNGRepresentation(_cachedImage) writeToFile: [_documentsDirectory stringByAppendingPathComponent:aImageName]
                                                             atomically:YES];
                else if ([[extension uppercaseString] isEqualToString:@"JPG"])
                    [UIImageJPEGRepresentation(_cachedImage, 1.0) writeToFile: [_documentsDirectory stringByAppendingPathComponent:aImageName]
                                                                   atomically:YES];
            }
            
        }	
        
        return _cachedImage;
    }
    @catch (NSException *_exception) {
        NSLog(@"Error: %@", [_exception reason]);
        return nil;
    }
}

- (UIImage *)getImageNamed:(NSString *)aImageName {
    
    UIImage *_cachedImage = [self.imagesCache objectForKey:aImageName];
    
    if (!_cachedImage) {
    
        //let's try to find image inside App Documents Directory
        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *_documentsDirectory = [_paths objectAtIndex:0];
        
        NSString *_imagePath =  [_documentsDirectory stringByAppendingPathComponent:aImageName];
        _cachedImage = [UIImage imageWithContentsOfFile:_imagePath];
        
        if (_cachedImage != nil) {
            
            [self.imagesCache setObject:_cachedImage forKey:aImageName];
        }
    }
    
    return _cachedImage;
}

- (BOOL) saveImageLocally:(UIImage *)image imageName:(NSString *)aImageName {
    
    //Check that no image is provided
    if ( image == nil)
        return NO;
    
    if ([[self.imagesCache allKeys] containsObject:aImageName]) {
        
        return YES;
    }
    
    //let's try to find image inside App Documents Directory
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentsDirectory = [_paths objectAtIndex:0];
    
//    NSString *_imagePath =  [_documentsDirectory stringByAppendingPathComponent:aImageName];
    
    NSString *extension = [aImageName pathExtension];
    
    if ([[extension uppercaseString] isEqualToString:@"PNG"]) {
     
        [UIImagePNGRepresentation(image) writeToFile: [_documentsDirectory stringByAppendingPathComponent:aImageName]
                                          atomically:YES];
    }
    else if ([[extension uppercaseString] isEqualToString:@"JPG"]) {
        
        [UIImageJPEGRepresentation(image, 1.0) writeToFile: [_documentsDirectory stringByAppendingPathComponent:aImageName]
                                                atomically:YES];
    }
    
    [self.imagesCache setObject:image forKey:aImageName];

    return YES;
}

- (void) removeLocalImage:(NSString *)aImageName
{
    if (aImageName == nil || [aImageName isEqualToString:@""])
        return;
    
    [self.imagesCache removeObjectForKey:aImageName];
    
    //let's try to find image inside App Documents Directory
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentsDirectory = [_paths objectAtIndex:0];
    
    NSString *_imagePath =  [_documentsDirectory stringByAppendingPathComponent:aImageName];
    NSError* _error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:_imagePath error:&_error];
    if (_error != nil)
    {
        NSLog(@"image can't deleted at path: %@ withError: %@", _imagePath, [_error localizedDescription]);
    }
    else
    {
        NSLog(@"User image deleted at path: %@", _imagePath);
    }
}

@end
