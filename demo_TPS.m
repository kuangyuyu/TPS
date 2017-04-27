%% MLS for images using points as pivots
%  The same work done for points can be used for images using a dense set
% of points over a grid that cover the image and using the interpolation to
% get all the transformations. The function MLSD2DWarp do exactly this
% work. The same mlsd must be computed to obtain the warping, only the set
% of points is different because a grid is required, so a step must be
% chosen.

% The step size:
step = 10;
sigma = 5;
lambda = 1000;
alpha = 1;

% Reading an image:
img = imread('face.png');

% Requiring the pivots:
f=figure(1); imshow(img);hold on;
p = getpoints;


% Requiring the new pivots:
f=figure(2); imshow(img); hold on; plotpointsLabels(p,'r.');
q = getpoints;

[h,w,c] = size(img);
s_p = [1,w,w,1;1,1,h,h];
h_p = [1:step*10:h,h];
w_p = [1:step*10:w,w];
hs1 = ones(1,length(h_p)) ;
ws1 =  ones(1,length(w_p)) ;
hsh = h.*ws1;
wsw = w.*hs1;
 sp_1 = [hs1',h_p'];
 sp_2 = [w_p;ws1]';
 sp_3 = [w_p;hsh]';
 sp_4 = [wsw',h_p'];
 sp = [sp_1;sp_2(2:end-1,:);sp_3(2:end-1,:);sp_4]';
p = [sp,p];
q = [sp,q];
% normalization
[np, nq, normal]=norm2(p',q');
px = q(1,:)';
py = q(2,:)';
plot(px,py,'rx');
hold off

% Generating the grid:
%grid_W = sort([1:step:w,w,p(1,:)]);
%grid_H = sort([1:step:h,h,p(2,:)]);

grid_W = [1:step:w,w];
grid_H = [1:step:h,h];

[X,Y] = meshgrid(grid_W,grid_H);

nX = (X-normal.xm(1))/normal.xscale;
nY = (Y-normal.xm(2))/normal.xscale;

% The warping can now be computed:
[imgo,sfp,sfv] = MRLS_TPS(img,np,nq,nX,nY,normal,lambda,alpha);
opx = sfp(:,1)*normal.yscale+normal.ym(1);
opy = sfp(:,2)*normal.yscale+normal.ym(2);
op = [opx,opy]';

oX = sfv(:,1)*normal.yscale+normal.ym(1);
oY = sfv(:,2)*normal.yscale+normal.ym(2);

% Plotting the result:
figure(3); imshow(imgo); hold on; plotpoints(q,'ro'); plotpoints(op,'gx');hold off
figure(4);
subplot(1,2,1),imshow(img);                  %
subplot(1,2,2),imshow(imgo); 
figure(5);
   % plot(nX(:),nY(:),'ro',sfv(:,1),sfv(:,2),'b+')
    hold on
    ind = 1:length(X(:));
    plot(nX,nY,'r.',[nX(:) sfv(ind,1)]',[nY(:) sfv(ind,2)]','k-','MarkerSize',2)%Tx -->
    hold off
    title( 'X->Y')
    
    figure(6);imshow(imgo); hold on; plot(oX,oY,'y.');hold off
    

imwrite(imgo,'imgo1.jpg');
% figure; imshow(img); hold on; plotpoints(p,'r.'); hold off
