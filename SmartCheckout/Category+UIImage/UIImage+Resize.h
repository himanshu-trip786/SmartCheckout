// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)

- (UIImage *) hm_resizedImage:(CGSize) newSize
		 interpolationQuality:(CGInterpolationQuality) quality;

- (UIImage *) hm_resizedImageWithContentMode:(UIViewContentMode) contentMode
									  bounds:(CGSize) bounds
						interpolationQuality:(CGInterpolationQuality) quality;

- (UIImage *) hm_resizedImage:(CGSize) newSize
					transform:(CGAffineTransform) transform
			   drawTransposed:(BOOL) transpose
		 interpolationQuality:(CGInterpolationQuality) quality;

- (CGAffineTransform) hm_transformForOrientation:(CGSize) newSize;
@end
