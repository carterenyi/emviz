function contcom = CT_makeContCom(ps,deg1,deg2)
%adapted for asyncrhony, deg1 input can be an adjacency radius,
%if deg2 is present, deg1 is before, and deg2 is after

if nargin==2
    deg2=deg1;
end
degrees=deg1+deg2;

contcom=nan(degrees,numel(ps));
for n=1:numel(ps)
    for i=1:deg1
        try
            if ps(n) > ps(n-i)
                contcom(deg1+1-i,n)=1;
            else
                contcom(deg1+1-i,n)=0;
            end
        catch %value will be nan
        end
        
    end
    for i=1:deg2
        try
            if ps(n) > ps(n+i)
                contcom(deg1+i,n)=1;
            else
                contcom(deg1+i,n)=0;
            end
        catch %value will be nan
        end
    end
end

end

