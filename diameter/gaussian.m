RGB = imread('telur.jpg');
I = rgb2gray(RGB);

J = imnoise(I,'gaussian',0,0.001);
imshow(J)

K = wiener2(J,[5 5]);
figure, imshow(K)