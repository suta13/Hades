img = imread('telur.jpg');

red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);
I = 0.3*red+0.5*green+0.2*blue ;
I = im2double(I);

%1. Parameters of edge detecting filters:
%  X = axis direction filter:
Nx1 = 10; Sigmax1=1;Nx2=10;Sigmax2=1;Theta1=pi/2;
%  X = axis direction filter:
Ny1 = 10; Sigmay1=1;Ny2=10;Sigmay2=1;Theta2=0;
% the thresholding parameters alfa :
alfa=0.1;

filterx = d2dgauss(Nx1,Sigmax1,Nx2,Sigmax2,Theta1);
Ix = conv2(I,filterx,'same');

filtery = d2dgauss(Ny1,Sigmay1,Ny2,Sigmay2,Theta2);
Iy = conv2(I,filtery,'same');

NVI = sqrt(Ix.*Ix+Iy.*Iy);
I_max = max(max(NVI));
I_min = min(min(NVI));
level = alfa*(I_max-I_min)+I_min;
Ibw = max(NVI,level.*ones(size(NVI)));

[n,m] = size(Ibw);
for i=2:n-1,
for j=2:m-1,
    if Ibw(i,j) > level,
    X = [-1,0,+1;-1,0,+1;-1,0,+1];
    Y = [-1,-1,-1;0,0,0;+1,+1,+1];
    Z = [Ibw(i-1,j-1),Ibw(i-1,j),Ibw(i-1,j+1);
        Ibw(i,j-1),Ibw(i,j),Ibw(i,j+1);
        Ibw(i+1,j-1),Ibw(i+1,j),Ibw(i+1,j+1)];
    XI = [Ix(i,j)/NVI(i,j), -Ix(i,j)/NVI(i,j)];
    YI = [Iy(i,j)/NVI(i,j), -Iy(i,j)/NVI(i,j)];
    ZI = interp2(X,Y,Z,XI,YI);
            if Ibw(i,j) >= ZI(1) && Ibw(i,j) >= ZI(2)
                edgeimage(i,j) = I_max;
            else
                edgeimage(i,j) = I_min;
            end
    else
        edgeimage(i,j) = I_min;
    end
end
end
figure,imshow(edgeimage);