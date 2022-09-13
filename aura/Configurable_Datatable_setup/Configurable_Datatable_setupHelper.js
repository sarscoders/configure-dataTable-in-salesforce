({
    onInit : function(component,helper) {
        var action = component.get("c.getObjectList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseVar = response.getReturnValue();
                component.set("v.listOfObjects", responseVar);
            } else {
                helper.showToast(component, event, helper,'Error!!', 'error', 'Something went Wrong please try again');
            }
        });
        $A.enqueueAction(action);
        this.getFields(component);
    },
    getFields : function(component,helper) {
        var Obj = component.get("v.selectedObject");
        var action = component.get("c.getallFields");
        action.setParams({seletedObject: Obj});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                var items = [];
                for (var i = 0; i < resp.length; i++) {
                    var item = {
                        "label": resp[i],
                        "value": resp[i]
                    };
                    items.push(item);
                }
                component.set("v.listOfFields", items);
            } else {
                helper.showToast(component, event, helper,'Error!!', 'error', 'Something went Wrong please try again');
            }
        });
        $A.enqueueAction(action);
    },
    getSelectedFields : function (component,event){
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedFields",selectedOptionValue.toString());
    },
    saveConfigure : function (component,helper){
        var Obj = component.get("v.selectedObject");
        var filedsList = component.get("v.selectedFields");
        if(!$A.util.isEmpty(Obj) && !$A.util.isEmpty(filedsList)){
            var configure = component.get("c.configuratonsave");
            configure.setParams( {
                'obj': Obj, 
                'FieldsData':filedsList
            });
            configure.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.showToast(component, event, helper,'Success!!', 'success', 'Datatable configure successfully');
                } else {
                    helper.showToast(component, event, helper,'Error!!', 'error', 'Something went Wrong please try again');
                    
                }
            });
            $A.enqueueAction(configure);
        } else {
            helper.showToast(component, event, helper,'Warning!!', 'warning', '!Please select Object and atleast one Fields');
        }
    },
    showToast : function(component, event, helper, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    }
})