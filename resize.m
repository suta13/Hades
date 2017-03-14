 a=imread('t.jpg');
% b=double(a)+1;           %converting uint to double
c=imresize(a, [200 300]);
imwrite(c,'1f.jpg');
figure,imshow(a,[]);
figure,imshow(c,[]);