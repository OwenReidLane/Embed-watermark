clear
%get .tif image with uigetfile
[filename, pathname]=uigetfile({'*.tif'}, 'pick a file');
alpha = 1.5; %watermarking strength
%load image
img = imread(filename);
%load watermark
load('watermark.mat');

%convert image to to double then into wavelet domain
%down to 2 levels of decomposition
[A1, H1, V1, D1] = dwt2(double(img),'haar','mode','per');
[A2, H2, V2, D2] = dwt2(double(A1), 'haar', 'mode','per');

%embed watermark with imported function
H2_wm = embed_watermark(w1, H2,alpha);
V2_wm = embed_watermark(w2, V2,alpha);
D2_wm = embed_watermark(w3, D2,alpha);

% reverse to inverse wavelet using idwt
A1_new = idwt2(A2,H2_wm, V2_wm, D2_wm, 'haar','mode','per' ); 
img_wm = idwt2(A1_new, H1, V1, D1, 'haar','mode','per' ); 

% convert image to unit8 and display with imshow
img_wm = uint8(img_wm);
figure, imshow(img_wm);
imwrite(img_wm,'watermarkedImage.tif');

% extract watermark to 2 levels of decomposition using haar wavelet
[A1_new, H1, V1, D1] = dwt2(double(img_wm),'haar','mode','per');
[A2, H2_wm, V2_wm, D2_wm] = dwt2(double(A1), 'haar', 'mode','per');
 
%use function extract_watermark
wm_1 = detect_watermark(w1,H2,sgn);
wm_2 = detect_watermark(w2,V2,sgn);
wm_3 = detecct_watermark(w3,D2,sgn);

%display watermarked image  as .tif
disp(wm_img);