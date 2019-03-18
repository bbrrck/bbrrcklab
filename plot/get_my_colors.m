function color = get_my_colors

rgb = @(r,g,b) [r,g,b] ./ 255;

color.Red      = rgb( 255,  68,  56 );
color.Orange   = rgb( 255, 163,   0 );
color.Blue     = rgb(  56, 168, 255 );
color.Green    = rgb(   2, 204,  91 );
color.Magenta  = rgb( 155,   0, 255 );
color.White    = rgb( 255, 255, 255 );
color.Gray     = @(x) x*ones(1,3);

matlab_default_colors = [
    0.0000    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
];

color.Palette = @(k) matlab_default_colors(mod(k-1,size(matlab_default_colors,1))+1,:);

% https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
palette20 = [
  rgb(230,  25,  75)  % Red	#e6194b	(230, 25, 75)	(0, 100, 66, 0)
  rgb( 60, 180,  75)  % Green	#3cb44b	(60, 180, 75)	(75, 0, 100, 0)
  rgb(255, 225,  25)  % Yellow	#ffe119	(255, 225, 25)	(0, 25, 95, 0)
  rgb(  0, 130, 200)  % Blue	#0082c8	(0, 130, 200)	(100, 35, 0, 0)
  rgb(245, 130,  48)  % Orange	#f58231	(245, 130, 48)	(0, 60, 92, 0)
  rgb(145,  30, 180)  % Purple	#911eb4	(145, 30, 180)	(35, 70, 0, 0)
  rgb( 70, 240, 240)  % Cyan	#46f0f0	(70, 240, 240)	(70, 0, 0, 0)
  rgb(240,  50, 230)  % Magenta	#f032e6	(240, 50, 230)	(0, 100, 0, 0)
  rgb(210, 245,  60)  % Lime	#d2f53c	(210, 245, 60)	(35, 0, 100, 0)
  rgb(250, 190, 190)  % Pink	#fabebe	(250, 190, 190)	(0, 30, 15, 0)
  rgb(  0, 128, 128)	% Teal	#008080	(0, 128, 128)	(100, 0, 0, 50)
  rgb(230, 190, 255)  % Lavender	#e6beff	(230, 190, 255)	(10, 25, 0, 0)
  rgb(170, 110,  40)  % Brown	#aa6e28	(170, 110, 40)	(0, 35, 75, 33)
  rgb(255, 250, 200)  % Beige	#fffac8	(255, 250, 200)	(5, 10, 30, 0)
  rgb(128,   0,   0)	% Maroon	#800000	(128, 0, 0)	(0, 100, 100, 50)
  rgb(170, 255, 195)  % Mint	#aaffc3	(170, 255, 195)	(33, 0, 23, 0)
  rgb(128, 128,   0)	% Olive	#808000	(128, 128, 0)	(0, 0, 100, 50)
  rgb(255, 215, 180)  % Coral	#ffd8b1	(255, 215, 180)	(0, 15, 30, 0)
  rgb(  0,   0, 128)  % Navy	#000080	(0, 0, 128)	(100, 100, 0, 50)
  rgb(128, 128, 128)  % Grey	#808080	(128, 128, 128)	(0, 0, 0, 50)
  ... % rgb(255, 255, 255)  % White	#FFFFFF	(255, 255, 255)	(0, 0, 0, 0)
  rgb(  0,   0,   0)  % Black	#000000	(0, 0, 0)	(0, 0, 0, 100)
];
color.Palette20 = @(k) palette20(mod(k-1,size(palette20,1))+1,:);