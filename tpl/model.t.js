StartTest(function(t){
    var cls = '${class}';

    t.createModelAndThen(cls,function(model){
        t.loadModelAndThen(model,function(model){
            t.validateModelAndThen(model,function(model){
                t.done();
            });
        });
    });
});