function phases = fourfsk(bitarr)

phases=zeros(length(bitarr)/2,1);
n=1;
for k=1:2:length(bitarr)-1
    bits=bitarr(k:k+1);
    if bits== [0;0]
        phases(n)=0;
    elseif bits==[0;1]
        phases(n)=1;
    elseif bits==[1;0]
        phases(n)=3;
    else
        phases(n)=2;
    end
    n=n+1;
end
end

    
    