function offset = ord(filename, x, out_name)
% Check reference offset for CA, CB, HA, and CO

offset = -100;
if nargin < 1, bmrb = 4998; end; if nargin < 2, x = 2; end

tmp = load(filename);
if size(tmp, 1)<20, return; end
pH = tmp(1, end);
%load paper/offset/data/procorr.txt
procorr = [
%      #      CA	    CB        HA        CO       HN     N      CA-CB	AA
    1.0000    2.0000    1.0000   -0.3000    1.9000   0.05  -1.2
    3.0000    2.0000    0.2000   -0.2900    1.3000   0.03  -1.0
    4.0000    2.4000    0.7000   -0.2800    1.7000   0.08  -1.5
    5.0000    2.1000    0.5000   -0.2700    1.4000   0.17  -0.6
    7.0000    1.7000         0   -0.3000    1.5000   0.05  -0.0
    8.0000    2.4000    0.1000   -0.2800    1.4000  -0.06  -1.8 
    9.0000    2.0000    0.5000   -0.2900    1.8000   0.11  -1.2
   10.0000    2.0000    0.7000   -0.3400    1.9000   0.02  -0.8
   11.0000    2.1000    0.5000   -0.2600    1.7000   0.03  -1.1
   12.0000    1.8000    0.2000   -0.3100    1.6000   0.03  -0.3
   14.0000    2.0000    0.6000   -0.3100    1.6000   0.03  -0.8
   15.0000    2.0000    0.7000   -0.3100    1.8000   0.03  -0.8
   16.0000    1.9000    0.5000   -0.3100    1.5000   0.05  -0.9
   17.0000    2.0000         0   -0.2600    1.5000   0.00  -2.4
   18.0000    2.4000    0.3000   -0.3200    1.4000   0.01  -1.3
   19.0000    1.8000    0.7000   -0.3300    1.3000   0.16  -0.9
   20.0000    2.1000    0.5000   -0.2900    1.1000   0.02  -0.5
];

aas = tmp(:, 2);
pros = find(aas == 13); if length(pros)>0 & pros(1)==1, pros(1) = []; end
for k = 1 : length(pros)
    tmpaa = tmp(pros(k)-1, 2);
    tmpnon = find(tmp(pros(k)-1, :)==-100);
    procr = procorr(find(procorr(:, 1)==tmpaa), :);
    if length(procr)>0 & tmp(pros(k)-1, 1) + 1 == tmp(pros(k), 1)
        tmp(pros(k)-1, :);
        tmp(pros(k)-1, 3:6) = tmp(pros(k)-1, 3:6) + procr(2:5);
        tmp(pros(k)-1, tmpnon) = -100;
    end
end

tmp(find(tmp(:, 2)<1), :) = [];
tmp(find(min(tmp(:, [3 4 x+1]), [], 2)==-100), :) = [];
tmp = [tmp(:, 1:4) tmp(:, x+1)];
if size(tmp, 1) > 20
    offset = findoffset(tmp, x+1, out_name, pH);
end
tmp = 'CACBHACOHNNH';
x = x - 1;
%print(gcf, '-dtiff', strcat('paper/offset/main/', num2str(bmrb), tmp(2*(x-1)+1:2*x)));
return;

