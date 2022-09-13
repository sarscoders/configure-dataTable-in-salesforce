({
    doInit : function(component, event, helper) {
        helper.getLabel(component, event, helper);
        var action = component.get("c.getResult");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set('v.data',response.getReturnValue());
                
            }            
            else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
    
})