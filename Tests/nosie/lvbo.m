fileId = fopen('E:\Matlab_workspace\Tests\nosie\whitenoise.pcm','r');
whitenoise = fread(fileId,inf,'int16');

whitenoise0 = conv(whitenoise,Num);
whitenoise0 = whitenoise0(1001:end);

fid=fopen('E:\Matlab_workspace\Tests\nosie\whitenoise300500.pcm','wb');
fwrite(fid,whitenoise0,'int16');
