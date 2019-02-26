function nmatRCE=nmatMono2poly(nmat,nmatRCE)

chans=unique(nmat(:,3));
for i=2:numel(chans)
temp=find(nmat(:,3)==chans(i));
start=nmat(temp(1),1);
temp=find(nmatRCE(:,3)==chans(i));
current=nmatRCE(temp(1),1);
diff=current-start;
for j=1:numel(nmatRCE(:,1))
    if nmatRCE(j,3)==chans(i)
        nmatRCE(j,1)=nmatRCE(j,1)-diff;
    end
end
end

end