%%  ��ȡwind����
%�Կ�ʯΪ����ȡ�����Լ��Сʱ����
%%

clear
clc
%%
w=windmatlab  %�������
% w.menu   %��ʾ�˵�
% x=isconnected(w);%���ж�wind ����w �Ƿ��Ѿ���½�ɹ���

%%   ��ȡ����
%��ȡ���� ����10��Լ  ����
kaishinianfs=2015;
jiesunianff=2021;
nfencha=1+jiesunianff-kaishinianfs;%���һ�����һ��֮��
kaishiy=kaishinianfs-2000-1;%��������ʼ���-1
rb10m30=[];
zhouqi='BarSize=30';
%% Ʒ��
pinzhong='RB';  %Ʒ���ַ���
heyue=''; %��Լ�ַ���
jiaoyisuo='.SHF';     %�������ַ���  ������DCE  ֣����CZC �Ͻ���SHF  �н���CFE
%% ��ʼʱ�� ����ʱ��
if isempty(heyue)
    disp([pinzhong,jiaoyisuo, ' ������Լ']);
    heyueshuzi='';
    yuefenk='-01';
    yuefenf='-12';
else
    heyueshuzi=str2num(heyue);
    switch  heyueshuzi    % ȷ����Լ���ݿ�ʼ�������·�
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
            disp('��Լ�·ݴ���');
    end
end
%ȷ����ݡ����ڡ�ʱ��
nianfenk=kaishinianfs-2;  riqik='-01'; shijk=' 09:00:00'; %01��Լ��ʼ�·�02��  05��Լ 06 ��10��Լ 11�� 09��Լ 10    yuefenk='-11';
nianfenf=nianfenk+1;  riqif='-30'; shijf=' 15:00:00'; %01��Լ�����·�12��  05��Լ 04 ��10��Լ 09�� 09��Լ 08    yuefenf='-09';
%%
for fyear=1:nfencha 
   niandu=kaishiy+fyear;
   nianduzifuchuan=num2str(niandu); 
   if isempty(heyue)
        jutiheyue=[pinzhong,jiaoyisuo];%�����Լ�ַ���
   else
       jutiheyue=[pinzhong,nianduzifuchuan,heyue,jiaoyisuo];%�����Լ�ַ���
   end
   
   nfk=nianfenk+fyear; 
   starttime=[num2str(nfk),yuefenk,riqik,shijk];%��ʼʱ��
   
   nfj=nianfenf+fyear; 
   finishtime=[num2str(nfj),yuefenf,riqif,shijf];%����ʱ��
   if datenum(starttime)>now
       disp('����Լ���ݻ�û��ʼ');
       break
   elseif datenum(finishtime)>now
       finishtime=now;
   end
   
    [w_wsi_data,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid]=...
    w.wsi(jutiheyue,'open,high,low,close',starttime,finishtime,zhouqi);

    if w_wsi_errorid==0
      dangxiaheyueshuju=[w_wsi_times,w_wsi_data];
      rb10m30=[rb10m30;dangxiaheyueshuju];
      disp([jutiheyue,'��Լ���ݻ�ȡ�ɹ�[', starttime, ' - ',finishtime, ']']);
    else
        disp([jutiheyue,'��Լ���ݻ�ȡʧ��[', starttime, ' - ',finishtime, ']']);
    end
end
%%  ����������
a1='����';a3='��Լ';a5='�߿�����';biaotizifuchuan=[a1,pinzhong,heyue,zhouqi,a5];
b1=rb10m30(:,1)-693960;  rb10m30=[b1,rb10m30(:,2:end)];  % matlab��excel����ת��
[aa,bb]=xlswrite(biaotizifuchuan,rb10m30);
% tday10=cellstr(tday10);
% qixian10=fts2ascii('10��Լ��������.txt',fints(tday10,[xianhuo0010,qihuo0010,chicangliang10,cjiaoliang10,...
%     qixianjiacha10,jiangetianshu10,gudingcben10,biandongchengben10,zengzhishui10,zongchengben10,jiaogelirun10],...
%     {'beijingxianhuo','qihuo10','chicangliang','chengjiaoliang','jiacha','jiangetianshu','gudingchengben',...
%     'biandongchengben','zengzhishui','zongchengben','jiaogelirun'}));
