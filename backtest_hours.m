function [rewards] = backtest_hours(ohlc_num, xianhuo_num, ohlc_daily_num, ...
    enable_match_available_period, span_year, start_month_day, end_month_day, output_img_path)
%%
%技术面结合基本面
%长短周期技术面信号结合， 纳入现货价格变化
%小时、日、周，现货 综合考虑
%2016-3-20
%注意输入数据的格式-高开低收
% 2020-09-04
% 增加对合约的交易时段的因素，选择合约是，请注意调整时间段，
% 如果不要时间段，则设置 enable_match_available_period = 0
% 设置交易日期区间 MG 2020-09-04
% 1月合约 8月1日 ~ 11月31日
% 5月合约 12.1日 ~ 3月31日
% 9月合约 4月1日 ~ 7月31日
% span_year = 1;  % 标示日期段是否跨年
% start_month_day = '-12-01';
% end_month_day = '-03-31';
%%
% clear
% clc
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

% 设置交易日期区间 MG 2020-09-04
% 1月合约 8月1日 ~ 11月31日
% 5月合约 12.1日 ~ 3月31日
% 9月合约 4月1日 ~ 7月31日
% enable_match_available_period = 1; % 是否启用交易时间段过滤 1：启用，0：关闭
% span_year = 1;  % 标示日期段是否跨年
% start_month_day = '-12-01';
% end_month_day = '-03-31';

%[num]=csvread('历年RB01BarSize=10高开低收.csv');
% [ohlc_num,~]=xlsread(file_path);  % 注意输入数据的格式-高开低收
% riqi1=datenum(text(2:end,1),a); %日期文本转换成日期数字格式
hdate1=ohlc_num(k:end,1)+693960;  %此处日期格式为数字
shijianxulue1=fints([hdate1,ohlc_num(k:end,2:5)]); %建立金融时间序列,可直接识别日期字符串

% [xianhuo_num,~]=xlsread('data\矿石仓单低价'); %输入时间+现货价格
xianhuoxulue1=fints(xianhuo_num(k:end,1)+693960,xianhuo_num(k:end,end)); %

% [ohlc_daily_num,~]=xlsread('data\历年I05高开低收'); 
meitianxulie=fints(ohlc_daily_num(k:end,1)+693960,ohlc_daily_num(k:end,2:5));  %纳入高开低收 后面用到
%%
%数据基本处理
% chartfts(shijianxulue1);   %画图
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
meiriclosejia=meirijuzhen(:,4);

xuanhuojuzhen=fts2mat(xianhuoxulue1,1);%现货矩阵
xianhuotianshu=length(xuanhuojuzhen(:,1));
xianhuotime=xuanhuojuzhen(:,1);
xianhuojia=xuanhuojuzhen(:,end);%%%

%% 信号传递 给小时线
jiage_xinhao=zeros(hqinggeshu,1);
xianhuo_xinhao=zeros(hqinggeshu,1);

