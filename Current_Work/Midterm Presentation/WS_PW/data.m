f1='name'; v1={'Beechcraft 1900';'Fairchild Metroliner Metro III';...
    'Dornier Do 228';'Short SC7 Skyvan';'DHC-6 Twin Otter';...
    'Let L-410 Turbolet'};
f2='P_W'; v2={0.06752336449
0.071875
0.07903780069
0.092
0.09248
0.1048901488};

f3='W_S'; v3={55.22580645;51.61290323;42.29651163;33.06878307;29.76190476;...
    37.60660981};

f4='weight'; v4={17120
16000
14550
12500
12500
14110};

f5='range'; v5={578
1080
715
243
100
378};

dd=struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5);

dd(end+1).name='Partior';
dd(end).P_W=0.06935832;
dd(end).W_S=60.0745;
dd(end).weight=1.4418e+04;
dd(end).range=1221.3;