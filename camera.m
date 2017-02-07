%imageIndex = 1;

function varargout = camera(varargin)
% CAMERA MATLAB code for camera.fig
%      CAMERA, by itself, creates a new CAMERA or raises the existing
%      singleton*.
%
%      H = CAMERA returns the handle to a new CAMERA or the handle to
%      the existing singleton*.
%
%      CAMERA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERA.M with the given input arguments.
%
%      CAMERA('Property','Value',...) creates a new CAMERA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before camera_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to camera_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help camera

% Last Modified by GUIDE v2.5 07-Feb-2017 16:03:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camera_OpeningFcn, ...
                   'gui_OutputFcn',  @camera_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before camera is made visible.
function camera_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to camera (see VARARGIN)

% Choose default command line output for camera


handles.output = hObject;
%clc; clear all; close all;
 vid = videoinput('winvideo', 1, 'YUY2_640x480');
 set(vid,'ReturnedColorSpace','rgb');
 vidRes=get(vid,'VideoResolution');
 width=vidRes(1);
 height=vidRes(2);
 nBands=get(vid,'NumberOfBands');
 %figure('Name', 'Matlabµ˜”√…„œÒÕ∑ By Lyqmath', 'NumberTitle', 'Off', 'ToolBar', 'None', 'MenuBar', 'None');
 hImage=image(zeros(vidRes(2),vidRes(1),nBands));
 preview(vid,hImage);
 
 
 handles.vid = vid;
 handles.imageIndex = 1;
% Update handles structure
 guidata(hObject, handles);
 
 
% UIWAIT makes camera wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = camera_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frame = getsnapshot(handles.vid);

imageFileName = ['' num2str(handles.imageIndex ) '.bmp'];
handles.imageIndex  = handles.imageIndex  + 1;
imwrite(frame,imageFileName);
guidata(hObject, handles);
%saveas(gcf,'camera.png');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.vid);
flushdata(handles.vid);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load cameraParams.mat ;
image = getsnapshot(handles.vid);
% undistort the image
im = undistortImage(image,cameraParams);

% Detect the checkerboard corners in the images.
[imagePoints, boardSize] = detectCheckerboardPoints(im);

% Generate the world coordinates of the checkerboard corners in the pattern-centric coordinate system, with the upper-left corner at (0,0).
squareSize = 58; % millimeters
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

save WorldImagePoints worldPoints imagePoints; 
load WorldImagePoints.mat ;
% Get the projective relationship.
tform = estimateGeometricTransform(imagePoints,worldPoints,'projective');
% Get the projective image.
pim = imwarp(im,tform);

% Get similarity transform
M = 150;
N = 200;
% Get the bird view image.
birdView = imwarp(pim,[M,N]);
axes(findobj(gcf,'Tag','axes2'));
imshow(birdView);
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load cameraParams.mat ;
image = getsnapshot(handles.vid);
%undistort the image
im = undistortImage(image,cameraParams);

load WorldImagePoints.mat ;
% Get the projective relationship.
tform = estimateGeometricTransform(imagePoints,worldPoints,'projective');
% Get the projective image.
pim = imwarp(im,tform);

% Get similarity transform
M = 150;
N = 200;
% Get the bird view image.
birdView = imwarp(pim,[M,N]);
axes(findobj(gcf,'Tag','axes2'));
imshow(birdView);
end
