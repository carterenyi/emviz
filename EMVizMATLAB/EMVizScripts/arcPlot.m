function r=arcPlot(r,nmat,nmatFound,plotTitle,sortYN,rselect,stringNames)
%% 1. Run findPattern first
%% 2. arc of similarity
%% if no time input is specified, it is animated
%data needed:
%nmat
%nmatRCE
%r (output of CT)
%with ind or segind
%and simind

if nargin==1
    nmat=r.nmat;
    nmatFound=r.nmatFound;
    r=r.r;
    plotTitle='Arc Diagram of MIDI file';
    sortYN=0;
end

%see if nargin = 6 below


chans=unique(nmatFound(:,3));
if numel(chans) > 1
    nmatFound=nmatMono2poly(nmat,nmatFound);
end

%clear non-recursive strings
for i=numel(r):-1:1
    try
        if numel(r(i).segind)==1 && numel(r(i).invind)==0
            r(i)=[];
        end
    catch
        if numel(r(i).ind)==1 && numel(r(i).simind)==0
            r(i)=[];
        end
    end
end

if nargin == 7
    r=r(rselect);
end



for i=1:numel(r)
    clearvars ind2 starts2
    try
        segind=r(i).ind;
        
        for j=1:numel(segind)
            starts2(j)=nmatFound(segind(j),1);
        end
        [starts2, ind2]=sort(starts2);
        r(i).ind=segind(ind2);
        
    catch
        segind=r(i).segind;
        
        for j=1:numel(segind)
            %             j
            %             segind(j)
            %             size(nmatFound)
            starts2(j)=nmatFound(segind(j),1);
        end
        [starts2, ind2]=sort(starts2);
        r(i).segind=segind(ind2);
    end
    
end

if sortYN==1
    for i=1:numel(r)
        try
            starts(i)=r(i).segind(1);
        catch
            starts(i)=r(i).ind(1);
        end
    end
    [starts, ind]=sort(starts);
    r=r(ind);
end






colornum=1;

cmap1 = jet(numel(r));
% color1=cmap1(2,:);
% cmap1(2,:)=[];
% cmap1=[color1;cmap1];


screensize = get( groot, 'Screensize' );
fig=figure();
set(fig,'Color','w','Name','Video-EASE: arcPlot','Position', screensize*.9);

midiplot(1)=plot([nmat(1,1) (nmat(1,1)+nmat(1,2))], [nmat(1,4) nmat(1,4)],'Color','k','LineWidth', 10);
legendplots(1)=midiplot(1);
hold on
title(plotTitle,'FontSize',30);
xlabel('Time (beats)','FontSize',16);
ylabel('MIDI pitch (C4=60)','FontSize',16);
set(gca,'FontSize',16,'FontWeight','bold');

%initialize colors and labels for legend
labels{1}='MIDI';
for i=1:numel(r)
    if nargin == 7 %%%%%
        labels{end+1}=stringNames{i};
    else
        labels{end+1}=['String' sprintf(' %d',i)];
    end
    if numel(r)==1
        h(i)=plot([-1,-2],[1,1],'Color',[0,0,1],'LineWidth',10); 
    else
    h(i)=plot([-1,-2],[1,1],'Color',cmap1(i,:),'LineWidth',10);
    end
    legendplots(end+1)=h(i);
end


for i=1:numel(nmat(:,1))
    midiplot(i)=plot([nmat(i,1) (nmat(i,1)+nmat(i,2))], [nmat(i,4) nmat(i,4)],'Color','k','LineWidth',10);
end


pitchmean=mean(nmat(:,4));
pitchmax=max(nmat(:,4));

xmin=min(nmat(:,1));
xmax=max(nmat(:,1));
xrange=xmax-xmin;
xmin=xmin-.1*xrange;
xmax=xmax+.1*xrange;
position = getpixelposition(gca);
plotsizex=position(3);
plotsizey=position(4);
xpixels=plotsizex/xmax;

rads=1;



