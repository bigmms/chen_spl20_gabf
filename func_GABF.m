function Iout = func_GABF(Isrc, Rad, StdS, StdR)

[Hei,Wid] = size(Isrc);
iKg = zeros(1,2*Rad+1);
for i = 0 : 1 : Rad
    iKg(Rad+i+1) = exp(-(i^2)/2/(StdS^2));
    iKg(Rad-i+1) = exp(-(i^2)/2/(StdS^2));
end
iKs = iKg' * iKg;
iKr = zeros(1,256);
for i = 0 : 1 : 255
    iKr(i+1) = exp(-(i^2)/2/(StdR^2));
end

Ibuf = imrotate(Isrc,90);
Ibuf = func_GF(Ibuf, Wid, Hei, Rad, StdS);
Ibuf = imrotate(Ibuf,-90);
Ibuf = func_GF(Ibuf, Hei, Wid, Rad, StdS);

Iout = Ibuf;
for h = 1 : 1 : Hei
    for w = 1 : 1 : Wid
        SumUp = 0;
        SumDn = 0;
        for sh = -Rad : 1 : Rad
            i = min(max(h + sh, 1), Hei);
            for sw = -Rad : 1 : Rad
                j = min(max(w + sw, 1), Wid);
                PxlDif = abs(Ibuf(i,j) - Isrc(h,w));
                if sh == 0 && sw == 0
                    SumUp = SumUp + Isrc(h,w);
                    SumDn = SumDn + 1;
                else
                    SumUp = SumUp + Ibuf(i,j) * iKs(sh+Rad+1, sw+Rad+1) * iKr(PxlDif+1);
                    SumDn = SumDn + iKs(sh+Rad+1, sw+Rad+1) * iKr(PxlDif+1);
                end
            end
        end
        if SumDn < 0.001
            Iout(h,w) = Ibuf(h,w);
        else
            Iout(h,w) = round(SumUp / SumDn);
        end
    end
end

end

function Iout = func_GF(Isrc, Hei, Wid, Rad, StdG)

iKs = zeros(1,Rad+1);
for i = 0 : 1 : Rad
    iKs(i+1) = exp(-(i^2)/2/(StdG^2));
end

Iout = Isrc;
for h = 1 : 1 : Hei
    for w = 1 : 1 : Wid
        SumUp = 0;
        SumDn = 0;
        for sw = -Rad : 1 : Rad
            j = min(max(w + sw, 1), Wid);
            SumUp = SumUp + Isrc(h,j) * iKs(abs(sw)+1);
            SumDn = SumDn + iKs(abs(sw)+1);
        end
        Iout(h,w) = round(SumUp / SumDn);
    end
end

end