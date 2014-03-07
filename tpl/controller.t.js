StartTest(function(t) {
    var cls = '${class}';
    
    t.chainDone(
        'waitForAppLaunch({ "controllers":["'+cls+'"] })',
        'validateControllerAndThen("'+cls+'")',
        'waitForAppDestroy()'
    );
});