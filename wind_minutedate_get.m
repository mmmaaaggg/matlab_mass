%%  获取wind数据
%以矿石为例获取历年合约半小时数据
%%

clear
clc
%%
w=windmatlab  %建立句柄
% w.menu   %显示菜单
% x=isconnected(w);%即判断wind 对象w 是否已经登陆成功。

%%   获取数据
%获取历年 螺纹10合约  数据
kaishinianfs=2015;
jiesunianff=2021;
nfencha=1+jiesunianff-kaishinianfs;%最后一年与第一年之差
kaishiy=kaishinianfs-2000-1;%比真正开始年份-1
rb10m30=[];
zhouqi='BarSize=30';
%% 品种
pinzhong='RB';  %品种字符串
heyue=''; %合约字符串
jiaoyisuo='.SHF';     %交易所字符串  大商所DCE  郑商所CZC 上交所SHF  中金所CFE
%% 开始时间 结束时间
if isempty(heyue)
    disp([pinzhong,jiaoyisuo, ' 连续合约']);
    heyueshuzi='';
    yuefenk='-01';
    yuefenf='-12';
else
    heyueshuzi=str2num(heyue);
    switch  heyueshuzi    % 确定合约数据开始、结束月份
        case 1
            yuefenk='-02';
            yuefenf='-12';
        case 5
            yuefenk='-06';
            yuefenf='-04';
        case 9
            yuefenk='-10';
            yuefenf='-08';
        case 10
            yuefenk='-11';
            yuefenf='-09';
        otherwise
            disp('合约月份错误');
    end
end
%确定年份、日期、时间
nianfenk=kaishinianfs-2;  riqik='-01'; shijk=' 09:00:00'; %01合约开始月份02；  05合约 06 ；10合约 11； 09合约 10    yuefenk='-11';
nianfenf=nianfenk+1;  riqif='-30'; shijf=' 15:00:00'; %01合约结束月份12；  05合约 04 ；10合约 09； 09合约 08    yuefenf='-09';
%%
for fyear=1:nfencha 
   niandu=kaishiy+fyear;
   nianduzifuchuan=num2str(niandu); 
   if isempty(heyue)
        jutiheyue=[pinzhong,jiaoyisuo];%具体合约字符串
   else
       jutiheyue=[pinzhong,nianduzifuchuan,heyue,jiaoyisuo];%具体合约字符串
   end
   
   nfk=nianfenk+fyear; 
   starttime=[num2str(nfk),yuefenk,riqik,shijk];%开始时间
   
   nfj=nianfenf+fyear; 
   finishtime=[num2str(nfj),yuefenf,riqif,shijf];%结束时间
   if datenum(starttime)>now
       disp('本合约数据还没开始');
       break
   elseif datenum(finishtime)>now
       finishtime=now;
   end
   
    [w_wsi_data,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid]=...
    w.wsi(jutiheyue,'open,high,low,close',starttime,finishtime,zhouqi);

    if w_wsi_errorid==0
      dangxiaheyueshuju=[w_wsi_times,w_wsi_data];
      rb10m30=[rb10m30;dangxiaheyueshuju];
      disp([jutiheyue,'合约数据获取成功[', starttime, ' - ',finishtime, ']']);
    else
        disp([jutiheyue,'合约数据获取失败[', starttime, ' - ',finishtime, ']']);
    end
end
%%  结果输出保存
a1='历年';a3='合约';a5='高开低收';biaotizifuchuan=[a1,pinzhong,heyue,zhouqi,a5];
b1=rb10m30(:,1)-693960;  rb10m30=[b1,rb10m30(:,2:end)];  % matlab与excel日期转换
[aa,bb]=xlswrite(biaotizifuchuan,rb10m30);
% tday10=cellstr(tday10);
% qixian10=fts2ascii('10合约期现正套.txt',fints(tday10,[xianhuo0010,qihuo0010,chicangliang10,cjiaoliang10,...
%     qixianjiacha10,jiangetianshu10,gudingcben10,biandongchengben10,zengzhishui10,zongchengben10,jiaogelirun10],...
%     {'beijingxianhuo','qihuo10','chicangliang','chengjiaoliang','jiacha','jiangetianshu','gudingchengben',...
%     'biandongchengben','zengzhishui','zongchengben','jiaogelirun'}));
