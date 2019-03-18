order = 5;
degree = order-1;
knots = 0:9;
t = linspace(min(knots),max(knots),1000);
N = zeros(length(knots)-1,length(t),order+1);

for k=0:degree,
    for i=1:length(knots)-k-1,
        if k==0,
            N(i,:,k+1) = t>=knots(i) & t<knots(i+1);
        else
            w0 = (t - knots(i)) ./ (knots(i+k)-knots(i));
            w1 = (t - knots(i+1)) ./ (knots(i+k+1)-knots(i+1));
            N(i,:,k+1) = w0.*N(i,:,k) + (1-w1).*N(i+1,:,k);
        end
    end
end

figure(gcf); clf; hold on;
axis on; grid on; axis equal;
count = 5;

for k=1:degree,
    axis([-.1 .1 -.1 .1]+[0 5+degree 0 1]);
    idx = t <= 5+k;
    x = repmat(t(idx),count,1)';
    y = N(1:count,idx,k+1)';
    cla;
    plot(x,y,'-','LineWidth',2,'Color',[117 197 240]/255);
    pause;
    print(gcf,['/home/bbrrck/teaching/geonum/2017/TD/degree' num2str(k) '.svg'],'-dsvg');
end

