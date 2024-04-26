function diff_im = dynamicAnisodiff(im, num_iter, delta_t, kappa,sigmU,sigmL)
        
        % Implementation of anisotrophic diffusion filter from
        % Adaptive Perona–Malik Model Based on the Variable Exponent
        % for Image Denoising by
        % Zhichang Guo, Jiebao Sun, Dazhi Zhang, and Boying Wu
        
        im = double(im);
        
        diff_im = im;
        
        dx = 1;
        dy = 1;
        
        % 2D convolution masks - finite differences.
        hN = [0 1 0; 0 -1 0; 0 0 0];
        hS = [0 0 0; 0 -1 0; 0 1 0];
        hE = [0 0 0; 0 -1 1; 0 0 0];
        hW = [0 0 0; 1 -1 0; 0 0 0];
        
        sigm0 = sigmU;
        
        % Anisotropic diffusion.
        for t = 1:num_iter
                
                % calculating alfa
                sigm = sigm0 + t*(sigmL-sigmU)/num_iter;
                Ng = ceil(6*sigm)+1;
                G = fspecial('gaussian',[Ng,Ng],sigm);
                nIm=diff_im/255;
                gi = imfilter(nIm,G,'conv');
                
                giN = imfilter(gi,hN,'conv');
                giS = imfilter(gi,hS,'conv');   
                giW = imfilter(gi,hW,'conv');
                giE = imfilter(gi,hE,'conv');
                
                k =0.1;
                alfaN = 2 - (2/(1+k*(norm(giN,1))^2));
                alfaS = 2 - (2/(1+k*(norm(giS,1))^2));
                alfaW = 2 - (2/(1+k*(norm(giW,1))^2));
                alfaE = 2 - (2/(1+k*(norm(giE,1))^2));
                
                
                % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
                nablaN = imfilter(diff_im,hN,'conv');
                nablaS = imfilter(diff_im,hS,'conv');   
                nablaW = imfilter(diff_im,hW,'conv');
                nablaE = imfilter(diff_im,hE,'conv');
                
                % Diffusion function.
                cN = 1./(1 + (abs(nablaN)/kappa).^alfaN);
                cS = 1./(1 + (abs(nablaS)/kappa).^alfaS);
                cW = 1./(1 + (abs(nablaW)/kappa).^alfaW);
                cE = 1./(1 + (abs(nablaE)/kappa).^alfaE);
        
                % Discrete PDE solution.
                diff_im = diff_im + ...
                          delta_t*(...
                          (1/(dy^2))*cN.*nablaN + (1/(dy^2))*cS.*nablaS + ...
                          (1/(dx^2))*cW.*nablaW + (1/(dx^2))*cE.*nablaE );
        
        end
        diff_im = uint8(diff_im);