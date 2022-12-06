figure('visible','on','position',[350,200,800,550]); 
y=[0.059;0.062;0.246;0.293;0.248;0.261;0.431;0.644];

b=bar(y,0.3);
grid on;
ch = get(b,'children');

set(gca,'XTickLabel',{'LApredict','Yan et al.','Deeper','DeepJIT','CC2Vec','JITLine','JIT-Fine','MOJ\_SDP'})
for i=1:8
    text(i,y(i)+0.03,num2str(y(i)),'VerticalAlignment','bottom','HorizontalAlignment','center');
end
set(ch,'FaceVertexCData',[1 0 1;0 0 0;])

ylabel('F1');