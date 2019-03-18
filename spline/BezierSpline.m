Points = [
    0 0
    1 1
    2 2
    3 3
];

n = 3;

% Points = rand(5,2);

InnerC1 = zeros(n,2);
InnerC1(1,:) = mean(Points(1:2,:));

InnerC2 = zeros(2*n,2);
InnerC2(1:2,:) = [0.33*sum(Points(1:2,:)); 0.66*sum(Points(1:2,:))];

for i=2:n,
    InnerC1(i,:) = 2*Points(i,:) - InnerC1(i-1,:);
    
    i0
    InnerC2(2*i-1,:) = 2*Points(i,:) - InnerC2(2*(i-1),:);
    InnerC2(2*i  ,:) = InnerC2(2*(i-1)-1,:) - 2*InnerC2(2*(i-1),:) - 2*InnerC2(2*i-1,:);
end

samples = 20;
t = linspace(0,1,samples);

figure(gcf); clf;

subplot(1,2,1); cla; hold on;
Plot3Vertex(Points,'b');
Plot3Vertex(InnerC1,'r');

for c=1:n,

    CP = [Points(c,:); InnerC1(c,:); Points(c+1,:)];
    P = zeros(samples,2);
    for i=1:samples,
        P(i,:) = Casteljau1d(0,2,t(i),CP);
    end
    
    Plot3Curve(P,0,rand(1,3));
    
end

subplot(1,2,2); cla; hold on;
Plot3Vertex(Points,'b');
Plot3Vertex(InnerC2,'g');

for c=1:n,

    CP = [Points(c,:); InnerC2(2*c-1:2*c,:); Points(c+1,:)];
    P = zeros(samples,2);
    for i=1:samples,
        P(i,:) = Casteljau1d(0,3,t(i),CP);
    end
    
    Plot3Curve(P,0,rand(1,3));
    
end