function offset = findoffset(tmp, x, out_name, pH)
refCACACB = [
% Reference to J. Bio. NMR 1995.5 67-81
%#	CA	    CB       HA    CO     NH    N      CA-CB	AA   CA   CB   HA CO NH N 
%
1	52.5	19.1     4.32  177.8  8.24  123.8  33.6	52.8 19.3 4.35 178.5 8.35 125.0%Ala 
3	54.2	41.1	 4.64  176.3  8.34  120.4  13.3	53.0 38.3 4.82 175.9 8.56 119.1%Asp 
4	56.6	29.9	 4.35  176.6  8.42  120.2  26.6	56.1 29.9 4.42 176.8 8.40 120.2%Glu 
5	57.7	39.6	 4.62  175.8  8.30  120.3  18.4 58.1 39.8 4.65 176.6 8.31 120.7%Phe 
7	55.0	29.0	 4.73  174.1  8.42  118.2  26.1	55.4 29.1 4.79 175.1 8.56 118.1%His 
8	61.1	38.8	 4.17  176.4  8.00  119.9  22.4	61.6 38.9 4.21 177.1 8.17 120.4%Ile 
9	56.2	33.1	 4.32  176.6  8.29  120.4  23.4	56.7 33.2 4.36 177.4 8.36 121.6%Lys 
10	55.1	42.4	 4.34  177.6  8.16  121.8  13.0	55.5 42.5 4.38 178.2 8.28 122.4%Leu 
11	55.4	32.9	 4.48  176.3  8.28  119.6  23.0	55.8 32.9 4.52 177.1 8.42 120.3%Met 
12	53.1	38.9	 4.74  175.2  8.40  118.7  14.5	53.3 39.1 4.79 176.1 8.51 119.0%Asn 
%13	63.3	32.1	 4.42  177.3  0.00  0.00   31.30	63.7 32.2 4.45 177.8 0    0%Pro 
14	55.7	29.4	 4.34  176.0  8.32  119.8  26.6	56.2 29.5 4.38 176.8 8.44 120.5%Gln 
15	56.0	30.9	 4.34  176.3  8.23  120.5  25.5	56.5 30.9 4.38 177.1 8.39 121.2%Arg 
16	58.3	63.8	 4.47  174.6  8.31  115.7  -5.2	58.7 64.1 4.51 175.4 8.43 115.5%Ser 
17	61.8	69.8	 4.35  174.7  8.15  113.6  -8.0	62.0 70.0 4.43 175.6 8.25 112.0%Thr 
18	62.2	32.9	 4.12  176.3  8.03  119.2  29.4	62.6 31.8 4.16 177.0 8.16 119.3%Val 
19	57.5	29.6	 4.66  176.1  8.25  121.3  28.0	57.6 29.8 4.70 177.1 8.22 122.1%Trp 
20	57.9	38.8	 4.55  175.9  8.12  120.3  19.3	58.3 38.9 4.58 176.7 8.26 120.9%Tyr   
];

if pH < 4
    refCACACB(:, 2:7) = refCACACB(:, 9:14);
    refCACACB(:, 8) = refCACACB(:, 2) - refCACACB(:, 3);
end
refCACACB(:, 9:14) = [];
tmp(find(tmp(:, 2)==2|tmp(:, 2)==6|tmp(:, 2)==13), :) = [];
tmpp = [];
for i = 1 : length(tmp)
    temp = find(refCACACB(:, 1)==tmp(i, 2));
    tmpp = [tmpp; refCACACB(temp, 2:end)];
end
tmp = [tmp tmpp];
%#	AA  CA  CB  X   CAref  CBref  HAref COref  NHref  Nref  (CA-CB)ref
%1  2   3   4   5      6      7     8      9      10    11   12
Nn = size(tmp, 2);
tmp(:, Nn+1) = tmp(:, 3) - tmp(:, 4) - tmp(:,6) + tmp(:,7);
tmp(:, Nn+2) = tmp(:, 5) - tmp(:, x+3);
os = [];
ths = [1 1 1 6 6 6 6];
offset = pf(tmp(:, Nn+1), tmp(:, Nn+2), x, tmp(:, 1:2), out_name, ths(x-1));
return;

function os = pf(X, Y, x, sn, out_name, th)
AA = 'ACDEFGHIKLMNPQRSTVWY';

if length(X) < 20, os = -100; return; end
Y(find(abs(X)>10))=[];X(find(abs(X)>10))=[];
Xo = []; Yo = []; Lso = [];
k = 0;
X1= X; Y1= Y;
sn0 = sn;

