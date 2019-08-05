function distance =GPSDistance(lat1_deg,long1_deg,lat2_deg,long2_deg)
% given latitude and longidude of two points return distance between them.
%
% From: http://ccv.eng.wayne.edu/m_script.html
%
  R=6.371*10^6;  %earth radius
  lat1_=lat1_deg*pi/180; %convert degrees into radians
  lat2_=lat2_deg*pi/180;
  long1_=long1_deg*pi/180;
  long2_=long2_deg*pi/180;
  distance=R*sqrt(2-2*cos(lat1_)*cos(lat2_)*cos(long1_-long2_)-2*sin(lat1_)*sin(lat2_));
end
