function [HR_24,HR_48,FAR_24,FAR_48,tab24,tab48]=HR_FAR_um(X)

t1=1;
t2=2;
t3=3;
t4=5;
t5=10;
t6=13;
t7=15;
t8=20;
t9=30;

[obs_1,forec24_1,forec48_1]=trans_bin(X,t1);% trans_bin busca coincidencias 
%en la sentencia, por ejemplo busque todos los dias que tengan precipitacion 
%mayor a 1 mm en los datos reales, en el pronostico a 24 horas y a 48  hrs,
%ponge unos en estas posiciones y en las demás pone ceros.
[hr1_24,far1_24,ll1_24,tab1_24]=roc(obs_1,forec24_1);
%ingresa el dato observado y el pronostico a 24 horas (en ceros y unos) y
%obtiene el hit rate, false alarm rate, la tabla de contingencia y el
%likelihood ratio para el evento "Precipitacion mayor a 1mm" (lo mismo para 
%demas eventos 2,3,5,10,13,15,20 y 30 mm)
[hr1_48,far1_48,ll1_48,tab1_48]=roc(obs_1,forec48_1);
%Se repite el procedimiento anterior para el pronostico a 48 horas.

[obs_2,forec24_2,forec48_2]=trans_bin(X,t2);
[hr2_24,far2_24,ll2_24,tab2_24]=roc(obs_2,forec24_2);
[hr2_48,far2_48,ll2_48,tab2_48]=roc(obs_2,forec48_2);

[obs_3,forec24_3,forec48_3]=trans_bin(X,t3);
[hr3_24,far3_24,ll3_24,tab3_24]=roc(obs_3,forec24_3);
[hr3_48,far3_48,ll3_48,tab3_48]=roc(obs_3,forec48_3);

[obs_4,forec24_4,forec48_4]=trans_bin(X,t4);
[hr4_24,far4_24,ll4_24,tab4_24]=roc(obs_4,forec24_4);
[hr4_48,far4_48,ll4_48,tab4_48]=roc(obs_4,forec48_4);


[obs_5,forec24_5,forec48_5]=trans_bin(X,t5);
[hr5_24,far5_24,ll5_24,tab5_24]=roc(obs_5,forec24_5);
[hr5_48,far5_48,ll5_48,tab5_48]=roc(obs_5,forec48_5);

[obs_6,forec24_6,forec48_6]=trans_bin(X,t6);
[hr6_24,far6_24,ll6_24,tab6_24]=roc(obs_6,forec24_6);
[hr6_48,far6_48,ll6_48,tab6_48]=roc(obs_6,forec48_6);

[obs_7,forec24_7,forec48_7]=trans_bin(X,t7);
[hr7_24,far7_24,ll7_24,tab7_24]=roc(obs_7,forec24_7);
[hr7_48,far7_48,ll7_48,tab7_48]=roc(obs_7,forec48_7);

[obs_8,forec24_8,forec48_8]=trans_bin(X,t8);
[hr8_24,far8_24,ll8_24,tab8_24]=roc(obs_8,forec24_8);
[hr8_48,far8_48,ll8_48,tab8_48]=roc(obs_8,forec48_8);

[obs_9,forec24_9,forec48_9]=trans_bin(X,t9);
[hr9_24,far9_24,ll9_24,tab9_24]=roc(obs_9,forec24_9);
[hr9_48,far9_48,ll9_48,tab9_48]=roc(obs_9,forec48_9);

HR_24=[hr1_24;hr2_24;hr3_24;hr4_24;hr5_24;hr6_24;hr7_24;hr8_24;hr9_24];
FAR_24=[far1_24;far2_24;far3_24;far4_24;far5_24;far6_24;far7_24;far8_24;far9_24];

HR_48=[hr1_48;hr2_48;hr3_48;hr4_48;hr5_48;hr6_48;hr7_48;hr8_48;hr9_48];
FAR_48=[far1_48;far2_48;far3_48;far4_48;far5_48;far6_48;far7_48;far8_48;far9_48];

tab24=[tab1_24 tab2_24 tab2_48 tab3_24 tab4_24 tab5_24 tab6_24 tab7_24 tab8_24 tab9_24];


tab48=[tab1_48 tab2_48 tab2_48 tab3_48 tab4_48 tab5_48 tab6_48 tab7_48 tab8_48 tab9_48];

umbrales=[1;2;3;5;10;13;15;20;30];
figure
plot(FAR_24-0.005,HR_24,'-o'),hold on,grid minor
legend('24 horas')
hh=plot(FAR_24,HR_24,'.')
set(hh,'MarkerSize',1)
for i=1:9
 aaa=num2str(round(umbrales(i)))
 hh=text(FAR_24(i),HR_24(i),num2str(aaa))
 set(hh,'FontSize',10)
end
hold on
plot(FAR_48-0.005,HR_48,'-or'),hold on
hh=plot(FAR_48,HR_48,'.')
set(hh,'MarkerSize',1)
for i=1:9
 aaa=num2str(round(umbrales(i)))
 hh=text(FAR_48(i),HR_48(i),num2str(aaa))
 set(hh,'FontSize',10)
end
hold off
xlabel('False Alarm Rate')
ylabel('Hit Rate')
title('Relative Operating Characteristic')
axis([0 0.5 0 0.5])
line([0 0.5],[0 0.5])
legend('24 horas','','48 horas')


