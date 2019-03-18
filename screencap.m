v = VideoWriter('export.avi','Motion JPEG AVI');
v.FrameRate = 12;
open(v);
figure(99);
[az,el] = view();
for i = 1:2:360,
    disp(i)
    view(az+i,el)
    f = getframe(gcf);
    writeVideo(v,f);
end
close(v);
fprintf('done.\n');