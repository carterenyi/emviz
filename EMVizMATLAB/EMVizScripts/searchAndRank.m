function [r,CL]=searchAndRank(nmat,type,cmin,in)

%INPUTS
%'nmat' is note matrix output from midi2nmat, this should be monophonic
%with only one voice, if it is polyphonic poly2mono should be used first
%'type' determines that type of search: '1' is pitches only; '2' is durations
%only and '3' is pitches and durations
%'cmin' is minimum cardinality for patterns, the algorithm will not search
%for strings short than this number, a good minimum is five events
%'in' is a structure for various search parameters see 'if nargin==4... below'

%CAUTION:
%1. this is only for monophonic pieces (if it is polyphonic run poly2mono
%first)
%2. does not work with human playback settings
%(turn off in Finale or Sibelius before exporting a MIDI)

%% Search Parameters from 'in'
if nargin==4 % number of arguments into the function
    try
        degrees=in.degrees; % degrees determines how big the contour reduction window is
    catch
        degrees=2; % the standard is 2
    end

    try
        cmax=in.cmax; % cardinality maximum sets the max string length
    catch
        cmax=50; % typically no strings longer than 50 are found anyway
    end
    

    
    try
        usetime=in.usetime;
    catch
        usetime=0;
    end

    
else %if there is no 'in' (i.e. nargin==3) these are default search parameters
    degrees=2;
    cmax=50;
    usetime=0; %consider time when calculating coverage
    %useDCL=0; % this is now separate input argument
end




rawnmat=nmat;


pitches=nmat(:,4); 
pitches=pitches';
contcom=CT_makeContCom(pitches,degrees);
CL=nansum(contcom);
%CL=sum(contcom);


durs=nmat(:,6);
durs=durs(2:end)-durs(1:end-1);
durs(end+1)=nmat(end,7);
contcom=CT_makeContCom(durs,degrees);
DCL=nansum(contcom);
%DCL=sum(contcom);

if type==1
    CL=[CL;CL];
elseif type ==2
    CL=[DCL;DCL];
elseif type ==3
    CL=[CL;DCL];
end

for n=cmin:cmax
    clearvars segments segmentu segmentucount segmentuind temp
    for i=1:numel(pitches)-n+1
        segments{i}=CL(:,i:i+n-1);
        %         for j=1:degrees
        %             try
        %                 segments{i}(1:degrees+1-j,j)=-1;
        %                 segments{i}(degrees+j:end,end+1-j)=-1;
        %             catch
        %             end
        %         end
    end
    
    
    [segmentu, idx ,idx2] = uniquecell(segments);
    %check to see if card saturation reached
    if numel(segmentu)==numel(segments)
        break
    end
    
    
    segmentucount=zeros(numel(segmentu),1);
    for i=1:length(segmentu)
        ind=find(idx2==i);
        segmentuind{i}=ind;
        segmentucount(i)=numel(ind);
        %         numel(pitches)
        %         segmentuind{i}(1)-2
        %         segmentuind{i}(1)+n-1+2
        try
            segmentpitch{i}=pitches(segmentuind{i}(1)-2:segmentuind{i}(1)+n-1+2);
        catch
            try
                segmentpitch{i}=pitches(segmentuind{i}(2)-2:segmentuind{i}(2)+n-1+2);
            catch
                segmentpitch{i}=[];
            end
        end
        %segmentdurs{i}=durs(segmentuind{i}(1):segmentuind{i}(1)+n-1);
    end
    %inversions
    [segmentucount, SortInd]=sort(segmentucount,'descend');
    segmentu=segmentu(SortInd);
    numel(segmentu)
    numel(segmentuind)
    segmentuind=segmentuind(SortInd);
    segmentpitch=segmentpitch(SortInd);
    %segmentdurs=segmentdurs(SortInd);
    idx=idx(SortInd);
    
    for i=1:5
        try
            inv=-segmentpitch{i}+max(segmentpitch{i});
        catch
            break
        end
        invercom=CT_makeContCom(inv,degrees);
        invCL=nansum(invercom);
        if isempty(invCL)==1
            break
        end
        try
            invCL=[invCL(3:end-2);segmentu{i}(2,:)];
        catch
            break
        end
        segmentuinvind{i}=[];
        for j=i+1:numel(segmentucount)
            if segmentucount(j)==0
                continue
            end
            size(invCL)
            size(segmentu{j})
            if segmentu{j}==invCL
                hmm=0;
                segmentucount(i)=segmentucount(i)+segmentucount(j);
                segmentuinvind{i}=[segmentuinvind{i},segmentuind{j}];
                segmentucount(j)=0;
                segmentu{j}=[];
                segmentuind{j}=[];
                segmentupitch{j}=[];
            end
        end
    end
    
    
    %     temp=find(segmentucount==1)
    %     temp2=find(segmentucount==0);
    %     temp=[temp',temp2'];
    segmentu(6:end)=[];
    segmentuind(6:end)=[];
    segmentucount(6:end)=[];
    for i=1:numel(segmentu)
        segmentucov(i)=segmentucount(i)*n;
    end
    
    %     [segmentucount, SortInd]=sort(segmentucount,'descend');
    %     segmentu=segmentu(SortInd);
    %     segmentuind=segmentuind(SortInd);
    %     idx=idx(SortInd);
    p(n).segments=segments;
    p(n).seg=segmentu;
    p(n).segcount=segmentucount;
    p(n).segind=segmentuind;
    p(n).segcov=segmentucov;
    try
        p(n).seginvind=segmentuinvind;
    catch
    end