for i=1:numel(r)
    try
        segind=r(i).ind;
        
    catch
        segind=r(i).segind;
    end
    try
        try
            simind=r(i).simind;
        catch
            simind=r(i).invind;
        end
    catch
        simind=[];
    end
    
    
    
    
    origxstart=nmatFound(segind(1),1);
    card=r(i).card;
    origxend=nmatFound(segind(1)+card-1,1)+nmatFound(segind(1)+card-1,2);
    origwidth=origxend-origxstart;
    origx=(origwidth)/2+origxstart;
    linewidthstart=origwidth*xpixels;
    origpitchmin=min(nmatFound(segind(1):segind(1)+card-1,4))-2;
    
    colornoalpha=cmap1(colornum,:);
    colornum=colornum+1;
    
    
    for j=2:numel(segind)
        compxstart=nmatFound(segind(j),1);
        compxend=nmatFound(segind(j)+card-1,1)+nmatFound(segind(j)+card-1,2);
        compwidth=compxend-compxstart;
        compx=(compwidth)/2+compxstart;
        linewidthend=compwidth*xpixels;
        comppitchmin=min(nmatFound(segind(j):segind(j)+card-1,4))-2;
        
        rad=(compx-origx)/2;
        rads(end+1)=rad;
        x=rad+origx;
        
        nsegments=100;
        linewidth=card*3;
        
        if numel(r)==1
            colornoalpha=[0,0,1];
        end
        
        coloralpha=[colornoalpha,.5];
        
        
        
        h = arc(x,pitchmean,rad,nsegments,coloralpha,linewidthstart,linewidthend);
        
        if origpitchmin < pitchmean
            line([origx origx],[pitchmean origpitchmin],'Color',coloralpha,'LineWidth',linewidthstart);
        end
        if comppitchmin < pitchmean
            try
            line([compx compx],[pitchmean comppitchmin],'Color',coloralpha,'LineWidth',linewidthend);
            catch
                continue
            end
        end
        
    end
    
    if isempty(simind)==0
        for j=1:numel(simind)
            compxstart=nmatFound(simind(j),1);
            compxend=nmatFound(simind(j)+card-1,1)+nmatFound(simind(j)+card-1,2);
            compwidth=compxend-compxstart;
            compx=(compwidth)/2+compxstart;
            linewidthend=compwidth*xpixels;
            comppitchmin=min(nmatFound(simind(j):simind(j)+card-1,4))-2;
            
            rad=(compx-origx)/2;
            rads(end+1)=rad;
            x=rad+origx;
            if rad < 0
                rad=-rad;
                
            end
            
            nsegments=100;
            linewidth=card*2;
            coloralpha=[colornoalpha,.2];
            
            h = arc(x,pitchmean,rad,nsegments,coloralpha,linewidthstart,linewidthend);
            
            if origpitchmin < pitchmean
                line([origx origx],[pitchmean origpitchmin],'Color',coloralpha,'LineWidth',linewidthstart);
            end
            if comppitchmin < pitchmean
                line([compx compx],[pitchmean comppitchmin],'Color',coloralpha,'LineWidth',linewidthend);
            end
        end
    end
    
end


if numel(chans)==1
    midiplot2(1)=line([nmat(1,1) (nmat(1,1)+nmat(1,2))], [nmat(1,4) nmat(1,4)],'Color','k','LineWidth', 10);
    
    for i=1:numel(nmat(:,1))
        midiplot2(i)=line([nmat(i,1) (nmat(i,1)+nmat(i,2))], [nmat(i,4) nmat(i,4)],'Color','k','LineWidth',10);
    end
    
else
    
    cmap2=hot(numel(chans));
    colornum=1;
    for j=1:numel(chans)
        for i=1:numel(nmat(:,1))
            if nmat(i,3)==chans(j)
                midiplot2(i)=line([nmat(i,1) (nmat(i,1)+nmat(i,2))], [nmat(i,4) nmat(i,4)],'Color','k','LineWidth',12);
            end
        end
    end
    for j=1:numel(chans)
        for i=1:numel(nmat(:,1))
            if nmat(i,3)==chans(j)
                midiplot3(i)=line([nmat(i,1)+.1 (nmat(i,1)+nmat(i,2))-.1], [nmat(i,4) nmat(i,4)],'LineWidth',8);
                midiplot3(i).Color=cmap2(colornum,:);
            end
        end
        colornum=colornum+1;
    end
end
ymin=min(nmat(:,4));
ymax=pitchmean+max(rads);
yrange=ymax-ymin;
ybuffer=.2*yrange;
ylim([ymin-ybuffer ymax+ybuffer]);
xlim([xmin xmax])
hold off

legend(legendplots,labels,'Box','off');%'Position',[0.75 0.75 0.2 0.2]);
end
