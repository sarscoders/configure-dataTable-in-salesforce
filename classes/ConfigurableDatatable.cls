public class ConfigurableDatatable {
    @AuraEnabled
    public static List<String> getObjectList() { 
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();    
        List<String> lisOfObjects = new List<String>();
        for(Schema.SObjectType f : gd.values()){
            Schema.DescribeSObjectResult  anObject = f.getDescribe();
            if (anObject.isAccessible() && anObject.isCreateable() && anObject.isUpdateable() && anObject.getKeyPrefix() != null) {
                lisOfObjects.add(String.valueOf(f));
            }
        }
        lisOfObjects.sort();
        return lisOfObjects;
    }
    @AuraEnabled
    public static List<String> getallFields(String seletedObject) { 
        List<String> referenceFields = new List<String>();
        
        Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult[] genericObj = Schema.describeSObjects(new String[]{seletedObject});
        Schema.SObjectType obj = genericObj[0].getSObjectType();
        Schema.SObjectType objectType = schemaMap.get(String.valueOf(obj));
        Schema.DescribeSObjectResult objDescribe = objectType.getDescribe();
        
        for(Schema.SObjectField fieldName : objDescribe.fields.getMap().values()) {
            if(fieldName.getDescribe().getType() != DisplayType.Reference) {
                referenceFields.add(String.valueOf(fieldName));       
            }			         
        }
        return referenceFields;
    }
    @AuraEnabled
    public static void configuratonsave(String obj, String FieldsData){
        Map<String, Object> mapTestData = new Map<String, Object>();
        mapTestData.put('object_Name__c',obj);
        mapTestData.put('Fields__c',FieldsData);
        
        CreateUpdateMetadata.createUpdateMetadata ('Configurable_Data_table.Data_Table', 'Data_Table', mapTestData);
    }
    @AuraEnabled
    public static List<sObject> getResult(){
        Configurable_Data_table__mdt dt = Configurable_Data_table__mdt.getInstance('Data_Table');
        String query =  'SELECT '+dt.Fields__c+' FROM '+dt.object_Name__c;
        List<sObject> resultList = database.query(query);
        return resultList;
    }
    @AuraEnabled
    public static List<fieldWrapper> getLabels(){
        List<fieldWrapper> wrapperlist = new List<fieldWrapper>();
        
        Configurable_Data_table__mdt dt = Configurable_Data_table__mdt.getInstance('Data_Table');
        Map<Schema.DisplayType,string> dataTypeMap = new Map<Schema.DisplayType,string>{ Schema.DisplayType.valueOf('DATETIME') => 'date-local',Schema.DisplayType.valueOf('BOOLEAN') => 'boolean',Schema.DisplayType.valueOf('PHONE') => 'email',Schema.DisplayType.valueOf('EMAIL') => 'email',Schema.DisplayType.valueOf('URL') => 'url',Schema.DisplayType.valueOf('DATE') => 'date'};
        String objectName = dt.object_Name__c;
        String[] extractLabel = dt.Fields__c.split(',');
        for(String l : extractLabel){
            fieldWrapper fwp = new fieldWrapper();
            String Label = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(l).getDescribe().getLabel();
            Schema.DisplayType dataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(l).getDescribe().getType();
            fwp.label = Label;
            fwp.ApiName = l;
            fwp.datatype = dataTypeMap.containskey(dataType) ? dataTypeMap.get(dataType) : 'text';
            wrapperlist.add(fwp);
        }
        return wrapperlist; 
    }
    public class fieldWrapper{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String ApiName{get;set;}
        @AuraEnabled
        public String datatype{get;set;}
    }
}