while 1
    ds = mahal([X Y], [X Y]);
    [YY II] = sort(ds);
    cf = find(YY>0.8*max(YY));
    Xo = [Xo X(II(cf(1):end))']; 
    Yo = [Yo Y(II(cf(1):end))']; 
    Lso = [Lso; sn(II(cf(1):end), :)];
    X(II(cf(1):end)) = []; Y(II(cf(1):end))=[]; sn(II(cf(1):end), :) = [];
    
    if length(Xo)> 0.02*length(X), Xo; break; end
    k = k + 1;
    if k>0, break; end
end

ss = 'CACBHACONH N';

if ~strcmp( out_name, 'stdout' )
    fid = fopen(out_name, 'a');
end

for  i = 1 : length(Xo)
    dx = 0.2;
    if strcmp( out_name, 'stdout' )
	fprintf('  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', Lso(i, 1),  AAtable(AA(Lso(i, 2)) ),...
        'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), Xo(i), Yo(i), 0);
    else
	fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', Lso(i, 1),  AAtable(AA(Lso(i, 2)) ),...
        'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), Xo(i), Yo(i), 0);
    end
    %h = text(Xo(i)+dx, Yo(i), strcat(num2str(Lso(i, 1)), AA(Lso(i, 2)))); set(h, 'FontSize', 16);
end
for i = 1 : length(X)
    if strcmp( out_name, 'stdout' )
	fprintf('  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', sn(i, 1), AAtable(AA(sn(i, 2))), ...
    	    'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), X(i), Y(i), 1);
    else
        fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', sn(i, 1), AAtable(AA(sn(i, 2))), ...
	    'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), X(i), Y(i), 1);
    end
end

if ~strcmp( out_name, 'stdout' )
    fclose(fid);
end

os = twolines(X1,Y1, sn0, out_name, th, x);
return;

function os = twolines(X, Y, sn, bmrb, th, x)
% th = 3;
AA = 'ACDEFGHIKLMNPQRSTVWY';

I1 = find(X<th);  I2 = find(X>-1*th);
X1 = X(find(X<th)); Y1 = Y(find(X<th));
X2 = X(find(X>-1*th)); Y2 = Y(find(X>-1*th));
P = []; S = [];

ss = 'CACBHACONH N';

if ~strcmp( bmrb, 'stdout' )
    fid = fopen(bmrb, 'a');
end

if length(X1) > 10
    [P1 S1] = robustfit(X1, Y1); 
    x1 = [min(X1):.01:2]; y1 = P1(2)*x1+P1(1);
%     h = plot(x1, y1, 'r--'); set(h, 'LineWidth', 2); 
    P = [P P1(1)]; S = [S P1(2)];
    if strcmp( bmrb, 'stdout' )
        fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(1), y1(1), 2 );
	fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(end), y1(end), 2 );
    else
        fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(1), y1(1), 2 );
	fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(end), y1(end), 2 );
    end
end
if length(X2) > 10
    [P2 S2] = robustfit(X2, Y2); 
    x2 = [-2:.01:max(X2)]; y2 = P2(2)*x2+P2(1);
%     h = plot(x2, y2, 'r'); set(h, 'LineWidth', 2);
    P = [P P2(1)]; S = [S P2(2)];
    if strcmp( bmrb, 'stdout' )
        fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x2(1), y2(1), 3 );
        fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x2(end), y2(end), 3 );
    else
        fprintf( fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x2(1), y2(1), 3 );
        fprintf( fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x2(end), y2(end), 3 );
    end
end

if ~strcmp( bmrb, 'stdout' )
    fclose(fid);
end

wgts = [];
for i = 1 : size(sn, 1)
    tmp1 = find(I1==i);
    tmp2 = find(I2==i);
    if length(tmp1)>0 && length(tmp2)>0 & exist('S1', 'var') & exist('S2', 'var')
        w = min([S1.w(tmp1) S2.w(tmp2)]);
    elseif length(tmp1)>0 & exist('S1', 'var')
        w = S1.w(tmp1);
    elseif exist('S2', 'var')
        w = S2.w(tmp2);    
    else
        w = 0;
    end
    wgts = [wgts; w];
end

format short g
%[YY II] = sort(wgts);
%tmp = [sn(II, 1) sn(II, 2) YY]

% wgts = (1-exp(1-wgts))/(1-exp(1));\
wgts;
wgts = 1- exp(wgts);
tmpw = 0.75;
wgts = tmpw * (2 * wgts - 1);
wgts = 1+(exp(2*wgts)-1)./(exp(2*wgts)+1);
wgts = wgts / (1+(exp(-2*tmpw)-1)./(exp(-2*tmpw)+1));

tmp1 = 0.2*min(abs([min(X) max(X)]));
tmp2 = 0.2*min(abs([min(Y) max(Y)]));
S = round(min(S)*50)/100;
P = -1*round(mean(P)*100)/100;
os = P;
warning on
return;
