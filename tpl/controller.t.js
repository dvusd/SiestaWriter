StartTest(function(t) {
    var cls = '${class}';
    
    t.chainDone(
        { action:'run', fn:'waitForAppLaunch', args:[{ controllers:[cls] }] },
        { action:'run', fn:'validateControllerAndThen', args:[cls] },
        { action:'run', fn:'waitForAppDestroy' }
    );
});