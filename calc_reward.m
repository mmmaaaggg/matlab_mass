function reward=calc_reward(varargin)
%%
%技术面结合基本面
%长短周期技术面信号结合， 纳入现货价格变化
%小时、日、周，现货 综合考虑
%2016-3-20
%注意输入数据的格式-高开低收
%%
%参数输入
%原始资金1000000
capital=1000000;

%删除开始进场个数
k=20;
%换月删除个数
huanyue=0; %看技术指标 周指标取5  小时指标取30 日指标取30 
ma1=20;  % 10日均线，或者20日均线
ma2=60;
jibendwei=10;    %基本仓位,手数，以10吨为一手
shengshui=200;   %升水
tieshui=150;%贴水
shouxufeibili=0.001;%手续费标准
morengcwei2=1;%不满足过虑条件2时，仓位降至‘原计划仓位’的比例,取值范围0-1,1表示无关，0为一票否决
morengcwei3=1;%不满足过虑条件3时，仓位降至‘原计划仓位’的比例,取值范围0-1,
%%
%数据输入
% k1='yyyy-mm-dd';
k2='yyyy-mm-dd HH:MM:SS';
% kk='mm/dd/yyyy';
j='yyyy/mm/dd';
% a=k2;

[num,text]=xlsread('历年I05BarSize=30高开低收');  % 注意输入数据的格式-高开低收
% riqi1=datenum(text(2:end,1),a); %日期文本转换成日期数字格式
hdate1=num(k:end,1)+693960;  %此处日期格式为数字
shijianxulue1=fints([hdate1,num(k:end,2:5)]); %建立金融时间序列,可直接识别日期字符串

[num2,text2]=xlsread('矿石仓单低价'); %输入时间+现货价格
xianhuoxulue1=fints(num2(k:end,1)+693960,num2(k:end,end)); %

[num3,text3]=xlsread('历年I05高开低收'); 
meitianxulie=fints(num3(k:end,1)+693960,num3(k:end,2:5));  %纳入高开低收 后面用到
%%
%数据基本处理
jinrongshijianxulie=shijianxulue1;
%特定日期函数提取
meirishuju=todaily((jinrongshijianxulie));% 提取每日数据
zhoumojr=toweekly(jinrongshijianxulie);    %提取周末数据

%缺失数据按照线性方法补上
jinrongshijianxulie=fillts(jinrongshijianxulie,'l');

% 时间序列矩阵化，1表示纳入时间 0表示不要时间 还可以指定数据
hangqingjuzhen=fts2mat(jinrongshijianxulie,1);
hqinggeshu=length(hangqingjuzhen(:,1));
hqingtime=hangqingjuzhen(:,1);

meirijuzhen=fts2mat(meitianxulie,1);%每日矩阵 
% 均线计算
[duan,chang]=movavg(meirijuzhen(:,4),ma1,ma2);  %使用每日收盘价格
jiagetianshu=length(meirijuzhen(:,1));
meiritime=meirijuzhen(:,1);
meiriclosejia=meirijuzhen(:,4);  % MG：这个是最低价，I行情数据结构感觉上应该是 时间+开高低收 结构

xuanhuojuzhen=fts2mat(xianhuoxulue1,1);%现货矩阵
xianhuotianshu=length(xuanhuojuzhen(:,1));
xianhuotime=xuanhuojuzhen(:,1);
xianhuojia=xuanhuojuzhen(:,end);%%%

%% 信号传递 给小时线
jiage_xinhao=zeros(hqinggeshu,1);
xianhuo_xinhao=zeros(hqinggeshu,1);

xianhuo_kaicang=zeros(hqinggeshu,1);%现货开仓信号   % MG：这个现货矩阵的价格一直在单方向的涨，应该是模拟数据吧
xianhuo_kaicang=xianhuozhangdie(xianhuojia);% 注意使用函数xianhuozhangdie  

shoupanjia_kaicang=zeros(hqinggeshu,1);%收盘开仓信号
shoupanjia_kaicang=junxianpailie(meiriclosejia,ma1,ma2);% 注意使用函数



for s=50:hqinggeshu
    for g=2:xianhuotianshu
        if hqingtime(s)>xianhuotime(g-1)&hqingtime(s)<xianhuotime(g)    %夜盘处理？
           xianhuo_xinhao(s)= xianhuo_kaicang(g-1);
         break
        end
    end
    
    for d=2:jiagetianshu
        if hqingtime(s)>meiritime(d-1)&hqingtime(s)<meiritime(d)
           jiage_xinhao(s)= shoupanjia_kaicang(d-1);
         break
        end
    end   
end




% aaa=fts2mat(shijianxulue1,1);

niandu=unique(year(hangqingjuzhen(:,1)));  %提取年度
niandugeshu=length(niandu);   %多少年

