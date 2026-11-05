clear

% Input Prameters

G = 6.67e-11;           % Gravatational Constant
M = 5.97e24;            % Mass of planet
rM = 6.38e6;            % Radius of Mass
u = M*G;                % Gravatiaonal pramerter of the mass

% Inputs Orbit data

e = 0.8;                % Ecintricity
rp = 100e3;             % Distance Orbit at pereaposis
rop = rM + rp;          % Radius Orbit + Planet radius
w = 90;                % Argument of perapsis
Omega = 90;            % Right accension
dec = 0;                % Declination
i = 30;                 % Inclination



h = sqrt(rop*(1+e));            % Angular momentum
a = rop/(1-e);                  % Semi-major axis
tou = ((2*pi)*(sqrt((a^3)/u))); % Tine period of orbit

T = tou;
t = tou/60;


if e < 1
    teta = 0: 1: 360;

    r = (a*(1-e^2))./(1+e*cosd(teta));

elseif e == 1
       teta = -90: 1: 90;

    r = (2*rop)./(1+e*cosd(teta));

elseif e > 1
    teta = -90: 1: 90;

    r = (a*(1-e^2))./(1+e*cosd(teta));

end 

E = acosd(((r./a)+1)/e); 
vr = sqrt(u./r);

figure;

x = (cosd(Omega)*cosd(teta + w)-sind(Omega)*cosd(i)*sind(teta + w)).*r;
y = (sind(Omega)*cosd(teta + w)+cosd(Omega)*cosd(i)*sind(teta + w)).*r;
z = (sind(i)*sind(teta + w)).*r;

[Xm1, Ym1, Zm1] = sphere(10);
Xm2 = Xm1*rM;
Ym2 = Ym1*rM;
Zm2 = Zm1*rM;


PM = surf(Xm2,Ym2,Zm2); grid;
set(PM, 'edgecolor','black')
set(PM, 'facecolor','green')
hold on
PO = plot3(x,y,z); grid;
hold on
Mr = 1.5*rM;

Axisx = quiver3(1,0,0,Mr,0,0,'b');
hold on 
Axisy = quiver3(0,1,0,0,Mr,0,'b');
hold on
AxisZ = quiver3(0,0,1,0,0,Mr,'b');
hold on
az = 50;
el = 45;
view(az, el);


for l = 1:2
    for st = 1:90

        if e < 1

            tetast = st*4 - 4;
            povalue = st*4 - 3;

            tetale = tetast + 4;

            %if tetale > 360 
            %tetale = 1;
            %end

        elseif e == 1
            tetast = st*2 + 269;
            povalue = st*2;

        elseif e > 1    

            tetast = st*2 +269;
            povalue = st*2;
            tetale = tetast + 4;

            if tetast > 360 
            tetast = tetast-360;
            end
        end

    xt = (cosd(Omega)*cosd(tetast + w) - sind(Omega)*cosd(i)*sind(tetast + w)).*r;
    yt = (sind(Omega)*cosd(tetast + w) + cosd(Omega)*cosd(i)*sind(tetast + w)).*r;
    zt = (sind(i)*sind(tetast + w)).*r;

    xn = abs((cosd(Omega) - sind(Omega)*cosd(i)).*r);
    yn = abs((sind(Omega) + cosd(Omega)*cosd(i)).*r);
    zn = abs((sind(i)).*r);


    %xt1 = (cosd(Omega)*cosd(tetale + w)-sind(Omega)*cosd(i)*sind(tetale + w)).*r;
    %yt1 = (sind(Omega)*cosd(tetale + w)+cosd(Omega)*cosd(i)*sind(tetale + w)).*r;
    %zt1 = (sind(i)*sind(tetale + w)).*r;

    %xp = (cosd(Omega)*cosd(tetast + w)-sind(Omega)*cosd(i)*sind(tetast + w)).*r;
    %yp = (sind(Omega)*cosd(tetast + w)+cosd(Omega)*cosd(i)*sind(tetast + w)).*r;
    %zp = (sind(i)*sind(tetast + w)).*r;


    Vxt = ((xn(1,tetale))*vr);
    Vyt = ((yn(1,tetast))*vr);
    Vzt = ((zn(1,tetale))*vr);

    [Xs1, Ys1, Zs1] = sphere(10);
    Rs = 0.1*rM;
    Xs2 = Xs1*Rs;
    Ys2 = Ys1*Rs;
    Zs2 = Zs1*Rs;

    PS = surf(Xs2+xt(1,povalue),Ys2+yt(1,povalue),Zs2+zt(1,povalue));
    
    set(PS, 'edgecolor','none')
    set(PS, 'facecolor','red')
    hold on 
    
    %Arrow = quiver3(xt(1,povalue),yt(1,povalue),zt(1,povalue),Vxt,Vyt,Vzt,'red');
    
    drawnow
    pause(0.05);
    %delete(PS);
    %delete(Arrow);

    % position vector dot product the normal to plane vector by the modulas
    % of velocity
    
    end
end