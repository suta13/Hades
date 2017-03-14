function varargout = diameter(varargin)
% DIAMETER MATLAB code for diameter.fig
%      DIAMETER, by itself, creates a new DIAMETER or raises the existing
%      singleton*.
%
%      H = DIAMETER returns the handle to a new DIAMETER or the handle to
%      the existing singleton*.
%
%      DIAMETER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIAMETER.M with the given input arguments.
%
%      DIAMETER('Property','Value',...) creates a new DIAMETER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before diameter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to diameter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help diameter

% Last Modified by GUIDE v2.5 14-Mar-2017 10:57:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @diameter_OpeningFcn, ...
                   'gui_OutputFcn',  @diameter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before diameter is made visible.
function diameter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to diameter (see VARARGIN)

% Choose default command line output for diameter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes diameter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = diameter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function NamaFile_Callback(hObject, eventdata, handles)
% hObject    handle to NamaFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NamaFile as text
%        str2double(get(hObject,'String')) returns contents of NamaFile as a double


% --- Executes during object creation, after setting all properties.
function NamaFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NamaFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name_file1,name_path1] = uigetfile(...
    {'*.bmp;*.jpg;*.tif','Files of type (*.bmp,*.jpg,*.tif)';
    '*.bmp','File Bitmap (*.bmp)';...
    '*.jpg','File jpeg (*.jpg)';
    '*.tif','File tif (*.tif)';
    '*.*','All Files (*.*)'},...
    'Open Image');


if ~ isequal (name_file1,0)
    handles.data1 = imread(fullfile(name_path1,name_file1));
    info = imfinfo(fullfile(name_path1, name_file1));
    size_file = info.FileSize/1000;
    guidata(hObject,handles);
    handles.current_data1=handles.data1;
    axes(handles.Asli);
    imshow(handles.data1);
    set(handles.Nama,'String',name_file1);
    set(handles.kb,'String',size_file);
else
    return;
end


% --- Executes on button press in gray.
function gray_Callback(hObject, eventdata, handles)
% hObject    handle to gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% image1 = handles.data1;
% gray = rgb2gray(image1);
% axes(handles.Maximum);
% imshow(gray);
% handles.data2 = gray;
% guidata(hObject,handles);


% --- Executes on button press in preprocess.
function preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.data1;
img = rgb2gray(image1);
img1 = double (img);
img2=imresize(img1, [200 300]);

% figure,imshow(img,[]);
% figure,imshow(img2,[]);

%Value for Thresholding
T_Low = 0.275;
T_High = 0.175;

%Gaussian Filter Coefficient
%Melakukan proses filtering gaussian dengan (theta) ?=1.4 
B = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4;5, 12, 15, 12, 5;4, 9, 12, 9, 4;2, 4, 5, 4, 2 ];
B = 1/159.* B;

%Convolution of image by Gaussian Coefficient
A=conv2(img2, B, 'same');

%Filter for horizontal and vertical direction
%penghalusan
KGx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
KGy = [1, 2, 1; 0, 0, 0; -1, -2, -1];

%Convolution by image by horizontal and vertical filter
Filtered_X = conv2(A, KGx, 'same');
Filtered_Y = conv2(A, KGy, 'same');

%Calculate directions/orientations
%mementukan arah tepi
arah = atan2 (Filtered_Y, Filtered_X);
arah = arah*180/pi;

pan=size(A,1);
leb=size(A,2);

%Adjustment for negative directions, making all directions positive
for i=1:pan
    for j=1:leb
        if (arah(i,j)<0) 
            arah(i,j)=360+arah(i,j);
        end;
    end;
end;

arah2=zeros(pan, leb);

%Adjusting directions to nearest 0, 45, 90, or 135 degree
for i = 1  : pan
    for j = 1 : leb
        if ((arah(i, j) >= 0 ) && (arah(i, j) < 22.5) || (arah(i, j) >= 157.5) && (arah(i, j) < 202.5) || (arah(i, j) >= 337.5) && (arah(i, j) <= 360))
            arah2(i, j) = 0;
        elseif ((arah(i, j) >= 22.5) && (arah(i, j) < 67.5) || (arah(i, j) >= 202.5) && (arah(i, j) < 247.5))
            arah2(i, j) = 45;
        elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
            arah2(i, j) = 90;
        elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
            arah2(i, j) = 135;
        end;
    end;
