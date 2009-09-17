function [value]=vf_gh_ztai(def,head)
%VF_GH_ZTAI    Returns value for virtual field ZTAI

% get reference time
tmp=head(h.reftime,:);

% who's  (un)defined
nv=size(head,2);
bad=logical(sum(isnan(tmp) | isinf(tmp) | tmp==def.undef.ntype) ...
    | tmp~=round(tmp) | [false(1,nv); (tmp(2,:)<1 | tmp(2,:)>366); ...
    (tmp(3,:)<0 | tmp(3,:)>23); (tmp(4,:)<0 | tmp(4,:)>59); ...
    (tmp(5,:)<0 | tmp(5,:)>60); (tmp(6,:)<0 | tmp(6,:)>999)]);
good=~bad;

% default [yr jday hr mn secs] all undef
value(nv,5)=def.undef.ntype;

if(any(good))
    % yr, jday, hr, min already known
    value(good,1:4)=tmp(1:4,good).';
    
    % get secs
    value(good,5)=(tmp(5,good)+tmp(6,good)/1000).';
    
    % convert to tai
    value(good,:)=utc2tai(value(good,:));
end

% wrap in cell
value=mat2cell(value,ones(nv,1));

end