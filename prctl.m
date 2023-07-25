function val = prctl(arr,pct)
    len = length(arr);
    ind = floor(pct/100*len);
    newarr = sort(arr);
    val = newarr(ind);
end