Bird's-Eye-View Program
===
>The program should run on matlab.<br>

##Description
This program can implement the bird's-eye-view generation process.<br>

##Using Steps
First, you should estimate the parameters of a camera and save them as "cameraParams.mat" (`using "cameraCalibrator"`).<br>
After pressing the button "get calibration image", the program will capture a snapshot of the scene (`it should include a checkerboard`).<br>
When pressing the button "savemat", the program will a bird's-eye-view iamge of the snapshot.<br>
Finally, you can generate a bird's-eye-view image by pressing the button "current birdview" without using a checkerboard.<br>

##Implemention Steps
* ###Undistort the image
	* The Camera Calibration app can help to estimate camera intrinsics, extrinsics, and lens distortion parameters as "cameraParams.mat". And the matlab function "undistortImage" can help to undistort the image.

* ###Save the Projective Relationship
	* Using matlab function "detectCheckerboardPoints" to detect the checkerboard corners in the images as "imagePoints".
	* Using matlab function "generateCheckerboardPoints" to generate the world coordinates of the checkerboard corners as "worldPoints".
	* Save the worldPoints and imagePoints as "WorldImagePoints.mat".

* ###Get the Projective Relationship between World Coordinate System and Undistorted Image Coordinate System
	* Using matlab function "estimateGeometricTransform" to get the projective relationship.

* ###Get the Bird's-Eye-View Image
	* Using matlab function "imwarp" to get the world image.
	* Using similarity transformation to get the bird's-eye-view image.
