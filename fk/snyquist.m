function [snyq]=snyquist(d,f)
%SNYQUIST    Returns the nyquist slowness for an array
%
%    Usage:    Snyq=snyquist(d,f)
%
%    Description: Snyq=SNYQUIST(D,F) returns the nyquist slowness
%     corresponding to an array with station spacing D and at frequency F.
%     D must be in kilometers.  F is expected in Hz.  Snyq will be in
%     s/deg.  D & F must be scalar or equal sized.
%
%    Notes:
%
%    Examples:
%     How to get measures of your array's station spacing?  The Matlab
%     function DELAUNAY can be used to find a stations nearest neighbors:
%      [stla,stlo]=getheader(data,'stla','stlo');
%      [clat,clon]=arraycenter(stla,stlo);
%      [e,n]=geographic2enu(stla,stlo,0,clat,clon,0);
%      tri=delaunay(e,n);
%      friends=[tri(:,1:2); tri(:,2:3); tri(:,[3 1])];
%      friends=unique([min(friends,[],2) max(friends,[],2)],'rows');
%      dist=vincentyinv(stla(friends(:,1)),stlo(friends(:,1)),...
%                       stla(friends(:,2)),stlo(friends(:,2)));
%      [n,x]=hist(dist,30); % 30 equal station spacing bins
%     
%     Now there are several measures of station spacing (for an irregular
%     array the best spacing measure for Snyq is not straight forward and
%     is often easier to empirically determine from looking at array
%     response functions with FKARF):
%      closest=min(dist);    % closest 2 stations
%      average=median(dist); % robust average station spacing
%      usual=x(n==max(n));      % most frequent binned station spacing
%
%     Once you have your typical station spacing, decide your frequency
%     bands of interest.  Then the nyquist slowness is straightforward.
%     Here we have a typical spacing of 50km and are interested in
%     frequencies at 0.04, 0.05, 0.067, 0.1, & 0.2Hz:
%      Snyq=snyquist(50,[0.04 0.05 0.067 0.1 0.2])
%
%    See also: KXY2SLOWBAZ, SLOWBAZ2KXY, FKARF, DELAUNAY

%     Version History:
%        May   3, 2010 - initial version
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated May   3, 2010 at 20:35 GMT

% todo:

% check nargin
msg=nargchk(2,2,nargin);
if(~isempty(msg)); error(msg); end

% check inputs
if(~isreal(d) || any(d<=0))
    error('seizmo:snyquist:badInput',...
        'D must be positive real in kilometers!');
elseif(~isreal(f) || any(f<=0))
    error('seizmo:snyquist:badInput',...
        'F must be positive real in Hz!');
elseif(~isequalsizeorscalar(d,f))
    error('seizmo:snyquist:badInput',...
        'D & F must be equal sized or scalar!');
end

% get slowness nyquist
knyq=1./(2*d); % units of 1/km or waves/km
snyq=knyq./f*(6371*pi/180); % units of s/deg

end