end;

%Calculate magnitude
%Menghitung gradient magnitude 
magnitude = (Filtered_X.^2) + (Filtered_Y.^2);
magnitude2 = sqrt(magnitude);

BW = zeros (pan, leb);

%Non-Maximum Supression
%Melakukan proses penghilangan nilai-nilai yang tidak maksimum, 
%jika nilai intensitas tidak maksimum, maka akan dilakukan penurunan nilai pixel menjadi 0.
for i=2:pan-1
    for j=2:leb-1
        if (arah2(i,j)==0)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i,j+1), magnitude2(i,j-1)]));
        elseif (arah2(i,j)==45)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j-1), magnitude2(i-1,j+1)]));
        elseif (arah2(i,j)==90)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j), magnitude2(i-1,j)]));
        elseif (arah2(i,j)==135)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j+1), magnitude2(i-1,j-1)]));
        end;
    end;
end;

BW = BW.*magnitude2;
axes(handles.Maximum);
imshow(BW);
handles.data2 = BW;
guidata(hObject,handles);


%Hysteresis Thresholding
%Melakukan proses pengambangan (thresholding) dengan menggunakan dua nilai ambang yaitu 
%threshold  T_min (threshold nilai rendah) dan  T_max (threshold nilai tinggi).
T_Low = T_Low * max(max(BW));
T_High = T_High * max(max(BW));

T_res = zeros (pan, leb);

for i = 1  : pan
    for j = 1 : leb
        if (BW(i, j) < T_Low)
            T_res(i, j) = 0;
        elseif (BW(i, j) > T_High)
            T_res(i, j) = 1;
        %Using 8-connected components
        elseif ( BW(i+1,j)>T_High || BW(i-1,j)>T_High || BW(i,j+1)>T_High || BW(i,j-1)>T_High || BW(i-1, j-1)>T_High || BW(i-1, j+1)>T_High || BW(i+1, j+1)>T_High || BW(i+1, j-1)>T_High)
            T_res(i,j) = 1;
        end;
    end;
end;

edge_final = uint8(T_res.*255);
%Show final edge detection result

axes(handles.Deteksi);
imshow(edge_final);
handles.data3 = edge_final;
guidata(hObject,handles);



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save = handles.data3;
[name_file_save,path_save] = uiputfile(...
    {'*.bmp','File Bitmap (*.bmp)';...
    '*.jpg','File jpeg (*.jpg)';
    '*.tif','File Tif (*.tif)';
    '*.*','All Files (*.*)'},...
    'Save Image');

if ~isequal(name_file_save,0)
    imwrite(save,fullfile(path_save,name_file_save));
else
    return
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axHandles = [handles.Asli, handles.Maximum, handles.Diameter, handles.Deteksi];
for h = axHandles
   cla(h);
end
set([handles.Nama,handles.kb, handles.Perim, handles.Diam,handles.Larea, handles.Centro, handles.Centro2],'String','');
set([handles.Perim1, handles.Diam1,handles.Larea1, handles.CentroX, handles.CentroY],'String','');
set([handles.Perim2, handles.Diam2,handles.Larea2, handles.CentroX1, handles.CentroY1],'String','');
set([handles.Perim3, handles.Diam3,handles.Larea3, handles.CentroX2, handles.CentroY2],'String','');
set([handles.Perim4, handles.Diam4,handles.Larea4, handles.CentroX3, handles.CentroY3],'String','');
% set([handles.Larea, handles.Perim, handles.Centro, handles.Diam], 'Value',0);

% % Find all windows of type figure, which have an empty FileName attribute.
% allPlots = findall(0, 'String', 'handles', 'FileName', []);
% % Close.
% delete(allPlots);


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keluar = questdlg('Yakin Akan Keluar ?', ...
    'Keluar', ...
    'Ya','Tidak','Ya');
switch keluar,
    case 'Ya',
        clear handles.Asli;
        clear handles.Maximum;
        clear handles.Deteksi ;
        clear handles.Diameter;
        close;
    case 'Tidak',
        return
end
close;


