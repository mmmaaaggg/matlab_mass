%%
%�����棬�ܱ��� ��kd macd��
%ע���������ݵĸ�ʽ-�߿�����
%%
%��������
%ԭʼ�ʽ�1000000
capital=1000000;

%ɾ����ʼ��������
k=20;
ma1=20;  % 10�վ��ߣ�����20�վ���
ma2=60;
jibendwei=40;    %������λ,��������10��Ϊһ��
shengshui=200;   %��ˮ
tieshui=150;%��ˮ
shouxufeibili=0.001;%�����ѱ�׼
morengcwei2=1;%�������������2ʱ����λ������ԭ�ƻ���λ���ı���,ȡֵ��Χ0-1,1��ʾ�޹أ�0ΪһƱ���
morengcwei3=1;%�������������3ʱ����λ������ԭ�ƻ���λ���ı���,ȡֵ��Χ0-1,
%%
%��������
k1='yyyy-mm-dd';
% k2='yyyy-mm-dd HH:MM:SS';
kk='mm/dd/yyyy';
j='yyyy/mm/dd';%  ������ʽ�������Ҫ�������ʽ
% a=k2;

[num,text]=xlsread('����05�ܸ߿�����');  %ע���� num��ǰ������
% riqi1=datenum(text(2:end,1),a); %�����ı�ת�����������ָ�ʽ
shijianxulue1=fints(text(1+k:end,1),num(k:end,:)); %��������ʱ������,��ֱ��ʶ�������ַ���
%%
%���ݻ�������
% chartfts(shijianxulue1);   %��ͼ

% niandu=unique(text(2:end,1));  %��ȡ���
% niandugeshu=length(niandu);   %������
jinrongshijianxulie=shijianxulue1;
%�ض����ں�����ȡ
% meirishuju=todaily((jinrongshijianxulie));% ��ȡÿ������
zhoumoxulie=toweekly(jinrongshijianxulie);    %��ȡ��ĩ����
%ȱʧ���ݰ������Է�������
zhoumoxulie=fillts(zhoumoxulie,'l');
% chartfts(zhoumoxulie);   %��ͼ
jiagelinshi1=[fts2mat(zhoumoxulie.series2),fts2mat(zhoumoxulie.series3),fts2mat(zhoumoxulie.series4)];%ע������
%����kdjֵ��ע�ⲻ��ϵͳ����,����3���������3������
kdjzhi = indicators(jiagelinshi1,'kdj');
kzhi=kdjzhi(:,1);
dzhi=kdjzhi(:,2);
jzhi=kdjzhi(:,3);
%����macdֵ���������̼ۣ����3����
macdzhi=indicators(jiagelinshi1(:,3),'macd');
timejuzhen=fts2mat(zhoumoxulie,1);% ʱ�����о��󻯣�1��ʾ����ʱ�� 0��ʾ��Ҫʱ�� ������ָ������
% aaa=fts2mat(shijianxulue1,1);
% bbb2=fints(aaa(:,1),aaa(:,2:5));
%%
%�����ν�
%ȷ�������۸�
jinchangjiage=zhoumoxulie;
qihuo=fts2mat(zhoumoxulie.series4);% ע������ 
dategtong=timejuzhen(:,1);
%%
% ���߼���
[duan,chang]=movavg(qihuo,ma1,ma2);
%%
%�����źŲ���

%��λ
changdu=length(jinchangjiage);
zijin=zeros(changdu,1);
cangwei=zeros(changdu,1);%0�����޳ֲ֣�1������2�Ӳ�
xishu2=zeros(changdu,1);%�ǵ� 1��-1
xishu22=ones(changdu,1).*morengcwei2;%��λ
xishu3=zeros(changdu,1);
xishu33=ones(changdu,1).*morengcwei3;%��λ
xishu4=ones(changdu,1);
xishu5=ones(changdu,1);
xishu6=ones(changdu,1);
jinchangjilu=zeros(changdu,1);%���ּ�¼������
%����ƽ�ּ�¼��
%%
%�����ź�
for i=2:changdu
% % % % %�����ź�
%       if (xianhuo(i)>xianhuo(i-1))|(xianhuo(i)==xianhuo(i-1)&cangwei(i-1)>0)    %ֻ���ֻ���ע���á�==����
% %       if (xianhuo(i-1)>xianhuo(i-2))|(xianhuo(i-1)==xianhuo(i-2)&cangwei(i-1)>0)    %�ͺ�һ�����
        %���������ֻ�
