
fileId = fopen('E:\Matlab_workspace\Tests_frame\�ǵ��ο�.pcm','r');
whitenoise = fread(fileId,inf,'int16');
whitenoise1 = conv(whitenoise,Num);
fid=fopen('E:\Matlab_workspace\Tests_frame\�ǵ��ο��˲�.pcm','wb');
fwrite(fid,whitenoise1,'int16');
