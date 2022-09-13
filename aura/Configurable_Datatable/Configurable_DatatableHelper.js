({
    getLabel : function (component, event, helper){
        var action = component.get("c.getLabels");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                var items = [];
                for (var i = 0; i < resp.length; i++) {
                    
                    var item = {
                        "label": resp[i].label,
                        "fieldName": resp[i].ApiName,
                        "type": resp[i].datatype
                    };
                    items.push(item);
                }
                component.set("v.columns", items);
            }            
            else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
        
        
    }
})