%      if ((xianhuo(i)>xianhuo(i-1))&(xianhuo2(i)>xianhuo2(i-1)))|(xianhuo(i)>=xianhuo(i-1)&xianhuo2(i)>=xianhuo2(i-1)&cangwei(i-1)>0) %���ֵ�Ҫ��ͬ���������ռ۸� 
%     if qihuo(i)>=duan(i)&((xianhuo(i)>xianhuo(i-1))|(xianhuo(i)>=xianhuo(i-1)&cangwei(i-1)>0))   %���ֽ�� 

%�������� 
   if (kzhi(i)>dzhi(i)&kzhi(i)<=30&kzhi(i-1)<=dzhi(i-1))|(cangwei(i-1)==1&kzhi(i)>dzhi(i))  
       cangwei(i)=1; 
     elseif dategtong(i)-dategtong(i-1)>300  %��Ҫ�޳���Լ����ת�����껻������
        cangwei(i)=0; 

       
% % % % %�����λ����      
%        if  qihuo(i)-xianhuo(i)>shengshui   %����ʱ��ˮ�ϴ��λ����
%             cangwei(i)=0.5; 
%        end
%        if qihuo(i)>=chang(i)&qihuo(i)<(xianhuo(i)+shengshui) %�ڻ�����60��������ˮС��200����λ�ӱ�
%             cangwei(i)=2;
%        end

%         if    (xianhuo2(i)>xianhuo2(i-1))|(xianhuo2(i)==xianhuo2(i-1)&xishu2(i-1)>0)  %�ڶ����źŹ���
%                  xishu2(i)=1; 
%                  xishu22(i)=1;
%         end
%         if      (xianhuo3(i)>xianhuo3(i-1))|(xianhuo3(i)==xianhuo3(i-1)&xishu3(i-1)>0)  %�������źŹ���
%                  xishu3(i)=1; 
%                  xishu33(i)=1;
%         end
%         cangwei(i)=cangwei(i)*xishu22(i)*xishu33(i);
        
   end
     
 %�������� 
   if (kzhi(i)<dzhi(i)&kzhi(i)>=70&kzhi(i-1)>dzhi(i-1))|(cangwei(i-1)==-1&kzhi(i)<dzhi(i))
       cangwei(i)=-1;    
     elseif dategtong(i)-dategtong(i-1)>300
        cangwei(i)=0;
    
% % % %%���ղ�λ
%      if (xianhuo(i)<xianhuo(i-1))|(xianhuo(i)==xianhuo(i-1)&cangwei(i-1)<0)    %ֻ���ֻ�
% %      if (xianhuo(i-1)<xianhuo(i-2))|(xianhuo(i-1)==xianhuo(i-2)&cangwei(i-1)<0)    %�ͺ�һ�����
%       if ((xianhuo(i)<xianhuo(i-1))&(xianhuo2(i)<xianhuo2(i-1)))|(xianhuo(i)<=xianhuo(i-1)&xianhuo2(i)<=xianhuo2(i-1)&cangwei(i-1)<0)     
%     if qihuo(i)<duan(i)&((xianhuo(i)<xianhuo(i-1))|(xianhuo(i)<=xianhuo(i-1)&cangwei(i-1)<0))      %���ֽ��     


        
% % % % % ���ղ�λ����
%         if  qihuo(i)-xianhuo(i)<-tieshui   %����ʱ��ˮ�ϴ󣬲�λ����
%             cangwei(i)=-0.5;
%         end
%        if qihuo(i)<chang(i)&qihuo(i)>(xianhuo(i)-tieshui)
%            cangwei(i)=-2;
%        end

%       if  (xianhuo2(i)<xianhuo2(i-1))|(xianhuo2(i)==xianhuo2(i-1)&xishu2(i-1)<0)  %�ڶ����źŹ���
%            xishu2(i)=-1; 
%            xishu22(i)=1;
%       end
%       if  (xianhuo3(i)<xianhuo3(i-1))|(xianhuo3(i)==xianhuo3(i-1)&xishu3(i-1)<0)  %�������źŹ���
%            xishu3(i)=-1; 
%            xishu33(i)=1;
%       end
%        cangwei(i)=cangwei(i)*xishu22(i)*xishu33(i);
       
      end
    
%     %�����ڻ���Լ01��05��09������ʱ�����Ҫ�ղ�
%     %01��Լ �������ڣ�11.15��11.30 ����ʼ����07.16����7.16-11.15
%     if month(date(i))>11|month(date(i))<7|((month(date(i))==7)&(day(date(i))<16))|((month(date(i))==11)&(day(date(i))>15))
%         cangwei(i)=0;
%     end
    