xianhuo_kaicang=zeros(hqinggeshu,1);%现货开仓信号
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
%计算macd值，输入收盘价，输出3列数
macdzhi=indicators(jiagelinshi1(:,3),'macd');
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
    % 判断交易日期段是否在 start_month_day ~ end_month_day 之间，同时注意判断是否跨年 span_year
    if enable_match_available_period
        cur_date = jinchangjiage.dates(i); %当前交易日期
        cur_year = year(cur_date);
        start_date = datenum([num2str(cur_year), start_month_day]);
        end_date = datenum([num2str(cur_year), end_month_day]);
        if span_year && (start_date<cur_date || cur_date<end_date)
            % 跨年
            is_avaliable = 1;
        elseif span_year == 0 && (start_date<cur_date && cur_date<end_date)
            % 不跨年
            is_avaliable = 1;
        else
            is_avaliable = 0;
        end
        if is_avaliable == 0
            smalltime_cangwei(i)=0;
            continue;
        end
    end
    % % % % %做多信号
    %       if (xianhuo(i)>xianhuo(i-1))|(xianhuo(i)==xianhuo(i-1)&cangwei(i-1)>0)    %只用现货，注意用“==”！
    % %       if (xianhuo(i-1)>xianhuo(i-2))|(xianhuo(i-1)==xianhuo(i-2)&cangwei(i-1)>0)    %滞后一天决策
            %两个地区现货
    %      if ((xianhuo(i)>xianhuo(i-1))&(xianhuo2(i)>xianhuo2(i-1)))|(xianhuo(i)>=xianhuo(i-1)&xianhuo2(i)>=xianhuo2(i-1)&cangwei(i-1)>0) %开仓点要求同步大于昨日价格 
    %     if qihuo(i)>=duan(i)&((xianhuo(i)>xianhuo(i-1))|(xianhuo(i)>=xianhuo(i-1)&cangwei(i-1)>0))   %期现结合 

    % kd低位金叉做多
    if (kzhi(i)>dzhi(i) && kzhi(i)<=30 && kzhi(i-1)<=dzhi(i-1))  %kd做多 
        smalltime_cangwei(i)=1;
    end           
    
    %     if macdzhuzhi(i)>0  %macd做多  jiagexinhao(i)&macdzhuzhi(i)>0
    %         smalltime_cangwei(i)=1;
    %     elseif dategtong(i)-dategtong(i-1)>300  %需要剔除合约到期转入下年换月因素
    %         smalltime_cangwei(i)=0;
    %         i=i+huanyue;
    %
    %
    %         % % % % %做多仓位设置
    %         %        if  qihuo(i)-xianhuo(i)>shengshui   %做多时升水较大仓位减半
    %         %             cangwei(i)=0.5;
    %         %        end
    %         %        if qihuo(i)>=chang(i)&qihuo(i)<(xianhuo(i)+shengshui) %期货高于60日线且升水小于200，仓位加倍
    %         %             cangwei(i)=2;
    %         %        end
    %
    %         %         if    (xianhuo2(i)>xianhuo2(i-1))|(xianhuo2(i)==xianhuo2(i-1)&xishu2(i-1)>0)  %第二个信号过滤
    %         %                  xishu2(i)=1;
    %         %                  xishu22(i)=1;
    %         %         end
    %         %         if      (xianhuo3(i)>xianhuo3(i-1))|(xianhuo3(i)==xianhuo3(i-1)&xishu3(i-1)>0)  %第三个信号过滤
    %         %                  xishu3(i)=1;
    %         %                  xishu33(i)=1;
    %         %         end
    %         %         cangwei(i)=cangwei(i)*xishu22(i)*xishu33(i);
    %
    %     end

        % kd高位死叉做空
    if (kzhi(i)<dzhi(i) && kzhi(i)>=70 && kzhi(i-1)>dzhi(i-1))   %kd做空 
        smalltime_cangwei(i)=-1;
    end  
    %     if  macdzhuzhi(i)<0 %macd做空  ~jiagexinhao(i)&macdzhuzhi(i)<0
    %         smalltime_cangwei(i)=-1;
    %     elseif dategtong(i)-dategtong(i-1)>300
    %         smalltime_cangwei(i)=0;
    %         i=i+huanyue;
    %
    %         % % % %%做空仓位
    %         %      if (xianhuo(i)<xianhuo(i-1))|(xianhuo(i)==xianhuo(i-1)&cangwei(i-1)<0)    %只用现货
    %         % %      if (xianhuo(i-1)<xianhuo(i-2))|(xianhuo(i-1)==xianhuo(i-2)&cangwei(i-1)<0)    %滞后一天决策
    %         %       if ((xianhuo(i)<xianhuo(i-1))&(xianhuo2(i)<xianhuo2(i-1)))|(xianhuo(i)<=xianhuo(i-1)&xianhuo2(i)<=xianhuo2(i-1)&cangwei(i-1)<0)
    %         %     if qihuo(i)<duan(i)&((xianhuo(i)<xianhuo(i-1))|(xianhuo(i)<=xianhuo(i-1)&cangwei(i-1)<0))      %期现结合
    %
    %
    %
    %         % % % % % 做空仓位设置
    %         %         if  qihuo(i)-xianhuo(i)<-tieshui   %做空时贴水较大，仓位减半
    %         %             cangwei(i)=-0.5;
    %         %         end
    %         %        if qihuo(i)<chang(i)&qihuo(i)>(xianhuo(i)-tieshui)
    %         %            cangwei(i)=-2;
    %         %        end
    %
    %         %       if  (xianhuo2(i)<xianhuo2(i-1))|(xianhuo2(i)==xianhuo2(i-1)&xishu2(i-1)<0)  %第二个信号过滤
    %         %            xishu2(i)=-1;
    %         %            xishu22(i)=1;
    %         %       end
    %         %       if  (xianhuo3(i)<xianhuo3(i-1))|(xianhuo3(i)==xianhuo3(i-1)&xishu3(i-1)<0)  %第三个信号过滤
    %         %            xishu3(i)=-1;
    %         %            xishu33(i)=1;
    %         %       end
    %         %        cangwei(i)=cangwei(i)*xishu22(i)*xishu33(i);
    %
    %     end

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
%部分结果输出
disp(['剔除开始数据个数：',num2str(k)]);
disp(['初始资金为：',num2str(capital)]);
disp(['最小仓位(以10吨一手记)：',num2str(jibendwei),'手']);
disp(['数据个数（交易日）：',num2str(changdu)]);
disp(['均线短期：',num2str(ma1),'    均线长期：',num2str(ma2)]);
disp(['升水：',num2str(shengshui),'    贴水：',num2str(tieshui)]);
%年度夏普比例，有待进一步研究
nianduxiapubili = sqrt(250)*sharpe(meirijiesuanykui,0); 

