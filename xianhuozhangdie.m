function   zhangdie=xianhuozhangdie(jiage) %jiage�����۸��ǵ��ź� 
           changdu=length(jiage);
           zhangdie=zeros(changdu,1);
           for t=2:changdu
               if jiage(t-1)<jiage(t)|(jiage(t-1)==jiage(t)&zhangdie(t-1)==1)
                   zhangdie(t)=1;
               elseif  jiage(t-1)>jiage(t)|(jiage(t-1)==jiage(t)&zhangdie(t-1)==-1)
                     zhangdie(t)=-1; 
               end
           end

end