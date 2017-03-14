clc;clear;close all;
I = imread('D:\STIKOM BALI\SMT 7\Pra Skripsi\latihan\diameter\testt.jpg');
figure, imshow(I)
bw = im2bw(I, graythresh(I));
bw2 = imfill(bw,'holes');
%label the image
[Label,Total] = bwlabel(bw2,8);
%object number
% num = 4;
% [row,col] = find(Label==num);
% 
% Obj_area=numel(row);
% display(Obj_area);

s = regionprops(bw2, 'centroid','area','perimeter','equivDiameter');
centroids = cat(1, s.Centroid);
area = cat(1, s.Area);
perimeter = cat(1, s.Perimeter);
% diameter = cat(1,sqrt(4*(Obj_area)/pi));
diameter = cat(1, s.EquivDiameter);
hold on
plot(centroids(:,1), centroids(:,2), 'r*')
 
[B,L] = bwboundaries(bw2,'noholes');
[~,num] = bwlabel(bw2,8);
 
for k = 1:num
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 2)
    text(boundary(1,2),boundary(1,1)-7,strcat(['Label = ',num2str(k)]),'Color','r',...
        'FontSize',10,'FontWeight','bold');
    text(boundary(1,2),boundary(1,1),strcat(['Area = ',num2str(area(k))]),'Color','b',...
        'FontSize',10,'FontWeight','bold');
    text(boundary(1,2),boundary(1,1)+7,strcat(['Perim = ',num2str(perimeter(k))]),'Color','g',...
        'FontSize',10,'FontWeight','bold');
    text(boundary(1,2),boundary(1,1)+14,strcat(['X = ',num2str(centroids(k,1))]),'Color','c',...
        'FontSize',10,'FontWeight','bold');
    text(boundary(1,2),boundary(1,1)+21,strcat(['Y = ',num2str(centroids(k,2))]),'Color','c',...
        'FontSize',10,'FontWeight','bold');
    text(boundary(1,2),boundary(1,1)+28,strcat(['Diam = ',num2str(diameter(k))]),'Color','g',...
        'FontSize',10,'FontWeight','bold');
end