%交易结果计算
%打包做成一个结果函数！！！

%结果输出，两类结果，1.每天结果。2.每次平仓结果
%  plot(zuizhongcangwei);
%  plot(meirijiesuanykui);
kaishiriqi=datestr(dategtong(1),j);
jiesuriqi=datestr(dategtong(end),j);
disp(['开始日期：',kaishiriqi,'    结束日期：',jiesuriqi,'    间隔天数（自然日）：',num2str(dategtong(end)-dategtong(1))]);
nianjunshouyilv=(zijin(end)/zijin(1))^(365/(dategtong(end)-dategtong(1)))-1;  %年度回报
%统计空仓交易日
kongcangjiaoyiri=length(find(zuizhongcangwei==0));
disp(['空仓交易日：',num2str(kongcangjiaoyiri)]);
zijin(end);
disp(['年均复合收益：',num2str(nianjunshouyilv),'    结束资金为：',num2str(zijin(end)), ' ★']);
% 资金曲线
% semilogy(datekaicang,zijin)
figure('visible','off');
plot(dategtong,zijin);
grid on
dateaxis('x',12)
saveas(gcf,output_img_path); %保存当前窗口的图像

[huichezijin,i1,i2]=maxdown(zijin);
datestr(dategtong(i1),j);
datestr(dategtong(i2),j);
disp(['最大资金回撤：',num2str(huichezijin),'    开始于：',datestr(dategtong(i1),j),'    结束于：',datestr(dategtong(i2),j)]);
[huichebili,ind11,ind22]=maxdownrate(zijin);
datestr(dategtong(ind11),j);
datestr(dategtong(ind22),j);
%年度复合回报/最大回撤>8
huibaobihuiche=-nianjunshouyilv/huichebili;

