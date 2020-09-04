%%突破进场,价格创20日新高进场。特别注意：返回n*1向量，如何对接？？
function [rr,r]=pricetupo(price,days,stop,distance)  

%price指价格向量，days指周期，stop指止损幅度(百分比）,distance指突破幅度（百分比）
%返回r交易信号向量，由-1,0,1组成，代表空、无、多
%程序漏洞1：如果多头进场后，不触及止损，高位横盘整理创出20天新低，开空单么？？
%回答：不开空单、多单继续持有！
n=length(price);
r=zeros(n,1);          %交易进场信号向量
rr=zeros(n,1);         %持仓信号
%赋初值
if ~exist('days','var')
    days=20;
end

if ~exist('stop','var')
    stop=0;
end

if ~exist('distance','var')
    distance=0;
end

d=days+1;
p=price;
s=stop;
t=d;
while t<=n
    if p(t)>max(p(t-d+1:t-1))*(1+distance)       %设置突破幅度
        %回答程序漏洞1   加上&p(t)==0  貌似没必要
        %新问题2:会不会影响多翻空？t、b的循环有点问题
        r(t)=1;               
        rr(t)=r(t);
        b=1;
        M=p(t);
        while p(b+t)>M*(1-stop)          %不止损，则继续持有
              rr(b+t)=1;      
              if p(b+t)>M
                  M=p(b+t);
              end
              b=b+1;
              if b+t>n
                  return;                %此语句是否合适？
              end
        end
        t=t+b;     %这条语句能解决问题1？ 貌似while循环就解决了这个问题
    elseif p(t)<min(p(t-d+1:t-1))*(1-distance)     %空单进场
        r(t)=-1;
        rr(t)=r(t);
        b=1;
        M=p(t);
        while p(b+t)<M*(1+stop)              %不止损，则继续持有
              rr(b+t)=-1;      
              if p(b+t)<M
                  M=p(b+t);
              end
              b=b+1;
              if b+t>n
                  return;  %此语句是否合适？
              end
        end
        t=t+b;
    else
        t=t+1;%不做多，也不做空时，指针后移
    end
end