StartTest(function(t){
    var Ext = t.getExt(),
        cls = '${class}';

    t.createModelAndThen(cls,function(model){
        t.loadModelAndThen(model,function(model){
            t.validateModelAndThen(model,function(model){
                t.done();
            });
        });
    });
});