[huicheshijian,shijian1,shijian2]=maxdowntime(zijin);
datestr(dategtong(shijian1),j);
datestr(dategtong(shijian2),j);
jiangetianshu=dategtong(shijian2)-dategtong(shijian1);
disp(['最大资金回撤比例：',num2str(huichebili),'    开始于：',datestr(dategtong(ind11),j),'    结束于：',datestr(dategtong(ind22),j)]);
disp(['最长资金恢复时间：',num2str(huicheshijian),'    开始于：',datestr(dategtong(shijian1),j),...
    '    结束于：',datestr(dategtong(shijian2),j),'    间隔天数:',num2str(jiangetianshu)]);

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
datekaicang=dategtong(xinhao3);
%交易次数
jiaoyicishu=length(kaicangzijin)-1;

%每次平仓盈亏
kaicangyingkui=[0;diff(kaicangzijin)];
%手续费合计
shouxufeiheji=sum(shouxufei);
%手续费比例
disp(['手续费比例：',num2str(shouxufeibili),'    手续费合计:',num2str(shouxufeiheji), ' ★']);
%最大连续盈利次数
%思考：连续盈利次数分布？
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
%最大连续亏损次数
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
disp(['最大连续盈利次数：',num2str(zuidalianxuylicishu),'    最大连续亏损次数:',num2str(zuidalianxukuisuncishu)]);
%最大盈利
[zuidayingli,xuhao]=max(kaicangyingkui);
%最大亏损
[zuidakuisun,xuhao2]=min(kaicangyingkui);
disp(['单次最大盈利：',num2str(zuidayingli),'    单次最大亏损:',num2str(zuidakuisun)]);
%盈利平均值
yinglipjunzhi=mean(kaicangyingkui(kaicangyingkui>0));
%亏损平均值
kuisunpjunzhi=mean(kaicangyingkui(kaicangyingkui<0));
%盈利次数
yinglicishu=length(kaicangyingkui(kaicangyingkui>0));
%盈利比例
yinglibili=yinglicishu/jiaoyicishu;
%亏损次数
kuisuncishu=length(kaicangyingkui(kaicangyingkui<0));
%平均盈利
%思考盈利分布
pingjunyli=(kaicangzijin(end)-kaicangzijin(1))/jiaoyicishu;
disp(['平均每次交易盈亏：',num2str(pingjunyli),'    亏损平均值：',num2str(kuisunpjunzhi),'    盈利平均值：',num2str(yinglipjunzhi)]);
disp(['交易次数：',num2str(jiaoyicishu),'    盈利次数：',num2str(yinglicishu),'    亏损次数：',num2str(kuisuncishu),'    盈利比例：',num2str(yinglibili)]);
%盈利累计
yinglileiji=sum(kaicangyingkui(kaicangyingkui>0));
%亏损累计
kuisunleiji=sum(kaicangyingkui(kaicangyingkui<0));

%资产回撤计数（超过回撤界限的次数）

%平均资产回撤（接上）

%R^2

%总盈利/总亏损
zongylibikuisun=-yinglileiji/kuisunleiji;
%平均盈利/平均亏损
pjunylibipjunkuisun=-yinglipjunzhi/kuisunpjunzhi;
disp(['盈利累计：',num2str(yinglileiji),'    亏损累计：',num2str(kuisunleiji),...
    '    总盈利/总亏损：',num2str(zongylibikuisun),'    平均盈利/平均亏损：',num2str(pjunylibipjunkuisun)]);
%平均持仓周期
pjunchicangzhouqi=(dategtong(end)-dategtong(1))/jiaoyicishu;
%最长持仓周期
kaicangriqi=dategtong(xinhao3);
%持仓周期
%思考：持仓周期分布
chicangzhouqi=[0;diff(kaicangriqi)];
%最长持仓周期
zuichangchicangzhouqi=max(chicangzhouqi);
%平均盈利周期
pjunylichicangzhouqi=mean(chicangzhouqi(kaicangyingkui>0));
%平均亏损周期
pjunkuisunchicangzhouqi=mean(chicangzhouqi(kaicangyingkui<0));
disp(['平均持仓天数：',num2str(pjunchicangzhouqi),'    最长持仓天数：',num2str(zuichangchicangzhouqi),...
    '    平均盈利持仓时间：',num2str(pjunylichicangzhouqi),'    平均亏损持仓时间：',num2str(pjunkuisunchicangzhouqi)]);