end


%% create r

allcov=0;
r(1).seg=p(cmin).seg{1};
r(1).segcount=p(cmin).segcount(1);
r(1).segind=p(cmin).segind{1};
r(1).cov=p(cmin).segcov(1);
try
    r(1).invind=p(n).seginvind{1};
catch
    r(1).invind=[];
end
for i=1:numel(p)
    for j=1:numel(p(i).seg)
        allcov(end+1)=p(i).segcov(j);
        r(end+1).card=i;
        r(end).seg=p(i).seg{j};
        r(end).segcount=p(i).segcount(j);
        r(end).segind=p(i).segind{j};
        r(end).cov=p(i).segcov(j);
        try
            r(end).invind=p(i).seginvind{j};
        catch
            r(end).invind=[];
        end
    end
end
r(1)=[];
allcov(1)=[];
[allcov, SortInd]=sort(allcov,'descend');
r=r(SortInd);

for i=1:numel(r)
    clearvars temp
    temp=[];
    for j=1:numel(r(i).segind)
        temp=[temp,r(i).segind(j):r(i).segind(j)+r(i).card-1];
    end
    for j=1:numel(r(i).invind)
        temp=[temp,r(i).invind(j):r(i).invind(j)+r(i).card-1];
    end
    r(i).inds=temp;
end
rold=r;

for i=numel(r):-1:1
    for j=1:i-1
        i
        a=r(i).inds;
        b=r(j).inds;
        c=intersect(a,b)
        if numel(a)==numel(c)
            r(i)=[]
            break
        end
    end
end


for i=numel(r):-1:1
    for j=1:i-1
        i;
        a=r(i).inds;
        b=r(j).inds;
        c=intersect(a,b);
        if .8*numel(a)<numel(c)
            r(j).inds=unique([r(j).inds,r(i).inds]);
            %                 try
            %                 r(j).sub(end+1)=r(i);
            %                 catch
            %                  r(j).sub(1)=r(i);
            %                 end
            r(i)=[];
            break
        end
    end
end

allcov=[];
for i=1:numel(r)
    allcov(end+1)=numel(r(i).inds);
end
[allcov, SortInd]=sort(allcov,'descend');
r=r(SortInd);

[l,~]=size(nmat);
% badinds=[1,2]
% badends=[l-1,l]
for i =1:numel(r)
    segends=r(i).segind+r(i).card-1;
    if sum(r(i).seg(1:2,1:2))~=0
    if ismember(1,r(i).segind)==0
        if ismember(2,r(i).segind)==0
            r(i).segind=r(i).segind-2
            r(i).invind=r(i).invind-2
            r(i).card=r(i).card+2;
        elseif ismember(2,r(i).segind)==1
            r(i).segind=r(i).segind-1
            r(i).invind=r(i).invind-1
            r(i).card=r(i).card+1;
        end
    end
    end
    
    if sum(r(i).seg(1:2,end-1:end))~=0
    if ismember(l,segends)==0
        if ismember(l-1,segends)==0
            r(i).card=r(i).card+2;
        elseif ismember(l-1,segends)==1
            r(i).card=r(i).card+1;
        end
    end
    end
    r(i).cov=r(i).card*r(i).segcount;
    %segSort=sort(r(i).segind);
    %r(i).segind=segSort;
end

nr=numel(r);
for i = nr:-1:1
    b=r(i).inds;
    for j=1:i-1
        a=r(j).inds;
        if all(ismember(b,a))==1
            r(i)=[];
            break
        end
    end
    
end

end

