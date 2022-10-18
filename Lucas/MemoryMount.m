
clear svMemBin;
clear svMemDec;

lastPos = 0;

for i = 1 : 10
   for j = 1 : svSizes(i)
      for x = 1 : 10
         aux = dec2bin(typecast(single(supportVectors{i}(j,x)), 'uint32'),32);
         svMemDec(lastPos + 1,1) = supportVectors{i}(j,x);
         svMemBin{lastPos + 1,1} = aux;
         lastPos = lastPos + 1;
      end
   end
end