% --- Executes on button press in hitung.
function hitung_Callback(hObject, eventdata, handles)
% hObject    handle to hitung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.data1;
axes(handles.Diameter);
imshow(image1);
handles.data3 = image1;
guidata(hObject,handles);
handles.data3 = image1;
guidata(hObject,handles);
bw = im2bw(image1, graythresh(image1));
bw2 = imfill(bw,'holes');

%label the image
[Label,Total] = bwlabel(bw2,8);
%object number
% num = 4;
% [row,col] = find(Label==num);
% 
% Obj_area=numel(row);
% display(Obj_area);
% centroids = [measurements.Centroid];
% xCentroids = centroids(1:2:end);
% yCentroids = centroids(2:2:end);

s = regionprops(bw2, 'centroid','area','perimeter','equivDiameter','MajorAxisLength','MinorAxisLength');
centroids = cat(1, s.Centroid);
majorAxisLength = cat(1,s.MajorAxisLength);
minorAxisLength = cat(1,s.MinorAxisLength);
smajorAxisLength = majorAxisLength/2;
sminorAxisLength = minorAxisLength/2;
% xCentroids = centroids(1:2:end);
% yCentroids = centroids(2:2:end);
area = cat(1, s.Area);
% area = cat(1,3.14 * smajorAxisLength * sminorAxisLength);
% perimeter = cat(1, s.Perimeter);
perimeter = cat(1,2*pi*(sqrt((power(smajorAxisLength,2)+power(sminorAxisLength,2))/2)));
diameter = cat(1,sqrt(4*(area)/pi));
% diameter = cat(1, s.EquivDiameter);
hold on
plot(centroids(:,1), centroids(:,2), 'r*')
 
[B,L] = bwboundaries(bw2,'noholes');
[~,num] = bwlabel(bw2,8);
 
for k = 1:num
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 2)
    text(boundary(1,2),boundary(1,1)-7,strcat(['Label = ',num2str(k)]),'Color','r',...
        'FontSize',7,'FontWeight','bold');
%     text(boundary(1,2),boundary(1,1),strcat(['Area = ',num2str(area(k))]),'Color','b',...
%         'FontSize',7,'FontWeight','bold');
%     text(boundary(1,2),boundary(1,1)+7,strcat(['Perim = ',num2str(perimeter(k))]),'Color','g',...
%         'FontSize',7,'FontWeight','bold');
%     text(boundary(1,2),boundary(1,1)+16,strcat(['X = ',num2str(centroids(k,1))]),'Color','c',...
%         'FontSize',7,'FontWeight','bold');
%     text(boundary(1,2),boundary(1,1)+26,strcat(['Y = ',num2str(centroids(k,2))]),'Color','c',...
%         'FontSize',7,'FontWeight','bold');
%     text(boundary(1,2),boundary(1,1)+35,strcat(['Diam = ',num2str(diameter(k))]),'Color','g',...
%         'FontSize',7,'FontWeight','bold');
end

for k = 1
set(handles.Label,'String',strcat(['Label = ',num2str(k)]));
set(handles.Perim,'String',strcat(num2str(perimeter(k))));
set(handles.Diam,'String',strcat(num2str(diameter(k))));
set(handles.Larea,'String',strcat(num2str(area(k))));
set(handles.Centro,'String',strcat(num2str(majorAxisLength(k))));
set(handles.Centro2,'String',strcat(num2str(minorAxisLength(k))));
end
for k = 2
set(handles.Label2,'String',strcat(['Label = ',num2str(k)]));
set(handles.Perim1,'String',strcat(num2str(perimeter(k))));
set(handles.Diam1,'String',strcat(num2str(diameter(k))));
set(handles.Larea1,'String',strcat(num2str(area(k))));
set(handles.CentroX,'String',strcat(num2str(majorAxisLength(k))));
set(handles.CentroY,'String',strcat(num2str(minorAxisLength(k))));
end
for k = 3
set(handles.Label3,'String',strcat(['Label = ',num2str(k)]));
set(handles.Perim2,'String',strcat(num2str(perimeter(k))));
set(handles.Diam2,'String',strcat(num2str(diameter(k))));
set(handles.Larea2,'String',strcat(num2str(area(k))));
set(handles.CentroX1,'String',strcat(num2str(majorAxisLength(k))));
set(handles.CentroY1,'String',strcat(num2str(minorAxisLength(k))));
end
for k = 4
set(handles.Label4,'String',strcat(['Label = ',num2str(k)]));
set(handles.Perim3,'String',strcat(num2str(perimeter(k))));
set(handles.Diam3,'String',strcat(num2str(diameter(k))));
set(handles.Larea3,'String',strcat(num2str(area(k))));
set(handles.CentroX2,'String',strcat(num2str(majorAxisLength(k))));
set(handles.CentroY2,'String',strcat(num2str(minorAxisLength(k))));
end
for k = 5
set(handles.Label5,'String',strcat(['Label = ',num2str(k)]));
set(handles.Perim4,'String',strcat(num2str(perimeter(k))));
set(handles.Diam4,'String',strcat(num2str(diameter(k))));
set(handles.Larea4,'String',strcat(num2str(area(k))));
set(handles.CentroX3,'String',strcat(num2str(majorAxisLength(k))));
set(handles.CentroY3,'String',strcat(num2str(minorAxisLength(k))));
end