% chartfts(zhoumoxulie);   %画图
jiagelinshi1=[fts2mat(jinrongshijianxulie.series2),fts2mat(jinrongshijianxulie.series3),fts2mat(jinrongshijianxulie.series4)];%注意列数
%计算kdj值，注意不是系统函数,输入3列数，输出3列数据
kdjzhi = indicators(jiagelinshi1,'kdj');
kzhi=kdjzhi(:,1);
dzhi=kdjzhi(:,2);
jzhi=kdjzhi(:,3);
% 计算MACD所需参数，默认 12,26,9
if isempty(varargin)
    short  = 12;
    long   = 26;
    signal = 9;
else
    short  = varargin{1};
    long   = varargin{2};
    signal = varargin{3};
end
%计算macd值，输入收盘价，输出3列数
macdzhi=indicators(jiagelinshi1(:,3),'macd', short, long, signal);
difzhi=macdzhi(:,1);
deazhi=macdzhi(:,2);
macdzhuzhi=macdzhi(:,3);

%%
%参数衔接
%确定进场价格
jinchangjiage=jinrongshijianxulie;
qihuo=fts2mat(jinrongshijianxulie.series4);% 注意列数 
dategtong=hangqingjuzhen(:,1);
%%

%%
%交易信号产生

%仓位
changdu=length(jinchangjiage);
zijin=zeros(changdu,1);
smalltime_cangwei=zeros(changdu,1);%0代表无持仓，1进场，2加仓
xishu2=zeros(changdu,1);%涨跌 1，-1
xishu22=ones(changdu,1).*morengcwei2;%仓位
xishu3=zeros(changdu,1);
xishu33=ones(changdu,1).*morengcwei3;%仓位
xishu4=ones(changdu,1);
xishu5=ones(changdu,1);
xishu6=ones(changdu,1);
jinchangjilu=zeros(changdu,1);%开仓纪录？？？
%增加平仓记录？
%%
%进场信号
for i=40:changdu
% % % % %做多信号
%       if (xianhuo(i)>xianhuo(i-1))|(xianhuo(i)==xianhuo(i-1)&cangwei(i-1)>0)    %只用现货，注意用“==”！
% %       if (xianhuo(i-1)>xianhuo(i-2))|(xianhuo(i-1)==xianhuo(i-2)&cangwei(i-1)>0)    %滞后一天决策
        %两个地区现货
%      if ((xianhuo(i)>xianhuo(i-1))&(xianhuo2(i)>xianhuo2(i-1)))|(xianhuo(i)>=xianhuo(i-1)&xianhuo2(i)>=xianhuo2(i-1)&cangwei(i-1)>0) %开仓点要求同步大于昨日价格 
%     if qihuo(i)>=duan(i)&((xianhuo(i)>xianhuo(i-1))|(xianhuo(i)>=xianhuo(i-1)&cangwei(i-1)>0))   %期现结合 


%    if jiagexinhao(i)&(kzhi(i)>dzhi(i)&kzhi(i)<=30&kzhi(i-1)<=dzhi(i-1))|(cangwei(i-1)==1&kzhi(i)>dzhi(i))  %kd做多 
     if macdzhuzhi(i)>0  %macd做多  jiagexinhao(i)&macdzhuzhi(i)>0  
       smalltime_cangwei(i)=1; 
     elseif dategtong(i)-dategtong(i-1)>300  %需要剔除合约到期转入下年换月因素
        smalltime_cangwei(i)=0; 
        i=i+huanyue;

       
% % % % %做多仓位设置      
%        if  qihuo(i)-xianhuo(i)>shengshui   %做多时升水较大仓位减半
%             cangwei(i)=0.5; 
%        end
%        if qihuo(i)>=chang(i)&qihuo(i)<(xianhuo(i)+shengshui) %期货高于60日线且升水小于200，仓位加倍
%             cangwei(i)=2;
%        end

%         if    (xianhuo2(i)>xianhuo2(i-1))|(xianhuo2(i)==xianhuo2(i-1)&xishu2(i-1)>0)  %第二个信号过滤
%                  xishu2(i)=1; 
%                  xishu22(i)=1;
%         end
%         if      (xianhuo3(i)>xianhuo3(i-1))|(xianhuo3(i)==xianhuo3(i-1)&xishu3(i-1)>0)  %第三个信号过滤
%                  xishu3(i)=1; 
%                  xishu33(i)=1;
%         end
%         cangwei(i)=cangwei(i)*xishu22(i)*xishu33(i);
        
   end
     
 
%    if ~jiagexinhao(i)&(kzhi(i)<dzhi(i)&kzhi(i)>=70&kzhi(i-1)>dzhi(i-1))|(cangwei(i-1)==-1&kzhi(i)<dzhi(i))   %kd做空 
   if  macdzhuzhi(i)<0 %macd做空  ~jiagexinhao(i)&macdzhuzhi(i)<0
       smalltime_cangwei(i)=-1;    
     elseif dategtong(i)-dategtong(i-1)>300
        smalltime_cangwei(i)=0;
        i=i+huanyue;
    
