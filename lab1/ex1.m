%ex1
v=[30:-1:1];
for i = 1:2:30
     v(i)=sin(v(i));
end
%v(1:2:end)=sin(v(1:2:end));

for i = 2:2:30
   for j = i:2:30
      if v(i)>v(j)
         a=v(i);
         v(i)=v(j);
         v(j)=a;          
      end
    end
end

%v(2:2:end)=sort(v(2:2:end));




