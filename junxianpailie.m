function   zhangdie=junxianpailie(jiage,duan,chang) %jiage�����������߶�ͷ���л��ǿ�ͷ���� 
           changdu=length(jiage);
           zhangdie=zeros(changdu,1);
           [jiaduan,jiachang]=movavg(jiage,duan,chang); 
           for t=2:changdu
               if jiage(t)>jiaduan(t)&jiaduan(t)>=jiachang(t)
                   zhangdie(t)=1;
               end
               if  jiage(t)<jiaduan(t)&jiaduan(t)<=jiachang(t)
                     zhangdie(t)=-1; 
               end
           end

end