% % % %%做空仓位
%      if (xianhuo(i)<xianhuo(i-1))|(xianhuo(i)==xianhuo(i-1)&cangwei(i-1)<0)    %只用现货
% %      if (xianhuo(i-1)<xianhuo(i-2))|(xianhuo(i-1)==xianhuo(i-2)&cangwei(i-1)<0)    %滞后一天决策
%       if ((xianhuo(i)<xianhuo(i-1))&(xianhuo2(i)<xianhuo2(i-1)))|(xianhuo(i)<=xianhuo(i-1)&xianhuo2(i)<=xianhuo2(i-1)&cangwei(i-1)<0)     
%     if qihuo(i)<duan(i)&((xianhuo(i)<xianhuo(i-1))|(xianhuo(i)<=xianhuo(i-1)&cangwei(i-1)<0))      %期现结合     


        
% % % % % 做空仓位设置
%         if  qihuo(i)-xianhuo(i)<-tieshui   %做空时贴水较大，仓位减半
%             cangwei(i)=-0.5;
%         end
%        if qihuo(i)<chang(i)&qihuo(i)>(xianhuo(i)-tieshui)
%            cangwei(i)=-2;
%        end

%       if  (xianhuo2(i)<xianhuo2(i-1))|(xianhuo2(i)==xianhuo2(i-1)&xishu2(i-1)<0)  %第二个信号过滤
%            xishu2(i)=-1; 
%            xishu22(i)=1;
%       end
%       if  (xianhuo3(i)<xianhuo3(i-1))|(xianhuo3(i)==xianhuo3(i-1)&xishu3(i-1)<0)  %第三个信号过滤
%            xishu3(i)=-1; 
%            xishu33(i)=1;
%       end
%        cangwei(i)=cangwei(i)*xishu22(i)*xishu33(i);
       
      end
    
%     %具体期货合约01、05、09，部分时间段需要空仓
%     %01合约 结束日期：11.15或11.30 ；开始日期07.16；即7.16-11.15
%     if month(date(i))>11|month(date(i))<7|((month(date(i))==7)&(day(date(i))<16))|((month(date(i))==11)&(day(date(i))>15))
%         cangwei(i)=0;
%     end
    
%     %05合约：11.16-3.15
%     if month(date(i))>3&month(date(i))<11|(month(date(i))==3&day(date(i))>15)|(month(date(i))==11&day(date(i))<16)
%         cangwei(i)=0;
%     end
%     
%     %09合约: 3.16-7.15
%     if month(date(i))>7|month(date(i))<3|(month(date(i))==3&day(date(i))<16)|(month(date(i))==7&day(date(i))>15)
%         cangwei(i)=0;
%     end

%期现结合仓位设置
%   if cangwei(i)-xianhuoxinhao(i)==0
%       cangwei(i)=cangwei(i)*2;
%   end
end

zuizhongcangwei=smalltime_cangwei*jibendwei;%最终仓位
jisuancangwei=[0;zuizhongcangwei(1:end-1)];%计算仓位
jisuanyishoucangwei=[0;smalltime_cangwei(1:end-1)];
%每日计算
meirijiacha=[0;diff(qihuo)];%每日价差????
meitianykui=jisuanyishoucangwei.*meirijiacha*10;%每手每日盈亏,按一手10吨记
%手续费
cangweibianhua=[0;diff(zuizhongcangwei)];

shouxufei=abs(cangweibianhua).*qihuo*shouxufeibili*10;
%每日盈亏
meirijiesuanykui=jibendwei.*meitianykui-shouxufei;
%总资金
zijin=capital+cumsum(meirijiesuanykui);
meirizijin=zijin;%每日数据输出时用到
%%
%交易结果计算
%打包做成一个结果函数！！！
%%
%结果输出，两类结果，1.每天结果。2.每次平仓结果
%  plot(zuizhongcangwei);
%  plot(meirijiesuanykui);
kaishiriqi=datestr(dategtong(1),j);
jiesuriqi=datestr(dategtong(end),j);
nianjunshouyilv=(zijin(end)/zijin(1))^(365/(dategtong(end)-dategtong(1)))-1;  %年度回报
%统计空仓交易日
kongcangjiaoyiri=length(find(zuizhongcangwei==0));
zijin(end);
% 资金曲线
% semilogy(datekaicang,zijin)

[huichezijin,i1,i2]=maxdown(zijin);
datestr(dategtong(i1),j);
datestr(dategtong(i2),j);
[huichebili,ind11,ind22]=maxdownrate(zijin);
datestr(dategtong(ind11),j);
datestr(dategtong(ind22),j);
%年度复合回报/最大回撤>8
huibaobihuiche=-nianjunshouyilv/huichebili;

[huicheshijian,shijian1,shijian2]=maxdowntime(zijin);
datestr(dategtong(shijian1),j);
datestr(dategtong(shijian2),j);
jiangetianshu=dategtong(shijian2)-dategtong(shijian1);

%%
%平仓盈亏相关计算
%开仓平仓盈亏计算
xinhao=sign(zuizhongcangwei);
xinhao2=abs([0;diff(xinhao)]);
xinhao3=xinhao2>0;
%上面三个语句是否有问题？


%每次开仓计算？
kaicangzijin=zijin(xinhao3);

zijin=kaicangzijin;

reward=zijin(end);