%     %05��Լ��11.16-3.15
%     if month(date(i))>3&month(date(i))<11|(month(date(i))==3&day(date(i))>15)|(month(date(i))==11&day(date(i))<16)
%         cangwei(i)=0;
%     end
%     
%     %09��Լ: 3.16-7.15
%     if month(date(i))>7|month(date(i))<3|(month(date(i))==3&day(date(i))<16)|(month(date(i))==7&day(date(i))>15)
%         cangwei(i)=0;
%     end
end

zuizhongcangwei=cangwei*jibendwei;%���ղ�λ
jisuancangwei=[0;zuizhongcangwei(1:end-1)];%�����λ
jisuanyishoucangwei=[0;cangwei(1:end-1)];
%ÿ�ռ���
meirijiacha=[0;diff(qihuo)];%ÿ�ռ۲�????
meitianykui=jisuanyishoucangwei.*meirijiacha*10;%ÿ��ÿ��ӯ��,��һ��10�ּ�
%������
cangweibianhua=[0;diff(zuizhongcangwei)];

shouxufei=abs(cangweibianhua).*qihuo*shouxufeibili*10;
%ÿ��ӯ��
meirijiesuanykui=jibendwei.*meitianykui-shouxufei;
%���ʽ�
zijin=capital+cumsum(meirijiesuanykui);
meirizijin=zijin;%ÿ���������ʱ�õ�
%%
%���ֽ�����
disp(['�޳���ʼ���ݸ�����',num2str(k)]);
disp(['��ʼ�ʽ�Ϊ��',num2str(capital)]);
disp(['��С��λ(��10��һ�ּ�)��',num2str(jibendwei),'��']);
disp(['���ݸ����������գ���',num2str(changdu)]);
disp(['���߶��ڣ�',num2str(ma1),'    ���߳��ڣ�',num2str(ma2)]);
disp(['��ˮ��',num2str(shengshui),'    ��ˮ��',num2str(tieshui)]);
%������ձ������д���һ���о�
nianduxiapubili = sqrt(250)*sharpe(meirijiesuanykui,0); 

%%
%���׽������
%�������һ���������������
%%
%����������������1.ÿ������2.ÿ��ƽ�ֽ��
%  plot(zuizhongcangwei);
%  plot(meirijiesuanykui);
kaishiriqi=datestr(dategtong(1),j);
jiesuriqi=datestr(dategtong(end),j);
disp(['��ʼ���ڣ�',kaishiriqi,'    �������ڣ�',jiesuriqi,'    �����������Ȼ�գ���',num2str(dategtong(end)-dategtong(1))]);
nianjunshouyilv=(zijin(end)/zijin(1))^(365/(dategtong(end)-dategtong(1)))-1;  %��Ȼر�
%ͳ�ƿղֽ�����
kongcangjiaoyiri=length(find(zuizhongcangwei==0));
disp(['�ղֽ����գ�',num2str(kongcangjiaoyiri)]);
zijin(end);
disp(['����������棺',num2str(nianjunshouyilv),'    �����ʽ�Ϊ��',num2str(zijin(end))]);
% �ʽ�����
% semilogy(datekaicang,zijin)
figure
plot(dategtong,zijin)
grid on
dateaxis('x',12)
[huichezijin,i1,i2]=maxdown(zijin);
datestr(dategtong(i1),j);
datestr(dategtong(i2),j);
disp(['����ʽ�س���',num2str(huichezijin),'    ��ʼ�ڣ�',datestr(dategtong(i1),j),'    �����ڣ�',datestr(dategtong(i2),j)]);
[huichebili,ind11,ind22]=maxdownrate(zijin);
datestr(dategtong(ind11),j);
datestr(dategtong(ind22),j);
%��ȸ��ϻر�/���س�>8
huibaobihuiche=-nianjunshouyilv/huichebili;

[huicheshijian,shijian1,shijian2]=maxdowntime(zijin);
datestr(dategtong(shijian1),j);
datestr(dategtong(shijian2),j);
jiangetianshu=dategtong(shijian2)-dategtong(shijian1);
disp(['����ʽ�س�������',num2str(huichebili),'    ��ʼ�ڣ�',datestr(dategtong(ind11),j),'    �����ڣ�',datestr(dategtong(ind22),j)]);
disp(['��ʽ�ָ�ʱ�䣺',num2str(huicheshijian),'    ��ʼ�ڣ�',datestr(dategtong(shijian1),j),...
    '    �����ڣ�',datestr(dategtong(shijian2),j),'    �������:',num2str(jiangetianshu)]);