%模型性能评价,利润，风险（不仅关注最大亏损，也关注亏损分布、亏损的标准差），稳定性，适用性
%标准离差率,衡量风险承受
biaozhunlichalv=std(kaicangyingkui)/pingjunyli;
%凯利指数
kellyzhishu=yinglibili-(1-yinglibili)/pjunylibipjunkuisun;
%悲观利润率
beiguanlirunlv=-((yinglicishu-yinglicishu^0.5)*yinglipjunzhi)/((kuisuncishu-kuisuncishu^0.5)*kuisunpjunzhi);
%保守利润指数
lirunzhishubaoshou=-(yinglileiji-zuidayingli*2)/(kuisunleiji+zuidakuisun*2);
%循环比>0.7
xunhuanbi=-yinglipjunzhi/kuisunpjunzhi-kuisuncishu/yinglicishu;
disp(['标准离差率：',num2str(biaozhunlichalv),'    凯利指数：',num2str(kellyzhishu),'    循环比：',num2str(xunhuanbi),...
    '    悲观利润率（大于2好，大于2.5优秀）：',num2str(beiguanlirunlv),'    保守利润指数：',num2str(lirunzhishubaoshou)]);
%%
%结果输出，两类结果，1.每天结果。2.每次平仓结果
%  plot(zuizhongcangwei);
%  plot(meirijiesuanykui);
zijin=kaicangzijin;
kaishiriqi=datestr(dategtong(1),j);
jiesuriqi=datestr(dategtong(end),j);
nianjunshouyilv=(zijin(end)/zijin(1))^(365/(dategtong(end)-dategtong(1)))-1;  %年度回报
dategtongg=datekaicang;    %这一句是关键！！！！！
zijin(end);

%资金曲线
% semilogy(datekaicang,zijin)
%figure
% plot(datekaicang,zijin)
% grid on
% dateaxis('x',12)
[huichezijin,i1,i2]=maxdown(zijin);
datestr(dategtongg(i1),j);
datestr(dategtongg(i2),j);


disp(['按每次完整交易，   最大资金回撤：',num2str(huichezijin),...
    '    开始于：',datestr(dategtongg(i1),j),'    结束于：',datestr(dategtongg(i2),j)]);

[huichebili,ind11,ind22]=maxdownrate(zijin);
datestr(dategtongg(ind11),j);
datestr(dategtongg(ind22),j);
%年度复合回报/最大回撤>8
huibaobihuiche=-nianjunshouyilv/huichebili;
disp(['最大资金回撤比例：',num2str(huichebili),'    开始于：',datestr(dategtongg(ind11),j),...
    '    结束于：',datestr(dategtongg(ind22),j),'    年度复合回报/最大回撤比例:',num2str(huibaobihuiche)]);

[huicheshijian,shijian1,shijian2]=maxdowntime(zijin);
datestr(dategtongg(shijian1),j);
datestr(dategtongg(shijian2),j);
jiangetianshu=dategtongg(shijian2)-dategtongg(shijian1);

disp(['最长资金恢复时间(交易次数)：',num2str(huicheshijian),'    开始于：',datestr(dategtongg(shijian1),j),...
    '    结束于：',datestr(dategtongg(shijian2),j),'    间隔天数:',num2str(jiangetianshu)]);
% 返回收益风险比
rewards = huibaobihuiche;
%%
%数据输出
%每日数据输出

%  [aa,bb]=xlswrite('螺纹焦炭每日交易情况输出0',[duiyingriqi,xianhuo,xianhuo2,zuizhongcangwei,qihuo,meirijiesuanykui,meirizijin]);
% %每次交易数据输出
% [aa,bb]=xlswrite('每次完整交易情况输出',[juzhengshuju,jijiexingxushu,jijiexingxushupjunzhi02]);
end