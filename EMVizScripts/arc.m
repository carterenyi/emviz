function h = arc(x,y,r,nsegments,coloralpha,linewidthstart,linewidthend)
if nargin<4
    nsegments=100;
    coloralpha=[0,0,1,1];
    linewidthstart=5;
    linewidthend=5;
    
end
linewidth=linewidthstart;
hold on
th = 0:pi/nsegments:pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;


linewidthincrement=(linewidthstart-linewidthend)/numel(xunit);
for i=2:numel(xunit)
    try
    h(i) = plot(xunit(i-1:i), yunit(i-1:i),'Color',coloralpha,'LineWidth',linewidthend+i*linewidthincrement);
    catch
        continue
    end
end
hold off