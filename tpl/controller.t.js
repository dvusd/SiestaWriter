StartTest(function(t) {
    var Ext = t.getExt(),
        cls = '${class}';
    
    t.chainDone(
        { action:'run', fn:'waitForAppLaunch', args:[{ controllers:[cls] }] },
        { action:'run', fn:'validateControllerAndThen', args:[cls] },
        { action:'run', fn:'waitForAppDestroy' }
    );
});