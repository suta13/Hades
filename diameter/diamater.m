clc

%read original image
I = imread('D:\STIKOM BALI\SMT 7\Pra Skripsi\latihan\diameter\telurcanny2.jpg');

%conver to binary
B = im2bw(I);
figure;imshow(B)

%fill the holes
C = imfill(B,'holes');
%label the image
[Label,Total] = bwlabel(C,8);
%object number
num = 4;
[row,col] = find(Label==num);

%to find bounding box
sx = min(col)-0.5;
sy = min(row)-0.5;
breadth = max(col)-min(col)+1;
len = max(row)-max(row)+1;
BBox=[sx sy breadth len];
display(BBox);

%refer
figure,imshow(I);
hold on;
x = zeros([1 5]);
y = zeros([1 5]);
x(:) = BBox(1);
y(:) = BBox(2);
x(2:3)=BBox(1)+BBox(3);
y(3:4)=BBox(2)+BBox(4);
plot(x,y);

%find area
Obj_area=numel(row);
display(Obj_area);

%find centroid
X = mean(col);
Y = mean(row);
Centroid = [X Y];
display(Centroid);
plot(X,Y,'ro','color','r');
hold off;

%find perimeter
BW = bwboundaries(Label==num);
c = cell2mat(BW(1));
Perimeter=0;
for i=1:size(c,1)-1
    Perimeter = Perimeter+sqrt((c(i,1)-c(i+1,1)).^2+(c(i,2)-c(i+1,2)).^2);
end
display(Perimeter);

%find equivdiameter
EquivD = sqrt(4*(Obj_area)/pi);
display(EquivD);

%find roundness
Roundness = (4*Obj_area*pi)/Perimeter.^2;
display(Roundness);