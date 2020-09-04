function   zhangdie=xianhuozhangdie(jiage) %jiage给出价格涨跌信号 
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