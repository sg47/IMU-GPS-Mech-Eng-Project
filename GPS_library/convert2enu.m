function [enu_result]  =  convert2enu(gps_result, gps_first_result)

% The default reference ellipsoid is a unit sphere. Instead, try using a
% wgs84 earth model and you will get a result much 
% closer to what you were expecting.

referenceEllipsoid = wgs84Ellipsoid;

[x, y, z] = geodetic2enu(gps_result.latitude, gps_result.longitude, ...
    gps_result.altitude, gps_first_result.latitude, ...
    gps_first_result.longitude, gps_first_result.altitude, referenceEllipsoid);
    

enu_result = gps_result;
enu_result.x = x;
enu_result.y = y;
enu_result.z = z;