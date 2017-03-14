I = imread('D:\STIKOM BALI\SMT 7\Pra Skripsi\latihan\diameter\telur.jpg');
gray    = rgb2gray(I);
thresh=graythresh(gray);
imbw=im2bw(gray,thresh);
imshow(imbw);
imwrite(imbw,'D:\STIKOM BALI\SMT 7\Pra Skripsi\latihan\diameter\telurbw1.jpg','jpg')


