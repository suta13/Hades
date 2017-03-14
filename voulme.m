%mengubah citra RGb ke grayscale (keabuan) 
rgb = imread('telur2.jpg');
imshow(rgb);
I=rgb2gray(rgb);	
[xmak,ymak]=size(I);
jml=0;	
for y=1:ymak	
for x=1:xmak	
    p=I(x,y);	
    a=sum(p,1);
    jml=jml+(a-1);	
end 
end

putih=0; titik=0;
rata=jml/(xmak*ymak); 
batas=rata-(rata*40/100); 
for x=1:ymak
    for y=1:xmak
    titik =I(x,y);
    if titik>batas;
        putih = putih +1;
        I2(x,y)=255;
    else
        I2(x,y) = 0;
    end
    end
end
putih;
S=putih*100/50;
r=sqrt(S/(4*pi));
Volume = (4/3)*pi*(r^3);
Volume;
subplot(1,2,1), imshow (I);
subplot(1,2,2), imshow (I2); 