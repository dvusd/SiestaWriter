StartTest(function(t) {
    var cls = '${class}';
    
    t.chainDone(
        // do not pass the view controller to the app
        'waitForAppLaunch({ "controllers":[] })',
        'validateControllerAndThen("'+cls+'")',
        'waitForAppDestroy()'
    );
});