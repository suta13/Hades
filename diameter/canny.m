g = imread('telur.jpg');
gray=rgb2gray(g); 
x = edge(gray,'canny',0.1,0,1); 
imshow(x);