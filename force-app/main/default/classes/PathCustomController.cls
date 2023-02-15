/**
 * @author kaique.barreiro
 */
public with sharing class PathCustomController {
    
    private static PathCustomRepository repository;

    static {
        repository = new PathCustomRepository();
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getMessageByStatus ( String sobjectName ) {
        
        List<PathCustom__mdt> pathCustoms = repository.findBySObject ( sobjectName );
        
        return new PathCustomFilter().indexMessageHoverByStatus ( pathCustoms );

    }

    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getFieldsByStatus ( String sobjectName ) {
        
        List<PathCustom__mdt> pathCustoms = repository.findBySObject ( sobjectName );
        
        return new PathCustomFilter().indexFieldsByStatus ( pathCustoms );

    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getGuidanceByStatus ( String sobjectName ) {
        
        List<PathCustom__mdt> pathCustoms = repository.findBySObject ( sobjectName );
        
        return new PathCustomFilter().indexGuidanceByStatus ( pathCustoms );

    }

    // 4 mock
    public static void setPathCustomRepository ( PathCustomRepository pcrepository ) {
        repository = pcrepository;
    }

}