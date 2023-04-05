T = pcryReadTable('../../data/20210803_091919_01.csv','fiji');
myFunc = @(x) sin(x);
Anim = pcryAnimator('video.avi',myFunc)