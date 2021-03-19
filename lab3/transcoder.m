function [bits, bpp, dist, psnr]=transcoder(block, quantStepLuminance, ...
    quantStepChrominance, srcCodingMethod, transform, subsampleFactor, ...
    showFig, imageName)

% This is a very simple transform coder and decoder. Copy it to your directory
% and edit it to suit your needs.
% You probably want to supply the image and coding parameters as
% arguments to the function instead of having them hardcoded.

if nargin == 7
    imageName = 'image1.png';
end

% Read an image
im=double(imread(imageName))/255;

% What blocksize do we want?
blocksize = [block block];

% Quantization steps for luminance and chrominance
qy = quantStepLuminance;
qc = quantStepChrominance;

% Change colourspace 
imy=rgb2ycbcr(im);

bits=0;


% Somewhere to put the decoded image
imyr=zeros(size(im));


% First we code the luminance component
% Here comes the coding part
if strcmp(transform, 'dct')
    tmp = bdct(imy(:,:,1), blocksize); % DCT
elseif strcmp(transform, 'dwht')
    tmp = bdwht(imy(:,:,1), blocksize);
end

tmp = bquant(tmp, qy);             % Simple quantization

if strcmp(srcCodingMethod, 'huffman')
    p = ihist(tmp(:));                 % Only one huffman code
    bits = bits + huffman(p);          % Add the contribution from
                                       % each component
elseif strcmp(srcCodingMethod, 'jpeg')
    bits = bits + sum(jpgrate(tmp, blocksize));
elseif strcmp(srcCodingMethod, 'ind huffman')
    for k=1:size(tmp, 1)
        p = ihist(tmp(k, :));
        bits = bits + huffman(p);
    end
end

			
% Here comes the decoding part
tmp = brec(tmp, qy);               % Reconstruction

if strcmp(transform, 'dct')
    imyr(:,:,1) = ibdct(tmp, blocksize, [512 768]);  % Inverse DCT
elseif strcmp(transform, 'dwht')
    imyr(:,:,1) = ibdwht(tmp, blocksize, [512 768]);
end

% Next we code the chrominance components
for c=2:3                          % Loop over the two chrominance components
  % Here comes the coding part

  tmp = imy(:,:,c);

  % If you're using chrominance subsampling, it should be done
  % here, before the transform.
  tmp = imresize(tmp, 1 / subsampleFactor);
  chromaSize = size(tmp);

  if strcmp(transform, 'dct')
    tmp = bdct(tmp, blocksize); % DCT
  elseif strcmp(transform, 'dwht')
    tmp = bdwht(tmp, blocksize);
  end
  
  tmp = bquant(tmp, qc);           % Simple quantization
  
  if strcmp(srcCodingMethod, 'huffman')
    p = ihist(tmp(:));                 % Only one huffman code
    bits = bits + huffman(p);          % Add the contribution from
                                       % each component
  elseif strcmp(srcCodingMethod, 'jpeg')
        bits = bits + sum(jpgrate(tmp, blocksize));
  elseif strcmp(srcCodingMethod, 'ind huffman')
    for k=1:size(tmp, 1)
        p = ihist(tmp(k, :));
        bits = bits + huffman(p);
    end
    % TODO Lägg till metod även nedan
  end
			
  % Here comes the decoding part
  tmp = brec(tmp, qc);            % Reconstruction
  
  if strcmp(transform, 'dct')
    tmp = ibdct(tmp, blocksize, chromaSize);  % Inverse DCT
  elseif strcmp(transform, 'dwht')
    tmp = ibdwht(tmp, blocksize, chromaSize);
  end
  

  % If you're using chrominance subsampling, this is where the
  % signal should be upsampled, after the inverse transform.
  tmp = imresize(tmp, subsampleFactor);

  imyr(:,:,c) = tmp;
  
end

% Display total number of bits and bits per pixel
bits;
bpp = bits/(size(im,1)*size(im,2));

% Revert to RGB colour space again.
imr=ycbcr2rgb(imyr);

% Measure distortion and PSNR
dist = mean((im(:)-imr(:)).^2);
psnr = 10*log10(1/dist);

if showFig
    % Display the original image
    figure, imshow(im)
    title('Original image')
    
    %Display the coded and decoded image
    figure, imshow(imr);
    title(sprintf('Decoded image, %5.2f bits/pixel, PSNR %5.2f dB', bpp, psnr))
end


