/**
 * @author kaique.barreiro
 */
@isTest
public with sharing class PathCustomControllerTest {
    
    @IsTest
    static void giveASobjectNameThenGetHoverByStatus () {
        
        String payload = '[{"attributes":{"type":"PathCustom__mdt","url":"/services/data/v56.0/sobjects/PathCustom__mdt/m007g00000063ZQAAY"},"MasterLabel":"Qualified","Guidance__c":"<ul>\r\n<li>BANT established and next steps agreed upon to move forward</li>\r\n<li>Qualifying a lead logs it is an Open Opportunity with 5% chance of closing</li>\r\n</ul>","Fields__c":"Company,Title,LeadSource,Industry","MessageHover__c":"Prospect meets the criteria to move them forward to opportunity","Id":"m007g00000063ZQAAY"},{"attributes":{"type":"PathCustom__mdt","url":"/services/data/v56.0/sobjects/PathCustom__mdt/m007g00000063ZpAAI"},"MasterLabel":"Disqualified","Guidance__c":"<ul>\r\n<li>Clear understanding as to why we are unlikely a good fit and/or do not meet qualifying criteria</li>\r\n</ul>","Fields__c":"Company,Title,LeadSource,Industry","MessageHover__c":"Prospect is not a qualified lead","Id":"m007g00000063ZpAAI"}]';

        Test.startTest();
        
        PathCustomController.setPathCustomRepository ( new PathCustomRepositoryTest.PathCustomRepositoryMock( payload ) );

        Map<String, String> messageHoverByStatus = PathCustomController.getMessageByStatus ( 'Lead' );

        Test.stopTest();
        
        System.assert ( messageHoverByStatus.get( 'Qualified' ) == 'Prospect meets the criteria to move them forward to opportunity' );
        System.assert ( messageHoverByStatus.get( 'Disqualified' ) == 'Prospect is not a qualified lead' );

    }

    @IsTest
    static void giveASobjectNameThenGetFieldsByStatus () {
        
        String payload = '[{"attributes":{"type":"PathCustom__mdt","url":"/services/data/v56.0/sobjects/PathCustom__mdt/m007g00000063ZQAAY"},"MasterLabel":"Qualified","Guidance__c":"<ul>\r\n<li>BANT established and next steps agreed upon to move forward</li>\r\n<li>Qualifying a lead logs it is an Open Opportunity with 5% chance of closing</li>\r\n</ul>","Fields__c":"Company,Title,LeadSource,Industry","MessageHover__c":"Prospect meets the criteria to move them forward to opportunity","Id":"m007g00000063ZQAAY"},{"attributes":{"type":"PathCustom__mdt","url":"/services/data/v56.0/sobjects/PathCustom__mdt/m007g00000063ZpAAI"},"MasterLabel":"Disqualified","Guidance__c":"<ul>\r\n<li>Clear understanding as to why we are unlikely a good fit and/or do not meet qualifying criteria</li>\r\n</ul>","Fields__c":"Company,Title,LeadSource,Industry","MessageHover__c":"Prospect is not a qualified lead","Id":"m007g00000063ZpAAI"}]';

        Test.startTest();
        
        PathCustomController.setPathCustomRepository ( new PathCustomRepositoryTest.PathCustomRepositoryMock( payload ) );

        Map<String, List<String>> fieldsByStatus = PathCustomController.getFieldsByStatus ( 'Lead' );

        Test.stopTest();
        
        System.assert ( fieldsByStatus.get( 'Qualified' ).size() == 4 );
        System.assert ( fieldsByStatus.get( 'Disqualified' ).size() == 4 );
        
    }

    @IsTest
    static void giveASobjectNameThenGetGuidanceByStatus () {
        
        String payload = '[{"attributes":{"type":"PathCustom__mdt","url":"/services/data/v56.0/sobjects/PathCustom__mdt/m007g00000063ZQAAY"},"MasterLabel":"Qualified","Guidance__c":"<ul>\r\n<li>BANT established and next steps agreed upon to move forward</li>\r\n<li>Qualifying a lead logs it is an Open Opportunity with 5% chance of closing</li>\r\n</ul>","Fields__c":"Company,Title,LeadSource,Industry","MessageHover__c":"Prospect meets the criteria to move them forward to opportunity","Id":"m007g00000063ZQAAY"},{"attributes":{"type":"PathCustom__mdt","url":"/services/data/v56.0/sobjects/PathCustom__mdt/m007g00000063ZpAAI"},"MasterLabel":"Disqualified","Guidance__c":"<ul>\r\n<li>Clear understanding as to why we are unlikely a good fit and/or do not meet qualifying criteria</li>\r\n</ul>","Fields__c":"Company,Title,LeadSource,Industry","MessageHover__c":"Prospect is not a qualified lead","Id":"m007g00000063ZpAAI"}]';

        Test.startTest();
        
        PathCustomController.setPathCustomRepository ( new PathCustomRepositoryTest.PathCustomRepositoryMock( payload ) );

        Map<String, String> guidanceByStatus = PathCustomController.getGuidanceByStatus ( 'Lead' );

        Test.stopTest();
        
        System.assert ( guidanceByStatus.get( 'Qualified' ).contains( 'BANT established and next steps agreed upon to move forward' ) );
        System.assert ( guidanceByStatus.get( 'Disqualified' ).contains( 'Clear understanding as to why we are unlikely a good fit and/or do not meet qualifying criteria' ) );
        
    }

}