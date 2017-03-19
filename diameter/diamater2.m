clear; close all;

% load image and convert to grayscale
I = imread('D:\STIKOM BALI\SMT 7\Pra Skripsi\latihan\diameter\telur3.jpg');
gray    = rgb2gray(I);
% figure; imshow(gray)
imwrite(gray,'D:\STIKOM BALI\SMT 7\Pra Skripsi\latihan\diameter\telurgray3.jpg','jpg')
% apply a weiner filter to remove noise.
% N is a measure of the window size for detecting coherent features
N=5;
wf  = wiener2(gray,[N,N]);
wf = wf(N:end-N,N:end-N);

% rescale the image adaptively to enhance contrast without enhancing noise
contras = adapthisteq(wf);

% apply a canny edge detection
deteksi = edge(contras,'canny',0.7,7.2);

%join edges
diskEnt1 = strel('disk',10); % radius of 4
tyjoin1 = imclose(deteksi,diskEnt1);
figure; imshow(tyjoin1)

imwrite(tyjoin1,'D:\STIKOM BALI\SMT 7\Pra Skripsi\latihan\diameter\telurcanny3.jpg','jpg')