%%
%ƽ��ӯ����ؼ���
%����ƽ��ӯ������
xinhao=sign(zuizhongcangwei);
xinhao2=abs([0;diff(xinhao)]);
xinhao3=xinhao2>0;
%������������Ƿ������⣿


%ÿ�ο��ּ��㣿
kaicangzijin=zijin(xinhao3);
zijin=kaicangzijin;
datekaicang=dategtong(xinhao3);
%���״���
jiaoyicishu=length(kaicangzijin)-1;

%ÿ��ƽ��ӯ��
kaicangyingkui=[0;diff(kaicangzijin)];
%�����Ѻϼ�
shouxufeiheji=sum(shouxufei);
%�����ѱ���
disp(['�����ѱ�����',num2str(shouxufeibili),'    �����Ѻϼ�:',num2str(shouxufeiheji)]);
%�������ӯ������
%˼��������ӯ�������ֲ���
lianxuylicishu=0;
zuidalianxuylicishu=0;
for ii=1:jiaoyicishu
    if kaicangyingkui(ii+1)>0
        lianxuylicishu=lianxuylicishu+1;
        zuidalianxuylicishu=max(zuidalianxuylicishu,lianxuylicishu);
    else 
        lianxuylicishu=0;
    end
end
%��������������
lianxukuisuncishu=0;
zuidalianxukuisuncishu=0;
for ii=1:jiaoyicishu
    if kaicangyingkui(ii+1)<0
        lianxukuisuncishu=lianxukuisuncishu+1;
        zuidalianxukuisuncishu=max(zuidalianxukuisuncishu,lianxukuisuncishu);
    else 
        lianxukuisuncishu=0;
    end
end
disp(['�������ӯ��������',num2str(zuidalianxuylicishu),'    ��������������:',num2str(zuidalianxukuisuncishu)]);
%���ӯ��
[zuidayingli,xuhao]=max(kaicangyingkui);
%������
[zuidakuisun,xuhao2]=min(kaicangyingkui);
disp(['�������ӯ����',num2str(zuidayingli),'    ����������:',num2str(zuidakuisun)]);
%ӯ��ƽ��ֵ
yinglipjunzhi=mean(kaicangyingkui(kaicangyingkui>0));
%����ƽ��ֵ
kuisunpjunzhi=mean(kaicangyingkui(kaicangyingkui<0));
%ӯ������
yinglicishu=length(kaicangyingkui(kaicangyingkui>0));
%ӯ������
yinglibili=yinglicishu/jiaoyicishu;
%�������
kuisuncishu=length(kaicangyingkui(kaicangyingkui<0));
%ƽ��ӯ��
%˼��ӯ���ֲ�
pingjunyli=(kaicangzijin(end)-kaicangzijin(1))/jiaoyicishu;
disp(['ƽ��ÿ�ν���ӯ����',num2str(pingjunyli),'    ����ƽ��ֵ��',num2str(kuisunpjunzhi),'    ӯ��ƽ��ֵ��',num2str(yinglipjunzhi)]);
disp(['���״�����',num2str(jiaoyicishu),'    ӯ��������',num2str(yinglicishu),'    ���������',num2str(kuisuncishu),'    ӯ��������',num2str(yinglibili)]);
%ӯ���ۼ�
yinglileiji=sum(kaicangyingkui(kaicangyingkui>0));
%�����ۼ�
kuisunleiji=sum(kaicangyingkui(kaicangyingkui<0));

%�ʲ��س������������س����޵Ĵ�����

%ƽ���ʲ��س������ϣ�

%R^2

%��ӯ��/�ܿ���
zongylibikuisun=-yinglileiji/kuisunleiji;
%ƽ��ӯ��/ƽ������
pjunylibipjunkuisun=-yinglipjunzhi/kuisunpjunzhi;
disp(['ӯ���ۼƣ�',num2str(yinglileiji),'    �����ۼƣ�',num2str(kuisunleiji),...
    '    ��ӯ��/�ܿ���',num2str(zongylibikuisun),'    ƽ��ӯ��/ƽ������',num2str(pjunylibipjunkuisun)]);
