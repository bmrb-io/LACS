function offset = ordN(filename, x, out_name)
% Check referencing offset for N and NH

offset = -100;

tmp = load(filename);
if size(tmp, 1)<20, return; end
pH = tmp(1, end);
%load paper/offset/data/procorr.txt
procorr = [
%      #      CA	    CB        HA        CO       NH     N      CA-CB	AA
    1.0000    2.0000    1.0000   -0.3000    1.9000   0.05  -1.2
    2.0000    1.8000    0.9000   -0.2600    1.6000   0.02  -1.1
    3.0000    2.0000    0.2000   -0.2900    1.3000   0.03  -1.0
    4.0000    2.4000    0.7000   -0.2800    1.7000   0.08  -1.5
    5.0000    2.1000    0.5000   -0.2700    1.4000   0.17  -0.6
    6.0000    0.6000    0        -0.1700    0.4000   0.12  -0.3
    7.0000    1.7000         0   -0.3000    1.5000   0.05  -0.0
    8.0000    2.4000    0.1000   -0.2800    1.4000  -0.06  -1.8 
    9.0000    2.0000    0.5000   -0.2900    1.8000   0.11  -1.2
   10.0000    2.0000    0.7000   -0.3400    1.9000   0.02  -0.8
   11.0000    2.1000    0.5000   -0.2600    1.7000   0.03  -1.1
   12.0000    1.8000    0.2000   -0.3100    1.6000   0.03  -0.3
   13.0000    1.8000    1.2000   -0.3100    5.9000   0      0
   14.0000    2.0000    0.6000   -0.3100    1.6000   0.03  -0.8
   15.0000    2.0000    0.7000   -0.3100    1.8000   0.03  -0.8
   16.0000    1.9000    0.5000   -0.3100    1.5000   0.05  -0.9
   17.0000    2.0000         0   -0.2600    1.5000   0.00  -2.4
   18.0000    2.4000    0.3000   -0.3200    1.4000   0.01  -1.3
   19.0000    1.8000    0.7000   -0.3300    1.3000   0.16  -0.9
   20.0000    2.1000    0.5000   -0.2900    1.1000   0.02  -0.5
];

Ncorr = [       %pH5
    1     0.0   0.00
    2     3.5   0.17
    3     1.6   0.04
    4     2.0   0.10
    5     3.2   0.04
    6     0.8  -0.04 
    7     2.6   0.13
    8     5.0   0.13
    9     2.4   0.08
    10    1.8   0.02
    11    1.9   0.06
    12    1.5   0.04
    13    1.2   0.16
    14    2.1   0.10
    15    2.2   0.10
    16    2.7   0.08
    17    3.2   0.09
    18    4.7   0.14
    19    3.6  -0.08
    20    3.6   0.01
];
Ncorr(:, 2) = Ncorr(:, 2) - 1.486;
Ncorr(:, 3) = Ncorr(:, 3) - 0.005;

% correct Pro following
aas = tmp(:, 2);
pros = find(aas == 13); if length(pros)>0 & pros(1)==1, pros(1) = []; end
for k = 1 : length(pros)
    tmpaa = tmp(pros(k)-1, 2);
    tmpnon = find(tmp(pros(k)-1, :)==-100);
    procr = procorr(find(procorr(:, 1)==tmpaa), :);
    if length(procr)>0 & tmp(pros(k)-1, 1) + 1 == tmp(pros(k), 1)
        tmp(pros(k)-1, :);
        tmp(pros(k)-1, 3:8) = tmp(pros(k)-1, 3:8) + procr(2:7);
        tmp(pros(k)-1, tmpnon) = -100;
    end
end

tmp(find(tmp(:, 2)<1), :) = [];
tmp = [tmp(:, 1:4) tmp(:, x+1)];

