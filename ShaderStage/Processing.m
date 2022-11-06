//
//  Processing.m
//  ShaderStage
//
//  Created by Michael Dominic K. on 01/11/2022.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef struct {
    float r;
    float g;
    float b;
} Color;

static Color ProcessPixel(Color input, float a, float b) {
    input.r *= a;
    input.g *= b;
    return input;
}

static unsigned char* ProcessData(const unsigned char *data, size_t width, size_t height, size_t stride, float a, float b) {
    unsigned char *newPtr = malloc(stride * height);
    
    Color color;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            size_t offset = (y * stride) + (x * 4);
            color.r = data[offset + 0] / 255.0;
            color.g = data[offset + 1] / 255.0;
            color.b = data[offset + 2] / 255.0;
            color = ProcessPixel(color, a, b);
            newPtr[offset + 0] = MAX(MIN(color.r * 255.0, 255), 0);
            newPtr[offset + 1] = MAX(MIN(color.g * 255.0, 255), 0);
            newPtr[offset + 2] = MAX(MIN(color.b * 255.0, 255), 0);
        }
    }
    
    return newPtr;
}


CGImageRef ProcessCGImage(CGImageRef image, float a, float b) {
    CGDataProviderRef provider = CGImageGetDataProvider(image);
    CFDataRef data = CGDataProviderCopyData(provider);
    const unsigned char *ptr = CFDataGetBytePtr(data);
    unsigned char *newPtr = ProcessData(ptr,
                                        CGImageGetWidth(image),
                                        CGImageGetHeight(image),
                                        CGImageGetBytesPerRow(image),
                                        a, b);
    
    CFDataRef newData = CFDataCreateWithBytesNoCopy(CFAllocatorGetDefault(),
                                                    newPtr,
                                                    CFDataGetLength(data),
                                                    CFAllocatorGetDefault());
    
    CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(newData);
    CGImageRef newImage = CGImageCreate(CGImageGetWidth(image),
                                        CGImageGetHeight(image),
                                        8, 32, CGImageGetBytesPerRow(image), CGColorSpaceCreateDeviceRGB(),
                                        CGImageGetBitmapInfo(image),
                                        newProvider, NULL, FALSE, kCGRenderingIntentDefault);
    
    return newImage;
}