%ƽ���ֲ�����
pjunchicangzhouqi=(dategtong(end)-dategtong(1))/jiaoyicishu;
%��ֲ�����
kaicangriqi=dategtong(xinhao3);
%�ֲ�����
%˼�����ֲ����ڷֲ�
chicangzhouqi=[0;diff(kaicangriqi)];
%��ֲ�����
zuichangchicangzhouqi=max(chicangzhouqi);
%ƽ��ӯ������
pjunylichicangzhouqi=mean(chicangzhouqi(kaicangyingkui>0));
%ƽ����������
pjunkuisunchicangzhouqi=mean(chicangzhouqi(kaicangyingkui<0));
disp(['ƽ���ֲ�������',num2str(pjunchicangzhouqi),'    ��ֲ�������',num2str(zuichangchicangzhouqi),...
    '    ƽ��ӯ���ֲ�ʱ�䣺',num2str(pjunylichicangzhouqi),'    ƽ������ֲ�ʱ�䣺',num2str(pjunkuisunchicangzhouqi)]);
%ģ����������,���󣬷��գ�������ע������Ҳ��ע����ֲ�������ı�׼����ȶ��ԣ�������
%��׼�����,�������ճ���
biaozhunlichalv=std(kaicangyingkui)/pingjunyli;
%����ָ��
kellyzhishu=yinglibili-(1-yinglibili)/pjunylibipjunkuisun;
%����������
beiguanlirunlv=-((yinglicishu-yinglicishu^0.5)*yinglipjunzhi)/((kuisuncishu-kuisuncishu^0.5)*kuisunpjunzhi);
%��������ָ��
lirunzhishubaoshou=-(yinglileiji-zuidayingli*2)/(kuisunleiji+zuidakuisun*2);
%ѭ����>0.7
xunhuanbi=-yinglipjunzhi/kuisunpjunzhi-kuisuncishu/yinglicishu;
disp(['��׼����ʣ�',num2str(biaozhunlichalv),'    ����ָ����',num2str(kellyzhishu),'    ѭ���ȣ�',num2str(xunhuanbi),...
    '    ���������ʣ�����2�ã�����2.5���㣩��',num2str(beiguanlirunlv),'    ��������ָ����',num2str(lirunzhishubaoshou)]);
%%
%����������������1.ÿ������2.ÿ��ƽ�ֽ��
%  plot(zuizhongcangwei);
%  plot(meirijiesuanykui);
j='yyyy/mm/dd';%  ������ʽ�������Ҫ�������ʽ
zijin=kaicangzijin;
kaishiriqi=datestr(dategtong(1),j);
jiesuriqi=datestr(dategtong(end),j);
nianjunshouyilv=(zijin(end)/zijin(1))^(365/(dategtong(end)-dategtong(1)))-1;  %��Ȼر�
dategtongg=datekaicang;    %��һ���ǹؼ�����������
zijin(end);

%�ʽ�����
% semilogy(datekaicang,zijin)
figure
plot(datekaicang,zijin)
grid on
dateaxis('x',12)
[huichezijin,i1,i2]=maxdown(zijin);
datestr(dategtongg(i1),j);
datestr(dategtongg(i2),j);


disp(['��ÿ���������ף�   ����ʽ�س���',num2str(huichezijin),...
    '    ��ʼ�ڣ�',datestr(dategtongg(i1),j),'    �����ڣ�',datestr(dategtongg(i2),j)]);

[huichebili,ind11,ind22]=maxdownrate(zijin);
datestr(dategtongg(ind11),j);
datestr(dategtongg(ind22),j);
%��ȸ��ϻر�/���س�>8
huibaobihuiche=-nianjunshouyilv/huichebili;
disp(['����ʽ�س�������',num2str(huichebili),'    ��ʼ�ڣ�',datestr(dategtongg(ind11),j),...
    '    �����ڣ�',datestr(dategtongg(ind22),j),'    ��ȸ��ϻر�/���س�����:',num2str(huibaobihuiche)]);

[huicheshijian,shijian1,shijian2]=maxdowntime(zijin);
datestr(dategtongg(shijian1),j);
datestr(dategtongg(shijian2),j);
jiangetianshu=dategtongg(shijian2)-dategtongg(shijian1);

disp(['��ʽ�ָ�ʱ��(���״���)��',num2str(huicheshijian),'    ��ʼ�ڣ�',datestr(dategtongg(shijian1),j),...
    '    �����ڣ�',datestr(dategtongg(shijian2),j),'    �������:',num2str(jiangetianshu)]);
%%
%�������
%ÿ���������

%  [aa,bb]=xlswrite('���ƽ�̿ÿ�ս���������0',[duiyingriqi,xianhuo,xianhuo2,zuizhongcangwei,qihuo,meirijiesuanykui,meirizijin]);
% %ÿ�ν����������
% [aa,bb]=xlswrite('ÿ����������������',[juzhengshuju,jijiexingxushu,jijiexingxushupjunzhi02]);