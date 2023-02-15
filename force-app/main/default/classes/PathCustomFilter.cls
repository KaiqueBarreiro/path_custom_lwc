/**
 * @author kaique.barreiro 
 */
public with sharing class PathCustomFilter {
    
    public Map<String, String> indexMessageHoverByStatus ( List<PathCustom__mdt> pathCustoms ) {

        Map<String, String> messageByStatus = new Map<String, String>();

        for ( PathCustom__mdt pathCustom : pathCustoms ) {

            messageByStatus.put ( pathCustom.MasterLabel, pathCustom.MessageHover__c );

        }
        
        return messageByStatus;

    }

    public Map<String, List<String>> indexFieldsByStatus ( List<PathCustom__mdt> pathCustoms ) {

        Map<String, List<String>> fieldsByStatus = new Map<String, List<String>>();

        for ( PathCustom__mdt pathCustom : pathCustoms ) {

            if ( String.isBlank( pathCustom.Fields__c ) ) continue;

            List<String> fields = pathCustom.Fields__c.split(',');

            fieldsByStatus.put ( pathCustom.MasterLabel, fields );

        }

        return fieldsByStatus;

    }

    public Map<String, String> indexGuidanceByStatus ( List<PathCustom__mdt> pathCustoms ) {

        Map<String, String> guidanceByStatus = new Map<String, String>();

        for ( PathCustom__mdt pathCustom : pathCustoms ) {

            guidanceByStatus.put ( pathCustom.MasterLabel, pathCustom.Guidance__c );

        }

        return guidanceByStatus;

    }

}