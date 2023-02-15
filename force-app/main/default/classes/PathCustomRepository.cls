/**
 * @author kaique.barreiro 
 */
public virtual class PathCustomRepository {

    public PathCustomRepository() {

    }

    virtual
    public List<PathCustom__mdt> findBySObject ( String sobjectName ) {

        List<PathCustom__mdt> pathCustoms = [SELECT MasterLabel, Guidance__c, Fields__c, MessageHover__c FROM PathCustom__mdt WHERE SObject__c = :sobjectName];

        return pathCustoms;

    }

}