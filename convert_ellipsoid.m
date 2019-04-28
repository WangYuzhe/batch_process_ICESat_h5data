function [phi2, h2] = convert_ellipsoid(a1, b1, phi1, h1, a2, b2)
% Inputs:
%    a1 - equatorial radius in meters of ellipsoid 1.
%    b1 - polar radius in meters of ellipsoid 1.
%    phi1 - ellipsoid 1 latitude in degrees.
%    a2 - equatorial radius in meters of ellipsoid 2.
%    b2 - polar radius in meters of ellipsoid 2.
%    h1 - ellipsoid 1 elevation in meters.
% Outputs:
%    phi2 - double precision ellipsoid 2 latitude in degrees.
%    h2 - double precision ellipsoid 2 elevation in meters.

% note
% atop = 6378136.300000;
% btop = 6356751.600563;
% awgs = 6378137.000000;
% bwgs = 6356752.314245;

dist = 0.0;
itmax = 30;
eps = 1e-12;

% Initialize double precision constant (dtor) for converting degrees to radians.
dtor = pi/180;
phi1r = phi1 * dtor;
sinphi1 = sin(phi1r);
cosphi1 = cos(phi1r);

% prevent division by very small numbers
if cosphi1 < eps
    cosphi1 = eps;
end
tanphi1 = sinphi1/cosphi1;

u1 = atan(b1/a1*tanphi1);

hpr1sin = b1 * sin(u1) + h1 * sinphi1;
hpr1cos = a1 * cos(u1) + h1 * cosphi1;

% set intial value for u2
u2 = u1;

% Decide which path we will take
if abs(phi1) <= 45
    % setup some constants
    k0 = b2 * b2 - a2 * a2;
    k1 = a2 * hpr1cos;
    k2 = b2 * hpr1sin;
    
    % perform newton-raphson iteration to solve for u2
    % cos(u2) will not be close to zero since abs(phi1) le 45
    for i = 1:itmax
        u2old = u2;
        cosu2 = cos(u2);
        fu2 = k0 * sin(u2) + k1 * tan(u2) - k2;
        fu2p = k0 * cosu2 + k1 / (cosu2 * cosu2);
        if abs(fu2p) < eps
            break % i = itmax;
        else
            delta = fu2 / fu2p;
            u2 = u2old - delta;
            if abs(delta) < eps
                break % i = itmax;
            end
        end
    end
    % Calculate phi2 and u2 outputs
    
    phi2r = atan(a2 / b2 * tan(u2));
    phi2 = phi2r / dtor;
    
    h2 = (hpr1cos - a2 * cos(u2)) / cos(phi2r);
else
    % setup some constants
    k0 = a2 * a2 - b2 * b2;
    k1 = b2 * hpr1sin;
    k2 = a2 * hpr1cos;
    
    % perform newton-raphson iteration to solve for u2
    % sin(u2) will not be close to zero since abs(phi1) gt 45
    for i = 1:itmax
        u2old = u2;
        sinu2 = sin(u2);
        fu2 = k0 * cos(u2) + k1 / tan(u2) - k2;
        fu2p =  -1 * (k0 * sinu2 + k1 / (sinu2 * sinu2));
        if abs(fu2p) < eps
            break % i = itmax;
        else
            delta = fu2 / fu2p;
            u2 = u2old - delta;
            if abs(delta) < eps
                break % i = itmax;
            end
        end
    end
    
    % Calculate phi2 and u2 outputs
    phi2r = atan(a2 / b2 * tan(u2));
    phi2 = phi2r / dtor;
    h2 = (hpr1sin - b2 * sin(u2)) / sin(phi2r);
end

% Perform distance measurement
% Calculate flattenings f1 and f2
f1 = 1 - b1 / a1;
f2 = 1 - b2 / a2;

% Determine an "average" ellipsoid
a_avg = (a1 + a2) / 2;
f_avg = (f1 + f2) / 2;

% Perform the distance measurement (see ALGORITHM above)
F = (phi2r + phi1r) / 2;
sinF = sin(F);
cosF = cos(F);
G = (phi2r - phi1r) / 2;

% Check for very small distance
if abs(G) < eps
    dist = 0.0;
else
    sinG = sin(G);
    sinsqG = sinG * sinG;
    cosG = cos(G);
    cossqG = cosG * cosG;
    omega = atan(sinG / cosG);
    R = sinG * cosG / omega;
    D = 2 * omega * a_avg;
    HH1 = (3 * R - 1) / (2 * cossqG);
    HH2 = (3 * R + 1) / (2 * sinsqG);
    dist = D * (1 + f_avg * HH1 * sinF * sinF * cossqG -...
        f_avg * HH2 * cosF * cosF * sinsqG);
end

end