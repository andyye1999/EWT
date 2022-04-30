
fileId = fopen('E:\Matlab_workspace\Tests_frame\骨导参考.pcm','r');
whitenoise = fread(fileId,inf,'int16');
whitenoise1 = conv(whitenoise,Num);
fid=fopen('E:\Matlab_workspace\Tests_frame\骨导参考滤波.pcm','wb');
fwrite(fid,whitenoise1,'int16');