function Larea_Callback(hObject, eventdata, handles)
% hObject    handle to Larea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Larea as text
%        str2double(get(hObject,'String')) returns contents of Larea as a double


% --- Executes during object creation, after setting all properties.
function Larea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Larea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Perim_Callback(hObject, eventdata, handles)
% hObject    handle to Perim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Perim as text
%        str2double(get(hObject,'String')) returns contents of Perim as a double


% --- Executes during object creation, after setting all properties.
function Perim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Centro_Callback(hObject, eventdata, handles)
% hObject    handle to Centro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Centro as text
%        str2double(get(hObject,'String')) returns contents of Centro as a double


% --- Executes during object creation, after setting all properties.
function Centro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Centro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diam_Callback(hObject, eventdata, handles)
% hObject    handle to Diam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diam as text
%        str2double(get(hObject,'String')) returns contents of Diam as a double


% --- Executes during object creation, after setting all properties.
function Diam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myicon = imread('ayam.jpg');
msg = cell(7,1);
msg{1} = sprintf('Tombol Open = Membuka file citra');
msg{2} = sprintf('Tombol Gray = Convert Citra RGB ke Grayscale');
msg{3} = sprintf('Tombol Canny = Deteksi Tepi Canny');
msg{4} = sprintf('Tombol Save = Untuk menyimpan file');
msg{5} = sprintf('Tombol Reset = Untuk mereset tampilan / mengosongkan tampilan');
msg{6} = sprintf('Tombol Hitung = Untuk proses menghitung diameter');
msg{7} = sprintf('Tombol Exit = Keluar dari GUI');
msg{8} = sprintf('Tombol Help = Bantuan untuk menggunakan aplikasi ini');
msg{9} = sprintf('Tombol About = Keluar dari GUI');
msgbox(msg,'Bantuan','custom',myicon)


% --- Executes on button press in about.
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
intro = 'Tentang Aplikasi :';
nama = {'Nama : Aplikasi Deteksi Tepi ','Version : 1.0 ','STIKOM BALI'}; % Define as desired:
msgbox([intro nama])



function Centro2_Callback(hObject, eventdata, handles)
% hObject    handle to Centro2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Centro2 as text
%        str2double(get(hObject,'String')) returns contents of Centro2 as a double


% --- Executes during object creation, after setting all properties.
function Centro2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Centro2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Larea1_Callback(hObject, eventdata, handles)
% hObject    handle to Larea1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Larea1 as text
%        str2double(get(hObject,'String')) returns contents of Larea1 as a double


% --- Executes during object creation, after setting all properties.
function Larea1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Larea1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Perim1_Callback(~, eventdata, handles)
% hObject    handle to Perim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Perim1 as text
%        str2double(get(hObject,'String')) returns contents of Perim1 as a double


% --- Executes during object creation, after setting all properties.
function Perim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroX_Callback(hObject, eventdata, handles)
% hObject    handle to CentroX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroX as text
%        str2double(get(hObject,'String')) returns contents of CentroX as a double


