% bwImg = imread('telurbw.jpg');
% 
% linIndex = find(bwImg);
% 
% [xCoords, yCoords] = ind2sub(size(bwImg),linIndex);
% 
% xc = sum(xCoords)/length(xCoords);
% 
% yc = sum(yCoords)/length(yCoords);
% 
% [coords, lblImg] = bwboundaries(bwImg, 4, 'noholes');
% 
% x = coords{1}(1:end-1,1);
% 
% y = coords{1}(1:end-1,2);
% 
% rp = sqrt((x - xc).^2 + (y - yc).^2);


bwImg = imread('telurbw.jpg');

lbl = bwconncomp(bwImg);

stat = regionprops(lbl,'Centroid');

xc = stat(1).Centroid(2);

yc = stat(1).Centroid(1);

[coords, lblImg] = bwboundaries(bwImg, 4, 'noholes');

x = coords{1}(1:end-1,1);

y = coords{1}(1:end-1,2);

rp = sqrt((x - xc).^2 + (y - yc).^2);
imshow(rp);