% correct residue
refCACACB = [
% Reference to J. Bio. NMR 1995.5 67-81
% 	CA	    CB       HA    CO     NH    N      CA-CB	AA   CA   CB   HA CO NH N 
%
1	52.5	19.1     4.32  177.8  8.24  123.8  33.6	52.8 19.3 4.35 178.5 8.35 125.0%Ala 
2   58.2    28.0     4.55  174.6  8.32  118.8  30.2 58.6 28.3 4.59 175.3 8.44 118.8%Cys (reduced)
3	54.2	41.1	 4.64  176.3  8.34  120.4  13.3	53.0 38.3 4.82 175.9 8.56 119.1%Asp 
4	56.6	29.9	 4.35  176.6  8.42  120.2  26.6	56.1 29.9 4.42 176.8 8.40 120.2%Glu 
5	57.7	39.6	 4.62  175.8  8.30  120.3  18.4 58.1 39.8 4.65 176.6 8.31 120.7%Phe 
6   45.1    0        3.96  174.9  8.33  108.8  45.1 45.4 0    4.02 174.9 8.41 107.5
7	55.0	29.0	 4.73  174.1  8.42  118.2  26.1	55.4 29.1 4.79 175.1 8.56 118.1%His 
8	61.1	38.8	 4.17  176.4  8.00  119.9  22.4	61.6 38.9 4.21 177.1 8.17 120.4%Ile 
9	56.2	33.1	 4.32  176.6  8.29  120.4  23.4	56.7 33.2 4.36 177.4 8.36 121.6%Lys 
10	55.1	42.4	 4.34  177.6  8.16  121.8  13.0	55.5 42.5 4.38 178.2 8.28 122.4%Leu 
11	55.4	32.9	 4.48  176.3  8.28  119.6  23.0	55.8 32.9 4.52 177.1 8.42 120.3%Met 
12	53.1	38.9	 4.74  175.2  8.40  118.7  14.5	53.3 39.1 4.79 176.1 8.51 119.0%Asn 
13	63.3	32.1	 4.42  177.3  0.00  0.00   31.1	63.7 32.2 4.45 177.8 0    0%Pro 
14	55.7	29.4	 4.34  176.0  8.32  119.8  26.6	56.2 29.5 4.38 176.8 8.44 120.5%Gln 
15	56.0	30.9	 4.34  176.3  8.23  120.5  25.5	56.5 30.9 4.38 177.1 8.39 121.2%Arg 
16	58.3	63.8	 4.47  174.6  8.31  115.7  -5.2	58.7 64.1 4.51 175.4 8.43 115.5%Ser 
17	61.8	69.8	 4.35  174.7  8.15  113.6  -8.0	62.0 70.0 4.43 175.6 8.25 112.0%Thr 
18	62.2	32.9	 4.12  176.3  8.03  119.2  29.4	62.6 31.8 4.16 177.0 8.16 119.3%Val 
19	57.5	29.6	 4.66  176.1  8.25  121.3  27.4	57.6 29.8 4.70 177.1 8.22 122.1%Trp 
20	57.9	38.8	 4.55  175.9  8.12  120.3  19.3	58.3 38.9 4.58 176.7 8.26 120.9%Tyr   
];

if pH < 4
    refCACACB(:, 2:7) = refCACACB(:, 9:14);
    refCACACB(:, 8) = refCACACB(:, 2) - refCACACB(:, 3);
end
refCACACB(:, 9:14) = [];

% correct preceding effect on N
m = size(tmp, 1);
NCor = [tmp(1, 1) 0];
for i = 2 : m
    temp = find(Ncorr(:, 1)==tmp(i-1, 2) & tmp(i-1, 1)+1==tmp(i, 1));
    if length(temp) > 0
        NCor = [NCor; tmp(i, 1) Ncorr(temp, 9-x)];
    end
end
temp = [];
for i = 2 : m    
    tt0 = find(refCACACB(:, 1)==tmp(i-1, 2));
    tt = find(refCACACB(:, 1)==tmp(i, 2)); 
    if length(tt)>0 & length(tt0)>0 & tmp(i, 2)~=13
        tx = tmp(i-1, 3)-tmp(i-1, 4) - refCACACB(tt0, 8);
        ty = tmp(i, 5)-refCACACB(tt, x);
        NC = find(NCor(:, 1)==tmp(i, 1));
        if length(NC)>0 & abs(tx)<=10 & min(tmp(i-1, 3:4)) > -90 & tmp(i, 5) > -90 & min(abs([6 7] - tmp(i-1, 2))) > 0 & tmp(i-1, 1)+1==tmp(i, 1)
            temp = [temp; tx ty - NCor(NC, 2) ty tmp(i,1:2)];
        end
    end
