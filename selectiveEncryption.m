clc
clear all

    %**********************************************
                % Prepare Image
    %**********************************************
    
%Opens dialog box and select and image from it - image size should be in KB to avoid delay in processing
[filename,filepath]=uigetfile({'*.png'; '*.jpg'},...
    'Select an image');

streamRaw = imread(strcat(filepath, filename));
[row,col,dim]=size(streamRaw);
if (dim>1)
streamGray=rgb2gray(streamRaw); % convert into gray-scale if input image is a color image
end


        %****************************************************************
        % Image Stream Manipulation to allow easy Encryption/Decryption
        %****************************************************************

streamGray =reshape(streamGray,[size(streamGray,1)*size(streamGray,2) 1]);
BinData = [];
for j=1:size(streamGray,2)
temp=[];
for i=1:size(streamGray, 1)
temp = vertcat(temp, Dec2Binary(streamGray(i,j)));
end
BinData = vertcat(BinData, temp);
end


            %*****************************************************
                            % % Encryption
            %*****************************************************


key = 10110010;
key = num2str(key) - '0';
encrypt_msg=[];
encrypt_msg_dec = [];
for i=1:size(BinData, 1)

encrypt_msg = vertcat(encrypt_msg, circshift(bitxor(BinData(i,:), key), 4));
encrypt_msg_dec = vertcat(encrypt_msg_dec, bin2dec(num2str(encrypt_msg(i,:))));
end


            %*****************************************************
                            % % Decryption
            %*****************************************************
            
key = 10110010;
key = num2str(key) - '0';
decrypt_msg=[];
decrypt_msg_dec = [];

for i=1:size(BinData, 1)
decrypt_msg = vertcat(decrypt_msg, bitxor(circshift(encrypt_msg(i,:), -4), key));
decrypt_msg_dec = vertcat(decrypt_msg_dec, bin2dec(num2str(decrypt_msg(i,:))));
end

            %*****************************************************
                            % % Image Display/Comparison
            %*****************************************************

stream_original=uint8(reshape(streamGray,[row,col]));
stream_encrypted=uint8(reshape(encrypt_msg_dec,[row,col]));
stream_decrypted=uint8(reshape(decrypt_msg_dec,[row,col]));

subplot(1,3,1)
imshow(stream_original)
title('Original')
subplot(1,3,2)
imshow(stream_encrypted)
title({'Selectively','Encrypted'})
subplot(1,3,3)
imshow(stream_decrypted)
title('Decrypted')


            %*****************************************************
                % Helper Function to Convert Decimal To Binary
            %*****************************************************


function [ base2 ] = Dec2Binary( decimal )
base2=logical([]);
for z=1:length(decimal)
base2 = [base2 logical(dec2bin(decimal(z), 8) - '0')]
end
end