% --- Executes during object creation, after setting all properties.
function CentroX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroY_Callback(hObject, eventdata, handles)
% hObject    handle to CentroY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroY as text
%        str2double(get(hObject,'String')) returns contents of CentroY as a double


% --- Executes during object creation, after setting all properties.
function CentroY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diam1_Callback(hObject, eventdata, handles)
% hObject    handle to Diam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diam1 as text
%        str2double(get(hObject,'String')) returns contents of Diam1 as a double


% --- Executes during object creation, after setting all properties.
function Diam1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Larea2_Callback(hObject, eventdata, handles)
% hObject    handle to Larea2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Larea2 as text
%        str2double(get(hObject,'String')) returns contents of Larea2 as a double


% --- Executes during object creation, after setting all properties.
function Larea2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Larea2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Perim2_Callback(hObject, eventdata, handles)
% hObject    handle to Perim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Perim2 as text
%        str2double(get(hObject,'String')) returns contents of Perim2 as a double


% --- Executes during object creation, after setting all properties.
function Perim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroX1_Callback(hObject, eventdata, handles)
% hObject    handle to CentroX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroX1 as text
%        str2double(get(hObject,'String')) returns contents of CentroX1 as a double


% --- Executes during object creation, after setting all properties.
function CentroX1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroY1_Callback(hObject, eventdata, handles)
% hObject    handle to CentroY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroY1 as text
%        str2double(get(hObject,'String')) returns contents of CentroY1 as a double


% --- Executes during object creation, after setting all properties.
function CentroY1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diam2_Callback(hObject, eventdata, handles)
% hObject    handle to Diam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diam2 as text
%        str2double(get(hObject,'String')) returns contents of Diam2 as a double


% --- Executes during object creation, after setting all properties.
function Diam2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Larea3_Callback(hObject, eventdata, handles)
% hObject    handle to Larea3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Larea3 as text
%        str2double(get(hObject,'String')) returns contents of Larea3 as a double


% --- Executes during object creation, after setting all properties.
function Larea3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Larea3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Perim3_Callback(hObject, eventdata, handles)
% hObject    handle to Perim3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Perim3 as text
%        str2double(get(hObject,'String')) returns contents of Perim3 as a double


% --- Executes during object creation, after setting all properties.
function Perim3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perim3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroX2_Callback(hObject, eventdata, handles)
% hObject    handle to CentroX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroX2 as text
%        str2double(get(hObject,'String')) returns contents of CentroX2 as a double


% --- Executes during object creation, after setting all properties.
function CentroX2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroY2_Callback(hObject, eventdata, handles)
% hObject    handle to CentroY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroY2 as text
%        str2double(get(hObject,'String')) returns contents of CentroY2 as a double


% --- Executes during object creation, after setting all properties.
function CentroY2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diam3_Callback(hObject, eventdata, handles)
% hObject    handle to Diam3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diam3 as text
%        str2double(get(hObject,'String')) returns contents of Diam3 as a double


% --- Executes during object creation, after setting all properties.
function Diam3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diam3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Larea4_Callback(hObject, eventdata, handles)
% hObject    handle to Larea4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Larea4 as text
%        str2double(get(hObject,'String')) returns contents of Larea4 as a double


% --- Executes during object creation, after setting all properties.
function Larea4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Larea4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Perim4_Callback(hObject, eventdata, handles)
% hObject    handle to Perim4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Perim4 as text
%        str2double(get(hObject,'String')) returns contents of Perim4 as a double


% --- Executes during object creation, after setting all properties.
function Perim4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perim4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroX3_Callback(hObject, eventdata, handles)
% hObject    handle to CentroX3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroX3 as text
%        str2double(get(hObject,'String')) returns contents of CentroX3 as a double


% --- Executes during object creation, after setting all properties.
function CentroX3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroX3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroY3_Callback(hObject, eventdata, handles)
% hObject    handle to CentroY3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroY3 as text
%        str2double(get(hObject,'String')) returns contents of CentroY3 as a double


% --- Executes during object creation, after setting all properties.
function CentroY3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroY3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diam4_Callback(hObject, eventdata, handles)
% hObject    handle to Diam4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diam4 as text
%        str2double(get(hObject,'String')) returns contents of Diam4 as a double


% --- Executes during object creation, after setting all properties.
function Diam4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diam4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