end

if size(temp, 1) > 20
    offset = findoffset(temp, x+1, out_name, pH);
else
    offset = -100;
end
return;

function offset = findoffset(tmp, xi, out_name, pH)

oss = [];
xd = []; nX = size(tmp, 1);
while 1
    X = tmp(:, 1); Y = tmp(:, 2);
    ds = mahal([X Y], [X Y]);
    [YY II] = sort(ds);
    cf = find(YY>0.99*max(YY));
    xd = [xd; tmp(II(cf(1):end), :)];
    tmp(II(cf(1):end), :) = [];
    if size(xd, 1)> 0.02*nX, break; end
end
lastwarn('');

while 1    
    [B stats] = robustfit(tmp(:, 1), tmp(:, 2));
    w = stats.w;
    [x i] = min(w);
    if x < 0.2
        xd = [xd; tmp(i, :)];
        tmp(i, :) = [];
    else
        break;
    end
end

ec = length(find(tmp(:, 1)<-2));
hc = length(find(tmp(:, 1)>2));
slen = size(tmp, 1);
opts = optimset('Display','off');
if xi == 8
    if abs(B(2)+0.4) > 0.1 & (min(ec, hc) < 0.15 * slen | slen < 66)
        X0 = [0   -0.4];
        LB = [-10 -0.45];
        UB = [ 10 -0.35];
        [x,RESNORM,RESIDUAL,EXITFLAG] = lsqcurvefit(@myLine, X0, X, Y, LB, UB, opts);
        B = x;
    end
else
    if abs(B(2)+0.07) > 0.02 & (min(ec, hc) < 0.15 * slen | slen < 66)
        X0 = [0   -0.07];
        LB = [-10 -0.08];
        UB = [ 10 -0.06];
        [x,RESNORM,RESIDUAL,EXITFLAG] = lsqcurvefit(@myLine, X0, X, Y, LB, UB, opts);
        B = x;
    end
end

ss = 'CACBHACOHNNH';
AA = 'ACDEFGHIKLMNPQRSTVWY';

if length(tmp) > 20
    x = xi;
    if ~strcmp( out_name, 'stdout' )
	fid = fopen(out_name, 'a'); 
    end

    for  i = 1 : size(xd, 1)
        dx = 0.2;
        
        if strcmp( out_name, 'stdout' )
	    fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', xd(i, 4),  AAtable(AA(xd(i, 5)) ),...
        	'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), xd(i, 1), xd(i, 2), 0);
	else
	    fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', xd(i, 4),  AAtable(AA(xd(i, 5)) ),...
        	'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), xd(i, 1), xd(i, 2), 0);
	end
        %h = text(Xo(i)+dx, Yo(i), strcat(num2str(Lso(i, 1)), AA(Lso(i, 2)))); set(h, 'FontSize', 16);
    end
    for i = 1 : size(tmp, 1)
        if strcmp( out_name, 'stdout' )
	    fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', tmp(i, 4), AAtable(AA(tmp(i, 5))), ...
    		'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), tmp(i, 1), tmp(i, 2), 1);
	else
	    fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', tmp(i, 4), AAtable(AA(tmp(i, 5))), ...
    		'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), tmp(i, 1), tmp(i, 2), 1);
    	end
    end

    x1 = [min(tmp(:, 1)):.01:2]; y1 = B(2)*x1+B(1);
    if strcmp( out_name, 'stdout' )
	fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(1), y1(1), 2);
        fprintf( '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(end), y1(end), 2);
    else
        fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(1), y1(1), 2);
	fprintf(fid, '  %4d %s  %s  %s  %5.2f   %5.2f   %d\n', 0,  'XXX', 'CA-CB', ss(2*(x-3)+1:2*(x-3)+2), x1(end), y1(end), 2);
    end

    if ~strcmp( out_name, 'stdout' )
	fclose(fid);
    end
end

xx = min(tmp(:, 1))-1 : .1 : max(tmp(:, 1)+1);

offset = -1*B(1);
if xi==8
    offset = offset - 0.465;
else
    offset = offset - 0.049;
end
offset = round(offset*100)/100;
return;

function F = myLine(x,xdata)
F = x(2)*xdata+x(1);
return;
