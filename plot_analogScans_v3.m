%%  plot_analogScans_v3.m
%   find a more efficient process of plotting data and making a montage
%   i.e. skip saving jpgs
%   i.e. use subplot? 

%%  plot_analogScans_v2.m
%   This version will automatically read the chunksize.

%   Future: auto read sweep number.
%   Future: Write h5 info to a diary file for additional info to read

%   This will only work with GETI screen data as of 20190826

% CHANGE THESE VALUES
% pname is the name to save the final output figure as. 
pname = 'P13a-20190729';

% input the path to the h5 file to be read.
%path = '/Volumes/genie/GETIScreenData/RawImageData/20190813_iGABASnFR/P24a-20190729_0001-0160.h5';
[file, pathname] = uigetfile('/Volumes/genie/GETIScreenData/RawImageData/20190813_iGABASnFR/*.h5');

% path = '/Volumes/genie/GETIScreenData/RawImageData/20190813_iGABASnFR/P13a-20190729_0001-0160.h5'
path = fullfile(pathname,file)
newdirname = fullfile(junkFolder,pname);

mkdir(newdirname);
 
numsweeps = 160;
junkFolder = '/Volumes/genie/Arthur_GENIE_stuff/tempwrite';


% loop this through all sweeps
for i = 1:numsweeps
    if i < 10
        sweepnum = strcat('000',num2str(i));
    elseif i>9 && i<100
        sweepnum = strcat('00',num2str(i));
    else
        sweepnum = strcat('0',num2str(i));
    end
    sweep = strcat('/sweep_',sweepnum,'/analogScans');
    elecreads{1,i} = h5read(path, sweep);
    
    y = elecreads{1,i}(:,1);
    x = 1:size(y,1);
    filename = fullfile(newdirname,sweepnum);
    filename_extension = strcat(filename,'.jpg');
    plot(x,y);
    saveas(gcf,filename_extension,'jpg');
    close;

end



junkpath = strcat(junkFolder,'/*.jpg');
filenames = dir(junkpath);

for i = 1:numsweeps
    filenameonly(i,1) = strcat(string(filenames(i).folder),'/',string(filenames(i).name));
end
% 
montage(filenameonly, 'Size', [8 20]);

for i = 1:numsweeps
    delete(filenameonly(i,1));
end

filename = fullfile(junkFolder,pname);
filename_extension = strcat(filename,'-StimGraph');
savefig(filename_extension);


% saveas(gcf,filename_extension,'fig');