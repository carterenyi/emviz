function [r,nmat,nmatFound,CL]=searchAndPlotPolyOrMono(filename,title,type,cmin,in,rselect,stringNames)


nmat=midi2nmat(filename);

if nargin == 1
    title=filename;
end

nmatold=nmat;
chans=unique(nmat(:,3));
numchans=numel(chans);
allchans=[];
for z=1:numchans
    ind= nmat(:,3)==chans(z);
    chanmat{z}=nmat(ind,:);
    if z > 1
        chanmat{z}(:,1)=chanmat{z}(:,1)+round(allchans(end,1));
        chanmat{z}(:,6)=chanmat{z}(:,6)+round(allchans(end,6));
    end
    allchans=vertcat(allchans,chanmat{z});
end
nmatFound=allchans;

if nargin >= 5
[r,CL]=searchAndRank(nmatFound,type,cmin,in)
else
    [r,CL]=searchAndRank(nmatFound,type,cmin)
end

nmat=nmatold;

if nargin == 6
    r=arcPlot(r,nmat,nmatFound,title,0,rselect);
elseif nargin == 7
r=arcPlot(r,nmat,nmatFound,title,0,rselect,stringNames);
else
r=arcPlot(r,nmat,nmatFound,title,0);
end

end