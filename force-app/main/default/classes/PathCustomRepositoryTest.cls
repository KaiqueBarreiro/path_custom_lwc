/**
 * @author kaique.barreiro
 */
@isTest
public with sharing class PathCustomRepositoryTest {
    
    @IsTest
    static void giveASObjectNameThenFindMetadataCustoms () {
        
        Test.startTest();
        
        List<PathCustom__mdt> pathCustoms = new PathCustomRepository().findBySObject ( 'Lead' );

        Test.stopTest();
        
        System.assert ( pathCustoms != null );
        System.assert ( pathCustoms.size() > 0 );

    }
    
    public class PathCustomRepositoryMock extends PathCustomRepository {

        String payload;

        public PathCustomRepositoryMock ( String payload ) {
            this.payload = payload;
        }

        override
        public List<PathCustom__mdt> findBySObject ( String sobjectName ) {
            return (List<PathCustom__mdt>) JSON.deserialize( payload.replaceAll('\n','').replaceAll('\r',''), List<PathCustom__mdt>.class );
        }

    }

}