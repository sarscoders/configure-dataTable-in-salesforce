@isTest
public class ConfigurableDatatable_Test {
    @isTest
    public static void method(){
        ConfigurableDatatable.getObjectList();
        ConfigurableDatatable.getallFields('Account');
        ConfigurableDatatable.configuratonsave('Account', 'Id,Name');
        ConfigurableDatatable.getResult();
        ConfigurableDatatable.getLabels();
    }
    @IsTest
    public static void CreateUpdateMetadataUtilsTest(){
        
        CreateUpdateMetadata metadata = new CreateUpdateMetadata();
        Test.startTest();
        metadata.handleResult(new Metadata.DeployResult(), new Metadata.DeployCallbackContext());
        Test.stopTest();
    }
}