pt=cd;
cd('C:\Users\granata\Desktop\PropDesign\PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\OPT');
[~,~]=dos('r');
copyfile('PROP_DESIGN_MAPS_INPUT.txt','../MAPS_ALT/');
cd('../MAPS_ALT/');
movefile('PROP_DESIGN_MAPS_INPUT.txt','../MAPS_ALT/PROP_DESIGN_MAPS_INPUT_ONE.txt');
cd(pt); % back to original